
local CURRENT_MODULE_NAME = ...
local HBCardLayer = class("HBCardLayer", import(".CardLayer"))

--杠的同牌不同组合 的选择列表

local function gangCardModelAndCount(hbCardLayer, cardValue)
    local isBaoCard = hbCardLayer.part:isPiZi(cardValue)
    local cardModel = isBaoCard and hbCardLayer.node.chiPanel or hbCardLayer.node.ma_panel1
    local cardCount = #cardModel:getChildren()
    return cardModel, cardCount
end

local function gangCardTextureName(hbCardLayer, cardValue)
    local type, value = hbCardLayer.card_factory:decodeValue(cardValue)
	return string.format("%s/mine/M_%s_%d.png", hbCardLayer.res_base, RoomConfig.CardType[type], value)
end

function HBCardLayer:onCreate() 
	HBCardLayer.super.onCreate(self)
	self.card_list[RoomConfig.SpecialOutCard] = {} --手牌队列 
	for i=1,RoomConfig.TableSeatNum do
		self.card_list[RoomConfig.SpecialOutCard][i] = {} 
		local speCardList = self.node["baoList"..i] 
		speCardList:setItemModel(speCardList:getItem(0))
		speCardList:getItem(0):setVisible(false)
		speCardList:setScrollBarEnabled(false)
		speCardList:setTouchEnabled(false)
	end

end

function HBCardLayer:hideOpt()
	HBCardLayer.super.hideOpt(self)
	for i=1,RoomConfig.TableSeatNum do
		--self.node["baoList"..i]:hide()
	end
end

function HBCardLayer:showGangList(gangList)
	--显示可以杠的列表
	self.node.ma_list2:show()
	self.node.ma_list2:removeAllChildren()

	local size_x = 0
	local size_y = self.node.ma_list2:getContentSize().height

	print("=========================================#gangList" .. #gangList)
	for i,v in ipairs(gangList) do
        local cardModel, cardCount = gangCardModelAndCount(self, bit._and(v.cardValue, 0xff))

        self.node.ma_list2:setItemModel(cardModel)
        self.node.ma_list2:insertDefaultItem(i-1)
		local item = self.node.ma_list2:getItem(i-1)

        for j = 1, cardCount do
			local texture_name = gangCardTextureName(self, bit._and(bit.rshift(v.cardValue, (j-1)*8), 0xff))
    		local ma = item:getChildByName("ma" .. j)
			ma:loadTexture(texture_name,1)
			size_x = size_x + ma:getContentSize().width
		end
		size_x = size_x +5
	end
	size_x = size_x -5

	self.node.ma_list2:setContentSize(cc.size(size_x,size_y))
	self.node.ma_list2:forceDoLayout()
	self.node.ma_list2:jumpToPercentHorizontal(50)
	self.node.ma_list2:addEventListener(function(ref,event)
		-- body
		if event == 1 then
			local select_index = self.node.ma_list2:getCurSelectedIndex()
			--发送请求杠牌
			self:hideOpt()

			local cardValue = gangList[select_index+1].cardValue
			local isBaoCard = self.part:isPiZi(bit._and(cardValue, 0xff))

			self.part:requestOptCard(RoomConfig.Gang, cardValue)
		end
	end)
end

function HBCardLayer:createCardFactory()
	local card_factory = import(".HBCardFactory",CURRENT_MODULE_NAME)
  	card_factory:init(
		self.res_base, 
		function(cardValue) return self.part:isLaiZi(cardValue) end,
		function(cardValue) return self.part:isPiZi(cardValue) end,
		function(cardValue) return self.part:isHongzhong(cardValue) end)
	return card_factory
end

function HBCardLayer:addDownCard(viewId,value) 
	HBCardLayer.super.addDownCard(self,viewId,value)  
	self:addSpeCard(viewId,value)
end
 

--重置已经出的牌
function HBCardLayer:resetOutCard(viewId,cardList)
	self:clearSpeOutCard(viewId)
	HBCardLayer.super.resetOutCard(self, viewId, cardList)
end


function HBCardLayer:addSpeCard(viewId, value)
	if true == self.part:isLaiZi(value)  then 
		local frameName = self.card_factory:getFrameNameWithData(viewId, value)
		local speCardList = self.node["baoList"..viewId]
		speCardList:setVisible(true) 
		local itemIndex = #self.card_list[RoomConfig.SpecialOutCard][viewId]
		if itemIndex > 0 or speCardList:getItem(0) == nil then
			speCardList:pushBackDefaultItem() 
		end
		local item = speCardList:getItem(itemIndex)
		item:setVisible(true) 
		item:loadTexture(frameName, 1) 
		local card_data = {
			card_sprite = item,
			card_value = value,
		} 	  
		table.insert(self.card_list[RoomConfig.SpecialOutCard][viewId], card_data) 
	end
end

function HBCardLayer:clearSpeOutCard(viewId)
	local speCardList = self.node["baoList"..viewId]
	speCardList:removeAllChildren()
	for i,v in ipairs(self.card_list[RoomConfig.SpecialOutCard][viewId]) do 
		v = nil
	end
	self.card_list[RoomConfig.SpecialOutCard][viewId] = {}
end

 function HBCardLayer:optCard(viewId,type,value,lastOpt,isreset)
	-- 删除吃碰杠的牌
	print("###[HBCardLayer:optCard] this is optCard:",viewId,type,value,lastOpt)   
	for i, v in ipairs(value.mcard) do 
		if self.part:isLaiZi(v) then  
			self:delUnhandCard(viewId, type, {v}) 
			self:doLaiziGangAction(viewId, v) 
			if viewId == RoomConfig.MySeat then
				self:sortHandCard(viewId, type)
			end 

			local newHandCardList = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat] 
			self.node.marker:hide()
			if isreset == nil or isreset ~= true then
				local sex = self.part:getPlayerInfo(viewId).sex;
				local seat_id = self.part:getPlayerInfo(viewId).seat_id;
				self:playOperateEffect(RoomConfig.LaiziGang , sex , seat_id)
			end
			return
		end
	end  
	HBCardLayer.super.optCard(self, viewId,type,value,lastOpt,isreset)
