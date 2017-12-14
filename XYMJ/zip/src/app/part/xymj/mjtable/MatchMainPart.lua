--[[
*名称:MatchMainPart
*描述:比赛控制部件
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CURRENT_MODULE_NAME = ...

local table_part_path = PartConfig.part['TablePart']
local TablePart = require(table_part_path)
local DEFAULT_VIEW = TablePart.DEFAULT_VIEW
local MatchMainPart = class("MatchMainPart", TablePart) 
MatchMainPart.DEFAULT_VIEW = DEFAULT_VIEW

MatchMainPart.CMD = {
	MATCH_OVER_NTF			= 0x01010010,
	MATCH_STATE_NTF			= 0x10100018,

	REQ_CPT_ENTRYOUT_CMD 	= 0x01010007,
	REQ_CPT_ENTRYOUT_ACK 	= 0x01010008,

	MSG_CPT_RESULT_ACK  	= 0x01010011,
	MSG_CPT_ONEEND_ACK 		= 0x01010013,

	MATCH_SCORE_NTF			= 0x01010019,

	CPT_ENTRY_CANCAL_CMD 	= 0x01010021,
	CPT_ENTRY_CANCAL_ACK 	= 0x01010022,

	CPT_QUERY_PLAYER_INFO	= 0x01010023,
	CPT_QUERY_PLAYER_ACK	= 0x01010024,
}

local states 	= {
	t_disuse	= 0,
	t_top8		= 1,
	t_top4		= 2,
	t_ready		= 3,
}

-- local match_parts = {
-- 	"ReadyMatchPart",   -- 比赛准备
--     "WinMatchPart",     -- 比赛胜利
--     "LoseMatchPart",    -- 比赛淘汰
--     "MatchOverPart",    -- 比赛结算
-- }

--激活模块
function MatchMainPart:activate(game_id, data, cpt_info, reconnect)
	-- @ 进入桌面
	self.game_id 	= game_id
	if cpt_info then
		self.cpt_info  	= cpt_info
	end
	if reconnect then
		self.reconnect = reconnect
	end

	self.match_mode = true
	self.tableid = 2008

	MatchMainPart.super.activate(self, self.game_id, data, true)
	if not self.wifi_and_net then
	    local wifi_and_net = self:getPart("WifiAndNetPart")
	    if wifi_and_net then
	    	wifi_and_net:activate(self.game_id,self.view.node.wifi_and_net)
	    	self.wifi_and_net = wifi_and_net
	    end
    end

    if cpt_info and cpt_info.state == 4 and self.view.updateTableShow then
    	self.view:updateTableShow(data.tableinfo)
    end

	local ui_room_id 		= self.view.node.lefttop_dark_bg3
	ui_room_id:setVisible(false)

	local ui_rule			= self.view.node.table_logo_playway
	local ui_dizhu 			= self.view.node.table_dizhu
	--ui_rule:setVisible(false)
	--ui_dizhu:setVisible(false)

	-- local part_zorder = #MatchMainPart.super.DEFAULT_PART
	-- for i, part_name in ipairs(match_parts) do
	-- 	local part_path = PartConfig.part[part_name]
	-- 	if part_path then
 --            self:addPart(require(part_path).new(self))
 --        end
	-- end

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_START)

	net_mode:registerMsgListener(self.CMD.MATCH_SCORE_NTF, handler(self, MatchMainPart.scoreNtf))
	net_mode:registerMsgListener(self.CMD.MATCH_STATE_NTF, handler(self, MatchMainPart.matchStateNtf))
	net_mode:registerMsgListener(self.CMD.REQ_CPT_ENTRYOUT_ACK, handler(self, MatchMainPart.exitMatch))
	net_mode:registerMsgListener(self.CMD.MSG_CPT_RESULT_ACK, handler(self, MatchMainPart.matchOverAck))
	net_mode:registerMsgListener(self.CMD.MSG_CPT_ONEEND_ACK, handler(self, MatchMainPart.matchOverAllAck))
	net_mode:registerMsgListener(self.CMD.CPT_ENTRY_CANCAL_ACK, handler(self, MatchMainPart.exitMatchAck))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_START,handler(self, MatchMainPart.gameStartNtf)) 		--牌局开始
	net_mode:registerMsgListener(self.CMD.CPT_QUERY_PLAYER_ACK, handler(self, MatchMainPart.queryCptInfoAck))
