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
CardLayer.GetCardOffsetX = 2/10 --摸牌的位置偏移量 @Deek, 2.5D效果, 原来是1/5
CardLayer.OutCardOffset = 6/5 --出牌位置偏移量
--CardLayer.OutCardSortOffsetCol = 2/3 --出牌位置排列列偏移量
CardLayer.OutCardSortOffsetCol = 0.68 --出牌位置排列列偏移量
CardLayer.OutCardSortOffsetRow = 4/5 --出牌位置排列行偏移量
CardLayer.PengCardOffset = 1/3 --碰杠的偏移量
CardLayer.GangCardOffset = 1/6 --杠的牌的y轴偏移量
--CardLayer.OutCardCol = 7 --出牌队列有多少列 2.5D效果, 控制每排摆多少个
CardLayer.OutCardCol = 7 --出牌队列有多少列 2.5D效果, 控制每排摆多少个
CardLayer.OutCardRow = 2 --出牌队列有多少行
CardLayer.StandCardOffset = 1/6 --立起的牌的偏移量
CardLayer.OutCardTime = 0.1 --出牌时间
CardLayer.AddCardTime = 0.1
CardLayer.ShowCardTime = 0.2 --出牌展示停顿时间
CardLayer.OptCardLayer = 21
CardLayer.CpgCardSpaceFactor = 1.19; -- @Deek 2.5D 控制吃碰杠牌间隙, 越小, 间隙越小
CardLayer.MySeatCardSetOffY = -4  --手牌y的偏移量
CardLayer.MySeatCardSetOffX =0  --手牌间隙调整，越大间隙越大


function CardLayer:onCreate()
	-- body
	--self:init("CardLayer-UI")
	self:initWithFilePath("CardLayer",CURRENT_MODULE_NAME)


	self.card_list = {}
	self.card_list[RoomConfig.HandCard] = {} --手牌队列
	self.card_list[RoomConfig.DownCard] = {} --碰杠队列
	self.card_list[RoomConfig.OutCard] = {} --出牌队列
	RoomConfig.ReadyCard = RoomConfig.ReadyCard or 7

	self.node.Node_Out_Cards:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_Out_Cards)

	self.node.Node_Down_Card:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_Down_Card)

	self.node.Node_Hand_Card:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_Hand_Card)

	self.node.Node_PushOver:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_PushOver)

	self.node.Node_Ext_BaiPai:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_Ext_BaiPai)

	self.node.Node_DrawingCardTip:setContentSize(display.size)
	ccui.Helper:doLayout(self.node.Node_DrawingCardTip)

	self.card_list[RoomConfig.ReadyCard] = {} --待摸牌队列 2.5D 新增
	print("RoomConfig.TableSeatNum ", RoomConfig.TableSeatNum)
 	for i=1,RoomConfig.TableSeatNum do 
 		self.card_list[RoomConfig.HandCard][i] = {} --手牌队列
		self.card_list[RoomConfig.DownCard][i] = {} --吃碰杠队列
		self.card_list[RoomConfig.OutCard][i] = {} --出牌队列
		self.card_list[RoomConfig.ReadyCard][i] = {} --待摸牌队列 2.5D 新增
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
    self.opt_animate = {} --牌操作的spine动画数组
    self.out_line = 0 --出牌的线超过这个位置就是出牌
    self.node.root:runAction(self.node.animation)
  	self.card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
  	self.card_factory:init(self.res_base)
  	self.card_factory:setPart(self.part)

  	--出牌
  	self.out_cardLayer = import(".OutCardLayer",CURRENT_MODULE_NAME)
  	self.out_cardLayer:init(self.res_base)
  	self.out_cardLayer:setRoot(self.node.Node_Out_Cards)

  	--吃碰杠牌
  	-- self.down_cardLayer = import(".DownCardLayer",CURRENT_MODULE_NAME)
  	-- self.down_cardLayer:init(self.res_base)
  	-- self.down_cardLayer:setRoot(self.node.Node_Down_Card)
    --吃碰杠牌
  	self:addDownCardLayer()

  	 --目前除了自己，其他3家的手牌
  	self.hand_cardLayer = import(".HandCardLayer",CURRENT_MODULE_NAME)
  	self.hand_cardLayer:init(self.res_base)
  	self.hand_cardLayer:setRoot(self.node.Node_Hand_Card)

   	--目前除了自己，其他3家的胡牌推倒
  	self.pushOverHand_cardLayer = import(".PushOverHandCardLayer",CURRENT_MODULE_NAME)
  	self.pushOverHand_cardLayer:init(self.res_base)
  	self.pushOverHand_cardLayer:setRoot(self.node.Node_PushOver)

     --听牌提示
  	self.drawingCardTip_cardLayer = import(".DrawingTipCardLayer",CURRENT_MODULE_NAME)
  	self.drawingCardTip_cardLayer:init(self.res_base)
  	self.drawingCardTip_cardLayer:setRoot(self.node.Node_DrawingCardTip)

  	--扩展摆牌
  	self.extBaiPai_cardLayer = import(".ExtBaiPaiCardLayer",CURRENT_MODULE_NAME)
  	self.extBaiPai_cardLayer:init(self.res_base)
  	self.extBaiPai_cardLayer:setRoot(self.node.Node_Ext_BaiPai)

  	self.readyCardCoordinate= import(".ReadyCardCoordinate",CURRENT_MODULE_NAME)

  	self.node.ma_list1:setItemModel(self.node.ma_panel)
  	self.node.ma_list1:hide()
  	if self.node.opt_card_list then
  		self.node.opt_card_list:addEventListener(handler(self,CardLayer.optListEvent))
  		self.node.opt_card_list:setScrollBarEnabled(false)
  		self.node.opt_card_list:hide()
  	end
  	self:setGangPicState(false)

  	self:initLocalZorder()
	 
	self.node["Img_bghu1"]:hide()
	self.node["Img_bghu2"]:hide()
	self.node["Img_bghu3"]:hide()
	self.node["Img_bghu4"]:hide()

	self.node.Node_DrawingCardTip:show()
	self.maskType = {
		normalMask = 1, --普通蒙版
		drawingMask =2,	--听牌蒙版
		shuaipaiMask =3  --甩牌蒙版
	}

  -- 	self.node.hcard_node1:hide()
  -- 	self.node.hcard_node2:hide()
  	-- self.node.hcard_node3:hide()
  -- 	self.node.hcard_node4:hide()
 	-- self.node.Node_Hand_Card:hide()

 	-- self.node.rcard_node1:hide()
  	-- self.node.rcard_node2:hide()
  	-- self.node.rcard_node3:hide()
  	 -- self.node.rcard_node4:hide()
  	 self.node.marker:hide()

  	 local is_match = self.part.owner.match_mode
  	 if is_match then
  	 	for i=1, 4 do
  	 		local ui_offline_icon = self.node['offline_icon' .. i ]
			ui_offline_icon:setVisible(false)
  	 	end
  	 end
end

function CardLayer:setHandsHide()
	if self.node.Node_Hand_Card then
		self.node.Node_Hand_Card:hide()
	end
end

--特殊规则吃碰杠需要继承
function CardLayer:addDownCardLayer()
  	self.down_cardLayer = import(".DownCardLayer",CURRENT_MODULE_NAME)
  	self.down_cardLayer:init(self.res_base)
  	self.down_cardLayer:setRoot(self.node.Node_Down_Card)	
end
--特殊规则吃碰杠需要继承
function CardLayer:showDownCard(viewId,tDownData,index, type)
	if self.down_cardLayer then
	  local downList =self.down_cardLayer:showDownCard(viewId,tDownData,index,type)
	  if downList then 
	  	return downList
	  end
	end
end

--set Z
function CardLayer:initLocalZorder()
	--1:本家2:下家：3：對家4：上家
	--手牌
	local  hZ = 2
	self.node["hcard_node1"]:setLocalZOrder(hZ+999)
	self.node["hcard_node2"]:setLocalZOrder(hZ)
	self.node["hcard_node3"]:setLocalZOrder(hZ)
	self.node["hcard_node4"]:setLocalZOrder(hZ)
	--待摸牌
	self.node["rcard_node1"]:setLocalZOrder(1)
	self.node["rcard_node2"]:setLocalZOrder(0)
	self.node["rcard_node3"]:setLocalZOrder(self.node["hcard_node3"]:getLocalZOrder()+1)
	self.node["rcard_node4"]:setLocalZOrder(0)
	self.node.Node_center:setLocalZOrder(hZ+100)

	self.node.Node_Ext_BaiPai:setLocalZOrder(self.node.Node_center:getLocalZOrder()+2)

	self.node.Node_Hand_Card:setLocalZOrder(self.node.Node_center:getLocalZOrder()-1)

	self.node["efcard_node_hu"]:setLocalZOrder(self.node["ocard_node3"]:getLocalZOrder())

	self.node.opt_card_list:setLocalZOrder(self.node["hcard_node1"]:getLocalZOrder()+1)

	self.node.auto_node:setLocalZOrder(self.node["hcard_node1"]:getLocalZOrder()+1)

	self.node.chi_list:setLocalZOrder(hZ+10000)

	self.node.bao_layer:setLocalZOrder(hZ+1000)

	self.node.bao_select_layer:setLocalZOrder(hZ+1000)

	self.node.Node_DrawingCardTip:setLocalZOrder(hZ+1000)


	-- self.node.marker:setLocalZOrder(hZ+10000)
	--头像部分
	self.node['head_bg1']:setLocalZOrder(hZ+1000)
	self.node['head_bg2']:setLocalZOrder(hZ+1000)
	self.node['head_bg3']:setLocalZOrder(hZ+1000)
	self.node['head_bg4']:setLocalZOrder(hZ+1000)

	self.node.Node_Center_Hu1:setLocalZOrder(self.node.Node_Ext_BaiPai:getLocalZOrder()-1)
	self.node.Node_Center_Hu2:setLocalZOrder(self.node.Node_Ext_BaiPai:getLocalZOrder()+1)
	self.node.Node_Center_Hu3:setLocalZOrder(self.node.Node_Ext_BaiPai:getLocalZOrder()-1)
	self.node.Node_Center_Hu4:setLocalZOrder(self.node.Node_Ext_BaiPai:getLocalZOrder()+1)

	--信息部分
	self.node.txt_remaind_card:setLocalZOrder(hZ+10000)
	self.node.remain_card_icon:setLocalZOrder(hZ+10000)

	self.node.Node_Center_effect:setLocalZOrder(hZ+100000)

	self.node.opt_card_list:setLocalZOrder(hZ+1000001)

	self.node.ma_list2:setLocalZOrder(hZ+100000)

	if self.node.nao_zhuang_cover then
		self.node.nao_zhuang_cover:setLocalZOrder(hZ+1000)
	end

	if self.node.kanpai_cancle_btn then
		self.node.kanpai_cancle_btn:setLocalZOrder(hZ+1001)
	end

	if self.node.kanpai_btn then
		self.node.kanpai_btn:setLocalZOrder(hZ+1001)
	end

  	--添加浮标特效
  	local function addMarkerEffect()
   		local loopAniPath = self.res_base.."/sp/hongsebiao/hongsebiao"
		self.markerAnim = Util.createSpineAnimationLoop(loopAniPath, "1", false)
		self.node.marker:getParent():addChild(self.markerAnim)
		self.markerAnim:setPosition(self.node.marker:getPosition())
  	end
  	addMarkerEffect()

  	self.markerAnim:setLocalZOrder(hZ+10000)
