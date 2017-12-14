--[[
*名称:SelectMatchLayer
*描述:赛事界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local SelectMatchLayer = class("SelectMatchLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]


--[[
type: (1、钻石场， 2、活动场，3、活动场，...)
cptNameCode : (1、初级场，2、中级场，...)
]]

function SelectMatchLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("SelectMatch",CURRENT_MODULE_NAME)
	--cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/mjmatch/winMatch/res/winMatch_picture.plist")
	local scale = display.width/1280
	self.node.panel:setScale(scale)

	self.select_page = 1
	self.node.level_root:setScrollBarEnabled(false)
	self.node.match_root:setScrollBarEnabled(false)
	self.node.level_root:setItemModel(self.node.item_level)
	self.node.match_root:setItemModel(self.node.item_match)

	local delay_time 	= cc.DelayTime:create(5)
	local cb 			= cc.CallFunc:create(function()
		self.part:getBatUpdatePeaple()
	end)
	local seq 			= cc.Sequence:create(delay_time, cb)
	local actions 		= cc.RepeatForever:create(seq)
	self.node.root:runAction(actions)
end

function SelectMatchLayer:closeClick()   
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false) 
	self.part:deactivate()
end

--[[
@ match_config 服务器返回的pb结构
]]
function SelectMatchLayer:updateUI()
	local match_root = self.node.match_root
	--match_root:removeAllItems()
	local items = match_root:getItems()
	for i, item in ipairs(items) do
		item:setVisible(false)
	end

	local ui_tips = self.node.tips
	ui_tips:setVisible(false)

	self.action_types = {}
	local configs = self.part.match_config
	for i, config in ipairs(configs) do
		self:refreshMatchType(i, config)
		if i == self.select_page then
			local infos = config.cptInfos
			for index, info in ipairs(infos) do
				self:refreshMatchLevel(index, info)
			end
		end
	end
end

--[[
@ 刷新赛事类型
]]
function SelectMatchLayer:refreshMatchType(index, config)
	-- @type与资源关联
	local types = {
		[1] = self.res_base .. '/act_1_%s.png',
		[2] = self.res_base .. '/act_2_%s.png',
		[3] = self.res_base .. '/act_3_%s.png',
	}

	local level_root = self.node.level_root
	local ui_item = level_root:getItem(index - 1)
	if not ui_item then
		level_root:insertDefaultItem(index - 1)
	end
	ui_item = level_root:getItem(index - 1)

	-- @ 场次的事件
	local ui_btn = ui_item:getChildByName('btn')
	ui_btn:setTag(index)
	ui_btn:addClickEventListener(function(sender)
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		local tag = sender:getTag()
		self.select_page = tag
		self:updateUI()
	end)

	-- @ 场次名字
	local type = config.type
	if not types[type] then
		return 
	end	

	if index == self.select_page then
		if #config.cptInfos == 0 then
			self.node.tips:setVisible(true)
		else
			self.node.tips:setVisible(false)
		end
	end

	local frame_name = ''
	if self.select_page == index then
		frame_name = string.format(types[type], 'select')
		ui_btn:setBrightStyle(1)
	else
		frame_name = string.format(types[type], 'normal')
		ui_btn:setBrightStyle(0)
	end
	local ui_name = ui_item:getChildByName('image')
	ui_name:loadTexture(frame_name, 1)
end

--[[
@ 刷新一条赛事
]]
function SelectMatchLayer:refreshMatchLevel(index, info)
	if os.time() > info.remainTime and info.cptRule == 1 then
		return
	end

	-- @level与资源关联
	local levels = {
		[1]	= self.res_base .. '/level_1.png',
		[2] = self.res_base .. '/level_2.png',
	}
	local types = {
		[1] = self.res_base .. '/zuan.png',
		[2] = self.res_base .. '/item_gold.png',
	}

	local match_root = self.node.match_root
	local ui_item = match_root:getItem(index-1)
	if not ui_item then
		match_root:insertDefaultItem(index-1)
	end
	ui_item = match_root:getItem(index-1)
	ui_item:setVisible(true)

	local ui_level 			= ui_item:getChildByName('level_1')
	local ui_top_award 		= ui_item:getChildByName('top_award')
	local ui_people_num 	= ui_item:getChildByName('people_num')
	local ui_detail 		= ui_item:getChildByName('btn_detail')
	local ui_singup_node	= ui_item:getChildByName('singup_node')
	local ui_singup_number 	= ui_singup_node:getChildByName('number')
	local ui_singup_icon 	= ui_singup_node:getChildByName('icon')
	local ui_countdown_node = ui_item:getChildByName('countdown_node')
	local ui_time 			= ui_countdown_node:getChildByName('time')
	local ui_select_btn 	= ui_item:getChildByName('select_btn')
	local ui_award_icon 	= ui_item:getChildByName('award_icon')
	local ui_remain_time 	= ui_item:getChildByName('remain_time')
	local ui_action 		= ui_item:getChildByName('action')
	local ui_m_time 		= ui_remain_time:getChildByName('m_time')
	local ui_s_time 		= ui_remain_time:getChildByName('s_time')
	local ui_timeout 		= ui_item:getChildByName('btn_over')

	--@ 第一名奖励
	if #info.championAward > 0 then
		local typ 	= info.championAward[1].rewardType
		local count = info.championAward[1].rewardCount
		if types[typ] then
			ui_award_icon:loadTexture(types[typ], 1)
			ui_top_award:setString(tostring(count or 0))
		end		
	end
	
	--@ 人数
	local vir_number = self.part:getVirtualNumber(info.cptId) --info.cptJoinNum
	local str = string.format(string_table.match_people, vir_number, info.cptSize)
	ui_people_num:setString(tostring(str))

	--@ 比赛级别
	local title = info.cptTitle
	ui_level:setString(title or '')
	
	-- @详情
	ui_detail:setTag(info.cptId)
	ui_detail:addClickEventListener(function(sender)
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		local tag = sender:getTag()
		self.part:detailClick(tag)
	end)

	ui_item:setTag(info.cptId)
	ui_item:addClickEventListener(function(sender)
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		local tag = sender:getTag()
		self.part:detailClick(tag)
	end)

	-- @参加
	ui_select_btn:setTag(info.cptId)
	ui_select_btn:addClickEventListener(function(sender)
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		if not ui_singup_node:isVisible() then
			return 
		end

		if not info.applyAuthority then
			self.part:tipsApplyAuthority()
			return 
		end

		if info.cptOver then
			self.part:cptOver()
			return 
		end

		local tag = sender:getTag()
		self.part:singupClick(tag)
	end)

	-- @ 截至报名
	ui_timeout:addClickEventListener(function(sender)
		self.part:cptOver()
	end)

	-- @ 只取array第一个
	if #info.cptEntryInfo == 0 then
		ui_singup_number:setVisible(false)
		ui_singup_icon:setVisible(false)
	elseif #info.cptEntryInfo > 0 then
		local need_item = info.cptEntryInfo[1]
		local typ 		= need_item.entryIconType
		local number 	= need_item.entryIconCount
		ui_singup_icon:loadTexture(types[typ], 1)
		ui_singup_number:setString(tostring(number))
		if number <= 0 then
			ui_singup_number:setVisible(false)
			ui_singup_icon:setVisible(false)
		end		
	end

	-- @ 比赛时间
	local start_time 	= os.date('%H:%M', info.cptBeginTime)
	local end_time 		= os.date('%H:%M', info.remainTime)
	local str = string.format('%s-%s', start_time, end_time)
	ui_time:setString(str)

	-- @ 是否时间赛制
	if info.cptRule == 2 then
		local function refreshRemain()
			local cptId 	= info.cptId
			local cpt_info	= self.part:getMatchData(cptId)
			local remain 	= cpt_info.remainTime + cpt_info.curTime - os.time()
			if remain < 0 then
				remain = 0
				self.part:getMatchConfig()
				return 
			end


			local m_time 	= math.floor(remain / 60)
			local s_time,_ 	= math.fmod(remain, 60)

			ui_m_time:setString(string.format('%02d', m_time))
			ui_s_time:setString(string.format('%02d', s_time))
		end
		refreshRemain()

		local delay_time 	= cc.DelayTime:create(1)
		local call_func 	= cc.CallFunc:create(function()
			refreshRemain()
		end)
		local seq 			= cc.Sequence:create(delay_time, call_func)
		local repeate		= cc.RepeatForever:create(seq)
		ui_m_time:runAction(repeate)
	else
		ui_remain_time:setVisible(false)
	end

	-- @ 是否加上标识
	if info.lastAction ~= 0 then
		ui_action:setVisible(true)
	else
		ui_action:setVisible(false)
	end

	-- @ 按钮显示逻辑
	local function refresh()
		if info.cptOver then
			ui_timeout:setVisible(true)
			ui_countdown_node:setVisible(false)
			ui_singup_node:setVisible(false)
			return 
		end
		ui_timeout:setVisible(false)

		if info.cptRule == 2 then
			ui_countdown_node:setVisible(false)
			ui_singup_node:setVisible(true)			
			return 
		end

		local time = os.time()
		if time >= info.cptBeginTime and 
			time <= info.cptEndTime then
			ui_countdown_node:setVisible(false)
			ui_singup_node:setVisible(true)	
		elseif 	time >= info.cptEndTime then
			self:updateUI()
			return 
		else
			ui_countdown_node:setVisible(true)
			ui_singup_node:setVisible(false)				
		end
	end
	refresh()

	-- @ 时间到了，切换到报名
	local delay_time 	= cc.DelayTime:create(1)
	local cb 			= cc.CallFunc:create(function()
		refresh()
		ui_countdown_node:stopAllActions()
	end)
	local seq 			= cc.Sequence:create(delay_time, cb)
	local repeate		= cc.RepeatForever:create(seq)
	ui_countdown_node:runAction(repeate)

	--@ 报名时间是否已经超过
	if info.cptOver then
		ui_timeout:setVisible(true)
		ui_countdown_node:setVisible(false)
		ui_singup_node:setVisible(false)
	else
		ui_timeout:setVisible(false)
	end
end

return SelectMatchLayer