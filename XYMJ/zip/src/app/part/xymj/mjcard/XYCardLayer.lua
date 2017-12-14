--[[
	云南的打牌界面处理
--]]
local CURRENT_MODULE_NAME = ...
local CardLayer = import(".CardLayer")
local XYCardLayer = class("XYCardLayer",CardLayer)

function XYCardLayer:onCreate()
	self.kanpaiCardNum = {0, 0, 0, 0}
	XYCardLayer.super.onCreate(self)
    self._touchListener:registerScriptHandler(handler(self, XYCardLayer.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self._touchListener:registerScriptHandler(handler(self, XYCardLayer.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self._touchListener:registerScriptHandler(handler(self, XYCardLayer.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
end

function XYCardLayer:createCardFactory()
	local card_factory = import(".XYCardFactory",CURRENT_MODULE_NAME)
  	card_factory:init(self.res_base)
	return card_factory
end

function XYCardLayer:showKanpaiMenu()
	self.node.kanpai_btn:show()
	self.node.kanpai_cancle_btn:show()
end

function XYCardLayer:hideKanpaiMenu()
	self.node.kanpai_btn:hide()
	self.node.kanpai_cancle_btn:hide()
end

function XYCardLayer:KanPaiClick()
	self.part:sendKanpaiRequest(RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_REMIND)
end

function XYCardLayer:KanPaiCancelClick()
	self.part:sendKanpaiRequest(RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_SUCCESSFULLY)
end

--展示砍牌的cardNum张牌
function XYCardLayer:showKanPaiCard(viewId, cardNum)
	print("XYCardLayer:showKanPaiCard viewId, cardNum : ", viewId, cardNum)

	-- if viewId == RoomConfig.MySeat then
	-- 	self.kanpaiCardNum = cardNum
	-- end
	self.kanpaiCardNum[viewId] = cardNum
	local card_num1 = #self.card_list[RoomConfig.DownCard][viewId]
	
	local down_card = {}
	for i=1,cardNum do
		down_card[i] = 0x39
	end
	print("before insert kanpai, down cards num : ",card_num1)

	local peng_card_list = {} --碰杠的牌以表结构保存
	for i,v in ipairs(down_card) do
		local card = nil
	    card = self.card_factory:createDownCardWithData(viewId,v)
		local size = card:getContentSize()
		if v == RoomConfig.EmptyCard and viewId == RoomConfig.DownSeat then --下家的背牌旋转了-90度宽高需要调转我也不知道为啥图片要这么出
			size = {width=size.height,height = size.width}
		end

		local pos = nil 
		if viewId == RoomConfig.MySeat then --有数据的手牌
			size.width = size.width*1.42
			size.width = size.width - 2
			local offset_y = 0
			local index = i
			pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(index+card_num1*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (card_num1 -1)*self.PengCardOffset*size.width,offset_y)
		elseif viewId == RoomConfig.DownSeat then
			local offset_y = 0
			local index = i
			--pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (index-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 -1)*self.PengCardOffset*size.height+offset_y)
			pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (index-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 + 1)*self.PengCardOffset*size.height)
		elseif viewId == RoomConfig.FrontSeat then
			local offset_y = 0
			local index = i
			size = cc.size(size.width*0.7,size.height*0.7)
			pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*size.width+(index+card_num1*3+self.PengCardOffset)*size.width+(card_num1 -1)*self.PengCardOffset*size.width,0+offset_y)
			card:setScale(0.7)
		elseif viewId == RoomConfig.UpSeat then
			local offset_y = 0
			local index=  i
			print("this is  angang  upseat index:",i,size.width,size.height)
			--pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(index+card_num1*3)*size.height*self.OutCardSortOffsetCol - (card_num1 -1)*self.PengCardOffset*size.height+offset_y)
			pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(index+card_num1*3)*size.height*self.OutCardSortOffsetCol - card_num1*self.PengCardOffset*size.height)
		end

		card:setPosition(pos)
		self.node["hcard_node" .. viewId]:addChild(card)

		table.insert(peng_card_list,card)
	end

	table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=clone(peng_card_list),card_value={mcard={0x39,0x39,0x39,0x39}}})
end

function XYCardLayer:removeHandcards(viewId)
	self.node["hcard_node".. viewId]:removeAllChildren()
	self.card_list[RoomConfig.HandCard][viewId] = {}
