# IEC-104 command logging with transaction correlation.
#
# FIFO pipelining:
# We assume both peers send messages in deterministic/correct order:
#   - Actcon corresponds to Acts in FIFO order (per basekey)
#   - ActTerm corresponds to accepted Actcons in FIFO order (per basekey)
#
# This simplifies correlation: we keep two FIFO queues per basekey:
#   pending_actcon: tx waiting for Actcon
#   pending_actterm: tx waiting for ActTerm

module iec104;

export {
	redef enum Log::ID += { LOG_IEC104_WRITE, LOG_IEC104_READ, LOG_IEC104_QUERY,
	    LOG_IEC104_CTRL, LOG_IEC104_PARAM };

	const write_tx_timeout: interval = 30secs &redef;
	const read_tx_timeout: interval = 30secs &redef;
	const query_tx_timeout: interval = 30secs &redef;
	const ctrl_tx_timeout: interval = 30secs &redef;
	const p_tx_timeout: interval = 30secs &redef;

	type CmdWriteInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;
		is_orig: bool &log;

		action: string &log;
		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log &optional;
		value: string &log &optional;

		se: bool &log &optional;

		qualifier: count &log &optional;

		actcon_ts: time &log &optional;
		actterm_ts: time &log &optional;
		duration: interval &log &optional;

		missing: string &log &optional;
		error: bool &log &optional;
		error_reason: string &log &optional;
		status: string &log &optional;
	} &log;

	type CmdReadInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;
		is_orig: bool &log;

		action: string &log;
		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log &optional;
		raw_data: count &log &optional;

		actcon_ts: time &log &optional;
		duration: interval &log &optional;

		missing: string &log &optional;
		error: bool &log &optional;
		error_reason: string &log &optional;
		status: string &log &optional;
	} &log;

	type CmdQueryInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;
		is_orig: bool &log;

		action: string &log;
		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log &optional;

		qoi: count &log &optional;
		qcc_rqt: count &log &optional;
		qcc_frz: count &log &optional;

		actcon_ts: time &log &optional;
		actterm_ts: time &log &optional;
		duration: interval &log &optional;

		missing: string &log &optional;
		error: bool &log &optional;
		error_reason: string &log &optional;
		status: string &log &optional;
	} &log;

	type CmdCtrlInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;
		is_orig: bool &log;

		action: string &log;
		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log &optional;

		time_sync: string &log &optional;
		tsc: count &log &optional;
		qrp: count &log &optional;

		actcon_ts: time &log &optional;
		actterm_ts: time &log &optional;
		duration: interval &log &optional;

		missing: string &log &optional;
		error: bool &log &optional;
		error_reason: string &log &optional;
		status: string &log &optional;
	} &log;

	# P_* transaction log (params).
	type PTxInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;
		is_orig: bool &log;

		action: string &log;
		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log &optional;
		value: string &log &optional;

		qpm_kpa: count &log &optional;
		qpm_pop: bool &log &optional;
		qpm_lpc: bool &log &optional;

		qpa: count &log &optional;

		actcon_ts: time &log &optional;
		actterm_ts: time &log &optional;
		duration: interval &log &optional;

		missing: string &log &optional;
		error: bool &log &optional;
		error_reason: string &log &optional;
		status: string &log &optional;
	} &log;
}

const BROADCAST_ADDR = 65535;

# -----------------------------------------------------------------------------
# Generic AAT engine state
# -----------------------------------------------------------------------------

type AATState: record {
	ts: time;
	uid: string;
	id: conn_id;
	is_orig: bool;

	action: string;
	asdu_type: IEC104TypeID;
	cot: IEC104CoT;
	ca: count;

	ioa: count &optional;

	# write extras
	value: string &optional;
	se: bool &optional;
	qualifier: count &optional;

	# query extras
	qoi: count &optional;
	qcc_rqt: count &optional;
	qcc_frz: count &optional;

	# ctrl extras
	time_sync: string &optional;
	tsc: count &optional;
	qrp: count &optional;

	# params extras
	qpm_kpa: count &optional;
	qpm_pop: bool &optional;
	qpm_lpc: bool &optional;
	qpa: count &optional;

	# phases
	actcon_ts: time &optional;
	actterm_ts: time &optional;
	duration: interval &optional;

	seen_act: bool;
	seen_actcon: bool;
	seen_actterm: bool;

	expect_actcon: bool;
	expect_actterm: bool;

	seen_error: bool;
	err_reasons: string;

	missing: string &optional;
	error: bool &optional;
	error_reason: string &optional;
	status: string &optional;

	basekey: string;
	txkey: string;
};

