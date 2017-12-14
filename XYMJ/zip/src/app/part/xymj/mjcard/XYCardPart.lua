local CURRENT_MODULE_NAME = ...
local CardPart = import(".CardPart")
local XYCardPart = class("XYCardPart",CardPart)
XYCardPart.DEFAULT_VIEW = "XYCardLayer"

--初始化手牌数据（包括断线重连）
function XYCardPart:init_data(data)
	self.opt_list = {}
	self.m_seat_id = data.mtablePos
	self.card_list = data.mcards.cardvalue
	self.mo_card = false
	self.kanpai = false

	local down_cards = {}  --处理断线重连，需要展示已经吃杠碰的牌的情况
	for i=1,4 do
		local num = 0
		local view_id = self:changeSeatToView(i-1)
		local down_card = data.playerdowncards[i]
		down_cards[view_id] = down_card and down_card.cards or {}
	end

	local otherHandCardNum = RoomConfig.HandCardNum
	if (#data.mcards.cardvalue == 4) and (#down_cards[1] == 0) then --可以砍牌,说明只有四张手牌
		otherHandCardNum = 4
	end

	local card_data =  { --自己初始的牌由data.mcards.cardvalue决定，其他人的默认RoomConfig.HandCardNum 13 张
					 {view_id = 1,num = #data.mcards.cardvalue,value=data.mcards.cardvalue},
					 {view_id = 2,num = otherHandCardNum,value={}},
					 {view_id = 3,num = otherHandCardNum,value={}},
					 {view_id = 4,num = otherHandCardNum,value={}},
					}

	self.out_card_list = data.playercard                                    --玩家已经出了的牌
	self.hu_card_list = data.playerhucards                                  --玩家胡的牌
	self.down_card_list = data.playerdowncards                              --玩家吃/碰/杠的牌
	local cur_seat_id = data.chucardplayerindex                             --出牌玩家的座位
	local cur_view_id = self:changeSeatToView(cur_seat_id)                  --出牌玩家相对于自己的座位

	self:turnSeat(cur_view_id,nil,data.playeroperationtime)
	self.view:createCardWithData(card_data)									--创建手牌

	if data.baocard ~= 0 then 
		self:refreshBaoCardOnPart(data.baocard)
	end

	self:refreshMyCard(data.mcards.cardvalue,down_cards[1],{})				--刷新自己的手牌

	for i=2,4 do 															--刷新其余三家手牌
		local down_card = down_cards[i]
		for _,card in ipairs(down_card) do
			local card_value = card.cardValue
			local c1 = bit._and(card_value,0xff)
			local c2 = bit._and(bit.rshift(card_value,8),0xff)
			local c3 = bit._and(bit.rshift(card_value,16),0xff)
			local card_data = {mcard={c1,c2},ocard=c3,kanpai={}}
			
			if card.type == RoomConfig.BuGang or card.type == RoomConfig.MingGang then --断线重连补杠要变明杠才好显示牌
				card.type = RoomConfig.MingGang
				card_data = {mcard={c1,c2,c2},ocard=c3,kanpai={}}
			elseif card.type == RoomConfig.AnGang then
				if self:showAnGang() then
					card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,c3},ocard=RoomConfig.EmptyCard,kanpai={}}
				else
					card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard},ocard=RoomConfig.EmptyCard,kanpai={}}
				end
			end

			local mCardNum = #(card_data.mcard) + 1

			for i=1,card.usexiaojinum or 0 do
				card_data.kanpai[i] = card_data.mcard[mCardNum-i]
				if card_data.kanpai[i] then
					card_data.mcard[mCardNum-i]=nil
				else
					card_data.kanpai[i] = card_data.ocard
					card_data.ocard = nil
				end
				
				card_data.game_start = true
			end

			self:optCard(i,card.type,card_data,true)
		end
	end

	for i=1,4 do
		if data.playeriskanpai and data.playeriskanpai[i] and data.playeriskanpai[i] > 0 then
			local view_id = self:changeSeatToView(i-1)
			if (view_id == RoomConfig.MySeat) then
				if (not self.kanpai) then
					self.view:showKanPaiCard(view_id, data.playeriskanpai[i])
					self.view:reposeHandCards(view_id)
					self.kanpai = true
				end
			else
				self.view:showKanPaiCard(view_id, data.playeriskanpai[i])
				self.view:reposeHandCards(view_id, true)
			end

		end
	end

	local out_cards = {}
	for i=1,4 do 															--刷新已出的牌
		local view_id = self:changeSeatToView(i-1)
		local out_card = data.playercard[i]
		out_cards[view_id] = out_card and out_card.cardvalue or {}
		self.view:resetOutCard(view_id, out_cards[view_id])
	end

	if data.chucard and data.chucard > 0 then					            -- 当前操作玩家打出的牌，断线重链时此字段有值
		self:showOutCard(cur_view_id,data.chucard)
	end

	if (#data.mcards.cardvalue == 4) and (#down_cards[1] == 0) then --可以砍牌，需要展示砍牌按钮
		self.view:showKanpaiMenu()
		if self.owner and self.owner.onKanpaiMenuShow then
			self.owner:onKanpaiMenuShow()
		end
	end

	local naozhaungCards = data.playernaozhuangcards and data.playernaozhuangcards.cardvalue or {}
	
	self:resetNaozhuangCard(naozhaungCards or {})
end

function XYCardPart:onKanPaiSucceed(viewId)
	if viewId == 1 then
		self.view:hideKanpaiMenu()
		self.kanpai = true
	end
	
	self.view:removeHandcards(viewId)
	self.view:showKanPaiCard(viewId, 4)
end

function XYCardPart:onKanPaiCancle(viewId)
	self.view:hideKanpaiMenu()
	--self.view:removeHandcards(viewId)
end

function XYCardPart:sendKanpaiRequest(operationId)
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = operationId
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)

	if SocketConfig.IS_SEQ == false then		
		local buff_str = player_table_operation:SerializeToString()
		local buff_lenth = player_table_operation:ByteSize()
		net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
	elseif SocketConfig.IS_SEQ == true then
		net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
	end
