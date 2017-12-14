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
local AddRoomPart = class("AddRoomPart",cc.load('mvc').PartBase) --登录模块
AddRoomPart.DEFAULT_PART = {
    "LoadingPart",
}
AddRoomPart.DEFAULT_VIEW = "AddRoomLayer"
AddRoomPart.TPYE1 = 1 --创建房间
AddRoomPart.TPYE2 = 2 --推荐人输入
AddRoomPart.CMD = {
    MSG_ENTER_VIP_ROOM = 0xc30102,
}

require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ReqStartGame_pb")
--[
-- @brief 构造函数
--]
function AddRoomPart:ctor(owner)
    AddRoomPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function AddRoomPart:initialize()
	self.num_list = {}
end

--激活模块
function AddRoomPart:activate(gameId,data)
    self.game_id = gameId
	AddRoomPart.super.activate(self,CURRENT_MODULE_NAME)
	self.num_list = {}
    data = 1
	self.type = function() return data end
	self.view:initUI(self.type())
end

function AddRoomPart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view = nil
		self.num_list = {}
	end
end

function AddRoomPart:getPartId()
	-- body
	return "AddRoomPart"
end

function AddRoomPart:addNum(num)
	-- body
	if self.type() == AddRoomPart.TPYE1 then
		if #self.num_list < 6 then
			table.insert(self.num_list,num)
			self.view:showNum(num,#self.num_list)
			if #self.num_list >= 6 then
				self:addGame()
			end
		end
	elseif self.type() == AddRoomPart.TPYE2 then
		if #self.num_list < 9 then                 --ui排版用户id最大允许输入10位
			table.insert(self.num_list,num)
			self.view:showNum(table.concat(self.num_list))
		end
	end
end

function AddRoomPart:addGame()
	-- body
	if #self.num_list > 0 then
		if self.type() == AddRoomPart.TPYE1 then
			print("###[AddRoomPart:addGame] AddRoomPart.TPYE1")
			local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
			local enter_vip_room = wllobby_message_pb.ReqStartGame()
			enter_vip_room.roomid = tonumber(table.concat(self.num_list))
			enter_vip_room.gametype = 1
			enter_vip_room.tableid = "ask_enter_room"
			enter_vip_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
			self.owner:startLoading()
			net_mode:sendProtoMsg(enter_vip_room,AddRoomPart.CMD.MSG_ENTER_VIP_ROOM,self.game_id)
			print("##[AddRoomPart:addGame] ask_enter_room roomid is ", enter_vip_room.roomid)
		elseif self.type() == AddRoomPart.TPYE2 then
			print("###[AddRoomPart:addGame] AddRoomPart.TPYE2")
			local str = tonumber(table.concat(self.num_list))
			self.owner:addReferrerId(str)
			self:deactivate()
		end
	end
end

function AddRoomPart:delNum()
	-- body
	if #self.num_list > 0 then
        self.view:showNum("",#self.num_list)
		table.remove(self.num_list)
	end
end

function AddRoomPart:createGameClick()
	-- body
	self.owner:createRoom()
end

function AddRoomPart:resetNum()
	-- body
	if self.type() == AddRoomPart.TPYE1 then  --clear number
		for loop = 1, #self.num_list do
			self:delNum()
		end
	elseif self.type() == AddRoomPart.TPYE2 then --confirm
		self:addGame()
	end
end
return AddRoomPart 