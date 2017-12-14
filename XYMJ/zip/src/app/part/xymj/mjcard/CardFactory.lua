--[[
*名称:CardLayer
*描述:手牌工厂模式类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CardFactory = class("CardFactory")
local MjCard = import(".MjCard")

function CardFactory:init(resBase)
	-- body
	self.res_base = resBase
	self:addSpriteFrames()
end

function CardFactory:addSpriteFrames()
	-- body
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/empty/empty_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mine/mine_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/left/left_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/right/right_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/bottom/bottom_picture.plist")
	
end

function CardFactory:createEndCard(value)
	-- body
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)
	print("this is  createEndCard",value,card_type,card_value)
	local frame_name = ""
	self.node =  MjCard:create()
	self.node:setValue(value)
	local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
	frame_name = self.res_base .. "/mine/" .. png_name
	print("frame_name = ",frame_name)
	self.node:loadTexture(frame_name,1)
	
	if touch then --是否有触摸事件
		self.node:setTouchEnabled(true)
		self.node:setSwallowTouches(false)
	end
	return self.node
end

function CardFactory:createWithData(viewId,value,touch)
	-- body
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)
	local frame_name = ""
	self.node =  MjCard:create()
	self.node:setValue(value)
	if viewId == RoomConfig.MySeat then
	    local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
	    local cur_part = global:getCurrentPart()
	    if cur_part and cur_part.record_mode then
	    	-- @ 回放模式下，我自己的牌应该与吃、碰、杠模型一样展示
	    	frame_name = self.res_base .. "/bottom/" .. png_name
	    else
	    	frame_name = self.res_base .. "/mine/" .. png_name
	    end
	    
	elseif viewId == RoomConfig.DownSeat then
		if value then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_right.png"
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name
			self.node:setScale(0.5)
		else
			frame_name = self.res_base .. "/empty/e_mj_up.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/" .. png_name
		else
		    frame_name = self.res_base .. "/empty/e_mj_left.png"
		end
	end
	
	
	self.node:loadTexture(frame_name,1)
	
	if viewId == RoomConfig.MySeat then

		local scale = display.width / 1080
		local o_scale = self.node:getScale()
		--print("this is o_scale :",o_scale,scale)
		self.node:setScale(scale*o_scale)
		local content_size = self.node:getContentSize()
		self.node.getContentSize = function()
			-- body
			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
		end
	end


	if touch then --是否有触摸事件
		self.node:setTouchEnabled(true)
		self.node:setSwallowTouches(false)
	end
	return self.node
end 

function CardFactory:createDownCardWithData(viewId,value)
	-- body
	print("this is card down card:",viewId,value)
	self:addSpriteFrames()
	self.node = cc.Sprite:createWithSpriteFrameName(self.res_base .. "/bottom/B_autumn.png")
	local size = self.node:getContentSize()
	local frame_name = self:getFrameNameWithData(viewId,value)
	self.node:setSpriteFrame(frame_name)
	if viewId == RoomConfig.MySeat then
		local scale = display.width / 1080
		local o_scale = self.node:getScale()
		self.node:setScale(scale*o_scale)
		local content_size = self.node:getContentSize()
		print("this is o_scale :",o_scale,scale)
		self.node.getContentSize = function()
			-- body
			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
		end
	end
	return self.node
end

function CardFactory:decodeValue(value)
	-- body
	if value then
		return math.floor(value/16),value%16
	else
		return nil
	end
end

function CardFactory:getFrameName(viewId,value)
	-- body
	local frame_name = ""
	local card_type,card_value = self:decodeValue(value)
	if viewId == RoomConfig.MySeat then
		local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
		frame_name = self.res_base .. "/mine/" .. png_name
	elseif viewId == RoomConfig.DownSeat then
		if value then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_right.png"
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name
			self.node:setScale(0.5)
		else
			frame_name = self.res_base .. "/empty/e_mj_up.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/" .. png_name
		else
		    frame_name = self.res_base .. "/empty/e_mj_left.png"
		end
	end
	return frame_name
end

function CardFactory:getFrameNameWithData(viewId,value)
	-- body
	local frame_name = ""
	local card_type,card_value = self:decodeValue(value)
	if viewId == RoomConfig.MySeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name	
		else
			frame_name = self.res_base .. "/bottom/B_wind_9.png"
		end
	elseif viewId == RoomConfig.DownSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_b_left.png"
			self.node:setRotation(-90)
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name
		else
			frame_name = self.res_base .. "/bottom/B_wind_9.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_b_right.png"
			self.node:setRotation(-90)
		end
	end
	return frame_name
end

return CardFactory