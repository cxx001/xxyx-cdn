--[[
*名称:SelectMatchPart
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*描述:赛事
*作者:lxc
*创建日期:
*修改日期:
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local SelectMatchPart = class("SelectMatchPart",cc.load('mvc').PartBase) --登录模块
SelectMatchPart.DEFAULT_PART = {
	'DetailMatchPart',
	'MatchOverPart',
	'WinMatchPart',
	'LoseMatchPart',
	'ReadyMatchPart',
}
SelectMatchPart.DEFAULT_VIEW = "SelectMatchLayer"
SelectMatchPart.CMD = {
 	MSG_CPT_LIST 		= 0x1010001,
  	MSG_CPT_LIST_ACK 	= 0x1010002,

	MSG_CPT_ENTRY_CMD	= 0x1010005,
	MSG_CPT_ENTRY_ACK	= 0x1010006,


	MSG_CPT_PEAPLE_CMD	= 0x1010017,
	MSG_CPT_PEAPLE_ACK 	= 0x1010018,

	MSG_CPT_PEAPLE_BAT_CMD 	= 0x01010025,
	MSG_CPT_PEAPLE_BAT_ACK 	= 0x01010026,
}

--[
-- @brief 构造函数
--]
function SelectMatchPart:ctor(owner)
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".competition_pb")

    SelectMatchPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function SelectMatchPart:initialize()
	-- self.singups = {
	-- 	[1001] 	 = {
	-- 		join_count 	= 1,
	-- 		all_count 	= 32,
	-- 	},
	-- 	[1002]	= {
	-- 		join_count 	= 10,
	-- 		all_count	= 64,
	-- 	},
	-- }
end

--激活模块
function SelectMatchPart:activate(game_id)
	self.game_id = game_id
	SelectMatchPart.super.activate(self,CURRENT_MODULE_NAME)

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_LIST_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_ENTRY_ACK)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OVER_ACK)

	net_mode:registerMsgListener(self.CMD.MSG_CPT_LIST_ACK,handler(self,SelectMatchPart.matchConfigAck))
	net_mode:registerMsgListener(self.CMD.MSG_CPT_ENTRY_ACK, handler(self, SelectMatchPart.singupAck))
	net_mode:registerMsgListener(self.CMD.MSG_CPT_PEAPLE_ACK, handler(self, SelectMatchPart.updatePeapleAck))
	net_mode:registerMsgListener(self.CMD.MSG_CPT_PEAPLE_BAT_ACK, handler(self, SelectMatchPart.updatePeapleBatAck))

	self:getMatchConfig(true)

	net_mode:addEventListener('onNotify', function(event)
		if event.code == NET_STATE.CONNECT_CHECK_OK then
			self.owner:endLoading()
			--self:getMatchConfig()
		end
	end)
end

function SelectMatchPart:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_LIST_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_ENTRY_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_PEAPLE_ACK)

	self.view:removeSelf()
	self.view = nil
end

function SelectMatchPart:getPartId()
	-- body
	return "SelectMatchPart"
end

function SelectMatchPart:cptOver()
	local tips_part = global:createPart("TipsPart", self)
	if tips_part then
		tips_part:activate({info_txt = '比赛场次已满'})
		tips_part:notScroll()
		return 
	end
end


--[[
@ 打开详情
]]
function SelectMatchPart:detailClick(id)
	local detail_part = self:getPart('DetailMatchPart')
	if detail_part then
		detail_part:activate(self.game_id, id)
	end
end

--[[
@ 参加比赛
]]
function SelectMatchPart:singupClick(id)
	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqPlayerEntry()
	request.cptId 		= id
	net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_ENTRY_CMD, self.game_id)
	self.owner:startLoading()	
end

