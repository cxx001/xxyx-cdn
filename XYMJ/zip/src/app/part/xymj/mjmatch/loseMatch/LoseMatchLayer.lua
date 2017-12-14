--[[
*名称:LoseMatchLayer
*描述:赛事界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:lxc
*创建日期:
*修改日期:
]]
local LoseMatchLayer = class("LoseMatchLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]


--[[
type: (1、钻石场， 2、活动场，3、活动场，...)
optLevel : (1、初级场，2、中级场，...)
]]

function LoseMatchLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("loseMatchLayer",CURRENT_MODULE_NAME)
end

function LoseMatchLayer:closeClick()    
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

--[[
@ 添加标题
]]
function LoseMatchLayer:addTitle()
	local path_name = self.res_base .. '/shibaijiemian'

	local ui_root 	= self.node.root
	local size 		= ui_root:getContentSize()
	local ui_title_one = Util.createSpineAnimationLoop(path_name, '1', false)
	ui_title_one:setPosition(cc.p(size.width/2, size.height/2))
	ui_root:addChild(ui_title_one)		
end

--[[
@ 分享
]]
function LoseMatchLayer:onShareClick()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:ShareToWx()
end

--[[
@ 确定
]]
function LoseMatchLayer:onSureClick()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

--[[
@ 名次
]]
function LoseMatchLayer:refreshTopNumber(number)
	self.node.number:setString(number)
end

--[[
]]
function LoseMatchLayer:updateUI()
	self:addTitle()

	self:refreshTopNumber(self.part.player_state.cptRank)
end


return LoseMatchLayer