end

--添加头像特效
function CardLayer:showHeadImgEffect(viewId)
	local headEffectName = "headEffect"
	for i=1,4 do
	  	local  headEffect= self.node["head_node"..i]:getChildByName(headEffectName)
	  	if headEffect then
	  		headEffect:hide()
	  	end
	end

	local tbAdujst ={}
	tbAdujst[RoomConfig.MySeat] = {scaleX=1,scaleY=1,x=36.2,y=20}
	tbAdujst[RoomConfig.DownSeat] = {scaleX=1,scaleY=1,x=36.2,y=20}
	tbAdujst[RoomConfig.FrontSeat] = {scaleX=1,scaleY=1,x=36.2,y=20}
	tbAdujst[RoomConfig.UpSeat] = {scaleX=1,scaleY=1,x=36.2,y=20}

	local headEffect =self.node["head_node"..viewId]:getChildByName(headEffectName)
 	if headEffect ==nil then
		local loopAniPath = self.res_base.."/sp/UI_paiju/UI_paiju"
		headEffect  = Util.createSpineAnimationLoop(loopAniPath, "1", false)
		headEffect:setName(headEffectName)
		local head_node=self.node["head_node" .. viewId]
		headEffect:setLocalZOrder(21)
		head_node:addChild(headEffect)
 	end
 	headEffect:setScaleX(tbAdujst[viewId].scaleX)
  	headEffect:setScaleY(tbAdujst[viewId].scaleY)
	headEffect:setPositionX(tbAdujst[viewId].x)
	headEffect:setPositionY(tbAdujst[viewId].y)
 	headEffect:show()
end

--听牌提示功能
--------------------------------------------------------------------------------
function CardLayer:refreshDrawingTip(tingRecord)
	if self.drawingCardTip_cardLayer then
		self.drawingCardTip_cardLayer:updateContentItem(tingRecord)
	end
end

function CardLayer:showDrawingTip(b)
	if self.drawingCardTip_cardLayer then
		self.drawingCardTip_cardLayer:showDrawTip(b)
	end
end

--b:true:牌是立起的
function CardLayer:selectedTingCard(cardvalue,b)
	if self.part then
		self.part:getTingRecordByCardValue(cardvalue,b)
	end
end

function CardLayer:allDrawTipHide()
	if self.drawingCardTip_cardLayer then
		self.drawingCardTip_cardLayer:allDrawTipHide()
	end	
end

function CardLayer:showdrawingCard(filterList)
	self:allDrawTipHide()
	self:filterUpdateMyCardListMask(filterList,self.maskType.drawingMask)
end
function CardLayer:clearTingCardsArrow()
	print("clearTingCardsArrow")
	local myCardList = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	if #myCardList == 0 then return end
	self:updateMyCardMask(myCardList,false,self.maskType.drawingMask)
end
--------------------------------------------------------------------------------

--剩下多少张
function CardLayer:updateLastCardNum(num)
	self.node.txt_remaind_card:setString(tostring(num));
	release_print(os.date("%c") .. "[info] 牌页面展示剩余张数 ", num)
end

function CardLayer:initTableWithData(player_list,data)
	for i,v in ipairs(player_list) do
		if i > 4 then
			return
		else
			self:showPlayer(v)
			print("this is show banker:",v.tablepos,data.dealerpos)
			if v.tablepos == data.dealerpos and not self.part.owner.match_mode then
				self.node["bank_icon" .. v.view_id]:show()
			else
				self.node['bank_icon' .. v.view_id ]:hide()
			end
		end
	end
end

function CardLayer:OneClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(1)
end

function CardLayer:TwoClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(2)
end

function CardLayer:ThreeClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(3)
end

function CardLayer:FourClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(4)
end

function CardLayer:HeadClick(viewId)
	if ISAPPSTORE then
		return
	end

	print("viewID:"..viewId)
	local player_info = self.part:getPlayerInfo(viewId)

	local posX = self.node['head_bg'..viewId]:getPositionX()
	local posY = self.node['head_bg'..viewId]:getPositionY()
	self.part:headClick(player_info , posX , posY , viewId)
	
	--self:optEffect(viewId,RoomConfig.peng)
  	-- self:setLastCardViewPos(viewId)
	-- self:showHuCardSp(viewId,20,0)
end

--更新胡牌推倒
function CardLayer:updatePushOver(handCards,viewId,startIndex)
	if self.pushOverHand_cardLayer and handCards then
	 	self.pushOverHand_cardLayer:updateHandCards(handCards,viewId,startIndex)
	end
end

--根据玩家信息显示玩家
-- view_id 是经过转换的界面位置
function CardLayer:showPlayer(playerInfo)
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 4 then
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		print("playerInfo:"..playerInfo.view_id)
		head_node:show()
		local names = playerInfo.name 		--名字只需要5个字
		name:setString(string.utf8sub(names,1,5))

		local strTag =""
		-- playerInfo.coin = 0
		if playerInfo.coin < 0 then
			strTag="/"
		end 
		local strCoin =strTag..playerInfo.coin
     	if not self.part.owner.match_mode then
     		coin:setString(strCoin)
     	end
		---------------------
		--裁剪模板
		local sprite_floor = cc.Sprite:create(self.res_base .. "/touxiang.png")
		-- local sprite_floor = cc.Sprite:create(self.res_base .. "/pz_jsfj2.png")
    	local clipping_node = cc.ClippingNode:create(sprite_floor)
    	local sprite_floor_size = sprite_floor:getContentSize()
    	----裁剪对象
    	local sprite_head = cc.Sprite:create(self.res_base .. "/default_head.png")
    	local head_size = sprite_head:getContentSize()
    	sprite_head:setScale(sprite_floor_size.width/head_size.width, sprite_floor_size.height/head_size.height)

    	local head_bg_size = head_node:getContentSize()
    	clipping_node:addChild(sprite_head)
    	clipping_node:setAlphaThreshold(0.8)
    	clipping_node:setPosition(cc.p(head_bg_size.width/2,head_bg_size.height/2))
    	head_node:addChild(clipping_node)

		print("---playerInfo.targetPlayerName : ",playerInfo.targetPlayerName)
		print("---playerInfo.headImgUrl : ",playerInfo.headImgUrl)
		if playerInfo.targetPlayerName ~= nil then
			if playerInfo.targetPlayerName and playerInfo.targetPlayerName ~= "" then
				self.part.owner:loadHeadImg(playerInfo.targetPlayerName,sprite_head)
			end
		else 	
			if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
				self.part.owner:loadHeadImg(playerInfo.headImgUrl,sprite_head)
			end
		end

	end
		-- self.node["head_bg1"]:hide()
		-- self.node["head_bg2"]:hide()
		-- self.node["head_bg3"]:hide()
		-- self.node["head_bg4"]:hide()
end

function CardLayer:offlinePlayer(offlinePos,online)
	local is_match = self.part.owner.match_mode
	if is_match then
		return 
	end

	release_print(os.date("%c") .. "[info] 牌页面展示玩家在线状态 ", offlinePos,online)
	if online then
		self.node['offline_icon' .. offlinePos]:hide()
		self.node['offline_frame' .. offlinePos]:hide()
	else
		self.node['offline_icon' .. offlinePos]:show()
		self.node['offline_frame' .. offlinePos]:show()
	end
end

function CardLayer:PengClick()
	release_print(os.date("%c") .. "[info] 牌页面点击碰 ")
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_PENG)
	self:hideOpt()
	self.card_touch_enable = false
end

function CardLayer:GangClick()
	release_print(os.date("%c") .. "[info] 牌页面点击杠 ")
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
	self:hideOpt()
	self.card_touch_enable = false
	self:setGangPicState(false)
end

function CardLayer:GuoClick()
	release_print(os.date("%c") .. "[info] 牌页面点击过 ")
	self.part:requestOpt(RoomConfig.MAHJONG_OPERTAION_CANCEL)
	self:sortHandCard(RoomConfig.MySeat) --放下举起的牌
	self:hideOpt()
	self.card_touch_enable = true
end

function CardLayer:HuClick()
	-- body
end

function CardLayer:ChiClick()
	release_print(os.date("%c") .. "[info] 牌页面点击吃 ")
	self.part:doChiClick()
	self.card_touch_enable = false
end

function CardLayer:hideOpt()
	print("###[CardLayer:hideOpt]self.opt_show ", self.opt_show)
	-- body
	self.opt_show = false
	for i,v in ipairs(self.opt_animate) do 
		v:clearTracks()
		v:removeFromParent()
	end
	self.opt_animate = {}
	self.node.opt_card_list:hide()
	self.node.chi_list:hide()

	self.node.ma_list1:hide() --隐藏掉 杠的单个选择列表
	self.node.ma_list2:hide() --隐藏掉 杠的组合选择列表

	self.node.baoSelect1:hide()
	self.node.baoSelect2:hide()
	print("this is hide opt ---------------------------------------------")
end


--非自己手牌
function CardLayer:refreshOtherCard(viewId,cardList)
	-- body
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	for i,v in ipairs(card_list) do
		v.card_sprite:hide()
	end
	self.hand_cardLayer:resetAllCard()

	self.card_list[RoomConfig.HandCard][viewId] = {}
	for i,v in ipairs(cardList) do
		release_print(os.date("%c") .. "[info] 牌页面展示玩家手牌 ", viewId,i)
		local card = self.hand_cardLayer:showCard(viewId,i)
		local card_panel = {
			card_sprite = card,
			card_value = v,
			card_pos = cc.p(card:getPosition())
		}
		table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	end
