--[[
*名称:ReferrerLayer
*描述:关联界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local ReferrerPart = class("ReferrerPart",cc.load('mvc').PartBase) --登录模块
ReferrerPart.DEFAULT_VIEW = "ReferrerLayer"
ReferrerPart.Result1 = 0 				--绑定成功
ReferrerPart.Result2 = 1108 			--绑定上级失败
ReferrerPart.Result3 = 1109				--绑定上级失败

--[
-- @brief 构造函数
--]
function ReferrerPart:ctor(owner)
    ReferrerPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function ReferrerPart:initialize()
	
end

--激活模块
function ReferrerPart:activate(data)
	ReferrerPart.super.activate(self,CURRENT_MODULE_NAME)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:registerMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK,handler(self,ReferrerPart.gameOperationAck)) 
end

function ReferrerPart:deactivate()
	local net_mode = global:getNetManager()
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK)
	self.view:removeSelf()
  	self.view =  nil
end

function ReferrerPart:okClick(ReferrerId)
	-- body
	if ReferrerId == nil then 
		ReferrerId = 1
	end
	self.saveTime = ReferrerId
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ycmj_message_pb")
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
	opt_msg.opid = 1060
	opt_msg.opvalue = ReferrerId
	net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_GAME_OPERATION,SocketConfig.GAME_ID)
end

function ReferrerPart:gameOperationAck(data,appId)
	-- body
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ycmj_message_pb")
	local game_op_ack = ycmj_message_pb.PlayerGameOpertaionAck()
	game_op_ack:ParseFromString(data)
	print("this is LobbyPart op ack:",game_op_ack.result)

	local show_txt = ""
	if game_op_ack.result ==  ReferrerPart.Result1 then
		show_txt = "绑定成功"
		local user = global:getGameUser()
		local game_player = {}
		game_player.saveTime = self.saveTime
		user:setProp("gameplayer",game_player)
		self.owner:shopClick()
	elseif game_op_ack.result ==  ReferrerPart.Result2 then
		show_txt = "绑定上级失败"
	elseif game_op_ack.result ==  ReferrerPart.Result3 then
		show_txt = "绑定上级失败，无效用户"
	end 

	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=show_txt,mid_click=function()
			-- body
			self:deactivate()
		end})
	end
end

function ReferrerPart:getPartId()
	-- body
	return "ReferrerPart"
end

return ReferrerPart 