global aat_seq: table[string] of count;

function aat_new_txkey(_basekey: string): string
	{
	local _n = _basekey in aat_seq ? aat_seq[_basekey] + 1 : 1;
	aat_seq[_basekey] = _n;
	return fmt("%s|tx=%d", _basekey, _n);
	}

function aat_init(c: connection, is_orig: bool, action: string, x: AsduCtx,
    basekey: string, txkey: string): AATState
	{
	local _st: AATState;

	_st$ts = network_time();
	_st$uid = c$uid;
	_st$id = c$id;
	_st$is_orig = is_orig;

	_st$action = action;
	_st$asdu_type = x$type_id;
	_st$cot = x$cot;
	_st$ca = x$ca;

	_st$seen_act = F;
	_st$seen_actcon = F;
	_st$seen_actterm = F;

	_st$expect_actcon = T;
	_st$expect_actterm = T;

	_st$seen_error = F;
	_st$err_reasons = "";

	_st$basekey = basekey;
	_st$txkey = txkey;

	return _st;
	}

function aat_mark_error(_st: AATState, _phase: string, _x: AsduCtx): AATState
	{
	if ( _x$pn )
		{
		_st$seen_error = T;
		_st$err_reasons = append_reason(_st$err_reasons, fmt(
		    "negative_confirmation@%s", _phase));
		}

	if ( _x$test )
		{
		_st$seen_error = T;
		_st$err_reasons = append_reason(_st$err_reasons, fmt("test_frame@%s",
		    _phase));
		}

	if ( cot_is_hard_error(_x$cot) )
		{
		_st$seen_error = T;
		_st$err_reasons = append_reason(_st$err_reasons, fmt("cot=%s@%s", fmt("%s",
		    _x$cot), _phase));
		}

	return _st;
	}

function aat_missing(_st: AATState): string
	{
	local _miss = "";
	local _sep = "";

	if ( ! _st$seen_act )
		{
		_miss += fmt("%sAct", _sep);
		_sep = ",";
		}

	if ( _st$expect_actcon && ! _st$seen_actcon )
		{
		_miss += fmt("%sActcon", _sep);
		_sep = ",";
		}

	if ( _st$expect_actterm && ! _st$seen_actterm )
		{
		_miss += fmt("%sActTerm", _sep);
		_sep = ",";
		}

	return _miss;
	}

function aat_finalize(_st: AATState, _timed_out: bool): AATState
	{
	local _miss = aat_missing(_st);
	if ( _miss != "" )
		_st$missing = _miss;

	if ( _st$seen_act && _st$seen_actterm && _st?$actterm_ts )
		_st$duration = _st$actterm_ts - _st$ts;

	_st$error = _st$seen_error;
	if ( _st$seen_error )
		_st$error_reason = _st$err_reasons;

	if ( _timed_out )
		{
		if ( _miss != "" )
			_st$status = fmt("timeout(%s)", _miss);
		else if ( ! _st$expect_actcon && ! _st$expect_actterm )
			_st$status = "ok_broadcast";
		else
			_st$status = "ok";
		}
	else if ( _st$error )
		_st$status = "error";
	else if ( _miss != "" )
		_st$status = "incomplete";
	else if ( ! _st$expect_actcon && ! _st$expect_actterm )
		_st$status = ( _st$seen_actcon || _st$seen_actterm ) ? "ok" : "ok_broadcast";
	else
		_st$status = "ok";

	return _st;
	}

# -----------------------------------------------------------------------------
# Emitters for logs
# -----------------------------------------------------------------------------