end
--[[
function CardLayer:refreshOtherCard(viewId,cardList)
	-- body
	local card_list = self.card_list[RoomConfig.HandCard][viewId]
	for i,v in ipairs(card_list) do
		v.card_sprite:removeSelf()
	end
	self.card_list[RoomConfig.HandCard][viewId] = {}

	local num = #cardList
	local num1 = RoomConfig.HandCardNum-num --#self.card_list[RoomConfig.DownCard][viewId]
	for i,v in ipairs(cardList) do
		local pos = nil
		local card = self.card_factory:createHandCard(viewId,v,true)
		local size = card:getContentSize()
		size.width = size.width - 2
		size.height = size.height +10
		if viewId == RoomConfig.DownSeat then --下家从上往下列牌
			pos = cc.p(0,(num/2-i-1+num1*0.7)*size.height/2)
		elseif viewId == RoomConfig.FrontSeat then --对家从右到左排列
			size.width = size.width/2
			pos =cc.p((num/2-i+0.5+num1*0.7)*size.width,0)
		elseif viewId == RoomConfig.UpSeat then --上家从下到上排列
			pos = cc.p(0,(i-num/2-2-num1*0.7)*size.height/2)
			card:setLocalZOrder(num - i)
		end
		card:setPosition(pos)
		self.node["hcard_node"..viewId]:addChild(card)

		local card_panel = {
			card_sprite = card,
			card_value = v,
			card_pos = cc.p(card:getPosition())
		}

		table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	end
end
--]]
--重新设置手牌
function CardLayer:resetHandCard(viewId,cardList)
		------------删除手牌重新生成手牌数据
	self.card_list[RoomConfig.HandCard][viewId] = {}

	local num = #cardList
	for i,v in ipairs(cardList) do --计算牌的位置
		local pos = nil
		-- local card = self.card_factory:createWithData(viewId,v,true)--self:createHandCard(v.view_id,v.value[i])
		release_print(os.date("%c") .. "[info] 牌页面创建玩家手牌 ", viewId,v)
		local card = self.card_factory:createHandCard(viewId,v,true)--self:createHandCard(v.view_id,v.value[i])

		local size = card:getContentSize()
		size.width = size.width - 2
		-- if v.view_id == RoomConfig.MySeat then --有数据的手牌
		pos = cc.p((i-num/2-1-self.GetCardOffsetX - 0.25)*size.width,50)
		if viewId == RoomConfig.MySeat then
			card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
		end
		-- card:setTag(i) --牌的索引
		card:setTag(v)
		-- card:setPosition(pos)
		self.node["hcard_node"..viewId]:addChild(card)
		local card_panel = {
			card_sprite = card,
			card_value = v, --只有自己的手牌有数据其他的都是nil
			card_pos = cc.p(card:getPosition())
		}
		table.insert(self.card_list[RoomConfig.HandCard][viewId],card_panel)
	end
end

