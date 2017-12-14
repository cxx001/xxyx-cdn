--[[
*名称:AdLayer
*描述:广告界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local AdPart = class("AdPart",cc.load('mvc').PartBase) --登录模块
AdPart.DEFAULT_PART = {}
AdPart.DEFAULT_VIEW = "AdNode"
--[
-- @brief 构造函数
--]
AdPart.CMD = {
MSG_GET_LUNBOTU_RSP = 0x0100000c,
MSG_GET_LUNBOTU_REQ = 0x0100000b,
}
function AdPart:ctor(owner)
    AdPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function AdPart:initialize()
	
end

--激活模块
function AdPart:activate(gameId,node, msg)
    self.game_id = gameId
	AdPart.super.activate(self,CURRENT_MODULE_NAME,node)

    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:registerMsgListener(AdPart.CMD.MSG_GET_LUNBOTU_RSP,handler(self,AdPart.onGetAdImgUrllist))
    if not msg then
    	self:getAdImgUrlList()
    else
		self.view:initAdPageView(msg)
		self:updateAdImg(msg)    	
    end
end

function AdPart:getAdImgUrlList()
    local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)
    net_manager:sendMsg("", 0, AdPart.CMD.MSG_GET_LUNBOTU_REQ,self.game_id)
end

function AdPart:onGetAdImgUrllist(data)
    local adlist_ack = hjlobby_message_pb.GetGameConfigRsp()
	adlist_ack:ParseFromString(data)
	print("--- onGetAdImgUrllist success",adlist_ack)
 	if self.view ~= nil then
		self.view:initAdPageView(adlist_ack.msg)
		self:updateAdImg(adlist_ack.msg)
	end
end

function AdPart:updateAdImg(urllist)
	for idx,url in ipairs(urllist) do
    	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    	lua_bridge:startDownloadImg(url,self.view:getAdImgNode(idx))			-- wind 容易引起self.view:getHeadNode() CRASH
	end
end

function AdPart:deactivate()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(AdPart.CMD.MSG_GET_LUNBOTU_RSP)

	if self.view then
		self.view:removeSelf()
		self.view = nil
	end
end

function AdPart:getPartId()
	-- body
	return "AdPart"
end

function AdPart:showAdNode(isShow)
	self.view:showAdNode(isShow)
end

return AdPart 