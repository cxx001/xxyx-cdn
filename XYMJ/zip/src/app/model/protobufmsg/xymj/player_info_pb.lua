-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
local vip_over_data_pb = require("vip_over_data_pb")
cc.exports.player_info_pb = {}
module('player_info_pb')


local PLAYERINFO = protobuf.Descriptor();
local PLAYERINFO_UID_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_NAME_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_HEADIMG_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_HEADIMGURL_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_SEX_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_COIN_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_TABLEPOS_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_DESC_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_FAN_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_GAMERESULT_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_CANFRIND_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_INTABLE_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_VIPOVERDATA_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_IP_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_GAMESTATE_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_PLAYERINDEX_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_DIMAOND_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_SCORE_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_WINS_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_LOSE_FIELD = protobuf.FieldDescriptor();
local PLAYERINFO_HURESULT_FIELD = protobuf.FieldDescriptor();

PLAYERINFO_UID_FIELD.name = "uid"
PLAYERINFO_UID_FIELD.full_name = ".PlayerInfo.uid"
PLAYERINFO_UID_FIELD.number = 1
PLAYERINFO_UID_FIELD.index = 0
PLAYERINFO_UID_FIELD.label = 1
PLAYERINFO_UID_FIELD.has_default_value = false
PLAYERINFO_UID_FIELD.default_value = ""
PLAYERINFO_UID_FIELD.type = 9
PLAYERINFO_UID_FIELD.cpp_type = 9

PLAYERINFO_NAME_FIELD.name = "name"
PLAYERINFO_NAME_FIELD.full_name = ".PlayerInfo.name"
PLAYERINFO_NAME_FIELD.number = 2
PLAYERINFO_NAME_FIELD.index = 1
PLAYERINFO_NAME_FIELD.label = 1
PLAYERINFO_NAME_FIELD.has_default_value = false
PLAYERINFO_NAME_FIELD.default_value = ""
PLAYERINFO_NAME_FIELD.type = 9
PLAYERINFO_NAME_FIELD.cpp_type = 9

PLAYERINFO_HEADIMG_FIELD.name = "headImg"
PLAYERINFO_HEADIMG_FIELD.full_name = ".PlayerInfo.headImg"
PLAYERINFO_HEADIMG_FIELD.number = 3
PLAYERINFO_HEADIMG_FIELD.index = 2
PLAYERINFO_HEADIMG_FIELD.label = 1
PLAYERINFO_HEADIMG_FIELD.has_default_value = false
PLAYERINFO_HEADIMG_FIELD.default_value = 0
PLAYERINFO_HEADIMG_FIELD.type = 13
PLAYERINFO_HEADIMG_FIELD.cpp_type = 3

PLAYERINFO_HEADIMGURL_FIELD.name = "headImgUrl"
PLAYERINFO_HEADIMGURL_FIELD.full_name = ".PlayerInfo.headImgUrl"
PLAYERINFO_HEADIMGURL_FIELD.number = 4
PLAYERINFO_HEADIMGURL_FIELD.index = 3
PLAYERINFO_HEADIMGURL_FIELD.label = 1
PLAYERINFO_HEADIMGURL_FIELD.has_default_value = false
PLAYERINFO_HEADIMGURL_FIELD.default_value = ""
PLAYERINFO_HEADIMGURL_FIELD.type = 9
PLAYERINFO_HEADIMGURL_FIELD.cpp_type = 9

PLAYERINFO_SEX_FIELD.name = "sex"
PLAYERINFO_SEX_FIELD.full_name = ".PlayerInfo.sex"
PLAYERINFO_SEX_FIELD.number = 5
PLAYERINFO_SEX_FIELD.index = 4
PLAYERINFO_SEX_FIELD.label = 1
PLAYERINFO_SEX_FIELD.has_default_value = false
PLAYERINFO_SEX_FIELD.default_value = 0
PLAYERINFO_SEX_FIELD.type = 13
PLAYERINFO_SEX_FIELD.cpp_type = 3

