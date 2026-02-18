(in-package #:cl-user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require "sb-concurrency"))

(defvar *verbose* nil)
(defvar *quiet* nil)
(defvar *pretty* nil)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defconstant ESC (code-char 27))

  (defun resolve-sgr-code (code)
    (or (typecase code
          (integer
           code)
          (keyword
           (case code
             (:clear 0)
             (:bright 1)
             (:dim 2)
             (:reverse 7)
             (:normal 22)
             (:black 30)
             (:red 31)
             (:green 32)
             (:yellow 33)
             (:blue 34)
             (:magenta 35)
             (:cyan 36)
             (:white 37))))
        (error "Invalid SGR code: ~S" code)))

  (defun sgr (stream &rest codes)
    (format stream "~C[~{~A~^;~}m" ESC (mapcar #'resolve-sgr-code codes)))

  (define-compiler-macro sgr (&whole form stream &rest codes &environment env)
    (cond ((every (lambda (code) (constantp code env))
                  codes)
           `(format ,stream ,(apply #'sgr nil codes)))
          (t
           form)))

  (defun %paint (list pretty)
    (with-output-to-string (out)
      (labels ((rec (list)
                 (loop for x in list
                       do (cond ((consp x)
                                 (rec x)
                                 (when pretty
                                   (sgr out :clear)))
                                ((keywordp x)
                                 (when pretty
                                   (sgr out x)))
                                ((stringp x)
                                 (write-string x out))
                                (t
                                 (error "Invalid paint spec: ~S" x))))))
        (rec list))))

  (defmacro paint (&rest spec)
    `(if *pretty*
         ,(%paint spec t)
         ,(%paint spec nil))))

(defun map-tokens (function string)
  (loop with start = 0
        for pos = (position #\space string :start start)
        do (cond ((null pos)
                  (when (< start (length string))
                    (funcall function string start (length string)))
                  (return))
                 ((= pos start)
                  (incf start))
                 (t
                  (funcall function string start pos)
                  (setq start (1+ pos))))))

(defun prepare-matcher (string start end)
  (let ((pos (position #\= string :start start :end end)))
    (if pos
        (concatenate 'string
                     (subseq string start pos)
                     " = "
                     (subseq string (1+ pos) end))
        (subseq string start end))))

(defun comment-reader (stream char)
  (declare (ignore char))
  (cond ((char= #\; (peek-char nil stream))
         ;; Double (or more) semicolon, ignore the rest of the line.
         (read-line stream)
         (values))
        (t
         (let ((tokens '()))
           (map-tokens (lambda (string start end)
                         (push (prepare-matcher string start end)
                               tokens))
                       (read-line stream))
           (nreverse tokens)))))

(defmethod process-file ((in string) (out stream) (check-cb function))
  (let ((path (probe-file in)))
    (cond ((and path (pathname-name path))
           (process-file path out check-cb))
          (t
           (warn "File does not exist: ~S" in)
           (funcall check-cb nil)))))

(defmethod process-file ((in pathname) (out stream) (check-cb function))
  (with-open-file (stream in)
    (process-file stream out check-cb)))

(defmethod process-file ((in stream) (out stream) (check-cb function))
  (let ((high nil))
    (declare (type (or null (unsigned-byte 4)) high))
    (loop for char = (read-char in nil nil)
          do (cond ((null char)
                    (return))
                   ((char= #\; char)
                    (map 'nil check-cb (funcall #'comment-reader in char)))
                   ((char= #\# char)
                    (read-line in))
                   ((or (char= #\space char)
                        (not (graphic-char-p char)))
                    ;; Skip.
                    )
                   (t
                    (let ((bits (digit-char-p char 16)))
                      (declare (type (or null (unsigned-byte 4)) bits))
                      (cond ((not bits)
                             (warn "Invalid character: ~S" char))
                            (high
                             (write-byte (+ (ash high 4) bits) out)
                             (setq high nil))
                            (t
                             (setq high bits))))))))
  (close out)
  (funcall check-cb nil))

(defmethod check-results ((file t) (input pathname) (checks t))
  (with-open-file (in input)
    (check-results file in checks)))

(defun ends-with (needle string)
  (let ((mm (mismatch string needle :test #'char-equal :from-end t)))
    (or (null mm)
        (= mm (- (length string) (length needle))))))

(defmethod check-results ((file t) (input stream) (next-check function))
  (let ((n 1))
    (labels ((next-line (stream)
               (let ((line (read-line stream nil nil)))
                 (incf n)
                 line))
             (locate (needle)
               (loop for line = (next-line input)
                     do (cond ((null line)
                               (unless *quiet*
                                 (format t
                                         (paint "~&[" (:red "-") "] "
                                                "Not found: ~S~%")
                                         needle))
                               (fresh-line)
                               (return-from check-results nil))
                              ((ends-with needle line)
                               (when *verbose*
                                 (format t (paint "~&[" (:green "+") "] ~A~%")
                                         line))
                               (return))
                              (t
                               (when *verbose*
                                 (format t (paint "~&    " (:dim "~A") "~%")
                                         line)))))))
      (loop for needle = (funcall next-check)
            do (if (null needle)
                   (return t)
                   (locate needle))))))

(defun run-test (input &key (binary #p"/tmp/iec104")
                            (parser "iec104::Apdus"))
  (let ((proc (sb-ext:run-program binary
                                  `("-B" "-p" ,parser)
                                  :environment '("HILTI_DEBUG=spicy")
                                  :input :stream
                                  :error :stream
                                  :wait nil))
        (mb (sb-concurrency:make-mailbox :name "checks")))
    (flet ((register-check (check)
             (sb-concurrency:send-message mb check)))
      (sb-thread:make-thread #'process-file
                             :arguments (list input
                                              (sb-ext:process-input proc)
                                              #'register-check))
      (check-results input
                     (sb-ext:process-error proc)
                     (lambda ()
                       (sb-concurrency:receive-message mb)))
      (case (sb-ext:process-status proc)
        (:exited
         (unless (zerop (sb-ext:process-exit-code proc))
           (warn "~A exited with code ~D"
                 binary (sb-ext:process-exit-code proc))))
        (:signaled
         (warn "~A exited with signal ~D"
               binary (sb-ext:process-exit-code proc)))
        (:running
         (loop repeat 10
               do (case (sb-ext:process-status proc)
                    (:running
                     (sleep 0.1))
                    (:exited
                     (return t)))
               finally (warn "Not waiting for ~A to stop." binary)))))))

(define-condition usage-error (serious-condition)
  ())

(define-condition invalid-argument (usage-error)
  ((argument
    :initarg :argument))
  (:report (lambda (condition stream)
             (format stream "Invalid argument: ~S"
                     (slot-value condition 'argument)))))

(defun usage ()
  (format t "~&~
usage: ~A [<options>] [--] <iec104-parser> <test-file>+

    -C, --color           color output
    -q, --quiet           don't output anything
    -v, --verbose         show analyzer output
"
          (first sb-ext:*posix-argv*)))

(defun parse-cmdline (args)
  (let ((options '())
        (positional '()))
    (flet ((option (key value)
             (setf (getf options key) value))
           (optionp (string)
             (and (< 1 (length string))
                  (char= #\- (schar string 0)))))
      (loop
        (when (endp args)
          (setf positional (nreverse positional))
          (return))
        (let ((arg (pop args)))
          (when (string= "--" arg)
            (setf positional (append (nreverse positional)
                                     args))
            (return))
          (cond ((or (string= "-C" arg)
                     (string= "--color" arg)
                     (string= "--colour" arg))
                 (option :pretty t))
                ((or (string= "-h" arg)
                     (string= "--help" arg))
                 (usage)
                 (sb-ext:quit :unix-status 0))
                ((or (string= "-q" arg)
                     (string= "--quiet" arg))
                 (option :quiet t))
                ((or (string= "-v" arg)
                     (string= "--verbose" arg))
                 (option :verbose t))
                ((optionp arg)
                 (error 'invalid-argument :argument arg))
                (t
                 (push arg positional)))))
      (values positional options))))

(defun main (args)
  (handler-case
      (multiple-value-bind (positional options)
          (parse-cmdline args)
        (let ((*verbose* (getf options :verbose nil))
              (*pretty* (getf options :pretty nil))
              (*quiet* (getf options :quiet nil))
              (binary (pop positional))
              (fail nil))
          (cond ((and binary positional)
                 (loop for (file . more) on positional
                       do (when (or *verbose* (not *quiet*))
                            (format t (paint "~&[" (:yellow "*") "] ~A~%")
                                    file))
                          (unless (run-test file :binary binary)
                            (setq fail t))
                          (when (and more *verbose*)
                            (terpri)))
                 (when fail
                   (sb-ext:quit :unix-status 1)))
                (t
                 (usage)
                 (sb-ext:quit :unix-status 64)))))
    (usage-error (condition)
      (format *error-output* "~&~A~%" condition)
      (sb-ext:quit :unix-status 64))))

(eval-when (:execute :load-toplevel)
  (let ((args (rest sb-ext:*posix-argv*)))
    (when args
      (main args))))
