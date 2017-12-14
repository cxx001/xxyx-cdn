--[[
	云南的打牌界面处理
--]]
local CURRENT_MODULE_NAME = ...
local CardLayer = import(".CardLayer")
local XYCardLayer = class("XYCardLayer",CardLayer)

function XYCardLayer:onCreate()
	self.kanpaiCardNum = {0, 0, 0, 0}
	XYCardLayer.super.onCreate(self)
	self._haveCallAdjustHandPosFun = false
    self._touchListener:registerScriptHandler(handler(self, XYCardLayer.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self._touchListener:registerScriptHandler(handler(self, XYCardLayer.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
end

function XYCardLayer:createCardFactory()
	local card_factory = import(".XYCardFactory",CURRENT_MODULE_NAME)
  	card_factory:init(self.res_base)
  	card_factory:setPart(self.part)
	return card_factory
end

function XYCardLayer:showKanpaiMenu()
	self.node.kanpai_btn:show()
	self.node.kanpai_cancle_btn:show()
	self:addkanpaiLoopEffect()
end

function XYCardLayer:addkanpaiLoopEffect()
	--坎
	local loopAniPath = self.res_base.."/sp/zi_anniu_xinyang/ZI_anniu_xinyang"
	self.kanAnim = Util.createSpineAnimationLoop(loopAniPath, "kan_anniu", false)
	self.node.kanpai_btn:getParent():addChild(self.kanAnim)
	self.kanAnim:setPosition(self.node.kanpai_btn:getPosition())
	self.kanAnim:setLocalZOrder(self.node.kanpai_btn:getLocalZOrder()+1)
	--过
	self.cancelAnim = Util.createSpineAnimationLoop(loopAniPath, "guo_anniu", false)
	self.node.kanpai_cancle_btn:getParent():addChild(self.cancelAnim)
	self.cancelAnim:setPosition(self.node.kanpai_cancle_btn:getPosition())
	self.cancelAnim:setLocalZOrder(self.node.kanpai_cancle_btn:getLocalZOrder()+1)
end

function XYCardLayer:removeKanPaiLoopEffect()
	if self.kanAnim ~= nil then
    	self.kanAnim:clearTracks()
    	self.kanAnim:removeFromParent()
    	self.kanAnim = nil
    end
	if self.cancelAnim ~= nil then
		self.cancelAnim:clearTracks()
		self.cancelAnim:removeFromParent()
		self.cancelAnim = nil
    end
end

function XYCardLayer:showKanpaiEffect(viewId)
	print("showKanpaiEffect:"..viewId)
	local node,pos = self:getOptPos(viewId)
	local anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo_xinyang/ZI_xiaoguo_xinyang", "kan_xiaoguo", false)
	anim:setPosition(pos)
	anim:setLocalZOrder(5)
	node:addChild(anim)
end

function XYCardLayer:hideKanpaiMenu()
	self.node.kanpai_btn:hide()
	self.node.kanpai_cancle_btn:hide()
	self:removeKanPaiLoopEffect()
end

function XYCardLayer:KanPaiClick()
	print("KanPaiClick")
	self.part:sendKanpaiRequest(RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_REMIND)
end

function XYCardLayer:KanPaiCancelClick()
	print("KanPaiCancelClick")
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
	-- local downCard = self.down_cardLayer:showDownCard(viewId,down_card,card_num1 + 1, 0)
	local downCard = self:showDownCard(viewId,down_card,card_num1 + 1, 0,nil)
	local card1 =downCard[1]
	local card2 =downCard[2]
	local card3 =downCard[3]
	local card4 =downCard[4]

	local card_data = {mcard={0x39,0x39,0x39,0x39}}
	table.insert(peng_card_list,card1)
	table.insert(peng_card_list,card2)
	table.insert(peng_card_list,card3)
	table.insert(peng_card_list,card4)
	table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=peng_card_list,card_value=card_data})

	-- for i,v in ipairs(down_card) do
	-- 	local card = nil
	--     card = self.card_factory:createDownCardWithData(viewId,v)
	-- 	local size = card:getContentSize()
	-- 	if v == RoomConfig.EmptyCard and viewId == RoomConfig.DownSeat then --下家的背牌旋转了-90度宽高需要调转我也不知道为啥图片要这么出
	-- 		size = {width=size.height,height = size.width}
	-- 	end

	-- 	local pos = nil 
	-- 	if viewId == RoomConfig.MySeat then --有数据的手牌
	-- 		size.width = size.width*1.42
	-- 		size.width = size.width - 2
	-- 		local offset_y = 0
	-- 		local index = i
	-- 		pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(index+card_num1*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (card_num1 -1)*self.PengCardOffset*size.width,offset_y)
	-- 	elseif viewId == RoomConfig.DownSeat then
	-- 		local offset_y = 0
	-- 		local index = i
	-- 		--pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (index-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 -1)*self.PengCardOffset*size.height+offset_y)
	-- 		pos = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (index-card_num1*3)*size.height*self.OutCardSortOffsetCol + (card_num1 + 1)*self.PengCardOffset*size.height)
	-- 	elseif viewId == RoomConfig.FrontSeat then
	-- 		local offset_y = 0
	-- 		local index = i
	-- 		size = cc.size(size.width*0.7,size.height*0.7)
	-- 		pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*size.width+(index+card_num1*3+self.PengCardOffset)*size.width+(card_num1 -1)*self.PengCardOffset*size.width,0+offset_y)
	-- 		card:setScale(0.7)
	-- 	elseif viewId == RoomConfig.UpSeat then
	-- 		local offset_y = 0
	-- 		local index=  i
	-- 		print("this is  angang  upseat index:",i,size.width,size.height)
	-- 		--pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(index+card_num1*3)*size.height*self.OutCardSortOffsetCol - (card_num1 -1)*self.PengCardOffset*size.height+offset_y)
	-- 		pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(index+card_num1*3)*size.height*self.OutCardSortOffsetCol - card_num1*self.PengCardOffset*size.height)
	-- 	end

	-- 	card:setPosition(pos)
	-- 	self.node["hcard_node" .. viewId]:addChild(card)

	-- 	table.insert(peng_card_list,card)
	-- end

	-- table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=clone(peng_card_list),card_value={mcard={0x39,0x39,0x39,0x39}}})
