
local CURRENT_MODULE_NAME = ...
local ESCardLayer = class("ESCardLayer", import(".CardLayer"))

--杠的同牌不同组合 的选择列表

local function gangCardModelAndCount(ESCardLayer, cardValue)
    local isBaoCard = ESCardLayer.part:isPiZi(cardValue)
    local cardModel = isBaoCard and ESCardLayer.node.chiPanel or ESCardLayer.node.ma_panel1
    local cardCount = #cardModel:getChildren()
    return cardModel, cardCount
end

local function gangCardTextureName(ESCardLayer, cardValue)
    local type, value = ESCardLayer.card_factory:decodeValue(cardValue)
	return string.format("%s/mine/M_%s_%d.png", ESCardLayer.res_base, RoomConfig.CardType[type], value)
end

function ESCardLayer:onCreate() 
	ESCardLayer.super.onCreate(self)
	self.card_factory:setPart(self.part)
	self.card_list[RoomConfig.SpecialOutCard] = {} --手牌队列 
	for i=1,RoomConfig.TableSeatNum do
		self.card_list[RoomConfig.SpecialOutCard][i] = {} 
	end
	print("ESCardLayer:onCreate") 
	self.extBaiPai_cardLayer:resetPiZiLaiZiCard()
	
	-- for i=1,RoomConfig.TableSeatNum do
	-- 	self.card_list[RoomConfig.SpecialOutCard][i] = {} 
	-- 	local speCardList = self.out_cardLayer:getBaoListByViewId(i)
	-- 	speCardList:setItemModel(speCardList:getItem(0))
	-- 	speCardList:getItem(0):setVisible(false)
	-- 	speCardList:setScrollBarEnabled(false)
	-- 	speCardList:setTouchEnabled(false)
	-- end
end

function ESCardLayer:hideOpt()
	ESCardLayer.super.hideOpt(self)
	for i=1,RoomConfig.TableSeatNum do
		--self.node["baoList"..i]:hide()
	end
end

function ESCardLayer:showGangList(gangList)
	print("###[ESCardLayer:showGangList]gangList is ")
	dump(gangList)
	--显示可以杠的列表
	self.node.ma_list2:show()
	self.node.ma_list2:removeAllChildren()
	self.node.ma_list2:setItemModel(self.node.ma_panel1)

	local size_x = 0
	local size_y = self.node.ma_list2:getContentSize().height 
	local paiIndex = 1
	for i,v in ipairs(gangList) do
		local c1 = bit._and(bit.rshift(v.cardValue, 0),0xff)
		local type,value = self.card_factory:decodeValue(c1)
		if not self.part:isLaiZi(c1) and not self.part:isPiZi(c1) then
			self.node.ma_list2:insertDefaultItem(paiIndex-1)
			local item = self.node.ma_list2:getItem(paiIndex-1)
			for j = 1,4 do 
	    		local ma = item:getChildByName("ma" .. j)
				local imgv = ma:getChildByName("Img_v")
				self:updateGCListCard(imgv,value,type)
				size_x = size_x + ma:getContentSize().width+2
			end 
			paiIndex = paiIndex + 1
		end 
		size_x = size_x +3
	end
	size_x = size_x -2
	local size = cc.size(size_x,size_y)
	self.node.ma_list2:setContentSize(size)

	self.node.ma_list2:forceDoLayout()
	self.node.ma_list2:jumpToPercentHorizontal(50)
	self.node.ma_list2:addEventListener(function(ref,event)
		-- body
		if event == 1 then
	
			local select_index = self.node.ma_list2:getCurSelectedIndex()
			--发送请求杠牌
			self:hideOpt()
			self.part:requestOptCard(RoomConfig.Gang,gangList[select_index+1].cardValue)
		end
	end)
end

function ESCardLayer:createCardFactory()
	local card_factory = import(".HBCardFactory",CURRENT_MODULE_NAME)
  	card_factory:init(
		self.res_base, 
		function(cardValue) return self.part:isLaiZi(cardValue) end,
		function(cardValue) return self.part:isPiZi(cardValue) end,
		function(cardValue) return self.part:isHongzhong(cardValue) end)
	return card_factory