end

function XYCardLayer:reposeHandCards(viewId, needRemove)
	local content_pos = cc.p(self.node["hcard_node" .. viewId]:getPosition())
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	local card_size = #self.card_list[RoomConfig.HandCard][viewId]

	--吃碰杠的牌
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #card_list1

	if (viewId ~= RoomConfig.MySeat) and needRemove then
		local remove_card_num = 4
		for i=card_size,card_size-remove_card_num+1,-1 do
			card_list[i].card_sprite:removeSelf()
			table.remove(card_list,i)
		end

		card_size = card_size - remove_card_num
	end
	local num1 = RoomConfig.HandCardNum-card_size

	for i=1,card_size do --计算牌的位置
		local card = card_list[i].card_sprite
		local pos = cc.p(0, 0)
		local size = card:getContentSize()
		size.width = size.width - 2

		if viewId == RoomConfig.MySeat then --有数据的手牌		
			local start_pos = (-self.GetCardOffsetX-RoomConfig.HandCardNum/2)*size.width --起始点位置
			local down_card_size = ((card_num1*3)*0.71+self.PengCardOffset+card_num1*self.PengCardOffset)*size.width
			if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
				down_card_size = ((card_num1*3+(self.kanpaiCardNum[RoomConfig.MySeat]-3))*0.71+self.PengCardOffset+card_num1*self.PengCardOffset)*size.width
			end
			if card_num1 == 0 then
				down_card_size = 0
			end
			pos = cc.p(start_pos+down_card_size+(i-1.4)*size.width,0)
		elseif viewId == RoomConfig.DownSeat then --下家从上往下列牌
			--pos = cc.p(0,(card_size/2-i+num1*0.7)*size.height/2)
			pos = cc.p(0,(RoomConfig.HandCardNum/2-i-1)*size.height/2)
		elseif viewId == RoomConfig.FrontSeat then --对家从右到左排列
			--pos =cc.p((card_size/2-i+num1*0.7)*size.width,0)
			pos =cc.p((RoomConfig.HandCardNum/2-i+0.5)*size.width,0)
		elseif viewId == RoomConfig.UpSeat then --上家从下到上排列
			--pos = cc.p(0,(i-card_size/2-num1*0.7)*size.height/2)
			pos = cc.p(0,(i-RoomConfig.HandCardNum/2-1)*size.height/2)
			card:setLocalZOrder(card_size - i)
		end
		card:setPosition(pos)
	end
end

function XYCardLayer:addCardToNaozhuangNode(value)
	local card = self.card_factory:createWithData(1, value, true)
	card:addTouchEventListener(handler(self,XYCardLayer.touchNZCardEvent))
	local size = card:getContentSize()
	size.width = size.width - 2
	-- local pos = cc.p((i-v.num/2-1-self.GetCardOffsetX)*size.width,0)
	-- card:setPosition(pos)
	self.node["nz_card_node1"]:addChild(card)
	local card_panel = {
		card_sprite = card,
		card_value = value, --只有自己的手牌有数据其他的都是nil
		card_pos = cc.p(card:getPosition())
	}
	table.insert(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat],card_panel)
end

function XYCardLayer:touchNZCardEvent(touch, event)
	XYCardLayer.super.touchCardEvent(self, touch, event)
end

--重置自己的手牌和碰杠的牌
function XYCardLayer:refreshMyCard(hcardList,dcardList,ocardList,value)
	XYCardLayer.super.refreshMyCard(self, hcardList, dcardList, ocardList, value)
	if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
		self:showKanPaiCard(1, self.kanpaiCardNum[RoomConfig.MySeat])
		self:reposeHandCards(1)
	end
end

