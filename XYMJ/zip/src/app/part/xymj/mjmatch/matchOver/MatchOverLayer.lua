--[[
*名称:MatchOverLayer
*描述:比赛详情
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local MatchOverLayer = class("MatchOverLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
type: (1、钻石场， 2、活动场，3、活动场，...)
optLevel : (1、初级场，2、中级场，...)
]]

function MatchOverLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("MatchOver",CURRENT_MODULE_NAME)

	self.node.detail_root:setVisible(true)
	self.node.promotion_root:setVisible(false)
	self:delayShowPromotion()

	local scale = display.width/1280
	self.node.detail_root:setScale(scale)
	self.node.promotion_root:setScale(scale)
end

function MatchOverLayer:onCloseClick()    
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	local ui_detail_root 	= self.node.detail_root
	local ui_promotion_root = self.node.promotion_root
	if ui_detail_root:isVisible() then
		self:showPromotion()
	else
		self.part:deactivate()	
	end
end

--[[
@ 5秒自动关闭结算
]]
local auto_kill_time = 10
function MatchOverLayer:delayShowPromotion()
	self.node.root:stopAllActions()

	local delay_time = cc.DelayTime:create(auto_kill_time)
	local call_func = cc.CallFunc:create(function()
		self:showPromotion()
	end)
	local seq = cc.Sequence:create(delay_time, call_func)
	self.node.root:runAction(seq)
end

function MatchOverLayer:addEffect(effect_name, root, cb)
	root:setVisible(true)
	local spine	= Util.createSpineAnimation(effect_name, '1')
	local size = root:getContentSize()
	spine:setPosition(cc.p(size.width/2, size.height/2))
	root:addChild(spine)

	local call_func = cc.CallFunc:create(function()
		-- @ todo
		local spine = Util.createSpineAnimationLoop(effect_name, '2')
		spine:setPosition(cc.p(size.width/2, size.height/2))
		root:addChild(spine)
		spine:setName('spine')
		spine:setVisible(false)
		if cb then
			cb()
		end
	end)
	local delay_time= cc.DelayTime:create(0.138)
	local seq 		= cc.Sequence:create(delay_time, call_func)
	root:runAction(seq)
end

function MatchOverLayer:showPromotion()
	self.node.root:stopAllActions()
	if self.part.riseType ~= 7 then
		return 
	end

	local ui_root 		= self.node.promotion_root
	local ui_top_node1	= ui_root:getChildByName('top_node_1')
	local ui_top_node2 	= ui_root:getChildByName('top_node_2')
	local ui_top_node3 	= ui_root:getChildByName('top_node_3')
	print(ui_top_node1, ui_top_node3)
	local max_desc 		= ui_top_node3:getChildByName('desc')
	local mid_desc 		= ui_top_node2:getChildByName('desc')

	local level 		= self.part.cptLevel or 1
	local totalNum		= self.part.totalNum or 32

	local str = string.format('打立出局(%d进%d)', totalNum, totalNum/2)
	max_desc:setString(str)

	local str = string.format('打立出局(%d进4)', totalNum/2)
	mid_desc:setString(str)

	self.node.promotion_root:setVisible(true)
	self.node.detail_root:setVisible(false)

	local delay_time = cc.DelayTime:create(auto_kill_time)
	local call_func = cc.CallFunc:create(function()
		self.part:autoNextGame()
	end)
	local seq = cc.Sequence:create(delay_time, call_func)
	self.node.root:runAction(seq)

	local ui_nodes = {
		[1] = self.node.top_node_3,
		[2] = self.node.top_node_2,
		[3] = self.node.top_node_1,
	}
	for i, ui_node in ipairs(ui_nodes) do
		ui_node:setVisible(false)
	end

	self:addEffect(self.res_base .. '/title/ssjj_title_effect', self.node.win_title)
	self:addEffect(self.res_base .. '/orang/ssjj_frameo_effect', self.node.top_node_3, function()
		self:addEffect(self.res_base .. '/yellow/ssjj_framey_effect', self.node.top_node_2, function()
			self:addEffect(self.res_base .. '/green/ssjj_frameg_effect', self.node.top_node_1, function()
				local ui_level = self.node['top_node_' .. level]
				local ui_spine = ui_level:getChildByName('spine')
				if ui_spine then
					ui_spine:setVisible(true)
				end
			end)	
		end)	
	end)

end

--[[
@ 刷新比赛类型，比赛局数
]]
function MatchOverLayer:refreshMatchUI()
	local types = {
		[0]	= self.res_base .. '/taotaisai.png',
		[1]	= self.res_base .. '/baqiangsai.png',
		[2]	= self.res_base .. '/juesai.png',
	}

	-- @ data
	local over_data = self.part.over_data
	local round 	= over_data.cptOrderNum
	local typ 		= over_data.typ	

	-- @ ui_node
	local ui_match_type = self.node.match_type
	local ui_cur_ju 	= self.node.cur_ju
	ui_cur_ju:setString(round)

	if types[typ] then
		ui_match_type:loadTexture(types[typ], 1)
	end
end

--[[
@ 刷新玩家的分数
]]
function MatchOverLayer:refreshPlayerScore()
	local over_data = self.part.over_data
	local users 	= over_data.PlayerSInfo
	for i, user in ipairs(users) do
		local name 		= user.name
		local score 	= user.thisScore
		local time_score= user.extrTimeScore
		local all_score = user.allScore
		local operation = user.operation
		local seat_id 	= user.playerPos
		local my_seat_id= self.part.owner.m_seat_id
		print(seat_id, my_seat_id)
		local view_id 	= self.part:getViewId(my_seat_id, seat_id)

		local ui_item 			= self.node['seat_' .. view_id ]
		local ui_name 			= ui_item:getChildByName('name')
		local ui_win_score		= ui_item:getChildByName('win_score')
		local ui_lose_score 	= ui_item:getChildByName('lose_score')
		local ui_time_score 	= ui_item:getChildByName('win_score_0')
		local ui_win_all_score 	= ui_item:getChildByName('all_win_score')
		local ui_lose_all_socre = ui_item:getChildByName('all_lose_score')
		local ui_action 		= ui_item:getChildByName('action')
		local ui_desc 			= ui_item:getChildByName('desc')

		ui_name:setString(name)		
		ui_time_score:setString(time_score)
		ui_desc:setString(user.desc)

		ui_win_all_score:setVisible( all_score >= 0 )
		ui_lose_all_socre:setVisible( all_score < 0 )
		ui_win_all_score:setString(  tostring(all_score) )
		ui_lose_all_socre:setString('/' .. math.abs(all_score) )


		-- @当局积分
		ui_win_score:setVisible( score >= 0 )
		ui_lose_score:setVisible( score < 0 )
		ui_win_score:setString( string.format('%+d', score) )
		ui_lose_score:setString(string.format('%+d', score) )
		if score == 0 then
			ui_win_score:setString(tostring(score))
		end

		local operation = user.huResult

		-- @胡牌的类型
		local operations = {
			[1] = self.res_base .. '/zimo.png',
			[2] = self.res_base .. '/hu.png',
			[3]	= self.res_base .. '/dianpao.png',
			[4] = self.res_base .. '/liuju.png'
		}
		if not operations[operation] then
			ui_action:setVisible(false)
		else
			ui_action:loadTexture(operations[operation], 1)			
		end
	end	
end

--[[
@ 服务器返回的pb结构
]]
function MatchOverLayer:updateUI()
	self:refreshMatchUI()
	self:refreshPlayerScore()
end

function MatchOverLayer:onExitCallback_()
	self.part.view = nil
end

function MatchOverLayer:onExit()
	self.part.view = nil
end

return MatchOverLayer