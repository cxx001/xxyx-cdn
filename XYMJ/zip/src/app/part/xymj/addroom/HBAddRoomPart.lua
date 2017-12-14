--[[
*名称:AddRoomLayer
*描述:加入房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local AddRoomPart = import(".AddRoomPart")
local HBAddRoomPart = class("HBAddRoomPart",AddRoomPart) --登录模块
HBAddRoomPart.DEFAULT_PART = {}
HBAddRoomPart.DEFAULT_VIEW = "AddRoomLayer"
HBAddRoomPart.TPYE1 = 1 --创建房间
HBAddRoomPart.TPYE2 = 2 --推荐人输入
HBAddRoomPart.CMD = {
	MSG_ENTER_VIP_ROOM = SocketConfig.MSG_ENTER_VIP_ROOM,
}
function HBAddRoomPart:addGame() 
	-- body
	if #self.num_list > 0 then
		if self.type() == HBAddRoomPart.TPYE1 then
			print("###[HBAddRoomPart:addGame] HBAddRoomPart.TPYE1")
			local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
			local enter_vip_room = wllobby_message_pb.ReqStartGame()
			enter_vip_room.roomid = tonumber(table.concat(self.num_list))
			enter_vip_room.gametype = 1
			enter_vip_room.tableid = "ask_enter_room"
			self.owner:startLoading()
			net_mode:sendProtoMsg(enter_vip_room,HBAddRoomPart.CMD.MSG_ENTER_VIP_ROOM,self.game_id)
			print("##[HBAddRoomPart:addGame] ask_enter_room roomid is ", enter_vip_room.roomid)
		elseif self.type() == HBAddRoomPart.TPYE2 then
			print("###[HBAddRoomPart:addGame] HBAddRoomPart.TPYE2")
			local str = tonumber(table.concat(self.num_list))
			self.owner:addReferrerId(str)
			self:deactivate()
		end
	end
end


return HBAddRoomPart 