end


--显示/刷新 左上角的2张牌 潜江的痞字显示朝
function HBCardLayer:refreshBaoCardOnLayer(cardConfig)
	-- body
	local baoInfo1 = cardConfig.baoInfo1
	local type,value = baoInfo1.type, baoInfo1.value
	
	if value > 0 then
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value) 
		print("bao1Name->",texture_name)
		self.node.bao1:loadTexture(texture_name,1)
		self.node.bao1:show()
		self.card_factory:addCardFlag(self.node.bao1, baoInfo1.srcValue)  
	end

	local baoInfo2 = cardConfig.baoInfo2
	type,value = baoInfo2.type,baoInfo2.value
	
	if value > 0 then
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("bao2Name->",texture_name)
		self.node.bao2:loadTexture(texture_name,1)
		self.node.bao2:show() 
		self.card_factory:addCardFlag(self.node.bao2, baoInfo2.srcValue)
	end
end

function HBCardLayer:mapOptPicName(optValue)
	print("HBCardLayer:mapOptPicNam " .. string.format("0x%02x", optValue)) 
	if optValue == RoomConfig.PIZI_NOTIFY then
		return "liang_bt.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_ZIMO then
		return "zimo.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_AN_GANG or optValue == RoomConfig.MAHJONG_OPERTAION_MING_GANG or optValue == RoomConfig.Gang then
		return "xiao.png"
	else
		return HBCardLayer.super.mapOptPicName(self, optValue)
	end 
end

--重置碰杠的牌
function HBCardLayer:resetDownCard(viewId,cardList)   
	self.card_list[RoomConfig.DownCard][viewId] = {} 
	local card_data = {} 
	local index = 1
	print("###[HBCardLayer:resetDownCard] viewID ", viewId)
	dump(cardList)
	for i,v in ipairs(cardList) do 
		print("index v.type v.cardValue ",index, v.type, v.cardValue)
		if v.type  == RoomConfig.MingGang or v.type == RoomConfig.BuGang or v.type == RoomConfig.AnGang then--如果是其他人暗杠是看不到牌的 --自己暗杠可以看到一张牌 
			local c1 = bit._and(v.cardValue,0xff) 
			local c2 = c1
			local c3 = c1 
			local c4 = c1 
			print("###[HBCardLayer:resetDownCard]Gang c1 is ", c1)
			if self.part:isPiZi(c1) then --朝牌使用三张牌的展示
				card_data = {mcard={c1,c2,c3}}
				self:resetDownCard_Peng(viewId, card_data, i)
			else
				--暗杠展示给别人看
				if v.type == RoomConfig.AnGang and viewId == RoomConfig.MySeat then
					c1 = RoomConfig.EmptyCard
					c2 = RoomConfig.EmptyCard
					c3 = RoomConfig.EmptyCard
				end
				local card_dataShow = {mcard={c1,c2,c3,c4}}
				card_data = {mcard={c1,c1,c1,c1}} 
				self:resetDownCard_Gang(viewId, card_dataShow, card_data, i)  
			end 
			index = index + 1
		elseif v.type  == RoomConfig.Peng or v.type == RoomConfig.Chi or v.type == RoomConfig.PIZI_NOTIFY then --直接使用数据创建三张牌  
			local c1 = bit._and(v.cardValue,0xff)
			local c2 = bit._and(bit.rshift(v.cardValue,8),0xff)
			local c3 = bit._and(bit.rshift(v.cardValue,16),0xff)
			print("###[HBCardLayer:resetDownCard]Peng c1 c2 c3 is ", c1,c2,c3)
			card_data = {mcard={c1,c2,c3}} 
			self:resetDownCard_Peng(viewId, card_data, index)
			index = index + 1
		end
	end 
end


return HBCardLayer
