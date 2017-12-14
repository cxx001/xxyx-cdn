--[[
*名称:GpsLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local GpsLayer = class("GpsLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
function GpsLayer:onCreate(data) --传入数据
	-- body
	self:initWithFilePath("GpsLayer",CURRENT_MODULE_NAME)
	self.node.GPS_panel:hide()
	self.flag = true
	self.node.Gps_btn:hide()
end

function GpsLayer:Gps_Click(node,touch,event)
	print("-----------GpsLayer event:",event)
	if event == 0 or event == 1 then
		self:showGps(true)
		self.flag = false
	elseif event == 2 or event == 3 then --按钮下touchend事件
		self:showGps(false)
	end
end

function GpsLayer:showGps(flag)
	-- body
	if flag == true then
		self.part:msgGetPlayersGpsInfo()
		self.node.GPS_panel:show()
	else
		self.node.GPS_panel:hide()
	end
end

function GpsLayer:isShowGipTip(flag)
	-- body
	self.isshow = flag
end

function GpsLayer:showDistance(index , distance , range)
	--body	
	print("index , distance , range : ",index , distance , range)
	self:showGipWaring(false)
	if distance == false then
		self.node["distance" .. index]:setString("?")
		self.node["distance" .. index]:setTextColor({r=255,g=0,b=0})
	else
		if distance > range and distance < 1000 then
			self.node["distance" .. index]:setString(distance.."m")
			self.node["distance" .. index]:setTextColor({r=255,g=255,b=255})
		elseif distance > 1000 then
			distance = distance/1000
			distance = string.format("%0.1f", distance) 
			self.node["distance" .. index]:setString(distance.."km")
			self.node["distance" .. index]:setTextColor({r=255,g=255,b=255})
		elseif distance < range then
			self.node["distance" .. index]:setString("小于"..range.."m")
			self.node["distance" .. index]:setTextColor({r=255,g=0,b=0})
			print("AAAAAAAAA:",self.flag,self.isshow)
			if self.flag == true and self.isshow == true then
				self.part:showGpsTip(index,range)
				self.part:setIsShow(false)
			else 
				self.flag = true
			end
		end
	end
end

function GpsLayer:showGipWaring(flag)
	-- body
	local FileName1 = self.res_base .. '/btn_gps_normal.png'
	local FileName2 = self.res_base .. '/btn_gps_select.png'

	if flag == true then
		self.node.Gps_btn:loadTextureNormal(FileName1,1)
	else
		self.node.Gps_btn:loadTextureNormal(FileName2,1)
	end
end

function GpsLayer:showSeat(flag , index)
	-- body
	local FileName1 = self.res_base .. '/icon_gps_light.png'
	local FileName2 = self.res_base .. '/icon_gps_gray.png'

	if flag == true then
		self.node["icon_gps_gray_" .. index]:loadTexture(FileName1,1)
	else
		self.node["icon_gps_gray_" .. index]:loadTexture(FileName2,1)
	end
end

function GpsLayer:showGpsBtn(flag)
	-- body
	-- if flag == true then
	-- 	self.node.Gps_btn:show()
	-- else
	-- 	self.node.Gps_btn:hide()
	-- end
end

return GpsLayer