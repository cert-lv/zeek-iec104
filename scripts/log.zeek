module iec104;

export {
    const log_as_json = F &redef;
}

redef enum Log::ID += {
    LOG_ASDU_IDENT,
    LOG_M_SP_NA_1,
    LOG_M_SP_TA_1,
    LOG_M_DP_NA_1,
    LOG_M_DP_TA_1,
    LOG_M_ST_NA_1,
    LOG_M_ST_TA_1,
    LOG_M_BO_NA_1,
    LOG_M_BO_TA_1,
    LOG_M_ME_NA_1,
    LOG_M_ME_TA_1,
    LOG_M_ME_NB_1,
    LOG_M_ME_TB_1,
    LOG_M_ME_NC_1,
    LOG_M_ME_TC_1,
    LOG_M_IT_NA_1,
    LOG_M_IT_TA_1,
    LOG_M_EP_TA_1,
    LOG_M_EP_TB_1,
    LOG_M_EP_TC_1,
    LOG_M_PS_NA_1,
    LOG_M_ME_ND_1,
    LOG_M_SP_TB_1,
    LOG_M_DP_TB_1,
    LOG_M_ST_TB_1,
    LOG_M_BO_TB_1,
    LOG_M_ME_TD_1,
    LOG_M_ME_TE_1,
    LOG_M_ME_TF_1,
    LOG_M_IT_TB_1,
    LOG_M_EP_TD_1,
    LOG_M_EP_TE_1,
    LOG_M_EP_TF_1,
    LOG_C_SC_NA_1,
    LOG_C_DC_NA_1,
    LOG_C_RC_NA_1,
    LOG_C_SE_NA_1,
    LOG_C_SE_NB_1,
    LOG_C_SE_NC_1,
    LOG_C_BO_NA_1,
    LOG_C_SC_TA_1,
    LOG_C_DC_TA_1,
    LOG_C_RC_TA_1,
    LOG_C_SE_TA_1,
    LOG_C_SE_TB_1,
    LOG_C_SE_TC_1,
    LOG_C_BO_TA_1,
    LOG_M_EI_NA_1,
    LOG_C_IC_NA_1,
    LOG_C_CI_NA_1,
    LOG_C_RD_NA_1,
    LOG_C_CS_NA_1,
    LOG_C_RP_NA_1,
    LOG_C_TS_TA_1,
    LOG_P_ME_NA_1,
    LOG_P_ME_NB_1,
    LOG_P_ME_NC_1,
    LOG_P_AC_NA_1,
    LOG_F_FR_NA_1,
    LOG_F_SR_NA_1,
    LOG_F_SC_NA_1,
    LOG_F_LS_NA_1,
    LOG_F_AF_NA_1,
    LOG_F_SG_NA_1,
    LOG_APCI_U,
    LOG_APCI_S,
    LOG_APCI_I,
    LOG_SVA_QOS,
    LOG_DIQ_CP56Time2a,
    LOG_DIQ_CP24Time2a,
    LOG_UNK,
};

type M_SP_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_SP_NA_1_io;
} &log;

type M_SP_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_SP_TA_1_io;
} &log;

type M_DP_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_DP_NA_1_io;
} &log;

type M_DP_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_DP_TA_1_io;
} &log;

type M_ST_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ST_NA_1_io;
} &log;

type M_ST_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ST_TA_1_io;
} &log;

type M_BO_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_BO_NA_1_io;
} &log;

type M_BO_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_BO_TA_1_io;
} &log;

type M_ME_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_NA_1_io;
} &log;

type M_ME_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TA_1_io;
} &log;

type M_ME_NB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_NB_1_io;
} &log;

type M_ME_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TB_1_io;
} &log;

type M_ME_NC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_NC_1_io;
} &log;

type M_ME_TC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TC_1_io;
} &log;

type M_IT_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_IT_NA_1_io;
} &log;

type M_IT_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_IT_TA_1_io;
} &log;

type M_EP_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TA_1_io;
} &log;

type M_EP_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TB_1_io;
} &log;

type M_EP_TC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TC_1_io;
} &log;

type M_PS_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_PS_NA_1_io;
} &log;

type M_ME_ND_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_ND_1_io;
} &log;

type M_SP_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_SP_TB_1_io;
} &log;

type M_DP_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_DP_TB_1_io;
} &log;