function aat_emit_write(_st: AATState)
	{
	local r: CmdWriteInfo;
	r$ts = _st$ts;
	r$uid = _st$uid;
	r$id = _st$id;
	r$is_orig = _st$is_orig;
	r$action = _st$action;
	r$asdu_type = _st$asdu_type;
	r$cot = _st$cot;
	r$ca = _st$ca;

	if ( _st?$ioa )
		r$ioa = _st$ioa;
	if ( _st?$value )
		r$value = _st$value;
	if ( _st?$se )
		r$se = _st$se;
	if ( _st?$qualifier )
		r$qualifier = _st$qualifier;

	if ( _st?$actcon_ts )
		r$actcon_ts = _st$actcon_ts;
	if ( _st?$actterm_ts )
		r$actterm_ts = _st$actterm_ts;
	if ( _st?$duration )
		r$duration = _st$duration;

	if ( _st?$missing )
		r$missing = _st$missing;
	if ( _st?$error )
		r$error = _st$error;
	if ( _st?$error_reason )
		r$error_reason = _st$error_reason;
	if ( _st?$status )
		r$status = _st$status;

	Log::write(LOG_IEC104_WRITE, r);
	}

function aat_emit_query(_st: AATState)
	{
	local r: CmdQueryInfo;
	r$ts = _st$ts;
	r$uid = _st$uid;
	r$id = _st$id;
	r$is_orig = _st$is_orig;
	r$action = _st$action;
	r$asdu_type = _st$asdu_type;
	r$cot = _st$cot;
	r$ca = _st$ca;

	if ( _st?$ioa )
		r$ioa = _st$ioa;
	if ( _st?$qoi )
		r$qoi = _st$qoi;
	if ( _st?$qcc_rqt )
		r$qcc_rqt = _st$qcc_rqt;
	if ( _st?$qcc_frz )
		r$qcc_frz = _st$qcc_frz;

	if ( _st?$actcon_ts )
		r$actcon_ts = _st$actcon_ts;
	if ( _st?$actterm_ts )
		r$actterm_ts = _st$actterm_ts;
	if ( _st?$duration )
		r$duration = _st$duration;

	if ( _st?$missing )
		r$missing = _st$missing;
	if ( _st?$error )
		r$error = _st$error;
	if ( _st?$error_reason )
		r$error_reason = _st$error_reason;
	if ( _st?$status )
		r$status = _st$status;

	Log::write(LOG_IEC104_QUERY, r);
	}

function aat_emit_ctrl(_st: AATState)
	{
	local r: CmdCtrlInfo;
	r$ts = _st$ts;
	r$uid = _st$uid;
	r$id = _st$id;
	r$is_orig = _st$is_orig;
	r$action = _st$action;
	r$asdu_type = _st$asdu_type;
	r$cot = _st$cot;
	r$ca = _st$ca;

	if ( _st?$ioa )
		r$ioa = _st$ioa;
	if ( _st?$time_sync )
		r$time_sync = _st$time_sync;
	if ( _st?$tsc )
		r$tsc = _st$tsc;
	if ( _st?$qrp )
		r$qrp = _st$qrp;

	if ( _st?$actcon_ts )
		r$actcon_ts = _st$actcon_ts;
	if ( _st?$actterm_ts )
		r$actterm_ts = _st$actterm_ts;
	if ( _st?$duration )
		r$duration = _st$duration;

	if ( _st?$missing )
		r$missing = _st$missing;
	if ( _st?$error )
		r$error = _st$error;
	if ( _st?$error_reason )
		r$error_reason = _st$error_reason;
	if ( _st?$status )
		r$status = _st$status;

	Log::write(LOG_IEC104_CTRL, r);
	}

function aat_emit_p(_st: AATState)
	{
	local r: PTxInfo;
	r$ts = _st$ts;
	r$uid = _st$uid;
	r$id = _st$id;
	r$is_orig = _st$is_orig;
	r$action = _st$action;
	r$asdu_type = _st$asdu_type;
	r$cot = _st$cot;
	r$ca = _st$ca;

	if ( _st?$ioa )
		r$ioa = _st$ioa;
	if ( _st?$value )
		r$value = _st$value;

	if ( _st?$qpm_kpa )
		r$qpm_kpa = _st$qpm_kpa;
	if ( _st?$qpm_pop )
		r$qpm_pop = _st$qpm_pop;
	if ( _st?$qpm_lpc )
		r$qpm_lpc = _st$qpm_lpc;
	if ( _st?$qpa )
		r$qpa = _st$qpa;

	if ( _st?$actcon_ts )
		r$actcon_ts = _st$actcon_ts;
	if ( _st?$actterm_ts )
		r$actterm_ts = _st$actterm_ts;
	if ( _st?$duration )
		r$duration = _st$duration;

	if ( _st?$missing )
		r$missing = _st$missing;
	if ( _st?$error )
		r$error = _st$error;
	if ( _st?$error_reason )
		r$error_reason = _st$error_reason;
	if ( _st?$status )
		r$status = _st$status;

	Log::write(LOG_IEC104_PARAM, r);
	}

