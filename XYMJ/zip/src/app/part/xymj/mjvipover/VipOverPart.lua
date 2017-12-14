--[[
*名称:VipOverLayer
*描述:大结算界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local VipOverPart = class("VipOverPart",cc.load('mvc').PartBase) --登录模块
VipOverPart.DEFAULT_PART = {}
VipOverPart.DEFAULT_VIEW = "VipOverLayer"
--[
-- @brief 构造函数
--]
VipOverPart.CMD = {
    MSG_GAME_OPERATION = 0xc30008, --
}
function VipOverPart:ctor(owner)
    VipOverPart.super.ctor(self, owner)
    self:initialize()
    
end

--[
-- @override
--]
function VipOverPart:initialize()

end

--激活模块
function VipOverPart:activate(gameId,data,tableid,creatorId)
    -- gameId = 262401 --临时调试用
    self.game_id = gameId
	--激活模块
    VipOverPart.super.activate(self, CURRENT_MODULE_NAME)
    self:vipOverDataInfo(data,tableid,creatorId)
end



function VipOverPart:vipOverDataInfo(data,tableid,creatorId)
    local vip_data = {}
    for k,v in ipairs(data.players) do
        vip_data[k] = {}
        if v.vipoverdata then
            local hithorsecount = v.vipoverdata.hithorsecount
            vip_data[k].dianpaoCount = v.vipoverdata.dianpaocount
            vip_data[k].ming_gang = bit._and(bit.rshift(hithorsecount,8),0xff)
            vip_data[k].an_gang = bit._and(bit.rshift(hithorsecount,16),0xff)
            vip_data[k].hit_horse = bit._and(bit.rshift(hithorsecount,0),0xff)
        end
    end
    self.view:vipOverDataInfo(data,vip_data,tableid,creatorId)
end

function VipOverPart:returnGame()
    -- body
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
    net_mode:sendProtoMsg(opt_msg,VipOverPart.CMD.MSG_GAME_OPERATION,self.game_id)
    self:deactivate()
    self.owner:returnGame()
end

function VipOverPart:loadHeadImg(url,node)
    -- body
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    lua_bridge:startDownloadImg(url,node)
end

function VipOverPart:deactivate()
    self.view:removeSelf()
    self.view =  nil
end

function VipOverPart:getPartId()
	-- body
	return "VipOverPart"
end

return VipOverPart
