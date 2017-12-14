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

function XYCardFactory:createEndCard(value,showKanpaiIcon)
	-- body
	local card = XYCardFactory.super.createEndCard(self,value)

	if showKanpaiIcon then
		local frame_name = self.res_base .. "/B_autumnkan.png"
		local flag = cc.Sprite:create(frame_name)
		if flag then
			flag:setPosition(cc.p(48, 60))
			card:addChild(flag)
		end
	end

	return card
end

function XYCardFactory:createDownCardWithData(viewId,value,showKanpaiIcon)
	-- body
	local card = XYCardFactory.super.createDownCardWithData(self, viewId, value)
	local frame_name = nil
	if showKanpaiIcon then
		frame_name = self:getKanFrameName(viewId)
	end

	if frame_name then
		print("XXXXX ----1---- frame_name ", frame_name)
		local flag = cc.Sprite:createWithSpriteFrameName(frame_name)
		--local flag = cc.Sprite:create(frame_name)
		
		if flag then
			print("XXXXX ----2---- viewId ", viewId)
			if viewId == RoomConfig.UpSeat then
				--flag:setScale(0.5)
				if value == RoomConfig.EmptyCard then
					flag:setPosition(cc.p(20, 25))
					flag:setRotation(90)
				else
					flag:setPosition(cc.p(25, 20))
				end			
			elseif viewId == RoomConfig.DownSeat then
				--flag:setScale(0.65)
				if value == RoomConfig.EmptyCard then
					flag:setPosition(cc.p(20, 25))
					flag:setRotation(90)
				else
					flag:setPosition(cc.p(25, 20))
				end
			elseif viewId == RoomConfig.FrontSeat then
				flag:setScale(0.65)
				flag:setPosition(cc.p(35, 55))
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
		frame_name = self.res_base .. "/B_autumnkan.png"
	elseif viewId == RoomConfig.DownSeat then
		frame_name = self.res_base .. "/R_autumnkan.png"
	elseif viewId == RoomConfig.FrontSeat then
		frame_name = self.res_base .. "/B_autumnkan.png"
	elseif viewId == RoomConfig.UpSeat then
		frame_name = self.res_base .. "/L_autumnkan.png"
	end

	return frame_name
end

return XYCardFactory