--[[
*名称:CardLayer
*描述:手牌工厂模式类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local HBCardFactory = class("HBCardFactory", import(".CardFactory"))

function HBCardFactory:init(resBase, laiZiPred, piZiPred, hongzhongPred)
	HBCardFactory.super.init(self, resBase)
	self.laiZiPred = laiZiPred
	self.piZiPred = piZiPred
	self.hongzhongPred = hongzhongPred or nil
end

function HBCardFactory:createWithData(viewId,value,touch)
	-- body
	local card = HBCardFactory.super.createWithData(self, viewId,value,touch)
	if viewId == RoomConfig.MySeat then
		return self:addCardFlag(card, value)
	end
	return card
end

function HBCardFactory:addSpriteFrames()
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mj_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/../../mjcardopt/res/opt_picture.plist")
	HBCardFactory.super.addSpriteFrames(self)
end

function HBCardFactory:addCardFlag(cardNode, value)
	print("###[HBCardFactory:addCardFlag]") 
	local frame_name = nil
	if self.laiZiPred(value) then
		frame_name = self.res_base .. "/icon_lai.png"
	elseif self.piZiPred(value) then
		frame_name = self.res_base .. "/icon_chao.png"
	elseif nil ~= self.hongzhongPred and self.hongzhongPred(value) then
		frame_name = self.res_base .. "/icon_pi.png"
	end 
	if frame_name then 
		local flag = cc.Sprite:createWithSpriteFrameName(frame_name)
		if flag then
			flag:setPosition(cc.p(52, 68))
			cardNode:addChild(flag)
		end
	end
	return cardNode
end


function HBCardFactory:createEndCard(value)
	print("###[HBCardFactory:createEndCard] value is ", value)
	local card = HBCardFactory.super.createEndCard(self, value)
	local frame_name = nil
	if self.laiZiPred(value) then 
		frame_name = self.res_base .. "/icon_lai.png"
	elseif self.piZiPred(value) then
		--frame_name = self.res_base .. "/icon_pi.png"
	end
	if frame_name then 
		local flag = cc.Sprite:createWithSpriteFrameName(frame_name)
		if flag then
			flag:setPosition(cc.p(52, 68))
			card:addChild(flag)
		end
	end
	return card
end


return HBCardFactory