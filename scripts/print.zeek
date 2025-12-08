module iec104;

redef record connection += {
    asdu_ident: AsduIdent &optional;
};

function comm_info(ts: time, c: connection, is_orig: bool): string
{
    return cat(ljust(cat(ts), 17, "0"), " ",
               c$id$orig_h, ":", port_to_count(c$id$orig_p),
               is_orig ? " -> " : " <- ",
               c$id$resp_h, ":", port_to_count(c$id$resp_p));
}

function tt56_str(tt: CP56Time2a): string
{
    local dow = vector("INV", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");
    local seconds = tt$ms / 1000;
    local ms = tt$ms % 1000;
    return cat(
        tt$year, "-", zfill(cat(tt$month), 2), "-", zfill(cat(tt$day), 2),
        " (", dow[tt$dow], ") ",
        zfill(cat(tt$hour), 2), ":", zfill(cat(tt$minute), 2), ":",
        zfill(cat(seconds), 2), ".", ljust(cat(ms), 3, "0"),
        " SU:", tt$su, " IV:", tt$iv);
}

function tt24_str(tt: CP24Time2a): string
{
    local seconds = tt$ms / 1000;
    local ms = tt$ms % 1000;
    return cat(zfill(cat(tt$minute), 2), ":",
               zfill(cat(seconds), 2), ".", ljust(cat(ms), 3, "0"),
               " IV:", tt$iv);
}

function asdu_info(c: connection): string
{
    if (c?$asdu_ident) {
        local ident = c$asdu_ident;
        return cat("  ASDU ", cat(ident$cot),
                   " OA=", ident$originator_address,
                   " CA=", ident$common_address,);
    } else {
        return "  missing ASDU";
    }
}
function u_info (startd: count, stopdt: count, testfr: count): string
{
    local x = (startd << 4) | (stopdt << 2) | testfr;
    switch x {
        case 1: return "U TESTFR act";
        case 2: return "U TESTFR con";
        case 4: return "U STOPDT act";
        case 8: return "U STOPDT con";
        case 16: return "U STARTDT act";
        case 32: return "U STARTDT con";
        default:
            return cat("INVALID U-Format: ", x);
    }
}

event iec104::u
    (c: connection, is_orig: bool, startdt: count, stopdt: count, testfr: count)
    &priority=-10
{
    print comm_info(network_time(), c, is_orig),
          u_info(startdt, stopdt, testfr);
}

event iec104::s
    (c: connection, is_orig: bool, rsn: count)
    &priority=-10
{
    print comm_info(network_time(), c, is_orig),
          cat("S rsn:", rsn);
}

event iec104::i
    (c: connection, is_orig: bool, ssn: count, rsn: count)
    &priority=-10
{
    print comm_info(network_time(), c, is_orig),
          fmt("I ssn:%d, rsn:%d", ssn, rsn);
}

event iec104::asdu
    (c: connection, is_orig: bool, ident: AsduIdent)
    &priority=-10
{
    c$asdu_ident = ident;
}

event iec104::m_sp_na_1
    (c: connection, is_orig: bool, io: M_SP_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_SP_NA_1 obj_addr=", io$obj_addr,
              " SIQ=", io$siq);
}

event iec104::m_sp_ta_1
    (c: connection, is_orig: bool, io: M_SP_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_SP_TA_1 obj_addr=", io$obj_addr,
              " SIQ=", io$siq,
              " TT=", tt24_str(io$tt));
}

event iec104::m_dp_na_1
    (c: connection, is_orig: bool, io: M_DP_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_DP_NA_1 obj_addr=", io$obj_addr,
              " DIQ=", io$diq);
}

event iec104::m_dp_ta_1
    (c: connection, is_orig: bool, io: M_DP_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_DP_TA_1 obj_addr=", io$obj_addr,
              " DIQ=", io$diq,
              " TT=", tt24_str(io$tt));
}

event iec104::m_st_na_1
    (c: connection, is_orig: bool, io: M_ST_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ST_NA_1 obj_addr=", io$obj_addr,
              " VTI=", io$vti,
              " QDS=", io$qds);
}

event iec104::m_st_ta_1
    (c: connection, is_orig: bool, io: M_ST_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ST_TA_1 obj_addr=", io$obj_addr,
              " VTI=", io$vti,
              " QDS=", io$qds,
              " TT=", tt24_str(io$tt));
}

event iec104::m_bo_na_1
    (c: connection, is_orig: bool, io: M_BO_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_BO_NA_1 obj_addr=", io$obj_addr,
              " BSI=", fmt("0x%x", io$bsi),
              " QDS=", io$qds);
}

