--[[
*名称:TableLayer
*描述:牌桌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TablePart = import(".TablePart")

local HZTablePart = class("HZTablePart",TablePart)
HZTablePart.DEFAULT_VIEW = "TableScene"

function HZTablePart:operationCard(data)
	-- body

	local card_part = self:getPart("CardPart")
	local dis_play_guo = true --是否显示过牌
	print("data.operation:",data.operation)
	print("This is HZTablePart Gang:",bit._and(data.operation,RoomConfig.Gang),RoomConfig.Gang)
	print("This is HZTablePart AN_GANG:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG),RoomConfig.MAHJONG_OPERTAION_AN_GANG)
	print("This is HZTablePart MING_GANG:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG),RoomConfig.MAHJONG_OPERTAION_MING_GANG)
	print("This is HZTablePart MAHJONG_OPERTAION_AN_GANG:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG),RoomConfig.MAHJONG_OPERTAION_AN_GANG)
	print("This is HZTablePart MAHJONG_OPERTAION_MING_GANG:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG),RoomConfig.MAHJONG_OPERTAION_MING_GANG)
		if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang 
		or bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG
		or bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG
		and bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) ~= RoomConfig.MAHJONG_OPERTAION_HU then
	  		local card_data = data.gangList
	  		print("This is HZTablePart MAHJONG_OPERTAION_CHU:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU),RoomConfig.MAHJONG_OPERTAION_CHU)
	  		if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
	  			--dis_play_guo = false --自己出牌不显示过 
	  			print("addOpt AN_GANG") 
	  			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_AN_GANG)
	   		else
	   			print("addOpt MING_GANG")
	  			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)		
	  		end
  		--card_part:ntfGangList(card_data)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then --自己摸了一张牌
		if data.chicardvalue ~= 0 then
			card_part:getCard(data.chicardvalue)
		end
   	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then
		local c1 = bit._and(data.pengcardvalue,0xff)
		local c2 = bit._and(bit.rshift(data.pengcardvalue,8),0xff)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c1}
		card_part:addOpt(RoomConfig.Peng)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.Chi)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_POP_LAST) == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		--显示2张 可点击的尾牌
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={},ocard=data.targetcard}
		card_part:ntfOpt(RoomConfig.MAHJONG_OPERTAION_POP_LAST,card_data,data.targetcard)
		return
	end

	card_part:showAddOpt(data.pengcardvalue,dis_play_guo)
end
return HZTablePart