--[[
@ 参加比赛返回
]]
function SelectMatchPart:singupAck(data)
	self.owner:endLoading()
	local net_manager = global:getNetManager()
	local singup_ack = competition_pb.PlayerEntryAck()
	singup_ack:ParseFromString(data)

	print(singup_ack)
	if singup_ack.resultCode == -12 then
		-- @ 已经在vip场次
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = singup_ack.resultMsg, left_click = function()
				local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
				local req_enter_room = ReqStartGame_pb.ReqStartGame()
				req_enter_room.roomid = 2002
				req_enter_room.gametype = 1
				req_enter_room.supportReadyBeforePlaying = 2
				req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
				self.owner:startLoading()
				net_mode:sendProtoMsg(req_enter_room,self.owner.CMD.MSG_REQUEST_START_GAME,SocketConfig.GAME_ID)
			end, right_click = function()
				
			end})
			tips_part:notScroll()
			return 
		end
	end

	if singup_ack.resultCode == -8 then
		-- @ 钻石不够
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = singup_ack.resultMsg, mid_click = function()
				local purchase_part = self.owner:getPart("PurchasePart")
				if purchase_part then
					purchase_part:activate(self.game_id)
				end
				self:deactivate()
			end})
			tips_part:notScroll()
			return 
		end
	end

	if singup_ack.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = singup_ack.resultMsg})
			tips_part:notScroll()
		end
		return 
	end

	self.cpt_info 				= self:getMatchData(singup_ack.cptId)
	self.cpt_info.cptJoinNum	= singup_ack.cptJoinNum
	self.cpt_info.cptUniqId		= singup_ack.cptUniqId
	self.cpt_info.remainTime 	= singup_ack.remainTime
	self.cpt_info.curTime 		= os.time()

	-- @ 报名成功准备区
	self.cpt_info.state			= 3	
	if not self.cpt_info then
		print('get match info error', singup_ack.cptId, json.encode(self.match_config))
		return 
	end

	self:deactivate()
	self.owner:startMatch(self.cpt_info, {})
end

--[[
@ 从服务器拉取配置信息
]]
function SelectMatchPart:getMatchConfig(show_loading)
	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqCompetitionList()
	--request.gameId 		= self.game_id

	-- 5秒之内，不能重复请求
	if not show_loading then
		if self.last_request and os.time() - self.last_request < 5 then
			return 
		end
	end
	self.last_request = os.time()

	net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_LIST, self.game_id)
	if show_loading then
		self.owner:startLoading()
	end
end

--[[
@ 获取实时人数变化
]]
function SelectMatchPart:getUpdatePeaple()
	if not self.match_config then
		return 
	end

	local cptIds = {}
	for i, config in ipairs(self.match_config) do
		local infos = config.cptInfos
		for k, info in ipairs(infos) do
			table.insert(cptIds, info.cptId)
		end
	end

	for i, cptId in ipairs(cptIds) do
		local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
		local request 		= competition_pb.ReqRealTimeNum()
		request.cptId 		= cptId
		request.needAward	= 0
		request.cptUniqId	= ''
		net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_PEAPLE_CMD, self.game_id)		
	end
end


--[[
@ 获取实时人数变化
]]
function SelectMatchPart:updatePeapleAck(data)
	local ack = competition_pb.RealTimeNumAck()
	ack:ParseFromString(data)

	if ack.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = ack.resultMsg})
		end
		tips_part:notScroll()
		return 
	end

	--print(ack)
	local cptId 	= ack.cptId
	local info = self:getMatchData(cptId)
	info.cptJoinNum = ack.cptJoinNum
	self.view:updateUI()
end

--[[
@ 批量请求实时人数变化
]]
function SelectMatchPart:getBatUpdatePeaple()
	if not self.match_config then
		return 
	end
	
	local cptIds = {}
	for i, config in ipairs(self.match_config) do
		local infos = config.cptInfos
		for k, info in ipairs(infos) do
			table.insert(cptIds, info.cptId)
		end
	end

	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqRealTimeNums()

	for i, cptId in ipairs(cptIds) do
		local request_node 		= request.joins:add()
		request_node.cptId 		= cptId
		request_node.needAward	= 0
		request_node.cptUniqId	= ''
	end	
	net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_PEAPLE_BAT_CMD, self.game_id)		
end

--[[
@ 批量获取实时人数变化
]]
function SelectMatchPart:updatePeapleBatAck(data)
	local ack = competition_pb.RealTimeNumAcks()
	ack:ParseFromString(data)

	for i, join in ipairs(ack.joins) do
		if join.resultCode == 0 then
			local cptId 	= join.cptId
			local info 		= self:getMatchData(cptId)
			info.cptJoinNum = join.cptJoinNum	
			info.cptOver 	= join.cptOver
		end
	end

	self.view:updateUI()
