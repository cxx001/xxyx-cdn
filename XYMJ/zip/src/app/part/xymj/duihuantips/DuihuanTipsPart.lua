--[[
*名称:DuihuanTipsLayer
*描述:兑换提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local DuihuanTipsPart = class("DuihuanTipsPart",cc.load('mvc').PartBase) --登录模块
DuihuanTipsPart.DEFAULT_VIEW = "DuihuanTipsLayer"
DuihuanTipsPart.ZORDER = 255

DuihuanTipsPart.TEXT_ZDL = 1  --文字+知道了按钮
DuihuanTipsPart.ITEMS_ZDL = 2  --恭喜您，获得+奖励内容+知道了按钮
DuihuanTipsPart.ITEMS_LJLQ = 3  --恭喜您，获得+奖励内容+立即领取按钮
DuihuanTipsPart.ITEMS_WXKF_QD = 4  --恭喜您，获得+奖励内容+微信客服+确定按钮
DuihuanTipsPart.ITEMS_LJDH_SHDH = 5  --恭喜您，获得+奖励内容+立即领取+稍后领取按钮
DuihuanTipsPart.ITEMS_LJFX_SHFX = 6  --恭喜您，获得+奖励内容+立即分享+稍后分享按钮

--[
-- @brief 构造函数
--]
function DuihuanTipsPart:ctor(owner)
    DuihuanTipsPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DuihuanTipsPart:initialize()
	
end

--激活模块
function DuihuanTipsPart:activate(gameId, info)
	self.game_id = gameId
    self.zorder = DuihuanTipsPart.ZORDER
    DuihuanTipsPart.super.activate(self,CURRENT_MODULE_NAME)
    self:setInfo(info)
end

function DuihuanTipsPart:setInfo(info)
	print("XXXXXXXX DuihuanTipsPart ", info)
	self.view:setInfo(info)
end

function DuihuanTipsPart:notScroll()
	if self.view then
		self.view:notScroll()
	end
end

function DuihuanTipsPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function DuihuanTipsPart:getPartId()
	-- body
	return "DuihuanTipsPart"
end

return DuihuanTipsPart 