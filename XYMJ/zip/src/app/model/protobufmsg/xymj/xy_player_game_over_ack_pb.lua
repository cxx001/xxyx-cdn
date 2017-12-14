-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
local player_game_over_ack_pb = require("player_game_over_ack_pb")
local card_info_pb = require("card_info_pb")
cc.exports.xy_player_game_over_ack_pb = {}
module('xy_player_game_over_ack_pb')


local XYPLAYERGAMEOVERACK = protobuf.Descriptor();
local XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD = protobuf.FieldDescriptor();
local XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD = protobuf.FieldDescriptor();
local XYPLAYERGAMEOVERACK_XYEXT_FIELD = protobuf.FieldDescriptor();

XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.name = "playerKanPaiCards"
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.full_name = ".XYPlayerGameOverAck.playerKanPaiCards"
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.number = 1
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.index = 0
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.label = 3
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.has_default_value = false
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.default_value = {}
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.message_type = card_info_pb.CardInfo
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.type = 11
XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD.cpp_type = 10

XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.name = "playerShuaiPaiCards"
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.full_name = ".XYPlayerGameOverAck.playerShuaiPaiCards"
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.number = 2
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.index = 1
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.label = 3
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.has_default_value = false
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.default_value = {}
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.message_type = card_info_pb.CardInfo
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.type = 11
XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD.cpp_type = 10

XYPLAYERGAMEOVERACK_XYEXT_FIELD.name = "xyExt"
XYPLAYERGAMEOVERACK_XYEXT_FIELD.full_name = ".XYPlayerGameOverAck.xyExt"
XYPLAYERGAMEOVERACK_XYEXT_FIELD.number = 100
XYPLAYERGAMEOVERACK_XYEXT_FIELD.index = 0
XYPLAYERGAMEOVERACK_XYEXT_FIELD.label = 1
XYPLAYERGAMEOVERACK_XYEXT_FIELD.has_default_value = false
XYPLAYERGAMEOVERACK_XYEXT_FIELD.default_value = nil
XYPLAYERGAMEOVERACK_XYEXT_FIELD.message_type = XYPLAYERGAMEOVERACK
XYPLAYERGAMEOVERACK_XYEXT_FIELD.type = 11
XYPLAYERGAMEOVERACK_XYEXT_FIELD.cpp_type = 10

XYPLAYERGAMEOVERACK.name = "XYPlayerGameOverAck"
XYPLAYERGAMEOVERACK.full_name = ".XYPlayerGameOverAck"
XYPLAYERGAMEOVERACK.nested_types = {}
XYPLAYERGAMEOVERACK.enum_types = {}
XYPLAYERGAMEOVERACK.fields = {XYPLAYERGAMEOVERACK_PLAYERKANPAICARDS_FIELD, XYPLAYERGAMEOVERACK_PLAYERSHUAIPAICARDS_FIELD}
XYPLAYERGAMEOVERACK.is_extendable = false
XYPLAYERGAMEOVERACK.extensions = {XYPLAYERGAMEOVERACK_XYEXT_FIELD}

XYPlayerGameOverAck = protobuf.Message(XYPLAYERGAMEOVERACK)

player_game_over_ack_pb.PlayerGameOverAck.RegisterExtension(XYPLAYERGAMEOVERACK_XYEXT_FIELD)
