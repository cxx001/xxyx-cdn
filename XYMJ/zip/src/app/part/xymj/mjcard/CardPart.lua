--[[
*名称:CardLayer
*描述:手牌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local CardPart = class("CardPart",cc.load('mvc').PartBase) --��¼ģ��

CardPart.DEFAULT_PART = {
	"CardOptPart"
}
CardPart.DEFAULT_VIEW = "CardLayer"
--[
-- @brief ���캯��
--]
function CardPart:ctor(owner)
    CardPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function CardPart:initialize()
	self.last_opt_id = -1 --上一次操作玩家位置?
	self.auto_opt = false --是否处于自动操作状态
end

function CardPart:showAnGang() --暗杠是否要显示一张牌给别人看 保山暗杠需要显示一张牌给别人看
	-- body
	return false
end

--[[
@ 调整回放手里的牌
]]
function CardPart:initRecordHands(card_data, frame_data)
	if not frame_data or not frame_data.record_mode then
		return 
	end

	card_data = {}
	local hands = frame_data.hands
	for i, hand in ipairs(hands) do
		local view_id = self:changeSeatToView(i-1)
		local cards = {
			view_id = view_id,
			num 	= #hand,
			value 	= hand,
		}
		card_data[view_id] = cards
	end

	return card_data
end

function CardPart:resetCardDataExt(data,optData)
	-- body
	self.view:resetAllCards()

	self.opt_list = {}
	self.m_seat_id = data.mtablePos
	self.card_list = data.mcards.cardvalue
	self.mo_card = false
	local card_data =  { --自己初始的牌由data.mcards.cardvalue决定，其他人的默认RoomConfig.HandCardNum 13 张
					 {view_id = 1,num = #data.mcards.cardvalue,value=data.mcards.cardvalue},
					 {view_id = 2,num = RoomConfig.HandCardNum,value={}},
					 {view_id = 3,num = RoomConfig.HandCardNum,value={}},
					 {view_id = 4,num = RoomConfig.HandCardNum,value={}},
					}

	if data.record_mode then
		self.record_mode = true
		card_data = self:initRecordHands(card_data, data)
	end

	self.out_card_list = data.playercard  --�Ѿ������� 玩家已经出了的牌
	self.hu_card_list = data.playerhucards --������ 玩家胡的牌
	self.down_card_list = data.playerdowncards --�����ܵ��� 玩家吃/碰/杠的牌
	local cur_seat_id = data.chucardplayerindex -- 出牌玩家的座位
	local cur_view_id = self:changeSeatToView(cur_seat_id) -- 出牌玩家相对于自己的座位

	local out_cards = {}
	for i=1,4 do
		local view_id = self:changeSeatToView(i-1)
		local out_card = data.playercard[i]
		out_cards[view_id] = out_card or {}
	end

	local down_cards = {}  --处理断线重连，需要展示已经吃杠碰的牌的情况
	local m_view_id = 0
	for i=1,4 do
		local num = 0
		local view_id = self:changeSeatToView(i-1)
		local down_card = data.playerdowncards[i]
		down_cards[view_id] = down_card or {}
	end

	self:turnSeat(cur_view_id,nil,data.playeroperationtime)
	for i=1, 4 do
		local view_id = self:changeSeatToView(i-1)
		if view_id == RoomConfig.MySeat then
			self.view:refreshMyCard(data.hands[i], down_cards[view_id], out_cards[view_id])
		else
			self.view:refreshOtherCard(view_id,down_cards[view_id], data.hands[i], out_cards[view_id])
		end
	end

	--data.baocard = 0x1121 --宝牌测试数据
	self:refreshBaoCardOnPart(data.baocard)
	-- if data.chucard and data.chucard > 0 then -- 当前操作玩家打出的牌，断线重链时此字段有值
	-- 	self:showOutCard(cur_view_id,data.chucard)
	-- end

	local node,pos = self.view:getOptPos(cur_view_id)
	local card_opt_part = self:getPart("CardOptPart") -- 展示碰杠那个字
	if bit._and(optData.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU then
		self:showOutCard(cur_view_id,optData.card_value)
	elseif bit._and(optData.operation, RoomConfig.MAHJONG_OPERTAION_AN_GANG) ==RoomConfig.MAHJONG_OPERTAION_AN_GANG or 
		bit._and(optData.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG or 
		bit._and(optData.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		card_opt_part:activate(self.game_id, pos,RoomConfig.MAHJONG_OPERTAION_AN_GANG,node)
	elseif bit._and(optData.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then --碰
		card_opt_part:activate(self.game_id, pos,RoomConfig.MAHJONG_OPERTAION_PENG,node)
	elseif bit._and(optData.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then --吃
		card_opt_part:activate(self.game_id, pos,RoomConfig.MAHJONG_OPERTAION_CHI,node)
	end
	
end

--����ģ�� --CardPart初始化
function CardPart:activate(gameId,data)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	 CardPart.super.activate(self, CURRENT_MODULE_NAME)
	-- local card_data = self:createDebugData()
	-- for i,v in ipairs(cardData) do
	-- 	if v.view_id == 1 then
	-- 		self.card_list = v.value
	-- 	end
	-- end
	self:init_data(data)
end

function CardPart:init_data(data)
	self.opt_list = {}
	self.m_seat_id = data.mtablePos
	self.card_list = data.mcards.cardvalue
	self.mo_card = false
	local card_data =  { --自己初始的牌由data.mcards.cardvalue决定，其他人的默认RoomConfig.HandCardNum 13 张
					 {view_id = 1,num = #data.mcards.cardvalue,value=data.mcards.cardvalue},
					 {view_id = 2,num = RoomConfig.HandCardNum,value={}},
					 {view_id = 3,num = RoomConfig.HandCardNum,value={}},
					 {view_id = 4,num = RoomConfig.HandCardNum,value={}},
					}

	self.out_card_list = data.playercard  --�Ѿ������� 玩家已经出了的牌
	self.hu_card_list = data.playerhucards --������ 玩家胡的牌
	self.down_card_list = data.playerdowncards --�����ܵ��� 玩家吃/碰/杠的牌
	local cur_seat_id = data.chucardplayerindex -- 出牌玩家的座位
	local cur_view_id = self:changeSeatToView(cur_seat_id) -- 出牌玩家相对于自己的座位

	self:turnSeat(cur_view_id,nil,data.playeroperationtime)
	self.view:createCardWithData(card_data)

	--data.baocard = 0x1121 --宝牌测试数据
	self:refreshBaoCardOnPart(data.baocard)

	local down_cards = {}  --处理断线重连，需要展示已经吃杠碰的牌的情况
	local m_view_id = 0
	for i=1,4 do
		local num = 0
		local view_id = self:changeSeatToView(i-1)
		local down_card = data.playerdowncards[i]
		down_cards[view_id] = down_card and down_card.cards or {}
	end

	print("This is down_card[1]::-----------------------------------------------------------------------------------,",#down_cards[1])
	self:refreshMyCard(data.mcards.cardvalue,down_cards[1],{})
	for i=2,4 do
		local down_card = down_cards[i]
		for _,card in ipairs(down_card) do
			local card_value = card.cardValue
			local c1 = bit._and(card_value,0xff)
			local c2 = bit._and(bit.rshift(card_value,8),0xff)
			local c3 = bit._and(bit.rshift(card_value,16),0xff)
			local card_data = {mcard={c1,c2},ocard=c3}
			
			if card.type == RoomConfig.BuGang or card.type == RoomConfig.MingGang then --断线重连补杠要变明杠才好显示牌
				card.type = RoomConfig.MingGang
				card_data = {mcard={c1,c2,c2},ocard=c3}
			elseif card.type == RoomConfig.AnGang then
				if self:showAnGang() then
					card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,c3},ocard=RoomConfig.EmptyCard}
				else
					card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard},ocard=RoomConfig.EmptyCard}
				end
			end
			self:optCard(i,card.type,card_data,true)
		end
	end

	local out_cards = {}
	for i=1,4 do
		local view_id = self:changeSeatToView(i-1)
		local out_card = data.playercard[i]
		out_cards[view_id] = out_card and out_card.cardvalue or {}
		self.view:resetOutCard(view_id, out_cards[view_id])
	end
	if data.chucard and data.chucard > 0 then -- 当前操作玩家打出的牌，断线重链时此字段有值
		self:showOutCard(cur_view_id,data.chucard)
	end
end

function CardPart:refreshBaoCardOnPart(baoCard)
	-- body
	print("refreshBaoCard1")
	self.view:refreshBaoCardOnLayer(baoCard)
end

function CardPart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view = nil
	end
end

function CardPart:getPartId()
	-- body
	return "NormalCardPart"
end

function CardPart:tingCard(value)
	-- body 
	self.view:showTingCard(value) --展示听牌页面
end

--�ֵ�˭����
function CardPart:turnSeat(viewId,cardValue,lastTime)
	-- body
	self.opt_list = {}
	self.view:turnSeat(viewId)  -- 设置是否可以操作牌，只有轮到自己的时候才能操作牌
	self.owner:turnSeat(viewId,lastTime) --猜测，展示轮到谁出牌的箭头和倒计时
	if cardValue then
		self.owner:getCard() ----摸牌 更新剩余牌数量的数字
	end

	if viewId == RoomConfig.MySeat and cardValue then --轮到自己，摸牌
		self:getCard(cardValue) --摸牌
	end

end

function CardPart:refreshOtherCard(viewId,cardValue) -- 把viewId对应的玩家的吃杠碰的牌替换成cardValue
	-- body
	self.view:refreshOtherCard(viewId,cardValue)
end

function CardPart:refreshMyCard(hcard,dcard,ocard,value) -- 刷新自己的手牌和 dcard_list
	-- bod
    self.card_list = hcard
    self.dcard_list = dcard
	self.view:refreshMyCard(hcard,dcard,ocard,value)
	-- if value then
	-- 	self:showOutCard(RoomConfig.MySeat,value)
	-- end
end

--���һ����
function CardPart:getCard(data) --摸牌 数据和UI处理
	-- body
	print("this is card part mo card ---------------------------------:",self.mo_card)
	if self.mo_card == false then
		self:removeOutCard(RoomConfig.MySeat)
		table.insert(self.card_list,data)
		self.mo_card = true
		self.view:getCard(data)
	end
end

function CardPart:requestOutCard(value) --向服务器请求出牌
	-- body
	print("this is send card:",value,index)
	if RoomConfig.Ai_Debug then
		local ai_mode =global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mode:requestOutCard(value)
	else
		local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
		player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_CHU
		player_table_operation.card_value = value
        player_table_operation.player_table_pos = self.m_seat_id
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
		self.mo_card = false
		if SocketConfig.IS_SEQ == false then
			local buff_str = player_table_operation:SerializeToString()
			local buff_lenth = player_table_operation:ByteSize()
			net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		elseif SocketConfig.IS_SEQ == true then
			net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		end
	end
	self.view:setGangPicState(false)
	self:showOutCard(RoomConfig.MySeat,value)
end

function CardPart:showOutCard(viewId,value)
	-- body
	self.last_opt_id = viewId  --最后动作的人
	-- self:removeOutCard() --移除当前出的牌
	self.view:outCard(viewId,value) --展示出牌的动画
end

function CardPart:showAutoOutCard(value)
	-- body
	if self.auto_opt == true then
		self:showOutCard(RoomConfig.MySeat,value)
	end
end

function CardPart:showHuCardSp(viewId,value)
	self.last_opt_id = viewId  --最后动作的人
	self.view:showHuCardSp(viewId,value) --展示出牌的动画
end

--���� 这个方法在收到消息 MSG_PLAYER_OPERATION_NTF 后被调用，用于把出的 没有被吃杠碰的牌 放入已出牌队列
function CardPart:outCard(viewId,value)  --把出的牌放入已出牌队列
	-- body
	-- self.view:addOutCard(viewId,value) --把出的牌放入已出牌队列	
end

--���ܹ����� 向服务器发送操作请求
function CardPart:requestOpt(type)
	print("##[CardPart:requestOpt]", type)
	-- body
	if RoomConfig.Ai_Debug then
		local ai_mode = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mode:requestMOpt(type)
	else
		local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
		if type == RoomConfig.MAHJONG_OPERTAION_AN_GANG or type == RoomConfig.MAHJONG_OPERTAION_BU_GANG or type == RoomConfig.MAHJONG_OPERTAION_MING_GANG or type == RoomConfig.Gang then
		   player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_MING_GANG --不管啥杠服务器自己知道是啥杠
		   self.mo_card = false
		   print("self.server_data_gang->",self.server_data)
		else
            player_table_operation.operation = type
		end
		player_table_operation.card_value = self.server_data
        player_table_operation.player_table_pos = self.m_seat_id
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
		print("###[CardPart:requestOpt]向服务器发送操作请求 type is ", type)  
		if SocketConfig.IS_SEQ == false then	
			print("###[CardPart:requestOpt] SocketConfig.IS_SEQ == false")	
			local buff_str = player_table_operation:SerializeToString()
			local buff_lenth = player_table_operation:ByteSize()
			net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		elseif SocketConfig.IS_SEQ == true then
			print("###[CardPart:requestOpt] SocketConfig.IS_SEQ == true")	
			net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		end
	end
	self.server_data = nil
	self.view:setGangPicState(false)
end

function CardPart:requestOptCard(type,cardValue)
	print("###[CardPart:requestOptCard] cardValue is ", cardValue)
	self.server_data = cardValue 
	self:requestOpt(type)
end
--֪ͨ�������ܹ�����
function CardPart:ntfOpt(type,value,serverDate,gangList)
	-- 只有非自动托管状态才可以碰杠
	if self.auto_opt == false then
		self.view:showOpt(type,value)
		self.server_data = serverDate
	end
end

--添加一个操作选项
function CardPart:addOpt(type)
	print("this is add opt:",type)
	table.insert(self.opt_list,type)
end

function CardPart:showAddOpt(value,disPlayGuo)
	-- body
	if self.auto_opt == false then
		self.server_data = value
		print("this is show add opt:",#self.opt_list)
		if disPlayGuo then
			table.insert(self.opt_list,RoomConfig.MAHJONG_OPERTAION_CANCEL)
		end
		self.view:showAddOpt(clone(self.opt_list))
		self.opt_list = {}
	end
end
 


function CardPart:removeLastCard(viewId,value)
	-- body
	self.view:removeLastCard(viewId,value)
end

function CardPart:showHuAnimate(viewId,maList,huType)
	-- body
	self.view:showHuAnimate(viewId,maList,huType)
end

--�ԣ�������
--[[
	value = {
		ocard = 1 --���˳�����
		mcard = {1,1} --�ҵ���
	}
	hideCardOptPart : 为true时不展示CardOptPart
--]]
function CardPart:optCard(viewId,type,value,hideCardOptPart) --执行玩家 viewId 类型 type 的吃杠碰操作 
	print(string.format("###[CardPart:optCard]玩家吃碰杠回包 viewID %d type %x", viewId, type))
	-- body
	self:removeOutCard(self.last_opt_id)
	if type == RoomConfig.Chi then
	elseif type == RoomConfig.PIZI_NOTIFY or type == RoomConfig.Peng then --����Ҫ���Լ��Ķ���ɾ�������ƣ��ӳ��ƶ�����ɾ��������
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
		
	elseif type == RoomConfig.AnGang then  --�Լ������ĸ��ǰ���

	elseif type == RoomConfig.MingGang then

	elseif type == RoomConfig.BuGang then
	elseif type == RoomConfig.MAHJONG_OPERTAION_POP_LAST then --更新宝牌
		self.mo_card = false
		self:refreshBaoCardOnPart(value.ocard)
		return
	end
	self.view:optCard(viewId,type,value,self.last_opt_id,hideCardOptPart) --UI展示玩家吃,碰,杠
	self:playChiPengGangAni(viewId, type, hideCardOptPart)
end

function CardPart:playChiPengGangAni(viewId, type, hideCardOptPart)
	if hideCardOptPart == nil or hideCardOptPart ~= true then
		local node,pos = self.view:getOptPos(viewId)
		local card_opt_part = self:getPart("CardOptPart") -- 展示碰杠那个字
		card_opt_part:activate(self.game_id,pos,type,node)
	end
end

function CardPart:removeOutCard(viewId)
	-- body
	self.view:removeCurOutCard(viewId)
end


--У���Ƶ������Ƿ����
function CardPart:checkCardValue(cardList)
	-- body
	for i,v in ipairs(self.card_list) do
		if self.card_list[i] ~= cardList[i].card_value then
			printLog("warring","check card value warring %d pos value have no match value: %d , value %d",i,self.card_list[i],cardList[i].card_value)
			return false
		end
	end
	return true
end

function CardPart:getPlayerInfo(viewId)
	-- body
	return self.owner:getPlayerInfo(viewId)
end

--设置托管状态
function CardPart:setAutoOutCard(state) 
	-- body
	self.view:setAutoOutCard(state)
	self.auto_opt = state
	if state == false then --只有取消托管功能
		self.mo_card = false --取消托管可以摸牌
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
		local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
		opt_msg.opid = RoomConfig.GAME_OPERATION_SET_TUOGUAN
		net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_GAME_OPERATION,self.game_id)
	end
end

function CardPart:changeSeatToView(seatId)
	-- body
	if self.m_seat_id then
		return (seatId - self.m_seat_id + 4)%4 + 1
	end 
end

function CardPart:setChiList(mycard,outcard)
	-- body
	self.chi_data = {chicardvalue = mycard,targetcard = outcard}
end

--点击吃牌后，事件进入这里的处理
function CardPart:doChiClick()
	local chi_list = {}
	for i=1, 4 do
		local v = bit._and(bit.rshift(self.chi_data.chicardvalue,(i-1)*8),0xff)
		if v > 0 then
			table.insert(chi_list,v)
		end
	end

    --存在多组吃牌时，不能直接点吃按钮
    local count = #chi_list;
    
    print("chi_count_total->",count)
  
    if count > 2 then
    	 --显示多组可选的牌 
    	local show_chi_list = {}
    	for i=1,count - 1 do
    		local temp_table = {chi_list[i],chi_list[i+1],self.chi_data.targetcard}
    		table.sort(temp_table)
    		table.insert(show_chi_list,temp_table)
    	end
        self.view:showChiList(show_chi_list) --列出吃的组合列表
    else
    	local value = bit._or(bit.lshift(chi_list[2],8),chi_list[1])
	    print("tagrget is->",target)
	    self.server_data = value
	    self.view:hideOpt()
	    self:requestOpt(RoomConfig.Chi)
    end

   
end

--点击 显示的尾牌后，事件进入这里的处理 index = 1 or 2 1表示第一张牌
function CardPart:doBaoCardClick(index)
	self.server_data = index
    self:requestOpt(RoomConfig.MAHJONG_OPERTAION_POP_LAST)
end

function CardPart:sendChilReq(chiList)
	-- body
	for i,v in ipairs(chiList) do --移除别人的牌
		if v == self.chi_data.targetcard then
			table.remove(chiList,i)
		end
	end
	local value = bit._or(bit.lshift(chiList[2],8),chiList[1]) --组合吃的牌
	print("CardPart:sendChilReq :",value)
	self.server_data = value
	self.view:hideOpt()
    self:requestOpt(RoomConfig.Chi)
end



--杠牌事件处理
function CardPart:gangClick()
	-- body
	-- self.gang_data = {
	-- 	0x31323231,0x33333331,0x34343431,0x32323231,0x33333333
	-- }
	if self.gang_list then
		local size = #self.gang_list
		if size == 1 then --只有一个直接杠
			print("###[CardPart:gangClick] size == 1")
			self.server_data =  self.gang_list[1].cardValue
			self:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
			self.view:hideOpt()
		elseif size > 1 and size <= 4 then --可以杠的列表小于等于4直接列出杠的情况 
			print("###[CardPart:gangClick] size > 1 and size <= 4")
			self.view:showGangList(self.gang_list) --列出刚的相信列表
		elseif size < 1 then
			print("###[CardPart:gangClick] size > 4:" .. #self.gang_list)
		else
			print("###[CardPart:gangClick] size > 4:" .. #self.gang_list)
			local gang_list = {}
			local gang_list1 = {}
			for i,v in ipairs(self.gang_list) do
				local c1 = bit._and(v.cardValue,0xff)
				gang_list[c1] = v --以值为索引防止重复
			end

			for k,v in pairs(gang_list) do
				table.insert(gang_list1,v)
			end

			self.view:showGangSelect(gang_list1) --列出杠的选择列表
		end
	end
end

function CardPart:optClick(type)
	-- body
	if type == RoomConfig.Chi then
		self:doChiClick()
	elseif type == RoomConfig.Gang then
		self:gangClick()
	elseif type == RoomConfig.MAHJONG_OPERTAION_ZIMO then
		self:requestOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	else
		self:requestOpt(type)
	end
	
end


function CardPart:ntfGangList(gangList)
	
	print("###[CardPart:ntfGangList] 填充杠列表") 
	-- body
	self.gang_list = gangList
	self.view:setGangPicState(true)
end

--返回当前选择的牌的值
function CardPart:selectGang(value)
	-- body
	local gang_list = {}
	for i,v in ipairs(self.gang_data) do
		local c1 = bit._and(v,0xff)
		print("this is select gang:",c1,value)
		if c1 == value then
			table.insert(gang_list,v)
		end
	end
	
	if #gang_list == 1 then
		self:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
	else
		self.view:showGangList(gang_list)
	end
	
end

function CardPart:getServerData()
	return self.server_data
end

function CardPart:removeGangOperation()
	self.view:setGangPicState(false)
end

return CardPart
