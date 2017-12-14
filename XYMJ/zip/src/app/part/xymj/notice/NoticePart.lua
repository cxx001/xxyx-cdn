--[[
*名称:NoticeLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local NoticePart = class("NoticePart",cc.load('mvc').PartBase) --登录模块
NoticePart.DEFAULT_VIEW = "NoticeLayer"
NoticePart.CMD = {
MSG_GET_GAME_CONFIG_RSP=0x01000008,				--申请代理ack
MSG_GET_GAME_CONFIG_REQ =0x01000007,			--申请代理,
}
--[
-- @brief 构造函数
--]
function NoticePart:ctor(owner)
    NoticePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function NoticePart:initialize()
	
end

--激活模块
function NoticePart:activate(gameId)
    self.game_id = gameId
	NoticePart.super.activate(self,CURRENT_MODULE_NAME)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(NoticePart.CMD.MSG_GET_GAME_CONFIG_RSP,handler(self,NoticePart.noticeAck),self:getPartId())  -- 没有操作 
	self:noticeReq()
end

function NoticePart:noticeReq()
	-- body
	local notice_req = hjlobby_message_pb.GetGameConfigReq()
	notice_req.type = 3
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:sendProtoMsg(notice_req,NoticePart.CMD.MSG_GET_GAME_CONFIG_REQ,self.game_id)
end

function NoticePart:noticeAck(data,gameID)
	-- body
	local notice_ack = hjlobby_message_pb.GetGameConfigRsp()
	notice_ack:ParseFromString(data)
	-- printserialize(notice_ack)
	printInfo("NoticePart:noticeAck %s",notice_ack)
	if notice_ack.resultCode == 0 and notice_ack.type == 3 and notice_ack.msg[1] then
		self.view:setNoticeInfo(notice_ack.msg[1])
	end
end

function NoticePart:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(NoticePart.CMD.MSG_GET_GAME_CONFIG_RSP,self:getPartId())
	if self.view then
		self.view:removeSelf()
	  	self.view =  nil
	end
end

function NoticePart:getPartId()
	-- body
	return "NoticePart"
end

return NoticePart 