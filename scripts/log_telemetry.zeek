module iec104;

export {
	redef enum Log::ID += { LOG_IEC104_MACTIONS };

	type MActionInfo: record {
		ts: time &log;
		uid: string &log;
		id: conn_id &log;

		asdu_type: IEC104TypeID &log;
		cot: IEC104CoT &log;
		ca: count &log;

		ioa: count &log;
		value: string &log &optional;

		spi: bool &log &optional;
		bl: bool &log &optional;
		sb: bool &log &optional;
		nt: bool &log &optional;
		iv: bool &log &optional;
		ov: bool &log &optional;

		cp24: string &log &optional;
		cp56: string &log &optional;
	} &log;
}

function m_emit(c: connection, is_orig: bool, ioa: count, value: string,
    spi: bool, bl: bool, sb: bool, nt: bool, iv: bool, ov: bool, cp24: string,
    cp56: string)
	{
	local x = ctx(c, is_orig);

	local r: MActionInfo;
	r$ts = network_time();
	r$uid = c$uid;
	r$id = c$id;

	r$asdu_type = x$type_id;
	r$cot = x$cot;
	r$ca = x$ca;

	r$ioa = ioa;
	if ( value != "" )
		r$value = value;

	r$spi = spi;
	r$bl = bl;
	r$sb = sb;
	r$nt = nt;
	r$iv = iv;
	r$ov = ov;

	if ( cp24 != "" )
		r$cp24 = cp24;
	if ( cp56 != "" )
		r$cp56 = cp56;

	Log::write(LOG_IEC104_MACTIONS, r);
	}

event zeek_init()
	{
	Log::create_stream(LOG_IEC104_MACTIONS, [ $columns=MActionInfo,
	    $path="iec104_telemetry" ]);
	}

event m_sp_na_1(c: connection, is_orig: bool, io: M_SP_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, io$siq$spi ? "T" : "F", io$siq$spi, io$siq$bl,
	    io$siq$sb, io$siq$nt, io$siq$iv, F, "", "");
	}

event m_sp_ta_1(c: connection, is_orig: bool, io: M_SP_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, io$siq$spi ? "T" : "F", io$siq$spi, io$siq$bl,
	    io$siq$sb, io$siq$nt, io$siq$iv, F, cp24_to_str(io$tt), "");
	}

event m_sp_tb_1(c: connection, is_orig: bool, io: M_SP_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, io$siq$spi ? "T" : "F", io$siq$spi, io$siq$bl,
	    io$siq$sb, io$siq$nt, io$siq$iv, F, "", cp56_to_str(io$tt));
	}

event m_dp_na_1(c: connection, is_orig: bool, io: M_DP_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$diq$dpi), F, io$diq$bl, io$diq$sb,
	    io$diq$nt, io$diq$iv, F, "", "");
	}

event m_dp_ta_1(c: connection, is_orig: bool, io: M_DP_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$diq$dpi), F, io$diq$bl, io$diq$sb,
	    io$diq$nt, io$diq$iv, F, cp24_to_str(io$tt), "");
	}

event m_dp_tb_1(c: connection, is_orig: bool, io: M_DP_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$diq$dpi), F, io$diq$bl, io$diq$sb,
	    io$diq$nt, io$diq$iv, F, "", cp56_to_str(io$tt));
	}

event m_st_na_1(c: connection, is_orig: bool, io: M_ST_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$vti$val), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_st_ta_1(c: connection, is_orig: bool, io: M_ST_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$vti$val), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, cp24_to_str(io$tt), "");
	}

event m_st_tb_1(c: connection, is_orig: bool, io: M_ST_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$vti$val), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", cp56_to_str(io$tt));
	}

event m_bo_na_1(c: connection, is_orig: bool, io: M_BO_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("0x%08x", io$bsi), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_bo_ta_1(c: connection, is_orig: bool, io: M_BO_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("0x%08x", io$bsi), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, cp24_to_str(io$tt), "");
	}

event m_bo_tb_1(c: connection, is_orig: bool, io: M_BO_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("0x%08x", io$bsi), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", cp56_to_str(io$tt));
	}

event m_me_na_1(c: connection, is_orig: bool, io: M_ME_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$nva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_me_ta_1(c: connection, is_orig: bool, io: M_ME_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$nva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, cp24_to_str(io$tt), "");
	}

event m_me_nb_1(c: connection, is_orig: bool, io: M_ME_NB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$sva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_me_tb_1(c: connection, is_orig: bool, io: M_ME_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$sva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, cp24_to_str(io$tt), "");
	}