function XYCardLayer:resetNaozhuangCard(cards)

	print("XYCardLayer:resetNaozhuangCard cards ", cards)
	self.node["nz_card_node1"]:removeAllChildren()
	self.naozhaung_card_list = {}
	self.node.nao_zhuang_cover:hide()
	--self.node.nao_zhuang_cover_long:hide()

	local startPosX = 0
	local naozhuangCardNum = #cards
	if naozhuangCardNum == 1 then
		startPosX = 1
		--self.node.nao_zhuang_cover:show()
	elseif naozhuangCardNum == 2 then
		--self.node.nao_zhuang_cover_long:show()
	end

	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local scale = display.width / 1080
	local size

	for i=1, #cards do
		local cardVal = cards[i]
		local pos = nil
		local card = self.card_factory:createWithData(RoomConfig.MySeat, cardVal, true)
		size = card:getContentSize()
		size.width = size.width - 2
		size.height = size.height +10
		pos = cc.p((startPosX + i - 1) * size.width, 0)
		card:setPosition(pos)
		card:setTag(cardVal)
		card:addTouchEventListener(handler(self,XYCardLayer.touchNZCardEvent))
		self.node["nz_card_node1"]:addChild(card)
		local card_panel = {
			card_sprite = card,
			card_value = cardVal, --只有自己的手牌有数据其他的都是nil
			card_pos = cc.p(card:getPosition())
		}
		table.insert(self.naozhaung_card_list,card_panel)
	end

	--这样做对调用顺序有要求，必须先刷新闹庄icon的状态，再更新蒙版的显示状态
	print("naozhuangCardNum, self.part:isNaozhuangIconShow(): ", naozhuangCardNum, self.part:isNaozhuangIconShow())
	if naozhuangCardNum > 0 and self.part:isNaozhuangIconShow() then
		self.node.nao_zhuang_cover:show()
		self.node.nao_zhuang_cover:setContentSize(cc.size((display.width - (size.width + 2) * naozhuangCardNum * scale), 120))
	end
end

--摸牌
function XYCardLayer:getCard(value)
	-- body
	local card = self.card_factory:createWithData(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
	local size = card:getContentSize()
	local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	-- if self.node.nao_zhuang_cover:isVisible() then
	-- 	card_num = card_num - (self.part:getNaozhaungCardsNum() or 0)
	-- end

	local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
	size.with = size.width -2
	local pos =cc.p((card_num-RoomConfig.HandCardNum/2+card_num1*2.1+card_num1*self.PengCardOffset)*size.width,0)
	if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
		pos =cc.p(((card_num-RoomConfig.HandCardNum/2+card_num1*2.1+card_num1*self.PengCardOffset+0.7*(self.kanpaiCardNum[RoomConfig.MySeat]-3)))*size.width,0)
	end
	card:setPosition(pos)
	card:setTag(value)
	card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
	self.node.hcard_node1:addChild(card)
	local card_data = {
		card_sprite = card,
		card_value =value,
		card_pos = cc.p(card:getPosition())
	}
	table.insert(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat],card_data)
end

function XYCardLayer:removeKanpaiCard(viewId)
	local downcardsNum = #self.card_list[RoomConfig.DownCard][viewId]
	local kanpaiCards = self.card_list[RoomConfig.DownCard][viewId][downcardsNum]
	if kanpaiCards then
		local cards = kanpaiCards.card_sprite
		for _,cardSprite in pairs(cards) do
			cardSprite:removeSelf()
		end
		table.remove(self.card_list[RoomConfig.DownCard][viewId], downcardsNum)
	end
	self.kanpaiCardNum[viewId] = 0
end