# -----------------------------------------------------------------------------
# FIFO AAT handler
# -----------------------------------------------------------------------------

function aat_handle_fifo(c: connection, is_orig: bool, action: string,
    basekey: string, q_actcon: table[string] of vector of string,
    q_actterm: table[string] of vector of string, t: table[string] of AATState,
    emit: function(_st: AATState), fill: function(_st: AATState): AATState)
	{
	local _x = ctx(c, is_orig);
	local _now = network_time();

	local _txkey = "";
	local _st: AATState;

	if ( _x$cot == Act )
		{
		_txkey = aat_new_txkey(basekey);
		q_push(q_actcon, basekey, _txkey);

		_st = fill(aat_init(c, is_orig, action, _x, basekey, _txkey));
		_st$ts = _now;
		_st$cot = Act;
		_st$is_orig = is_orig;
		_st$seen_act = T;
		_st = aat_mark_error(_st, "Act", _x);

		# Broadcast exception: do not require confirmations, but keep tx open.
		if ( _x$ca == BROADCAST_ADDR )
			{
			_st$expect_actcon = F;
			_st$expect_actterm = F;
			}

		t[_txkey] = _st;
		return;
		}

	if ( _x$cot == Actcon )
		{
		_txkey = q_pop_front(q_actcon, basekey);
		if ( _txkey == "" )
			_txkey = aat_new_txkey(basekey); # missing Act observed

		_st = _txkey in t ? t[_txkey] : fill(aat_init(c, is_orig, action, _x, basekey,
		    _txkey));

		# if first observed phase
		if ( ! _st$seen_act && ! _st$seen_actcon && ! _st$seen_actterm )
			{
			_st$ts = _now;
			_st$cot = _x$cot;
			_st$is_orig = is_orig;
			}

		# prefer real CA if later phases provide it
		if ( _st$ca == BROADCAST_ADDR && _x$ca != BROADCAST_ADDR )
			_st$ca = _x$ca;

		_st$actcon_ts = _now;
		_st$seen_actcon = T;
		_st = aat_mark_error(_st, "Actcon", _x);

		# Negative Actcon: no ActTerm expected; finalize now.
		if ( _x$pn )
			{
			_st$expect_actterm = F;
			_st = aat_finalize(_st, F);
			emit(_st);
			delete t[_txkey];
			return;
			}

		q_push(q_actterm, basekey, _txkey);
		t[_txkey] = _st;
		return;
		}

	if ( _x$cot == ActTerm )
		{
		_txkey = q_pop_front(q_actterm, basekey);
		if ( _txkey == "" )
			_txkey = aat_new_txkey(basekey); # missing prior phases

		_st = _txkey in t ? t[_txkey] : fill(aat_init(c, is_orig, action, _x, basekey,
		    _txkey));

		if ( ! _st$seen_act && ! _st$seen_actcon && ! _st$seen_actterm )
			{
			_st$ts = _now;
			_st$cot = _x$cot;
			_st$is_orig = is_orig;
			}

		if ( _st$ca == BROADCAST_ADDR && _x$ca != BROADCAST_ADDR )
			_st$ca = _x$ca;

		_st$actterm_ts = _now;
		_st$seen_actterm = T;
		_st = aat_mark_error(_st, "ActTerm", _x);

		_st = aat_finalize(_st, F);
		emit(_st);
		delete t[_txkey];
		return;
		}

	# Unexpected COT: attach best-effort to oldest in-flight tx (actterm preferred).
	_txkey = q_front(q_actterm, basekey);
	if ( _txkey == "" )
		_txkey = q_front(q_actcon, basekey);

	if ( _txkey == "" )
		{
		_txkey = aat_new_txkey(basekey);
		q_push(q_actcon, basekey, _txkey);
		}

	_st = _txkey in t ? t[_txkey] : fill(aat_init(c, is_orig, action, _x, basekey,
	    _txkey));
	_st = aat_mark_error(_st, fmt("%s", _x$cot), _x);
	t[_txkey] = _st;
	}

