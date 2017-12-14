-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
cc.exports.RedPacketMessage_pb = {}
module('RedPacketMessage_pb')


local SENDREDPACKETMSG = protobuf.Descriptor();
local SENDREDPACKETMSG_PACKETID_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_GAMEID_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_PLAYERNAME_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_ACTIVITYID_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_SHARECODE_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_ACTIVITYNAME_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_ACTIVITYDESC_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_RESULTCODE_FIELD = protobuf.FieldDescriptor();
local SENDREDPACKETMSG_RESULTMESSAGE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG = protobuf.Descriptor();
local OPENREDPACKETREQMSG_PACKETID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_GAMEID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_SHARECODE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_ACTIVITYID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_PLAYERNAME_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_WXOPENID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETREQMSG_USERID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG = protobuf.Descriptor();
local OPENREDPACKETRSPMSG_PRIZE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_PRIZETYPE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_SHARELINK_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_PACKETID_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_RESULTCODE_FIELD = protobuf.FieldDescriptor();
local OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETREQMSG = protobuf.Descriptor();
local GETREDPACKETREQMSG_PACKETID_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETREQMSG_USERID_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETREQMSG_GAMEID_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETREQMSG_PRIZETYPE_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETRSPMSG = protobuf.Descriptor();
local GETREDPACKETRSPMSG_PACKETID_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETRSPMSG_PACKETSTATUS_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETRSPMSG_RESULTCODE_FIELD = protobuf.FieldDescriptor();
local GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETREQMSG = protobuf.Descriptor();
local QUERYREDPACKETREQMSG_USERID_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETREQMSG_PLAYERNAME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETREQMSG_GAMEID_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG = protobuf.Descriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO = protobuf.Descriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_REDPACKETS_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_STARTTIME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_ENDTIME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_RESULTCODE_FIELD = protobuf.FieldDescriptor();
local QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD = protobuf.FieldDescriptor();

SENDREDPACKETMSG_PACKETID_FIELD.name = "packetId"
SENDREDPACKETMSG_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.packetId"
SENDREDPACKETMSG_PACKETID_FIELD.number = 1
SENDREDPACKETMSG_PACKETID_FIELD.index = 0
SENDREDPACKETMSG_PACKETID_FIELD.label = 2
SENDREDPACKETMSG_PACKETID_FIELD.has_default_value = false
SENDREDPACKETMSG_PACKETID_FIELD.default_value = 0
SENDREDPACKETMSG_PACKETID_FIELD.type = 3
SENDREDPACKETMSG_PACKETID_FIELD.cpp_type = 2

SENDREDPACKETMSG_GAMEID_FIELD.name = "gameId"
SENDREDPACKETMSG_GAMEID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.gameId"
SENDREDPACKETMSG_GAMEID_FIELD.number = 2
SENDREDPACKETMSG_GAMEID_FIELD.index = 1
SENDREDPACKETMSG_GAMEID_FIELD.label = 1
SENDREDPACKETMSG_GAMEID_FIELD.has_default_value = false
SENDREDPACKETMSG_GAMEID_FIELD.default_value = ""
SENDREDPACKETMSG_GAMEID_FIELD.type = 9
SENDREDPACKETMSG_GAMEID_FIELD.cpp_type = 9

SENDREDPACKETMSG_PLAYERNAME_FIELD.name = "playerName"
SENDREDPACKETMSG_PLAYERNAME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.playerName"
SENDREDPACKETMSG_PLAYERNAME_FIELD.number = 3
SENDREDPACKETMSG_PLAYERNAME_FIELD.index = 2
SENDREDPACKETMSG_PLAYERNAME_FIELD.label = 1
SENDREDPACKETMSG_PLAYERNAME_FIELD.has_default_value = false
SENDREDPACKETMSG_PLAYERNAME_FIELD.default_value = ""
SENDREDPACKETMSG_PLAYERNAME_FIELD.type = 9
SENDREDPACKETMSG_PLAYERNAME_FIELD.cpp_type = 9

