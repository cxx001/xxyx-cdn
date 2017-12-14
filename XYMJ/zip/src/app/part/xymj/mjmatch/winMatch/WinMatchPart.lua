--[[
*名称:WinMatchPart.lua
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*描述:赛事
*作者:lxc
*创建日期:
*修改日期:
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local WinMatchPart = class("WinMatchPart",cc.load('mvc').PartBase) --登录模块
WinMatchPart.DEFAULT_PART = {
}
WinMatchPart.DEFAULT_VIEW = "WinMatchLayer"

--[
-- @brief 构造函数
--]
function WinMatchPart:ctor(owner)
    WinMatchPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function WinMatchPart:initialize()
end

--激活模块
function WinMatchPart:activate(game_id, data)
	WinMatchPart.super.activate(self,CURRENT_MODULE_NAME)

	self.awards = {}
	for i, info in ipairs(data.cptRewardInfo.rewardItem) do
		local award = {
			type 	= info.rewardType,
			count 	= info.rewardCount,
		}
		table.insert(self.awards, award)
	end

	self.player_state = {
		riseType 		= data.riseType,
		allScore		= data.allScore,
		cptRank			= data.cptRank,
		cptOrderNum 	= data.cptOrderNum,
		cptRewardInfo 	= {
			rewardItem 	= self.awards,
		},
	}

	self.owner:autoNextGame(false)
	self.view:updateUI()
end

function WinMatchPart:deactivate()
	self.view:removeSelf()
	self.owner:returnLobby()
	self.view = nil
end

function WinMatchPart:getPartId()
	-- body
	return "WinMatchPart"
end

function WinMatchPart:shareToWx()
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	--lua_bridge:ShareToWx(2)
	lua_bridge:savePicAndShare(nil, nil, nil, 2)
end

return WinMatchPart 