type M_ST_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ST_TB_1_io;
} &log;

type M_BO_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_BO_TB_1_io;
} &log;

type M_ME_TD_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TD_1_io;
} &log;

type M_ME_TE_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TE_1_io;
} &log;

type M_ME_TF_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_ME_TF_1_io;
} &log;

type M_IT_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_IT_TB_1_io;
} &log;

type M_EP_TD_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TD_1_io;
} &log;

type M_EP_TE_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TE_1_io;
} &log;

type M_EP_TF_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EP_TF_1_io;
} &log;

type C_SC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SC_NA_1_io;
} &log;

type C_DC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_DC_NA_1_io;
} &log;

type C_RC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_RC_NA_1_io;
} &log;

type C_SE_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_NA_1_io;
} &log;

type C_SE_NB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_NB_1_io;
} &log;

type C_SE_NC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_NC_1_io;
} &log;

type C_BO_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_BO_NA_1_io;
} &log;

type C_SC_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SC_TA_1_io;
} &log;

type C_DC_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_DC_TA_1_io;
} &log;

type C_RC_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_RC_TA_1_io;
} &log;

type C_SE_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_TA_1_io;
} &log;

type C_SE_TB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_TB_1_io;
} &log;

type C_SE_TC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_SE_TC_1_io;
} &log;

type C_BO_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_BO_TA_1_io;
} &log;

type M_EI_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: M_EI_NA_1_io;
} &log;

type C_IC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_IC_NA_1_io;
} &log;

type C_CI_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_CI_NA_1_io;
} &log;

type C_RD_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_RD_NA_1_io;
} &log;

type C_CS_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_CS_NA_1_io;
} &log;

type C_RP_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_RP_NA_1_io;
} &log;

type C_TS_TA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: C_TS_TA_1_io;
} &log;

type P_ME_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: P_ME_NA_1_io;
} &log;

type P_ME_NB_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: P_ME_NB_1_io;
} &log;

type P_ME_NC_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: P_ME_NC_1_io;
} &log;

type P_AC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: P_AC_NA_1_io;
} &log;

type F_FR_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_FR_NA_1_io;
} &log;

type F_SR_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_SR_NA_1_io;
} &log;

type F_SC_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_SC_NA_1_io;
} &log;

type F_LS_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_LS_NA_1_io;
} &log;

type F_AF_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_AF_NA_1_io;
} &log;

type F_SG_NA_1_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    io: F_SG_NA_1_io;
} &log;

type AsduIdent_log: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    ident: AsduIdent;
} &log;

type APCI_S: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    rsn: count;
} &log;

type APCI_U: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    startdt: count;
    stopdt: count;
    testfr: count;
} &log;

type APCI_I: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    ssn: count;
    rsn: count;
} &log;

type UNK: record {
    ts: time;
    uid: string;
    id: conn_id;
    is_orig: bool;
    apdu: count;
    type_id: ::IEC104TypeID;
    data: string;
} &log;

redef record connection += {
    apdu_counter: count &default=0;
};


function add_log(id: Log::ID, stream: Log::Stream, json: bool)
{
    Log::create_stream(id, stream);
    if (json) {
        local filter = Log::get_filter(id, "default");
        filter$config = table(["use_json"] = "T",
                              ["json_timestamps"] = "JSON::TS_ISO8601");
        Log::add_filter(id, filter);
    }
}