function CardLayer:resetDownCard(viewId,cardList) 
    local card_list = self.card_list[RoomConfig.DownCard][viewId]
	self.card_list[RoomConfig.DownCard][viewId] = {}
	local card_data = {}
	local peng_card_list = {} --碰杠的牌以表结构保存 
	local index = 1
	print("###[CardLayer:resetDownCard]viewId #card_list is ", viewId, #card_list) 
	for i,v in ipairs(cardList) do
		print("###[CardLayer:resetDownCard]viewId  v.type", viewId,  v.type)
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

			local tData = {}
			tData[1] = c1 
			tData[2] = c2
			tData[3] = c3
			tData[4] = c4
			-- local downCard = self.down_cardLayer:showDownCard(viewId,tData,index, v.type)
			release_print(os.date("%c") .. "[info] 牌页面展示杠downCard ", viewId, c1, c2, c3, c4, index, v.type)
			local downCard = self:showDownCard(viewId,tData,index, v.type)		
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
		elseif v.type  == RoomConfig.Peng or v.type == RoomConfig.Chi then --直接使用数据创建三张牌
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
			local downCard =self:showDownCard(viewId,tData,index, v.type)	

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
 

--重置已经出的牌
function CardLayer:resetOutCard(viewId,cardList,isReset)
	release_print(os.date("%c") .. "[info] 牌页面重置已出牌 ", viewId)
	print("this is reset out card:",viewId,#cardList)
	local card_list = self.card_list[RoomConfig.OutCard][viewId]
	for i,v in ipairs(card_list) do
		--v.card_sprite:removeSelf()
		v.card_sprite:hide()
	end
	self.card_list[RoomConfig.OutCard][viewId] = {}

	for i,v in ipairs(cardList) do
		print("this is reset out card:",v)
		self:addDownCard(viewId,v,isReset)
	end
end

--重置自己的手牌和碰杠的牌
function CardLayer:refreshMyCard(hcardList,dcardList,ocardList,value)
	release_print(os.date("%c") .. "[info] 牌页面重置自己的手牌和碰杠的牌 ")
	-- self:removeCurOutCard(RoomConfig.MySeat)
	if self.last_out_card[RoomConfig.MySeat] == nil then --如果出牌动画已经播完
		table.insert(ocardList,value)
	end
	self.node["hcard_node".. RoomConfig.MySeat]:removeAllChildren()
	self:resetDownCard(RoomConfig.MySeat,dcardList)
	self:resetHandCard(RoomConfig.MySeat,hcardList)
	self:resetOutCard(RoomConfig.MySeat,ocardList, true)
    self:sortHandCard(RoomConfig.MySeat)

	--self.node.marker:hide()
	self.markerAnim:hide()
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

	self.node.lefttop_dark_bg2:show()

	if baoCard and self.node.bao1 then
		--[[
		print("refreshBaoCard3")
		local bao1 = bit._and(baoCard,0xff);
		local bao2 = bit._and(bit.rshift(baoCard,8),0xff)
		print("refreshBaoCard4",bao1,bao2)

		local type,value = self.card_factory:decodeValue(bao1)
		local texture_name = string.format("%s/bottom/B_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("bao1Name->",texture_name)

		self.node.bao1:loadTexture(texture_name,1)
		self.node.bao1:show()

		type,value = self.card_factory:decodeValue(bao2)
		texture_name = string.format("%s/bottom/B_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		print("bao2Name->",texture_name)

		self.node.bao2:loadTexture(texture_name,1)
		self.node.bao2:show()
--]]
		local bao1 = bit._and(baoCard,0xff);
		local bao2 = bit._and(bit.rshift(baoCard,8),0xff)
		release_print(os.date("%c") .. "[info] 牌页面展示宝牌 ", bao1, bao2)

		if bao1 > 0 then
			self.node.bao1:show()
			local cardBao1 = self.card_factory:createHandCard(RoomConfig.MySeat,bao1,false)
			cardBao1:setAnchorPoint(cc.p(0.0,0.0))
			self.node.bao1:addChild(cardBao1)
		end

		if bao2 > 0 then
			self.node.bao2:show()
			local cardBao2 = self.card_factory:createHandCard(RoomConfig.MySeat,bao2,false)
			cardBao2:setAnchorPoint(cc.p(0.0,0.0))
			self.node.bao2:addChild(cardBao2)
		end
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

function CardLayer:getCard(value)
	print("getCardgetCard")
	release_print(os.date("%c") .. "[info] 牌页面展示摸到一张牌 ", value)
	-- body
	local card = self.card_factory:createHandCard(RoomConfig.MySeat,value,true) --只有自己有摸牌动作
	local size = card:getContentSize()
	local card_num = #self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]

	local lastHandCardPos = self._mySeatPosList[card_num]		--最后一个手牌的位置

	--[[
	for i=1,card_num do
		local v = card_list[i]
		local pos = self._mySeatPosList[i+card_num1]
		v.card_sprite:setPosition(pos)
		v.card_pos = pos	
	end
	--]]

	local card_num1 = #self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
	--每有吃碰杠一个往右边移动一个牌子宽度
 	local pos_x =lastHandCardPos.x + (1+self.GetCardOffsetX)*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX) +card_num1*(CardLayer.MySeatPerSize.width +CardLayer.MySeatCardSetOffX)
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
	-- self:removeOneReadyCard()
end 

function CardLayer:onTouchBegan(touches,event)
	-- body
	return true
end

function CardLayer:onTouchMoved(touches,event)
	-- body

	local touch_pos = touches:getLocation()
	if self.select_card.card and self.card_touch_enable == true then 
		local node_pos = self.node.hcard_node1:convertToNodeSpace(touch_pos)
		self.select_card.card:setPosition(node_pos)
		self.select_card.stand = false
	end
end

function CardLayer:onTouchEnded(touches,event)
	-- body
	local touch_pos = touches:getLocation()
	print("CardLayer:onTouchEnded--touch_pos=")
	-- SZXX_Util.gTablePrint(touch_pos)
	print("CardLayer:onTouchEnded--self.out_line=", self.out_line)
	if self.select_card.card then
		if touch_pos.y > self.out_line then
			release_print(os.date("%c") .. "[info] 牌页面拖牌超过线，请求出牌 ", self.select_card.card:getTag())
			self.card_touch_enable = false
			self.select_card_pos = cc.p(self.select_card.card:getPosition())
			self:selectedTingCard(self.select_card.card:getTag(),false)
			self:updateAllwanceMask(self.select_card.card:getTag()) 
			self.part:requestOutCard(self.select_card.card:getTag())
			self.select_card.card:hide()
			self.select_card = {}
			self:hideOpt()
		elseif self.select_card.stand == false then --选择的牌要提起
			local content_size = self.select_card.card:getContentSize()
			local pos = cc.pAdd(self.select_card.pos,cc.p(0,content_size.height*self.StandCardOffset))
			self.select_card.card:setPosition(pos)
			self.select_card.card:setLocalZOrder(0)
			self.select_card.stand = true
			self:selectedTingCard(self.select_card.card:getTag(),true)
			self:updateAllwanceMask(self.select_card.card:getTag()) 
		elseif self.select_card.stand == true then
			release_print(os.date("%c") .. "[info] 牌页面双击，请求出牌 ", self.select_card.card:getTag())
			self.card_touch_enable = false
			self.select_card_pos = cc.p(self.select_card.card:getPosition())
			-- self:selectedTingCard(self.select_card.card:getTag())
			self:updateAllwanceMask(self.select_card.card:getTag()) 
			self.part:requestOutCard(self.select_card.card:getTag())
			self.select_card.card:hide()
			self.select_card = {}
			self:hideOpt()
		end 
	end
end


-- 展示出牌的动画
-- function CardLayer:outCard(viewId,value)
-- 	self:hideDrawHandCard()

-- 	print("###[CardLayer:outCard]展示出牌的动画viewId   value ",viewId,value)
-- 	-- body @Deek 2.5D效过，出牌飞出动作
--  	local card = self.card_factory:createHandCard(RoomConfig.MySeat,value) --出牌的牌 是用自己的牌的大小来显示的

-- 	local sex = self.part:getPlayerInfo(viewId).sex
--  	local card_type,card_value = self.card_factory:decodeValue(value)
--  	self:playCardEffect(card_type, card_value, sex)

-- 	-- @Deek 每出一张牌, 移除一张底牌, 目前其他三家这样处理
-- 	if viewId ~= RoomConfig.MySeat then
-- 	   --self:removeOneReadyCard()
-- 	end

--  	-- self.node["hcard_node" .. viewId]:addChild(card)
--  	self.node.Node_Center_effect:getParent():addChild(card)
--  	card:setLocalZOrder(self.node.Node_Center_effect:getLocalZOrder()-1)

--  	-- self:addChild(card)
--  	local content_size = card:getContentSize()
-- 	local pos = cc.p(self.node['hcard_node' .. viewId]:getPosition())
-- 	card:setPosition(pos)

-- 	content_size.width = content_size.width - 5; -- @Deek 2.5D效果, 减小出牌间距
	
-- 	if viewId == RoomConfig.MySeat then --结束时最后一张牌
-- 		if self.select_card_pos then
-- 			pos = clone(self.select_card_pos)
-- 			pos = self.node["hcard_node" .. viewId]:convertToWorldSpace(pos)
-- 			card:setPosition(pos)
-- 			self.select_card_pos = nil
-- 		end
-- 		pos = cc.p(0,content_size.height*self.OutCardOffset)
-- 	elseif viewId == RoomConfig.DownSeat then
-- 		pos = cc.p(-content_size.width*CardLayer.OutCardOffset,0)
-- 	elseif viewId == RoomConfig.FrontSeat then
-- 		pos =cc.p(0,-content_size.height*CardLayer.OutCardOffset/2)
-- 	elseif viewId == RoomConfig.UpSeat then
-- 		pos = cc.p(content_size.width*CardLayer.OutCardOffset,0)
-- 	end
-- 	pos = self.node["hcard_node" .. viewId]:convertToWorldSpace(pos)
-- 	local actions = {
-- 						cc.Spawn:create(cc.MoveTo:create(CardLayer.OutCardTime,pos),cc.ScaleTo:create(CardLayer.OutCardTime+CardLayer.ShowCardTime,1)),
-- 					}
-- 	local seq = transition.sequence(actions)
-- 	self:removeCurOutCard(viewId)
-- 	self.last_out_card[viewId] = card
-- 	transition.execute(card,seq,{removeSelf= false,onComplete=function()
-- 		-- body
-- 		if RoomConfig.Ai_Debug then
-- 			local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
-- 			if ai_mod:checkPengGang() == false then
-- 				ai_mod:turnSeat()
-- 			end
-- 		else
-- 			self:addOutCard(viewId,value)
-- 		end
-- 	end})

-- end

function CardLayer:outCard(viewId,value)
	self:hideDrawHandCard()

	print("###[CardLayer:outCard]展示出牌的动画viewId   value ",viewId,value)
	release_print(os.date("%c") .. "[info] 展示出牌的动画 ", viewId,value)
	-- body @Deek 2.5D效过，出牌飞出动作
 	local card = self.card_factory:createHandCard(RoomConfig.MySeat,value) --出牌的牌 是用自己的牌的大小来显示的

	local sex = self.part:getPlayerInfo(viewId).sex
 	local card_type,card_value = self.card_factory:decodeValue(value)
 	self:playCardEffect(card_type, card_value, sex)

	if viewId == RoomConfig.MySeat then
		print("outCard")
		print("内容不显示灯泡显示")
		if self.part then
			self.part:showDrawingTip(false)
		end
	end
	self:delAllwanceMask()
 	-- self.node["hcard_node" .. viewId]:addChild(card)
 	self.node.Node_Center_effect:getParent():addChild(card)
 	card:setLocalZOrder(self.node.Node_Center_effect:getLocalZOrder()-1)

 	-- self:addChild(card)
 	local content_size = card:getContentSize()
	local pos = cc.p(self.node['hcard_node' .. viewId]:getPosition())
	card:setPosition(pos)

	content_size.width = content_size.width - 5; -- @Deek 2.5D效果, 减小出牌间距
	
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
	-- local actions = {
	-- 					cc.Spawn:create(cc.MoveTo:create(CardLayer.OutCardTime,pos),cc.ScaleTo:create(CardLayer.OutCardTime+CardLayer.ShowCardTime,1)),
	-- 				}
	-- local seq = transition.sequence(actions)
	self:removeCurOutCard(viewId)
	self.last_out_card[viewId] = card
	-- transition.execute(card,seq,{removeSelf= false,onComplete=function()
		-- body
		if RoomConfig.Ai_Debug then
			local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
			if ai_mod:checkPengGang() == false then
				ai_mod:turnSeat()
			end
		else
			self:addOutCard(viewId,value)
		end
	-- end})

end


--viewId最后出手的人
function CardLayer:setLastCardViewPos(viewId)
	self:hideDrawHandCard()
	local pos = nil
	local card_list = self.card_list[RoomConfig.OutCard][viewId] or {}
	local card_num = #card_list 
	if 	card_list[card_num] ~= nil and card_list[card_num].card_sprite then
		pos = cc.p(card_list[card_num].card_sprite:getPosition())
		--local anim = Util.createSpineAnimation(self.res_base .. "/room/resource/sp/hu_nahui/Hu_nahui", "1", false)
		local anim = Util.createSpineAnimation(self.res_base .. "/sp/hu_daji/Hu_daji", "1", false)
		anim :setPosition(pos)

		pos = self.out_cardLayer:getShowOutHuCardWordPos(viewId,card_list[card_num].card_sprite)
		anim:setPosition(pos)
		self:addChild(anim,21)

		-- card_list[card_num].card_sprite:getParent():addChild(anim ,21) 


		local time_entry = nil
		time_entry = self:schedulerFunc(function()
		   		if time_entry ~= nil and time_entry ~= -1 then
		   			self:unScheduler(time_entry)
		   		end
		   		print("updatTimeupdatTimeupdatTimeupdatTimeupdatTime")
		   		--self.node.marker:hide()
		   		self.markerAnim:hide()
		   		--if anim  then
		   			--anim:hide()
		   		--end
		  		--card_list[card_num].card_sprite:removeSelf()
		  		card_list[card_num].card_sprite:hide()

		   end,1,false)

	end
end

--viewId:最后出牌的人,要胡的牌
function CardLayer:showHuCardSp(viewId,value,t)

	self.img_bghu = self.node["Img_bghu"..viewId]
	local time_entry = nil
	time_entry = self:schedulerFunc(function()
		if time_entry ~= nil and time_entry ~= -1 then
		   	self:unScheduler(time_entry)
		end
	local anim = Util.createSpineAnimation(self.res_base .. "/sp/hu_nahui/Hu_nahui", "1", false)
	anim:setAnchorPoint(cc.p(0.5,0.5))
	local pos =cc.p(self.img_bghu:getPosition())
	anim:setPosition(pos)
	self.img_bghu:getParent():addChild(anim,21)
	self.img_bghu:show()
	end,t,false)

	local huImg = self.node["Img_hu"..viewId]
	local card_type,card_value = self.card_factory:decodeValue(value)
	self:updateCardViewId(viewId,huImg,card_value,card_type)
end

--移除当前出的牌
function CardLayer:removeCurOutCard(viewId)
	release_print(os.date("%c") .. "[info] 移除当前出的牌 ", viewId)
	if self.last_out_card[viewId] ~= nil then
		self.last_out_card[viewId]:stopAllActions()
		self.last_out_card[viewId]:removeSelf()
		self.last_out_card[viewId] = nil
	end
end

function CardLayer:showMyCardMask(b)
   	local myCardList = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
   	self:updateMyCardMask(myCardList,b,self.maskType.normalMask)	
end
function CardLayer:turnSeat(viewId)
	-- body
	self.select_card = {}
	-- self:hideOpt()
	print("this is turnSeat -------------------------viewId opt_show :",viewId, self.opt_show)
	if viewId == RoomConfig.MySeat then --轮到自己操作才能操作牌
	    self.card_touch_enable = true
	    self:hideDrawHandCard()
	    -- self:showMyCardMask(false)
	else
	    self.card_touch_enable = false
	    self:hideOpt()
        --其他3家摸牌显示
	    local index = #self.card_list[RoomConfig.HandCard][viewId]
	    if index > 0 then
		    print("self.card_list[RoomConfig.HandCard]index"..index)
		    -- print("viewId:",viewId)
		    self.hand_cardLayer:showDrawHandCard(viewId,index)
	    end
	    -- self:showMyCardMask(true)
	end
	self:showHeadImgEffect(viewId)

end

function CardLayer:hideDrawHandCard()
	self.hand_cardLayer:hideCurrentDrawCard()
end

--加入一个操作显示
function CardLayer:showAddOpt(optList)
	print("###[CardLayer:showAddOpt] optList self.opt_show ", self.opt_show)
	dump(optList)
 -- bod
	self.opt_list = optList 
	for i,v in ipairs(self.opt_animate) do 
		v:clearTracks()
		v:removeFromParent()
	end
	self.opt_animate = {}
	self.node.opt_card_list:removeAllChildren()


	self.node.opt_card_list:setItemModel(self.node.opt_card_panel)
	self.node.opt_card_list:show()
	local loopAniPath = self.res_base.."/sp/zi_anniu/ZI_anniu"

	

   for i,v in ipairs(optList) do
	  self.node.opt_card_list:insertDefaultItem(i-1)
	  local item = self.node.opt_card_list:getItem(i-1)
	  local opt_btn = item:getChildByName("opt_btn")
	  -- local pic_name = ""
	  local anim = nil
	  if v == RoomConfig.MAHJONG_OPERTAION_CANCEL then
	    -- pic_name = "cancel_bt.png"
	    release_print(os.date("%c") .. "[info] 牌页面展示过操作 ")
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "guo_anniu", false)

	  elseif v == RoomConfig.MAHJONG_OPERTAION_CHI then
	   -- pic_name = "chi.png" -- 目前吃暂时没动画
	   	release_print(os.date("%c") .. "[info] 牌页面展示吃操作 ")
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "chi_anniu", false)
	  elseif v == RoomConfig.MAHJONG_OPERTAION_PENG then
	   -- pic_name = "peng_bt.png"
	   	release_print(os.date("%c") .. "[info] 牌页面展示碰操作 ")
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "peng_anniu", false)
	  elseif v == RoomConfig.MAHJONG_OPERTAION_AN_GANG or v == RoomConfig.MAHJONG_OPERTAION_MING_GANG or v == RoomConfig.Gang then
	   -- pic_name = "gang_bt.png"
	   	release_print(os.date("%c") .. "[info] 牌页面展示杠操作 ")
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "Gang_anniu", false)
	  elseif v == RoomConfig.MAHJONG_OPERTAION_HU then
	   -- pic_name = "hu.png"
	   	release_print(os.date("%c") .. "[info] 牌页面展示胡操作 ")
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "hu_anniu", false)
	  elseif v == RoomConfig.PLAYER_OPERATION_BAIPAI then
	  	release_print(os.date("%c") .. "[info] 牌页面展示摆操作 ") 
	  	anim = Util.createSpineAnimationLoop(loopAniPath, "bai_anniu", false)
	  end

	if(anim ~= nil) then
	    item:addChild(anim)
	    table.insert(self.opt_animate,anim)
	    local itemSize = item:getContentSize()
	    anim:setPosition(cc.p(itemSize.width / 2, itemSize.height / 2))
	    opt_btn:hide()
	    item:setScale(1.2)
	end
	self.opt_show = true
 end
 print("###[CardLayer:showAddOpt]2 optList self.opt_show ", self.opt_show) 
 self.node.opt_card_list:forceDoLayout()
 self.node.opt_card_list:jumpToPercentHorizontal(100)
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

		--点过之后，客户端本地不会收到对应的消息 所以本地去掉蒙版
		if RoomConfig.MAHJONG_OPERTAION_CANCEL     			== self.opt_list[cur_select + 1] 
			or RoomConfig.MAHJONG_OPERTAION_CHI    	   			== self.opt_list[cur_select + 1]
			or RoomConfig.MAHJONG_OPERTAION_PENG       			== self.opt_list[cur_select + 1]
			or RoomConfig.MAHJONG_OPERTAION_AN_GANG    			== self.opt_list[cur_select + 1]
			or RoomConfig.MAHJONG_OPERTAION_MING_GANG  			== self.opt_list[cur_select + 1]
			or RoomConfig.Gang    					   			== self.opt_list[cur_select + 1] 
		then
			self:showMyCardMask(false)
		end

		if RoomConfig.MAHJONG_OPERTAION_CANCEL== self.opt_list[cur_select + 1]  then
			if self.resetShuaiPaiScript then
				self:resetShuaiPaiScript()
			end
		end

		--碰之后有可能从听到不听的情况（7对子）
		if RoomConfig.MAHJONG_OPERTAION_PENG== self.opt_list[cur_select + 1]  then
			self.part:clearTinglisandAllDrawTipHide()
		end

		self.part:optClick(self.opt_list[cur_select + 1])
		self.opt_list = nil
	end