SENDREDPACKETMSG_ACTIVITYID_FIELD.name = "activityId"
SENDREDPACKETMSG_ACTIVITYID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.activityId"
SENDREDPACKETMSG_ACTIVITYID_FIELD.number = 4
SENDREDPACKETMSG_ACTIVITYID_FIELD.index = 3
SENDREDPACKETMSG_ACTIVITYID_FIELD.label = 1
SENDREDPACKETMSG_ACTIVITYID_FIELD.has_default_value = false
SENDREDPACKETMSG_ACTIVITYID_FIELD.default_value = 0
SENDREDPACKETMSG_ACTIVITYID_FIELD.type = 5
SENDREDPACKETMSG_ACTIVITYID_FIELD.cpp_type = 1

SENDREDPACKETMSG_SHARECODE_FIELD.name = "shareCode"
SENDREDPACKETMSG_SHARECODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.shareCode"
SENDREDPACKETMSG_SHARECODE_FIELD.number = 5
SENDREDPACKETMSG_SHARECODE_FIELD.index = 4
SENDREDPACKETMSG_SHARECODE_FIELD.label = 1
SENDREDPACKETMSG_SHARECODE_FIELD.has_default_value = false
SENDREDPACKETMSG_SHARECODE_FIELD.default_value = ""
SENDREDPACKETMSG_SHARECODE_FIELD.type = 9
SENDREDPACKETMSG_SHARECODE_FIELD.cpp_type = 9

SENDREDPACKETMSG_ACTIVITYNAME_FIELD.name = "activityName"
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.activityName"
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.number = 6
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.index = 5
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.label = 1
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.has_default_value = false
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.default_value = ""
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.type = 9
SENDREDPACKETMSG_ACTIVITYNAME_FIELD.cpp_type = 9

SENDREDPACKETMSG_ACTIVITYDESC_FIELD.name = "activityDesc"
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.activityDesc"
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.number = 7
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.index = 6
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.label = 1
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.has_default_value = false
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.default_value = ""
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.type = 9
SENDREDPACKETMSG_ACTIVITYDESC_FIELD.cpp_type = 9

SENDREDPACKETMSG_RESULTCODE_FIELD.name = "resultCode"
SENDREDPACKETMSG_RESULTCODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.resultCode"
SENDREDPACKETMSG_RESULTCODE_FIELD.number = 8
SENDREDPACKETMSG_RESULTCODE_FIELD.index = 7
SENDREDPACKETMSG_RESULTCODE_FIELD.label = 1
SENDREDPACKETMSG_RESULTCODE_FIELD.has_default_value = false
SENDREDPACKETMSG_RESULTCODE_FIELD.default_value = 0
SENDREDPACKETMSG_RESULTCODE_FIELD.type = 5
SENDREDPACKETMSG_RESULTCODE_FIELD.cpp_type = 1

SENDREDPACKETMSG_RESULTMESSAGE_FIELD.name = "resultMessage"
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg.resultMessage"
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.number = 9
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.index = 8
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.label = 1
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.has_default_value = false
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.default_value = ""
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.type = 9
SENDREDPACKETMSG_RESULTMESSAGE_FIELD.cpp_type = 9

