--[[
*名称:DissolveLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local DissolvePart = class("DissolvePart",cc.load('mvc').PartBase) --登录模块
DissolvePart.DEFAULT_VIEW = "DissolveLayer"

--[
-- @brief 构造函数
--]
function DissolvePart:ctor(owner)
    DissolvePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DissolvePart:initialize()
	
end

--激活模块
function DissolvePart:activate(gameId)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	DissolvePart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:LayerInit(false)
	print("this is DissolvePart:activate----------------------------------------------------  ")
end

function DissolvePart:deactivate()
	self.view:removeSelf()
  	self.view = nil
  	print("this is DissolvePart:deactivate----------------------------------------------------  ")
end

function DissolvePart:closeClick()
	-- body
	self.view:CloseClick()
end

function DissolvePart:getPlayerInfo(viewId)
	return self.owner:getPlayerInfo(viewId)
end

function DissolvePart:changeSeatToView(seatId)
	return self.owner:changeSeatToView(seatId)
end

function DissolvePart:setData(data , playerList ,m_seat_id)
	if data.mCloseStatus == 1 then
		self.view:LayerInit(true)
		self.view:SetData(data , playerList , m_seat_id)
	elseif data.mCloseStatus == 2 then
		self.view:LayerInit(false)
		self:showDisagree(data , playerList)
	else
		self.view:LayerInit(false)
	end
end

function DissolvePart:showCloseVipRoomTips(playerName,playerIndex)
	-- body
	self.owner:showCloseVipRoomTips(playerName,playerIndex)
end

function DissolvePart:sureCloseVipRoom(flag)
	-- body
	self.owner:sureCloseVipRoom(flag)
end

function DissolvePart:showDisagree(data , playerList)
	-- body
	if data.mRefuseTablePos ~= nil then
		for i,v in ipairs(data.mRefuseTablePos) do
			local playerId = self:changeSeatToView(v)
			local player_disagree_txt = self:getPlayerInfo(playerId)
			local disagree_tip = string.format(string_table.player_disagree_tip,player_disagree_txt.name)
			local tips_part = global:createPart("TipsPart",self)
			if tips_part then
				tips_part:activate({info_txt=disagree_tip})
			end
		end
	end
end

function DissolvePart:getPartId()
	-- body
	return "DissolvePart"
end

return DissolvePart 