-- function XYCardLayer:refreshOptDownCard(viewId, optValue, type) 
-- 	local isKanpai = true
-- 	local curDownCardList = self.card_list[RoomConfig.DownCard][viewId]
-- 	local lastDownCard = curDownCardList[#curDownCardList]

-- 	if lastDownCard then
-- 		for i=1,4 do
-- 			local cardVal = lastDownCard.card_value.mcard[i]
-- 			if cardVal then
-- 				if cardVal ~= 0x39 then
-- 					isKanpai = false
-- 					break
-- 				end
-- 			else
-- 				isKanpai = false
-- 				break
-- 			end
-- 		end
-- 	else
-- 		isKanpai = false
-- 	end

-- 	if isKanpai then
-- 		self:removeKanpaiCard(viewId)
-- 	end

-- 	XYCardLayer.super.refreshOptDownCard(self, viewId, optValue, type)   

-- 	if isKanpai then
-- 		self:showKanPaiCard(viewId)
-- 		self:reposeHandCards(viewId)
-- 	end
-- end

function XYCardLayer:onTouchBegan(touches,event)
	-- body
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
		if self.node.nao_zhuang_cover:isVisible() then--or self.node.nao_zhuang_cover_long:isVisible() then
		 	node_pos = self.node.nz_card_node1:convertToNodeSpace(touch_pos)
		 	for i,v in ipairs(self.naozhaung_card_list) do
            	if v.card_sprite.touchBegan and v.card_sprite:getParent():getName() == "nz_card_node1" then
                    v.card_sprite:touchBegan(node_pos)
                end
            end
        else
            for i,v in ipairs(card_list) do
                if v.card_sprite.touchBegan then
                    v.card_sprite:touchBegan(node_pos)
                end
            end
		end		
	end
	return true
end

function XYCardLayer:onTouchMoved(touches,event)
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
		if self.node.nao_zhuang_cover:isVisible() then--or self.node.nao_zhuang_cover_long:isVisible() then
		 	node_pos = self.node.nz_card_node1:convertToNodeSpace(touch_pos)
			for i,v in ipairs(self.naozhaung_card_list) do
				if v.card_sprite.touchMoved then
					v.card_sprite:touchMoved(node_pos)
				end
			end
		else
			for i,v in ipairs(card_list) do
				if v.card_sprite.touchMoved then
					v.card_sprite:touchMoved(node_pos)
				end
			end
		end
	end
end

function XYCardLayer:onTouchEnded(touches,event)
	-- body
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		print("CardLayer:onTouchEnded--self.out_line=", self.out_line)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]

		if self.node.nao_zhuang_cover:isVisible() then--or self.node.nao_zhuang_cover_long:isVisible() then
		 	node_pos = self.node.nz_card_node1:convertToNodeSpace(touch_pos)
			for i,v in ipairs(self.naozhaung_card_list) do
				if v.card_sprite.touchEnd and v.card_sprite:touchEnd(node_pos,self.out_line) then
					self.part:requestOutCard(v.card_sprite:getValue())
					self.card_touch_enable = false
				end
			end
		else
			for i,v in ipairs(card_list) do
				if v.card_sprite.touchEnd and v.card_sprite:touchEnd(node_pos,self.out_line) then
					self.part:requestOutCard(v.card_sprite:getValue())
					self.card_touch_enable = false
				end
			end
		end
	end
end

--玩家吃,碰,杠
--value= {mcard={2,3},ocard = 1}
-- isreset 是否有音效，断线重连没有音效
function XYCardLayer:optCardWithKanpai(viewId,type,value,lastOpt,isreset)
	-- 删除吃碰杠的牌
	print("this is optCard:",viewId,type,value,lastOpt)
	self.card_touch_enable = false
	local card_list =self.card_list[RoomConfig.HandCard][viewId]
	local card_size = #self.card_list[RoomConfig.HandCard][viewId]
	if viewId == RoomConfig.MySeat then --自己的牌需要根据数据删除。其他人的牌就随便删除两-三张
		for j,v in ipairs(value.mcard) do
			for i=card_size,1,-1 do
				local del_card =v
				
				if del_card == RoomConfig.EmptyCard then --暗杠需要根据第四张牌的值判断删除那些牌
					local toRemoveCardVal = value.mcard[4] and value.mcard[4] or value.kanpai[1]
					del_card = toRemoveCardVal or RoomConfig.EmptyCard
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
			if value.kanpai and (not value.game_start) then
				remove_card_num = remove_card_num - #(value.kanpai)
			end
			for i=card_size,card_size-remove_card_num+1,-1 do
				print("CardLayer:optCard--收到杠操作，删除牌，i=", i)
				card_list[i].card_sprite:removeSelf()
				table.remove(card_list,i)
			end
		end
	end