event zeek_init() &priority=5
{
    add_log(LOG_ASDU_IDENT, [$columns=AsduIdent_log, $path="iec104-asdu-ident"], log_as_json);
    add_log(LOG_M_SP_NA_1, [$columns=M_SP_NA_1_log, $path="iec104-M_SP_NA_1"], log_as_json);
    add_log(LOG_M_SP_TA_1, [$columns=M_SP_TA_1_log, $path="iec104-M_SP_TA_1"], log_as_json);
    add_log(LOG_M_DP_NA_1, [$columns=M_DP_NA_1_log, $path="iec104-M_DP_NA_1"], log_as_json);
    add_log(LOG_M_DP_TA_1, [$columns=M_DP_TA_1_log, $path="iec104-M_DP_TA_1"], log_as_json);
    add_log(LOG_M_ST_NA_1, [$columns=M_ST_NA_1_log, $path="iec104-M_ST_NA_1"], log_as_json);
    add_log(LOG_M_ST_TA_1, [$columns=M_ST_TA_1_log, $path="iec104-M_ST_TA_1"], log_as_json);
    add_log(LOG_M_BO_NA_1, [$columns=M_BO_NA_1_log, $path="iec104-M_BO_NA_1"], log_as_json);
    add_log(LOG_M_BO_TA_1, [$columns=M_BO_TA_1_log, $path="iec104-M_BO_TA_1"], log_as_json);
    add_log(LOG_M_ME_NA_1, [$columns=M_ME_NA_1_log, $path="iec104-M_ME_NA_1"], log_as_json);
    add_log(LOG_M_ME_TA_1, [$columns=M_ME_TA_1_log, $path="iec104-M_ME_TA_1"], log_as_json);
    add_log(LOG_M_ME_NB_1, [$columns=M_ME_NB_1_log, $path="iec104-M_ME_NB_1"], log_as_json);
    add_log(LOG_M_ME_TB_1, [$columns=M_ME_TB_1_log, $path="iec104-M_ME_TB_1"], log_as_json);
    add_log(LOG_M_ME_NC_1, [$columns=M_ME_NC_1_log, $path="iec104-M_ME_NC_1"], log_as_json);
    add_log(LOG_M_ME_TC_1, [$columns=M_ME_TC_1_log, $path="iec104-M_ME_TC_1"], log_as_json);
    add_log(LOG_M_IT_NA_1, [$columns=M_IT_NA_1_log, $path="iec104-M_IT_NA_1"], log_as_json);
    add_log(LOG_M_IT_TA_1, [$columns=M_IT_TA_1_log, $path="iec104-M_IT_TA_1"], log_as_json);
    add_log(LOG_M_EP_TA_1, [$columns=M_EP_TA_1_log, $path="iec104-M_EP_TA_1"], log_as_json);
    add_log(LOG_M_EP_TB_1, [$columns=M_EP_TB_1_log, $path="iec104-M_EP_TB_1"], log_as_json);
    add_log(LOG_M_EP_TC_1, [$columns=M_EP_TC_1_log, $path="iec104-M_EP_TC_1"], log_as_json);
    add_log(LOG_M_PS_NA_1, [$columns=M_PS_NA_1_log, $path="iec104-M_PS_NA_1"], log_as_json);
    add_log(LOG_M_ME_ND_1, [$columns=M_ME_ND_1_log, $path="iec104-M_ME_ND_1"], log_as_json);
    add_log(LOG_M_SP_TB_1, [$columns=M_SP_TB_1_log, $path="iec104-M_SP_TB_1"], log_as_json);
    add_log(LOG_M_DP_TB_1, [$columns=M_DP_TB_1_log, $path="iec104-M_DP_TB_1"], log_as_json);
    add_log(LOG_M_ST_TB_1, [$columns=M_ST_TB_1_log, $path="iec104-M_ST_TB_1"], log_as_json);
    add_log(LOG_M_BO_TB_1, [$columns=M_BO_TB_1_log, $path="iec104-M_BO_TB_1"], log_as_json);
    add_log(LOG_M_ME_TD_1, [$columns=M_ME_TD_1_log, $path="iec104-M_ME_TD_1"], log_as_json);
    add_log(LOG_M_ME_TE_1, [$columns=M_ME_TE_1_log, $path="iec104-M_ME_TE_1"], log_as_json);
    add_log(LOG_M_ME_TF_1, [$columns=M_ME_TF_1_log, $path="iec104-M_ME_TF_1"], log_as_json);
    add_log(LOG_M_IT_TB_1, [$columns=M_IT_TB_1_log, $path="iec104-M_IT_TB_1"], log_as_json);
    add_log(LOG_M_EP_TD_1, [$columns=M_EP_TD_1_log, $path="iec104-M_EP_TD_1"], log_as_json);
    add_log(LOG_M_EP_TE_1, [$columns=M_EP_TE_1_log, $path="iec104-M_EP_TE_1"], log_as_json);
    add_log(LOG_M_EP_TF_1, [$columns=M_EP_TF_1_log, $path="iec104-M_EP_TF_1"], log_as_json);
    add_log(LOG_C_SC_NA_1, [$columns=C_SC_NA_1_log, $path="iec104-C_SC_NA_1"], log_as_json);
    add_log(LOG_C_DC_NA_1, [$columns=C_DC_NA_1_log, $path="iec104-C_DC_NA_1"], log_as_json);
    add_log(LOG_C_RC_NA_1, [$columns=C_RC_NA_1_log, $path="iec104-C_RC_NA_1"], log_as_json);
    add_log(LOG_C_SE_NA_1, [$columns=C_SE_NA_1_log, $path="iec104-C_SE_NA_1"], log_as_json);
    add_log(LOG_C_SE_NB_1, [$columns=C_SE_NB_1_log, $path="iec104-C_SE_NB_1"], log_as_json);
    add_log(LOG_C_SE_NC_1, [$columns=C_SE_NC_1_log, $path="iec104-C_SE_NC_1"], log_as_json);
    add_log(LOG_C_BO_NA_1, [$columns=C_BO_NA_1_log, $path="iec104-C_BO_NA_1"], log_as_json);
    add_log(LOG_C_SC_TA_1, [$columns=C_SC_TA_1_log, $path="iec104-C_SC_TA_1"], log_as_json);
    add_log(LOG_C_DC_TA_1, [$columns=C_DC_TA_1_log, $path="iec104-C_DC_TA_1"], log_as_json);
    add_log(LOG_C_RC_TA_1, [$columns=C_RC_TA_1_log, $path="iec104-C_RC_TA_1"], log_as_json);
    add_log(LOG_C_SE_TA_1, [$columns=C_SE_TA_1_log, $path="iec104-C_SE_TA_1"], log_as_json);
    add_log(LOG_C_SE_TB_1, [$columns=C_SE_TB_1_log, $path="iec104-C_SE_TB_1"], log_as_json);
    add_log(LOG_C_SE_TC_1, [$columns=C_SE_TC_1_log, $path="iec104-C_SE_TC_1"], log_as_json);
    add_log(LOG_C_BO_TA_1, [$columns=C_BO_TA_1_log, $path="iec104-C_BO_TA_1"], log_as_json);
    add_log(LOG_M_EI_NA_1, [$columns=M_EI_NA_1_log, $path="iec104-M_EI_NA_1"], log_as_json);
    add_log(LOG_C_IC_NA_1, [$columns=C_IC_NA_1_log, $path="iec104-C_IC_NA_1"], log_as_json);
    add_log(LOG_C_CI_NA_1, [$columns=C_CI_NA_1_log, $path="iec104-C_CI_NA_1"], log_as_json);
    add_log(LOG_C_RD_NA_1, [$columns=C_RD_NA_1_log, $path="iec104-C_RD_NA_1"], log_as_json);
    add_log(LOG_C_CS_NA_1, [$columns=C_CS_NA_1_log, $path="iec104-C_CS_NA_1"], log_as_json);
    add_log(LOG_C_RP_NA_1, [$columns=C_RP_NA_1_log, $path="iec104-C_RP_NA_1"], log_as_json);
    add_log(LOG_C_TS_TA_1, [$columns=C_TS_TA_1_log, $path="iec104-C_TS_TA_1"], log_as_json);
    add_log(LOG_P_ME_NA_1, [$columns=P_ME_NA_1_log, $path="iec104-P_ME_NA_1"], log_as_json);
    add_log(LOG_P_ME_NB_1, [$columns=P_ME_NB_1_log, $path="iec104-P_ME_NB_1"], log_as_json);
    add_log(LOG_P_ME_NC_1, [$columns=P_ME_NC_1_log, $path="iec104-P_ME_NC_1"], log_as_json);
    add_log(LOG_P_AC_NA_1, [$columns=P_AC_NA_1_log, $path="iec104-P_AC_NA_1"], log_as_json);
    add_log(LOG_F_FR_NA_1, [$columns=F_FR_NA_1_log, $path="iec104-F_FR_NA_1"], log_as_json);
    add_log(LOG_F_SR_NA_1, [$columns=F_SR_NA_1_log, $path="iec104-F_SR_NA_1"], log_as_json);
    add_log(LOG_F_SC_NA_1, [$columns=F_SC_NA_1_log, $path="iec104-F_SC_NA_1"], log_as_json);
    add_log(LOG_F_LS_NA_1, [$columns=F_LS_NA_1_log, $path="iec104-F_LS_NA_1"], log_as_json);
    add_log(LOG_F_AF_NA_1, [$columns=F_AF_NA_1_log, $path="iec104-F_AF_NA_1"], log_as_json);
    add_log(LOG_F_SG_NA_1, [$columns=F_SG_NA_1_log, $path="iec104-F_SG_NA_1"], log_as_json);
    add_log(LOG_APCI_U, [$columns=APCI_U, $path="iec104-apci_u"], log_as_json);
    add_log(LOG_APCI_S, [$columns=APCI_S, $path="iec104-apci_s"], log_as_json);
    add_log(LOG_APCI_I, [$columns=APCI_I, $path="iec104-apci_i"], log_as_json);
    add_log(LOG_UNK, [$columns=UNK, $path="iec104-unk"], log_as_json);
}

