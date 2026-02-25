module iec104;

export {
	redef enum Log::ID += { LOG_IEC104_FILE };

	type FActionInfo: record {
		ts: time &log;
		ts_end: time &log &optional;
		duration: interval &log &optional;

		uid: string &log;
		id: conn_id &log;

		# Segment direction: "control_to_station" if is_orig, else "station_to_control"
		direction: string &log;
		is_orig: bool &log;

		ca: count &log;

		ioa: count &log;
		fname: count &log;

		segments: count &log;
		bytes: count &log;

		status: string &log;
	} &log;

	# Flush summary if no further segments arrive within this interval.
	const file_seg_timeout: interval = 2min &redef;
}

type FSegState: record {
	r: FActionInfo;
	last_ts: time;
};

# -----------------------------------------------------------------------------
# State handling
# -----------------------------------------------------------------------------

function f_dir(is_orig: bool): string
	{
	return is_orig ? "control_to_station" : "station_to_control";
	}

function f_key(c: connection, is_orig: bool, ioa: count, fname: count): string
	{
	return fmt("%s|%s|ioa=%d|fname=%d", c$uid, f_dir(is_orig), ioa, fname);
	}

function f_new_state(c: connection, is_orig: bool, ioa: count, fname: count)
    : FSegState
	{
	local x = ctx(c, is_orig);
	local now = network_time();

	local r: FActionInfo;
	r$ts = now;
	r$uid = c$uid;
	r$id = c$id;
	r$direction = f_dir(is_orig);
	r$is_orig = is_orig;
	r$ca = x$ca;
	r$ioa = ioa;
	r$fname = fname;
	r$segments = 0;
	r$bytes = 0;
	r$status = "in_progress";

	return FSegState($r=r, $last_ts=now);
	}

function f_finalize(st: FSegState, status: string)
	{
	st$r$ts_end = st$last_ts;
	if ( st$last_ts >= st$r$ts )
		st$r$duration = st$last_ts - st$r$ts;

	st$r$status = status;
	Log::write(LOG_IEC104_FILE, st$r);
	}

function expire_seg_state(t: table[string] of FSegState, key: string): interval
	{
	if ( key !in t )
		return 0secs;
	f_finalize(t[key], "timeout");
	return 0secs;
	}

global seg_state: table[string] of FSegState &write_expire=file_seg_timeout
    &expire_func=expire_seg_state;

function f_put(c: connection, is_orig: bool, ioa: count, fname: count,
    st: FSegState)
	{
	seg_state[f_key(c, is_orig, ioa, fname)] = st;
	}

function f_done_one(c: connection, is_orig: bool, ioa: count, fname: count,
    status: string)
	{
	local k = f_key(c, is_orig, ioa, fname);
	if ( k !in seg_state )
		return;
	f_finalize(seg_state[k], status);
	delete seg_state[k];
	}

function f_done_any(c: connection, ioa: count, fname: count, status: string)
	{
	# We don't know which side sends the final LS/AF reliably in all setups;
	# close both directions if present.
	f_done_one(c, T, ioa, fname, status);
	f_done_one(c, F, ioa, fname, status);
	}

# -----------------------------------------------------------------------------
# Log stream
# -----------------------------------------------------------------------------

event zeek_init()
	{
	# Keep same filename as before: iec104_file.log
	Log::create_stream(LOG_IEC104_FILE, [ $columns=FActionInfo, $path="iec104_file" ]);
	}

# -----------------------------------------------------------------------------
# Events
# -----------------------------------------------------------------------------

# Count only file segment transfers.
event f_sg_na_1(c: connection, is_orig: bool, io: F_SG_NA_1_io)
	{
	local now = network_time();
	local k = f_key(c, is_orig, io$obj_addr, io$fname);

	local st: FSegState;
	if ( k in seg_state )
		st = seg_state[k];
	else
		st = f_new_state(c, is_orig, io$obj_addr, io$fname);

	# Prefer non-broadcast CA if we started with 65535 and later see a specific CA.
	local x = ctx(c, is_orig);
	if ( st$r$ca == 65535 && x$ca != 65535 )
		st$r$ca = x$ca;

	st$last_ts = now;
	st$r$segments += 1;
	st$r$bytes += |io$seg|;

	f_put(c, is_orig, io$obj_addr, io$fname, st);
	}

# Treat LS/AF as end markers to flush summaries early (if any segments were seen).
event f_ls_na_1(c: connection, is_orig: bool, io: F_LS_NA_1_io)
	{
	f_done_any(c, io$obj_addr, io$fname, "ok");
	}

event f_af_na_1(c: connection, is_orig: bool, io: F_AF_NA_1_io)
	{
	f_done_any(c, io$obj_addr, io$fname, "ok");
	}