SENDREDPACKETMSG.name = "SendRedPacketMsg"
SENDREDPACKETMSG.full_name = ".com.sparkingfuture.redpacket.netty.SendRedPacketMsg"
SENDREDPACKETMSG.nested_types = {}
SENDREDPACKETMSG.enum_types = {}
SENDREDPACKETMSG.fields = {SENDREDPACKETMSG_PACKETID_FIELD, SENDREDPACKETMSG_GAMEID_FIELD, SENDREDPACKETMSG_PLAYERNAME_FIELD, SENDREDPACKETMSG_ACTIVITYID_FIELD, SENDREDPACKETMSG_SHARECODE_FIELD, SENDREDPACKETMSG_ACTIVITYNAME_FIELD, SENDREDPACKETMSG_ACTIVITYDESC_FIELD, SENDREDPACKETMSG_RESULTCODE_FIELD, SENDREDPACKETMSG_RESULTMESSAGE_FIELD}
SENDREDPACKETMSG.is_extendable = false
SENDREDPACKETMSG.extensions = {}
OPENREDPACKETREQMSG_PACKETID_FIELD.name = "packetId"
OPENREDPACKETREQMSG_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.packetId"
OPENREDPACKETREQMSG_PACKETID_FIELD.number = 1
OPENREDPACKETREQMSG_PACKETID_FIELD.index = 0
OPENREDPACKETREQMSG_PACKETID_FIELD.label = 2
OPENREDPACKETREQMSG_PACKETID_FIELD.has_default_value = false
OPENREDPACKETREQMSG_PACKETID_FIELD.default_value = 0
OPENREDPACKETREQMSG_PACKETID_FIELD.type = 3
OPENREDPACKETREQMSG_PACKETID_FIELD.cpp_type = 2

OPENREDPACKETREQMSG_GAMEID_FIELD.name = "gameId"
OPENREDPACKETREQMSG_GAMEID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.gameId"
OPENREDPACKETREQMSG_GAMEID_FIELD.number = 2
OPENREDPACKETREQMSG_GAMEID_FIELD.index = 1
OPENREDPACKETREQMSG_GAMEID_FIELD.label = 1
OPENREDPACKETREQMSG_GAMEID_FIELD.has_default_value = false
OPENREDPACKETREQMSG_GAMEID_FIELD.default_value = ""
OPENREDPACKETREQMSG_GAMEID_FIELD.type = 9
OPENREDPACKETREQMSG_GAMEID_FIELD.cpp_type = 9

OPENREDPACKETREQMSG_SHARECODE_FIELD.name = "shareCode"
OPENREDPACKETREQMSG_SHARECODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.shareCode"
OPENREDPACKETREQMSG_SHARECODE_FIELD.number = 3
OPENREDPACKETREQMSG_SHARECODE_FIELD.index = 2
OPENREDPACKETREQMSG_SHARECODE_FIELD.label = 1
OPENREDPACKETREQMSG_SHARECODE_FIELD.has_default_value = false
OPENREDPACKETREQMSG_SHARECODE_FIELD.default_value = ""
OPENREDPACKETREQMSG_SHARECODE_FIELD.type = 9
OPENREDPACKETREQMSG_SHARECODE_FIELD.cpp_type = 9

OPENREDPACKETREQMSG_ACTIVITYID_FIELD.name = "activityId"
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.activityId"
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.number = 4
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.index = 3
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.label = 1
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.has_default_value = false
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.default_value = 0
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.type = 5
OPENREDPACKETREQMSG_ACTIVITYID_FIELD.cpp_type = 1

OPENREDPACKETREQMSG_PLAYERNAME_FIELD.name = "playerName"
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.playerName"
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.number = 5
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.index = 4
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.label = 1
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.has_default_value = false
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.default_value = ""
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.type = 9
OPENREDPACKETREQMSG_PLAYERNAME_FIELD.cpp_type = 9

OPENREDPACKETREQMSG_WXOPENID_FIELD.name = "wxOpenId"
OPENREDPACKETREQMSG_WXOPENID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.wxOpenId"
OPENREDPACKETREQMSG_WXOPENID_FIELD.number = 6
OPENREDPACKETREQMSG_WXOPENID_FIELD.index = 5
OPENREDPACKETREQMSG_WXOPENID_FIELD.label = 1
OPENREDPACKETREQMSG_WXOPENID_FIELD.has_default_value = false
OPENREDPACKETREQMSG_WXOPENID_FIELD.default_value = ""
OPENREDPACKETREQMSG_WXOPENID_FIELD.type = 9
OPENREDPACKETREQMSG_WXOPENID_FIELD.cpp_type = 9

