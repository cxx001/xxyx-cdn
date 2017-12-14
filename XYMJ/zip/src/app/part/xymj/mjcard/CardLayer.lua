--[[
*名称:CardLayer
*描述:手牌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CardLayer = class("CardLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
CardLayer.GetCardOffsetX = 1/5 --摸牌的位置偏移量
CardLayer.OutCardOffset = 6/5 --出牌位置偏移量
CardLayer.OutCardSortOffsetCol = 2/3 --出牌位置排列列偏移量
CardLayer.OutCardSortOffsetRow = 4/5 --出牌位置排列行偏移量
CardLayer.PengCardOffset = 1/3 --碰杠的偏移量
CardLayer.GangCardOffset = 1/6 --杠的牌的y轴偏移量
CardLayer.OutCardCol = 9 --出牌队列有多少列
CardLayer.OutCardRow = 2 --出牌队列有多少行
CardLayer.StandCardOffset = 1/6 --立起的牌的偏移量
CardLayer.OutCardTime = 0.1 --出牌时间
CardLayer.AddCardTime = 0.1
CardLayer.ShowCardTime = 0.2 --出牌展示停顿时间

function CardLayer:onCreate()
	-- body
	self:initWithFilePath("CardLayer",CURRENT_MODULE_NAME)
	self.card_list = {}
	self.card_list[RoomConfig.HandCard] = {} --手牌队列
	self.card_list[RoomConfig.DownCard] = {} --碰杠队列
	self.card_list[RoomConfig.OutCard] = {} --出牌队列
 	for i=1,RoomConfig.TableSeatNum do
 		self.card_list[RoomConfig.HandCard][i] = {} --手牌队列
		self.card_list[RoomConfig.DownCard][i] = {} --碰杠队列
		self.card_list[RoomConfig.OutCard][i] = {} --出牌队列
 	end
 	self.last_out_card = {} --出牌列表
	self._touchListener = cc.EventListenerTouchOneByOne:create()
    self._touchListener:setSwallowTouches(false)
    self._touchListener:registerScriptHandler(handler(self, CardLayer.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self._touchListener:registerScriptHandler(handler(self, CardLayer.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self._touchListener:registerScriptHandler(handler(self, CardLayer.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self._touchListener, self)

    self.opt_show = false
    self.card_touch_enable = false --是否可以点击牌
    self.select_card = {} --当前选择的牌的信息
    self.out_line = 0 --出牌的线超过这个位置就是出牌
    self.node.root:runAction(self.node.animation)
  	self.card_factory = self:createCardFactory()
  	self.node.ma_list1:setItemModel(self.node.ma_panel)
  	self.node.ma_list1:hide()

  	if self.node.opt_card_list then
  		self.node.opt_card_list:addEventListener(handler(self,CardLayer.optListEvent))
  		self.node.opt_card_list:setScrollBarEnabled(false)
  		self.node.opt_card_list:hide()
  	end

  	self:setGangPicState(false)

end

function CardLayer:createCardFactory()
	local card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
  	card_factory:init(self.res_base)
	return card_factory
end

function CardLayer:PengClick()
	-- body
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_PENG)
	self:hideOpt()
	self.card_touch_enable = false
end

function CardLayer:GangClick()
	-- body
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
	self:hideOpt()
	self.card_touch_enable = false
	self:setGangPicState(false)
end

function CardLayer:GuoClick()
	-- body
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_CANCEL)
	self:sortHandCard(RoomConfig.MySeat) --放下举起的牌
	self:hideOpt()
	self.card_touch_enable = true
end

function CardLayer:HuClick()
	-- body
end

function CardLayer:ChiClick()
	-- body
	self.part:doChiClick()
	self.card_touch_enable = false
end

function CardLayer:hideOpt()
	-- body
	self.opt_show = false
	self.node.gang_btn:hide()
	self.node.gang_btn1:hide()
	self.node.peng_btn:hide()
	self.node.guo_btn:hide()
	self.node.opt_card_list:hide()
	self.node.chi_list:hide()

	self.node.ma_list1:hide() --隐藏掉 杠的单个选择列表
	self.node.ma_list2:hide() --隐藏掉 杠的组合选择列表

	self.node.baoSelect1:hide()
	self.node.baoSelect2:hide()
	print("this is hide opt ---------------------------------------------")
end

function CardLayer:refreshOtherCard(viewId,dlist,hlist,olist)
	-- body
	self:resetDownCard(viewId,dlist)
	self:resetHandCard(viewId,hlist)
	self:resetOutCard(viewId,olist)
end

--重新设置手牌
function CardLayer:resetHandCard(viewId,cardList)
	-- body
	------------删除手牌重新生成手牌数据
	self.card_list[RoomConfig.HandCard][viewId] = {}

	-- @ 如果是回放模式，生成偏移
	local offset_h = 0
	local offset_w = 0
	if self.part.record_mode then
		offset_h = 20
		offset_w = 30
	end

	local num = #cardList
	for i,v in ipairs(cardList) do --计算牌的位置
		local pos = nil
		local card = self.card_factory:createWithData(viewId,v,true)--self:createHandCard(v.view_id,v.value[i])
		local size = card:getContentSize()
		size.width = size.width - 2
		-- if v.view_id == RoomConfig.MySeat then --有数据的手牌
		
		if viewId == RoomConfig.MySeat then
			pos = cc.p((i-num/2-1-self.GetCardOffsetX)*size.width,0)
			card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
		elseif viewId == RoomConfig.DownSeat then --下家从上往下列牌
			if v ~= nil then
				size.height = size.height +10
			end
			pos = cc.p(0,(RoomConfig.HandCardNum/2-i-1)*size.height/2 + offset_h)
		elseif viewId == RoomConfig.FrontSeat then --对家从右到左排列
			if v ~= nil then
				size.width = size.width/2
			end
			pos =cc.p((RoomConfig.HandCardNum/2-i+0.5)*size.width+offset_w,0)
		elseif viewId == RoomConfig.UpSeat then --上家从下到上排列
			if v ~= nil then
				size.height = size.height +10
			end
			pos = cc.p(0,(i-RoomConfig.HandCardNum/2-1)*size.height/2 - offset_w)
			card:setLocalZOrder(RoomConfig.HandCardNum - i)
		end
		-- card:setTag(i) --牌的索引
		card:setTag(v)
		card:setPosition(pos)
		self.node["hcard_node"..viewId]:addChild(card)
		local card_panel = {
			card_sprite = card,
			card_value = v, --只有自己的手牌有数据其他的都是nil
			card_pos = cc.p(card:getPosition())
		}
		table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	end
end

--重置碰杠的牌
function CardLayer:resetDownCard(viewId,cardList)
	-- body
    local card_list = self.card_list[RoomConfig.DownCard][viewId]
	self.card_list[RoomConfig.DownCard][viewId] = {}
	local card_data = {}
	local peng_card_list = {} --碰杠的牌以表结构保存

	-- @ 如果是放回模式，生成偏移
	local offset_w = 0
	local offset_h = 0
	if self.part.record_mode then
		offset_w = 35
		offset_h = 25
	end

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
			local card1 = self.card_factory:createDownCardWithData(viewId,c1)
			local card2 = self.card_factory:createDownCardWithData(viewId,c2)
			local card3 = self.card_factory:createDownCardWithData(viewId,c3)
			local card4 = self.card_factory:createDownCardWithData(viewId,c4)
			card_data = {mcard={c1,c1,c1,c1}}
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
				size = cc.size(size.width*0.5,size.height*0.5)
				pos1 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(1+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				pos2 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				pos3 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(3+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				pos4 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0+size.height * self.GangCardOffset)
				card1:setScale(0.5)
				card2:setScale(0.5)
				card3:setScale(0.5)
				card4:setScale(0.5)
			elseif viewId == RoomConfig.UpSeat then
				pos1 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(1+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
				pos2 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
				pos3 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(3+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
				pos4 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+size.width * self.GangCardOffset+offset_h)
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
		elseif v.type  == RoomConfig.Peng or v.type == RoomConfig.Chi then --直接使用数据创建三张牌
			local card_value = v.cardValue  -- 字段命名可能不一致
			local c1 = bit._and(card_value,0xff)
			local c2 = bit._and(bit.rshift(card_value,8),0xff)
			local c3 = bit._and(bit.rshift(card_value,16),0xff)
			card_data = {mcard={c1,c2,c3}}
			print("this is create peng card :",c1,c2,c3)
			local card1 = self.card_factory:createDownCardWithData(viewId,c1)
			local card2 = self.card_factory:createDownCardWithData(viewId,c2)
			local card3 = self.card_factory:createDownCardWithData(viewId,c3)

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
				pos3 = cc.p(0,(-RoomConfig.HandCardNum/2)*size.height*self.OutCardSortOffsetCol - (3-(i-1)*3)*size.height*self.OutCardSortOffsetCol + (i -2)*self.PengCardOffset*size.height)
			elseif viewId == RoomConfig.FrontSeat then
				size = cc.size(size.width*0.5,size.height*0.5)
				pos1 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(1+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				pos2 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(2+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				pos3 =cc.p((-RoomConfig.HandCardNum/2 - 1)*size.width+(3+(i-1)*3+self.PengCardOffset)*size.width+(i -2)*self.PengCardOffset*size.width - offset_w,0)
				card1:setScale(0.5)
				card2:setScale(0.5)
				card3:setScale(0.5)
			elseif viewId == RoomConfig.UpSeat then
				pos1 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(1+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
				pos2 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
				pos3 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(3+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+offset_h)
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



function CardLayer:resetDownCard_Gang(viewId,card_dataShow, card_data, i) 
	local peng_card_list = {} --碰杠的牌以表结构保存
	 
	local card1 = self.card_factory:createDownCardWithData(viewId, card_dataShow.mcard[1])
	local card2 = self.card_factory:createDownCardWithData(viewId, card_dataShow.mcard[2])
	local card3 = self.card_factory:createDownCardWithData(viewId, card_dataShow.mcard[3])
	local card4 = self.card_factory:createDownCardWithData(viewId, card_dataShow.mcard[4])
	
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
		pos4 = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*size.height*self.OutCardSortOffsetCol-(2+(i-1)*3)*size.height*self.OutCardSortOffsetCol - (i -2)*self.PengCardOffset*size.height+size.width * self.GangCardOffset)
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
end

 

function CardLayer:resetDownCard_Peng(viewId, card_data, i) 

	local peng_card_list = {} --碰杠的牌以表结构保存

	local card1 = self.card_factory:createDownCardWithData(viewId, card_data.mcard[1])
	local card2 = self.card_factory:createDownCardWithData(viewId, card_data.mcard[2])
	local card3 = self.card_factory:createDownCardWithData(viewId, card_data.mcard[3])

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



--重置已经出的牌
function CardLayer:resetOutCard(viewId,cardList)
	-- body
	print("this is reset out card:",viewId,#cardList)
	local card_list = self.card_list[RoomConfig.OutCard][viewId]
	for i,v in ipairs(card_list) do
		v.card_sprite:removeSelf()
	end
	self.card_list[RoomConfig.OutCard][viewId] = {}

	for i,v in ipairs(cardList) do
		print("this is reset out card:",v)
		self:addDownCard(viewId,v)
	end
end

--重置自己的手牌和碰杠的牌
function CardLayer:refreshMyCard(hcardList,dcardList,ocardList,value)
	-- body
	-- self:removeCurOutCard(RoomConfig.MySeat)
	if self.last_out_card[RoomConfig.MySeat] == nil then --如果出牌动画已经播完
		table.insert(ocardList,value)
	end
	self.node["hcard_node".. RoomConfig.MySeat]:removeAllChildren()
	self:resetDownCard(RoomConfig.MySeat,dcardList)
	self:resetHandCard(RoomConfig.MySeat,hcardList)
	self:resetOutCard(RoomConfig.MySeat,ocardList)
    self:sortHandCard(RoomConfig.MySeat)

	self.node.marker:hide()
end

function CardLayer:showTingCard(value)
	-- body
	local isTing = #value
	if isTing > 0 then
		self.node.ting_node:show()
		self.node.ting_card_node:removeAllChildren()
		for i,v in ipairs(value) do
			local card = self.card_factory:createWithData(RoomConfig.MySeat,v)
			local content_size = card:getContentSize()
			local pos = cc.p(content_size.width*i,0)
			card:setPosition(pos)
			self.node.ting_card_node:addChild(card)
		end
	elseif isTing == 0 then
		self.node.ting_node:hide()
	end
end

--显示/刷新 左上角的2张牌
function CardLayer:refreshBaoCardOnLayer(baoCard)
	-- body
	print("refreshBaoCard2",baoCard,self.node.bao1)
	if baoCard and self.node.bao1 then
		print("refreshBaoCard3")
		local bao1 = bit._and(baoCard,0xff);
		local bao2 = bit._and(bit.rshift(baoCard,8),0xff)
		print("refreshBaoCard4",bao1,bao2)

		local type,value = self.card_factory:decodeValue(bao1)
		if value <= 0 then
			return 
		end
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("bao1Name->",texture_name)

		self.node.bao1:loadTexture(texture_name,1)
		self.node.bao1:show()

		type,value = self.card_factory:decodeValue(bao2)
		texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("bao2Name->",texture_name)

		self.node.bao2:loadTexture(texture_name,1)
		self.node.bao2:show()
	end
end

--显示 2张抓尾的宝牌
function CardLayer:showSelectBaoCardOnLayer(baoCard)
	-- body
	if baoCard then
		local bao1 = bit._and(baoCard,0xff);
		local bao2 = bit._and(bit.rshift(baoCard,8),0xff)

		local type,value = self.card_factory:decodeValue(bao1)
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("selectbao1Name->",texture_name)

		self.node.baoSelect1:loadTexture(texture_name,1) --baoSelect1
		self.node.baoSelect1:show()

		if(bao2 == 0) then
			bao2 = 1
			print("error:bao2 is 0")
		end

		type,value = self.card_factory:decodeValue(bao2)
		texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("selectbao2Name->",texture_name)

		self.node.baoSelect2:loadTexture(texture_name,1)
		self.node.baoSelect2:show()

		self.node.baoSelect1:setTouchEnabled(true)
        self.node.baoSelect1:addTouchEventListener(function(sender,eventType)
        	if eventType == ccui.TouchEventType.ended then
               print("touch baoSelect1")
               --[[ --点击抓尾的牌 的处理
                    CCMenuItemSprite* mi=(CCMenuItemSprite*)pSender;
				    long cards=(long)mi->getUserData();
				    CCLog("cards->%ld",cards);
				    
				    PlayerTableOperationMsg msg;
				    
				    msg.operation=MAHJONG_OPERTAION_POP_LAST;//吃听也是发吃给服务器
				    
				    msg.card_value=(int)cards;
				    msg.player_table_pos=m_playerTablePos;
				    msg.unused1 = appGetGlobal()->getRoomId();
				    //
				    appGetConnection()->sendMsg(&msg);
				    
				    //移除
				    remove_operation_menu();
				    ]]

				--点击抓尾的牌 的处理
				--self.node.baoSelect1:hide()
				--self.node.baoSelect2:hide()

				self.part:doBaoCardClick(1)
				self:hideOpt() --在该方法中，隐藏掉 尾牌的选择
				self.card_touch_enable = false

				--local tmpBaoCard = 0x2114
				--self:refreshBaoCardOnLayer(tmpBaoCard)
			end
		end)

		self.node.baoSelect2:setTouchEnabled(true)
        self.node.baoSelect2:addTouchEventListener(function(sender,eventType)
        	if eventType == ccui.TouchEventType.ended then
                print("touch baoSelect2")
                --self.node.baoSelect1:hide()
			    --self.node.baoSelect2:hide()

			    --点击抓尾的牌 的处理
			    self.part:doBaoCardClick(2)
				self:hideOpt()
				self.card_touch_enable = false

			    --local tmpBaoCard = 0x1519
				--self:refreshBaoCardOnLayer(tmpBaoCard)
			end
		end)
		self.card_touch_enable = false
	end
end


--摸牌
function CardLayer:getCard(value)
	-- body
	local card = self.card_factory:createWithData(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
	local size = card:getContentSize()
	local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
	size.with = size.width -2
	local pos =cc.p((card_num-RoomConfig.HandCardNum/2+card_num1*2.1+card_num1*self.PengCardOffset)*size.width,0)
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
end

function CardLayer:onTouchBegan(touches,event)
	-- body
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
		for i,v in ipairs(card_list) do
			if v.card_sprite.touchBegan then
				v.card_sprite:touchBegan(node_pos)
			end
		end
	end
	return true
end

function CardLayer:onTouchMoved(touches,event)
	-- body

	-- local touch_pos = touches:getLocation()
	-- if self.select_card.card and self.card_touch_enable == true then
	-- 	local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
	-- 	self.select_card.card:setPosition(node_pos)
	-- 	self.select_card.stand = false
	-- end
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
		for i,v in ipairs(card_list) do
			if v.card_sprite.touchMoved then
				v.card_sprite:touchMoved(node_pos)
			end
		end
	end
end

function CardLayer:onTouchEnded(touches,event)
	-- body
	if self.card_touch_enable == true then
		local touch_pos = touches:getLocation()
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		print("CardLayer:onTouchEnded--self.out_line=", self.out_line)
		local card_list = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
		for i,v in ipairs(card_list) do
			if v.card_sprite.touchEnd and v.card_sprite:touchEnd(node_pos,self.out_line) then
				self.part:requestOutCard(v.card_sprite:getValue())
				self.card_touch_enable = false
			end
		end
	end
	-- local touch_pos = touches:getLocation()
	-- print("CardLayer:onTouchEnded--touch_pos=")
	-- SZXX_Util.gTablePrint(touch_pos)
	-- print("CardLayer:onTouchEnded--self.out_line=", self.out_line)
	-- if self.select_card.card then
	-- 	if touch_pos.y > self.out_line then
	-- 		self.card_touch_enable = false
	-- 		self.select_card_pos = cc.p(self.select_card.card:getPosition())
	-- 		self.part:requestOutCard(self.select_card.card:getTag())
	-- 		self.select_card.card:hide()
	-- 		self.select_card = {}
	-- 	elseif self.select_card.stand == false then --选择的牌要提起
	-- 		local content_size = self.select_card.card:getContentSize()
	-- 		local pos = cc.pAdd(self.select_card.pos,cc.p(0,content_size.height*self.StandCardOffset))
	-- 		self.select_card.card:setPosition(pos)
	-- 		self.select_card.card:setLocalZOrder(0)
	-- 		self.select_card.stand = true
	-- 	elseif self.select_card.stand == true then
	-- 		self.card_touch_enable = false
	-- 		self.select_card_pos = cc.p(self.select_card.card:getPosition())
	-- 		self.part:requestOutCard(self.select_card.card:getTag())
	-- 		self.select_card.card:hide()
	-- 		self.select_card = {}
	-- 	end
	-- 	self:hideOpt()
	-- end
end


-- 展示出牌的动画
function CardLayer:outCard(viewId,value)
	-- body
 	local card = self.card_factory:createWithData(RoomConfig.MySeat,value) --出牌的牌 是用自己的牌的大小来显示的

	local sex = self.part:getPlayerInfo(viewId).sex;
 	local card_type,card_value = self.card_factory:decodeValue(value)
 	self:playCardEffect(card_type , card_value , sex)

 	-- self.node["hcard_node" .. viewId]:addChild(card)
 	self:addChild(card)
 	local content_size = card:getContentSize()
	local pos = cc.p(self.node['hcard_node' .. viewId]:getPosition())
	card:setPosition(pos)
	
	if viewId == RoomConfig.MySeat then --结束时最后一张牌
		if self.select_card_pos then
			pos = clone(self.select_card_pos)
			pos = self.node["hcard_node" .. viewId]:convertToWorldSpace(pos)
			card:setPosition(pos)
			self.select_card_pos = nil
		end
		pos = cc.p(0,content_size.height*self.OutCardOffset)
	elseif viewId == RoomConfig.DownSeat then
		pos = cc.p(-content_size.width*CardLayer.OutCardOffset,0)
	elseif viewId == RoomConfig.FrontSeat then
		pos =cc.p(0,-content_size.height*CardLayer.OutCardOffset/2)
	elseif viewId == RoomConfig.UpSeat then
		pos = cc.p(content_size.width*CardLayer.OutCardOffset,0)
	end
	pos = self.node["hcard_node" .. viewId]:convertToWorldSpace(pos)
	local actions = {
						cc.Spawn:create(cc.MoveTo:create(CardLayer.OutCardTime,pos),cc.ScaleTo:create(CardLayer.OutCardTime+CardLayer.ShowCardTime,1)),
					}
	local seq = transition.sequence(actions)
	self:removeCurOutCard(viewId)
	self.last_out_card[viewId] = card
	transition.execute(card,seq,{removeSelf= false,onComplete=function()
		-- body
		if RoomConfig.Ai_Debug then
			local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
			if ai_mod:checkPengGang() == false then
				ai_mod:turnSeat()
			end
		else
			self:addOutCard(viewId,value)
		end
	end})

end

function CardLayer:showHuCardSp(viewId,value)
	local card = self.card_factory:createWithData(RoomConfig.MySeat,value) --出牌的牌 是用自己的牌的大小来显示的

	local sex = self.part:getPlayerInfo(viewId).sex;
 	local card_type,card_value = self.card_factory:decodeValue(value)
 	self:addChild(card,20)
 	card:setAnchorPoint(cc.p(0.5,0.5))

 	local pos = cc.p(self.node['ocard_node' .. viewId]:getPosition())
	-- if viewId == RoomConfig.MySeat then --结束时最后一张牌
	-- 	pos = cc.p(640,255)
	-- elseif viewId == RoomConfig.DownSeat then
	-- 	pos = cc.p(960,390)
	-- elseif viewId == RoomConfig.FrontSeat then
	-- 	pos =cc.p(640,577)
	-- elseif viewId == RoomConfig.UpSeat then
	-- 	pos = cc.p(320,390)
	-- end
	if viewId == RoomConfig.MySeat then
		pos.y = pos.y - 30
	end
	card:setPosition(pos)
end

--移除当前出的牌
function CardLayer:removeCurOutCard(viewId) 
	-- body
	if self.last_out_card[viewId] ~= nil then
		self.last_out_card[viewId]:stopAllActions()
		self.last_out_card[viewId]:removeSelf()
		self.last_out_card[viewId] = nil
	end
end


function CardLayer:turnSeat(viewId)
	-- body
	self.select_card = {}
	-- self:hideOpt()
	print("this is turnSeat -------------------------:",self.opt_show)
	if viewId == RoomConfig.MySeat and self.opt_show == false then --轮到自己操作才能操作牌
	    self.card_touch_enable = true
	else
	    self.card_touch_enable = false
	end

end

--加入一个操作显示
function CardLayer:showAddOpt(optList)
	-- bod
	self.opt_list = optList
	self.node.opt_card_list:removeAllChildren()
  	self.node.opt_card_list:setItemModel(self.node.opt_card_panel)
  	self.node.opt_card_list:show()

  	local baseSize = self.node.opt_card_panel:getContentSize()
  	for i,v in ipairs(optList) do
		self.node.opt_card_list:insertDefaultItem(i-1) 
		local item = self.node.opt_card_list:getItem(i-1)
		local opt_btn = item:getChildByName("opt_btn") 
		local texture_name = string.format("%s/%s",self.res_base,self:mapOptPicName(v))
		print("=========CardLayer:showAddOpt " .. texture_name)
		opt_btn:ignoreContentAdaptWithSize(true)
		opt_btn:loadTextureNormal(texture_name, 1)
		opt_btn:addClickEventListener(function(...) self:optClick(i) end)
		--如果操作字超过两个字，则改变两个操作字之间的间隙
		if opt_btn:getContentSize().width > baseSize.width then
			item:setContentSize(cc.size(opt_btn:getContentSize().width ,item:getContentSize().height))
		end
		self.opt_show = true
	end
	
	self.node.opt_card_list:forceDoLayout()
	self.node.opt_card_list:jumpToPercentHorizontal(100)
end

function CardLayer:optClick(cur_select)
	self.card_touch_enable = false
	self:hideOpt()
	self.part:optClick(self.opt_list[cur_select])
	self.opt_list = nil
end

function CardLayer:mapOptPicName(optValue)
	local pic_name = ""
	if optValue == RoomConfig.MAHJONG_OPERTAION_CANCEL then
		pic_name = "cancel_bt.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_CHI then
		pic_name = "chi.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_PENG then
		pic_name = "peng_bt.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_AN_GANG or optValue == RoomConfig.MAHJONG_OPERTAION_MING_GANG or optValue == RoomConfig.Gang then
		pic_name = "gang_bt.png"
	elseif optValue == RoomConfig.MAHJONG_OPERTAION_HU then
		pic_name = "hu.png"
	end
	return pic_name
end

function CardLayer:setGangPicState(enable)
	-- body
	if self.node.gang_pic_btn then
		if enable then
			self.node.gang_pic_btn:setTouchEnabled(true)
			self.node.gang_pic_btn:setEnabled(true)
		else
			self.node.gang_pic_btn:setTouchEnabled(false)
			self.node.gang_pic_btn:setEnabled(false)
		end
	end
end

function CardLayer:optListEvent(ref,event)
	-- body
	local cur_select = self.node.opt_card_list:getCurSelectedIndex()
	self.cur_item = self.node.opt_card_list:getItem(cur_select)
	print("--------optListEvent event :",event,cur_select)
	if event == 0 and self.opt_list then
	    self.cur_item:addTouchEventListener(handler(self,CardLayer.optListItemEvent))
	end
	if event == 1 and self.opt_list then
	    self.card_touch_enable = false
		self:hideOpt()
		self.part:optClick(self.opt_list[cur_select + 1])
		self.opt_list = nil
	end
end

function CardLayer:optListItemEvent(ref,event)
	print("--------optListItemEvent event :",event)
	if event == 0 or event == 1 then
		local actions = {
		                    cc.ScaleTo:create(0.01,1.2),
		                 }
		local seq = transition.sequence(actions)
		    transition.execute(self.cur_item , seq)
	elseif event == 2 or event == 3 then --按钮下touchend事件
		local actions = {
		                    cc.ScaleTo:create(0.01,1),
		                 }
		local seq = transition.sequence(actions)
		    transition.execute(self.cur_item , seq)
	end
end

--显示碰杠过操作
-- function CardLayer:showOpt(type,value)
-- 	-- body
-- 	self.card_touch_enable  = false
-- 	if type == RoomConfig.MingGang then
-- 		self.node.gang_btn:show()
-- 		self.node.peng_btn:show()
-- 		self.node.guo_btn:show()
-- 	elseif type == RoomConfig.AnGang or type == RoomConfig.BuGang then
-- 		self.node.gang_btn1:show()
-- 		self.node.guo_btn:show()
-- 	elseif type == RoomConfig.Peng then
-- 		self.node.peng_btn:show()
-- 		self.node.guo_btn:show()
-- 	elseif type == RoomConfig.Hu then --红中麻将自动就胡了
-- 	end

-- 	for i,v in ipairs(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]) do
-- 		for j,k in ipairs(value.mcard) do
-- 			if v.card_value == k then
-- 				local content_size = v.card_sprite:getContentSize()
-- 				local pos = cc.pAdd(v.card_pos,cc.p(0,content_size.height*self.StandCardOffset))
-- 				v.card_sprite:setPosition(pos)
-- 			end
-- 		end
-- 	end
-- end

--玩家牌被吃碰了移除最后出的牌
function CardLayer:removeLastCard(lastOpt,value)
	-- body
	if self.last_out_card[lastOpt] then
		self:removeCurOutCard(lastOpt)
	end
    local opt_card =  bit._and(value,0xff)
    local out_card = self.card_list[RoomConfig.OutCard][lastOpt]
    local out_card_size = #out_card
    for i=out_card_size,1,-1 do
    	if out_card[i].card_value == opt_card then
			out_card[i].card_sprite:removeSelf()
			table.remove(out_card,i)
			break
		end
    end
end

function CardLayer:showHuAnimate(viewId,maList,huType)
	-- body
	local card_node = self.node["hcard_node" .. viewId]
	local pos = cc.p(card_node:getPosition()) 
	self.node.hu_sprite:setPosition(pos)
	self.node.hu_sprite:show() 
    self.node.animation:setLastFrameCallFunc(function()
		local huTexture = "" 
		if 0 == huType then
			huTexture =self.res_base .. "/hu.png"
			
		else
			huTexture = self.res_base .. "/zimo.png" 
		end
		print(string.format("###[CardLayer:showHuAnimate] hu_sprite huType is %d and texture is %s ",huType,huTexture))
		self.node.hu_sprite:setSpriteFrame(huTexture) 
    	-- body
    	if #maList > 0 then
	    	self.node.ma_list1:show()
	    	local function addMa(i)
	    		-- body
	    		if i > #maList then
	    			return
	    		end

	    		local type,value = self.card_factory:decodeValue(maList[i])
	    		self.node.ma_list1:insertDefaultItem(i-1)
	    		local item = self.node.ma_list1:getItem(i-1)
	    		local ma = item:getChildByName("ma1")
				local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
				ma:loadTexture(texture_name,1)
				ma:fadeIn({time= 0.5,onComplete=function()
					-- body
					addMa(i+1)
				end})
				
	    	end
	    	addMa(1)
		end 
    end)
	self.node.animation:play("hu_animate",false)
end



--玩家吃,碰,杠
--value= {mcard={2,3},ocard = 1}
-- isreset 是否有音效，断线重连没有音效
function CardLayer:optCard(viewId,type,value,lastOpt,isreset)
	-- 删除吃碰杠的牌
	print("###[HBCardLayer:optCard] this is optCard:",viewId,type,value,lastOpt) 
	self.card_touch_enable = false   
	self:refreshOptDownCard(viewId, value, type) 
	self.node.marker:hide()
	if isreset == nil or isreset ~= true then
		local sex = self.part:getPlayerInfo(viewId).sex;
		local seat_id = self.part:getPlayerInfo(viewId).seat_id;
		self:playOperateEffect(type , sex , seat_id)
	end
end

--[[
@ 回放重设所有的牌
]]
function CardLayer:resetAllCards()
	for i=1, 4 do
		self.card_list[RoomConfig.HandCard][i] = {}
		self.card_list[RoomConfig.DownCard][i] = {}
		self.node["hcard_node"..i]:removeAllChildren()
	end
end

--返回需要删除的手牌
function CardLayer:delUnhandCard(viewId, type, delCardList)  
	local card_list = self.card_list[RoomConfig.HandCard][viewId] 
	print("###[CardLayer:delUnhandCard] card_list1 is")
	dump(card_list)
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
	print("###[CardLayer:delUnhandCard] card_list2 is")
	dump(card_list)
	print("###[CardLayer:delUnhandCard] delCardList is")
	dump(delCardList)
	return  delCardList
end

function CardLayer:refreshOptDownCard(viewId, optValue, type) 

	local newDownCardList = {}
	for i, v in pairs(optValue.mcard) do
		table.insert(newDownCardList, v)
	end  

	self:delUnhandCard(viewId, type, newDownCardList) 

	if optValue.ocard then
		table.insert(newDownCardList, 1, optValue.ocard)
	end  

	local curDownCardList = self.card_list[RoomConfig.DownCard][viewId]  
	local showCardList = self:getOptChiPengGangList(viewId, newDownCardList, curDownCardList, type)
	if type ~= RoomConfig.BuGang then --补杠不需要创建新的牌堆
		local temp_panel = {}
		temp_panel.card_sprite = showCardList
		temp_panel.card_value = optValue 
		table.insert(curDownCardList,temp_panel) --碰杠牌的数据结构	
	else
		print("###[CardLayer:refreshOptDownCard]showCardList is empty")
	end 


	if viewId == RoomConfig.MySeat then
		self:sortHandCard(viewId,type)
	end    
end



function CardLayer:doLaiziGangAction(viewId, laiziValue)
	self.part:showOutCard(viewId, laiziValue) 
end

function CardLayer:getOptChiPengGangList(viewId, downCardList, curDownCardList, type)  
	local curDownCardNum = #curDownCardList 
	local showCardList = {} --碰杠的牌以表结构保存 
	local refCard = self.card_factory:createDownCardWithData(viewId,1) 
	for i,cardValue1 in ipairs(downCardList) do 

		local card = self.card_factory:createDownCardWithData(viewId,cardValue1) 
		local size = refCard:getContentSize() 

		if downCardValue == RoomConfig.EmptyCard and viewId == RoomConfig.DownSeat then --下家的背牌旋转了-90度宽高需要调转我也不知道为啥图片要这么出
			size = {width=size.height,height = size.width}
		end 
		local pos = nil   

		if type == RoomConfig.BuGang then
			print("###[CardLayer:getOptChiPengGangList] downCardList is ")
			dump(downCardList)
			print("###[CardLayer:getOptChiPengGangList] curDownCardList is ")
			dump(curDownCardList)
			for k, cardInfo in ipairs(curDownCardList) do
				--print("this is room config bugang:",cardInfo.card_value.mcard[1],cardValue1,cardInfo.card_sprite[2]:getPositionX())
				if cardInfo.card_value.mcard[1] == cardValue1 then --补杠只需要创建一张牌
					local card_sprite = cardInfo.card_sprite[2] --第二张
					pos = self:getOptBuGangDownPos(viewId, cc.p(card_sprite:getPositionX(), card_sprite:getPositionY()), size)

					if viewId == RoomConfig.FrontSeat then
						card:setScale(0.7)
					end

					card:setPosition(pos)
					self.node["hcard_node" .. viewId]:addChild(card)
					table.insert(cardInfo.card_sprite,card)
					break
				end
			end 

		elseif type == RoomConfig.MingGang or type == RoomConfig.AnGang then--如果是其他人暗杠是看不到牌的 --自己暗杠可以看到一张牌
			pos = self:getOptMingOrAnGangDownPos(viewId, i, size, curDownCardNum) 
			card:setPosition(pos)
			if viewId == RoomConfig.FrontSeat then
				card:setScale(0.7)
			end 
			self.node["hcard_node" .. viewId]:addChild(card) 
			table.insert(showCardList,card) 

		elseif type == RoomConfig.Peng  
			or type == RoomConfig.Chi 
			or type == RoomConfig.PIZI_NOTIFY 
			or type == RoomConfig.PIZI_NOTIFY_AN then
			pos = self:getOptPengOrChiDownPos(viewId, i, size, curDownCardNum)
			card:setPosition(pos)
			if viewId == RoomConfig.FrontSeat then
				card:setScale(0.7)
			end 
			self.node["hcard_node" .. viewId]:addChild(card)
			table.insert(showCardList,card) 

		end

	end 
	return showCardList
end

function CardLayer:getOptBuGangDownPos(viewId, basePos, cardSize)  
	local pos
	if viewId == RoomConfig.MySeat or viewId == RoomConfig.FrontSeat then
		pos = cc.p(basePos.x,basePos.y+cardSize.height*self.GangCardOffset)
	else
		pos = cc.p(basePos.x,basePos.y+cardSize.width*self.GangCardOffset)
	end
	print(string.format("###[CardLayer:getOptBuGangDownPos] basePos %f,%f", basePos.x,basePos.y))
	print(string.format("###[CardLayer:getOptBuGangDownPos] pos %f,%f", pos.x,pos.y))
	return pos
end

function CardLayer:getOptMingOrAnGangDownPos(viewId, index, cardSize, cardNum)
	local pos
	if viewId == RoomConfig.MySeat then --有数据的手牌
		cardSize.width = cardSize.width*1.42
		cardSize.width = cardSize.width - 2
		local offset_y = 0
		--local index=  i
		if index == 4 then
			offset_y = cardSize.height * self.GangCardOffset
			index = 2
		end
		pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(index+cardNum*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*cardSize.width+ (cardNum -1)*self.PengCardOffset*cardSize.width,offset_y)
	elseif viewId == RoomConfig.DownSeat then
		local offset_y = 0
		--local index=  i
		if index == 4 then
			offset_y = cardSize.width * self.GangCardOffset
			index = 2
		end
		pos = cc.p(0,(-RoomConfig.HandCardNum/2 + 1.5)*cardSize.height*self.OutCardSortOffsetCol - (index-cardNum*3)*cardSize.height*self.OutCardSortOffsetCol + (cardNum -1)*self.PengCardOffset*cardSize.height+offset_y)
	elseif viewId == RoomConfig.FrontSeat then
		local offset_y = 0
		--local index=  i
		if index == 4 then
			offset_y = cardSize.height * self.GangCardOffset
			index = 2
		end
		cardSize = cc.size(cardSize.width*0.7,cardSize.height*0.7)
		pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*cardSize.width+(index+cardNum*3+self.PengCardOffset)*cardSize.width+(cardNum -1)*self.PengCardOffset*cardSize.width,0+offset_y)
		
	elseif viewId == RoomConfig.UpSeat then
		local offset_y = 0
		--local index=  i
		if index == 4 then
			offset_y = cardSize.width * self.GangCardOffset
			index = 2
		end
		pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*cardSize.height*self.OutCardSortOffsetCol-(index+cardNum*3)*cardSize.height*self.OutCardSortOffsetCol - (cardNum -1)*self.PengCardOffset*cardSize.height+offset_y)
	end
	return pos
end

function CardLayer:getOptPengOrChiDownPos(viewId, i, cardSize, cardNum) 
	local pos
	if viewId == RoomConfig.MySeat then --有数据的手牌
		cardSize.width = cardSize.width*1.42
		cardSize.width = cardSize.width - 2
		pos = cc.p((-RoomConfig.HandCardNum/2-0.5+(i+cardNum*3+self.PengCardOffset)*0.7-self.GetCardOffsetX)*cardSize.width + (cardNum-1)*self.PengCardOffset*cardSize.width,0)
	elseif viewId == RoomConfig.DownSeat then
		pos = cc.p(0,(-RoomConfig.HandCardNum/2 + 1.5)*cardSize.height*self.OutCardSortOffsetCol - (i-cardNum*3)*cardSize.height*self.OutCardSortOffsetCol + (cardNum -1)*self.PengCardOffset*cardSize.height)
	elseif viewId == RoomConfig.FrontSeat then
		cardSize = cc.size(cardSize.width*0.7,cardSize.height*0.7)
		pos =cc.p((-RoomConfig.HandCardNum/2 - 1.5)*cardSize.width+(i+cardNum*3+self.PengCardOffset)*cardSize.width+(cardNum -1)*self.PengCardOffset*cardSize.width,0)
		 
	elseif viewId == RoomConfig.UpSeat then
		pos = cc.p(0,(RoomConfig.HandCardNum/2+0.5)*cardSize.height*self.OutCardSortOffsetCol-(i+cardNum*3)*cardSize.height*self.OutCardSortOffsetCol - (cardNum -1)*self.PengCardOffset*cardSize.height)
	end
	return pos
end


function CardLayer:touchCardEvent(touch,event)
	-- body
	print("This is touch card event :",self.select_card.card)
	if self.card_touch_enable == false then
		self.select_card = {}
		return
	end

	if event == 0 then
		if self.select_card.card then --如果有选择牌并且选择的是当前的牌
			if self.select_card.card:getTag() == touch:getTag() and self.select_card.stand == true then
				print("This is touch card event :",self.select_card.card:getTag(),touch:getTag())
				self.select_card.card:setPosition(self.select_card.pos)
			else
				self.select_card.card:setPosition(self.select_card.pos)
				self.select_card = {
				card = touch,
				stand  = false, --选择的牌是否立起
				pos = cc.p(touch:getPosition())}
				self.select_card.card:setLocalZOrder(RoomConfig.HandCardNum)
			end
		else
			self.select_card = {
			card = touch,
			stand  = false, --选择的牌是否立起
			pos = cc.p(touch:getPosition())}
			self.select_card.card:setLocalZOrder(RoomConfig.HandCardNum)
		end

		-- if self.select_card.card == nil then
		-- 	self.select_card = {
		-- 	card = touch,
		-- 	stand  = false, --选择的牌是否立起
		-- 	pos = cc.p(touch:getPosition())}
		-- 	self.select_card.card:setLocalZOrder(RoomConfig.HandCardNum)
		-- end
	elseif event == 2 then

	end
end

--[[
游戏开始创建手牌
牌摆放的顺序很重要会影响碰杠的牌的摆放
--]]
function CardLayer:createCardWithData(data)
	-- body
	for i,v in ipairs(data) do
		local content_pos = cc.p(self.node["hcard_node" .. v.view_id]:getPosition())
		
		if v.num > RoomConfig.HandCardNum then
			v.num = RoomConfig.HandCardNum
		end
		
		for i=1,v.num do --计算牌的位置
			local pos = nil
			local card = self.card_factory:createWithData(v.view_id,v.value[i],true)--self:createHandCard(v.view_id,v.value[i])
			local size = card:getContentSize()
			size.width = size.width - 2
			if v.view_id == RoomConfig.MySeat then --有数据的手牌
				pos = cc.p((i-v.num/2-1-self.GetCardOffsetX)*size.width,0)
				card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
				-- card:setTag(i) --牌的索引
				card:setTag(v.value[i])
				self.out_line = content_pos.y + size.height/2
			elseif v.view_id == RoomConfig.DownSeat then --下家从上往下列牌
				if v.value[i] ~= nil then
					size.height = size.height +10
				end
				pos = cc.p(0,(v.num/2-i-1)*size.height/2)
			elseif v.view_id == RoomConfig.FrontSeat then --对家从右到左排列
				if v.value[i] ~= nil then
					size.width = size.width/2
				end
				pos =cc.p((v.num/2-i+0.5)*size.width,0)
			elseif v.view_id == RoomConfig.UpSeat then --上家从下到上排列
				if v.value[i] ~= nil then
					size.height = size.height +10
				end
				pos = cc.p(0,(i-v.num/2-1)*size.height/2)
				card:setLocalZOrder(v.num - i)
			end
			card:setPosition(pos)
			self.node["hcard_node"..v.view_id]:addChild(card)

			local card_panel = {
				card_sprite = card,
				card_value = v.value[i], --只有自己的手牌有数据其他的都是nil
				card_pos = cc.p(card:getPosition())
			}

			table.insert(self.card_list[RoomConfig.HandCard][v.view_id],card_panel)
		end

		if v.value[v.num + 1] then
			self:getCard(v.value[v.num + 1])
		end
	end
end


--重新排列手牌 手牌的顺序必须和数据顺序一样。
function CardLayer:sortHandCard(viewId,optCard)
	-- 手牌
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	local card_num = #card_list


		--吃碰杠的牌
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #card_list1

	print("This is sort hand card:",card_num,card_num1)

	if (optCard and (optCard == RoomConfig.Peng or optCard == RoomConfig.Chi or optCard == RoomConfig.PIZI_NOTIFY)) or card_num == (RoomConfig.HandCardNum + 1)then --碰完牌要把一张牌放到摸牌位
		if card_num  > 0 then
			local card = card_list[card_num].card_sprite --最后一张牌移位
			-- card:setTag(card_num)
			card_num = card_num - 1
			local size = card:getContentSize()
			size.with = size.width -2
			local pos = cc.p((card_num-RoomConfig.HandCardNum/2+card_num1*3*0.7+card_num1*self.PengCardOffset)*size.width,0)
			card:setPosition(pos)
		end
	end



	for i=1,card_num do
		local v = card_list[i]
		local size = v.card_sprite:getContentSize()
		local pos = nil
		size.width = size.width -2
		-- v.card_sprite:setTag(i) --重新排列索引 
		local start_pos = (-self.GetCardOffsetX-RoomConfig.HandCardNum/2)*size.width --起始点位置
		local down_card_size = ((card_num1*3+self.PengCardOffset)*0.7+card_num1*self.PengCardOffset)*size.width
		if card_num1 == 0 then
				down_card_size = 0
		end
		pos = cc.p(start_pos+down_card_size+(i-1)*size.width,0)--cc.p((card_num1*3*0.7+card_num1*self.PengCardOffset)*size.width + (i-1-RoomConfig.HandCardNum/2-self.GetCardOffsetX)*size.width,0)
		v.card_sprite:setPosition(pos)
		v.card_sprite:show()
		v.card_pos = pos
	end
end



function CardLayer:addDownCard(viewId,value)
	-- body
	local sprite = self.card_factory:createDownCardWithData(viewId,value)--ccui.ImageView:create()
	-- sprite:loadTexture(frame_name,1)
	local card_list = self.card_list[RoomConfig.OutCard][viewId]
	local card_num= #card_list
	local content_size = sprite:getContentSize()
	local col = card_num%self.OutCardCol --当前牌应该放在第几列
	local row = math.floor(card_num/self.OutCardCol)  --当前牌应该放在第几行
	local pos = nil

	if viewId == RoomConfig.MySeat then
		pos = cc.p((col - self.OutCardCol/2)*content_size.width,-row*content_size.height*self.OutCardSortOffsetRow)
	elseif viewId == RoomConfig.DownSeat then
		pos = cc.p(row*content_size.width,(col - self.OutCardCol/2)*content_size.height*self.OutCardSortOffsetCol)
		sprite:setLocalZOrder(self.OutCardCol*self.OutCardRow - (row+1)*col)
	elseif viewId == RoomConfig.FrontSeat then
		pos = cc.p((self.OutCardCol/2-col)*content_size.width,row*content_size.height*self.OutCardSortOffsetRow)
		sprite:setLocalZOrder(self.OutCardRow - row)
	elseif viewId == RoomConfig.UpSeat then
		pos = cc.p(-row*content_size.width,(self.OutCardCol/2-col)*content_size.height*self.OutCardSortOffsetCol)
	end

	sprite:setPosition(pos)
	local card_panel = {
			card_sprite = sprite,
			card_value = value
		}
	table.insert(self.card_list[RoomConfig.OutCard][viewId],card_panel)

	self.node["ocard_node" .. viewId]:addChild(sprite)

			--显示出牌标记位置
	self.node.marker:show()
	self.node.marker:stopAllActions()
	local world_pos = sprite:convertToWorldSpace(sprite:getAnchorPointInPoints())
	world_pos = cc.pAdd(world_pos,cc.p(0,content_size.height/2))
	
	self.node.marker:setPosition(world_pos)
	local actions = {
						cc.MoveBy:create(0.5,cc.p(0,10)),
						cc.MoveBy:create(0.5,cc.p(0,-10)),
					}
	local seq = transition.sequence(actions)
	local action = cc.RepeatForever:create(seq)
	self.node.marker:runAction(action)
end


--增加一张牌到出牌队列
function CardLayer:addOutCard(viewId,value)
	print("--增加一张牌到出牌队列 viewId", viewId)
	-- body
	if self.last_out_card[viewId] then 
		local sprite = self.card_factory:createDownCardWithData(viewId,value) 
		local pos = self:getCardPosition(RoomConfig.OutCard, viewId, value, sprite:getContentSize())
		local world_pos = self.node["ocard_node" .. viewId]:convertToWorldSpace(pos)  
		local actions = {
					cc.Spawn:create(cc.MoveTo:create(CardLayer.AddCardTime,world_pos),cc.ScaleTo:create(CardLayer.AddCardTime,0.5)),
				}
		local seq = transition.sequence(actions)
		transition.execute(self.last_out_card[viewId],seq,{removeSelf= false,onComplete=function()
			-- body
			if self.last_out_card[viewId] then
				self:addDownCard(viewId,value)
				self:removeCurOutCard(viewId)
			end
		end})
	end
end

function CardLayer:getCardPosition(outcardType,viewId, value, size)
	local card_list = self.card_list[outcardType][viewId]
	local card_num= #card_list 
	local content_size = size
	local col = card_num%self.OutCardCol --当前牌应该放在第几列
	local row = math.floor(card_num/self.OutCardCol)  --当前牌应该放在第几行
	local pos = nil

	if viewId == RoomConfig.MySeat then
		pos = cc.p((col - self.OutCardCol/2)*content_size.width,-row*content_size.height*self.OutCardSortOffsetRow)
	elseif viewId == RoomConfig.DownSeat then
		pos = cc.p(row*content_size.width,(col - self.OutCardCol/2)*content_size.height*self.OutCardSortOffsetCol)
	elseif viewId == RoomConfig.FrontSeat then
		pos = cc.p((self.OutCardCol/2-col)*content_size.width,row*content_size.height*self.OutCardSortOffsetRow)
	elseif viewId == RoomConfig.UpSeat then
		pos = cc.p(-row*content_size.width,(self.OutCardCol/2-col)*content_size.height*self.OutCardSortOffsetCol)
	end 
	return pos
end


--获取播放吃碰杠的坐标
function CardLayer:getOptPos(viewId)
	-- body
	local card = self.card_list[RoomConfig.HandCard][viewId][1].card_sprite
 	local content_size = card:getContentSize()
	local pos = nil
	if viewId == RoomConfig.MySeat then
		pos = cc.p(0,content_size.height*self.OutCardOffset)
	elseif viewId == RoomConfig.DownSeat then
		pos = cc.p(-content_size.width*self.OutCardOffset,0)
	elseif viewId == RoomConfig.FrontSeat then
		pos =cc.p(0,-content_size.height*self.OutCardOffset/2)
	elseif viewId == RoomConfig.UpSeat then
		pos = cc.p(content_size.width*self.OutCardOffset,0)
	end
	return self.node["hcard_node"..viewId],pos
end

--zhongqy 出牌音效
function CardLayer:playCardEffect(card_type , card_value , sex) --牌类型 ， 牌数值 ， 出牌人性别
	global:getAudioModule():playSound("res/sound/dapai.wav",false)

	local sound_type = tostring(card_type)
	local sound_value = tostring(card_value)

	local sex = tostring(sex)  --模拟性别 2：男 其他：女
	local mp3_name
	if sex == "2" then
		if sound_type == "0" then
			mp3_name = string.format("res/sound/man/%dwan.mp3", sound_value)
		elseif sound_type == "1" then
			mp3_name = string.format("res/sound/man/%dtiao.mp3", sound_value)
		elseif sound_type == "2" then
			mp3_name = string.format("res/sound/man/%dtong.mp3", sound_value)
		elseif sound_type == "3" then
			mp3_name = string.format("res/sound/man/zi%d.mp3", sound_value)
		end
	else
		if sound_type == "0" then
			mp3_name = string.format("res/sound/female/g_%dwan.mp3", sound_value)
		elseif sound_type == "1" then
			mp3_name = string.format("res/sound/female/g_%dtiao.mp3", sound_value)
		elseif sound_type == "2" then
			mp3_name = string.format("res/sound/female/g_%dtong.mp3", sound_value)
		elseif sound_type == "3" then
			mp3_name = string.format("res/sound/female/zi%d.mp3", sound_value)
		end
	end
	global:getAudioModule():playSound(mp3_name,false)
end

function CardLayer:playOperateEffect(operate_type , sex , seat) 	--操作类型（胡 碰 杠）出牌人性别 出牌人位置
   local sex = tostring(sex)
   local mp3_name = nil
   local sex_name = "man"
   
   if sex ~=  "2" then
   		sex_name = "female"
   end

	if operate_type == RoomConfig.MAHJONG_OPERTAION_CHI then --吃
			mp3_name = "res/sound/".. sex_name .. "/chi.mp3"
    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PENG then --碰
			mp3_name = "res/sound/".. sex_name .. "/peng0.mp3"
    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_MING_GANG or operate_type == RoomConfig.MAHJONG_OPERTAION_AN_GANG or operate_type == RoomConfig.MAHJONG_OPERTAION_BU_GANG then --杠
		    mp3_name = "res/sound/".. sex_name .. "/gang0.mp3"
    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED then --胡
			-- mp3_name = "res/sound/".. sex_name .. "/hu.mp3"
			mp3_name = "res/sound/effect_hu.mp3"
		--为什么加下面的语句， lxb 注释掉了
		--if seat == RoomConfig.MySeat and sex ~= "2" then
		--	mp3_name = "res/sound/female/hu1.mp3"
		--end
    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED then --自摸
		-- 	mp3_name = "res/sound/".. sex_name .. "/zimo0.mp3"
		-- if seat == RoomConfig.MySeat and sex ~= "2" then
		-- 	mp3_name = "res/sound/female/zimo111.mp3"
		-- end
		mp3_name = "res/sound/effect_hu.mp3"
	end

	if mp3_name == nil then
		return 
	end
   global:getAudioModule():playSound(mp3_name,false)
end


function CardLayer:setAutoOutCard(state)
	-- body
	if state then
		self.card_touch_enable = false
		if self.select_card.card then
			self.select_card.card:hide()
			self.select_card = {}
		end
        self.node.auto_node:show()
        self:hideOpt()
	else
        self.node.auto_node:hide() 
	end
end

function CardLayer:AutoClick()
	-- body
	self.part:setAutoOutCard(false)
end

function CardLayer:showChiList(chiList)
	--显示可以杠的列表
	print("this is  show chil list ---------------------------------------:",#chiList)
	self.node.chi_list:show()
	self.node.chi_list:removeAllChildren()
	self.node.chi_list:setItemModel(self.node.chiPanel)
	self.card_touch_enable = false
	local size_x = 0
	local size_y = self.node.chi_list:getContentSize().height

	for i,v in ipairs(chiList) do
		self.node.chi_list:insertDefaultItem(i-1)
		local item = self.node.chi_list:getItem(i-1)
		for j,k in ipairs(v) do
			-- local c1 = bit._and(bit.rshift(v,(j-1)*8),0xff)
			local type,value = self.card_factory:decodeValue(k)
    		local ma = item:getChildByName("ma" .. j)
			local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
			ma:loadTexture(texture_name,1)

			size_x = size_x + ma:getContentSize().width
		end
		size_x = size_x + 8
	end

	size_x = size_x - 8
	local size = cc.size(size_x,size_y)
	self.node.chi_list:setContentSize(size)

	self.node.chi_list:forceDoLayout()
	self.node.chi_list:jumpToPercentHorizontal(50)
	self.node.chi_list:addEventListener(function(ref,event)
		print("this is chi event listener -----------:",ref,event)
		if event == 1 then
			local select_index = self.node.chi_list:getCurSelectedIndex()
			self.part:sendChilReq(chiList[select_index+1])
			--发送请求吃牌
		end
	end)
end



--云南杠牌处理
function CardLayer:GangPicClick()
	-- body
    self.part:gangClick() --杠的测试
	self:setGangPicState(false)
end

--杠的同牌不同组合 的选择列表
function CardLayer:showGangList(gangList)
	--显示可以杠的列表
	self.node.ma_list2:show()
	self.node.ma_list2:removeAllChildren()
	self.node.ma_list2:setItemModel(self.node.ma_panel1)

	local size_x = 0
	local size_y = self.node.ma_list2:getContentSize().height

	for i,v in ipairs(gangList) do
		self.node.ma_list2:insertDefaultItem(i-1)
		local item = self.node.ma_list2:getItem(i-1)
		for j = 1,4 do
			local c1 = bit._and(bit.rshift(v.cardValue,(j-1)*8),0xff)
			local type,value = self.card_factory:decodeValue(c1)
    		local ma = item:getChildByName("ma" .. j)
			local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
			ma:loadTexture(texture_name,1)
			size_x = size_x + ma:getContentSize().width
		end
		size_x = size_x +5
	end
	size_x = size_x -5
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
			print("###[CardLayer:showGangList] 点击按钮请求杠牌",gangList[select_index+1].cardValue)
			self.part:requestOptCard(RoomConfig.Gang,gangList[select_index+1].cardValue)
		end
	end)
end

--杠的不同牌 单个选择列表
function CardLayer:showGangSelect(gangList)
	-- body
	self.node.ma_list1:show()
	local size_x = 0
	local size_y = self.node.ma_list1:getContentSize().height
	for i,v in ipairs(gangList) do
		self.node.ma_list1:insertDefaultItem(i-1)
		local item = self.node.ma_list1:getItem(i-1)
		local c1 = bit._and(v,0xff)
		local type,value = self.card_factory:decodeValue(c1)
    	local ma = item:getChildByName("ma1")
    	size_x = size_x + ma:getContentSize().width+3
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		ma:loadTexture(texture_name,1)
	end

	local size = cc.size(size_x,size_y)
	self.node.ma_list1:setContentSize(size)
	self.node.ma_list1:jumpToPercentHorizontal(50)

	self.node.ma_list1:addEventListener(function(ref,event)
		-- body
		if event == 1 then
			local select_index = self.node.ma_list1:getCurSelectedIndex()
			local c1 = bit._and(gangList[select_index + 1],0xff)
			self.part:selectGang(c1)
		end
	end)
end

--显示碰杠过操作
function CardLayer:showOpt(type,value)
	-- body
	self.card_touch_enable  = false
	if type == RoomConfig.MingGang then
		self.opt_show = true
		self.node.gang_btn:show()
		self.node.peng_btn:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.AnGang or type == RoomConfig.BuGang then
		self.opt_show = true
		self.node.gang_btn1:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.Peng or type == RoomConfig.PIZI_NOTIFY then
		self.opt_show = true
		self.node.peng_btn:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.Hu then --胡的显示
	elseif type == RoomConfig.CHI then --吃的显示
		self.opt_show = true
		self.node.peng_btn:show()
		self.node.chi_btn:show()
	elseif type == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		self.opt_show = true
		print("self:showSelectBaoCardOnLayer(value.ocard)->",value.ocard)
		self:showSelectBaoCardOnLayer(value.ocard)	
	end

	for i,v in ipairs(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]) do
		for j,k in ipairs(value.mcard) do
			if v.card_value == k then
				local content_size = v.card_sprite:getContentSize()
				local pos = cc.pAdd(v.card_pos,cc.p(0,content_size.height*self.StandCardOffset))
				v.card_sprite:setPosition(pos)
			end
		end
	end
	print("this is show opt -------------------------:",self.opt_show)
end

return CardLayer
