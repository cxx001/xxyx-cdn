--[[
*名称:MatchOverPart(比赛小结算)
*描述:比赛详情
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local MatchOverPart = class("MatchOverPart",cc.load('mvc').PartBase) --登录模块
MatchOverPart.DEFAULT_PART = {}
MatchOverPart.DEFAULT_VIEW = "MatchOverLayer"

--[[
@ rewardType {1=钻石, 2=金币}
]]

--[
-- @brief 构造函数
--]
function MatchOverPart:ctor(owner)
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".competition_pb")

    MatchOverPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function MatchOverPart:initialize()
	
end

--激活模块
function MatchOverPart:activate(game_id, data)
	MatchOverPart.super.activate(self,CURRENT_MODULE_NAME)
	if not data then
		return 
	end

	print(data)

	local players = {}
	for i, player_info in ipairs(data.PlayerSInfo) do
		local info = {
			playerPos		= player_info.player.tablepos,
			name 			= player_info.player.name,
			allScore		= player_info.allScore,
			thisScore		= player_info.thisScore,
			extrTimeScore 	= player_info.extrTimeScore,
			lastOperation 	= player_info.lastOperation,
			desc 			= player_info.player.desc,
			huResult		= player_info.player.huResult,
		}
		table.insert(players, info)
	end

	self.over_data 	= {
		typ 		= data.cptOrderType,
		cptOrderNum	= data.cptOrderNum,
		PlayerSInfo = players,
	}
	self.riseType = nil
	self.view:updateUI()
end

function MatchOverPart:getTop()
	-- @ 若不是晋级状态
	if self.riseType ~= 7 then
		return nil
	end

	local typ 		= self.over_data.typ
	local ju 		= self.over_data.cptOrderNum
	local level 	= self.owner.cpt_info.cptNameCode

	-- @32, 64人比赛
	if level == 1 then
		if typ == 0 then
			local tops = {
				[1] = 16,
				[2] = 8,
				[3] = 4,
			}
			return tops[ju]
		end

		return 4
	elseif level == 2 then
		if typ == 0 then
			local tops = {
				[1] = 32,
				[2] = 16,
				[3] = 8,
				[4] = 4,
			}
			return tops[ju]
		else
			return 4
		end
	end
end

function MatchOverPart:setData(over_data)
	self.cptLevel = over_data.cptLevel
	self.totalNum = over_data.totalNum
end

function MatchOverPart:deactivate()
	self.view:removeSelf()
	self.view = nil
end

function MatchOverPart:getPartId()
	-- body
	return "MatchOverPart"
end

--[[
@ 逻辑座位号转成视图座位号
]]
function MatchOverPart:getViewId(my_seat_id, seat_id)
	if my_seat_id then
		return (seat_id - my_seat_id + 4)%4 + 1
	end 
end

--[[
@ 自动进入下一局
]]
function MatchOverPart:autoNextGame()
	self:deactivate()
	self.owner:autoNextGame(true)
end

--[[
@ 关闭
]]
function MatchOverPart:closeClick()
	self:deactivate()
end

return MatchOverPart 