OPENREDPACKETREQMSG_USERID_FIELD.name = "userId"
OPENREDPACKETREQMSG_USERID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg.userId"
OPENREDPACKETREQMSG_USERID_FIELD.number = 7
OPENREDPACKETREQMSG_USERID_FIELD.index = 6
OPENREDPACKETREQMSG_USERID_FIELD.label = 1
OPENREDPACKETREQMSG_USERID_FIELD.has_default_value = false
OPENREDPACKETREQMSG_USERID_FIELD.default_value = 0
OPENREDPACKETREQMSG_USERID_FIELD.type = 5
OPENREDPACKETREQMSG_USERID_FIELD.cpp_type = 1

OPENREDPACKETREQMSG.name = "OpenRedPacketReqMsg"
OPENREDPACKETREQMSG.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketReqMsg"
OPENREDPACKETREQMSG.nested_types = {}
OPENREDPACKETREQMSG.enum_types = {}
OPENREDPACKETREQMSG.fields = {OPENREDPACKETREQMSG_PACKETID_FIELD, OPENREDPACKETREQMSG_GAMEID_FIELD, OPENREDPACKETREQMSG_SHARECODE_FIELD, OPENREDPACKETREQMSG_ACTIVITYID_FIELD, OPENREDPACKETREQMSG_PLAYERNAME_FIELD, OPENREDPACKETREQMSG_WXOPENID_FIELD, OPENREDPACKETREQMSG_USERID_FIELD}
OPENREDPACKETREQMSG.is_extendable = false
OPENREDPACKETREQMSG.extensions = {}
OPENREDPACKETRSPMSG_PRIZE_FIELD.name = "prize"
OPENREDPACKETRSPMSG_PRIZE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.prize"
OPENREDPACKETRSPMSG_PRIZE_FIELD.number = 1
OPENREDPACKETRSPMSG_PRIZE_FIELD.index = 0
OPENREDPACKETRSPMSG_PRIZE_FIELD.label = 1
OPENREDPACKETRSPMSG_PRIZE_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_PRIZE_FIELD.default_value = ""
OPENREDPACKETRSPMSG_PRIZE_FIELD.type = 9
OPENREDPACKETRSPMSG_PRIZE_FIELD.cpp_type = 9

OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.name = "prizeType"
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.prizeType"
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.number = 2
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.index = 1
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.label = 1
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.default_value = 0
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.type = 5
OPENREDPACKETRSPMSG_PRIZETYPE_FIELD.cpp_type = 1

OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.name = "isNeedShare"
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.isNeedShare"
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.number = 3
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.index = 2
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.label = 1
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.default_value = 0
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.type = 5
OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD.cpp_type = 1

OPENREDPACKETRSPMSG_SHARELINK_FIELD.name = "shareLink"
OPENREDPACKETRSPMSG_SHARELINK_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.shareLink"
OPENREDPACKETRSPMSG_SHARELINK_FIELD.number = 4
OPENREDPACKETRSPMSG_SHARELINK_FIELD.index = 3
OPENREDPACKETRSPMSG_SHARELINK_FIELD.label = 1
OPENREDPACKETRSPMSG_SHARELINK_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_SHARELINK_FIELD.default_value = ""
OPENREDPACKETRSPMSG_SHARELINK_FIELD.type = 9
OPENREDPACKETRSPMSG_SHARELINK_FIELD.cpp_type = 9

OPENREDPACKETRSPMSG_PACKETID_FIELD.name = "packetId"
OPENREDPACKETRSPMSG_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.packetId"
OPENREDPACKETRSPMSG_PACKETID_FIELD.number = 5
OPENREDPACKETRSPMSG_PACKETID_FIELD.index = 4
OPENREDPACKETRSPMSG_PACKETID_FIELD.label = 1
OPENREDPACKETRSPMSG_PACKETID_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_PACKETID_FIELD.default_value = 0
OPENREDPACKETRSPMSG_PACKETID_FIELD.type = 3
OPENREDPACKETRSPMSG_PACKETID_FIELD.cpp_type = 2

OPENREDPACKETRSPMSG_RESULTCODE_FIELD.name = "resultCode"
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.resultCode"
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.number = 6
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.index = 5
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.label = 1
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.default_value = 0
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.type = 5
OPENREDPACKETRSPMSG_RESULTCODE_FIELD.cpp_type = 1

OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.name = "resultMessage"
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg.resultMessage"
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.number = 7
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.index = 6
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.label = 1
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.has_default_value = false
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.default_value = ""
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.type = 9
OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD.cpp_type = 9

OPENREDPACKETRSPMSG.name = "OpenRedPacketRspMsg"
OPENREDPACKETRSPMSG.full_name = ".com.sparkingfuture.redpacket.netty.OpenRedPacketRspMsg"
OPENREDPACKETRSPMSG.nested_types = {}
OPENREDPACKETRSPMSG.enum_types = {}
OPENREDPACKETRSPMSG.fields = {OPENREDPACKETRSPMSG_PRIZE_FIELD, OPENREDPACKETRSPMSG_PRIZETYPE_FIELD, OPENREDPACKETRSPMSG_ISNEEDSHARE_FIELD, OPENREDPACKETRSPMSG_SHARELINK_FIELD, OPENREDPACKETRSPMSG_PACKETID_FIELD, OPENREDPACKETRSPMSG_RESULTCODE_FIELD, OPENREDPACKETRSPMSG_RESULTMESSAGE_FIELD}
OPENREDPACKETRSPMSG.is_extendable = false
OPENREDPACKETRSPMSG.extensions = {}
GETREDPACKETREQMSG_PACKETID_FIELD.name = "packetId"
GETREDPACKETREQMSG_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg.packetId"
GETREDPACKETREQMSG_PACKETID_FIELD.number = 1
GETREDPACKETREQMSG_PACKETID_FIELD.index = 0
GETREDPACKETREQMSG_PACKETID_FIELD.label = 2
GETREDPACKETREQMSG_PACKETID_FIELD.has_default_value = false
GETREDPACKETREQMSG_PACKETID_FIELD.default_value = 0
GETREDPACKETREQMSG_PACKETID_FIELD.type = 3
GETREDPACKETREQMSG_PACKETID_FIELD.cpp_type = 2

GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.name = "redRedPacketNum"
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg.redRedPacketNum"
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.number = 2
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.index = 1
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.label = 1
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.has_default_value = false
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.default_value = ""
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.type = 9
GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD.cpp_type = 9

GETREDPACKETREQMSG_USERID_FIELD.name = "userId"
GETREDPACKETREQMSG_USERID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg.userId"
GETREDPACKETREQMSG_USERID_FIELD.number = 3
GETREDPACKETREQMSG_USERID_FIELD.index = 2
GETREDPACKETREQMSG_USERID_FIELD.label = 1
GETREDPACKETREQMSG_USERID_FIELD.has_default_value = false
GETREDPACKETREQMSG_USERID_FIELD.default_value = 0
GETREDPACKETREQMSG_USERID_FIELD.type = 5
GETREDPACKETREQMSG_USERID_FIELD.cpp_type = 1

GETREDPACKETREQMSG_GAMEID_FIELD.name = "gameId"
GETREDPACKETREQMSG_GAMEID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg.gameId"
GETREDPACKETREQMSG_GAMEID_FIELD.number = 4
GETREDPACKETREQMSG_GAMEID_FIELD.index = 3
GETREDPACKETREQMSG_GAMEID_FIELD.label = 1
GETREDPACKETREQMSG_GAMEID_FIELD.has_default_value = false
GETREDPACKETREQMSG_GAMEID_FIELD.default_value = ""
GETREDPACKETREQMSG_GAMEID_FIELD.type = 9
GETREDPACKETREQMSG_GAMEID_FIELD.cpp_type = 9

GETREDPACKETREQMSG_PRIZETYPE_FIELD.name = "prizeType"
GETREDPACKETREQMSG_PRIZETYPE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg.prizeType"
GETREDPACKETREQMSG_PRIZETYPE_FIELD.number = 5
GETREDPACKETREQMSG_PRIZETYPE_FIELD.index = 4
GETREDPACKETREQMSG_PRIZETYPE_FIELD.label = 1
GETREDPACKETREQMSG_PRIZETYPE_FIELD.has_default_value = false
GETREDPACKETREQMSG_PRIZETYPE_FIELD.default_value = 0
GETREDPACKETREQMSG_PRIZETYPE_FIELD.type = 5
GETREDPACKETREQMSG_PRIZETYPE_FIELD.cpp_type = 1

