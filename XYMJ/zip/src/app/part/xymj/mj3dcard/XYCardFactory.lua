--[[
*名称:CardLayer
*描述:手牌工厂模式类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local XYCardFactory = class("XYCardFactory", import(".CardFactory"))

function XYCardFactory:createDownCardWithData(viewId,value,showKanpaiIcon)
	-- body
	local card = XYCardFactory.super.createDownCardWithData(self, viewId, value)
	local frame_name = nil
	if showKanpaiIcon then
		frame_name = self:getKanFrameName(viewId)
	end

	if frame_name then
		--local flag = cc.Sprite:createWithSpriteFrameName(frame_name)
		local flag = cc.Sprite:create(frame_name)
		
		if flag then
			if viewId == RoomConfig.DownSeat or viewId == RoomConfig.UpSeat then
				flag:setScale(0.65)
				flag:setPosition(cc.p(35, 26))
			else
				flag:setScale(0.65)
				flag:setPosition(cc.p(35, 55))
			end
			card:addChild(flag)
		end
	end
		
	return card
end

function XYCardFactory:getKanFrameName(viewId)
	-- body
	local frame_name = ""
	if viewId == RoomConfig.MySeat then
		frame_name = self.res_base .. "/room/resource/mj/B_autumnkan.png"
	elseif viewId == RoomConfig.DownSeat then
		frame_name = self.res_base .. "/room/resource/mj/R_autumnkan.png"
	elseif viewId == RoomConfig.FrontSeat then
		frame_name = self.res_base .. "/room/resource/mj/L_autumnkan.png"
	elseif viewId == RoomConfig.UpSeat then
		frame_name = self.res_base .. "/room/resource/mj/B_autumnkan.png"
	end
	return frame_name
end

return XYCardFactory