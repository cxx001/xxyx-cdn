--[[
*名称:ThrowCardLayer
*描述:甩牌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]

local ThrowCardLayer = class("ThrowCardLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...

function ThrowCardLayer:onCreate(data) --传入数据
	self:initWithFilePath("ThrowCardLayer",CURRENT_MODULE_NAME)
	for i=1,4 do
		local pathStr = "btn_mj_0" .. tostring(i)
		local mj_node = self.node.Image_down:getChildByName(pathStr)
		local shade = mj_node:getChildByName("img_shade")
		shade:hide()
	end
end

-- function ThrowCardLayer:setCardFactory(cardfactory)
-- 	self.card_factory = cardfactory
-- end

function ThrowCardLayer:initThrowMj(card_data, cardfactory)
	local function createWidgetCard(path,bTouch)
		local widgetCard = ccui.ImageView:create()
		widgetCard:setAnchorPoint(cc.p(0,0))
		widgetCard:loadTexture(path,1)
		widgetCard:setTouchEnabled(bTouch)
		return widgetCard
	end

	if cardfactory then
		for i=1,4 do
			local pathStr = "btn_mj_0" .. tostring(i)
			local mj_node = self.node.Image_down:getChildByName(pathStr)
			local value_node = mj_node:getChildByName("img_value")
			local card_type,card_value = cardfactory:decodeValue(card_data[i])
			local nodeCardVPath = cardfactory:getMySeatHandCardVFilePath(card_value,card_type)
			local nodeCardV=createWidgetCard(nodeCardVPath, false)
			if nodeCardV ~=nil then
				value_node:addChild(nodeCardV)
			end
			mj_node:setTag(card_data[i])
		end
	end
end

function ThrowCardLayer:setPlayerState(state)
	for k,v in ipairs(state) do
		if  k == RoomConfig.MySeat  then
			if v == false then
				self.node.Image_down:show()
			else	
				self.node.Image_down:hide()		
			end
		elseif k == RoomConfig.DownSeat then
			if v == false then
				self.node.Image_right:show()
			else	
				self.node.Image_right:hide()		
			end
		elseif k == RoomConfig.FrontSeat then
			if v == false then
				self.node.Image_up:show()
			else	
				self.node.Image_up:hide()		
			end
		elseif k == RoomConfig.UpSeat then
			if v == false then
				self.node.Image_left:show()
			else	
				self.node.Image_left:hide()		
			end
		end
	end
end

function ThrowCardLayer:onClickQueding()

	local throw_card = {}
	for i=1,4 do
		local pathStr = "btn_mj_0" .. tostring(i)
		local mj = self.node.Image_down:getChildByName(pathStr)
		local shade = mj:getChildByName("img_shade")
		if shade:isVisible() then
			if #throw_card < 2 then
				table.insert(throw_card, mj:getTag())
			end
		end
	end
	if #throw_card ~= 1 and #throw_card ~= 2 then
		return
	end
	
	self.part:throwCard(throw_card)
	--按钮不可再点击
	local queding_btn = self.node.Image_down:getChildByName("btn_qd")
	queding_btn:setTouchEnabled(false);
end

function ThrowCardLayer:onClickMj(sender)
	-- body
	if sender then
		local shade = sender:getChildByName("img_shade")
		if shade:isVisible() then
			shade:hide()
		else
			if self:canSelectMj() then
				shade:show()
			end
		end
	end
end

function ThrowCardLayer:canSelectMj()
	local can = false
	local chooseNum = 0
	for i=1,4 do
		local pathStr = "btn_mj_0" .. tostring(i)
		local mj = self.node.Image_down:getChildByName(pathStr)
		local shade = mj:getChildByName("img_shade")
		if shade:isVisible() then
			chooseNum = chooseNum + 1 
		end
	end
	if chooseNum < 2 then
		can = true
	end
	return can
end

return ThrowCardLayer