-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
cc.exports.logReported_pb = {}
module('logReported_pb')


local LOGREPORTED = protobuf.Descriptor();
local LOGREPORTED_PLAYERINDEX_FIELD = protobuf.FieldDescriptor();
local LOGREPORTED_OPERATIONTIME_FIELD = protobuf.FieldDescriptor();
local LOGREPORTED_DESCRIPTION_FIELD = protobuf.FieldDescriptor();

LOGREPORTED_PLAYERINDEX_FIELD.name = "playerIndex"
LOGREPORTED_PLAYERINDEX_FIELD.full_name = ".LogReported.playerIndex"
LOGREPORTED_PLAYERINDEX_FIELD.number = 1
LOGREPORTED_PLAYERINDEX_FIELD.index = 0
LOGREPORTED_PLAYERINDEX_FIELD.label = 1
LOGREPORTED_PLAYERINDEX_FIELD.has_default_value = false
LOGREPORTED_PLAYERINDEX_FIELD.default_value = 0
LOGREPORTED_PLAYERINDEX_FIELD.type = 13
LOGREPORTED_PLAYERINDEX_FIELD.cpp_type = 3

LOGREPORTED_OPERATIONTIME_FIELD.name = "operationTime"
LOGREPORTED_OPERATIONTIME_FIELD.full_name = ".LogReported.operationTime"
LOGREPORTED_OPERATIONTIME_FIELD.number = 2
LOGREPORTED_OPERATIONTIME_FIELD.index = 1
LOGREPORTED_OPERATIONTIME_FIELD.label = 1
LOGREPORTED_OPERATIONTIME_FIELD.has_default_value = false
LOGREPORTED_OPERATIONTIME_FIELD.default_value = ""
LOGREPORTED_OPERATIONTIME_FIELD.type = 9
LOGREPORTED_OPERATIONTIME_FIELD.cpp_type = 9

LOGREPORTED_DESCRIPTION_FIELD.name = "description"
LOGREPORTED_DESCRIPTION_FIELD.full_name = ".LogReported.description"
LOGREPORTED_DESCRIPTION_FIELD.number = 3
LOGREPORTED_DESCRIPTION_FIELD.index = 2
LOGREPORTED_DESCRIPTION_FIELD.label = 1
LOGREPORTED_DESCRIPTION_FIELD.has_default_value = false
LOGREPORTED_DESCRIPTION_FIELD.default_value = ""
LOGREPORTED_DESCRIPTION_FIELD.type = 9
LOGREPORTED_DESCRIPTION_FIELD.cpp_type = 9

LOGREPORTED.name = "LogReported"
LOGREPORTED.full_name = ".LogReported"
LOGREPORTED.nested_types = {}
LOGREPORTED.enum_types = {}
LOGREPORTED.fields = {LOGREPORTED_PLAYERINDEX_FIELD, LOGREPORTED_OPERATIONTIME_FIELD, LOGREPORTED_DESCRIPTION_FIELD}
LOGREPORTED.is_extendable = false
LOGREPORTED.extensions = {}

LogReported = protobuf.Message(LOGREPORTED)
