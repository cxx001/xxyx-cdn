--[[
*名称:FankuiLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local FankuiPart = class("FankuiPart",cc.load('mvc').PartBase) --登录模块
FankuiPart.DEFAULT_VIEW = "FankuiLayer"

--[
-- @brief 构造函数
--]
function FankuiPart:ctor(owner)
    FankuiPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function FankuiPart:initialize()
	
end

--激活模块
function FankuiPart:activate(gameId)
	self.gameId = gameId
	FankuiPart.super.activate(self,CURRENT_MODULE_NAME)
end

function FankuiPart:deactivate()
	if self.view then
		self.view:removeSelf()
	  	self.view =  nil
	end
end

function FankuiPart:getPartId()
	-- body
	return "FankuiPart"
end

function FankuiPart:uploadLogFile(msg)
	local user = global:getGameUser()
	local uid = user:getProp("uid")
	local logFilepath = cc.FileUtils:getInstance():getLogFilePath()

	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	http_mode:UpLoadLogFile(uid, self.gameId, logFilepath, msg)

	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.upload_log_succeed})
	end
end

return FankuiPart