end

function XYCardLayer:removeHandcards(viewId)
	self.node["hcard_node".. viewId]:removeAllChildren()
	self.card_list[RoomConfig.HandCard][viewId] = {}
end

function XYCardLayer:reposeHandCards(viewId, needRemove)
	local content_pos = cc.p(self.node["hcard_node" .. viewId]:getPosition())
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	local card_size = #self.card_list[RoomConfig.HandCard][viewId]

	-- local hand_card_list = self.card_list[RoomConfig.HandCard][viewId]
	-- for i,v in ipairs(hand_card_list) do
	-- 	v.card_sprite:hide()
	-- end
	-- self.hand_cardLayer:resetAllCard()
	-- self.card_list[RoomConfig.HandCard][viewId] = {}

	--吃碰杠的牌
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #card_list1

	if (viewId ~= RoomConfig.MySeat) and needRemove then
		local remove_card_num = 4
		for i=card_size,card_size-remove_card_num+1,-1 do
			--card_list[i].card_sprite:removeSelf()
			if card_list and card_list[i] and card_list[i].card_sprite then
				card_list[i].card_sprite:hide()
				table.remove(card_list,i)
			end
		end

		card_size = card_size - remove_card_num
	end
	-- local num1 = RoomConfig.HandCardNum-card_size

	-- for i=1,card_size do --计算牌的位置
	-- 	local card = card_list[i].card_sprite
	-- 	local pos = cc.p(0, 0)
	-- 	local size = card:getContentSize()
	-- 	size.width = size.width - 2

	-- 	if viewId == RoomConfig.MySeat then --有数据的手牌		
	-- 		-- local start_pos = (-self.GetCardOffsetX-RoomConfig.HandCardNum/2)*size.width --起始点位置
	-- 		-- local down_card_size = ((card_num1*3)*0.71+self.PengCardOffset+card_num1*self.PengCardOffset)*size.width
	-- 		-- if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
	-- 		-- 	down_card_size = ((card_num1*3+(self.kanpaiCardNum[RoomConfig.MySeat]-3))*0.71+self.PengCardOffset+card_num1*self.PengCardOffset)*size.width
	-- 		-- end
	-- 		-- if card_num1 == 0 then
	-- 		-- 	down_card_size = 0
	-- 		-- end
	-- 		-- pos = cc.p(start_pos+down_card_size+(i-1.4)*size.width,0)
	-- 		local num = #card_list
	-- 		for i,v in pairs(card_list) do --计算牌的位置
	-- 			local pos = nil
	-- 			-- local card = self.card_factory:createWithData(viewId,v,true)--self:createHandCard(v.view_id,v.value[i])
	-- 			local card = self.card_factory:createHandCard(viewId,v.card_value,true)--self:createHandCard(v.view_id,v.value[i])

	-- 			local size = card:getContentSize()
	-- 			size.width = size.width - 2
	-- 			-- if v.view_id == RoomConfig.MySeat then --有数据的手牌
	-- 			pos = cc.p((i-num/2-1-self.GetCardOffsetX - 0.25)*size.width,50)
	-- 			if viewId == RoomConfig.MySeat then
	-- 				card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
	-- 			end
	-- 			-- card:setTag(i) --牌的索引
	-- 			card:setTag(v.card_value)
	-- 			card:setPosition(pos)
	-- 			self.node["hcard_node"..viewId]:addChild(card)
	-- 			local card_panel = {
	-- 				card_sprite = card,
	-- 				card_value = v, --只有自己的手牌有数据其他的都是nil
	-- 				card_pos = cc.p(card:getPosition())
	-- 			}
	-- 			table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	-- 		end
	-- 	-- elseif viewId == RoomConfig.DownSeat then --下家从上往下列牌
	-- 	-- 	pos = cc.p(0,(card_size/2-i-1+num1*0.7)*size.height/2)
	-- 	-- elseif viewId == RoomConfig.FrontSeat then --对家从右到左排列
	-- 	-- 	pos =cc.p((card_size/2-i+0.5+num1*0.7)*size.width,0)
	-- 	-- elseif viewId == RoomConfig.UpSeat then --上家从下到上排列
	-- 	-- 	pos = cc.p(0,(i-card_size/2-2-num1*0.7-0.5)*size.height/2)
	-- 	-- 	card:setLocalZOrder(card_size - i)
	-- 	else
	-- 		print("XXXXXXX XYCardLayer:reposeHandCards viewId, #card_list ", viewId, #card_list)
	-- 		for i,v in pairs(card_list) do
	-- 			local card = self.hand_cardLayer:showCard(viewId,i)
	-- 			local card_panel = {
	-- 				card_sprite = card,
	-- 				card_value = v,
	-- 				card_pos = cc.p(card:getPosition())
	-- 			}
	-- 			table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	-- 		end
	-- 	end
	-- end
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
	print("refreshMyCard")
	XYCardLayer.super.refreshMyCard(self, hcardList, dcardList, ocardList, value)
	if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
	 dump(self.kanpaiCardNum)
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
		local card = self.card_factory:createHandCard(RoomConfig.MySeat, cardVal, true)--createWithData(RoomConfig.MySeat, cardVal, true)
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
	print("naozhuangCardNum, self.part:isNaozhuangIconShow(): ", naozhuangCardNum, self:isNaozhuangIconShow())
	if naozhuangCardNum > 0 and self:isNaozhuangIconShow() then
		self.node.nao_zhuang_cover:show()
		self.node.nao_zhuang_cover:setContentSize(cc.size((display.width - (size.width + 2) * naozhuangCardNum * scale), 120))
	end

	self.down_cardLayer:updateNaozhuangNum(naozhuangCardNum)
end

--更新闹装要打出牌的听牌信息
function XYCardLayer:showdrawingCard(filterList)
	XYCardLayer.super.showdrawingCard(self,filterList)
	if not self.naozhaung_card_list or #self.naozhaung_card_list <=0 then return end
	--闹装的情况下
	local naozhuangInFilterList = {}
	for k,v in pairs(filterList) do
		for kh,vh in pairs(self.naozhaung_card_list) do
			local valueCard = vh.card_value 
			if valueCard == v then
				table.insert(naozhuangInFilterList,vh)
			end
		end
	end

	print("showdrawingCard==len:"..#naozhuangInFilterList)
	dump(naozhuangInFilterList)
	self:updateMyCardMask(naozhuangInFilterList,true,self.maskType.drawingMask)
end

function XYCardLayer:adjustHandPos()
	print("adjustHandPos:")
	if CardLayer.MySeatPerSize then
		print("MySeatPerSize:")
		local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
 		local mySeatHandCardList= self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
 		if card_num > 1 then
 			local lastHandCard = mySeatHandCardList[card_num]
  			local lastSecondsCard = mySeatHandCardList[card_num-1]
 			if lastHandCard and lastHandCard.card_sprite and lastSecondsCard and lastHandCard.card_sprite then
 				local card = lastHandCard.card_sprite 
 	 			local lastSecondsCard = lastSecondsCard.card_sprite 
 	 			if card:getPositionX() < lastSecondsCard:getPositionX() + CardLayer.MySeatPerSize.width +2 then
 	  				card:setPositionX(card:getPositionX()+CardLayer.GetCardOffsetX*CardLayer.MySeatPerSize.width)
 	 			end
 			end
 		end
	end
	
end

function XYCardLayer:getCard(value)
	print("XYCardLayer:getCardgetCard")
	release_print(os.date("%c") .. "[info] 信阳牌页面展示摸到一张牌 ", value)
	-- body
	local card = self.card_factory:createHandCard(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
	local size = card:getContentSize()
	local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]

	--local lastHandCardPos = self._mySeatPosList[card_num]		--最后一个手牌的位置
	local lastHandCardPos = cc.p(0, 0)
	if self._mySeatPosList and self._mySeatPosList[card_num] then
		lastHandCardPos = self._mySeatPosList[card_num]
	end

	local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
	print("card_num1:"..card_num1)
	--每有吃碰杠一个往右边移动一个牌子宽度
	local pos_x = 0
	if CardLayer.MySeatPerSize then
		--CardLayer.MySeatPerSize = size
		if card_num >0 then
	 		pos_x = lastHandCardPos.x + (1+self.GetCardOffsetX)*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) +card_num1*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX)
	 		if self.kanpaiCardNum[RoomConfig.MySeat] > 0 and self.kanpaiCardNum[RoomConfig.MySeat] <= 4 then
	 			pos_x =lastHandCardPos.x + (1+self.GetCardOffsetX)*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) +card_num1*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) -size.width
			end
		else
			pos_x = -1.5*2* size.width
		end
	else
		pos_x = -1.5*2* size.width
	end
	local pos = cc.p(pos_x,CardLayer.MySeatCardSetOffY)
	card:setPosition(pos)
	-- card:setTag(card_num + 1)
	card:setTag(value)
	card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
	self.node.hcard_node1:addChild(card)
	local card_data = {
		card_sprite = card,
		card_value =value,
		card_pos = cc.p(card:getPosition())
	}
	table.insert(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat],card_data)
	-- self:showdrawingCard(true)

	-- self:removeOneReadyCard()