GETREDPACKETREQMSG.name = "GetRedPacketReqMsg"
GETREDPACKETREQMSG.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketReqMsg"
GETREDPACKETREQMSG.nested_types = {}
GETREDPACKETREQMSG.enum_types = {}
GETREDPACKETREQMSG.fields = {GETREDPACKETREQMSG_PACKETID_FIELD, GETREDPACKETREQMSG_REDREDPACKETNUM_FIELD, GETREDPACKETREQMSG_USERID_FIELD, GETREDPACKETREQMSG_GAMEID_FIELD, GETREDPACKETREQMSG_PRIZETYPE_FIELD}
GETREDPACKETREQMSG.is_extendable = false
GETREDPACKETREQMSG.extensions = {}
GETREDPACKETRSPMSG_PACKETID_FIELD.name = "packetId"
GETREDPACKETRSPMSG_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketRspMsg.packetId"
GETREDPACKETRSPMSG_PACKETID_FIELD.number = 1
GETREDPACKETRSPMSG_PACKETID_FIELD.index = 0
GETREDPACKETRSPMSG_PACKETID_FIELD.label = 2
GETREDPACKETRSPMSG_PACKETID_FIELD.has_default_value = false
GETREDPACKETRSPMSG_PACKETID_FIELD.default_value = 0
GETREDPACKETRSPMSG_PACKETID_FIELD.type = 3
GETREDPACKETRSPMSG_PACKETID_FIELD.cpp_type = 2

GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.name = "packetStatus"
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketRspMsg.packetStatus"
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.number = 2
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.index = 1
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.label = 1
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.has_default_value = false
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.default_value = 0
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.type = 5
GETREDPACKETRSPMSG_PACKETSTATUS_FIELD.cpp_type = 1

GETREDPACKETRSPMSG_RESULTCODE_FIELD.name = "resultCode"
GETREDPACKETRSPMSG_RESULTCODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketRspMsg.resultCode"
GETREDPACKETRSPMSG_RESULTCODE_FIELD.number = 3
GETREDPACKETRSPMSG_RESULTCODE_FIELD.index = 2
GETREDPACKETRSPMSG_RESULTCODE_FIELD.label = 1
GETREDPACKETRSPMSG_RESULTCODE_FIELD.has_default_value = false
GETREDPACKETRSPMSG_RESULTCODE_FIELD.default_value = 0
GETREDPACKETRSPMSG_RESULTCODE_FIELD.type = 5
GETREDPACKETRSPMSG_RESULTCODE_FIELD.cpp_type = 1

GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.name = "resultMessage"
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketRspMsg.resultMessage"
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.number = 4
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.index = 3
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.label = 1
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.has_default_value = false
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.default_value = ""
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.type = 9
GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD.cpp_type = 9

GETREDPACKETRSPMSG.name = "GetRedPacketRspMsg"
GETREDPACKETRSPMSG.full_name = ".com.sparkingfuture.redpacket.netty.GetRedPacketRspMsg"
GETREDPACKETRSPMSG.nested_types = {}
GETREDPACKETRSPMSG.enum_types = {}
GETREDPACKETRSPMSG.fields = {GETREDPACKETRSPMSG_PACKETID_FIELD, GETREDPACKETRSPMSG_PACKETSTATUS_FIELD, GETREDPACKETRSPMSG_RESULTCODE_FIELD, GETREDPACKETRSPMSG_RESULTMESSAGE_FIELD}
GETREDPACKETRSPMSG.is_extendable = false
GETREDPACKETRSPMSG.extensions = {}
QUERYREDPACKETREQMSG_USERID_FIELD.name = "userId"
QUERYREDPACKETREQMSG_USERID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketReqMsg.userId"
QUERYREDPACKETREQMSG_USERID_FIELD.number = 1
QUERYREDPACKETREQMSG_USERID_FIELD.index = 0
QUERYREDPACKETREQMSG_USERID_FIELD.label = 1
QUERYREDPACKETREQMSG_USERID_FIELD.has_default_value = false
QUERYREDPACKETREQMSG_USERID_FIELD.default_value = 0
QUERYREDPACKETREQMSG_USERID_FIELD.type = 5
QUERYREDPACKETREQMSG_USERID_FIELD.cpp_type = 1

QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.name = "playerName"
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketReqMsg.playerName"
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.number = 2
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.index = 1
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.label = 1
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.has_default_value = false
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.default_value = ""
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.type = 9
QUERYREDPACKETREQMSG_PLAYERNAME_FIELD.cpp_type = 9

QUERYREDPACKETREQMSG_GAMEID_FIELD.name = "gameId"
QUERYREDPACKETREQMSG_GAMEID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketReqMsg.gameId"
QUERYREDPACKETREQMSG_GAMEID_FIELD.number = 3
QUERYREDPACKETREQMSG_GAMEID_FIELD.index = 2
QUERYREDPACKETREQMSG_GAMEID_FIELD.label = 1
QUERYREDPACKETREQMSG_GAMEID_FIELD.has_default_value = false
QUERYREDPACKETREQMSG_GAMEID_FIELD.default_value = ""
QUERYREDPACKETREQMSG_GAMEID_FIELD.type = 9
QUERYREDPACKETREQMSG_GAMEID_FIELD.cpp_type = 9

QUERYREDPACKETREQMSG.name = "QueryRedPacketReqMsg"
QUERYREDPACKETREQMSG.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketReqMsg"
QUERYREDPACKETREQMSG.nested_types = {}
QUERYREDPACKETREQMSG.enum_types = {}
QUERYREDPACKETREQMSG.fields = {QUERYREDPACKETREQMSG_USERID_FIELD, QUERYREDPACKETREQMSG_PLAYERNAME_FIELD, QUERYREDPACKETREQMSG_GAMEID_FIELD}
QUERYREDPACKETREQMSG.is_extendable = false
QUERYREDPACKETREQMSG.extensions = {}
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.name = "packetId"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.packetId"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.number = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.index = 0
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.label = 2
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.default_value = 0
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.type = 3
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD.cpp_type = 2

QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.name = "createTime"
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.createTime"
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.number = 2
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.index = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.name = "prizeType"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.prizeType"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.number = 3
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.index = 2
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.default_value = 0
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.type = 5
QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD.cpp_type = 1

QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.name = "redPacketName"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.redPacketName"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.number = 4
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.index = 3
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.name = "redRedPacketNum"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.redRedPacketNum"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.number = 5
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.index = 4
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.name = "redRedPacketNumContent"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.redRedPacketNumContent"
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.number = 6
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.index = 5
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.name = "packetStatus"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.packetStatus"
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.number = 7
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.index = 6
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.default_value = 0
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.type = 5
QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD.cpp_type = 1

QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.name = "shareLink"
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.shareLink"
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.number = 8
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.index = 7
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.name = "shareCode"
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.shareCode"
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.number = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.index = 8
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.type = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.name = "activityId"
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo.activityId"
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.number = 10
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.index = 9
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.label = 1
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.default_value = 0
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.type = 5
QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD.cpp_type = 1