--创建吃碰杠的牌 基于手牌的位置偏移
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #self.card_list[RoomConfig.DownCard][viewId]
	local down_card = {}
	for i,v in ipairs(value.mcard) do
		down_card[i] = v
	end
	print("this is opt card:",type,card_num1,#down_card)
	
	local allkanpai = false
	if value.ocard then
		table.insert(down_card,1,value.ocard)
	elseif value.kanpai and #(value.kanpai) > 0 then
		table.insert(down_card,1,value.kanpai[#(value.kanpai)])
		value.kanpai[#(value.kanpai)] = nil
		allkanpai = true
	end

	local kanpaiNum = 0
	if value.kanpai then
		for k,v in pairs(value.kanpai) do
			table.insert(down_card, v)
		end
		kanpaiNum = #(value.kanpai)
	end
	if allkanpai then
		kanpaiNum = kanpaiNum + 1
	end

	local peng_card_list = {} --碰杠的牌以表结构保存
	local gang_card_pos = nil --用处处理补杠杠牌位置

	for i,v in ipairs(down_card) do
		local card = nil
		local showKanicon = false
		if i <= kanpaiNum then
			showKanicon = true
		end
	    card = self.card_factory:createDownCardWithData(viewId,v,showKanicon)
		local size = card:getContentSize()
		if v == RoomConfig.EmptyCard and viewId == RoomConfig.DownSeat then --下家的背牌旋转了-90度宽高需要调转我也不知道为啥图片要这么出
			size = {width=size.height,height = size.width}
		end
		local pos = nil 
		if type == RoomConfig.BuGang then
			for k,j in ipairs(card_list1) do
				print("this is room config bugang:",j.card_value.mcard[1] or j.card_value.kanpai[1],v,j.card_sprite[2]:getPositionX())
				dump(j)
				if (j.card_value.mcard[1] or j.card_value.kanpai[1]) == v then --补杠只需要创建一张牌
					local card_sprite = j.card_sprite[2] --第二张
					local pos = cc.p(card_sprite:getPosition())
					if viewId == RoomConfig.MySeat or viewId == RoomConfig.FrontSeat then
						pos = cc.p(pos.x,pos.y+size.height*self.GangCardOffset)
					else
						pos = cc.p(pos.x,pos.y+size.width*self.GangCardOffset)
					end

					if viewId == RoomConfig.FrontSeat then
						card:setScale(0.7)
					end

					card:setPosition(pos)
					self.node["hcard_node" .. viewId]:addChild(card)
					table.insert(j.card_sprite,card)
					break
				end
			end
		elseif type == RoomConfig.MingGang or type == RoomConfig.AnGang then--如果是其他人暗杠是看不到牌的 --自己暗杠可以看到一张牌
			
			if viewId == RoomConfig.MySeat then --有数据的手牌
				size.width = size.width*1.42
				size.width = size.width - 2
				local offset_y = 0
				local index=  i
				if index == 4 then
					offset_y = size.height * self.GangCardOffset
					index = 2
				end
				pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(index+card_num1*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (card_num1 -1)*self.PengCardOffset*size.width,offset_y)
			elseif viewId == RoomConfig.DownSeat then
				local offset_y = 0
				local index=  i
				if index == 4 then
					offset_y = size.width * self.GangCardOffset
					index = 2
				end
				pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (index-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 -1)*self.PengCardOffset*size.height+offset_y)
			elseif viewId == RoomConfig.FrontSeat then
				local offset_y = 0
				local index=  i
				if index == 4 then
					offset_y = size.height * self.GangCardOffset
					index = 2
				end
				size = cc.size(size.width*0.7,size.height*0.7)
				pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*size.width+(index+card_num1*3+self.PengCardOffset)*size.width+(card_num1 -1)*self.PengCardOffset*size.width,0+offset_y)
				card:setScale(0.7)
			elseif viewId == RoomConfig.UpSeat then
				local offset_y = 0
				local index=  i
				print("this is  angang  upseat index:",i,size.width,size.height)
				if v == RoomConfig.EmptyCard then --上家的明牌的尺寸比背牌的尺寸大
					size = cc.size(size.height,size.width)
				end
				if index == 4 then
					offset_y = size.width * self.GangCardOffset 
					index = 2
				end
				print("this is  angang  upseat index:",i,size.width,size.height,card_num1)
				pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(index+card_num1*3)*size.height*self.OutCardSortOffsetCol - (card_num1-1)*self.PengCardOffset*size.height+offset_y)
			end

			card:setPosition(pos)
			self.node["hcard_node" .. viewId]:addChild(card)

			table.insert(peng_card_list,card)
		elseif type == RoomConfig.Peng  or type == RoomConfig.Chi then
			if viewId == RoomConfig.MySeat then --有数据的手牌
				size.width = size.width*1.42
				size.width = size.width - 2
				pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(i+card_num1*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width + (card_num1-1)*self.PengCardOffset*size.width,0)
			elseif viewId == RoomConfig.DownSeat then
				pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (i-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 -1)*self.PengCardOffset*size.height)
			elseif viewId == RoomConfig.FrontSeat then
				size = cc.size(size.width*0.7,size.height*0.7)
				pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*size.width+(i+card_num1*3+self.PengCardOffset)*size.width+(card_num1 -1)*self.PengCardOffset*size.width,0)
				card:setScale(0.7)
			elseif viewId == RoomConfig.UpSeat then
				pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(i+card_num1*3)*size.height*self.OutCardSortOffsetCol - (card_num1 -1)*self.PengCardOffset*size.height)
			end
			card:setPosition(pos)
			self.node["hcard_node" .. viewId]:addChild(card)
			table.insert(peng_card_list,card)
		end
	end

	if type ~= RoomConfig.BuGang then --补杠不需要创建新的牌堆
		local temp_panel = {}
		temp_panel.card_sprite = peng_card_list
		temp_panel.card_value = value 
	
		table.insert(card_list1,temp_panel) --碰杠牌的数据结构	
	end

	if viewId == RoomConfig.MySeat then
		self:sortHandCard(viewId,type)
	end

	self.node.marker:hide()
	if isreset == nil or isreset ~= true then
		local sex = self.part:getPlayerInfo(viewId).sex;
		local seat_id = self.part:getPlayerInfo(viewId).seat_id;
		self:playOperateEffect(type , sex , seat_id)
	end