end

function MatchMainPart:deactivate()
	MatchMainPart.super.deactivate(self)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(self.CMD.MATCH_SCORE_NTF)
	net_mode:unRegisterMsgListener(self.CMD.MATCH_STATE_NTF)
	net_mode:unRegisterMsgListener(self.CMD.REQ_CPT_ENTRYOUT_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_RESULT_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_ONEEND_ACK)
	net_mode:unRegisterMsgListener(self.CMD.CPT_ENTRY_CANCAL_ACK)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_START) 		--牌局开始
	net_mode:unRegisterMsgListener(self.CMD.CPT_QUERY_PLAYER_ACK)	
end

--[[
@ 比赛需要激活的部件
]]
function MatchMainPart:activateMatchPart(data)
	local ready_match_part = self:getPart('ReadyMatchPart')
	if ready_match_part and self.cpt_info.state ~= 4 and not self.reconnect then
		ready_match_part:activate(self.game_id)
		ready_match_part:setState(self.cpt_info.state)
	end
	self.reconnect = false

	-- @ 正在赛事中
	if self.cpt_info.state == 4 then
		self:activateDefualtPart(data)
	end

	return 
end

--[[
@ 还原比赛
]]
function MatchMainPart:revertMatch(data)
	local cpt_ack 	= data.tableinfo.Extensions[competition_pb.StartGameMsgAckExt.cptExt]
	if not cpt_ack then
		return 
	end

	local player_position	= cpt_ack.player_position
	if player_position ~= 2 then
		return 
	end
	local cptUniqId			= cpt_ack.position_id
	local query_ack 		= cpt_ack.cptInfo

	--@0、淘汰赛准备区；1、八强赛准备区; 2、决赛准备区.3已报名准备区；4、玩家比赛中状态
	local state  	= query_ack.state
	local roundNum 	= query_ack.roundNum
	local totalScore= query_ack.totalScore

	local championAwards = {}
	local cpt_info 	= query_ack.cptInfo

	local championAward = {}
	for i,award in ipairs(cpt_info.championAward.rewardItem) do
		local award_temp = {
			rewardType	= award.rewardType,
			rewardCount	= award.rewardCount,
		}
		table.insert(championAward, award_temp)
	end

	local entrys 		= {}
	local info 			= query_ack.cptInfo
	local entrys_temp	= query_ack.cptInfo.cptEntryInfo
	for i, entry in ipairs(entrys_temp) do
		local entry_node= {
			entryIconType 	= entry.entryIconType,
			entryIconCount	= entry.entryIconCount,
		}
		table.insert(entrys, entry_node)
	end

	--@ table_node
	self.cpt_info 		= {
		cptId 			= info.cptId,
		cptNameCode		= info.cptNameCode,
		cptSize 		= info.cptSize,
		cptJoinNum		= info.cptJoinNum,
		cptBeginTime 	= info.cptBeginTime,
		cptEndTime 		= info.cptEndTime,
		championAward	= championAward or {},
		cptEntryInfo	= entrys or {},
		state 			= query_ack.state,
		roundNum		= query_ack.roundNum,
		totalScore		= query_ack.totalScore,
		cptUniqId 		= cptUniqId,
		cptTitle 		= info.cptTitle,
		cptRule 		= info.cptRule,
		lastAction 		= info.lastAction,
		curTime 		= os.time(),
		remainTime		= info.cptEndTime,
	}



	local card_part =self:getPart("CardPart")
	if card_part and card_part.view and state ~= 4 then
		card_part:deactivate()
	end

	local ready_match_part = self:getPart('ReadyMatchPart')
	if ready_match_part and not ready_match_part.view and state ~= 4 then
		ready_match_part:activate(self.game_id)
	end
	ready_match_part:setState(self.cpt_info.state)
