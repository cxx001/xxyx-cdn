--[[
*名称:ReadyMatchPart
*描述:比赛准备界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local ReadyMatchLayer = class("ReadyMatchLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...


function ReadyMatchLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("readyMatchLayer",CURRENT_MODULE_NAME)
	--cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/mjmatch/detail/res/match_detail_picture.plist")

	local delay_time 	= cc.DelayTime:create(5)
	local cb 			= cc.CallFunc:create(function()
		self.part:getUpdatePeaple()
	end)
	local seq 			= cc.Sequence:create(delay_time, cb)
	local actions 		= cc.RepeatForever:create(seq)
	self.node.root:runAction(actions)

	local scale = display.width/1280
	self.node.ui_root:setScale(scale)

	for rank=1, 3 do
		local ui_item 	= self.node['item_match_' .. rank ]
		local ui_award 	= ui_item:getChildByName('reward_root')

		for i=1, 3 do
			local ui_item 		= ui_award:getChildByName('item_' .. i )
			local ui_number 	= ui_award:getChildByName('number_' .. i )
			ui_item:setVisible(false)			
			ui_number:setVisible(false)
		end		
	end
end

function ReadyMatchLayer:closeClick()    
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

--[[
@ detail 服务器返回的pb结构
]]
function ReadyMatchLayer:updateUI()
	self:refreshAward()
	self:updateState()
	self:refreshTitle()
	--self:refreshPeaple()
end

--[[
@ 隐藏基本信息
]]
function ReadyMatchLayer:setRootVisible(show)
	self.node.ui_root:setVisible(show)
end

--[[
@ 刷新奖励
]]
function ReadyMatchLayer:refreshAward()
	for i=1, 3 do
		local ui_item = self.node['item_match_' .. i]
		ui_item:setVisible(false)
	end
	
	if not self.part.rewards then
		return 
	end

	local types = {
		[1] = self.res_base .. '/zuan.png',
		[2] = self.res_base .. '/item_gold.png',
	}

	for i, reward in ipairs(self.part.rewards) do
		local rank 				= reward.rank
		local items 			= reward.rewardItem

		if rank > 3 or rank < 1 or i > 3 then
			return 
		end

		local ui_item 			= self.node['item_match_' .. rank ]
		local ui_award 			= ui_item:getChildByName('reward_root')
		local ui_top_number 	= ui_item:getChildByName('top_number')
		ui_item:setVisible(true)
		
		-- @top1-3
		if i < 4 then
			local frame_name = string.format(self.res_base .. '/top%d.png', i)
			print(frame_name)
			ui_top_number:loadTexture(frame_name, 1)
			ui_top_number:setVisible(true)
		else
			ui_top_number:setVisible(false)
		end

		print(json.encode(items))
		for n, item in ipairs(items) do
			if n <= 3 then
				local rewardType	= item.rewardType
				local rewardCount	= item.rewardCount

				local ui_item 		= ui_award:getChildByName('item_' .. n )
				local ui_number 	= ui_award:getChildByName('number_' .. n )

				print(types[rewardType])
				ui_item:loadTexture(types[rewardType], 1)
				ui_number:setString(tostring(rewardCount))

				ui_item:setVisible(true)			
				ui_number:setVisible(true)
			end
		end
	end
end

--[[
@ 刷新标题
]]
function ReadyMatchLayer:refreshTitle()
	local title			= self.part.cpt_info.cptTitle
	local ui_title 		= self.node.title
	ui_title:setString(title or '')
end

--[[
@ 刷新人数
]]
-- function ReadyMatchLayer:refreshPeaple()
-- 	local ui_desc = self.node.desc

-- 	local count  		= self.part.cptJoinNum --self.part:getVirtualNumber() or 0
-- 	local total_count	= self.part.cpt_info.cptSize or 0

-- 	local str 			= string.format(string_table.match_tips, count, total_count - count)
-- 	ui_desc:setString(str)
-- end

function ReadyMatchLayer:addEffectMask()
	local mask_layer = cc.LayerColor:create()
    mask_layer:initWithColor(cc.c4b(0,0,0,150))
    self.node.root:addChild(mask_layer)
    mask_layer:setName('mask_layer')
    return mask_layer
end

function ReadyMatchLayer:addEffect(path_name, offset)
	if self.node.root:getChildByName('mask_layer') then
		return 
	end

	self:addEffectMask()
	local ui_effect = Util.createSpineAnimation(path_name, '1', false, true, function()
		local mask_layer = self.node.root:getChildByName('mask_layer')
		if mask_layer then
			mask_layer:removeFromParent()
		end
	end)
	local size = self.node.root:getContentSize()
	ui_effect:setPosition(cc.p(size.width/2, size.height/2 + offset))
	self.node.root:addChild(ui_effect)
end

function ReadyMatchLayer:onXixiShou()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	local path_name = self.res_base .. '/effect_xixishou/xixishou'
	self:addEffect(path_name, 0)
end

function ReadyMatchLayer:onBaiCaiShen()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	local path_name = self.res_base .. '/effect_baicaishen/baicaishen'
	self:addEffect(path_name, -100)
end

function ReadyMatchLayer:ExitClick()
	self.part:exitMatch()
end

function ReadyMatchLayer:backEvent()
	self.part:backEvent()
end

function ReadyMatchLayer:updateState()
	local str_states = {
		[0] = '正在为您匹配对手，请稍等……',
		[1] = '正在等待开始8强比赛……',
		[2] = '正在等待开始4强比赛……',
		[3] = '已报名%d人，还需%d人即可开始比赛',
	}

	local rule 	= self.part.owner.cpt_info.cptRule
	local state = self.part.cpt_info.state
	if not str_states[state] then
		return 
	end

	if self.part.cpt_info.state == 3 then
		self.node.exit_btn:setVisible(true)
	else
		self.node.exit_btn:setVisible(false)
	end

	local ui_desc 		= self.node.desc
	local count  		= self.part:getVirtualNumber() or 0
	local total_count	= self.part.cpt_info.cptSize or 0
	local str 			= string.format(str_states[state], count, total_count)
	

	-- @ 时间赛制
	if rule == 2 and self.part.cpt_info.state == 3 then
		local ui_root = self.node.remain_time
		ui_root:setVisible(true)
		ui_desc:setVisible(false)

		local function refresh()
			local cpt_info 	= self.part.owner.cpt_info
			local remainTime= cpt_info.remainTime
			local curTime 	= cpt_info.curTime
			local remain	= remainTime + curTime - os.time()
			if remain < 0 then
				self.part:getUpdatePeaple()
				return 
			end

			local ui_m_time = ui_root:getChildByName('m_time')
			local ui_s_time = ui_root:getChildByName('s_time')
			local ui_desc	= ui_root:getChildByName('desc')

			local m_time 	= math.floor(remain / 60)
			local s_time,_ 	= math.fmod(remain, 60)
			ui_m_time:setString(string.format('%02d', m_time))
			ui_s_time:setString(string.format('%02d', s_time))

			local count  	= self.part:getVirtualNumber() or 0
			local str 		= string.format('已报名%d人(最少需%d人)', count, total_count)
			ui_desc:setString(str)	
		end
		refresh()

		local delay_time 	= cc.DelayTime:create(1)
		local call_func 	= cc.CallFunc:create(function()
			refresh()
		end)
		local seq 			= cc.Sequence:create(delay_time, call_func)
		local repeate		= cc.RepeatForever:create(seq)
		ui_desc:stopAllActions()
		ui_desc:runAction(repeate)
		return 
	else
		ui_desc:setVisible(true)
		self.node.remain_time:setVisible(false)
	end
	
	ui_desc:setString(str)
	-- @ 已报名准备区
	if total_count == count and state == 3 then
		local str = '立即开赛，请稍等……'
		ui_desc:setString(str)
		return 
	end	
end

function ReadyMatchLayer:onExitCallback_()
	self.part.view = nil
end

function ReadyMatchLayer:onExit()
	self.part.view = nil
end

return ReadyMatchLayer