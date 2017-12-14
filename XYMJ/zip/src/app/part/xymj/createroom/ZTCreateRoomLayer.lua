--[[
*名称:CreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CURRENT_MODULE_NAME = ...
local CreateRoomLayer = import(".CreateRoomLayer")
local ZTCreateRoomLayer = class("ZTCreateRoomLayer",CreateRoomLayer)

function ZTCreateRoomLayer:setSelectMa(num)
	-- body
	print("setSelectMa :",num)
	if num == 1 then

	else		
		for i=2,3 do
			if i ~= num then
				self.node["ma_select" .. i]:setSelected(false)
				self.node["ma_select" .. i]:setTouchEnabled(true)
			else 
				self.node["ma_select" .. i]:setTouchEnabled(false)
			end
		end
	end

	self.curPlay = {}
	for i=1,3 do
		print("setSelectMa: ",self.node["ma_select" .. i]:isSelected())
		self.curPlay[i] = self.node["ma_select" .. i]:isSelected()
	end

	self.part:setPlayWay(self.curPlay)
end


return ZTCreateRoomLayer