end

--[[
@ 查询玩家状态信息 
]]
function MatchMainPart:queryCptInfo(cptUniqId)
	local request 			= competition_pb.queryPlayerCptInfo()
	request.cptUniqId		= cptUniqId	
	net_mode:sendProtoMsg(request, self.CMD.CPT_QUERY_PLAYER_INFO, self.game_id)
	self.owner:startLoading()
end

function MatchMainPart:getPartId()
	-- body
	return "MatchMainPart"
end

function MatchMainPart:gameStartNtf(data,appId)
	-- body
	local game_start = xymj_message_pb.GameStartMsg()
	game_start:ParseFromString(data)
	self.playerwin = game_start.playerwin
	print("TablePart:gameStartNtf:",game_start)
	-- local ready_part = self:getPart("ReadyPart")
	-- ready_part:hideView()

	--self:activateDefualtPart(game_start)

	self.cpt_info.cptJoinNum 	= self.cpt_info.cptSize
	self.cpt_info.state 		= 4

	local ready_match_part = self:getPart('ReadyMatchPart')
	if ready_match_part and ready_match_part.view then
		ready_match_part:deactivate()
	end

	-- local ready_part = self:getPart("ReadyPart")
	-- if ready_part then
	-- 	ready_part:hideView()
	-- end

	self:startGame(game_start)
	-- if self.view and self.view.updateTableShow then
	-- 	self.view:updateTableShow(game_start)
	-- end

	-- @ 隐藏ui
	local ui_room_bg 		= self.view.node.goldOrRoomIDBg
	local ui_settings_btn 	= self.view.node.settings_btn
	local ui_dissolve_btn 	= self.view.node.dissolve_btn
	local ui_room_id 		= self.view.node.lefttop_dark_bg3
	ui_room_bg:setVisible(false)
	ui_room_id:setVisible(false)
	ui_settings_btn:setVisible(false)
	for i=1, 4 do
		local ui_offline_icon = self.view.node['offline_icon' .. i ]
		ui_offline_icon:setVisible(false)

		local ui_bank = self.view.node['bank_icon' .. i ]
		ui_bank:setVisible(false)
	end
end

--[[
@ 积分变化 
]]
function MatchMainPart:scoreNtf(data)
	local score_ntf = competition_pb.CptNotifyMsg()
	score_ntf:ParseFromString(data)
	print(score_ntf)

	local card_part = self:getPart('CardPart')
	if card_part and card_part.view then
		card_part:updateScoreNtf(score_ntf)
	end
end

--[[
@ 比赛晋级、淘汰 
]]
function MatchMainPart:matchStateNtf(data)
	local state_ntf = competition_pb.EndCptPlayerStateMsg()
	state_ntf:ParseFromString(data)
	--print(state_ntf)

	if state_ntf.uEndCptInfo.riseType == 0 then
		local win_match_part = self:getPart('WinMatchPart')
		if win_match_part then
			win_match_part:activate(self.game_id, state_ntf.uEndCptInfo)
		end
	else
		local lose_match_part = self:getPart('LoseMatchPart')
		if lose_match_part then
			lose_match_part:activate(self.game_id, state_ntf.uEndCptInfo)
		end
	end
end

function MatchMainPart:requestExitMatch()
	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqPlayerEntryCancel()
	request.cptUniqId	= self.cpt_info.cptUniqId
	request.cptRule 	= self.cpt_info.cptRule
	request.cptId 		= self.cpt_info.cptId
	net_mode:sendProtoMsg(request, self.CMD.CPT_ENTRY_CANCAL_CMD, self.game_id)
	--self.owner:startLoading()
end

