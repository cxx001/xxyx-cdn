-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
cc.exports.CreateVipRoomMsg_pb = {}
module('CreateVipRoomMsg_pb')


local CREATEVIPROOMMSG = protobuf.Descriptor();
local CREATEVIPROOMMSG_GAMETYPE_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_ROOMID_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_PSW_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_QUANNUM_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_SELECTWAYNUM_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_ROOMNO_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_PAYTYPE_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_DIZHU_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_FDIZHU_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_EXTENDINFO_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD = protobuf.FieldDescriptor();
local CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD = protobuf.FieldDescriptor();

CREATEVIPROOMMSG_GAMETYPE_FIELD.name = "gametype"
CREATEVIPROOMMSG_GAMETYPE_FIELD.full_name = ".CreateVipRoomMsg.gametype"
CREATEVIPROOMMSG_GAMETYPE_FIELD.number = 1
CREATEVIPROOMMSG_GAMETYPE_FIELD.index = 0
CREATEVIPROOMMSG_GAMETYPE_FIELD.label = 1
CREATEVIPROOMMSG_GAMETYPE_FIELD.has_default_value = false
CREATEVIPROOMMSG_GAMETYPE_FIELD.default_value = 0
CREATEVIPROOMMSG_GAMETYPE_FIELD.type = 13
CREATEVIPROOMMSG_GAMETYPE_FIELD.cpp_type = 3

CREATEVIPROOMMSG_ROOMID_FIELD.name = "roomid"
CREATEVIPROOMMSG_ROOMID_FIELD.full_name = ".CreateVipRoomMsg.roomid"
CREATEVIPROOMMSG_ROOMID_FIELD.number = 2
CREATEVIPROOMMSG_ROOMID_FIELD.index = 1
CREATEVIPROOMMSG_ROOMID_FIELD.label = 1
CREATEVIPROOMMSG_ROOMID_FIELD.has_default_value = false
CREATEVIPROOMMSG_ROOMID_FIELD.default_value = 0
CREATEVIPROOMMSG_ROOMID_FIELD.type = 13
CREATEVIPROOMMSG_ROOMID_FIELD.cpp_type = 3

CREATEVIPROOMMSG_PSW_FIELD.name = "psw"
CREATEVIPROOMMSG_PSW_FIELD.full_name = ".CreateVipRoomMsg.psw"
CREATEVIPROOMMSG_PSW_FIELD.number = 3
CREATEVIPROOMMSG_PSW_FIELD.index = 2
CREATEVIPROOMMSG_PSW_FIELD.label = 1
CREATEVIPROOMMSG_PSW_FIELD.has_default_value = false
CREATEVIPROOMMSG_PSW_FIELD.default_value = ""
CREATEVIPROOMMSG_PSW_FIELD.type = 9
CREATEVIPROOMMSG_PSW_FIELD.cpp_type = 9

CREATEVIPROOMMSG_QUANNUM_FIELD.name = "quanNum"
CREATEVIPROOMMSG_QUANNUM_FIELD.full_name = ".CreateVipRoomMsg.quanNum"
CREATEVIPROOMMSG_QUANNUM_FIELD.number = 4
CREATEVIPROOMMSG_QUANNUM_FIELD.index = 3
CREATEVIPROOMMSG_QUANNUM_FIELD.label = 1
CREATEVIPROOMMSG_QUANNUM_FIELD.has_default_value = false
CREATEVIPROOMMSG_QUANNUM_FIELD.default_value = 0
CREATEVIPROOMMSG_QUANNUM_FIELD.type = 13
CREATEVIPROOMMSG_QUANNUM_FIELD.cpp_type = 3

CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.name = "selectWayNum"
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.full_name = ".CreateVipRoomMsg.selectWayNum"
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.number = 5
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.index = 4
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.label = 1
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.has_default_value = false
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.default_value = 0
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.type = 13
CREATEVIPROOMMSG_SELECTWAYNUM_FIELD.cpp_type = 3

CREATEVIPROOMMSG_ROOMNO_FIELD.name = "roomNo"
CREATEVIPROOMMSG_ROOMNO_FIELD.full_name = ".CreateVipRoomMsg.roomNo"
CREATEVIPROOMMSG_ROOMNO_FIELD.number = 6
CREATEVIPROOMMSG_ROOMNO_FIELD.index = 5
CREATEVIPROOMMSG_ROOMNO_FIELD.label = 1
CREATEVIPROOMMSG_ROOMNO_FIELD.has_default_value = false
CREATEVIPROOMMSG_ROOMNO_FIELD.default_value = 0
CREATEVIPROOMMSG_ROOMNO_FIELD.type = 13
CREATEVIPROOMMSG_ROOMNO_FIELD.cpp_type = 3

