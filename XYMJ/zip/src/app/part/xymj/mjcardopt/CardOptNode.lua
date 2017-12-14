--[[
*名称:CardOptLayer
*描述:类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CardOptNode = class("CardOptNode",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

local CURRENT_MODULE_NAME = ...
function CardOptNode:onCreate()
	-- body
	self:initWithFilePath("CardOptNode",CURRENT_MODULE_NAME) 
end

function CardOptNode:playAnimate(type)
	-- body
	-- if type == RoomConfig.AnGang 
	-- 	or type == RoomConfig.MingGang 
	-- 	or type == RoomConfig.BuGang 
	-- 	or type == RoomConfig.LaiziGang then
	-- 	print("###[CardOptNode:playAnimate(type)] 播放杠牌的动画 type ", type)
	-- 	self:playGangAni(type) 
	-- 	return 
	-- end 

	-- local animate = self.node.animation
	-- if type == RoomConfig.Peng then
	-- 	self.node.peng_sprite:show() 
	-- elseif type == RoomConfig.Chi then
	-- 	self.node.chi_sprite:show()
	-- end 
	
	-- self.node.root:stopAllActions()
	-- self.node.root:runAction(animate)
	-- animate:gotoFrameAndPlay(0,false)
	-- animate:setLastFrameCallFunc(function()
	-- 	-- body
	-- 	self.part:animateOver()
	-- end)

	if type == RoomConfig.Peng then
		self.node.peng_sprite:show()
	elseif type == RoomConfig.AnGang or type == RoomConfig.MingGang or type == RoomConfig.BuGang then
		self.node.gang_sprite:show()
	elseif type == RoomConfig.Chi then
		self.node.chi_sprite:show()
	--elseif type == RoomConfig.Hu then
	--	self.node.hu_sprite:show()
	end

	local animate = self.node.animation
	self.node.root:stopAllActions()
	self.node.root:runAction(animate)
	animate:gotoFrameAndPlay(0,false)
	animate:setLastFrameCallFunc(function()
		-- body
		self.part:animateOver()
	end)	
end

function CardOptNode:playGangAni(gangType)
	local texture = nil
	if gangType == RoomConfig.AnGang then
		texture =self.res_base ..  "/angang.png"
	elseif  gangType == RoomConfig.MingGang then
		texture = self.res_base ..  "/minggang.png"
	elseif gangType == RoomConfig.BuGang then
		texture = self.res_base ..  "/bugang.png"
	elseif gangType == RoomConfig.LaiziGang then
		texture = self.res_base ..  "/laizigang.png"
	end
	if nil == texture then
		print("###[CardOptNode:createGangAni] invalid gangType ", gangType)
		return nil
	end
	print(texture)
	local imageView = self.node.qjgang_imageview
	imageView:show()
	imageView:ignoreContentAdaptWithSize(true)
	imageView:loadTexture(texture, 1)
	imageView:setScale(0)
	imageView:setOpacity(0)

	local startAction = cc.Spawn:create(
		cc.ScaleTo:create(0.7, 1),
		cc.FadeIn:create(0.7))
	local endAction = cc.FadeOut:create(0.5)

	local function overFunc()
        self.part:animateOver()
        print("####[CardOptNode:playGangAni] aniover")
    end

	local action = cc.Sequence:create(startAction, endAction, cc.CallFunc:create(overFunc))
	imageView:runAction(action) 
end

return CardOptNode