event iec104::m_bo_ta_1
    (c: connection, is_orig: bool, io: M_BO_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_BO_TA_1 obj_addr=", io$obj_addr,
              " BSI=", fmt("0x%x", io$bsi),
              " QDS=", io$qds,
              " TT=", tt24_str(io$tt));
}

event iec104::m_me_na_1
    (c: connection, is_orig: bool, io: M_ME_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_NA_1 obj_addr=", io$obj_addr,
              " NVA=", io$nva,
              " QDS=", io$qds);
}

event iec104::m_me_ta_1
    (c: connection, is_orig: bool, io: M_ME_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TA_1 obj_addr=", io$obj_addr,
              " NVA=", io$nva,
              " QDS=", io$qds,
              " TT=", tt24_str(io$tt));
}

event iec104::m_me_nb_1
    (c: connection, is_orig: bool, io: M_ME_NB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_NB_1 obj_addr=", io$obj_addr,
              " SVA=", io$sva,
              " QDS=", io$qds);
}

event iec104::m_me_tb_1
    (c: connection, is_orig: bool, io: M_ME_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TB_1 obj_addr=", io$obj_addr,
              " SVA=", io$sva,
              " QDS=", io$qds,
              " TT=", tt24_str(io$tt));
}

event iec104::m_me_nc_1
    (c: connection, is_orig: bool, io: M_ME_NC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_NC_1 obj_addr=", io$obj_addr,
              " R32=", io$r32,
              " QDS=", io$qds);
}

event iec104::m_me_tc_1
    (c: connection, is_orig: bool, io: M_ME_TC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TC_1 obj_addr=", io$obj_addr,
              " R32=", io$r32,
              " QDS=", io$qds,
              " TT=", tt24_str(io$tt));
}

event iec104::m_it_na_1
    (c: connection, is_orig: bool, io: M_IT_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_IT_NA_1 obj_addr=", io$obj_addr,
              " BCR=", io$bcr,
              " QD=", io$qd);
}

event iec104::m_it_ta_1
    (c: connection, is_orig: bool, io: M_IT_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_IT_TA_1 obj_addr=", io$obj_addr,
              " BCR=", io$bcr,
              " QD=", io$qd,
              " TT=", tt24_str(io$tt));
}

event iec104::m_ep_ta_1
    (c: connection, is_orig: bool, io: M_EP_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TA_1 obj_addr=", io$obj_addr,
              " SEP=", io$sep,
              " MS=", io$ms,
              " TT=", tt24_str(io$tt));
}

event iec104::m_ep_tb_1
    (c: connection, is_orig: bool, io: M_EP_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TB_1 obj_addr=", io$obj_addr,
              " SEP=", io$sep,
              " QDP=", io$qdp,
              " MS=", io$ms,
              " TT=", tt24_str(io$tt));
}

event iec104::m_ep_tc_1
    (c: connection, is_orig: bool, io: M_EP_TC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TC_1 obj_addr=", io$obj_addr,
              " OCI=", io$oci,
              " QDP=", io$qdp,
              " MS=", io$ms,
              " TT=", tt24_str(io$tt));
}

event iec104::m_ps_na_1
    (c: connection, is_orig: bool, io: M_PS_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_PS_NA_1 obj_addr=", io$obj_addr,
              " SCD=", io$scd,
              " QDS=", io$qds);
}

event iec104::m_me_nd_1
    (c: connection, is_orig: bool, io: M_ME_ND_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_ND_1 obj_addr=", io$obj_addr,
              " NVA=", io$nva);
}

event iec104::m_sp_tb_1
    (c: connection, is_orig: bool, io: M_SP_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_SP_TB_1 obj_addr=", io$obj_addr,
              " SIQ=", io$siq,
              " TT=", tt56_str(io$tt));
}

event iec104::m_dp_tb_1
    (c: connection, is_orig: bool, io: M_DP_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_DP_TB_1 obj_addr=", io$obj_addr,
              " DIQ=", io$diq,
              " TT=", tt56_str(io$tt));
}

event iec104::m_st_tb_1
    (c: connection, is_orig: bool, io: M_ST_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ST_TB_1 obj_addr=", io$obj_addr,
              " VTI=", io$vti,
              " QDS=", io$qds,
              " TT=", tt56_str(io$tt));
}

event iec104::m_bo_tb_1
    (c: connection, is_orig: bool, io: M_BO_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_BO_TB_1 obj_addr=", io$obj_addr,
              " BSI=", fmt("0x%x", io$bsi),
              " QDS=", io$qds,
              " TT=", tt56_str(io$tt));
}

