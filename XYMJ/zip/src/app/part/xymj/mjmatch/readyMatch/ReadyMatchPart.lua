--[[
*名称:ReadyMatchPart
*描述:比赛准备部件
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local ReadyMatchPart = class("ReadyMatchPart",cc.load('mvc').PartBase) --登录模块
ReadyMatchPart.DEFAULT_PART = {}
ReadyMatchPart.DEFAULT_VIEW = "ReadyMatchLayer"
ReadyMatchPart.CMD = {
	MSG_CPT_PEAPLE_CMD			= 0x1010017,
	MSG_CPT_PEAPLE_ACK 			= 0x1010018,
	MATCH_BATTLE_BEGIN_MSG 	 	= 0x01010027,
}

--[
-- @brief 构造函数
--]
function ReadyMatchPart:ctor(owner)
    ReadyMatchPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function ReadyMatchPart:initialize()
	
end

--激活模块
function ReadyMatchPart:activate(game_id)
	self.game_id = game_id
	self.cpt_info 	= self.owner.cpt_info
	self.cptJoinNum = self.cpt_info.cptJoinNum
	ReadyMatchPart.super.activate(self,CURRENT_MODULE_NAME)

	--self.rewards = {}
	--self.rewards 	= self.cpt_info.championAward
	self.view:updateUI()

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(self.CMD.MSG_CPT_PEAPLE_ACK,handler(self, ReadyMatchPart.updatePeapleAck))
	net_mode:registerMsgListener(self.CMD.MATCH_BATTLE_BEGIN_MSG, handler(self, ReadyMatchPart.MatchNotify), 'ReadyMatchPart')
	self:getUpdatePeaple()
end



function ReadyMatchPart:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(self.CMD.MSG_CPT_PEAPLE_ACK)
	net_mode:unRegisterMsgListener(self.CMD.MATCH_BATTLE_BEGIN_MSG)

	self.view:removeSelf()
	self.view = nil
end

function ReadyMatchPart:getPartId()
	-- body
	return "ReadyMatchPart"
end

function ReadyMatchPart:exitMatch()
	self.owner:requestExitMatch()
end

function ReadyMatchPart:setState(state)
	self.cpt_info.state = state
	self.view:updateState()
end

--[[
@ 获取实时人数变化
]]
function ReadyMatchPart:getUpdatePeaple()
	print(self.cpt_info.state, self.last_request, os.time(), self:getVirtualNumber(), self.cpt_info.cptSize)
	if self.cpt_info.state == 4 then
		return 
	end

	-- 5秒之内，不能重复请求
	if self.last_request and os.time() - self.last_request < 5 then
		return 
	end
	self.last_request = os.time()

	local count  		= self:getVirtualNumber() or 0
	local total_count	= self.cpt_info.cptSize or 0
	if count == total_count and self.rewards and self.cpt_info.cptRule == 1 then
		return 
	end

	local cptId 		= self.cpt_info.cptId
	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqRealTimeNum()
	request.cptId 		= cptId
	request.needAward	= 1
	request.cptUniqId 	= self.cpt_info.cptUniqId
	net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_PEAPLE_CMD, self.game_id)		
end

--[[
@ 获取实时人数变化
]]
function ReadyMatchPart:updatePeapleAck(data)
	local ack = competition_pb.RealTimeNumAck()
	ack:ParseFromString(data)

	if ack.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = ack.resultMsg})
		end
		return 
	end
	print(ack)

	self.rewards = {}
	for i, infos in ipairs(ack.cptRewardInfo) do
		local rank 	= infos.rank
		local items = {}
		for i, reward in ipairs(infos.rewardItem) do
			local item_node = {
				rewardType 	= reward.rewardType,
				rewardCount	= reward.rewardCount,
			}
			table.insert(items, item_node)
		end

		local info 	= {
			rank 		= rank,
			rewardItem	= items,
		}
		table.insert(self.rewards, info)
	end

	self.cptJoinNum 				= ack.cptJoinNum
	self.owner.cpt_info.cptJoinNum 	= ack.cptJoinNum
	if self.view then
		self.view:updateUI()
	end
end

function ReadyMatchPart:MatchNotify(data)
	local match_notify 	= competition_pb.commNotify()
	match_notify:ParseFromString(data)

	local ext_data 		= match_notify.Extensions[competition_pb.commNotifyExt.ext]
	if ext_data.remainTime > 0 then
		self.owner.cpt_info.remainTime 	= ext_data.remainTime
		self.owner.cpt_info.curTime = os.time()
	end	
end

--[[
@ 虚拟报名人数
]]
function ReadyMatchPart:getVirtualNumber()
	local cptJoinNum 	= self.cptJoinNum
	local max_num 		= self.cpt_info.cptSize

	local remain_num 	= max_num - cptJoinNum
	local cptNameCode 	= self.cpt_info.cptNameCode
	-- @ 时间赛不虚拟出人数
	if self.cpt_info.cptRule == 2 then
		return cptJoinNum
	end

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

function ReadyMatchPart:backEvent()
	
end

return ReadyMatchPart 
