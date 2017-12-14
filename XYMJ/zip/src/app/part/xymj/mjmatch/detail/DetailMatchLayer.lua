--[[
*名称:DetailMatchLayer
*描述:比赛详情
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local DetailMatchLayer = class("DetailMatchLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
type: (1、钻石场， 2、活动场，3、活动场，...)
optLevel : (1、初级场，2、中级场，...)
]]

function DetailMatchLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("MatchDetail",CURRENT_MODULE_NAME)
	local scale = display.width/1280
	self.node.panel:setScale(scale)

	self.select_page = 1
	self.node.level_root:setScrollBarEnabled(false)
	self.node.match_root:setScrollBarEnabled(false)
	self.node.level_root:setItemModel(self.node.item_level)
	self.node.match_root:setItemModel(self.node.item_match)
end

function DetailMatchLayer:closeClick()   
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false) 
	self.part:deactivate()
end

--[[
@ detail 服务器返回的pb结构
]]
function DetailMatchLayer:updateUI(detail)
	self:refreshRoot()
	self:refreshItem()

	self:refreshRewards()
	self:refreshMyBattle()
end

--[[
@ 刷新奖励、规则、战绩的可见行
]]
function DetailMatchLayer:refreshRoot()
	local ui_roots = {
		[1]	= self.node.award_root,
		[2] = self.node.detail_root,
		[3] = self.node.my_battles_root,
	}

	for i, root in ipairs(ui_roots) do
		if i == self.select_page then
			root:setVisible(true)
		else
			root:setVisible(false)
		end
	end
end

--[[
@ 刷新item
]]
function DetailMatchLayer:refreshItem()
	local ui_items = {
		[1] = self.node.award_btn,
		[2] = self.node.detail_btn,
		[3] = self.node.battle_btn,
	}

	local names = {
		[1] = self.res_base .. '/award_%s.png',
		[2] = self.res_base .. '/detail_%s.png',
		[3] = self.res_base .. '/myMatch_%s.png',
	}

	for i, ui_item in ipairs(ui_items) do
		local ui_btn 	= ui_item:getChildByName('btn')
		local ui_name 	= ui_item:getChildByName('image') 

		local frame_name = ''
		if i == self.select_page then
			ui_btn:setBrightStyle(1)
			frame_name = string.format(names[i], 'select')
		else
			ui_btn:setBrightStyle(0)
			frame_name = string.format(names[i], 'normal')
		end
		ui_name:loadTexture(frame_name, 1)
	end
end


--[[
@ 刷新一条名次信息
]]
function DetailMatchLayer:refreshRewards()
	local types = {
		[1] = self.res_base .. '/zuan.png',
		[2] = self.res_base .. '/item_gold.png',
	}

	local rewards = self.part.detail.cptRewardInfo
	if #rewards < 0 then
		return 
	end

	local ui_root = self.node.match_root
	for i, items in ipairs(rewards) do
		--@ item
		local ui_item = ui_root:getItem(i - 1)
		if not ui_item then
			ui_root:insertDefaultItem(i - 1)
		end
		ui_item = ui_root:getItem(i - 1)

		--@ ui_node
		local ui_top_number = ui_item:getChildByName('top_number')
		local ui_number 	= ui_item:getChildByName('number')
		local ui_reward_root= ui_item:getChildByName('reward_root')
		ui_number:setString(tostring(i))

		-- @top1-3
		if i < 4 then
			local frame_name = string.format(self.res_base .. '/top%d.png', i)
			ui_top_number:loadTexture(frame_name, 1)
			ui_top_number:setVisible(true)
		else
			ui_top_number:setVisible(false)
		end

		-- @icon
		for k = 1, 3 do
			-- @ ui_node
			local ui_icon 		= ui_reward_root:getChildByName('item_' .. k )
			local ui_number 	= ui_reward_root:getChildByName('number_' .. k )

			local item = items[k]
			if not item then
				ui_icon:setVisible(false)
				ui_number:setVisible(false)
			else
				-- @ data
				local rewardType 	= item.rewardType
				local rewardCount	= item.rewardCount

				if types[rewardType] then
					ui_icon:loadTexture(types[rewardType], 1)
				end
				ui_number:setString(item.rewardCount)				
			end
		end
	end
end

--[[
@ 刷新我的战绩
]]
function DetailMatchLayer:refreshMyBattle()
	local ui_root = self.node.my_battles_root
	local ui_top_root	= ui_root:getChildByName('top_root')
	local ui_top_item 	= ui_root:getChildByName('top_item')
	local ui_number 	= ui_root:getChildByName('number')
	local ui_top_number = ui_root:getChildByName('top_num')
	local ui_day		= ui_root:getChildByName('day')

	local rank = self.part.detail.beastRank
	local time = self.part.detail.battleTime 

	if rank <= 0 or time <= 0 then
		ui_top_item:setVisible(false)
		ui_top_number:setVisible(false)
		ui_number:setVisible(false)
		ui_day:setVisible(false)
		return
	end

	local str = os.date("%Y年%m月%d日", time)
	ui_day:setString(str)
	ui_number:setString(tostring(rank))

	local str_top_num = string.format('第%d名', rank)
	ui_top_number:setString(str_top_num)
end

--[[
@ 分享
]]
function DetailMatchLayer:onShareClick()
	self.part:ShareToWx()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

function DetailMatchLayer:onAwardClick()
	self.select_page = 1
	self:refreshRoot()
	self:refreshItem()

	self:refreshRewards()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

function DetailMatchLayer:onDetailClick()
	self.select_page = 2
	self:refreshRoot()
	self:refreshItem()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

function DetailMatchLayer:onBattleClick()
	self.select_page = 3
	self:refreshRoot()
	self:refreshItem()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end


return DetailMatchLayer