end

function XYCardLayer:optCard(viewId,type,value,lastOpt,isreset,kanpaiCardNum)
	local isKanpai = false
	local curDownCardList = self.card_list[RoomConfig.DownCard][viewId]
	local lastDownCard = curDownCardList[#curDownCardList]

	if self.kanpaiCardNum[viewId] > 0 then
		isKanpai = true
	end

	if isKanpai then
		self:removeKanpaiCard(viewId)
	end

	self:optCardWithKanpai(viewId, type, value, lastOpt, isreset)   

	if isKanpai and kanpaiCardNum > 0 then
		self:showKanPaiCard(viewId, kanpaiCardNum)
		self:reposeHandCards(viewId)
	end
end

--重置碰杠的牌
function XYCardLayer:resetDownCard(viewId,cardList)
	print("###[XYCardLayer:resetDownCard] viewId ", viewId)
	-- body
    local card_list = self.card_list[RoomConfig.DownCard][viewId]
	self.card_list[RoomConfig.DownCard][viewId] = {}
	local card_data = {}
	local peng_card_list = {} --碰杠的牌以表结构保存
	for i,v in ipairs(cardList) do
		if v.type  == RoomConfig.MingGang or v.type == RoomConfig.BuGang or v.type == RoomConfig.AnGang then--如果是其他人暗杠是看不到牌的 --自己暗杠可以看到一张牌
			local card_value = v.cardValue  --杠只有一张牌 字段命名可能不一致
			local c1 = bit._and(card_value,0xff)
			local c2 = c1
			local c3 = c1 
			local c4 = c1 
			if v.type == RoomConfig.AnGang and viewId == RoomConfig.MySeat then
				c1 = RoomConfig.EmptyCard
				c2 = RoomConfig.EmptyCard
				c3 = RoomConfig.EmptyCard
			end

			local kanpaiCardNum = v.usexiaojinum or 0 --字段复用，这里表示downcard中砍牌的数量
			local addIconIndex = {1, 2, 4, 3}
			local addIconFlag = {}
			for i=1,kanpaiCardNum do
				addIconFlag[addIconIndex[i]] = true
			end

			local card1 = self.card_factory:createDownCardWithData(viewId,c1,addIconFlag[1])
			local card2 = self.card_factory:createDownCardWithData(viewId,c2,addIconFlag[2])
			local card3 = self.card_factory:createDownCardWithData(viewId,c3,addIconFlag[3])
			local card4 = self.card_factory:createDownCardWithData(viewId,c4,addIconFlag[4])
			card_data = {mcard={c1,c2,c3,c4}}
			local pos1 = nil
			local pos2 = nil
			local pos3 = nil
			local pos4 = nil
			local size = card1:getContentSize()
			
			
			if viewId == RoomConfig.MySeat then --有数据的手牌
				size.width = size.width * 1.42
				size.width = size.width - 2
				pos1 = cc.p((-RoomConfig.HandCardNum/2-0.5+(1+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
				pos2 = cc.p((-RoomConfig.HandCardNum/2-0.5+(2+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
				pos3 = cc.p((-RoomConfig.HandCardNum/2-0.5+(3+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
				pos4 = cc.p((-RoomConfig.HandCardNum/2-0.5+(2+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0+size.height * self.GangCardOffset)
			elseif viewId == RoomConfig.DownSeat then
				pos1 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (1-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
				pos2 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (2-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
				pos3 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (3-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
				pos4 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (2-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height+size.width * self.GangCardOffset)
			elseif viewId == RoomConfig.FrontSeat then
				size = cc.size(size.width*0.7,size.height*0.7)
				pos1 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(1+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				pos2 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				pos3 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(3+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				pos4 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0+size.height * self.GangCardOffset)
				card:setScale(0.7)
			elseif viewId == RoomConfig.UpSeat then
				pos1 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(1+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
				pos2 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
				pos3 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(3+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
				pos4 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+size.width/2)
			end

			card1:setPosition(pos1)
			card2:setPosition(pos2)
			card3:setPosition(pos3)
			card4:setPosition(pos4)
			self.node["hcard_node" .. viewId]:addChild(card1)
			self.node["hcard_node" .. viewId]:addChild(card2)
			self.node["hcard_node" .. viewId]:addChild(card3)
			self.node["hcard_node" .. viewId]:addChild(card4)
			table.insert(peng_card_list,card1)
			table.insert(peng_card_list,card2)
			table.insert(peng_card_list,card3)
			table.insert(peng_card_list,card4)
			table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=peng_card_list,card_value=card_data}) --碰杠牌的数据结构
			peng_card_list = {}
		elseif v.type  == RoomConfig.Peng or v.type == RoomConfig.Chi then --直接使用数据创建三张牌
			local card_value = v.cardValue  -- 字段命名可能不一致
			local c1 = bit._and(card_value,0xff)
			local c2 = bit._and(bit.rshift(card_value,8),0xff)
			local c3 = bit._and(bit.rshift(card_value,16),0xff)
			card_data = {mcard={c1,c2,c3}}
			print("this is create peng card :",c1,c2,c3)

			local kanpaiCardNum = v.usexiaojinum or 0 --字段复用，这里表示downcard中砍牌的数量
			local addIconFlag = {}
			for i=1,kanpaiCardNum do
				addIconFlag[i] = true
			end

			local card1 = self.card_factory:createDownCardWithData(viewId,c1,addIconFlag[1])
			local card2 = self.card_factory:createDownCardWithData(viewId,c2,addIconFlag[2])
			local card3 = self.card_factory:createDownCardWithData(viewId,c3,addIconFlag[3])

			local size = card1:getContentSize()
			local pos1 = nil
			local pos2 = nil
			local pos3 = nil
			if viewId == RoomConfig.MySeat then 
				size = card1:getContentSize() --获取第一张手牌的大小计算碰杠牌的位置
				size.width = size.width * 1.42
				size.width = size.width - 2
				pos1 = cc.p((-RoomConfig.HandCardNum/2-0.5+(1+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width + (i-2)*self.PengCardOffset*size.width,0)
				pos2 = cc.p((-RoomConfig.HandCardNum/2-0.5+(2+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width + (i-2)*self.PengCardOffset*size.width,0)
				pos3 = cc.p((-RoomConfig.HandCardNum/2-0.5+(3+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width + (i-2)*self.PengCardOffset*size.width,0)
			elseif viewId == RoomConfig.DownSeat then
				pos1 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (1-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
				pos2 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (2-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
				pos2 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (3-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
			elseif viewId == RoomConfig.FrontSeat then
				size = cc.size(size.width*0.7,size.height*0.7)
				pos1 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(1+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				pos2 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				pos3 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(3+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
				card1:setScale(0.7)
				card2:setScale(0.7)
				card3:setScale(0.7)
			elseif viewId == RoomConfig.UpSeat then
				pos1 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(1+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
				pos2 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
				pos3 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(3+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
			end

			card1:setPosition(pos1)
			card2:setPosition(pos2)
			card3:setPosition(pos3)
			self.node["hcard_node" .. viewId]:addChild(card1)
			self.node["hcard_node" .. viewId]:addChild(card2)
			self.node["hcard_node" .. viewId]:addChild(card3)

			table.insert(peng_card_list,card1)
			table.insert(peng_card_list,card2)
			table.insert(peng_card_list,card3)
			table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=clone(peng_card_list),card_value=card_data}) --碰杠牌的数据结构
			peng_card_list = {}
		end
	end
end

return XYCardLayer