end

--[[
@ 服务器返回配置信息
]]
function SelectMatchPart:matchConfigAck(data)
	self.owner:endLoading()
	local net_manager = global:getNetManager()
	local match_config = competition_pb.CompetitionListAck()
	match_config:ParseFromString(data)

	if match_config.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = match_config.resultMsg})
		end
		tips_part:notScroll()
		return 
	end
	print(match_config)
	
	self.match_config = {}
	for i, config in ipairs(match_config.configs) do
		local infos 	= {}
		local typ 		= config.type
		local infos_temp= config.cptInfos
		for i, info in ipairs(infos_temp) do
			local championAward = {}
			for i,award in ipairs(info.championAward.rewardItem) do
				local award_temp = {
					rewardType	= award.rewardType,
					rewardCount	= award.rewardCount,
				}
				table.insert(championAward, award_temp)
			end

			local entrys 		= {}
			local entrys_temp	= info.cptEntryInfo
			for i, entry in ipairs(entrys_temp) do
				local entry_node= {
					entryIconType 	= entry.entryIconType,
					entryIconCount	= entry.entryIconCount,
				}
				table.insert(entrys, entry_node)
			end

			--@ table_node
			local info_node 	= {
				cptId 			= info.cptId,
				cptNameCode		= info.cptNameCode,
				cptSize 		= info.cptSize,
				cptJoinNum		= info.cptJoinNum,
				cptBeginTime 	= info.cptBeginTime,
				cptEndTime 		= info.cptEndTime,
				championAward	= championAward or {},
				cptEntryInfo	= entrys or {},
				cptTitle		= info.cptTitle,
				cptRule 		= info.cptRule,
				lastAction 		= info.lastAction,
				curTime 		= os.time(),
				cptShowLine 	= info.cptShowLine,
				applyAuthority 	= info.applyAuthority,
				cptOver 		= info.cptOver,
				remainTime 		= info.cptEndTime,
			}
			table.insert(infos, info_node)
		end
		local config_node = {
			type 	= typ,
			cptInfos= infos,
		}
		table.insert(self.match_config, config_node)
	end

	for i, config in ipairs(self.match_config) do
		local cptInfos = config.cptInfos
		table.sort(cptInfos, function(a, b)
			if a.cptShowLine < b.cptShowLine then
				return true
			else
				return false
			end
		end)
	end

	self.view:updateUI()
end

--[[
@ 获取比赛数据
]]
function SelectMatchPart:getMatchData(cptId)
	for i, config in ipairs(self.match_config) do
		local infos = config.cptInfos
		for k, info in ipairs(infos) do
			if info.cptId == cptId then
				return info
			end
		end
	end
end

--[[
@ 虚拟报名人数
]]
function SelectMatchPart:getVirtualNumber(cptId)
	local info = self:getMatchData(cptId)
	if not info then
		return 
	end

	local cptJoinNum 	= info.cptJoinNum
	local max_num 		= info.cptSize

	if info.cptRule == 2 then
		return cptJoinNum
	end

	local remain_num 	= max_num - cptJoinNum
	local cptNameCode 	= info.cptNameCode
	if cptNameCode == 1 then
		if remain_num <= 2 then
			return cptJoinNum
		end

		if remain_num > 2 and remain_num < 20 then
			return cptJoinNum + 1
		end

		if remain_num >= 20 then
			return cptJoinNum + 2
		end

	elseif cptNameCode == 2 then

		if remain_num <= 4 then
			return cptJoinNum 
		end

		if remain_num > 4 and remain_num < 10 then
			return cptJoinNum + 1
		end

		if remain_num >= 10 and remain_num < 20 then
			return cptJoinNum + 2
		end

		if remain_num >= 20 and remain_num < 35 then
			return cptJoinNum + 3
		end

		if remain_num >= 35 then
			return cptJoinNum + 4
		end 
	end

	return cptJoinNum
end

function SelectMatchPart:tipsApplyAuthority()
	local tips = '未获得资格，请阅读公告报名或联系客服'
	local tips_part = global:createPart("TipsPart", self)
	if tips_part then
		tips_part:activate({info_txt = tips})
		tips_part:notScroll()
	end
end

return SelectMatchPart 
