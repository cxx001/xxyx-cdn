--[[
*名称:DetailMatchPart
*描述:比赛详情
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local DetailMatchPart = class("DetailMatchPart",cc.load('mvc').PartBase) --登录模块
DetailMatchPart.DEFAULT_PART = {}
DetailMatchPart.DEFAULT_VIEW = "DetailMatchLayer"
DetailMatchPart.CMD = {
 	MSG_CPT_DETAIL 		= 0x01010003,
  	MSG_CPT_DETAIL_ACK 	= 0x01010004,
}

--[[
@ rewardType {1=钻石, 2=金币}
]]

--[
-- @brief 构造函数
--]
function DetailMatchPart:ctor(owner)
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".competition_pb")

    DetailMatchPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DetailMatchPart:initialize()
	
end

--激活模块
function DetailMatchPart:activate(game_id, cptId)
	self.game_id 	= game_id
	self.cptId 		= cptId
	DetailMatchPart.super.activate(self,CURRENT_MODULE_NAME)

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(self.CMD.MSG_CPT_DETAIL_ACK,handler(self,DetailMatchPart.matchDetailAck))

	self:getMatchDetail()
	--self:matchDetailAck()
end

function DetailMatchPart:deactivate()
	self.view:removeSelf()
	self.view = nil
end

function DetailMatchPart:getPartId()
	-- body
	return "DetailMatchPart"
end

--[[
@ 从服务器拉取详情
]]
function DetailMatchPart:getMatchDetail()
	local net_mode 		= global:getModuleWithId(ModuleDef.NET_MOD)
	local request 		= competition_pb.ReqCompetitionDetails()
	--request.gameId 		= self.game_id
	request.cptId 		= self.cptId
	net_mode:sendProtoMsg(request, self.CMD.MSG_CPT_DETAIL, self.game_id)
	self.owner.owner:startLoading()
end

--[[
@ 服务器返回配置信息
]]
function DetailMatchPart:matchDetailAck(data)
	self.owner.owner:endLoading()
	local net_manager = global:getNetManager()
	local details = competition_pb.CompetitionDetailsAck()
	details:ParseFromString(data)

	if details.resultCode ~= 0 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			tips_part:activate({info_txt = details.resultMsg})
		end
		return 
	end

	local cptRewardInfo = {}
	local infos = details.cptDetails.cptRewardInfo
	for i, items in ipairs(infos) do
		local items_node = {}
		for i, item in ipairs(items.rewardItem) do
			local info_node = {
				rewardType		= item.rewardType,
				rewardCount 	= item.rewardCount,
			}
			table.insert(items_node, info_node)	
		end
		table.insert(cptRewardInfo, items_node)
	end
	self.detail = {
		cptBeginTime		= details.cptDetails.cptBeginTime,
		cptEndTime 			= details.cptDetails.cptEndTime,
		cptPeriod 			= details.cptDetails.cptPeriod,
		cptDepictUrl		= details.cptDetails.cptDepictUrl,
		beastRank 			= details.cptDetails.beastRank,
		battleTime			= details.cptDetails.battleTime,
		cptRewardInfo 		= cptRewardInfo or {},
	}

	print(details)
	self.view:updateUI(self.detail)
end

function DetailMatchPart:ShareToWx()
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	--lua_bridge:ShareToWx(2)
	lua_bridge:savePicAndShare(nil, nil, nil, 2)
end

return DetailMatchPart 
