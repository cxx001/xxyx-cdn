local CURRENT_MODULE_NAME = ...
local CardPart = import(".CardPart")
local XYCardPart = class("XYCardPart",CardPart)

XYCardPart.DEFAULT_PART = {
	"CardOptPart",
	"ThrowCardPart"
}

XYCardPart.DEFAULT_VIEW = "XYCardLayer"

--初始化手牌数据（包括断线重连）
function XYCardPart:init_data(data)
	print("XYCardPart",data)
	self.opt_list = {}
	self.m_seat_id = data.mtablePos
	self.card_list = data.mcards.cardvalue
	self.mo_card = false
	self.kanpai = false
	self.play_way_type = data.newplayway

	local function isInThrowCardStat(states)
		local isOnThrow = false
		for k,v in ipairs(states) do
			if v == false then
				isOnThrow = true
			end
		end
		return isOnThrow
	end 

	local xy_game_extend = data.Extensions[xymj_message_pb.XYGameStartMsg.xyExt]
	self.isShuaiPai = xy_game_extend.isShuaiPai
	if xy_game_extend.isShuaiPai == true then --甩牌玩法
		if isInThrowCardStat(xy_game_extend.playerShuaiPaiStates) then --甩牌中
			self.throwcard_part = self:getPart("ThrowCardPart")
			if self.throwcard_part then
				local throw_data = {}
				throw_data.playerstates = {}
				for i=1,4 do
					local view_id = self:changeSeatToView(i-1)
					throw_data.playerstates[view_id] = xy_game_extend.playerShuaiPaiStates[i]
				end
			-- throw_data.playerstates = xy_game_extend.playerShuaiPaiStates 
				throw_data.throwcards = xy_game_extend.playerShuaiPaiCards 
				self.throwcard_part:activate(self.game_id, self, throw_data, self:getCardFactory())
			end
			return 
		else--已甩牌
		end
	end 

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

	self.view.majorViewId = self.majorViewId

	self:turnSeat(cur_view_id,nil,data.playeroperationtime)
 	local tricksTotalNum = 34*4
	self.view:createReadyCard(card_data, tricksTotalNum)

	self:setRetainCardNum(data.cardLeftNum or 0) --设置剩余牌
	self:updateLastCardNum(data.cardLeftNum or 0)
	local  cardAllNum= data.cardAllNum or 0	 --当前游戏牌的总数
	print("retainCardNum:"..tostring(data.cardLeftNum or 0))
	print("cardAllNum:"..cardAllNum)
	self:reduceTricksNum(tricksTotalNum-cardAllNum)
	self:reduceTricksNum(cardAllNum - (data.cardLeftNum or 0))
	
	self.view:createCardWithData(card_data)									--创建手牌

	if data.baocard ~= 0 then 
		self:refreshBaoCardOnPart(data.baocard)
	else
		self.view:hideBaoCard()
	end

	local down_card_MySelf = down_cards[1]
		for _,card in ipairs(down_card_MySelf) do
			dump(card)
			print("usexiaojinum:"..card.usexiaojinum)
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
				print("carddatakanpai")
				dump(card_data.kanpai)
				--card_data.game_start = true
			end

			self:optCard(i,card.type,card_data,true)
		end
	end

	for i=1,4 do
		print("i------------:"..i)
		--dump(data.playeriskanpai[i])
		if data.playeriskanpai and data.playeriskanpai[i] and data.playeriskanpai[i] > 0 then
			local view_id = self:changeSeatToView(i-1)
			if (view_id == RoomConfig.MySeat) then
				if (not self.kanpai) then
					print("xxxxxxxx",data.playeriskanpai[i])
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

	for i=1,4 do
		local view_id = self:changeSeatToView(i-1)

		if data.playerisnaozhuang and data.playerisnaozhuang[i] and (data.playerisnaozhuang[i] == 1) then
			if (i - 1) == data.dealerpos then
				self:showTongnaoIcon(view_id)
			else
				self:showNaozhuangIcon(view_id)
			end
		end
	end

	local naozhaungCards = data.playernaozhuangcards and data.playernaozhuangcards.cardvalue or {}
	self:resetNaozhuangCard(naozhaungCards or {})

	if xy_game_extend.playerShuaiPaiCards then
		self:resetShuaiPaiScript(xy_game_extend.playerShuaiPaiCards)
	end
end

function XYCardPart:refreshMyCard(hcard,dcard,ocard,value) -- 刷新自己的手牌和 dcard_list
	-- bod
    self.card_list = hcard
    self.dcard_list = dcard
	self.view:refreshMyCard(hcard,dcard,ocard,value)
	-- if value then
	-- 	self:showOutCard(RoomConfig.MySeat,value)
	-- end
end