# -----------------------------------------------------------------------------
# Streams
# -----------------------------------------------------------------------------

event zeek_init()
	{
	Log::create_stream(LOG_IEC104_WRITE, [ $columns=CmdWriteInfo,
	    $path="iec104_write" ]);
	Log::create_stream(LOG_IEC104_QUERY, [ $columns=CmdQueryInfo,
	    $path="iec104_query" ]);
	Log::create_stream(LOG_IEC104_CTRL, [ $columns=CmdCtrlInfo, $path="iec104_ctrl" ]);
	Log::create_stream(LOG_IEC104_PARAM, [ $columns=PTxInfo, $path="iec104_param" ]);
	}

# -----------------------------------------------------------------------------
# WRITE/QUERY/CTRL/PARAM
# -----------------------------------------------------------------------------

global write_q_actcon: table[string] of vector of string;
global write_q_actterm: table[string] of vector of string;
global query_q_actcon: table[string] of vector of string;
global query_q_actterm: table[string] of vector of string;
global ctrl_q_actcon: table[string] of vector of string;
global ctrl_q_actterm: table[string] of vector of string;
global p_q_actcon: table[string] of vector of string;
global p_q_actterm: table[string] of vector of string;

function expire_aat(t: table[string] of AATState, key: string, q1: table[string] of
    vector of string, q2: table[string] of vector of string, emit: function(
    _st: AATState)): interval
	{
	if ( key !in t )
		return 0secs;

	local _st = t[key];

	# Remove from both queues (at most one will contain it).
	q_remove(q1, _st$basekey, _st$txkey);
	q_remove(q2, _st$basekey, _st$txkey);

	_st = aat_finalize(_st, T);
	emit(_st);

	return 0secs;
	}

function expire_write_state(t: table[string] of AATState, key: string): interval
	{
	return expire_aat(t, key, write_q_actcon, write_q_actterm, aat_emit_write);
	}

function expire_query_state(t: table[string] of AATState, key: string): interval
	{
	return expire_aat(t, key, query_q_actcon, query_q_actterm, aat_emit_query);
	}

function expire_ctrl_state(t: table[string] of AATState, key: string): interval
	{
	return expire_aat(t, key, ctrl_q_actcon, ctrl_q_actterm, aat_emit_ctrl);
	}

function expire_p_state(t: table[string] of AATState, key: string): interval
	{
	return expire_aat(t, key, p_q_actcon, p_q_actterm, aat_emit_p);
	}

global write_state: table[string] of AATState &write_expire=write_tx_timeout
    &expire_func=expire_write_state;

global query_state: table[string] of AATState &write_expire=query_tx_timeout
    &expire_func=expire_query_state;

global ctrl_state: table[string] of AATState &write_expire=ctrl_tx_timeout
    &expire_func=expire_ctrl_state;

global p_state: table[string] of AATState &write_expire=p_tx_timeout
    &expire_func=expire_p_state;

# -----------------------------------------------------------------------------
# Basekeys + wrappers
# -----------------------------------------------------------------------------

function write_basekey(c: connection, action: string, ca: count,
    asdu_type: IEC104TypeID, ioa: count, value: string, se: bool,
    qualifier: count): string
	{
	return fmt("%s|%s|ca=%d|type=%s|ioa=%d|val=%s|se=%s|q=%d", c$uid, action, ca,
	    fmt("%s", asdu_type), ioa, value, se ? "T" : "F", qualifier);
	}

function handle_write_cmd(c: connection, is_orig: bool, action: string,
    ioa: count, value: string, se: bool, qualifier: count)
	{
	local _x = ctx(c, is_orig);
	local _basekey = write_basekey(c, action, _x$ca, _x$type_id, ioa, value, se,
	    qualifier);

	# Broadcast fallback: if reply uses real CA, try to map to earlier CA=BROADCAST_ADDR.
	if ( _x$cot != Act && _x$ca != BROADCAST_ADDR )
		{
		if ( _basekey !in write_q_actcon && _basekey !in write_q_actterm )
			{
			local _b = write_basekey(c, action, BROADCAST_ADDR, _x$type_id, ioa, value, se,
			    qualifier);
			if ( _b in write_q_actcon || _b in write_q_actterm )
				_basekey = _b;
			}
		}

	aat_handle_fifo(c, is_orig, action, _basekey, write_q_actcon, write_q_actterm,
	    write_state, aat_emit_write, function[ioa, value, se, qualifier](
	    _st: AATState): AATState
		{
		_st$ioa = ioa;
		if ( value != "" )
			_st$value = value;
		_st$se = se;
		_st$qualifier = qualifier;
		return _st;
		});
	}

