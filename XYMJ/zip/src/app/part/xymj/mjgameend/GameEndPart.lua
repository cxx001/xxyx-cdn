--[[
*名称:GameEndLayer
*描述:结束结算界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local GameEndPart = class("GameEndPart",cc.load('mvc').PartBase) --登录模块
GameEndPart.DEFAULT_PART = {}
GameEndPart.DEFAULT_VIEW = "YNGameEndLayer"
--[
-- @brief 构造函数
--]
function GameEndPart:ctor(owner)
    GameEndPart.super.ctor(self, owner)
    self:initialize() 
end

--[
-- @override
--]
function GameEndPart:initialize()
	
end

--激活模块
function GameEndPart:activate(gameId,data , tablepos,lastRound)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	self.record_mode = data.record_mode
	GameEndPart.super.activate(self,CURRENT_MODULE_NAME)
	self.last_round = lastRound
	self.view:setData(data ,tablepos,lastRound) 
end

function GameEndPart:deactivate()
	self.view:removeSelf()
	self.view = nil
end

function GameEndPart:getPartId()
	-- body
	return "GameEndPart"
end

function GameEndPart:hideBackBtn()
	-- body
	self.view:hideBackBtn()
end

--下一局开始
function GameEndPart:nextGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_GAME_OVER_CONTINUE
	--net_mode:sendProtoMsg(player_table_operation,SocketConfig.MSG_GAME_OPERATION,SocketConfig.GAME_ID)
   	if SocketConfig.IS_SEQ == false then	
    	local buff_str = player_table_operation:SerializeToString()
    	local buff_lenth = player_table_operation:ByteSize()
    	net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_GAME_OPERATION,self.game_id)
    elseif SocketConfig.IS_SEQ == true then
   		net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_GAME_OPERATION,self.game_id)
   	end

	self:deactivate()
    if self.last_round == false then
		self.owner:nextGame()
	end

	if self.record_mode then
		self.owner:recordOver()
	end
end


--返回大厅
function GameEndPart:returnGame()
	-- body
	self:deactivate()
	--self.owner:returnGame()
	self.owner:returnLobby()
end


return GameEndPart 