--[[
@ 退出比赛
]]
function MatchMainPart:exitMatchAck(data)
	local exit_ack = competition_pb.PlayerEntryCancelAck()
	exit_ack:ParseFromString(data)

	if exit_ack.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:notScroll()
			tips_part:activate({info_txt = exit_ack.resultMsg})
			return 
		end
	end

	-- @ 已经开赛，服务器主动T出报名区
	local time_out_code = -1001
	if exit_ack.resultCode == time_out_code then
		local tips_part = global:createPart('TipsPart', self)
		if tips_part then
			tips_part:activate({info_txt = exit_ack.resultMsg, mid_click = function()
				self:deactivate()
				local user = global:getGameUser()
				local lobby_part = global:createPart("LobbyPart",user)
				lobby_part:activate(self.game_id)
				lobby_part:matchClick()
			end})
			tips_part:notScroll()
			return 
		end
	end

	self:deactivate()
	local user = global:getGameUser()
	local lobby_part = global:createPart("LobbyPart",user)
	lobby_part:activate(self.game_id)
	lobby_part:matchClick()
end

--[[
@ 根据uid查到用户信息
]]
function MatchMainPart:getPlayerByUid(uid)
	if not self.player_list then
		return 
	end
	for seat_id, player in ipairs(self.player_list) do
		if player and player.playerIndex == uid then
			return player.tablepos, player
		end		
	end
end

--[[
@ 比赛小结算
]]
function MatchMainPart:matchOverAck(data)
	local over_ack = competition_pb.EndCptPlayerResultMsg()
	over_ack:ParseFromString(data)	
	local card_part =self:getPart("CardPart")
	if card_part then
		card_part:deactivate()
	end


	local nextState = over_ack.nextOrderType
	local types = {
		[0] = states.t_disuse,
		[1] = states.t_top8,
		[2] = states.t_top4,
	}
	self.cpt_info.state = types[nextState]

	local ready_match_part = self:getPart('ReadyMatchPart')
	if ready_match_part then
		ready_match_part:activate(self.game_id, self.cpt_info.state)
		ready_match_part.view:setRootVisible(false)
	end
	
	local over_part = self:getPart('MatchOverPart')
	if over_part then
		over_part:activate(self.game_id, over_ack)
	end
end

--[[
@ 下一局游戏 
]]
function MatchMainPart:autoNextGame(show)
	local ready_match_part = self:getPart('ReadyMatchPart')
	if ready_match_part and ready_match_part.view then
		ready_match_part.view:setRootVisible(show)
	end
end

--[[
@ 晋级或失败
]]
function MatchMainPart:matchOverAllAck(data)
	local over_all_ack = competition_pb.EndCptPlayerStateMsg()
	over_all_ack:ParseFromString(data)
	print(over_all_ack)

	local over_data 			= over_all_ack.uEndCptInfo
	local over_part 			= self:getPart('MatchOverPart')
	local riseType 				= over_data.riseType

	-- @ 晋级
	if riseType == 7 then
		if over_part then
			over_part.riseType = 7
			if not over_part.view then
				over_part:activate(self.game_id)
				over_part:setData(over_data)
				over_part.view:showPromotion()
			end
			self:autoNextGame(false)
		end
	end

	local lose_part 	= self:getPart('LoseMatchPart')
	local win_part 		= self:getPart('WinMatchPart')

	local card_part =self:getPart("CardPart")
	if card_part and card_part.view then
		card_part:deactivate()
	end

	local delay_time 	= cc.DelayTime:create(10)
	local cb 			= cc.CallFunc:create(function()
		if riseType == 6 or riseType == 8 then
			local ready_match_part = self:getPart('ReadyMatchPart')
			if ready_match_part and ready_match_part.view then
				ready_match_part:deactivate()
			end

			local match_over = self:getPart('MatchOverPart')
			if match_over and match_over.view then
				match_over:deactivate()
			end
		end

		-- @ 被淘汰了
		if riseType == 6 then
			if lose_part then
				lose_part:activate(self.game_id, over_data)
			end
		end

		-- @ 胜利
		if riseType == 8 then
			if win_part then
				win_part:activate(self.game_id, over_data)
			end
		end		
	end)
	local seq 			= cc.Sequence:create(delay_time, cb)
	self.view.node.root:runAction(seq)
end

return MatchMainPart