end

function CardLayer:optListItemEvent(ref,event)
	print("--------optListItemEvent event :",event)
	if event == 0 or event == 1 then
		local actions = {
		                    cc.ScaleTo:create(0.01,1.3),
		                 }
		local seq = transition.sequence(actions)
		    transition.execute(self.cur_item , seq)
	elseif event == 2 or event == 3 then --按钮下touchend事件
		local actions = {
		                    cc.ScaleTo:create(0.01,1.2),
		                 }
		local seq = transition.sequence(actions)
		    transition.execute(self.cur_item , seq)
	end
end

--玩家牌被吃碰了移除最后出的牌
function CardLayer:removeLastCard(lastOpt,value)
	release_print(os.date("%c") .. "[info] 玩家牌被吃碰了移除最后出的牌 ",lastOpt,value)
	if self.last_out_card[lastOpt] then
		self:removeCurOutCard(lastOpt)
	end
    local opt_card =  bit._and(value,0xff)
    local out_card = self.card_list[RoomConfig.OutCard][lastOpt]
    local out_card_size = #out_card
    for i=out_card_size,1,-1 do
    	if out_card[i].card_value == opt_card then
			--out_card[i].card_sprite:removeSelf()
			out_card[i].card_sprite:hide()
			table.remove(out_card,i)
			break
		end
    end
end

function CardLayer:showHuAnimate(viewId,maList,huType)
	local node,pos = self:getOptPos(viewId)
	local anim = nil
	--自摸效果
	print("showHuAnimate------------------------"..huType)
	if huType == 1 then
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "zimo_xiaoguo", false)
	else--胡牌
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "hu_xiaoguo", false)
	end

	anim:setPosition(pos)
	anim:setLocalZOrder(6)
	node:addChild(anim)

	--播放胡的音效
	local sex = self.part:getPlayerInfo(viewId).sex
	local seat_id = self.part:getPlayerInfo(viewId).seat_id
	self:playOperateEffect(RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED,sex,seat_id)

end

--播发操作动画特效
function CardLayer:optEffect(viewId,type)
	-- body
	print("type------------------------------------:"..type)
	local xiaogouZorder= 100
	local node,pos = self:getOptPos(viewId)
	local anim = nil
	if type == RoomConfig.Chi then
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "chi_xiaoguo", false)
    --elseif type == RoomConfig.MingGang or type == RoomConfig.AnGang or type == RoomConfig.Gang then
    elseif type == RoomConfig.MingGang then
    	anim = Util.createSpineAnimation(self.res_base .. "/sp/guafeng/Guafeng", "1", false)
    	local gangAni = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false)
  		gangAni:setPosition(pos)
		gangAni:setLocalZOrder(6)
		node:addChild(gangAni)

    elseif type == RoomConfig.AnGang then
    	anim = Util.createSpineAnimation(self.res_base .. "/sp/xiayu/Xiayu", "1", false)
       	local gangAni = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false)
  		gangAni:setPosition(pos)
		gangAni:setLocalZOrder(6)
		node:addChild(gangAni)

    elseif type ==RoomConfig.Gang then
    	anim = Util.createSpineAnimation(self.res_base .. "/sp/guafeng/Guafeng", "1", false)
    	local gangAni = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false)
  		gangAni:setPosition(pos)
		gangAni:setLocalZOrder(6)
		node:addChild(gangAni)

	elseif type == RoomConfig.Peng then
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "peng_xiaoguo", false)

	elseif type == RoomConfig.PLAYER_OPERATION_BAIPAI then
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "bai_xiaoguo", false)

	elseif type == RoomConfig.LaiziGang then
		print("播放赖子杠效果")
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false) 
		
	elseif type == RoomConfig.PiziGang then
		print("播放痞子杠效果")
		anim = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false) 

	else--补杠服务器和客户端不对应  TODO
	    anim = Util.createSpineAnimation(self.res_base .. "/sp/guafeng/Guafeng", "1", false)
    	local gangAni = Util.createSpineAnimation(self.res_base .. "/sp/zi_xiaoguo/ZI_xiaoguo", "gang_xiaoguo", false)
  		gangAni:setPosition(pos)
		gangAni:setLocalZOrder(6)
		node:addChild(gangAni)	
	end

	anim:setPosition(pos)
	anim:setLocalZOrder(5)
	node:addChild(anim)
end

--玩家吃,碰,杠
--value= {mcard={2,3},ocard = 1}
-- isreset 是否有音效，断线重连没有音效
function CardLayer:optCard(viewId,type,value,lastOpt,isreset)
	-- 删除吃碰杠的牌
	print("###[CardLayer:optCard]this is optCard:",viewId,type,value,lastOpt)
	-- dump(value)
	self.card_touch_enable = false
	local card_list =self.card_list[RoomConfig.HandCard][viewId]
	local card_size = #self.card_list[RoomConfig.HandCard][viewId] 
	if viewId == RoomConfig.MySeat then --自己的牌需要根据数据删除。其他人的牌就随便删除两-三张 
		for j,v in ipairs(value.mcard) do
			for i=card_size,1,-1 do
				local del_card =v
				
				if del_card == RoomConfig.EmptyCard then --暗杠需要根据第四张牌的值判断删除那些牌
					del_card = value.mcard[4] or RoomConfig.EmptyCard
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
				-- card_list[i].card_sprite:removeSelf()
				card_list[i].card_sprite:hide()
				table.remove(card_list,i)
			end
		end
	end

