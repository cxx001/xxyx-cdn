local CURRENT_MODULE_NAME = ...
local TablePart = import(".TablePart")
local YNTablePart = class("YNTablePart",TablePart)
YNTablePart.DEFAULT_VIEW = "TableScene"



--自己摸了一张牌
function YNTablePart:operationChu(data)
	-- body
	local card_part = self:getPart("CardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end

	local opt_type = nil
	local card_value = {}
	--如果玩家听牌
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		opt_type = RoomConfig.MAHJONG_OPERTAION_HU
		card_value.mcard = {}
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,MahjongOperation.AN_GANG) == MahjongOperation.AN_GANG then
		opt_type = RoomConfig.AN_GANG
		card_value.mcard = {data.pengcardvalue,data.pengcardvalue,data.pengcardvalue,data.pengcardvalue}
		card_part:addOpt(RoomConfig.RoomConfig.GANG)
	end

	if bit._and(data.operation,MahjongOperation.BU_GANG) == MahjongOperation.BU_GANG then
		opt_type = RoomConfig.BU_GANG
		card_value.mcard = {data.pengcardvalue}
		card_part:addOpt(RoomConfig.RoomConfig.GANG)
	end

	if opt_type then
		card_part:showAddOpt(data.pengcardvalue,true) --自己摸牌不显示过
	end
end




function YNTablePart:operationCard(data)
	-- body
	local card_part = self:getPart("CardPart")
	local dis_play_guo = true --是否显示过牌
	print("This is YNTablePart operationCard:",bit._and(data.operation,MahjongOperation.PENG),bit._and(data.operation,MahjongOperation.AN_GANG),bit._and(data.operation,MahjongOperation.MING_GANG))

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
		if data.chicardvalue ~= 0 then
			card_part:getCard(data.chicardvalue)
		end
	end

	if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang and bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) ~= RoomConfig.MAHJONG_OPERTAION_HU then
  		local card_data = data.gangList
  		print("This is YNTablePart operationCard:",data.operation,RoomConfig.MAHJONG_OPERTAION_CHU,bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU))
  		-- if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
  		-- 	dis_play_guo = false --自己出牌不显示过  
   	-- 	else
  			card_part:addOpt(RoomConfig.Gang)		
  		-- end
  		card_part:ntfGangList(card_data)
  	elseif bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang then
		local card_data = data.gangList
		card_part:addOpt(RoomConfig.Gang)
		card_part:ntfGangList(card_data)	
	end

	

	if bit._and(data.operation,MahjongOperation.PENG) == MahjongOperation.PENG then
		local c1 = bit._and(data.pengcardvalue,0xff)
		local c2 = bit._and(bit.rshift(data.pengcardvalue,8),0xff)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c1}
		-- card_part:ntfOpt(RoomConfig.Peng,card_data,data.pengcardvalue)
		card_part:addOpt(RoomConfig.Peng)
	end

	if bit._and(data.operation,MahjongOperation.CHI) == MahjongOperation.CHI then
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.Chi)
	end

	if bit._and(data.operation,MahjongOperation.HU) == MahjongOperation.HU then
		card_part:addOpt(MahjongOperation.HU)
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



return YNTablePart