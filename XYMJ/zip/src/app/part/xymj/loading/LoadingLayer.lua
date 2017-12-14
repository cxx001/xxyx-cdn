--[[
*名称:LoadingLayer
*描述:加载动画界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local LoadingLayer = class("LoadingLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function LoadingLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("LoadingLayer",CURRENT_MODULE_NAME)
	self.node.loading:runAction(self.node.animation)
	self.node.animation:play("StartLoading",true)
end

return LoadingLayer