event iec104::m_me_td_1
    (c: connection, is_orig: bool, io: M_ME_TD_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TD_1 obj_addr=", io$obj_addr,
              " NVA=" ,io$nva,
              " QDS=", io$qds,
              " TT=", tt56_str(io$tt));
}

event iec104::m_me_te_1
    (c: connection, is_orig: bool, io: M_ME_TE_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TE_1 obj_addr=", io$obj_addr,
              " SVA=" ,io$sva,
              " QDS=", io$qds,
              " TT=", tt56_str(io$tt));
}

event iec104::m_me_tf_1
    (c: connection, is_orig: bool, io: M_ME_TF_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_ME_TF_1 obj_addr=", io$obj_addr,
              " R32=" ,io$r32,
              " QDS=", io$qds,
              " TT=", tt56_str(io$tt));
}

event iec104::m_it_tb_1
    (c: connection, is_orig: bool, io: M_IT_TB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_IT_TB_1 obj_addr=", io$obj_addr,
              " BCR=", io$bcr,
              " QD=", io$qd,
              " TT=", tt56_str(io$tt));
}

event iec104::m_ep_td_1
    (c: connection, is_orig: bool, io: M_EP_TD_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TD_1 obj_addr=", io$obj_addr,
              " SEP=", io$sep,
              " MS=", io$ms,
              " TT=", tt56_str(io$tt));
}

event iec104::m_ep_te_1
    (c: connection, is_orig: bool, io: M_EP_TE_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TE_1 obj_addr=", io$obj_addr,
              " SEP=", io$sep,
              " QDP=", io$qdp,
              " MS=", io$ms,
              " TT=", tt56_str(io$tt));
}

event iec104::m_ep_tf_1
    (c: connection, is_orig: bool, io: M_EP_TF_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EP_TF_1 obj_addr=", io$obj_addr,
              " OCI=", io$oci,
              " QDP=", io$qdp,
              " MS=", io$ms,
              " TT=", tt56_str(io$tt));
}

event iec104::c_sc_na_1
    (c: connection, is_orig: bool, io: C_SC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SC_NA_1 obj_addr=", io$obj_addr,
              " SCO=", io$sco);
}

event iec104::c_dc_na_1
    (c: connection, is_orig: bool, io: C_DC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_DC_NA_1 obj_addr=", io$obj_addr,
              " DCO=", io$dco);
}

event iec104::c_rc_na_1
    (c: connection, is_orig: bool, io: C_RC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_RC_NA_1 obj_addr=", io$obj_addr,
              " RCO=", io$rco);
}

event iec104::c_se_na_1
    (c: connection, is_orig: bool, io: C_SE_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SE_NA_1 obj_addr=", io$obj_addr,
              " NVA=", io$nva,
              " QOS=", io$qos);
}

event iec104::c_se_nb_1
    (c: connection, is_orig: bool, io: C_SE_NB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SE_NB_1 obj_addr=", io$obj_addr,
              " SVA=", io$sva,
              " QOS=", io$qos);
}

event iec104::c_se_nc_1
    (c: connection, is_orig: bool, io: C_SE_NC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SE_NC_1 obj_addr=", io$obj_addr,
              " R32=", io$r32,
              " QOS=", io$qos);
}

event iec104::c_bo_na_1
    (c: connection, is_orig: bool, io: C_BO_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_BO_NA_1 obj_addr=", io$obj_addr,
              " BSI=", fmt("0x%x", io$bsi));
}

event iec104::c_sc_ta_1
    (c: connection, is_orig: bool, io: C_SC_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SC_TA_1 obj_addr=", io$obj_addr,
              " SCO=", io$sco,
              " TT=", tt56_str(io$tt));
}

event iec104::c_dc_ta_1
    (c: connection, is_orig: bool, io: C_DC_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_DC_TA_1 obj_addr=", io$obj_addr,
              " DCO=", io$dco,
              " TT=", tt56_str(io$tt));
}

event iec104::c_rc_ta_1
    (c: connection, is_orig: bool, io: C_RC_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_RC_TA_1 obj_addr=", io$obj_addr,
              " RCO=", io$rco,
              " TT=", tt56_str(io$tt));
}

event iec104::c_se_ta_1
    (c: connection, is_orig: bool, io: C_SE_TA_1_io)
    &priority=-10
{
    cat("C_SE_TA_1 obj_addr=", io$obj_addr,
        " NVA=", io$nva,
        " QOS=", io$qos,
        " TT=", tt56_str(io$tt));
}

event iec104::c_se_tb_1
    (c: connection, is_orig: bool, io: C_SE_TB_1_io)
    &priority=-10
{
    cat("C_SE_TB_1 obj_addr=", io$obj_addr,
        " SVA=", io$sva,
        " QOS=", io$qos,
        " TT=", tt56_str(io$tt));
}