--创建吃碰杠的牌 基于手牌的位置偏移
	local card_list1 = self.card_list[RoomConfig.DownCard][viewId]
	local card_num1 = #card_list1
	local down_card = {}
	for i,v in ipairs(value.mcard) do
		down_card[i] = v
	end
	print("this is opt card:",type,card_num1,#down_card)

	if value.ocard then --从别处吃碰杠的牌
		table.insert(down_card,1,value.ocard)
	end

	local peng_card_list = {} --碰杠的牌以表结构保存

	local tData ={} 			--新的吃碰杠结构

	for i,v in ipairs(down_card) do
		if type == RoomConfig.BuGang then
			local downIndex = 1
			for k,j in ipairs(card_list1) do
				print("this is room config bugang:",j.card_value.mcard[1],v,j.card_sprite[2]:getPositionX())
				if j.card_value.mcard[1] == v then --补杠只需要创建一张牌
					tData[1] = v
					local index = k					--第几对
					-- local  downList=self.down_cardLayer:showDownCard(viewId,tData,index,type)
					release_print(os.date("%c") .. "[info] CLOC 展示补杠的牌 ",viewId,tData[1],index,type)
					local  downList=self:showDownCard(viewId,tData,index,type)

					local  card= downList[1]
					table.insert(j.card_sprite,card)  -- 原有的碰牌插入相同的牌（补杠）
					break
				end
			end
		else--非补杠
			tData[i] = v
		end
	end

	if type ~= RoomConfig.BuGang then --补杠不需要创建新的牌堆

		local index = card_num1 + 1
		-- local  downList=self.down_cardLayer:showDownCard(viewId,tData,index,type)
		release_print(os.date("%c") .. "[info] CLOC 展示吃碰杠的牌 ",viewId,tData[1],tData[2],tData[3],tData[4],index,type)
		local  downList=self:showDownCard(viewId,tData,index,type)
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
end
 

function CardLayer:touchCardEvent(touch,event)
	--甩牌玩法，甩的牌不允许出
	local shuaiTag = touch:getChildByTag(1)
	if shuaiTag and shuaiTag:isVisible() then
		return
	end

	print("This is touch card event  card_touch_enable :",self.select_card.card, self.card_touch_enable)
	if self.card_touch_enable == false then
		self.select_card = {}
		--return
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

	elseif event == 2 then

	end
end

--[[
每摸一张牌, 删除一张底牌
--]]
function CardLayer:removeOneReadyCard()
   local majorViewId = self.majorViewId

   local viewIdSeq = nil

   if(majorViewId == RoomConfig.MySeat) then
      viewIdSeq = {RoomConfig.MySeat,RoomConfig.UpSeat,RoomConfig.FrontSeat,RoomConfig.DownSeat}
   elseif(majorViewId == RoomConfig.DownSeat) then
      viewIdSeq = {RoomConfig.DownSeat,RoomConfig.MySeat, RoomConfig.UpSeat,RoomConfig.FrontSeat}
   elseif(majorViewId == RoomConfig.FrontSeat) then
       viewIdSeq = {RoomConfig.FrontSeat,RoomConfig.DownSeat,RoomConfig.MySeat,RoomConfig.UpSeat}
   else -- RoomConfig.UpSeat
	   viewIdSeq = {RoomConfig.UpSeat,RoomConfig.FrontSeat, RoomConfig.DownSeat, RoomConfig.MySeat}
   end

   for _, seat in ipairs(viewIdSeq) do
       local rcard_list = self.card_list[RoomConfig.ReadyCard][seat]
	   if(#rcard_list > 0) then
		   local couple = rcard_list[1].card_sprite
		   local wifeSprite = couple:getChildByTag(couple:getTag() * 10)
		   if(wifeSprite ~= nil) then
			   wifeSprite:removeFromParent()
		   else
			   couple:removeFromParent()
			   table.remove(rcard_list, 1)
		   end
		   break
	   end
   end
end

function CardLayer:removeReadyCardByNum(num)
	for i=1,num do
		self:removeOneReadyCard()
	end
end

--断线重连需要删除的待摸牌
function CardLayer:removeReadyCPG()

	-- table.insert(peng_card_list,card1)
	-- table.insert(peng_card_list,card2)
	-- table.insert(peng_card_list,card3)
	-- table.insert(peng_card_list,card4)
	-- table.insert(self.card_list[RoomConfig.DownCard][viewId],{card_sprite=peng_card_list,card_value=card_data})

	-- local num = 0 
	-- local mySeatDown =self.card_list[RoomConfig.DownCard][RoomConfig.MySeat]
	-- local downSeatDown =self.card_list[RoomConfig.DownCard][RoomConfig.DownSeat]
	-- local frontSeatDown =self.card_list[RoomConfig.DownCard][RoomConfig.FrontSeat]
	-- local upSeatDown =self.card_list[RoomConfig.DownCard][RoomConfig.UpSeat]


	-- for k,v in pairs(mySeatDown) do
	-- 	num = num + #v.card_sprite
	-- end
	-- for k,v in pairs(downSeatDown) do
	-- 	num = num + #v.card_sprite
	-- end
	-- for k,v in pairs(frontSeatDown) do
	-- 	num = num + #v.card_sprite
	-- 	dump(v.cardValue)
	-- end

	-- -- dump(upSeatDown)
	-- for k,v in pairs(upSeatDown) do
	-- 	num = num + #v.card_sprite
	-- end

	-- print("num:........"..num)
	-- self:removeReadyCardByNum(num)
end

--[[
游戏开始创建待摸牌
--]]
function CardLayer:createReadyCard(data, totalCards)
	-- body
	local lastPos = nil;
    local couples = math.floor( (totalCards / 4) / 2 )

    print("couples---------------:"..couples)
	print("totalCards---------------:"..totalCards)

    local yoffsetLR = 12;
	local xoffsetLR = -3;
	local yoffsetBT = 17;
	
	for i,v in ipairs(data) do
		local rcard_node = self.node["rcard_node" .. v.view_id];

		local content_pos = cc.p(rcard_node:getPosition())

		local rcard_list = self.card_list[RoomConfig.ReadyCard][v.view_id]
		print("rcard_list is ")
		-- dump(rcard_list)
		print("v.view_id is ", v.view_id)
		-- dump(self.card_list[RoomConfig.ReadyCard])
		for j=1,couples do --计算牌的位置
			local pos = {}

			local card = self.card_factory:createReadyCard(v.view_id,false)--self:createHandCard(v.view_id,v.value[i])
			local card2 = self.card_factory:createReadyCard(v.view_id, true) -- 上方的牌作为子节点

            card:setTag(j)
            card2:setTag(j * 10);
			card:addChild(card2);

			local size = card:getContentSize()
			size.width = size.width
            local pos2 = cc.p(size.width / 2, size.height / 2);

			if v.view_id == RoomConfig.MySeat then --有数据的手牌
				-- pos = cc.p((j-couples/2-1)*size.width,0)
				pos = cc.p((couples/2-j)*size.width,0)
				-- card:setTag(i) --牌的索引
				self.out_line = content_pos.y + size.height/2
                pos2 = cc.pAdd(pos2, cc.p(0, yoffsetBT));

			elseif v.view_id == RoomConfig.DownSeat then --下家从上往下列牌
				local TopMarginX = 6  --上面牌子相对下面牌子的偏移量
				local TopMarginY = 15 --上面牌子相对下面牌子的Y偏移量
                local perScale = 0.02 --单位缩放因子
                local scale = 1-(couples*perScale)+j*perScale
				-- pos = cc.p(size.width*(j-1)*0.09+margiXtb[j],(couples/2-j-1)*(size.height/2+6.8)+marginY)
				-- pos = cc.p(poxs[j],poys[j])
				local downPos =self.readyCardCoordinate:getDownPos(j,couples)
				pos = cc.p(downPos.x,downPos.y)
				card:setLocalZOrder(j)
				card:setScale(scale)
				pos2 = cc.pAdd(pos2, cc.p(TopMarginX, TopMarginY))

			elseif v.view_id == RoomConfig.FrontSeat then --对家从右到左排列
				local  frontSeatMarginY = -20
				size.width = size.width - 2
				pos =cc.p((j-couples/2-1+0.365)*(size.width - 1),frontSeatMarginY) -- 2.5D效果, Y坐标偏移
				-- pos =cc.p((couples/2-j+0.365)*(size.width - 1),frontSeatMarginY) -- 2.5D效果, Y坐标偏移
                pos2 = cc.pAdd(pos2, cc.p(0, yoffsetBT));
			elseif v.view_id == RoomConfig.UpSeat then --上家从下到上排列
				local size = card:getContentSize()
    			local perScale = 0.02 --单位缩放因子
				print("size:width:============="..size.width)
				local TopMarginX = -6 --上面牌子相对下面牌子的偏移量
				local TopMarginY = 16 --上面牌子相对下面牌子的Y偏移量
				-- local marginY = (j-1)*(j-1)*perScale*18	 	--缩放后需要调整的每列间隙
				-- pos = cc.p(size.width*(j-1)*0.078,(j-couples/2-1)*(size.height/2+7)-marginY)
				local upPos =self.readyCardCoordinate:getUpPos(j,couples)
				pos = cc.p(upPos.x,upPos.y)

				card:setScale(1-perScale*(j-1))
				pos2 = cc.pAdd(pos2, cc.p(TopMarginX, TopMarginY));
				card:setLocalZOrder(couples - j)
			end

			card:setPosition(pos)
            card2:setPosition(pos2);
			
			rcard_node:addChild(card)
			

			local card_panel = {
				card_sprite = card,
				card_value = nil, --只有自己的手牌有数据其他的都是nil
				card_pos = cc.p(card:getPosition())
			}

			table.insert(rcard_list,card_panel)
		end
		-- if v.value[v.num + 1] then
		-- 	self:getCard(v.value[v.num + 1])
		--end
	end
end

--余量更新
function CardLayer:updateAllwanceMask(value)
	if not self.out_cardLayer then return end
 	self.out_cardLayer:updateAllwanceMask(value)
 	if not self.down_cardLayer then return end
 	self.down_cardLayer:updateAllwanceMask(value)
end
--余量消失
function CardLayer:delAllwanceMask()
	if not self.out_cardLayer then return end
 	self.out_cardLayer:delAllwanceMask()
	if not self.down_cardLayer then return end
 	self.down_cardLayer:delAllwanceMask()
end
--更新自己手牌的蒙版
function CardLayer:updateMyCardMask(myCardList,b,maskType)
	print("normalMask.:"..self.maskType.normalMask)
	print("drawingMask:"..self.maskType.drawingMask)
	local maskNameTb = {}	--对应的标识节点名
	maskNameTb[self.maskType.normalMask] = "normalMask"
	maskNameTb[self.maskType.drawingMask] = "drawingMask"
	maskNameTb[self.maskType.shuaipaiMask] = "shuaipaiMask"

	local cardMaskName = maskNameTb[maskType] or "normalMask"
	local shuaipaiMaskName = "shuaipaiMask"

	local maskResTb = {}	--对应的标识路径
	maskResTb[self.maskType.normalMask] = "/mj_azz_01.png"--蒙版
	maskResTb[self.maskType.drawingMask] = "/arrow.png" --听牌箭头
	maskNameTb[self.maskType.shuaipaiMask] = "/mj_azz_01.png"
	local resName = maskResTb[maskType] or "/mj_azz_01.png"

	if #myCardList == 0 then return end
	if b then
		for k,v in pairs(myCardList) do
			local cardMask = v.card_sprite:getChildByName(cardMaskName)
			if cardMask ==nil then
					cardMask = ccui.ImageView:create()
					cardMask:setAnchorPoint(cc.p(0,0))

					cardMask:loadTexture(self.res_base..resName)
					if maskType == self.maskType.drawingMask then
						local x = (v.card_sprite:getContentSize().width-cardMask:getContentSize().width)/2
						local y = v.card_sprite:getContentSize().height
						cardMask:setPosition(cc.p(x,y))
					end
					cardMask:setName(cardMaskName)
					v.card_sprite:addChild(cardMask,20)
			end
			cardMask:show()

			if cardMaskName == "normalMask" then
				local shuaipaiMask = v.card_sprite:getChildByName(shuaipaiMaskName)
				if shuaipaiMask then
					shuaipaiMask:hide()
				end
			end
		end
	else
		for k,v in pairs(myCardList) do
			local cardMask = v.card_sprite:getChildByName(cardMaskName)
			if cardMask ~=nil then
			   cardMask:hide()
			end

			if cardMaskName == "normalMask" then
				local shuaipaiMask = v.card_sprite:getChildByName(shuaipaiMaskName)
				if shuaipaiMask then
					shuaipaiMask:hide()
				end
			end
		end
	end
end

--过滤显示对应手牌标识的类型
function CardLayer:filterUpdateMyCardListMask(filterCardList,maskType)
	dump(filterCardList)
	local myCardList = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	if #myCardList == 0 or #filterCardList==0 then return end
	self:updateMyCardMask(myCardList,false,maskType)

	local inCardsCardList= {}
	for k,v in pairs(filterCardList) do
		for kh,vh in pairs(myCardList) do
			local valueCard = vh.card_value 
			-- print("valueCard:",valueCard)
			if valueCard == v then
				 local  tb = {}
				 tb.card_sprite = vh.card_sprite
				 tb.valueCard = valueCard
				 table.insert(inCardsCardList,tb)
			end
		end
	end
	self:updateMyCardMask(inCardsCardList,true,maskType)	
end

--可碰牌的時候亮牌功能
--tbDownCards:碰杠值类型列表值
function CardLayer:downUpateMyCardMask(tbDownCards)
	-- --杠可能有存在列表的情况下（多种杠选择）
	local myCardList = self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]
	if #myCardList == 0 or #tbDownCards==0 then return end
	self:updateMyCardMask(myCardList,true,maskType)

	local inCardsCardList= {}
	for k,v in pairs(tbDownCards) do
		for kh,vh in pairs(myCardList) do
			local valueCard = vh.card_value 
			-- print("valueCard:",valueCard)
			if valueCard == v then
				 local  tb = {}
				 tb.card_sprite = vh.card_sprite
				 tb.valueCard = valueCard
				 table.insert(inCardsCardList,tb)
			end
		end
	end
	self:updateMyCardMask(inCardsCardList,false,maskType)	
end

--自己手牌的位置列表3.0 13个牌(可调多次不影响)
function CardLayer:initMySeatCardPosList(sizes)
	if not sizes then
		return
	end
	local sizeWidth = sizes.width +CardLayer.MySeatCardSetOffX 	--手牌单位大小
	print("handCardNum--size------------:"..sizeWidth)
	self._mySeatPosList = {}
	local handCardNum = RoomConfig.HandCardNum + 1
	print("handCardNum--------------:"..handCardNum)
	for i=1,handCardNum do
		local start_pos_x = (-self.GetCardOffsetX-RoomConfig.HandCardNum/2)*sizeWidth --起始点位置
		local pos = cc.p(start_pos_x +(i-1)*sizeWidth,CardLayer.MySeatCardSetOffY)
		table.insert(self._mySeatPosList,pos)
	end
end

function CardLayer:createCardWithData(data)
	print("createCardWithData")
	-- self:removeOneReadyCard()
	local lastPos = nil;
	for i,v in ipairs(data) do
		local content_pos = cc.p(self.node["hcard_node" .. v.view_id]:getPosition())
		--self.node["hcard_node" .. v.view_id]:hide()
		print("v.num:"..v.num.."-------------:v.view_id:"..v.view_id)
		-- if v.num > RoomConfig.HandCardNum then
		-- 	v.num = RoomConfig.HandCardNum
		-- end

		for i=1,v.num do --计算牌的位置
			local pos = {}
			local card =nil

			-- 每创建一张手牌, 底牌也需要移除一张
			  -- self:removeOneReadyCard()

			if v.view_id == RoomConfig.MySeat then --有数据的手牌
				release_print(os.date("%c") .. "[info] CLCCD 创建手牌 ",v.view_id,v.value[i])
			 	card = self.card_factory:createHandCard(v.view_id,v.value[i],true)
			 	local size = card:getContentSize()
				CardLayer.MySeatPerSize  = size 	--手牌单位大小
				pos = cc.p((i-v.num/2-1-self.GetCardOffsetX)*size.width,30)
				card:addTouchEventListener(handler(self,CardLayer.touchCardEvent)) --自己的牌需要添加触碰事件
				-- card:setTag(i) --牌的索引
				card:setTag(v.value[i]) 
				self.out_line = content_pos.y + size.height/2
				card:setPosition(pos)
				self.node["hcard_node"..v.view_id]:addChild(card)
				-- print("v.view_id == RoomConfig.MySeat")
			else
				release_print(os.date("%c") .. "[info] CLCCD 展示手牌 ",v.view_id,i)
				card = self.hand_cardLayer:showCard(v.view_id,i)
			end

			local card_panel = {
				card_sprite = card,
				card_value = v.value[i], --只有自己的手牌有数据其他的都是nil
				card_pos = cc.p(card:getPosition())
			}

			table.insert(self.card_list[RoomConfig.HandCard][v.view_id],card_panel)
		end

		if v.value[v.num + 1] then
			self:initMySeatCardPosList(CardLayer.MySeatPerSize)
			self:getCard(v.value[v.num + 1])
		end
	end
end

--重新排列手牌 手牌的顺序必须和数据顺序一样。

function CardLayer:sortHandCard(viewId,optCard)

	print("sortHandCardsortHandCard---------:") 

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
		local card = card_list[card_num].card_sprite --最后一张牌移位（摸牌的偏移量）
		local pos_x = card:getPositionX()
		card:setPositionX(pos_x+self.GetCardOffsetX*(CardLayer.MySeatPerSize.width+CardLayer.MySeatCardSetOffX))
		print("RoomConfig.ChiRoomConfig.Chi")
	end

end

function CardLayer:addDownCard(viewId,value,isReset)
	-- body
	-- sprite:loadTexture(frame_name,1)
	local card_list = self.card_list[RoomConfig.OutCard][viewId]
	local card_num= #card_list

	local col = card_num%self.OutCardCol --当前牌应该放在第几列
	local row = math.floor(card_num/self.OutCardCol)  --当前牌应该放在第几行
	print("row:-----------------"..row)
	local tempRow = 3  --从第2行开始特殊摆牌
	local tempCard= self.OutCardCol*tempRow
	print("cardNum:----------------"..card_num)
	print("tempCard:----------------"..tempCard)

	local sprite=self.out_cardLayer:showoutCard(viewId,value,row,col)
	--if sprite == nil then return end
		
	local card_panel = {
			card_sprite = sprite,
			card_value = value
		}
	table.insert(self.card_list[RoomConfig.OutCard][viewId],card_panel)

	--显示出牌标记位置
	--self.node.marker:show()
	self.markerAnim:show()
	-- self.node.marker:stopAllActions()
	local world_pos = sprite:convertToWorldSpace(sprite:getAnchorPointInPoints())
	world_pos = cc.pAdd(world_pos,cc.p(0,sprite:getContentSize().height/2))
	
	-- self.node.marker:setPosition(world_pos)
	self.markerAnim:setPosition(world_pos)
	-- local actions = {
	-- 					cc.MoveBy:create(0.5,cc.p(0,10)),
	-- 					cc.MoveBy:create(0.5,cc.p(0,-10)),
	-- 				}
	-- local seq = transition.sequence(actions)
	-- local action = cc.RepeatForever:create(seq)
	-- self.node.marker:runAction(action)

	--self.out_cardLayer:resetAllCard()
end

--增加一张牌到出牌队列
function CardLayer:addOutCard(viewId,value)
	release_print(os.date("%c") .. "[info] 牌桌页面 增加一张牌到出牌队列 ",viewId,value)
	if self.last_out_card[viewId] then
		local card_list = self.card_list[RoomConfig.OutCard][viewId]
		local card_num= #card_list
		-- local sprite = self.card_factory:createOutCardWithData(viewId,value,1)--ccui.ImageView:create()
		-- local content_size = sprite:getContentSize()
		local col = card_num%self.OutCardCol --当前牌应该放在第几列
		local row = math.floor(card_num/self.OutCardCol)  --当前牌应该放在第几行

		-- local wold_pos = self.node["ocard_node" .. viewId]:convertToWorldSpace(pos)
		local wold_pos = self.out_cardLayer:getShowOutCardWordPos(viewId,row,col)

		local actions = {
					cc.Spawn:create(cc.MoveTo:create(CardLayer.AddCardTime,wold_pos),cc.ScaleTo:create(CardLayer.AddCardTime,0.5)),
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

--获取播放吃碰杠的坐标
function CardLayer:getOptPos(viewId)
	-- body
	if not self.card_list[RoomConfig.HandCard][viewId][1] then
		return self.node["efcard_node"..viewId],cc.p(0, 0)
	end

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
	--return self.node["hcard_node"..viewId],pos

	return self.node["efcard_node"..viewId],pos
end

--zhongqy 出牌音效
function CardLayer:playCardEffect(card_type , card_value , sex) --牌类型 ， 牌数值 ， 出牌人性别
	-- global:getAudioModule():playSound("res/sound/dapai.wav",false)
	-- local sound_type = tostring(card_type)
	-- local sound_value = tostring(card_value)
	-- local sex = tostring(sex)  --模拟性别 2：男 其他：女
	-- local mp3_name
	-- if sex == "2" then
	-- 	if sound_type == "0" then
	-- 		mp3_name = string.format("res/sound/man/%dwan.mp3", sound_value)
	-- 	elseif sound_type == "1" then
	-- 		mp3_name = string.format("res/sound/man/%dtiao.mp3", sound_value)
	-- 	elseif sound_type == "2" then
	-- 		mp3_name = string.format("res/sound/man/%dtong.mp3", sound_value)
	-- 	elseif sound_type == "3" then
	-- 		mp3_name = string.format("res/sound/man/zi%d.mp3", sound_value)
	-- 	end
	-- else
	-- 	if sound_type == "0" then
	-- 		mp3_name = string.format("res/sound/female/g_%dwan.mp3", sound_value)
	-- 	elseif sound_type == "1" then
	-- 		mp3_name = string.format("res/sound/female/g_%dtiao.mp3", sound_value)
	-- 	elseif sound_type == "2" then
	-- 		mp3_name = string.format("res/sound/female/g_%dtong.mp3", sound_value)
	-- 	elseif sound_type == "3" then
	-- 		mp3_name = string.format("res/sound/female/zi%d.mp3", sound_value)
	-- 	end
	-- end
	-- global:getAudioModule():playSound(mp3_name,false)

	global:getAudioModule():playSound("res/sound/dapai.wav",false)

	local sound_type = tostring(card_type)
	local sound_value = tostring(card_value)

	local sex = tostring(sex)  --模拟性别 2：男 其他：女
	local mp3_name
	local sexPath = sex == "2" and "man/" or "female/g_"
	local sexPath3 = sex == "2" and "man/zi" or "female/zi"
	local tbPath = {}
	local resSoundBeforePath = "res/sound/"
	--子游戏麻将子方言音效播放说明：
	--1:在"res/sound/"目录下新建一个 和assertPath（如信阳就是,xymj）相同的文件夹
	--2:：将相对应的方言麻将子音效放入到assertPath（xymj）
	local bDialect =self.part:IsSetDialect()
	local assertPath = self.part:getGameAssetsPath()
	resSoundBeforePath = bDialect and resSoundBeforePath..assertPath.."/" or resSoundBeforePath

	tbPath["0"] = string.format("%s%s%dwan.mp3",resSoundBeforePath,sexPath,sound_value)
	tbPath["1"] = string.format("%s%s%dtiao.mp3",resSoundBeforePath,sexPath,sound_value)
	tbPath["2"] = string.format("%s%s%dtong.mp3",resSoundBeforePath,sexPath,sound_value)
	tbPath["3"] = string.format("%s%s%d.mp3",resSoundBeforePath,sexPath3,sound_value)
	if not tbPath[sound_type] then return end
	mp3_name = tbPath[sound_type]
	print("mp3_name:"..mp3_name)
	global:getAudioModule():playSound(mp3_name,false)
end

function CardLayer:playOperateEffect(operate_type , sex , seat) 	--操作类型（胡 碰 杠）出牌人性别 出牌人位置
   	local sex = tostring(sex)
   	local mp3_name = nil
   	local sex_name = sex =="2" and "man/" or "female/"
   	local optType = tostring(operate_type)
   	local tbPath = {}
   	local resSoundBeforePath = "res/sound/"
   	local resHuBeforePath = "res/sound/"
	local bDialect =self.part:IsSetDialect()
	local assertPath = self.part:getGameAssetsPath()
	resSoundBeforePath = bDialect and resSoundBeforePath..assertPath.."/" or resSoundBeforePath
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_CHI)] 					= string.format("%s%s%s",resSoundBeforePath,sex_name,"chi.mp3")
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_PENG)] 				= string.format("%s%s%s",resSoundBeforePath,sex_name,"peng0.mp3")
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_MING_GANG)] 			= string.format("%s%s%s",resSoundBeforePath,sex_name,"gang0.mp3")
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_AN_GANG)] 				= string.format("%s%s%s",resSoundBeforePath,sex_name,"gang0.mp3")
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_BU_GANG)] 				= string.format("%s%s%s",resSoundBeforePath,sex_name,"gang0.mp3")
   	tbPath[tostring(RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED)] 	= string.format("%s%s",resHuBeforePath,"effect_hu.mp3")
   	if not tbPath[optType] then return end
   	mp3_name = tbPath[optType]
   	print("Operate===mp3_name:"..mp3_name)
   	global:getAudioModule():playSound(mp3_name,false)
 --   local sex = tostring(sex)
 --   local mp3_name = nil
 --   local sex_name = "man"
   
 --   if sex ~=  "2" then
 --   		sex_name = "female"
 --   end


	-- if operate_type == RoomConfig.MAHJONG_OPERTAION_CHI  then --吃
	-- 		mp3_name = "res/sound/".. sex_name .. "/chi.mp3"
 --    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PENG then --碰
	-- 		mp3_name = "res/sound/".. sex_name .. "/peng0.mp3"
 --    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_MING_GANG or operate_type == RoomConfig.MAHJONG_OPERTAION_AN_GANG or operate_type == RoomConfig.MAHJONG_OPERTAION_BU_GANG then --杠
	-- 	    mp3_name = "res/sound/".. sex_name .. "/gang0.mp3"
 --    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED then --胡
	-- 		-- mp3_name = "res/sound/".. sex_name .. "/hu.mp3"
	-- 		mp3_name = "res/sound/effect_hu.mp3"
	-- 	--为什么加下面的语句， lxb 注释掉了
	-- 	--if seat == RoomConfig.MySeat and sex ~= "2" then
	-- 	--	mp3_name = "res/sound/female/hu1.mp3"
	-- 	--end
 --    elseif operate_type == RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED then --自摸
	-- 	-- 	mp3_name = "res/sound/".. sex_name .. "/zimo0.mp3"
	-- 	-- if seat == RoomConfig.MySeat and sex ~= "2" then
	-- 	-- 	mp3_name = "res/sound/female/zimo111.mp3"
	-- 	-- end
	-- 	mp3_name = "res/sound/effect_hu.mp3"
	-- end

	-- if mp3_name == nil then
	-- 	return 
	-- end
 --   global:getAudioModule():playSound(mp3_name,false)
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
			local imgv = ma:getChildByName("Img_v")
			self:updateGCListCard(imgv,value,type)
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