function query_basekey(c: connection, action: string, ca: count,
    asdu_type: IEC104TypeID, ioa: count, qoi: count, rqt: count, frz: count)
    : string
	{
	return fmt("%s|%s|ca=%d|type=%s|ioa=%d|qoi=%d|rqt=%d|frz=%d", c$uid, action, ca,
	    fmt("%s", asdu_type), ioa, qoi, rqt, frz);
	}

function handle_query_cmd(c: connection, is_orig: bool, action: string,
    ioa: count, qoi: count, rqt: count, frz: count)
	{
	local _x = ctx(c, is_orig);
	local _basekey = query_basekey(c, action, _x$ca, _x$type_id, ioa, qoi, rqt,
	    frz);

	if ( _x$cot != Act && _x$ca != BROADCAST_ADDR )
		{
		if ( _basekey !in query_q_actcon && _basekey !in query_q_actterm )
			{
			local _b = query_basekey(c, action, BROADCAST_ADDR, _x$type_id, ioa, qoi,
			    rqt, frz);
			if ( _b in query_q_actcon || _b in query_q_actterm )
				_basekey = _b;
			}
		}

	aat_handle_fifo(c, is_orig, action, _basekey, query_q_actcon, query_q_actterm,
	    query_state, aat_emit_query, function[ioa, qoi, rqt, frz](
	    _st: AATState): AATState
		{
		_st$ioa = ioa;
		if ( qoi != 0 )
			_st$qoi = qoi;
		if ( rqt != 0 )
			_st$qcc_rqt = rqt;
		if ( frz != 0 )
			_st$qcc_frz = frz;
		return _st;
		});
	}

function ctrl_basekey(c: connection, action: string, asdu_type: IEC104TypeID,
    ioa: count, time_sync: string, tsc: count, qrp: count): string
	{
	# Keep CA out (Act may use BROADCAST_ADDR, replies real CA).
	return fmt("%s|%s|type=%s|ioa=%d|ts=%s|tsc=%d|qrp=%d", c$uid, action, fmt("%s",
	    asdu_type), ioa, time_sync, tsc, qrp);
	}

function handle_ctrl_cmd(c: connection, is_orig: bool, action: string,
    ioa: count, time_sync: string, tsc: count, qrp: count)
	{
	local _x = ctx(c, is_orig);
	local _basekey = ctrl_basekey(c, action, _x$type_id, ioa, time_sync, tsc, qrp);

	aat_handle_fifo(c, is_orig, action, _basekey, ctrl_q_actcon, ctrl_q_actterm,
	    ctrl_state, aat_emit_ctrl, function[ioa, time_sync, tsc, qrp](
	    _st: AATState): AATState
		{
		_st$ioa = ioa;
		if ( time_sync != "" )
			_st$time_sync = time_sync;
		if ( tsc != 0 )
			_st$tsc = tsc;
		if ( qrp != 0 )
			_st$qrp = qrp;
		return _st;
		});
	}

# -----------------------------------------------------------------------------
# PARAM basekeys + handlers
# -----------------------------------------------------------------------------

function p_me_basekey(c: connection, action: string, ca: count,
    asdu_type: IEC104TypeID, ioa: count, value: string, kpa: count, pop: bool,
    lpc: bool): string
	{
	return fmt("%s|%s|ca=%d|type=%s|ioa=%d|val=%s|kpa=%d|pop=%s|lpc=%s", c$uid,
	    action, ca, fmt("%s", asdu_type), ioa, value, kpa, pop ? "T" : "F", lpc ? "T"
	    : "F");
	}