end 

-- --摸牌
-- function XYCardLayer:getCard(value)
-- 	-- local card = self.card_factory:createWithData(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
-- 	-- local size = card:getContentSize()
-- 	-- local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
-- 	-- local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
-- 	-- size.with = size.width -2
-- 	-- local pos =cc.p((card_num-RoomConfig.HandCardNum/2+card_num1*2.1+card_num1*self.PengCardOffset)*size.width,0)
	-- if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
	-- 	pos =cc.p(((card_num-RoomConfig.HandCardNum/2+card_num1*2.1+card_num1*self.PengCardOffset+0.7*(self.kanpaiCardNum[RoomConfig.MySeat]-3)))*size.width,0)
	-- end
-- 	-- card:setPosition(pos)
-- 	-- card:setTag(value)
-- 	-- card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
-- 	-- self.node.hcard_node1:addChild(card)
-- 	-- local card_data = {
-- 	-- 	card_sprite = card,
-- 	-- 	card_value =value,
-- 	-- 	card_pos = cc.p(card:getPosition())
-- 	-- }
-- 	-- table.insert(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat],card_data)

-- 	local card = self.card_factory:createHandCard(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
-- 	local size = card:getContentSize()
-- 	local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]

-- 	local lastHandCardPos = self._mySeatPosList[card_num]		--最后一个手牌的位置
-- 	local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
-- 	--每有吃碰杠一个往右边移动一个牌子宽度
--  	local pos_x =lastHandCardPos.x + (1+self.GetCardOffsetX)*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) +card_num1*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX)
--  	if self.kanpaiCardNum[RoomConfig.MySeat] > 0 then
-- 		pos_x = lastHandCardPos.x + (1+self.GetCardOffsetX)*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) +(card_num1 + (self.kanpaiCardNum[RoomConfig.MySeat]-3))*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX)
-- 	end
-- 	local pos = cc.p(pos_x,CardLayer.MySeatCardSetOffY)
-- 	card:setPosition(pos)
-- 	-- card:setTag(card_num + 1)
-- 	card:setTag(value)
-- 	card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
-- 	self.node.hcard_node1:addChild(card)
-- 	local card_data = {
-- 		card_sprite = card,
-- 		card_value =value,
-- 		card_pos = cc.p(card:getPosition())
-- 	}
-- 	table.insert(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat],card_data)