PLAYERINFO_COIN_FIELD.name = "coin"
PLAYERINFO_COIN_FIELD.full_name = ".PlayerInfo.coin"
PLAYERINFO_COIN_FIELD.number = 6
PLAYERINFO_COIN_FIELD.index = 5
PLAYERINFO_COIN_FIELD.label = 1
PLAYERINFO_COIN_FIELD.has_default_value = false
PLAYERINFO_COIN_FIELD.default_value = 0
PLAYERINFO_COIN_FIELD.type = 3
PLAYERINFO_COIN_FIELD.cpp_type = 2

PLAYERINFO_TABLEPOS_FIELD.name = "tablepos"
PLAYERINFO_TABLEPOS_FIELD.full_name = ".PlayerInfo.tablepos"
PLAYERINFO_TABLEPOS_FIELD.number = 7
PLAYERINFO_TABLEPOS_FIELD.index = 6
PLAYERINFO_TABLEPOS_FIELD.label = 1
PLAYERINFO_TABLEPOS_FIELD.has_default_value = false
PLAYERINFO_TABLEPOS_FIELD.default_value = 0
PLAYERINFO_TABLEPOS_FIELD.type = 13
PLAYERINFO_TABLEPOS_FIELD.cpp_type = 3

PLAYERINFO_DESC_FIELD.name = "desc"
PLAYERINFO_DESC_FIELD.full_name = ".PlayerInfo.desc"
PLAYERINFO_DESC_FIELD.number = 8
PLAYERINFO_DESC_FIELD.index = 7
PLAYERINFO_DESC_FIELD.label = 1
PLAYERINFO_DESC_FIELD.has_default_value = false
PLAYERINFO_DESC_FIELD.default_value = ""
PLAYERINFO_DESC_FIELD.type = 9
PLAYERINFO_DESC_FIELD.cpp_type = 9

PLAYERINFO_FAN_FIELD.name = "fan"
PLAYERINFO_FAN_FIELD.full_name = ".PlayerInfo.fan"
PLAYERINFO_FAN_FIELD.number = 9
PLAYERINFO_FAN_FIELD.index = 8
PLAYERINFO_FAN_FIELD.label = 1
PLAYERINFO_FAN_FIELD.has_default_value = false
PLAYERINFO_FAN_FIELD.default_value = 0
PLAYERINFO_FAN_FIELD.type = 13
PLAYERINFO_FAN_FIELD.cpp_type = 3

PLAYERINFO_GAMERESULT_FIELD.name = "gameresult"
PLAYERINFO_GAMERESULT_FIELD.full_name = ".PlayerInfo.gameresult"
PLAYERINFO_GAMERESULT_FIELD.number = 10
PLAYERINFO_GAMERESULT_FIELD.index = 9
PLAYERINFO_GAMERESULT_FIELD.label = 1
PLAYERINFO_GAMERESULT_FIELD.has_default_value = false
PLAYERINFO_GAMERESULT_FIELD.default_value = 0
PLAYERINFO_GAMERESULT_FIELD.type = 13
PLAYERINFO_GAMERESULT_FIELD.cpp_type = 3

PLAYERINFO_CANFRIND_FIELD.name = "canfrind"
PLAYERINFO_CANFRIND_FIELD.full_name = ".PlayerInfo.canfrind"
PLAYERINFO_CANFRIND_FIELD.number = 11
PLAYERINFO_CANFRIND_FIELD.index = 10
PLAYERINFO_CANFRIND_FIELD.label = 1
PLAYERINFO_CANFRIND_FIELD.has_default_value = false
PLAYERINFO_CANFRIND_FIELD.default_value = 0
PLAYERINFO_CANFRIND_FIELD.type = 13
PLAYERINFO_CANFRIND_FIELD.cpp_type = 3

