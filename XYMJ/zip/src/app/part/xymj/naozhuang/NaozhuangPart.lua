--[[
*名称:NaozhuangLayer
*描述:闹庄界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local NaozhuangPart = class("NaozhuangPart",cc.load('mvc').PartBase) --登录模块

NaozhuangPart.DEFAULT_VIEW = "NaozhuangLayer"
--[
-- @brief 构造函数
--]
function NaozhuangPart:ctor(owner)
    NaozhuangPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function NaozhuangPart:initialize()

end

function NaozhuangPart:activate()
	print("NaozhuangPart active ")
    NaozhuangPart.super.activate(self, CURRENT_MODULE_NAME)
    self.view:hideNaozhuangPanel()
end

function NaozhuangPart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view =  nil
	end
end

function NaozhuangPart:getPartId()
	-- body
	return "NaozhuangPart"
end

--将逻辑座位转换为界面座位
function NaozhuangPart:changeSeatToView(seatId) --座位顺时针方向增加 1 - 4
	-- body
	if self.m_pos then
		return (seatId - self.m_pos + 4)%4 + 1
	end
end

function NaozhuangPart:maskClick()
	-- body
end

function NaozhuangPart:onSelectNaozhuang()
	print("NaozhuangPart:onSelectNaozhuang")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = RoomConfig.MAHJONG_OPERTAION_NAO_ZHUANG
    net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function NaozhuangPart:onSelectTongnao()
	print("NaozhuangPart:onSelectTongnao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = RoomConfig.MAHJONG_OPERTAION_TONG_NAO
    net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function NaozhuangPart:onSelectCancleNaozhuang()
	print("NaozhuangPart:onSelectBunao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = RoomConfig.MAHJONG_OPERTAION_CANCLE_NAO_ZHUANG
    net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function NaozhuangPart:onSelectCancleTongnao()
	print("NaozhuangPart:onSelectBunao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = RoomConfig.MAHJONG_OPERTAION_CANCLE_TONG_NAO
    net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function NaozhuangPart:onNotifyNaozhuang()
	self.view:showNaozhuangPanel()
end

function NaozhuangPart:onNotifyWaitNaozhuang()
	self.view:showWaitNaozhuangPanel()
end

function NaozhuangPart:onNotifyTongnao()
	self.view:showTongnaoPanel()
end

function NaozhuangPart:onNotifyWaitTongnao()
	self.view:showWaitTongnaoPanel()
end

function NaozhuangPart:onNotifySelectNaoChaoshi()
	self:deactivate()
end

return NaozhuangPart
