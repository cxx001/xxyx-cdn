--[[
*名称:RoomMenuPart
*描述:游戏菜单页面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local RoomMenuPart = class("RoomMenuPart",cc.load('mvc').PartBase) --登录模块
RoomMenuPart.DEFAULT_PART = {}
RoomMenuPart.DEFAULT_VIEW = "RoomMenuLayer"
--[
-- @brief 构造函数
--]
function RoomMenuPart:ctor(owner)
    RoomMenuPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function RoomMenuPart:initialize()
	self.cur_select =  self.FACE_TYPE --默认打开表情页面
	self.record_list = {}
end

--激活模块
--[[
	pos_table = { --激活需要传入表情坐标table(相对整个界面的坐标)
		cc.p()
		cc.p()
	}
--]]
function RoomMenuPart:activate(tableid)
	--if not posTable then
	--	printLog('warning',"pos table is nil activate chat part fail")
	--end

	--self.m_pos = seat_id

	--local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	--net_mode:registerMsgListener(MsgDef.MSG_TALKING_IN_GAME,handler(self,RoomMenuPart.recTalkingInGameMsg))

	--self.pos_table = posTable
	--self.voice_record_show = false --是否隐藏聊天记录界面
	self.tableid = tableid;
	RoomMenuPart.super.activate(self,CURRENT_MODULE_NAME)
	--self.view:intRecordProgress(29)
	--local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	--lua_bridge:addEventListener("nativeOnRecordVoiceEnd",handler(self,RoomMenuPart.onRecordVoiceEnd))
	-- self.view:showSelectedPage(self.cur_select)
end

function RoomMenuPart:deactivate()
	--local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	--lua_bridge:removeEventListenersByEvent("nativeOnRecordVoiceEnd")

	--local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	--net_mode:unRegisterMsgListener(MsgDef.MSG_TALKING_IN_GAME)
	--self.view:hideIME()
	self.view:removeSelf()
	self.view =  nil
end

function RoomMenuPart:getPartId()
	-- body
	return "RoomMenuPart"
end

function RoomMenuPart:hideDissolveBtn(ret)
	dump(self.view)
	self.view:hideDissolveBtn(ret)
end

return RoomMenuPart
