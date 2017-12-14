--[[
*名称:WifiAndNetLayer
*描述:网络状况界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local WifiAndNetNode = class("WifiAndNetNode",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function WifiAndNetNode:onCreate() 
	-- body
	self:initWithFilePath("WifiAndNetNode",CURRENT_MODULE_NAME)
	
end

function WifiAndNetNode:startUpdate()
	-- body
	self.part:checkUpdateInfo()
	self:schedulerFunc(function()
        -- body
		self.part:checkUpdateInfo()
    end,4,false)
end

function WifiAndNetNode:updateTime(time)
	-- body
	self.node.time_txt:setString(time)
end

function WifiAndNetNode:updateBattery(status)
	-- body
	local index = 1
	if status > 80 then
		index = 5
	elseif status >60 then
		index = 4
	elseif status > 40 then
		index = 3
	elseif status > 20 then
		index = 2
	else
		index = 1
	end
	--local frame_name = string.format("%s/room/resource/wifiandnet/dianliang-%d.png",self.res_base,index)
	--self.node.battery_img:loadTexture(frame_name,1)
	local battery_fore = self.node.battery_fore;
	local foreWidth = battery_fore:getContentSize().width;
	self.node.battery_fore:setPositionX((1 - status / 100.0) * -foreWidth)
end

function WifiAndNetNode:updateWifi(status,ping)
	-- body
	local index = 1
	if status > 80 then
    	index = 5
    elseif status > 60 then
    	index = 4
    elseif status > 40 then
    	index = 3
    elseif status > 20 then
    	index = 2
    else
    	index = 1
	end
	
	local net_level = 5;
	status = math.abs(status) --取绝对值
	local color = cc.c3b(0,255,0)
	if status <= 50 then
		net_level = 5
	elseif status <= 100 then
		color = cc.c3b(255,255,0)
		net_level = 4
	elseif status <= 200 then
		color = cc.c3b(255,255,0)
		net_level = 3
	elseif status <= 500 then
		color = cc.c3b(255,255,0)
		net_level = 2
	elseif status <= 1000 then
		color = cc.c3b(255,0,0)
		net_level = 1
	else
		color = cc.c3b(255,0,0)
		net_level = 0
	end

	local frame_name = string.format(self.res_base .. "/wifi-%d.png",net_level)
	-- if status == 1 then
	if net_level > 3 then
			net_level = 3
	end
	frame_name = string.format(self.res_base .. "/wifi-%d.png",net_level)
	-- elseif status == 2 then --4g
	-- 	frame_name = string.format(self.res_base .. "/xinhao-%d.png",net_level)
	-- else
	-- 	frame_name = self.res_base .. "/wifi-0.png"
	-- end

	self.node.wifi_img:loadTexture(frame_name,1)
	self.node.delay_time:setTextColor(color)
	self.node.delay_time:setString(status .."ms")
end

return WifiAndNetNode