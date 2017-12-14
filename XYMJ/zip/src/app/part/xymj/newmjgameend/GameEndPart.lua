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
function GameEndPart:activate(gameId,data , tablepos,lastRound,curHand,totalHand, cardPart)
	self.game_id = gameId
	GameEndPart.super.activate(self, CURRENT_MODULE_NAME)
	self.last_round = lastRound
	print("tableid----------------------:"..self.owner.tableid)      
	self.view:setCardPart(cardPart)
	self.view:setData(data ,tablepos,lastRound,curHand,totalHand,self.owner.tableid)
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
	-- bodyRecordLayer
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = RoomConfig.MAHJONG_OPERTAION_GAME_OVER_CONTINUE
	net_mode:sendProtoMsg(player_table_operation,SocketConfig.MSG_GAME_OPERATION,SocketConfig.GAME_ID)
	self:deactivate()
    if self.last_round == false then
		self.owner:nextGame()
	end
end


--返回大厅
function GameEndPart:returnGame()
	-- body
	self:deactivate()
	--self.owner:returnGame()
	self.owner:returnLobby()
end

--获取吃碰杠的来源		
--根据服务器端的玩家位置找出名字
--:offNum -1上家，0对家，1下家
function GameEndPart:getChiPengGangName(pos,offNum,dataa)
	local name = "XXXX"
	if offNum < -1 or offNum > 1 then
		return ""
	end

	if pos == nil or pos< 0 or pos > 3 then
		return ""
	end

	if offNum ~=-1 and offNum ~=0 and offNum~=1 then
		return ""
	end
	
	if offNum == 0 then 
		offNum = 2  --方便直接转成对家的坐标，对家坐标跟自己坐标差2
	end

	for i,v in ipairs(dataa.players) do
		local table_pos = (pos + offNum+4)%4
		print("this is getChiPengGangName--------:",pos,table_pos)
		if v.tablepos == table_pos then
			name=v.name
			print("tablepostablepostableposnamenamename:"..name)
			break
		end
	end
		return name
end


return GameEndPart 