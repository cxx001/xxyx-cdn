--[[
听牌提示
--]]
local DrawingTipCardLayer = class("DrawingTipCardLayer",cc.Ref)

-- local XYDownCardLayer = class("XYDownCardLayer",DownCardLayer)


local CURRENT_MODULE_NAME = ...

function DrawingTipCardLayer:init(resBase)
	self.res_base = resBase
	self._currentDrawCard = nil

	self.card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
	self.card_factory:addSpriteFrames()
end

DrawingTipCardLayer.rowItemtotal = 5
DrawingTipCardLayer.margingX = 10	--项之间的间隔

--子节点
function DrawingTipCardLayer:setRoot(root)
	self._root = root
	self.button_tip  = self._root:getChildByName("Button_tip")
   	self.hcard_node1 = self._root:getChildByName("hcard_node1")
   	self.hcard_node1 = self._root:getChildByName("hcard_node1")
    self.listView_bg = self.hcard_node1:getChildByName("ListView_bg")
   	self.image_bg = 	self.hcard_node1:getChildByName("Image_bg")
    self.slider_View = self.hcard_node1:getChildByName("Slider_View")
    self.slider_View:hide()

   	local  panel_itembg= self._root:getChildByName("Panel_itembg")
   	--每个项的单位宽度
   	self.itemWidth = panel_itembg:getChildByName("Image_1"):getContentSize().width
   	self.listView_bg:setItemModel(panel_itembg)
   	self.listView_bg_pox = self.listView_bg:getPositionX()
   	self:showDrawTip(false)

    self.slider_View:addEventListener(handler(self, DrawingTipCardLayer.sliderEvent))
    self.listView_bg:addScrollViewEventListener(handler(self, DrawingTipCardLayer.listViewEvent))
 	self.button_tip:addTouchEventListener(handler(self,DrawingTipCardLayer.TipTouchEvent)) --自己的牌需要添加触碰事件
end

function DrawingTipCardLayer:TipTouchEvent(pSender,eventType)
	if eventType == ccui.TouchEventType.began then
		print("began")
		self:showContentTip(true)
    elseif eventType == ccui.TouchEventType.moved then
  		print("moved")
    elseif eventType == ccui.TouchEventType.ended then
 		print("ended")
 		self:showContentTip(false)
    elseif eventType == ccui.TouchEventType.canceled then
 		print("canceled")
  		self:showContentTip(false)
    end
end

function DrawingTipCardLayer:showContentTip(b)
	if self.listView_bg and self.image_bg and self.slider_View then
	    self.listView_bg:setVisible(b) 
	   	self.image_bg:setVisible(b)
	    self.slider_View:setVisible(b)
	    if #self.listView_bg:getItems() <=1 then
	    	self.slider_View:setVisible(false)
	 	end
	end
end

