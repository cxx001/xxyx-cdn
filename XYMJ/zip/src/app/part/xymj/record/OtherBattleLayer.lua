--[[
*名称:OtherBattleLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local OtherBattleLayer = class("OtherBattleLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...

function OtherBattleLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("OtherBattleLayer", CURRENT_MODULE_NAME)
	self.node.im_board:setScrollBarEnabled(false)
end


for i=0,9 do
	OtherBattleLayer["NumClick" .. i] = function(self)
		self.part:addNum(i)
	end
end

function OtherBattleLayer:AddGameClick()    
	self.part:addGame()
end

function OtherBattleLayer:ResetClick()    
	self.part:resetNum()
end

function OtherBattleLayer:DelClick()    
	self.part:delNum()
end

function OtherBattleLayer:CloseClick()
	-- body
	self.part:deactivate()
end

function OtherBattleLayer:showNum(str)
	-- body
	self.node.input_txt:setString(str)
end

function OtherBattleLayer:CreateGameClick()
	-- body
	self.part:createGameClick()
end

return OtherBattleLayer