-- 	self:removeOneReadyCard()


-- end

function XYCardLayer:removeKanpaiCard(viewId)
	local downcardsNum = #self.card_list[RoomConfig.DownCard][viewId]
	local kanpaiCards = self.card_list[RoomConfig.DownCard][viewId][downcardsNum]
	print("XYCardLayer:removeKanpaiCard downcardsNum ", downcardsNum)
	dump(self.card_list[RoomConfig.DownCard][viewId])
	if kanpaiCards then
		local cards = kanpaiCards.card_sprite
		for _,cardSprite in pairs(cards) do
			--cardSprite:removeSelf()
			cardSprite:hide()
		end
		table.remove(self.card_list[RoomConfig.DownCard][viewId], downcardsNum)
		print("XYCardLayer:removeKanpaiCard downcardsNum ", #(self.card_list[RoomConfig.DownCard][viewId]))
	end
	print("XYCardLayer:removeKanpaiCard ---1--- downcardsNum ", #(self.card_list[RoomConfig.DownCard][viewId]))
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
	local touch_pos = touches:getLocation()
	if self.select_card.card and self.card_touch_enable == true then
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		self.select_card.card:setPosition(node_pos)
		--self.select_card.stand = false
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
					release_print(os.date("%c") .. "[info] 信阳牌页面请求出闹庄的牌 ", v.card_sprite:getValue())
					self.part:requestOutCard(v.card_sprite:getValue())
					self.card_touch_enable = false
				end
			end
		else
			for i,v in ipairs(card_list) do
				if v.card_sprite.touchEnd and v.card_sprite:touchEnd(node_pos,self.out_line) then
					release_print(os.date("%c") .. "[info] 信阳牌页面请求出手牌 ", v.card_sprite:getValue())
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
					if value.shuaipai[1] then
						toRemoveCardVal = value.shuaipai[1]
					end
					del_card = toRemoveCardVal or RoomConfig.EmptyCard
				end
				
				if card_list[i].card_value and card_list[i].card_value == del_card then
					--card_list[i].card_sprite:removeSelf()
					card_list[i].card_sprite:hide()
					table.remove(card_list,i)
					card_size = card_size - 1
					break
				end
			end
		end

		if value.shuaipai then
			local shuaipaiNum = #(value.shuaipai)
			local startIdx = 0
			for i=1,card_size do
				local del_card =v
				
				if card_list[i].card_value and card_list[i].card_value == value.shuaipai[1] then
					startIdx = i
					break
				end
			end

			for i=startIdx + shuaipaiNum - 1,startIdx,-1 do
				card_list[i].card_sprite:hide()
				table.remove(card_list,i)
				card_size = card_size - 1
			end
		end
	else
		if type ~= RoomConfig.BuGang then
			local remove_card_num = 3
			if value.kanpai and (not value.game_start) then
				remove_card_num = remove_card_num - #(value.kanpai)
				print("card_size:"..card_size)
				print("remove_card_num:"..remove_card_num)
				print("value.kanpai")
				dump(value.kanpai)
			end

			for i=card_size,card_size-remove_card_num+1,-1 do
				print("CardLayer:optCard--收到杠操作，删除牌，i=", i)
				-- if cardList and card_list[i] and card_list[i].card_sprite then
					if card_list[i] then
						card_list[i].card_sprite:hide()
						table.remove(card_list,i)
					end
				
				-- end

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
	
	if value.ocard then
		table.insert(down_card,1,value.ocard)
	end

	local kanpaiNum = 0
	if value.kanpai then
		for k,v in pairs(value.kanpai) do
			table.insert(down_card, v)
		end
		kanpaiNum = #(value.kanpai)
	end

	if value.shuaipai then
		for k,v in pairs(value.shuaipai) do
			table.insert(down_card, v)
		end
		kanpaiNum = #(value.shuaipai)
	end

	local peng_card_list = {} --碰杠的牌以表结构保存
	local tData ={} 			--新的吃碰杠结构
	local gang_card_pos = nil --用处处理补杠杠牌位置

	for i,v in ipairs(down_card) do
		-- local card = nil
		-- local showKanicon = false
		-- if i <= kanpaiNum then
		-- 	showKanicon = true
		-- end
	 --    card = self.card_factory:createDownCardWithData(viewId,v,showKanicon)
		-- local size = card:getContentSize()
		-- if v == RoomConfig.EmptyCard and viewId == RoomConfig.DownSeat then --下家的背牌旋转了-90度宽高需要调转我也不知道为啥图片要这么出
		-- 	size = {width=size.height,height = size.width}
		-- end
		-- local pos = nil 
		if type == RoomConfig.BuGang then
			local downIndex = 1
			for k,j in ipairs(card_list1) do
				-- print("this is room config bugang:",j.card_value.mcard[1],j.card_value.kanpai[1],v,j.card_sprite[2]:getPositionX())
								-- print("this is room config bugang:",j.card_value.mcard[1],j.card_value.kanpai[1],v,j.card_sprite[2]:getPositionX())
				local curDownCardVal = j.card_value.mcard[1] or j.card_value.kanpai[1]
				if not curDownCardVal then
					curDownCardVal = j.card_value.shuaipai[1]
				end
				if curDownCardVal == v then --补杠只需要创建一张牌
					tData[1] = v
					local index = k					--第几对
					-- local  downList=self.down_cardLayer:showDownCard(viewId,tData,index,type)
					local downList = nil
					if value.kanpai and #(value.kanpai) > 0 then
						print(" RoomConfig.BuGangXXXX")
						dump(value.kanpai)
						release_print(os.date("%c") .. "[info] 信阳CLOC 展示补杠的牌坎 ",viewId,tData[1],index,type)
						downList=self:showDownCard(viewId,tData,index,type,#value.kanpai)
					elseif value.shuaipai and #(value.shuaipai) > 0 then
						print(" RoomConfig.BuGangShuai")
						dump(value.shuaipai)
						release_print(os.date("%c") .. "[info] 信阳CLOC 展示补杠的牌甩 ",viewId,tData[1],index,type)
						downList=self:showDownCard(viewId,tData,index,type,nil)
					else
						print(" RoomConfig.BuGangNULL")
						downList=self:showDownCard(viewId,tData,index,type,nil)
					end
					local  card= downList[1]
					table.insert(j.card_sprite,card)  -- 原有的碰牌插入相同的牌（补杠）
					break
				end
			end
		else--非补杠
			tData[i] = v
			if type == RoomConfig.AnGang and (not self.part:showAnGang()) then
				tData[i] = RoomConfig.EmptyCard
			end
		end
	end

	if type ~= RoomConfig.BuGang then --补杠不需要创建新的牌堆
		local index = card_num1 + 1
		release_print(os.date("%c") .. "[info] 信阳CLOC 展示吃碰杠的牌 ",viewId,tData[1],tData[2],tData[3],tData[4],index,type)
		if kanpaiNum == 0 then
			kanpaiNum = value.usexiaojinum
		end
		local  downList=self:showDownCard(viewId,tData,index,type,kanpaiNum)
		-- local  downList=self.down_cardLayer:showDownCard(viewId,tData,index,type)
		for id,vCard in ipairs(downList) do
			table.insert(peng_card_list,vCard)
		end

		local temp_panel = {}
		temp_panel.card_sprite = peng_card_list
		temp_panel.card_value = value 
		print("[CardLayer:optCard]展示碰杠牌viewId   peng_card_list ", viewId)
		dump(peng_card_list)
		table.insert(card_list1,temp_panel) --碰杠牌的数据结构	
	end

	if viewId == RoomConfig.MySeat then
		self:sortHandCard(viewId,type)
	end

	--self.node.marker:hide()
	self.markerAnim:hide()
	if isreset == nil or isreset ~= true then
		local sex = self.part:getPlayerInfo(viewId).sex;
		local seat_id = self.part:getPlayerInfo(viewId).seat_id;
		self:playOperateEffect(type , sex , seat_id)
	end

	self:resetShuaiPaiScript(self.shuaiPaiNums)
end

function XYCardLayer:sortHandCard(viewId,optCard)

	print("XYCardLayersortHandCard---------:") 

	self:initMySeatCardPosList(CardLayer.MySeatPerSize) 
	-- 手牌
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	local card_num = #card_list


	--吃碰杠的牌
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #card_list1

	--需要根据吃碰杠的数量重新排列位置(每有碰一个往右边移动一个牌子宽度)
	--存储最多13个位置
	for i=1,card_num do
		local v = card_list[i]
		local pos = self._mySeatPosList[i+card_num1]
		if pos and v.card_sprite then
			v.card_sprite:setPosition(pos)
			v.card_pos = pos	
		end
	end

	print("This is sort hand card:",card_num,card_num1)
	--吃碰杠操作后
	if (optCard and (optCard == RoomConfig.Peng or optCard == RoomConfig.Chi)) or card_num == (RoomConfig.HandCardNum + 1)then --吃碰完牌要把一张牌放到摸牌位
		if card_num == 0 then return end
		local card = card_list[card_num].card_sprite --最后一张牌移位（摸牌的偏移量）
		local pos_x = card:getPositionX()
		card:setPositionX(pos_x+self.GetCardOffsetX*(CardLayer.MySeatPerSize.width+CardLayer.MySeatCardSetOffX))
		print("RoomConfig.ChiRoomConfig.Chi")
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
	if not isreset then
		self:optEffect(viewId,type)
	end
		--self:optEffect(viewId,type)

end

function XYCardLayer:addDownCardLayer()
  	self.down_cardLayer = import(".XYDownCardLayer",CURRENT_MODULE_NAME)
  	self.down_cardLayer:init(self.res_base)
  	self.down_cardLayer:setRoot(self.node.Node_Down_Card)	
end

function XYCardLayer:showDownCard(viewId,tDownData,index, type,bKanPaiNUm)
	if self.down_cardLayer then
		if self.down_cardLayer.setPlaywayType then
			self.down_cardLayer:setPlaywayType(self.part:getPlaywayType())
		end

	  	local downList=self.down_cardLayer:showDownCard(viewId,tDownData,index,type,bKanPaiNUm)
	  	if downList then 
	  		return downList
	 	end
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
	local index = 1
	print("###[XYCardLayer:resetDownCard]viewId #card_list is ", viewId, #card_list) 
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
				if (not self.part:showAnGang()) then
					c4 = RoomConfig.EmptyCard
				end
			end

			local tData = {}
			tData[1] = c1 
			tData[2] = c2
			tData[3] = c3
			tData[4] = c4
			-- local downCard = self.down_cardLayer:showDownCard(viewId,tData,index, v.type)
			release_print(os.date("%c") .. "[info] 信阳牌页面展示杠downCard ", viewId, c1, c2, c3, c4, index, v.type)
			local downCard =self:showDownCard(viewId,tData,index, v.type,v.usexiaojinum)	
			local card1 =downCard[1]
			local card2 =downCard[2]
			local card3 =downCard[3]
			local card4 =downCard[4]

			card_data = {mcard={c1,c1,c1,c1}}

			table.insert(peng_card_list,card1)
			table.insert(peng_card_list,card2)
			table.insert(peng_card_list,card3)
			table.insert(peng_card_list,card4)
			table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=peng_card_list,card_value=card_data}) --碰杠牌的数据结构
			index = index + 1

			-- local kanpaiCardNum = v.usexiaojinum or 0 --字段复用，这里表示downcard中砍牌的数量
			-- local addIconIndex = {1, 2, 4, 3}
			-- local addIconFlag = {}
			-- for i=1,kanpaiCardNum do
			-- 	addIconFlag[addIconIndex[i]] = true
			-- end

			-- local card1 = self.card_factory:createDownCardWithData(viewId,c1,addIconFlag[1])
			-- local card2 = self.card_factory:createDownCardWithData(viewId,c2,addIconFlag[2])
			-- local card3 = self.card_factory:createDownCardWithData(viewId,c3,addIconFlag[3])
			-- local card4 = self.card_factory:createDownCardWithData(viewId,c4,addIconFlag[4])
			-- card_data = {mcard={c1,c2,c3,c4}}
			-- local pos1 = nil
			-- local pos2 = nil
			-- local pos3 = nil
			-- local pos4 = nil
			-- local size = card1:getContentSize()
			
			
			-- if viewId == RoomConfig.MySeat then --有数据的手牌
			-- 	size.width = size.width * 1.42
			-- 	size.width = size.width - 2
			-- 	pos1 = cc.p((-RoomConfig.HandCardNum/2-0.5+(1+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
			-- 	pos2 = cc.p((-RoomConfig.HandCardNum/2-0.5+(2+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
			-- 	pos3 = cc.p((-RoomConfig.HandCardNum/2-0.5+(3+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0)
			-- 	pos4 = cc.p((-RoomConfig.HandCardNum/2-0.5+(2+(i-1)*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*size.width+ (i -2)*self.PengCardOffset*size.width,0+size.height * self.GangCardOffset)
			-- elseif viewId == RoomConfig.DownSeat then
			-- 	pos1 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (1-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
			-- 	pos2 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (2-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
			-- 	pos3 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (3-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
			-- 	pos4 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (2-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height+size.width * self.GangCardOffset)
			-- elseif viewId == RoomConfig.FrontSeat then
			-- 	size = cc.size(size.width*0.7,size.height*0.7)
			-- 	pos1 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(1+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
			-- 	pos2 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
			-- 	pos3 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(3+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0)
			-- 	pos4 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width,0+size.height * self.GangCardOffset)
			-- 	card:setScale(0.7)
			-- elseif viewId == RoomConfig.UpSeat then
			-- 	pos1 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(1+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
			-- 	pos2 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
			-- 	pos3 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(3+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height)
			-- 	pos4 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+size.width/2)
			-- end

			-- card1:setPosition(pos1)
			-- card2:setPosition(pos2)
			-- card3:setPosition(pos3)
			-- card4:setPosition(pos4)
			-- self.node["hcard_node" .. viewId]:addChild(card1)
			-- self.node["hcard_node" .. viewId]:addChild(card2)
			-- self.node["hcard_node" .. viewId]:addChild(card3)
			-- self.node["hcard_node" .. viewId]:addChild(card4)
			-- table.insert(peng_card_list,card1)
			-- table.insert(peng_card_list,card2)
			-- table.insert(peng_card_list,card3)
			-- table.insert(peng_card_list,card4)
			-- table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=peng_card_list,card_value=card_data}) --碰杠牌的数据结构
			-- peng_card_list = {}
		elseif v.type  == RoomConfig.Peng then --直接使用数据创建三张牌
			local card_value = v.cardValue  -- 字段命名可能不一致
			local c1 = bit._and(card_value,0xff)
			local c2 = bit._and(bit.rshift(card_value,8),0xff)
			local c3 = bit._and(bit.rshift(card_value,16),0xff)
			card_data = {mcard={c1,c2,c3}}
			print("this is create peng card :",c1,c2,c3)
			local tData = {}
			tData[1] = c1 
			tData[2] = c2
			tData[3] = c3

			-- local downCard = self.down_cardLayer:showDownCard(viewId,tData,index, v.type)
			release_print(os.date("%c") .. "[info] 牌页面展示吃碰downCard ", viewId, c1, c2, c3, index, v.type)		
			local downCard = self:showDownCard(viewId,tData,index, v.type,v.usexiaojinum)	

			local card1 =downCard[1]
			local card2 =downCard[2]
			local card3 =downCard[3]

			table.insert(peng_card_list,card1)
			table.insert(peng_card_list,card2)
			table.insert(peng_card_list,card3)
			table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=clone(peng_card_list),card_value=card_data}) --碰杠牌的数据结构
			peng_card_list = {}
			index = index + 1
		end
	end
end

function XYCardLayer:showNaozhuangIcon(viewId)
	local naozhuangIcon = self.node['icon_naozhuang' .. viewId]
	if naozhuangIcon then
		naozhuangIcon:show()
	end
end

function XYCardLayer:showTongnaoIcon(viewId)
	local tongnaoIcon = self.node['icon_tongnao' .. viewId]
	if tongnaoIcon then
		tongnaoIcon:show()
	end
end

function XYCardLayer:isNaozhuangIconShow()
	local ret = false

	if self.node.icon_naozhuang1 and self.node.icon_naozhuang1:isVisible() then
		ret = true
	elseif self.node.icon_tongnao1 and self.node.icon_tongnao1:isVisible() then
		ret = true
	end

	return ret
end

function XYCardLayer:pushOverShowKanPaiValue(tbKanPaiValue,i)
	if not self.down_cardLayer then return end
	local viewId = i
	local card_list = self.card_list[RoomConfig.DownCard][viewId]
	if not card_list and #card_list <=0 then
		return
	end
	self.down_cardLayer:pushOverShowKanPaiValue(tbKanPaiValue,viewId,#card_list)
end

function XYCardLayer:hideBaoCard()
	if self.node.bao1 then
		self.node.bao1:hide()
	end

	if self.node.bao2 then
		self.node.bao2:hide()
	end
end

function XYCardLayer:resetShuaiPaiScript(shuaiPaiNums)
	shuaiPaiNums = shuaiPaiNums or self.shuaiPaiNums
	if not shuaiPaiNums then
		shuaiPaiNums = {}
	end
	self.shuaiPaiNums = {}
	for _,v in pairs(shuaiPaiNums) do
		table.insert(self.shuaiPaiNums, v)
	end

	local function addShuaiScript(card)
		local kan_sp = cc.Sprite:create(self.res_base .. "/shuaiScript.png")
		kan_sp:setAnchorPoint(cc.p(0,0))
        kan_sp:setPosition(cc.p(0,0))
		kan_sp:setTag(1)
		card:addChild(kan_sp)
		kan_sp:setLocalZOrder(30)
	end

	local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	local shuai_card_list = {}
    for i,v in ipairs(card_list) do
    	local showKanpaiIcon = false
		for idx,shauipai_val in pairs(shuaiPaiNums) do
			if shauipai_val == v.card_value then
				shuaiPaiNums[idx] = 0
				showKanpaiIcon = true
				break
			end
		end

		local tag = v.card_sprite:getChildByTag(1)
		if showKanpaiIcon then
			if tag then
				tag:show()
			else
		 		addShuaiScript(v.card_sprite)
		 	end
		 	table.insert(shuai_card_list, v)
		else
			if tag then
				tag:hide()
			end
		end		
    end
    
    self:updateMyCardMask(shuai_card_list,true,self.maskType.shuaipaiMask)
end

return XYCardLayer