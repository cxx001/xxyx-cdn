--[[
*名称:WinMatchLayer
*描述:赛事界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local WinMatchLayer = class("WinMatchLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]


--[[
type: (1、钻石场， 2、活动场，3、活动场，...)
optLevel : (1、初级场，2、中级场，...)
]]

function WinMatchLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("winMatchLayer",CURRENT_MODULE_NAME)

	self.award_org_y 	= self.node.award_root:getPositionY()
	self.btn_org_y 		= self.node.btn_root:getPositionY()

	self.node.award_root:setVisible(false)
	self.node.btn_root:setVisible(false)
end

function WinMatchLayer:refreshTopNumber(number)
	self.node.top_mumber:setString(tostring(number))
end

function WinMatchLayer:closeClick()
	self.part:deactivate()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

--[[
@ 添加标题
]]
function WinMatchLayer:addTitle()
	local path_name = self.res_base .. '/shenglijiemian'

	local ui_root 	= self.node.effect_root
	local size 		= ui_root:getContentSize()


	local ui_title_one = Util.createSpineAnimation(path_name, '1', false, false)
	ui_title_one:registerSpineEventHandler(function()
		local ui_title_loop = Util.createSpineAnimationLoop(path_name, '2', false)
		ui_title_loop:setPosition(cc.p(size.width/2, size.height/2))
		ui_root:addChild(ui_title_loop)	
		ui_title_loop:setVisible(true)

		ui_title_one:setVisible(false)

		-- ui_title_loop:setOpacity(0)
		-- local fade_in = cc.FadeIn:create(0.1)
		-- ui_title_loop:runAction(fade_in)
		-- ui_title_loop:setVisible(true) 

		-- -- @ 淡入
		-- ui_title_one:setOpacity(255)
		-- local fade_out = cc.FadeOut:create(0.1)

		-- @ delay
		-- local delay_time 	= cc.DelayTime:create(0.001)
		-- local cb 			= cc.CallFunc:create(function()
		-- 	ui_title_one:setVisible(false)
		-- end)
		-- local seq 			= cc.Sequence:create(fade_out, delay_time, cb)
		-- ui_title_one:runAction(seq)

		self:awardActions()		
	end, sp.EventType.ANIMATION_COMPLETE)

	ui_title_one:setPosition(cc.p(size.width/2, size.height/2))
	ui_root:addChild(ui_title_one)		
end

--[[
]]
function WinMatchLayer:updateUI()
	self:refreshTopNumber(self.part.player_state.cptRank)
	self:addTitle()
end

--[[
@ 奖励背景actions
]]
function WinMatchLayer:awardActions()
	local ui_award_root = self.node.award_root
	ui_award_root:setVisible(true)

	-- @ 文字提示延迟显示
	local ui_award_text = self.node.award_tips
	ui_award_text:setVisible(false)
	local delay_time	= cc.DelayTime:create(0.2)
	local cb 			= cc.CallFunc:create(function()
		ui_award_text:setVisible(true)
	end)
	local seq 			= cc.Sequence:create(delay_time, cb)
	ui_award_text:runAction(seq)

	-- @ 淡入
	ui_award_root:setOpacity(0)
	local fade_in = cc.FadeIn:create(0.4)

	-- @ 移动
	ui_award_root:setPositionY(self.award_org_y - 50)
	local pos_x 	= ui_award_root:getPositionX()
	local move_to 	= cc.MoveTo:create(0.25, cc.p(pos_x, self.award_org_y))

	-- @ spawn
	local spawn = cc.Spawn:create(fade_in, move_to)
	local cb 	= cc.CallFunc:create(function()
		self:addAwardEffect(self.part.awards)
	end)
	local seq   = cc.Sequence:create(spawn, cb)
	ui_award_root:runAction(seq)
end

--[[
@ 确定、炫耀按钮actions
]]
function WinMatchLayer:btnActions()
	local btn_root = self.node.btn_root
	btn_root:setVisible(true)

	-- @ 淡入
	btn_root:setOpacity(0)
	local fade_in = cc.FadeIn:create(0.4)

	-- @ 移动
	btn_root:setPositionY(self.award_org_y - 50)
	local pos_x 	= btn_root:getPositionX()
	local move_to 	= cc.MoveTo:create(0.25, cc.p(pos_x, self.award_org_y))

	-- @ spawn、repeate
	local spawn = cc.Spawn:create(fade_in, move_to)
	local cb    = cc.CallFunc:create(function()
	end)
	local seq   = cc.Sequence:create(spawn, cb)
	btn_root:runAction(seq)
end

--[[
@ types : [1、金币， 2、钻石]
]]
function WinMatchLayer:addAwardEffect(awards)
	local types = {
		[1] = self.res_base .. '/zuan.png',
		[2] = self.res_base .. '/item_gold.png',
	}

	local offset = #awards
	if offset <= 0 then
		self:btnActions()
		return 
	end

	local ui_root 		= self.node['item_root_' .. offset]:clone()
	local ui_item_root	= self.node.item_root

	local size = ui_item_root:getContentSize()
	ui_root:setPosition(cc.p(size.width/2, size.height/2))
	ui_item_root:addChild(ui_root)

	for i, award in ipairs(awards) do
		local typ 		= award.type
		local count 	= award.count
		local ui_item 	= ui_root:getChildByName('item_' .. i )
		local ui_number = ui_root:getChildByName('item_number_' .. i ) 
		local ui_item_bg= ui_root:getChildByName('item_bg_' .. i )

		ui_item:setVisible(false)
		ui_number:setVisible(false)
		ui_item_bg:setVisible(false)

		ui_item:loadTexture(types[typ], 1)
		ui_number:setString('/' .. tostring(count) )
	end

	local function playEffect(index)
		if index < 0 or index > 3 then
			return 
		end

		local ui_item 	= ui_root:getChildByName('item_' .. index )
		local ui_number = ui_root:getChildByName('item_number_' .. index )
		local ui_item_bg= ui_root:getChildByName('item_bg_' .. index )

		ui_item:setVisible(true)
		ui_number:setVisible(true)
		ui_item_bg:setVisible(true)

		local path_name = self.res_base .. '/jianglixiaoguo'
		local ui_effect = Util.createSpineAnimation(path_name, '1', false, true, function()
			if #awards > index then
				playEffect(index+1)
			else
				--@ 奖励动画播放完毕
				self:btnActions()
			end
		end)
		local pos_x, pos_y = ui_item_bg:getPosition()
		ui_effect:setPosition(cc.p(pos_x, pos_y))
		ui_root:addChild(ui_effect)
	end

	playEffect(1)
end

--[[
@ 分享
]]
function WinMatchLayer:onShareClick()
	self.part:deactivate()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

--[[
@ 炫耀
]]
function WinMatchLayer:onXuanYao()
	self.part:shareToWx()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
end

--[[
@ 确定
]]
function WinMatchLayer:onSureClick()
	self.part:deactivate()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	--self:awardActions()
	--self:btnActions()
end

return WinMatchLayer