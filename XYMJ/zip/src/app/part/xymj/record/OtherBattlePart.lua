--[[
*名称:OtherBattlePart
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local OtherBattlePart = class("OtherBattlePart",cc.load('mvc').PartBase) --登录模块
OtherBattlePart.DEFAULT_VIEW = "OtherBattleLayer"
--[
-- @brief 构造函数
--]
function OtherBattlePart:ctor(owner)
    OtherBattlePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function OtherBattlePart:initialize()
	self.num_list = {}
end

--激活模块
function OtherBattlePart:activate()
	OtherBattlePart.super.activate(self,CURRENT_MODULE_NAME)
end

function OtherBattlePart:deactivate()
	self.num_list = {}
	self.view:removeSelf()
 	self.view =  nil

 	--self.owner:recordClick()
end

function OtherBattlePart:getPartId()
	-- body
	return "OtherBattlePart"
end

function OtherBattlePart:addNum(num)
	-- body
	if #self.num_list < 6 then
		table.insert(self.num_list,num)
		self.view:showNum(table.concat(self.num_list))
		if #self.num_list >= 6 then
			self:addGame()
		end
	end
end

function OtherBattlePart:addGame()
	-- body
	if #self.num_list > 0 then
		self.owner:startLoading()
		
		local share_code = tostring(table.concat(self.num_list))
		local getBattleData = require('app.part.record.GetBattleData').new()
		getBattleData:loadRecordData(share_code, function(code, server_data)
			self.owner:endLoading()
			if code == 200 then
				self:deactivate()
				self.owner:startRecrod(code, server_data)
			else
				local str = ''
				if code == 400 then
					str = string_table.not_battle_data
				else
					str = string.format(string_table.load_battle_error, code)
				end
				-- @ error
				local tips_part = global:createPart("TipsPart",self)
				if tips_part then
					tips_part:activate({info_txt=str})
				end			
			end
		end)
	end
end

function OtherBattlePart:delNum()
	-- body
	if #self.num_list > 0 then
		table.remove(self.num_list)
		self.view:showNum(table.concat(self.num_list))
	end
end

function OtherBattlePart:resetNum()
	-- body
	for loop = 1, #self.num_list do
		self:delNum()
	end
end

return OtherBattlePart 