function CardLayer:updateCardViewId(viewId,imgv,v,card_type)
	local tbPath = {}
	tbPath[RoomConfig.MySeat]="mj_az_02"
	tbPath[RoomConfig.DownSeat]="mj_ar_02"
	tbPath[RoomConfig.FrontSeat]="mj_ad_01"
	tbPath[RoomConfig.UpSeat]="mj_al_02"
	local fileNameBefore = tbPath[viewId]
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
	imgv:loadTexture(fileName,1)
end

function CardLayer:updateGCListCard(imgv,v,card_type)
	local fileNameBefore = "mj_az_01"
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
	imgv:loadTexture(fileName,1)
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
			print("c1:---------------"..c1)
			print("value:---------------"..value)
    		local ma = item:getChildByName("ma" .. j)
			local imgv = ma:getChildByName("Img_v")
			self:updateGCListCard(imgv,value,type)
			size_x = size_x + ma:getContentSize().width+2
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
			--清除听牌箭头
			print("ooooooooooooooooooo")
			self:clearTingCardsArrow()
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
		local texture_name = string.format("%s/room/resource/mj/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
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
	elseif type == RoomConfig.Peng then
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
	print("###[CardLayer:showOpt]type   value   opt_show", type,value,self.opt_show) 
end

function CardLayer:getCardFactory()
	return self.card_factory
end

function CardLayer:playerScoreEffect(view_id, ui_score, ui_total_score, score, totalScore)
	local pos_directions = {
		[1] = {x = 640, y = 260},
		[2] = {x = 900, y = 360},
		[3] = {x = 640, y = 600},
		[4] = {x = 300, y = 360}
	}

	--[[
	美术效果
	1、透明度0-100，用时132MS，位移59
	2、透明度保持不变，用时528MS，位移80
	3、透明度100-0，用时132MS，位移59
	]]

	local pos = pos_directions[view_id]
	print('view_id', view_id, json.encode(pos))
	ui_score:setPosition(cc.p(pos.x-100, pos.y))
	ui_score:setString('/' .. math.abs(score) )
	local ui_root = self.node.root:getParent()
	if not ui_root then
		return 
	end
	ui_root:addChild(ui_score, 100)

	local move_to 	= cc.MoveTo:create(0.13, cc.p(pos.x-60, pos.y))
	local fade_in 	= cc.FadeIn:create(0.13)
	local spawn1	= cc.Spawn:create(move_to, fade_in) 
	local move_to2 	= cc.MoveTo:create(0.52, cc.p(pos.x+60, pos.y))
	local move_to3 	= cc.MoveTo:create(0.13, cc.p(pos.x+100, pos.y))
	local fade_out 	= cc.FadeOut:create(0.13)
	local spawn2	= cc.Spawn:create(move_to3, fade_out)
	local call_back		= cc.CallFunc:create(function()
		local path_name = self.res_base .. '/sp/jingyaneffect/jingyaneffect'
		local ui_effect = Util.createSpineAnimation(path_name, '1', nil, true)
		local size 		= ui_total_score:getContentSize()
		ui_effect:setAnchorPoint(cc.p(0.5, 0.5))
		ui_effect:setPosition(cc.p(size.width/2, size.height/2))
		ui_total_score:addChild(ui_effect)
		ui_total_score:setString(totalScore)
		ui_score:removeFromParent()
	end)	
	local seqs 		= cc.Sequence:create(spawn1, move_to2, spawn2, call_back)
	ui_score:runAction(seqs)
end

function CardLayer:updateScoreNtf(score_ntf)
	for i=1, 4 do
		local ui_head 	= self.node['head_node' .. i ]
		ui_head:setVisible(true)
	end

	for i, player_score in ipairs(score_ntf.playerScore) do
		local uid 		= player_score.uid
		local score 	= player_score.score
		local totalScore= player_score.totalScore

		local seat_id, player = self.part.owner:getPlayerByUid(uid)
		if not seat_id or not player then
			print('update match score error:', uid, seat_id, json.encode(player))
			return 
		end

		local view_id 			= self.part:changeSeatToView(seat_id) 
		local ui_head 			= self.node["head_node" .. view_id]
		local ui_total_score 	= self.node['coin' .. view_id ]
		local ui_win_score	 	= ccui.TextAtlas:create('',
													self.res_base .. "/jia.png",
													50,
													77,
													"/")

		local ui_lose_score = ccui.TextAtlas:create('',
													self.res_base .. "/jian.png",
													50,
													77,
													"/")
		ui_head:setVisible(true)
		if score == 0 then
			local ui_score 	= self.node['coin' .. view_id]
			ui_score:setString(totalScore)
		elseif score > 0 then
			self:playerScoreEffect(view_id, ui_win_score, ui_total_score, score, totalScore)
		elseif score < 0 then
			self:playerScoreEffect(view_id, ui_lose_score, ui_total_score, score, totalScore)
		end
	end
end

return CardLayer
