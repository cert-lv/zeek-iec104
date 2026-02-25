module iec104;

event zeek_init()
	{
	Log::create_stream(LOG_IEC104_READ, [ $columns=CmdReadInfo, $path="iec104_read" ]);
	}

type ReadState: record {
	r: CmdReadInfo;
	basekey: string;
	txkey: string;
	seen_req: bool;
	seen_resp: bool;
	seen_error: bool;
	err_reasons: string;
};

global read_seq: table[string] of count;
global read_active: table[string] of vector of string;

function read_new_txkey(_basekey: string): string
	{
	local _n = _basekey in read_seq ? read_seq[_basekey] + 1 : 1;
	read_seq[_basekey] = _n;
	return fmt("%s|tx=%d", _basekey, _n);
	}

function read_basekey(c: connection, action: string, ca: count,
    asdu_type: IEC104TypeID, ioa: count): string
	{
	return fmt("%s|%s|ca=%d|type=%s|ioa=%d", c$uid, action, ca, fmt("%s",
	    asdu_type), ioa);
	}

function read_mark_error(_st: ReadState, _phase: string, _x: AsduCtx): ReadState
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

function read_finalize(_st: ReadState, _timed_out: bool): CmdReadInfo
	{
	local _miss = "";
	local _sep = "";
	if ( ! _st$seen_req )
		{
		_miss += fmt("%srequest", _sep);
		_sep = ",";
		}
	if ( ! _st$seen_resp )
		{
		_miss += fmt("%sresponse", _sep);
		}

	if ( _miss != "" )
		_st$r$missing = _miss;

	if ( _st$seen_req && _st$seen_resp && _st$r?$actcon_ts )
		_st$r$duration = _st$r$actcon_ts - _st$r$ts;

	_st$r$error = _st$seen_error;
	if ( _st$seen_error )
		_st$r$error_reason = _st$err_reasons;

	if ( _timed_out )
		_st$r$status = _miss != "" ? fmt("timeout(%s)", _miss) : "ok";
	else if ( _st$seen_error )
		_st$r$status = "error";
	else if ( _miss != "" )
		_st$r$status = "incomplete";
	else
		_st$r$status = "ok";

	return _st$r;
	}

function expire_read_state(t: table[string] of ReadState, key: string): interval
	{
	if ( key !in t )
		return 0secs;
	local _st = t[key];
	q_remove(read_active, _st$basekey, _st$txkey);
	Log::write(LOG_IEC104_READ, read_finalize(_st, T));
	return 0secs;
	}

global read_state: table[string] of ReadState &write_expire=read_tx_timeout
    &expire_func=expire_read_state;

event c_rd_na_1(c: connection, is_orig: bool, io: C_RD_NA_1_io)
	{
	local _x = ctx(c, is_orig);
	local _now = network_time();

	local _action = "value_read";
	local _ioa = io$obj_addr;
	local _basekey = read_basekey(c, _action, _x$ca, _x$type_id, _ioa);

	local _txkey = "";

	if ( is_orig )
		{
		_txkey = read_new_txkey(_basekey);
		q_push(read_active, _basekey, _txkey);
		}
	else
		{
		_txkey = q_front(read_active, _basekey);
		if ( _txkey == "" )
			{
			_txkey = read_new_txkey(_basekey);
			q_push(read_active, _basekey, _txkey);
			}
		}

	local _st: ReadState;

	if ( _txkey in read_state )
		_st = read_state[_txkey];
	else
		{
		local _r: CmdReadInfo;
		_r$ts = _now;
		_r$uid = c$uid;
		_r$id = c$id;
		_r$is_orig = is_orig;

		_r$action = _action;
		_r$asdu_type = _x$type_id;
		_r$cot = _x$cot;
		_r$ca = _x$ca;
		_r$ioa = _ioa;

		_st$r = _r;
		_st$basekey = _basekey;
		_st$txkey = _txkey;
		_st$seen_req = F;
		_st$seen_resp = F;
		_st$seen_error = F;
		_st$err_reasons = "";
		}

	if ( is_orig )
		{
		_st$r$ts = _now;
		_st$r$is_orig = T;
		_st$r$cot = _x$cot;
		_st$seen_req = T;
		_st = read_mark_error(_st, "request", _x);
		read_state[_txkey] = _st;
		return;
		}

	_st$r$actcon_ts = _now;
	_st$seen_resp = T;
	_st = read_mark_error(_st, "response", _x);

	if ( io?$raw_data )
		_st$r$raw_data = io$raw_data;

	read_state[_txkey] = _st;

	Log::write(LOG_IEC104_READ, read_finalize(_st, F));
	delete read_state[_txkey];
	q_remove(read_active, _basekey, _txkey);
	}
