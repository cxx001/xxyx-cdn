--[[
*名称:ThrowCardLayer
*描述:甩牌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]

local CURRENT_MODULE_NAME = ...
local ThrowCardPart = class("ThrowCardPart",cc.load('mvc').PartBase)
ThrowCardPart.DEFAULT_VIEW = "ThrowCardLayer"

--[
-- @brief 构造函数
--]
function ThrowCardPart:ctor(owner)
    ThrowCardPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function ThrowCardPart:initialize()
	
end
--激活模块
function ThrowCardPart:activate(gameId, card_part, data, cardfactory)
	self.game_id = gameId
	self.card_part = card_part
	ThrowCardPart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:setPlayerState(data.playerstates)

	if not data.playerstates[RoomConfig.MySeat] then
		self.view:initThrowMj(data.throwcards, cardfactory)
	end
end

function ThrowCardPart:setPlayerState(playerstate)
	self.view:setPlayerState(playerstate)
end

function ThrowCardPart:deactivate()
	if self.view then
		self.view:removeSelf()
	  	self.view =  nil
	end
end

function ThrowCardPart:throwCard(throw_card)
	if self.card_part then
		self.card_part:sendThrowCardRequest(throw_card)
	end
end

function ThrowCardPart:getView()
	return self.view
end

function ThrowCardPart:getPartId()
	-- body
	return "ThrowCardPart"
end

return ThrowCardPart