--胡牌推倒 
function XYCardPart:pushOverHandCard(handCards)
	--手牌为全部不可见
	print("handCardshandCards:",handCards)
	if handCards then
		for i=2,4 do
			for k,v in ipairs(handCards[i].cardvalue) do
				print("i:====="..i.."         v:"..v.."    k:"..k)
			end
		end
	end

	if handCards and self.view then
		local hand_cards = {}
		--信阳坎牌摊牌
		if self.view.kanpaiCardNum then
			local kanpaiNums = self.view.kanpaiCardNum
			-- dump(kanpaiNums)
			for i=1,4 do
				local view_id = self:changeSeatToView(i-1)
				hand_cards[view_id] = handCards[i] and handCards[i].cardvalue or {}
			end
			self.view:setHandsHide()

			for i=1,4 do
				local num = kanpaiNums[i]
				if num > 0 then
					local tbKanPaiValue = {}
					for j=1,num do
						local value = hand_cards[i]	
						print("value:"..value[j])
						table.insert(tbKanPaiValue,value[j])
					end
					self.view:pushOverShowKanPaiValue(tbKanPaiValue,i)
				end
			end

			for i=2,4 do
				local startIndex =  kanpaiNums[i] and kanpaiNums[i] or 0 
				startIndex =kanpaiNums[i] and kanpaiNums[i] or 0 
		 		self.view:updatePushOver(hand_cards[i],i,startIndex)
			end
		else
			for i=1,4 do
				local view_id = self:changeSeatToView(i-1)
				hand_cards[view_id] = handCards[i] and handCards[i].cardvalue or {}
			end
			self.view:setHandsHide()
			for i=2,4 do
		 		self.view:updatePushOver(hand_cards[i],i,0)
			end
		end

	end
end

function XYCardPart:onKanPaiSucceed(viewId)
	if viewId == 1 then
		self.view:hideKanpaiMenu()
		self.kanpai = true
	end
	
	self.view:removeHandcards(viewId)
	self.view:showKanPaiCard(viewId, 4)

	self.view:showKanpaiEffect(viewId)
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

function XYCardPart:sendThrowCardRequest(throw_card)
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_SHUAIPAI
	-- player_table_operation.operation = operationId
	for i,v in ipairs(throw_card) do
  		player_table_operation.naoZhuangCards:append(v)
  	end
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	if SocketConfig.IS_SEQ == false then		
		local buff_str = player_table_operation:SerializeToString()
		local buff_lenth = player_table_operation:ByteSize()
		net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
	elseif SocketConfig.IS_SEQ == true then
		net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
	end
end

function XYCardPart:onNotifyThrowCard(player_states, shuaiPaiNums)
	if self.throwcard_part then
		local states = {}
		for i=1,4 do
			local view_id = self:changeSeatToView(i-1)
			states[view_id] = player_states[i]
		end
		self.throwcard_part:setPlayerState(states)

		if i == RoomConfig.MySeat then
			self:resetShuaiPaiScript(shuaiPaiNums)
		end
	end
end

function XYCardPart:resetShuaiPaiScript(shuaiPaiNums)
	if self.view then
		self.view:resetShuaiPaiScript(shuaiPaiNums)
	end
end

function XYCardPart:isMyselfKanpai()
	return self.kanpai
end

function XYCardPart:resetNaozhuangCard(cards)
	self.view:resetNaozhuangCard(cards)
end

--暗杠是否要显示一张牌给别人看 默认不给看
function XYCardPart:showAnGang() 
	local ret = true
	if self.play_way_type and (bit._and(self.play_way_type, 0x40080) == 0x40080) then
		ret = false
	end
	return ret
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
	-- if hideCardOptPart == nil or hideCardOptPart ~= true then
	-- 	local node,pos = self.view:getOptPos(viewId)
	-- 	local card_opt_part = self:getPart("CardOptPart") -- 展示碰杠那个字
	-- 	card_opt_part:activate(self.game_id, pos,type,node)
	-- end
end

function XYCardPart:adjustLastCardPos()
	if self.view then
		self.view:adjustHandPos()
	end
end

function XYCardPart:showNaozhuangIcon(viewId)
	if self.view then
		self.view:showNaozhuangIcon(viewId)
	end
end

function XYCardPart:showTongnaoIcon(viewId)
	if self.view then
		self.view:showTongnaoIcon(viewId)
	end
end

function XYCardPart:showOutCard(viewId,value)
	-- body
	self.last_opt_id = viewId  --最后动作的人
	-- self:removeOutCard() --移除当前出的牌
	if self.play_way_type and (bit._and(self.play_way_type, 0x40080) == 0x40080) then
		value = 0x39
	end
	self.view:outCard(viewId,value) --展示出牌的动画
end

function XYCardPart:isPeiZi(cardValue)
	local ret = false
	if self.play_way_type and (bit._and(self.play_way_type, 0x40080) == 0x40080) then
        if self.bao_val then
			local bao1 = bit._and(self.bao_val,0xff) or 0
			local bao2 = bit._and(bit.rshift(self.bao_val,8),0xff) or 0
			if bao1 == cardValue or bao2 == cardValue then
				ret = true
			end
        end
	end
    return ret
end

function XYCardPart:getPlaywayType()
	local ret = 0
	if self.owner and self.owner.getPlaywayType then
		ret = self.owner:getPlaywayType()
	end
	return ret
end

return XYCardPart