event iec104::c_se_tc_1
    (c: connection, is_orig: bool, io: C_SE_TC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_SE_TC_1 obj_addr=", io$obj_addr,
              " R32=", io$r32,
              " QOS=", io$qos,
              " TT=", tt56_str(io$tt));
}

event iec104::c_bo_ta_1
    (c: connection, is_orig: bool, io: C_BO_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_BO_TA_1 obj_addr=", io$obj_addr,
              " BSI=", fmt("0x%x", io$bsi),
              " TT=", tt56_str(io$tt));
}

event iec104::m_ei_na_1
    (c: connection, is_orig: bool, io: M_EI_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("M_EI_NA_1 obj_addr=", io$obj_addr,
              " COI=", io$coi,
              " LPC=", io$lpc);
}

event iec104::c_ic_na_1
    (c: connection, is_orig: bool, io: C_IC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_IC_NA_1 obj_addr=", io$obj_addr,
              " QOI=", io$qoi);
}

event iec104::c_ci_na_1
    (c: connection, is_orig: bool, io: C_CI_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_CI_NA_1 obj_addr=", io$obj_addr,
              " QCC=", io$qcc);
}

event iec104::c_rd_na_1
    (c: connection, is_orig: bool, io: C_RD_NA_1_io)
    &priority=-10
{
    local dump: string = cat("C_RD_NA_1 obj_addr=", io$obj_addr);
    if (io?$raw_data) {
        dump += cat(" raw_data=", io$raw_data);
    }

    print asdu_info(c), dump;
}

event iec104::c_cs_na_1
    (c: connection, is_orig: bool, io: C_CS_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_CS_NA_1 obj_addr=", io$obj_addr,
              " TT=", tt56_str(io$tt));
}

event iec104::c_rp_na_1
    (c: connection, is_orig: bool, io: C_RP_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_RP_NA_1 obj_addr=", io$obj_addr,
              " QRP=", io$qrp);
}

event iec104::c_ts_ta_1
    (c: connection, is_orig: bool, io: C_TS_TA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("C_TS_TA_1 obj_addr=", io$obj_addr,
              " TSC=", io$tsc,
              " TT=", tt56_str(io$tt));
}

event iec104::p_me_na_1
    (c: connection, is_orig: bool, io: P_ME_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("P_ME_NA_1 obj_addr=", io$obj_addr,
              " NVA=", io$nva,
              " QPM=", io$qpm);
}

event iec104::p_me_nb_1
    (c: connection, is_orig: bool, io: P_ME_NB_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("P_ME_NB_1 obj_addr=", io$obj_addr,
              " SVA=", io$sva,
              " QPM=", io$qpm);
}

event iec104::p_me_nc_1
    (c: connection, is_orig: bool, io: P_ME_NC_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("P_ME_NC_1 obj_addr=", io$obj_addr,
              " R32=", io$r32,
              " QPM=", io$qpm);
}

event iec104::p_ac_na_1
    (c: connection, is_orig: bool, io: P_AC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("P_AC_NA_1 obj_addr=", io$obj_addr,
              " QPA=", io$qpa);
}

event iec104::f_fr_na_1
    (c: connection, is_orig: bool, io: F_FR_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_FR_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " len=", io$len,
              " frq=", io$frq);
}

event iec104::f_sr_na_1
    (c: connection, is_orig: bool, io: F_SR_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_SR_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " sname=", io$sname,
              " len=", io$len, " srq=", io$srq);
}

event iec104::f_sc_na_1
    (c: connection, is_orig: bool, io: F_SC_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_SC_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " sname=", io$sname,
              " scq=", io$scq);
}

event iec104::f_ls_na_1
    (c: connection, is_orig: bool, io: F_LS_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_LS_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " sname=", io$sname,
              " lsq=", io$lsq, " chs=", io$chs);
}

event iec104::f_af_na_1
    (c: connection, is_orig: bool, io: F_AF_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_AF_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " sname=", io$sname,
              " afq=", io$afq);
}

event iec104::f_sg_na_1
    (c: connection, is_orig: bool, io: F_SG_NA_1_io)
    &priority=-10
{
    print asdu_info(c),
          cat("F_SG_NA_1 obj_addr=", io$obj_addr,
              " fname=", io$fname, " sname=", io$sname,
              " len=", io$len, " seg=", io$seg);
}

event iec104::unknown_asdu
    (c: connection, is_orig: bool, type_id: ::IEC104TypeID, hex: string)
    &priority=-10
{
    print asdu_info(c),
          cat("UNKNOWN TypeID=", type_id, " bytes=", hex);
}