event iec104::s
    (c: connection, is_orig: bool, rsn: count)
    &priority=-5
{
    c$apdu_counter += 1;
    local rec = APCI_S($ts=network_time(),
                       $uid=c$uid,
                       $id=c$id,
                       $is_orig=is_orig,
                       $apdu=c$apdu_counter,
                       $rsn=rsn);
    Log::write(iec104::LOG_APCI_S, rec);
}

event iec104::u
    (c: connection, is_orig: bool, startdt: count, stopdt: count, testfr: count)
    &priority=-5
{
    c$apdu_counter += 1;
    local rec = APCI_U($ts=network_time(),
                       $uid=c$uid,
                       $id=c$id,
                       $is_orig=is_orig,
                       $apdu=c$apdu_counter,
                       $startdt=startdt,
                       $stopdt=stopdt,
                       $testfr=testfr);
    Log::write(iec104::LOG_APCI_U, rec);
}

event iec104::i
    (c: connection, is_orig: bool, ssn: count, rsn: count)
    &priority=-5
{
    c$apdu_counter += 1;
    local rec = APCI_I($ts=network_time(),
                       $uid=c$uid,
                       $id=c$id,
                       $is_orig=is_orig,
                       $apdu=c$apdu_counter,
                       $ssn=ssn,
                       $rsn=rsn);
    Log::write(iec104::LOG_APCI_I, rec);
}

