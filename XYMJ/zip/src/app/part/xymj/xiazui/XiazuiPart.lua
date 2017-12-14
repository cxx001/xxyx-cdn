--[[
*名称:XiazuiLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local XiazuiPart = class("XiazuiPart",cc.load('mvc').PartBase) --登录模块
XiazuiPart.DEFAULT_VIEW = "XiazuiLayer"
XiazuiPart.ZORDER = 13

--[
-- @brief 构造函数
--]
function XiazuiPart:ctor(owner)
    XiazuiPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function XiazuiPart:initialize()
	
end

--激活模块
function XiazuiPart:activate(xiazui_type)
    self.zorder = XiazuiPart.ZORDER
    XiazuiPart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:setAreaType(xiazui_type)
end

function XiazuiPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function XiazuiPart:onSelectOK()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerTableOperationMsg()
    opt_msg.operation = RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI
    opt_msg.opValue = self:getXiazuiVal()
    net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)	
end

function XiazuiPart:onSelectCancle()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerTableOperationMsg()
    opt_msg.operation = RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI
    opt_msg.opValue = 0
    net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)		
end

function XiazuiPart:getXiazuiVal()
	local ret = 0
	if self.view:isMenqingSelected() then
		ret = ret + 0x80
	end
	
	if self.view:isJiaziSelected() then
		ret = ret + 0x100
	end
	
	if self.view:isDuamenSelected() then
		ret = ret + 0x200
	end
	
	if self.view:isBazhangSelected() then
		ret = ret + 0x400
	end
	
	if self.view:isZhadanSelected() then
		ret = ret + 0x800
	end
	
	if self.view:isPaoziSelected() then
		ret = ret + 0x1000
	end
	
	return ret
end

function XiazuiPart:getPartId()
	-- body
	return "XiazuiPart"
end

return XiazuiPart 