function handle_p_me(c: connection, is_orig: bool, action: string, ioa: count,
    value: string, kpa: count, pop: bool, lpc: bool)
	{
	local _x = ctx(c, is_orig);

	# Do not create transactions for interrogation results (telemetry).
	if ( cot_is_inrogen(_x$cot) )
		return;

	local _basekey = p_me_basekey(c, action, _x$ca, _x$type_id, ioa, value, kpa,
	    pop, lpc);

	# Broadcast fallback: map reply CA back to CA=BROADCAST_ADDR tx.
	if ( _x$cot != Act && _x$ca != BROADCAST_ADDR )
		{
		if ( _basekey !in p_q_actcon && _basekey !in p_q_actterm )
			{
			local _b = p_me_basekey(c, action, BROADCAST_ADDR, _x$type_id, ioa, value,
			    kpa, pop, lpc);
			if ( _b in p_q_actcon || _b in p_q_actterm )
				_basekey = _b;
			}
		}

	aat_handle_fifo(c, is_orig, action, _basekey, p_q_actcon, p_q_actterm, p_state,
	    aat_emit_p, function[ioa, value, kpa, pop, lpc](_st: AATState)
	    : AATState
		{
		_st$ioa = ioa;
		if ( value != "" )
			_st$value = value;
		_st$qpm_kpa = kpa;
		_st$qpm_pop = pop;
		_st$qpm_lpc = lpc;
		return _st;
		});
	}

function p_ac_basekey(c: connection, action: string, ca: count,
    asdu_type: IEC104TypeID, ioa: count, qpa: count): string
	{
	return fmt("%s|%s|ca=%d|type=%s|ioa=%d|qpa=%d", c$uid, action, ca, fmt("%s",
	    asdu_type), ioa, qpa);
	}

function handle_p_ac(c: connection, is_orig: bool, action: string, ioa: count,
    qpa: count)
	{
	local _x = ctx(c, is_orig);

	# Do not create transactions for interrogation results (telemetry).
	if ( cot_is_inrogen(_x$cot) )
		return;

	local _basekey = p_ac_basekey(c, action, _x$ca, _x$type_id, ioa, qpa);

	if ( _x$cot != Act && _x$ca != BROADCAST_ADDR )
		{
		if ( _basekey !in p_q_actcon && _basekey !in p_q_actterm )
			{
			local _b = p_ac_basekey(c, action, BROADCAST_ADDR, _x$type_id, ioa, qpa);
			if ( _b in p_q_actcon || _b in p_q_actterm )
				_basekey = _b;
			}
		}

	aat_handle_fifo(c, is_orig, action, _basekey, p_q_actcon, p_q_actterm, p_state,
	    aat_emit_p, function[ioa, qpa](_st: AATState): AATState
		{
		_st$ioa = ioa;
		_st$qpa = qpa;
		_st$value = fmt("%d", qpa);
		return _st;
		});
	}

# -----------------------------------------------------------------------------
# WRITE events
# -----------------------------------------------------------------------------

event c_sc_na_1(c: connection, is_orig: bool, io: C_SC_NA_1_io)
	{
	handle_write_cmd(c, is_orig, "single_write", io$obj_addr, io$sco$scs ? "T" :
	    "F", io$sco$se, io$sco$qu);
	}

event c_sc_ta_1(c: connection, is_orig: bool, io: C_SC_TA_1_io)
	{
	handle_write_cmd(c, is_orig, "single_write", io$obj_addr, io$sco$scs ? "T" :
	    "F", io$sco$se, io$sco$qu);
	}

event c_dc_na_1(c: connection, is_orig: bool, io: C_DC_NA_1_io)
	{
	handle_write_cmd(c, is_orig, "double_write", io$obj_addr, fmt("%d",
	    io$dco$dcs), io$dco$se, io$dco$qu);
	}

event c_dc_ta_1(c: connection, is_orig: bool, io: C_DC_TA_1_io)
	{
	handle_write_cmd(c, is_orig, "double_write", io$obj_addr, fmt("%d",
	    io$dco$dcs), io$dco$se, io$dco$qu);
	}

event c_rc_na_1(c: connection, is_orig: bool, io: C_RC_NA_1_io)
	{
	handle_write_cmd(c, is_orig, "step_write", io$obj_addr, fmt("%d", io$rco$rcs),
	    io$rco$se, io$rco$qu);
	}

event c_rc_ta_1(c: connection, is_orig: bool, io: C_RC_TA_1_io)
	{
	handle_write_cmd(c, is_orig, "step_write", io$obj_addr, fmt("%d", io$rco$rcs),
	    io$rco$se, io$rco$qu);
	}