event iec104::asdu
    (c: connection, is_orig: bool, ident: AsduIdent)
    &priority=-5
{
    local rec = AsduIdent_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $ident=ident);
    Log::write(iec104::LOG_ASDU_IDENT, rec);
}

event iec104::m_sp_na_1
    (c: connection, is_orig: bool, io: M_SP_NA_1_io)
    &priority=-5
{
    local rec = M_SP_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_SP_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_SP_NA_1, rec);
}

event iec104::m_sp_ta_1
    (c: connection, is_orig: bool, io: M_SP_TA_1_io)
    &priority=-5
{
    local rec = M_SP_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_SP_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_SP_TA_1, rec);
}

event iec104::m_dp_na_1
    (c: connection, is_orig: bool, io: M_DP_NA_1_io)
    &priority=-5
{
    local rec = M_DP_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_DP_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_DP_NA_1, rec);
}

event iec104::m_dp_ta_1
    (c: connection, is_orig: bool, io: M_DP_TA_1_io)
    &priority=-5
{
    local rec = M_DP_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_DP_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_DP_TA_1, rec);
}

event iec104::m_st_na_1
    (c: connection, is_orig: bool, io: M_ST_NA_1_io)
    &priority=-5
{
    local rec = M_ST_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ST_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_ST_NA_1, rec);
}

event iec104::m_st_ta_1
    (c: connection, is_orig: bool, io: M_ST_TA_1_io)
    &priority=-5
{
    local rec = M_ST_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ST_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_ST_TA_1, rec);
}

event iec104::m_bo_na_1
    (c: connection, is_orig: bool, io: M_BO_NA_1_io)
    &priority=-5
{
    local rec = M_BO_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_BO_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_BO_NA_1, rec);
}

event iec104::m_bo_ta_1
    (c: connection, is_orig: bool, io: M_BO_TA_1_io)
    &priority=-5
{
    local rec = M_BO_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_BO_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_BO_TA_1, rec);
}

event iec104::m_me_na_1
    (c: connection, is_orig: bool, io: M_ME_NA_1_io)
    &priority=-5
{
    local rec = M_ME_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_NA_1, rec);
}