PLAYERINFO_INTABLE_FIELD.name = "intable"
PLAYERINFO_INTABLE_FIELD.full_name = ".PlayerInfo.intable"
PLAYERINFO_INTABLE_FIELD.number = 12
PLAYERINFO_INTABLE_FIELD.index = 11
PLAYERINFO_INTABLE_FIELD.label = 1
PLAYERINFO_INTABLE_FIELD.has_default_value = false
PLAYERINFO_INTABLE_FIELD.default_value = 0
PLAYERINFO_INTABLE_FIELD.type = 13
PLAYERINFO_INTABLE_FIELD.cpp_type = 3

PLAYERINFO_VIPOVERDATA_FIELD.name = "vipoverdata"
PLAYERINFO_VIPOVERDATA_FIELD.full_name = ".PlayerInfo.vipoverdata"
PLAYERINFO_VIPOVERDATA_FIELD.number = 13
PLAYERINFO_VIPOVERDATA_FIELD.index = 12
PLAYERINFO_VIPOVERDATA_FIELD.label = 1
PLAYERINFO_VIPOVERDATA_FIELD.has_default_value = false
PLAYERINFO_VIPOVERDATA_FIELD.default_value = nil
PLAYERINFO_VIPOVERDATA_FIELD.message_type = vip_over_data_pb.vipOverData
PLAYERINFO_VIPOVERDATA_FIELD.type = 11
PLAYERINFO_VIPOVERDATA_FIELD.cpp_type = 10

PLAYERINFO_IP_FIELD.name = "ip"
PLAYERINFO_IP_FIELD.full_name = ".PlayerInfo.ip"
PLAYERINFO_IP_FIELD.number = 14
PLAYERINFO_IP_FIELD.index = 13
PLAYERINFO_IP_FIELD.label = 1
PLAYERINFO_IP_FIELD.has_default_value = false
PLAYERINFO_IP_FIELD.default_value = ""
PLAYERINFO_IP_FIELD.type = 9
PLAYERINFO_IP_FIELD.cpp_type = 9

PLAYERINFO_GAMESTATE_FIELD.name = "gamestate"
PLAYERINFO_GAMESTATE_FIELD.full_name = ".PlayerInfo.gamestate"
PLAYERINFO_GAMESTATE_FIELD.number = 15
PLAYERINFO_GAMESTATE_FIELD.index = 14
PLAYERINFO_GAMESTATE_FIELD.label = 1
PLAYERINFO_GAMESTATE_FIELD.has_default_value = false
PLAYERINFO_GAMESTATE_FIELD.default_value = 0
PLAYERINFO_GAMESTATE_FIELD.type = 13
PLAYERINFO_GAMESTATE_FIELD.cpp_type = 3

PLAYERINFO_PLAYERINDEX_FIELD.name = "playerIndex"
PLAYERINFO_PLAYERINDEX_FIELD.full_name = ".PlayerInfo.playerIndex"
PLAYERINFO_PLAYERINDEX_FIELD.number = 16
PLAYERINFO_PLAYERINDEX_FIELD.index = 15
PLAYERINFO_PLAYERINDEX_FIELD.label = 1
PLAYERINFO_PLAYERINDEX_FIELD.has_default_value = false
PLAYERINFO_PLAYERINDEX_FIELD.default_value = 0
PLAYERINFO_PLAYERINDEX_FIELD.type = 13
PLAYERINFO_PLAYERINDEX_FIELD.cpp_type = 3

PLAYERINFO_DIMAOND_FIELD.name = "dimaond"
PLAYERINFO_DIMAOND_FIELD.full_name = ".PlayerInfo.dimaond"
PLAYERINFO_DIMAOND_FIELD.number = 17
PLAYERINFO_DIMAOND_FIELD.index = 16
PLAYERINFO_DIMAOND_FIELD.label = 1
PLAYERINFO_DIMAOND_FIELD.has_default_value = false
PLAYERINFO_DIMAOND_FIELD.default_value = 0
PLAYERINFO_DIMAOND_FIELD.type = 13
PLAYERINFO_DIMAOND_FIELD.cpp_type = 3