QUERYREDPACKETRSPMSG_REDPACKETINFO.name = "RedPacketInfo"
QUERYREDPACKETRSPMSG_REDPACKETINFO.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.RedPacketInfo"
QUERYREDPACKETRSPMSG_REDPACKETINFO.nested_types = {}
QUERYREDPACKETRSPMSG_REDPACKETINFO.enum_types = {}
QUERYREDPACKETRSPMSG_REDPACKETINFO.fields = {QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETID_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_CREATETIME_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_PRIZETYPE_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_REDPACKETNAME_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUM_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_REDREDPACKETNUMCONTENT_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_PACKETSTATUS_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARELINK_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_SHARECODE_FIELD, QUERYREDPACKETRSPMSG_REDPACKETINFO_ACTIVITYID_FIELD}
QUERYREDPACKETRSPMSG_REDPACKETINFO.is_extendable = false
QUERYREDPACKETRSPMSG_REDPACKETINFO.extensions = {}
QUERYREDPACKETRSPMSG_REDPACKETINFO.containing_type = QUERYREDPACKETRSPMSG
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.name = "redPackets"
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.redPackets"
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.number = 1
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.index = 0
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.label = 3
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.default_value = {}
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.message_type = QUERYREDPACKETRSPMSG_REDPACKETINFO
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.type = 11
QUERYREDPACKETRSPMSG_REDPACKETS_FIELD.cpp_type = 10

QUERYREDPACKETRSPMSG_STARTTIME_FIELD.name = "startTime"
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.startTime"
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.number = 2
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.index = 1
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.label = 1
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.type = 9
QUERYREDPACKETRSPMSG_STARTTIME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_ENDTIME_FIELD.name = "endTime"
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.endTime"
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.number = 3
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.index = 2
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.label = 1
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.type = 9
QUERYREDPACKETRSPMSG_ENDTIME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.name = "dailyStartTime"
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.dailyStartTime"
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.number = 4
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.index = 3
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.label = 1
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.type = 9
QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.name = "dailyEndTime"
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.dailyEndTime"
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.number = 5
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.index = 4
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.label = 1
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.type = 9
QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.name = "resultCode"
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.resultCode"
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.number = 6
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.index = 5
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.label = 1
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.default_value = 0
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.type = 5
QUERYREDPACKETRSPMSG_RESULTCODE_FIELD.cpp_type = 1

QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.name = "resultMessage"
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg.resultMessage"
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.number = 7
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.index = 6
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.label = 1
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.has_default_value = false
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.default_value = ""
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.type = 9
QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD.cpp_type = 9

QUERYREDPACKETRSPMSG.name = "QueryRedPacketRspMsg"
QUERYREDPACKETRSPMSG.full_name = ".com.sparkingfuture.redpacket.netty.QueryRedPacketRspMsg"
QUERYREDPACKETRSPMSG.nested_types = {QUERYREDPACKETRSPMSG_REDPACKETINFO}
QUERYREDPACKETRSPMSG.enum_types = {}
QUERYREDPACKETRSPMSG.fields = {QUERYREDPACKETRSPMSG_REDPACKETS_FIELD, QUERYREDPACKETRSPMSG_STARTTIME_FIELD, QUERYREDPACKETRSPMSG_ENDTIME_FIELD, QUERYREDPACKETRSPMSG_DAILYSTARTTIME_FIELD, QUERYREDPACKETRSPMSG_DAILYENDTIME_FIELD, QUERYREDPACKETRSPMSG_RESULTCODE_FIELD, QUERYREDPACKETRSPMSG_RESULTMESSAGE_FIELD}
QUERYREDPACKETRSPMSG.is_extendable = false
QUERYREDPACKETRSPMSG.extensions = {}

GetRedPacketReqMsg = protobuf.Message(GETREDPACKETREQMSG)
GetRedPacketRspMsg = protobuf.Message(GETREDPACKETRSPMSG)
OpenRedPacketReqMsg = protobuf.Message(OPENREDPACKETREQMSG)
OpenRedPacketRspMsg = protobuf.Message(OPENREDPACKETRSPMSG)
QueryRedPacketReqMsg = protobuf.Message(QUERYREDPACKETREQMSG)
QueryRedPacketRspMsg = protobuf.Message(QUERYREDPACKETRSPMSG)
QueryRedPacketRspMsg.RedPacketInfo = protobuf.Message(QUERYREDPACKETRSPMSG_REDPACKETINFO)
SendRedPacketMsg = protobuf.Message(SENDREDPACKETMSG)