event iec104::m_me_ta_1
    (c: connection, is_orig: bool, io: M_ME_TA_1_io)
    &priority=-5
{
    local rec = M_ME_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TA_1, rec);
}

event iec104::m_me_nb_1
    (c: connection, is_orig: bool, io: M_ME_NB_1_io)
    &priority=-5
{
    local rec = M_ME_NB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_NB_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_NB_1, rec);
}

event iec104::m_me_tb_1
    (c: connection, is_orig: bool, io: M_ME_TB_1_io)
    &priority=-5
{
    local rec = M_ME_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TB_1, rec);
}

event iec104::m_me_nc_1
    (c: connection, is_orig: bool, io: M_ME_NC_1_io)
    &priority=-5
{
    local rec = M_ME_NC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_NC_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_NC_1, rec);
}

event iec104::m_me_tc_1
    (c: connection, is_orig: bool, io: M_ME_TC_1_io)
    &priority=-5
{
    local rec = M_ME_TC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TC_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TC_1, rec);
}

event iec104::m_it_na_1
    (c: connection, is_orig: bool, io: M_IT_NA_1_io)
    &priority=-5
{
    local rec = M_IT_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_IT_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_IT_NA_1, rec);
}

event iec104::m_it_ta_1
    (c: connection, is_orig: bool, io: M_IT_TA_1_io)
    &priority=-5
{
    local rec = M_IT_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_IT_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_IT_TA_1, rec);
}

event iec104::m_ep_ta_1
    (c: connection, is_orig: bool, io: M_EP_TA_1_io)
    &priority=-5
{
    local rec = M_EP_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TA_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TA_1, rec);
}

event iec104::m_ep_tb_1
    (c: connection, is_orig: bool, io: M_EP_TB_1_io)
    &priority=-5
{
    local rec = M_EP_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TB_1, rec);
}

event iec104::m_ep_tc_1
    (c: connection, is_orig: bool, io: M_EP_TC_1_io)
    &priority=-5
{
    local rec = M_EP_TC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TC_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TC_1, rec);
}

event iec104::m_ps_na_1
    (c: connection, is_orig: bool, io: M_PS_NA_1_io)
    &priority=-5
{
    local rec = M_PS_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_PS_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_PS_NA_1, rec);
}

event iec104::m_me_nd_1
    (c: connection, is_orig: bool, io: M_ME_ND_1_io)
    &priority=-5
{
    local rec = M_ME_ND_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_ND_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_ND_1, rec);
}

event iec104::m_sp_tb_1
    (c: connection, is_orig: bool, io: M_SP_TB_1_io)
    &priority=-5
{
    local rec = M_SP_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_SP_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_SP_TB_1, rec);
}

event iec104::m_dp_tb_1
    (c: connection, is_orig: bool, io: M_DP_TB_1_io)
    &priority=-5
{
    local rec = M_DP_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_DP_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_DP_TB_1, rec);
}

event iec104::m_st_tb_1
    (c: connection, is_orig: bool, io: M_ST_TB_1_io)
    &priority=-5
{
    local rec = M_ST_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ST_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_ST_TB_1, rec);
}

event iec104::m_bo_tb_1
    (c: connection, is_orig: bool, io: M_BO_TB_1_io)
    &priority=-5
{
    local rec = M_BO_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_BO_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_BO_TB_1, rec);
}

event iec104::m_me_td_1
    (c: connection, is_orig: bool, io: M_ME_TD_1_io)
    &priority=-5
{
    local rec = M_ME_TD_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TD_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TD_1, rec);
}

event iec104::m_me_te_1
    (c: connection, is_orig: bool, io: M_ME_TE_1_io)
    &priority=-5
{
    local rec = M_ME_TE_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TE_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TE_1, rec);
}

event iec104::m_me_tf_1
    (c: connection, is_orig: bool, io: M_ME_TF_1_io)
    &priority=-5
{
    local rec = M_ME_TF_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_ME_TF_1,
        $io=io);
    Log::write(iec104::LOG_M_ME_TF_1, rec);
}

event iec104::m_it_tb_1
    (c: connection, is_orig: bool, io: M_IT_TB_1_io)
    &priority=-5
{
    local rec = M_IT_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_IT_TB_1,
        $io=io);
    Log::write(iec104::LOG_M_IT_TB_1, rec);
}