CREATEVIPROOMMSG_PAYTYPE_FIELD.name = "payType"
CREATEVIPROOMMSG_PAYTYPE_FIELD.full_name = ".CreateVipRoomMsg.payType"
CREATEVIPROOMMSG_PAYTYPE_FIELD.number = 7
CREATEVIPROOMMSG_PAYTYPE_FIELD.index = 6
CREATEVIPROOMMSG_PAYTYPE_FIELD.label = 1
CREATEVIPROOMMSG_PAYTYPE_FIELD.has_default_value = false
CREATEVIPROOMMSG_PAYTYPE_FIELD.default_value = 0
CREATEVIPROOMMSG_PAYTYPE_FIELD.type = 13
CREATEVIPROOMMSG_PAYTYPE_FIELD.cpp_type = 3

CREATEVIPROOMMSG_DIZHU_FIELD.name = "diZhu"
CREATEVIPROOMMSG_DIZHU_FIELD.full_name = ".CreateVipRoomMsg.diZhu"
CREATEVIPROOMMSG_DIZHU_FIELD.number = 8
CREATEVIPROOMMSG_DIZHU_FIELD.index = 7
CREATEVIPROOMMSG_DIZHU_FIELD.label = 1
CREATEVIPROOMMSG_DIZHU_FIELD.has_default_value = false
CREATEVIPROOMMSG_DIZHU_FIELD.default_value = 0
CREATEVIPROOMMSG_DIZHU_FIELD.type = 13
CREATEVIPROOMMSG_DIZHU_FIELD.cpp_type = 3

CREATEVIPROOMMSG_FDIZHU_FIELD.name = "fdiZhu"
CREATEVIPROOMMSG_FDIZHU_FIELD.full_name = ".CreateVipRoomMsg.fdiZhu"
CREATEVIPROOMMSG_FDIZHU_FIELD.number = 9
CREATEVIPROOMMSG_FDIZHU_FIELD.index = 8
CREATEVIPROOMMSG_FDIZHU_FIELD.label = 1
CREATEVIPROOMMSG_FDIZHU_FIELD.has_default_value = false
CREATEVIPROOMMSG_FDIZHU_FIELD.default_value = 0.0
CREATEVIPROOMMSG_FDIZHU_FIELD.type = 2
CREATEVIPROOMMSG_FDIZHU_FIELD.cpp_type = 6

CREATEVIPROOMMSG_EXTENDINFO_FIELD.name = "extendInfo"
CREATEVIPROOMMSG_EXTENDINFO_FIELD.full_name = ".CreateVipRoomMsg.extendInfo"
CREATEVIPROOMMSG_EXTENDINFO_FIELD.number = 10
CREATEVIPROOMMSG_EXTENDINFO_FIELD.index = 9
CREATEVIPROOMMSG_EXTENDINFO_FIELD.label = 1
CREATEVIPROOMMSG_EXTENDINFO_FIELD.has_default_value = false
CREATEVIPROOMMSG_EXTENDINFO_FIELD.default_value = ""
CREATEVIPROOMMSG_EXTENDINFO_FIELD.type = 12
CREATEVIPROOMMSG_EXTENDINFO_FIELD.cpp_type = 9

CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.name = "supportReadyBeforePlaying"
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.full_name = ".CreateVipRoomMsg.supportReadyBeforePlaying"
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.number = 11
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.index = 10
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.label = 1
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.has_default_value = false
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.default_value = 0
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.type = 13
CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD.cpp_type = 3

CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.name = "createVipRoomWay"
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.full_name = ".CreateVipRoomMsg.createVipRoomWay"
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.number = 12
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.index = 11
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.label = 1
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.has_default_value = false
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.default_value = 0
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.type = 13
CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD.cpp_type = 3

CREATEVIPROOMMSG.name = "CreateVipRoomMsg"
CREATEVIPROOMMSG.full_name = ".CreateVipRoomMsg"
CREATEVIPROOMMSG.nested_types = {}
CREATEVIPROOMMSG.enum_types = {}
CREATEVIPROOMMSG.fields = {CREATEVIPROOMMSG_GAMETYPE_FIELD, CREATEVIPROOMMSG_ROOMID_FIELD, CREATEVIPROOMMSG_PSW_FIELD, CREATEVIPROOMMSG_QUANNUM_FIELD, CREATEVIPROOMMSG_SELECTWAYNUM_FIELD, CREATEVIPROOMMSG_ROOMNO_FIELD, CREATEVIPROOMMSG_PAYTYPE_FIELD, CREATEVIPROOMMSG_DIZHU_FIELD, CREATEVIPROOMMSG_FDIZHU_FIELD, CREATEVIPROOMMSG_EXTENDINFO_FIELD, CREATEVIPROOMMSG_SUPPORTREADYBEFOREPLAYING_FIELD, CREATEVIPROOMMSG_CREATEVIPROOMWAY_FIELD}
CREATEVIPROOMMSG.is_extendable = false
CREATEVIPROOMMSG.extensions = {}

CreateVipRoomMsg = protobuf.Message(CREATEVIPROOMMSG)
