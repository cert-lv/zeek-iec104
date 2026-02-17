#!/bin/sh

set -eu

BASEDIR="$(dirname $0)"
ANALYZER="${BASEDIR}/../../analyzer/iec104.spicy"

[ ! -f /tmp/iec104 -o "$ANALYZER" -nt /tmp/iec104 ] && spicy-build -d -o /tmp/iec104 "$ANALYZER"

exec sbcl --noinform --script "${BASEDIR}/spicy.lisp" /tmp/iec104 "$@"
