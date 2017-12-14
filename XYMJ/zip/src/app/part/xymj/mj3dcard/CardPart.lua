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
	self.last_opt_id = -1 --���һ��������� 
	self.auto_opt = false --是否处于自动操作状态
	self:setRetainCardNum(-1) --初始化剩余的牌
end

function CardPart:setRetainCardNum(num)
	self._retainCardNum = num --剩余的牌数
end

function CardPart:showAnGang() --暗杠是否要显示一张牌给别人看 保山暗杠需要显示一张牌给别人看
	-- body
	return false
end

--����ģ�� --CardPart初始化
function CardPart:activate(gameId,data)

	self.game_id = gameId


	 CardPart.super.activate(self, CURRENT_MODULE_NAME)
	-- local card_data = self:createDebugData()
	-- for i,v in ipairs(cardData) do
	-- 	if v.view_id == 1 then
	-- 		self.card_list = v.value
	-- 	end
	-- end
	self:resetDialect()--重置方言

	self:init_data(data)
end

--初始化手牌数据（包括断线重连）
function CardPart:init_data(data)
	self.gang_list = {}
	self.opt_list = {}
	self.m_seat_id = data.mtablePos
	self.card_list = data.mcards.cardvalue
	self.mo_card = false
	print("====================================",data)
	local card_data =  { --自己初始的牌由data.mcards.cardvalue决定，其他人的默认RoomConfig.HandCardNum 13 张
					 {view_id = RoomConfig.MySeat,num = #data.mcards.cardvalue,value=data.mcards.cardvalue},
					 {view_id = RoomConfig.DownSeat,num = RoomConfig.HandCardNum,value={}},
					 {view_id = RoomConfig.FrontSeat,num = RoomConfig.HandCardNum,value={}},
					 {view_id = RoomConfig.UpSeat,num = RoomConfig.HandCardNum,value={}},
					}

	self.out_card_list = data.playercard  --�Ѿ������� 玩家已经出了的牌
	self.hu_card_list = data.playerhucards --������ 玩家胡的牌
	self.down_card_list = data.playerdowncards --�����ܵ��� 玩家吃/碰/杠的牌
	local cur_seat_id = data.chucardplayerindex -- 出牌玩家的座位
	local cur_view_id = self:changeSeatToView(cur_seat_id) -- 出牌玩家相对于自己的座位

	self:turnSeat(cur_view_id,nil,data.playeroperationtime)

	self.view.majorViewId = self.majorViewId; -- @Deek

	-- 2.5D, 这里需要有 一个发牌的动作过程, 先创建待发牌队列
	self.view:createReadyCard(card_data, 34 * 4)-- TODO: 牌总数量需要由服务器下发

	-- 2.5D, TODO: 手牌需要有一个发牌的动作过程
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
			print(string.format("###[CardPart:activate]其他玩家断线重连 player:%d card.type %02x card_value %02x", i, card.type, card_value))
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
	local outNum=0
	for i=1,4 do
		local view_id = self:changeSeatToView(i-1)
		local out_card = data.playercard[i]
		out_cards[view_id] = out_card and out_card.cardvalue or {}
		self.view:resetOutCard(view_id, out_cards[view_id], true)
	end

	if data.chucard and data.chucard > 0 then -- 当前操作玩家打出的牌，断线重链时此字段有值
		self:showOutCard(cur_view_id,data.chucard)
	end
end

function CardPart:refreshBaoCardOnPart(baoCard)
	-- body
	print("refreshBaoCard1")
	self.bao_val = baoCard
	self.view:refreshBaoCardOnLayer(baoCard)
end

function CardPart:deactivate()
	print("CardPart===deactivate")
	self.tingRecordList   = {}  	--听牌的信息列表
	self.selfSelectedCard = nil
	self.tingList = nil
	if self.view then 
		self.view:removeSelf()
		self.view =  nil
	end
end

function CardPart:offlinePlayer(pos,online)
 	if self.view then
 	   self.view:offlinePlayer(pos,online)	
 	end
end

function CardPart:getPartId()
	-- body
	return "CardPart"
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

	-- if viewId == RoomConfig.MySeat then
		-- if self._addOpt then  self._addOpt=nil return end
		-- self.view:showMyCardMask(false)
	-- else
	-- 	self.view:showMyCardMask(true)
	-- end

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

--摸一张牌
function CardPart:drawOneCard()
	self.view:removeReadyCardByNum(1)	
end

--���һ����
function CardPart:getCard(data) --摸牌 数据和UI处理
	-- body
	print("this is card part mo card ---------------------------------:",self.mo_card)
	release_print(os.date("%c") .. "[info] 牌摸一张牌 ",data)
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
	release_print(os.date("%c") .. "[info] 牌请求出一张牌 ",value)
	if value == 0 then  --TODO 用于定位出0牌的问题，解决后删除上报
		local user = global:getGameUser()
		local uid = user:getProp("uid")
		local logFilepath = cc.FileUtils:getInstance():getLogFilePath()

		local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
		http_mode:UpLoadLogFile(uid, 524545, logFilepath, "chulingpai")
	end
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

	--请求听牌出牌：待优化
	-- self:requestOutCardForTingPai(value)
	--[[
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
	--]]
end

--听牌请求
function CardPart:requestOutCardForTingPai(value) --向服务器请求出牌
	print("this is send card:",value,index)
	release_print(os.date("%c") .. "[info] 牌请听牌一张牌 ",value)
	if value == 0 then  --TODO 用于定位出0牌的问题，解决后删除上报
		local user = global:getGameUser()
		local uid = user:getProp("uid")
		local logFilepath = cc.FileUtils:getInstance():getLogFilePath()

		local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
		http_mode:UpLoadLogFile(uid, 524545, logFilepath, "chulingpai")
	end
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_SELECT_CARD_TING
	player_table_operation.card_value = value
    player_table_operation.player_table_pos = self.m_seat_id
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	-- if SocketConfig.IS_SEQ == false then
		local buff_str = player_table_operation:SerializeToString()
		local buff_lenth = player_table_operation:ByteSize()
		net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	-- elseif SocketConfig.IS_SEQ == true then
	-- 	net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	-- end
end


function CardPart:showOutCard(viewId,value)
	release_print(os.date("%c") .. "[info] 牌展示出一张牌 ",value)
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

function CardPart:showHuCardSp(viewId,value,t)
	self.last_opt_id = viewId  --最后动作的人
	self.view:showHuCardSp(viewId,value,t) --展示出牌的动画
end

--���� 这个方法在收到消息 MSG_PLAYER_OPERATION_NTF 后被调用，用于把出的 没有被吃杠碰的牌 放入已出牌队列
function CardPart:outCard(viewId,value)  --把出的牌放入已出牌队列
	-- body
	-- self.view:addOutCard(viewId,value) --把出的牌放入已出牌队列	
end

--���ܹ����� 向服务器发送操作请求
function CardPart:requestOpt(type)
	release_print(os.date("%c") .. "[info] 牌向服务器发送操作请求 ",type)
	if RoomConfig.Ai_Debug then
		local ai_mode = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mode:requestMOpt(type)
	else
		local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
		if type == RoomConfig.MAHJONG_OPERTAION_AN_GANG or type == RoomConfig.MAHJONG_OPERTAION_BU_GANG or type ==RoomConfig.MAHJONG_OPERTAION_MING_GANG or type == RoomConfig.Gang then
		   player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_MING_GANG  --不管啥杠服务器自己知道是啥杠
		   self.mo_card = false
		   print("self.server_data_gang->",self.server_data)
		else
            player_table_operation.operation = type
		end

		if player_table_operation.operation == RoomConfig.MAHJONG_OPERTAION_CANCEL then
			player_table_operation.operation = bit._or(0x100,RoomConfig.MAHJONG_OPERTAION_CANCEL)
		end

		player_table_operation.card_value = self.server_data
        player_table_operation.player_table_pos = self.m_seat_id
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)

		if SocketConfig.IS_SEQ == false then		
			local buff_str = player_table_operation:SerializeToString()
			local buff_lenth = player_table_operation:ByteSize()
			net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		elseif SocketConfig.IS_SEQ == true then
			net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
		end
	end
	self.server_data = nil
	self.view:setGangPicState(false)