--[[
打出去的时候为不可见听牌提示
--]]
--交互在什么时候可见，在什么时候不可见
function DrawingTipCardLayer:showButton_tip(b) 
	if self.button_tip then
		print("self.listView_bg:getItems()"..#self.listView_bg:getItems())
			if #self.listView_bg:getItems() >0 and b then
			-- if #self.listView_bg:getItems()>0 and b then
			self.button_tip:show() 
			print("button_tip:show")
		else
			self.button_tip:hide()
				print("button_tip:hide")
		end
	end
end

function DrawingTipCardLayer:allDrawTipHide()
	self.dataList = nil
	if self.listView_bg and self.image_bg and self.slider_View and self.button_tip then
	    self.listView_bg:hide() 
	   	self.image_bg:hide()
	    self.slider_View:hide()	
	    self.button_tip:hide()	
	end
end

function DrawingTipCardLayer:showDrawTip(b)
	if self.listView_bg and self.image_bg and self.slider_View then
	    self.listView_bg:setVisible(b) 
	   	self.image_bg:setVisible(b)
	    self.slider_View:setVisible(b)
	 	if #self.listView_bg:getItems() <=1 then
	    	self.slider_View:setVisible(false)
	 	end
	 	self:showButton_tip(not b)
	end
end

--x为偏移的位置
function DrawingTipCardLayer:layoutPanel_itembg(panel_itembg,x)
	local margingX =DrawingTipCardLayer.margingX
	local pBgWidth = panel_itembg:getContentSize().width
	for index=1,DrawingTipCardLayer.rowItemtotal do
		local itemWidget = panel_itembg:getChildByName("Image_"..index)
		local itemWidgetWidth = self.itemWidth
		local pos_x = pBgWidth -(index-1)*itemWidgetWidth -index*margingX
		itemWidget:setPositionX(pos_x)
	end
end

--itemDataNum当前行的项数
function DrawingTipCardLayer:setContentItemSize(itemDataNum)
	local margingX =DrawingTipCardLayer.margingX
	local listViewHight = self.listView_bg:getContentSize().height
	local image_bgHight = self.image_bg:getContentSize().height
	local totoalWidth = 0
	totoalWidth = self.itemWidth*itemDataNum +margingX*(itemDataNum+1) 
	self.listView_bg:setContentSize(cc.size(totoalWidth,listViewHight))
	self.image_bg:setContentSize(cc.size(totoalWidth+self.itemWidth,image_bgHight))
end

function DrawingTipCardLayer:adjustImage_bg(itemNum)
	if itemNum == 0 then return end
	local marginWidth = itemNum==1 and 0 or 40
	local width = self.listView_bg:getContentSize().width + self.itemWidth
	local hight = self.image_bg:getContentSize().height
	self.image_bg:setContentSize(cc.size(width+marginWidth,hight))
	self.listView_bg:setPositionX(self.listView_bg_pox-marginWidth)
end
--[[
	注明：内容框可滚动区域
	内容框大小随项数和胡牌标识决定；
	外围框由内容框决定
	排列从右往左边排列
--]]

function DrawingTipCardLayer:sliderEvent()
    local percent = self.slider_View:getPercent()
    self.listView_bg:jumpToPercentVertical(percent)
end

function DrawingTipCardLayer:listViewEvent(sender, event)
    if event == ccui.ScrollviewEventType.scrolling or
    event == ccui.ScrollviewEventType.containerMoved then
        local listView = self.listView_bg
        local pInner = listView:getInnerContainer()
        local listheight = listView:getLayoutSize().height - pInner:getContentSize().height
        local percent = (pInner:getPositionY()/listheight) * 100.0
        self.slider_View:setPercent(100-percent)
    end
end


function DrawingTipCardLayer:reSetContentItem(itemList,listData)
	--重新設置itemList的宽
	--
	self:layoutPanel_itembg(itemList,0)

    for index=1,DrawingTipCardLayer.rowItemtotal do
    	local itemWidget = itemList:getChildByName("Image_"..index)
    	itemWidget:hide()
    end

    for i,v in ipairs(listData) do
       	local itemWidget = itemList:getChildByName("Image_"..i)
       	itemWidget:show() 
       	self:updateCardItem(itemWidget,v)
    end
end

--这里需要优化一下
function DrawingTipCardLayer:updateContentItem(dataList)
	-- print("dataList:"..#dataList)
	local function nomalUpdateContent(dataList)
		self.listView_bg:removeAllItems()
		for i,v in ipairs(dataList) do
		    self.listView_bg:insertDefaultItem(i -1)
		    local itemList  = self.listView_bg:getItem(i-1)
		    self:reSetContentItem(itemList,v)
		    if i==1 then
		    	self:setContentItemSize(#v) 
		    end
		end
	end

	if self.dataList and dataList then
		print("self.dataList and dataList")
		dump(self.dataList)
		dump(dataList)
		if #self.dataList == #dataList then
			self.dataList = dataList
			print("#self.dataList === #dataList")
			if #self.listView_bg:getItems() == 0 then
				nomalUpdateContent(self.dataList)
				return
			end

		   	for i,v in ipairs(dataList) do
		        local itemList  = self.listView_bg:getItem(i-1)
		        if not itemList then
		        	break
		        end
		        self:reSetContentItem(itemList,v)
		        if i==1 then
		        	self:setContentItemSize(#v) 
		        end
		    end
		else
			print("#self.dataList not= #dataList")
			self.dataList = dataList
			nomalUpdateContent(self.dataList)
		end
	elseif not self.dataList then
		print("not self.dataList")
		self.dataList = dataList
		nomalUpdateContent(self.dataList)
	end

    if dataList and #dataList>0 then
    	if #dataList > 1 then
    		self.slider_View:show()
       		if not self.image_bg:isVisible() then
    			self.slider_View:hide()
    		end
    		self.listView_bg:setScrollBarEnabled(true)
     		self.listView_bg:setScrollBarOpacity(0.0)
     		self.slider_View:setPercent(0)
     		self.listView_bg:jumpToTop()
    	else
    		self.slider_View:hide()
    		self.listView_bg:setScrollBarEnabled(false)
    	end
    	self:adjustImage_bg(#dataList)
   		self:showDrawTip(true)
    end

end

function DrawingTipCardLayer:updateCardItem(itemWidget,data)
	local fanNum = data.fanNum
	local cardLeftNum = data.cardLeftNum
	local cardvalue= data.cardvalue
	local card_type,card_value = self.card_factory:decodeValue(cardvalue)
	local function updateCard(imgv,v,card_type)
		--加载个缓存plist保险点
		local fileNameBefore = "mj_az_01"
		local filePath=self.res_base .. "/"..fileNameBefore.."/"
		local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
		imgv:loadTexture(fileName,1) 
		local maskName = "maskName"
		local cardMask = imgv:getChildByName(maskName)
		local resName = "/mj_azz_01.png"
		if not cardMask then
			cardMask = ccui.ImageView:create()
			cardMask:setAnchorPoint(cc.p(0,0))
			cardMask:loadTexture(self.res_base..resName)
			cardMask:setName(maskName)
			imgv:addChild(cardMask)
		end
		if cardLeftNum == 0 then
			cardMask:show()
		else
			cardMask:hide()
		end
	end

	local img_cardBg = itemWidget:getChildByName("ma1")
	local img_card = img_cardBg:getChildByName("Img_v")
	updateCard(img_card,card_value,card_type)

	local  AtlasLabel_fannum= itemWidget:getChildByName("AtlasLabel_fannum")
	local  AtlasLabel_leftnum= itemWidget:getChildByName("AtlasLabel_leftnum")
	AtlasLabel_fannum:setString(fanNum.."")
	AtlasLabel_leftnum:setString(cardLeftNum.."")
end



return DrawingTipCardLayer