-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
local card_down_pb = require("card_down_pb")
cc.exports.card_down_list_pb = {}
module('card_down_list_pb')


local CARDDOWNLIST = protobuf.Descriptor();
local CARDDOWNLIST_CARDS_FIELD = protobuf.FieldDescriptor();

CARDDOWNLIST_CARDS_FIELD.name = "cards"
CARDDOWNLIST_CARDS_FIELD.full_name = ".CardDownList.cards"
CARDDOWNLIST_CARDS_FIELD.number = 1
CARDDOWNLIST_CARDS_FIELD.index = 0
CARDDOWNLIST_CARDS_FIELD.label = 3
CARDDOWNLIST_CARDS_FIELD.has_default_value = false
CARDDOWNLIST_CARDS_FIELD.default_value = {}
CARDDOWNLIST_CARDS_FIELD.message_type = card_down_pb.CardDown
CARDDOWNLIST_CARDS_FIELD.type = 11
CARDDOWNLIST_CARDS_FIELD.cpp_type = 10

CARDDOWNLIST.name = "CardDownList"
CARDDOWNLIST.full_name = ".CardDownList"
CARDDOWNLIST.nested_types = {}
CARDDOWNLIST.enum_types = {}
CARDDOWNLIST.fields = {CARDDOWNLIST_CARDS_FIELD}
CARDDOWNLIST.is_extendable = false
CARDDOWNLIST.extensions = {}

CardDownList = protobuf.Message(CARDDOWNLIST)