event iec104::m_ep_td_1
    (c: connection, is_orig: bool, io: M_EP_TD_1_io)
    &priority=-5
{
    local rec = M_EP_TD_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TD_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TD_1, rec);
}

event iec104::m_ep_te_1
    (c: connection, is_orig: bool, io: M_EP_TE_1_io)
    &priority=-5
{
    local rec = M_EP_TE_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TE_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TE_1, rec);
}

event iec104::m_ep_tf_1
    (c: connection, is_orig: bool, io: M_EP_TF_1_io)
    &priority=-5
{
    local rec = M_EP_TF_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EP_TF_1,
        $io=io);
    Log::write(iec104::LOG_M_EP_TF_1, rec);
}

event iec104::c_sc_na_1
    (c: connection, is_orig: bool, io: C_SC_NA_1_io)
    &priority=-5
{
    local rec = C_SC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SC_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_SC_NA_1, rec);
}

event iec104::c_dc_na_1
    (c: connection, is_orig: bool, io: C_DC_NA_1_io)
    &priority=-5
{
    local rec = C_DC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_DC_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_DC_NA_1, rec);
}

event iec104::c_rc_na_1
    (c: connection, is_orig: bool, io: C_RC_NA_1_io)
    &priority=-5
{
    local rec = C_RC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_RC_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_RC_NA_1, rec);
}

event iec104::c_se_na_1
    (c: connection, is_orig: bool, io: C_SE_NA_1_io)
    &priority=-5
{
    local rec = C_SE_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_NA_1, rec);
}

event iec104::c_se_nb_1
    (c: connection, is_orig: bool, io: C_SE_NB_1_io)
    &priority=-5
{
    local rec = C_SE_NB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_NB_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_NB_1, rec);
}

event iec104::c_se_nc_1
    (c: connection, is_orig: bool, io: C_SE_NC_1_io)
    &priority=-5
{
    local rec = C_SE_NC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_NC_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_NC_1, rec);
}

event iec104::c_bo_na_1
    (c: connection, is_orig: bool, io: C_BO_NA_1_io)
    &priority=-5
{
    local rec = C_BO_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_BO_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_BO_NA_1, rec);
}

event iec104::c_sc_ta_1
    (c: connection, is_orig: bool, io: C_SC_TA_1_io)
    &priority=-5
{
    local rec = C_SC_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SC_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_SC_TA_1, rec);
}

event iec104::c_dc_ta_1
    (c: connection, is_orig: bool, io: C_DC_TA_1_io)
    &priority=-5
{
    local rec = C_DC_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_DC_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_DC_TA_1, rec);
}

event iec104::c_rc_ta_1
    (c: connection, is_orig: bool, io: C_RC_TA_1_io)
    &priority=-5
{
    local rec = C_RC_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_RC_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_RC_TA_1, rec);
}

event iec104::c_se_ta_1
    (c: connection, is_orig: bool, io: C_SE_TA_1_io)
    &priority=-5
{
    local rec = C_SE_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_TA_1, rec);
}

event iec104::c_se_tb_1
    (c: connection, is_orig: bool, io: C_SE_TB_1_io)
    &priority=-5
{
    local rec = C_SE_TB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_TB_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_TB_1, rec);
}

event iec104::c_se_tc_1
    (c: connection, is_orig: bool, io: C_SE_TC_1_io)
    &priority=-5
{
    local rec = C_SE_TC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_SE_TC_1,
        $io=io);
    Log::write(iec104::LOG_C_SE_TC_1, rec);
}

event iec104::c_bo_ta_1
    (c: connection, is_orig: bool, io: C_BO_TA_1_io)
    &priority=-5
{
    local rec = C_BO_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_BO_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_BO_TA_1, rec);
}

event iec104::m_ei_na_1
    (c: connection, is_orig: bool, io: M_EI_NA_1_io)
    &priority=-5
{
    local rec = M_EI_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=M_EI_NA_1,
        $io=io);
    Log::write(iec104::LOG_M_EI_NA_1, rec);
}

event iec104::c_ic_na_1
    (c: connection, is_orig: bool, io: C_IC_NA_1_io)
    &priority=-5
{
    local rec = C_IC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_IC_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_IC_NA_1, rec);
}

