--[[
*名称:CreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local NewCreateRoomPart = class("NewCreateRoomPart",import(".CreateRoomPart")) --登录模块
NewCreateRoomPart.DEFAULT_PART = {}
NewCreateRoomPart.DEFAULT_VIEW = "NewCreateRoomLayer" 
 

--激活模块
function NewCreateRoomPart:activate(gameId,data) 
    NewCreateRoomPart.super.activate(self, gameId,data)
	self:switchToGroupManager()
end
 
function NewCreateRoomPart:switchToGroupManager()
	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	self.agentFlag = game_player.agentFlag 
	local enable = self.agentFlag == 1 and true or false
	--enable = true 
	print("###NewCreateRoomPart:switchToGroupManager enable ", enable) 
	self:updateRedPoint(0)
	if not enable then
		self.view:switchToGroupManager(enable) 
		return
	end
	self.roomListPart = global:createPart("RoomListPart",self) 
	local parentNode = self.view:getRoomListPanel()
	if nil == self.roomListPart or nil == parentNode then
		print("###[NewCreateRoomPart:switchToGroupManager] nil == self.roomListPart ") 
		return
	end
	self.roomListPart:activate(self.game_id,cc.p(0,0), parentNode)  
	self.view:switchToGroupManager(enable)
	self:switchToRoomList(false)  --默认打开创建房间列表
end

function NewCreateRoomPart:switchToRoomList(enable)
	print("###[NewCreateRoomPart:switchToRoomList] enable is ", enable)
	if enable then
		self:updateRedPoint(0)
	end
	self.view:switchToRoomList(enable) 
end

function NewCreateRoomPart:requestCurrentList()
	print("###NewCreateRoomPart:requestCurrentList")
	if self.roomListPart and self.agentFlag then
		self.roomListPart:requestCurrentList(true)
	end 
end

function NewCreateRoomPart:updateRedPoint(num)
	self.view:updateRedPoint(num)
end

return NewCreateRoomPart 