end

function ESCardLayer:addDownCard(viewId,value,isReset) 
	ESCardLayer.super.addDownCard(self,viewId,value,isReset)   
	self:addSpeCard(viewId,value,isReset)
end
 

--重置已经出的牌
function ESCardLayer:resetOutCard(viewId,cardList,isReset)
	self:clearSpeOutCard(viewId)
	ESCardLayer.super.resetOutCard(self, viewId, cardList, isReset)
end


--添加懒子，痞子到出牌中
function ESCardLayer:addSpeCard(viewId, value,isReset)
	print("###[SCardLayer:addSpeCard]viewId, value ", viewId, value)
	
	if self.part:isLaiZi(value) or self.part:isPiZi(value) then 
	 	print("###[SCardLayer:isLaiZi]viewId, value ", viewId, value)
	 	local num = #self.card_list[RoomConfig.SpecialOutCard][viewId]+1
	 	local item = self.extBaiPai_cardLayer:showPiZiLaiZi(viewId,num,value,self.part:isPiZi(value))

		local itemIndex = #self.card_list[RoomConfig.SpecialOutCard][viewId] 
		local card_data = {
			card_sprite = item,
			card_value = value,
		} 	  

		table.insert(self.card_list[RoomConfig.SpecialOutCard][viewId], card_data)

		if not isReset then 
			self:optEffect(viewId, self.part:isLaiZi(value) and RoomConfig.LaiziGang or RoomConfig.PiziGang)
		end
	end
end

function ESCardLayer:clearSpeOutCard(viewId)
	-- local speCardList = self.out_cardLayer:getBaoListByViewId(viewId)
	-- speCardList:removeAllChildren()
	-- for i,v in ipairs(self.card_list[RoomConfig.SpecialOutCard][viewId]) do 
	-- 	v = nil
	-- end
	self.extBaiPai_cardLayer:resetPiZiLaiZiCardByViewId(viewId)
	self.card_list[RoomConfig.SpecialOutCard][viewId] = {}
end

 function ESCardLayer:optCard(viewId,type,value,lastOpt,isreset)
	-- 删除吃碰杠的牌
	print("###[ESCardLayer:optCard] this is optCard:",viewId,type,value,lastOpt)  
	if type ~= RoomConfig.Chi and type ~= RoomConfig.Peng then
		print("###[ESCardLayer:optCard] type == RoomConfig.Chi or type == RoomConfig.Peng ")
		for i, v in ipairs(value.mcard) do 
			if self.part:isLaiZi(v) or self.part:isPiZi(v) then 
				print("fuck fuck fuck ")  
				self:delUnhandCard(viewId, type, {v}) 
				self:doLaiziGangAction(viewId, v) 
				if viewId == RoomConfig.MySeat then
					self:sortHandCard(viewId, type)
				end 
				self.node.marker:hide()
				if isreset == nil or isreset ~= true then
					local sex = self.part:getPlayerInfo(viewId).sex;
					local seat_id = self.part:getPlayerInfo(viewId).seat_id;
					-- self:optEffect(viewId, self.part:isLaiZi(v) and RoomConfig.LaiziGang or RoomConfig.PiziGang)
				end
				return
			end
		end 
	end 
	ESCardLayer.super.optCard(self, viewId,type,value,lastOpt,isreset)
end

function ESCardLayer:doLaiziGangAction(viewId, laiziValue)
	
end