event m_me_nc_1(c: connection, is_orig: bool, io: M_ME_NC_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%.10g", io$r32), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_me_tc_1(c: connection, is_orig: bool, io: M_ME_TC_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%.10g", io$r32), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, cp24_to_str(io$tt), "");
	}

event m_me_nd_1(c: connection, is_orig: bool, io: M_ME_ND_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$nva), F, F, F, F, F, F, "", "");
	}

event m_me_td_1(c: connection, is_orig: bool, io: M_ME_TD_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$nva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", cp56_to_str(io$tt));
	}

event m_me_te_1(c: connection, is_orig: bool, io: M_ME_TE_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$sva), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", cp56_to_str(io$tt));
	}

event m_me_tf_1(c: connection, is_orig: bool, io: M_ME_TF_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%.10g", io$r32), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", cp56_to_str(io$tt));
	}

event m_it_na_1(c: connection, is_orig: bool, io: M_IT_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$bcr), F, F, F, F, io$qd$iv, F, "",
	    "");
	}

event m_it_ta_1(c: connection, is_orig: bool, io: M_IT_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$bcr), F, F, F, F, io$qd$iv, F,
	    cp24_to_str(io$tt), "");
	}

event m_it_tb_1(c: connection, is_orig: bool, io: M_IT_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$bcr), F, F, F, F, io$qd$iv, F, "",
	    cp56_to_str(io$tt));
	}

event m_ps_na_1(c: connection, is_orig: bool, io: M_PS_NA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$scd), F, io$qds$bl, io$qds$sb,
	    io$qds$nt, io$qds$iv, io$qds$ov, "", "");
	}

event m_ep_ta_1(c: connection, is_orig: bool, io: M_EP_TA_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$sep$bl, io$sep$sb,
	    io$sep$nt, io$sep$iv, F, cp24_to_str(io$tt), "");
	}

event m_ep_tb_1(c: connection, is_orig: bool, io: M_EP_TB_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$qdp$bl, io$qdp$sb,
	    io$qdp$nt, io$qdp$iv, F, cp24_to_str(io$tt), "");
	}

event m_ep_tc_1(c: connection, is_orig: bool, io: M_EP_TC_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$qdp$bl, io$qdp$sb,
	    io$qdp$nt, io$qdp$iv, F, cp24_to_str(io$tt), "");
	}

event m_ep_td_1(c: connection, is_orig: bool, io: M_EP_TD_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$sep$bl, io$sep$sb,
	    io$sep$nt, io$sep$iv, F, "", cp56_to_str(io$tt));
	}

event m_ep_te_1(c: connection, is_orig: bool, io: M_EP_TE_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$qdp$bl, io$qdp$sb,
	    io$qdp$nt, io$qdp$iv, F, "", cp56_to_str(io$tt));
	}

event m_ep_tf_1(c: connection, is_orig: bool, io: M_EP_TF_1_io)
	{
	m_emit(c, is_orig, io$obj_addr, fmt("ms=%d", io$ms), F, io$qdp$bl, io$qdp$sb,
	    io$qdp$nt, io$qdp$iv, F, "", cp56_to_str(io$tt));
	}

event p_me_na_1(c: connection, is_orig: bool, io: P_ME_NA_1_io)
	{
	local x = ctx(c, is_orig);
	if ( ! cot_is_inrogen(x$cot) )
		return;
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$nva), F, F, F, F, F, F, "", "");
	}

event p_me_nb_1(c: connection, is_orig: bool, io: P_ME_NB_1_io)
	{
	local x = ctx(c, is_orig);
	if ( ! cot_is_inrogen(x$cot) )
		return;
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$sva), F, F, F, F, F, F, "", "");
	}

event p_me_nc_1(c: connection, is_orig: bool, io: P_ME_NC_1_io)
	{
	local x = ctx(c, is_orig);
	if ( ! cot_is_inrogen(x$cot) )
		return;
	m_emit(c, is_orig, io$obj_addr, fmt("%.10g", io$r32), F, F, F, F, F, F, "",
	    "");
	}

event p_ac_na_1(c: connection, is_orig: bool, io: P_AC_NA_1_io)
	{
	local x = ctx(c, is_orig);
	if ( ! cot_is_inrogen(x$cot) )
		return;
	m_emit(c, is_orig, io$obj_addr, fmt("%d", io$qpa), F, F, F, F, F, F, "", "");
	}