end

function XYCardPart:isMyselfKanpai()
	return self.kanpai
end

function XYCardPart:resetNaozhuangCard(cards)
	self.naozhaungCards = cards
	self.view:resetNaozhuangCard(cards)
end

--暗杠是否要显示一张牌给别人看 默认不给看
function XYCardPart:showAnGang() 
	-- body
	return true
end

function XYCardPart:isNaozhuangIconShow()
	return self.owner:isNaozhuangIconShow()
end

--执行玩家吃杠碰操作 
function XYCardPart:optCard(viewId,type,value,hideCardOptPart,kanpaiCardNum) 
	-- body
	self:removeOutCard(self.last_opt_id)
	if type == RoomConfig.Chi then

	elseif type == RoomConfig.Peng then
		if viewId == RoomConfig.MySeat then
			local card_size = #self.card_list --如果是自己的操作，则从手牌中移除相应的牌
			local to_remove_card = {}
			for j,k in ipairs(value.mcard) do
				for i=card_size,1,-1 do
					if self.card_list[i] == k then
						table.insert(to_remove_card, {idx = i, card = k})
						table.remove(self.card_list,i)
						break
					end
				end
			end
			if #to_remove_card ~= #(value.mcard) then --服务器重复发消息等原因导致手牌中无牌可删除 这里加一个保护
				for k,v in pairs(to_remove_card) do
					table.insert(self.card_list, v.idx, v.card)
				end
				return
			end
		end
		
	elseif type == RoomConfig.AnGang then  

	elseif type == RoomConfig.MingGang then

	elseif type == RoomConfig.BuGang then
	elseif type == RoomConfig.MAHJONG_OPERTAION_POP_LAST then --更新宝牌
		self.mo_card = false
		self:refreshBaoCardOnPart(value.ocard)
		return
	end

	self.view:optCard(viewId,type,value,self.last_opt_id,hideCardOptPart,kanpaiCardNum) --UI展示玩家吃,碰,杠

	-- if self.naozhaungCards then
	-- 	self.view:resetNaozhuangCard(self.naozhaungCards)
	-- end

	if hideCardOptPart == nil or hideCardOptPart ~= true then
		local node,pos = self.view:getOptPos(viewId)
		local card_opt_part = self:getPart("CardOptPart") -- 展示碰杠那个字
		card_opt_part:activate(self.game_id, pos,type,node)
	end
end

function XYCardPart:getNaozhaungCardsNum()
	local ret = 0
	if self.naozhaungCards then
		ret = #(self.naozhaungCards)
	end
	return ret
end

return XYCardPart