--显示/刷新 左上角的2张牌 潜江的痞字显示朝
function ESCardLayer:refreshBaoCardOnLayer(cardConfig)
	-- body
	self.card_factory:addSpriteFrames()
	local baoInfo1 = cardConfig.baoInfo1  
	local baoInfo2 = cardConfig.baoInfo2 
	
	self.node.lefttop_dark_bg2:show()

	if cardConfig and self.node.bao1 then
		self.node.bao1:show()
		self.node.bao2:show()
		-- local bao1 = bit._and(baoCard,0xff);
		-- local bao2 = bit._and(bit.rshift(baoCard,8),0xff)
		local bao1 = baoInfo1.srcValue
		local bao2 = baoInfo2.srcValue
		print("###[ESCardLayer:refreshBaoCardOnLayer] bao1 is ", bao1.."and bao2 is "..bao2)
		if bao1 > 0 then
			local frame_name = self.res_base .. "/allempty/mj_az_01.png"
			self.node.bao1:loadTexture(frame_name,1)

			local cardBao1 = self.card_factory:createHandCard(RoomConfig.MySeat,bao1,false)
			self.node.bao1:setScale(0.5)
			cardBao1:setAnchorPoint(cc.p(0.0,0.0))
			self.node.bao1:addChild(cardBao1)
			self.node.bao1:setVisible(true)
		else 
			self.node.bao2:setVisible(false)
			if self.part.owner:getPlayWay1() == 0x08 then
				local frame_name = self.res_base .. "/allempty/mj_bz_04.png"
				self.node.bao1:loadTexture(frame_name,1) 
				self.node.bao1:setVisible(true)
			end 
		end 
		 

		if bao2 > 0 then
			local frame_name = self.res_base .. "/allempty/mj_az_01.png"
			self.node.bao2:loadTexture(frame_name,1)
			local cardBao2 = self.card_factory:createHandCard(RoomConfig.MySeat,bao2,false)
			self.node.bao2:setScale(0.5)
			cardBao2:setAnchorPoint(cc.p(0.0,0.0))
			self.node.bao2:addChild(cardBao2)	
			self.node.bao2:setVisible(true)		
		else
			-- local frame_name = self.res_base .. "/allempty/mj_bz_04.png"
			-- self.node.bao2:loadTexture(frame_name,1) 
			self.node.bao2:setVisible(false)
		end 
	end 
end

function ESCardLayer:mapOptPicName(optValue)
	print("ESCardLayer:mapOptPicNam " .. string.format("0x%02x", optValue)) 
	if optValue == RoomConfig.PIZI_NOTIFY then
		return "liang_bt.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_ZIMO then
		return "zimo.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_AN_GANG or optValue == RoomConfig.MAHJONG_OPERTAION_MING_GANG or optValue == RoomConfig.Gang then
		return "xiao.png"
	else
		return ESCardLayer.super.mapOptPicName(self, optValue)
	end 
end

--重置碰杠的牌
function ESCardLayer:resetDownCard(viewId,cardList)   
	ESCardLayer.super.resetDownCard(self, viewId,cardList) 
end

--返回需要删除的手牌
function ESCardLayer:delUnhandCard(viewId, type, delCardList)  
	local card_list = self.card_list[RoomConfig.HandCard][viewId] 
	print("###[ESCardLayer:delUnhandCard]viewId  card_list1 is ", viewId)
	local card_size = #card_list 
	if viewId == RoomConfig.MySeat then --自己的牌需要根据数据删除。其他人的牌就随便删除两-三张
		for j,v in ipairs(delCardList) do
			for i=card_size,1,-1 do
				local del_card =v
				
				if del_card == RoomConfig.EmptyCard then --暗杠需要根据第四张牌的值判断删除那些牌
					del_card = delCardList[4] or RoomConfig.EmptyCard
				end
				
				if card_list[i].card_value and card_list[i].card_value == del_card then
					card_list[i].card_sprite:removeSelf()
					table.remove(card_list,i)
					card_size = card_size - 1
					break
				end
			end
		end
	else
		if type ~= RoomConfig.BuGang then
			local remove_card_num = 3
			for i=card_size,card_size-remove_card_num+1,-1 do
				card_list[i].card_sprite:removeSelf()
				table.remove(card_list,i)
			end
		end
	end  
	return  delCardList
end


return ESCardLayer