event iec104::c_ci_na_1
    (c: connection, is_orig: bool, io: C_CI_NA_1_io)
    &priority=-5
{
    local rec = C_CI_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_CI_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_CI_NA_1, rec);
}

event iec104::c_rd_na_1
    (c: connection, is_orig: bool, io: C_RD_NA_1_io)
    &priority=-5
{
    local rec = C_RD_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_RD_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_RD_NA_1, rec);
}

event iec104::c_cs_na_1
    (c: connection, is_orig: bool, io: C_CS_NA_1_io)
    &priority=-5
{
    local rec = C_CS_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_CS_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_CS_NA_1, rec);
}

event iec104::c_rp_na_1
    (c: connection, is_orig: bool, io: C_RP_NA_1_io)
    &priority=-5
{
    local rec = C_RP_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_RP_NA_1,
        $io=io);
    Log::write(iec104::LOG_C_RP_NA_1, rec);
}

event iec104::c_ts_ta_1
    (c: connection, is_orig: bool, io: C_TS_TA_1_io)
    &priority=-5
{
    local rec = C_TS_TA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=C_TS_TA_1,
        $io=io);
    Log::write(iec104::LOG_C_TS_TA_1, rec);
}

event iec104::p_me_na_1
    (c: connection, is_orig: bool, io: P_ME_NA_1_io)
    &priority=-5
{
    local rec = P_ME_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=P_ME_NA_1,
        $io=io);
    Log::write(iec104::LOG_P_ME_NA_1, rec);
}

event iec104::p_me_nb_1
    (c: connection, is_orig: bool, io: P_ME_NB_1_io)
    &priority=-5
{
    local rec = P_ME_NB_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=P_ME_NB_1,
        $io=io);
    Log::write(iec104::LOG_P_ME_NB_1, rec);
}

event iec104::p_me_nc_1
    (c: connection, is_orig: bool, io: P_ME_NC_1_io)
    &priority=-5
{
    local rec = P_ME_NC_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=P_ME_NC_1,
        $io=io);
    Log::write(iec104::LOG_P_ME_NC_1, rec);
}

event iec104::p_ac_na_1
    (c: connection, is_orig: bool, io: P_AC_NA_1_io)
    &priority=-5
{
    local rec = P_AC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=P_AC_NA_1,
        $io=io);
    Log::write(iec104::LOG_P_AC_NA_1, rec);
}

event iec104::f_fr_na_1
    (c: connection, is_orig: bool, io: F_FR_NA_1_io)
    &priority=-5
{
    local rec = F_FR_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_FR_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_FR_NA_1, rec);
}

event iec104::f_sr_na_1
    (c: connection, is_orig: bool, io: F_SR_NA_1_io)
    &priority=-5
{
    local rec = F_SR_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_SR_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_SR_NA_1, rec);
}

event iec104::f_sc_na_1
    (c: connection, is_orig: bool, io: F_SC_NA_1_io)
    &priority=-5
{
    local rec = F_SC_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_SC_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_SC_NA_1, rec);
}

event iec104::f_ls_na_1
    (c: connection, is_orig: bool, io: F_LS_NA_1_io)
    &priority=-5
{
    local rec = F_LS_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_LS_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_LS_NA_1, rec);
}

event iec104::f_af_na_1
    (c: connection, is_orig: bool, io: F_AF_NA_1_io)
    &priority=-5
{
    local rec = F_AF_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_AF_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_AF_NA_1, rec);
}

event iec104::f_sg_na_1
    (c: connection, is_orig: bool, io: F_SG_NA_1_io)
    &priority=-5
{
    local rec = F_SG_NA_1_log(
        $ts=network_time(),
        $uid=c$uid,
        $id=c$id,
        $is_orig=is_orig,
        $apdu=c$apdu_counter,
        $type_id=F_SG_NA_1,
        $io=io);
    Log::write(iec104::LOG_F_SG_NA_1, rec);
}

event iec104::unknown_asdu
    (c: connection, is_orig: bool, type_id: ::IEC104TypeID, hex: string)
    &priority=-5
{
    local rec = UNK($ts=network_time(),
                    $uid=c$uid,
                    $id=c$id,
                    $is_orig=is_orig,
                    $apdu=c$apdu_counter,
                    $type_id=type_id,
                    $data=hex);
    Log::write(iec104::LOG_UNK, rec);
}