PLAYERINFO_SCORE_FIELD.name = "score"
PLAYERINFO_SCORE_FIELD.full_name = ".PlayerInfo.score"
PLAYERINFO_SCORE_FIELD.number = 18
PLAYERINFO_SCORE_FIELD.index = 17
PLAYERINFO_SCORE_FIELD.label = 1
PLAYERINFO_SCORE_FIELD.has_default_value = false
PLAYERINFO_SCORE_FIELD.default_value = 0
PLAYERINFO_SCORE_FIELD.type = 5
PLAYERINFO_SCORE_FIELD.cpp_type = 1

PLAYERINFO_WINS_FIELD.name = "wins"
PLAYERINFO_WINS_FIELD.full_name = ".PlayerInfo.wins"
PLAYERINFO_WINS_FIELD.number = 19
PLAYERINFO_WINS_FIELD.index = 18
PLAYERINFO_WINS_FIELD.label = 1
PLAYERINFO_WINS_FIELD.has_default_value = false
PLAYERINFO_WINS_FIELD.default_value = 0
PLAYERINFO_WINS_FIELD.type = 5
PLAYERINFO_WINS_FIELD.cpp_type = 1

PLAYERINFO_LOSE_FIELD.name = "lose"
PLAYERINFO_LOSE_FIELD.full_name = ".PlayerInfo.lose"
PLAYERINFO_LOSE_FIELD.number = 20
PLAYERINFO_LOSE_FIELD.index = 19
PLAYERINFO_LOSE_FIELD.label = 1
PLAYERINFO_LOSE_FIELD.has_default_value = false
PLAYERINFO_LOSE_FIELD.default_value = 0
PLAYERINFO_LOSE_FIELD.type = 5
PLAYERINFO_LOSE_FIELD.cpp_type = 1

PLAYERINFO_HURESULT_FIELD.name = "huResult"
PLAYERINFO_HURESULT_FIELD.full_name = ".PlayerInfo.huResult"
PLAYERINFO_HURESULT_FIELD.number = 21
PLAYERINFO_HURESULT_FIELD.index = 20
PLAYERINFO_HURESULT_FIELD.label = 1
PLAYERINFO_HURESULT_FIELD.has_default_value = false
PLAYERINFO_HURESULT_FIELD.default_value = 0
PLAYERINFO_HURESULT_FIELD.type = 5
PLAYERINFO_HURESULT_FIELD.cpp_type = 1

PLAYERINFO.name = "PlayerInfo"
PLAYERINFO.full_name = ".PlayerInfo"
PLAYERINFO.nested_types = {}
PLAYERINFO.enum_types = {}
PLAYERINFO.fields = {PLAYERINFO_UID_FIELD, PLAYERINFO_NAME_FIELD, PLAYERINFO_HEADIMG_FIELD, PLAYERINFO_HEADIMGURL_FIELD, PLAYERINFO_SEX_FIELD, PLAYERINFO_COIN_FIELD, PLAYERINFO_TABLEPOS_FIELD, PLAYERINFO_DESC_FIELD, PLAYERINFO_FAN_FIELD, PLAYERINFO_GAMERESULT_FIELD, PLAYERINFO_CANFRIND_FIELD, PLAYERINFO_INTABLE_FIELD, PLAYERINFO_VIPOVERDATA_FIELD, PLAYERINFO_IP_FIELD, PLAYERINFO_GAMESTATE_FIELD, PLAYERINFO_PLAYERINDEX_FIELD, PLAYERINFO_DIMAOND_FIELD, PLAYERINFO_SCORE_FIELD, PLAYERINFO_WINS_FIELD, PLAYERINFO_LOSE_FIELD, PLAYERINFO_HURESULT_FIELD}
PLAYERINFO.is_extendable = true
PLAYERINFO.extensions = {}

PlayerInfo = protobuf.Message(PLAYERINFO)