event c_bo_na_1(c: connection, is_orig: bool, io: C_BO_NA_1_io)
	{
	handle_write_cmd(c, is_orig, "bitstring_write", io$obj_addr, fmt("0x%08x",
	    io$bsi), F, 0);
	}

event c_bo_ta_1(c: connection, is_orig: bool, io: C_BO_TA_1_io)
	{
	handle_write_cmd(c, is_orig, "bitstring_write", io$obj_addr, fmt("0x%08x",
	    io$bsi), F, 0);
	}

event c_se_na_1(c: connection, is_orig: bool, io: C_SE_NA_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%d", io$nva),
	    io$qos$se, io$qos$ql);
	}

event c_se_nb_1(c: connection, is_orig: bool, io: C_SE_NB_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%d", io$sva),
	    io$qos$se, io$qos$ql);
	}

event c_se_nc_1(c: connection, is_orig: bool, io: C_SE_NC_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%.10g",
	    io$r32), io$qos$se, io$qos$ql);
	}

event c_se_ta_1(c: connection, is_orig: bool, io: C_SE_TA_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%d", io$nva),
	    io$qos$se, io$qos$ql);
	}

event c_se_tb_1(c: connection, is_orig: bool, io: C_SE_TB_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%d", io$sva),
	    io$qos$se, io$qos$ql);
	}

event c_se_tc_1(c: connection, is_orig: bool, io: C_SE_TC_1_io)
	{
	handle_write_cmd(c, is_orig, "setpoint_write", io$obj_addr, fmt("%.10g",
	    io$r32), io$qos$se, io$qos$ql);
	}

# -----------------------------------------------------------------------------
# QUERY events
# -----------------------------------------------------------------------------

event c_ic_na_1(c: connection, is_orig: bool, io: C_IC_NA_1_io)
	{
	handle_query_cmd(c, is_orig, "interrogation", io$obj_addr, io$qoi, 0, 0);
	}

event c_ci_na_1(c: connection, is_orig: bool, io: C_CI_NA_1_io)
	{
	handle_query_cmd(c, is_orig, "counter_interrogation", io$obj_addr, 0,
	    io$qcc$rqt, io$qcc$frz);
	}

# -----------------------------------------------------------------------------
# CTRL events
# -----------------------------------------------------------------------------

event c_cs_na_1(c: connection, is_orig: bool, io: C_CS_NA_1_io)
	{
	handle_ctrl_cmd(c, is_orig, "clock_sync", io$obj_addr, cp56_to_str(io$tt), 0, 0);
	}

event c_ts_ta_1(c: connection, is_orig: bool, io: C_TS_TA_1_io)
	{
	handle_ctrl_cmd(c, is_orig, "test", io$obj_addr, cp56_to_str(io$tt), io$tsc, 0);
	}

event c_rp_na_1(c: connection, is_orig: bool, io: C_RP_NA_1_io)
	{
	handle_ctrl_cmd(c, is_orig, "reset_process", io$obj_addr, "", 0, io$qrp);
	}

# -----------------------------------------------------------------------------
# PARAM event
# -----------------------------------------------------------------------------

event p_me_na_1(c: connection, is_orig: bool, io: P_ME_NA_1_io)
	{
	handle_p_me(c, is_orig, "param_measured", io$obj_addr, fmt("%d", io$nva),
	    io$qpm$kpa, io$qpm$pop, io$qpm$lpc);
	}

event p_me_nb_1(c: connection, is_orig: bool, io: P_ME_NB_1_io)
	{
	handle_p_me(c, is_orig, "param_measured", io$obj_addr, fmt("%d", io$sva),
	    io$qpm$kpa, io$qpm$pop, io$qpm$lpc);
	}

event p_me_nc_1(c: connection, is_orig: bool, io: P_ME_NC_1_io)
	{
	handle_p_me(c, is_orig, "param_measured", io$obj_addr, fmt("%.10g", io$r32),
	    io$qpm$kpa, io$qpm$pop, io$qpm$lpc);
	}

event p_ac_na_1(c: connection, is_orig: bool, io: P_AC_NA_1_io)
	{
	handle_p_ac(c, is_orig, "param_activation", io$obj_addr, io$qpa);
	}