end

function CardPart:requestOptCard(type,cardValue)
	self.server_data = cardValue
	self:requestOpt(type)
end
--֪ͨ�������ܹ�����
function CardPart:ntfOpt(type,value,serverDate,gangList)
	print("###[CardPart:ntfOpt]type,value ", type,value)
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
	local tbDownCardList = {}
	if self.auto_opt == false then
		if bit._and(value.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then 
			-- self._addOpt = true
			local c1 = bit._and(value.pengcardvalue,0xff)
			if self.view then
				local card_type,card_value = self.view.card_factory:decodeValue(c1) --预留给牌子
				print("card_type:"..card_type.."    card_value:"..card_value)
			end
			print("pengc1:=======:"..c1)
			table.insert(tbDownCardList,c1)
		elseif bit._and(value.operation,RoomConfig.Gang) == RoomConfig.Gang then
			-- self._addOpt = true
			local  gangList=value.gangList
			for i,v in ipairs(gangList) do
				local c1 = bit._and(bit.rshift(v.cardValue,0),0xff)
				print("Gang==c1:"..c1)
				table.insert(tbDownCardList,c1)
			end
		end

		self.server_data = value.pengcardvalue
		print("value===============================:",value)
		print("this is show add opt:",#self.opt_list)
		if disPlayGuo then
			table.insert(self.opt_list,RoomConfig.MAHJONG_OPERTAION_CANCEL)
		end
		self.view:showAddOpt(clone(self.opt_list))
		self.view:downUpateMyCardMask(tbDownCardList)
		
		self.opt_list = {}
	end
end

-- function CardPart:optClick(type)
-- 	-- body
-- 	if type == RoomConfig.Chi then
-- 		self:doChiClick()
-- 	else
-- 		self:requestOpt(type)
-- 	end	
-- end


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
	print("###[CardPart:optCard]viewId,type,value,hideCardOptPart   ",viewId,type,value,hideCardOptPart)
	--dump(value)
	-- body
	self:removeOutCard(self.last_opt_id) 
	if type == RoomConfig.Chi then
	elseif type == RoomConfig.Peng then --����Ҫ���Լ��Ķ���ɾ�������ƣ��ӳ��ƶ�����ɾ��������
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
	elseif type == RoomConfig.MAHJONG_OPERTAION_REFRESHBAO then  --更新宝牌
		self:refreshBaoCardOnPart(value.ocard)
		return
	end
	self.view:optCard(viewId,type,value,self.last_opt_id,hideCardOptPart) --UI展示玩家吃,碰,杠
	if hideCardOptPart == nil or hideCardOptPart ~= true then
		self.view:optEffect(viewId,type)
	-- 	local node,pos = self.view:getOptPos(viewId)
	-- 	local card_opt_part = self:getPart("CardOptPart") -- 展示碰杠那个字
	-- 	card_opt_part:activate(pos,type,node)
	end
	-- self.view:turnSeat(viewId)
	-- self.owner:turnSeat(viewId)
end

--删除最后的牌
function CardPart:removeLastOptCard()
	-- body
	self:removeOutCard(self.last_opt_id)
end
function CardPart:setLastCardViewPos()
	print("this is setLastCardViewPos----------------",self.last_opt_id)
	self.view:setLastCardViewPos(self.last_opt_id)
		dump(self.last_opt_id)

end

function CardPart:removeOutCard(viewId)
	-- body
	self.view:removeCurOutCard(viewId)
end

--更新最新的牌数
function CardPart:updateLastCardNum(num)
	print("num:"..num)
	if self._retainCardNum ~=num then
	 	local reduceCardNum = self._retainCardNum -num
	 	print("reduceCardNum:"..reduceCardNum)
	 	print("retainCardNum:"..self._retainCardNum)
	 	print("num:"..num)
	 	self._retainCardNum = num
	 	self:reduceTricksNum(reduceCardNum)
	end
	if self.view then
		self.view:updateLastCardNum(num)
	end
end

function CardPart:reduceTricksNum(num)
	if num == 0 then return end
	self.view:removeReadyCardByNum(num)
end

--修正牌墩
function CardPart:adujstReadyCard()

end

--当前子游戏的配置路径
function CardPart:getGameAssetsPath()
	print("game_id:"..self.game_id)
 	local user = global:getGameUser()
 	local gameInfo = user:getGameInfo(tonumber(self.game_id))
 	if not gameInfo or not gameInfo.assetsPath then
 		return ""
 	end
 	print("assetsPath:"..gameInfo.assetsPath)
 	return gameInfo.assetsPath
end

function CardPart:resetDialect()
	local dialectKey = "Dialect"
	local userDefault = cc.UserDefault:getInstance()
	local b = userDefault:getBoolForKey(dialectKey, false)
	self.bDialect = b
end

function CardPart:IsSetDialect()
	return self.bDialect
end

--胡牌推倒 
function CardPart:pushOverHandCard(handCards)
	-- --手牌为全部不可见
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


--听牌功能
-------------------------------------------------------------------
--听牌：(断线重连听牌的话会发这个消息)
function CardPart:onlyTingCard(data)
	--如果是自己的话:灯泡为不可见
	if not data or not data.tingRecords then return end
	local tingData=data.tingRecords
		-- print("onlyTingCardonlyTingCardViewId:"..viewId)
		-- if viewId ~= RoomConfig.MySeat then return end
		print("onlyTingCardonlyTingCard",tingData)

		-- local  viewId = self:changeSeatToView()
		self.tingList   = {}  	--听牌的信息列表
		if  not tingData then return end
		for i,v in ipairs(tingData) do
			local tingRecords = v
			local  tingRecord	 ={}
			tingRecord.cardvalue = tingRecords.cardValue --0
			local  details= tingRecords.details
			local  tingCardDetailList= {}
			for j,vd in ipairs(details) do
				--所听牌的详情
				local tingCardDetail = {} 	
				tingCardDetail.cardvalue =vd.cardValue
				tingCardDetail.fanNum =vd.fanNum
				tingCardDetail.cardLeftNum =vd.cardLeftNum
				table.insert(tingCardDetailList,tingCardDetail)
			end
			tingRecord.tingRecordDetails = tingCardDetailList
			table.insert(self.tingList,tingRecord)
		end
		dump(self.tingList)
		local tingRecord = self.tingList[1] --
		if not tingRecord then return end
		--[听牌刷新]
		local tingRecords = self:filterTingRecordDetails(tingRecord.tingRecordDetails)
		dump(tingRecords)
		self:refreshDrawingTip(tingRecords)
		local viewId=self:changeSeatToView(data.playertablepos)
		-- if viewId ==RoomConfig.MySeat then return end
		if self.selfSelectedCard then   --自己选中的话，直接
			print("灯泡隐藏")
			self.selfSelectedCard = nil
		else
			--[听牌隐藏] ,[灯泡显示]
			print("灯泡显示")
			self:showDrawingTip(false)
		end

end

-- --手牌提示要打出的牌添加标识
-- function CardPart:drawingHandCardTip(tingData)
-- 	self.tingRecordList   = {}  	--听牌的信息列表
-- 	if  not tingData then return end
-- 	for i,v in ipairs(tingData) do
-- 		local tingRecords = v
-- 		local  tingRecord	 ={}
-- 		tingRecord.cardvalue = tingRecords.cardValue
-- 		local  details= tingRecords.details
-- 		local  tingCardDetailList= {}
-- 		for j,vd in ipairs(details) do
-- 			--所听牌的详情
-- 			local tingCardDetail = {} 	
-- 			tingCardDetail.cardvalue =vd.cardValue
-- 			tingCardDetail.fanNum =vd.fanNum
-- 			tingCardDetail.cardLeftNum =vd.cardLeftNum
-- 			table.insert(tingCardDetailList,tingCardDetail)
-- 		end
-- 		tingRecord.tingRecordDetails = tingCardDetailList
-- 		table.insert(self.tingRecordList,tingRecord)
-- 	end

-- 	self:updataHandDrawingCard(self.tingRecordList)
-- end


--听牌信息:
--playertablepos
--不是我就刷新
--手牌提示要打出的牌添加标识
function CardPart:drawingHandCardTip(data)
	print("drawingHandCardTip")
	if  not data or  not data.tinglist then return end 
	self.tingRecordList   = {} 
	self.tingRecordList = data.tinglist
	self:updataHandDrawingCard(self.tingRecordList)
end

function CardPart:updataHandDrawingCard(tingRecordList)
	-- if self.view then
	-- 	local drawingMaskList = {}
	-- 	for i,v in ipairs(tingRecordList) do
	-- 		table.insert(drawingMaskList,v.cardvalue)
	-- 	end
	-- 	self.view:showdrawingCard(drawingMaskList)
	-- end
	if self.view then
		local drawingMaskList = {}
		for i,v in ipairs(tingRecordList) do
			table.insert(drawingMaskList,v)
		end
		self.view:showdrawingCard(drawingMaskList)
	end  
end

--分割数据
function CardPart:filterTingRecordDetails(tingRecordDetails)
	if not tingRecordDetails then return  nil end
	local filterDetailList ={} 		--处理成n行m列的数据
	local constCol = 5
	local rowNum = math.ceil (#tingRecordDetails/constCol)
	local function initFilterDetailList()
		for i=1,rowNum do
			table.insert(filterDetailList,{})
		end
	end
	initFilterDetailList()
	-- dump(filterDetailList)
	for i,v in ipairs(tingRecordDetails) do
		local rowIndex=math.ceil (i/constCol)
		-- print("rowIndex:"..rowIndex)
		local filterDetailRowData = filterDetailList[rowIndex]
		table.insert(filterDetailRowData,v)
	end
	return filterDetailList
end

--b为false显示灯泡：
--ture为直接显示听牌列表
function CardPart:getTingRecordByCardValue(cardvalue,b)
	-- if not self.tingRecordList or #self.tingRecordList== 0 then 
	-- 	self:allDrawTipHide()
	-- 	return
	-- end
	-- local notIRL =true
	-- for i,v in ipairs(self.tingRecordList) do
	-- 	local tingRecord = v
	-- 	if tingRecord.cardvalue == cardvalue then
	-- 		local tingRecords = self:filterTingRecordDetails(tingRecord.tingRecordDetails)
	-- 		self:refreshDrawingTip(tingRecords)
	-- 		notIRL =false
	-- 		break
	-- 	end
	-- end
	-- if notIRL then
	-- 	self:allDrawTipHide()
	-- end


	if not self.tingRecordList or #self.tingRecordList== 0 then 
		return
	end
	local function inTingRecordList(value)
		local b = false
		for k,v in ipairs(self.tingRecordList) do
			local cardSlectTing = v
			if cardSlectTing == value then
				b = true
				break
			end
		end
		return b
	end
	local inTingb = inTingRecordList(cardvalue)
	if inTingb then
		print("requestOutCardForTingPai:"..cardvalue)
		self:requestOutCardForTingPai(cardvalue)
		if b then
			self.selfSelectedCard = true
		end
	else
		self:clearTinglisandAllDrawTipHide()
	end
end

function CardPart:clearTinglisandAllDrawTipHide()
	self.tingList = nil
	print("notnotnot")
	self:allDrawTipHide()
end

function CardPart:allDrawTipHide()
	if self.view then
		self.view:allDrawTipHide()
	end
end

function CardPart:showDrawingTip(b)
	if not self.tingList then return end
	local tingRecord = self.tingList[1]
	if not tingRecord then return end
	dump(tingRecord.tingRecordDetails)
	if #tingRecord.tingRecordDetails==0 then
		return
	end

	if self.view then
		self.view:showDrawingTip(b)
	end
	if b == false then
		print("正常显示")
	end
end

--刷新听牌列表
function CardPart:refreshDrawingTip(tingRecord)
	if self.view then
		-- print("tingRecord:"..#tingRecord)
		dump(tingRecord)
		self.view:refreshDrawingTip(tingRecord)
	end
end

--干掉听牌上面的听牌箭头
function CardPart:clearTingCardsArrow()
	if self.view then
		self.view:clearTingCardsArrow()
	end
end

-------------------------------------------------------------------
function CardPart:initTableWithData(player_list,data)
	self.view:initTableWithData(player_list,data)
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
	if not self.gang_list or #self.gang_list == 0 then
		print("###[CardPart:gangClick]not self.gang_list or #gang_list == 0 ")
		self.view:hideOpt()
		return
	end 
	local size = #self.gang_list
	if size == 1 then --只有一个直接杠
		print("###[CardPart:gangClick]杠")
		self.server_data =  self.gang_list[1].cardValue
		self:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
		self.view:hideOpt()
		self:clearTingCardsArrow()
	elseif size > 1 and size <= 4 then --可以杠的列表小于等于4直接列出杠的情况 
		print("###[CardPart:gangClick]展示杠列表")
		self.view:showGangList(self.gang_list) --列出刚的详细列表
	else
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

function CardPart:optClick(type)
	-- body
	if type == RoomConfig.Chi then
		self:doChiClick()
	elseif type == RoomConfig.Gang then
		self:gangClick()
	else
		self:requestOpt(type)
	end
	
end


function CardPart:ntfGangList(gangList) 
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

function CardPart:getCardFactory()
	return self.view:getCardFactory()
end


function CardPart:getServerData()
	return self.server_data
end

function CardPart:headClick(player_info , posX , posY , viewId)
	self.owner:headClick(player_info , posX , posY , viewId)
end

function CardPart:updateScoreNtf(score_ntf)
	self.view:updateScoreNtf(score_ntf)
end

return CardPart
