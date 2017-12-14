
local XTCreateRoomLayer = class("XTCreateRoomLayer", import(".CreateRoomLayer"))

for i = 1, 2 do
	XTCreateRoomLayer["PaymentSelectEvent" .. i] = function(self)
		self.part:selectPayment(i)
	end
end 

for i =1, 3 do
	XTCreateRoomLayer["PlayWay2SelectEvent" .. i] = function(self)
		self.part:selectPlayWay2(i)
	end
end


function XTCreateRoomLayer:setSelectPayment(payment)
	print("###[XTCreateRoomLayer:setSelectPayment] payment ", payment)
	for i = 1, 2 do --关闭当前选择
		local paymentNode = self.node["payment_select" .. i]
		paymentNode:setSelected(i == payment)
		paymentNode:setTouchEnabled(i ~= payment)
	end
end

function XTCreateRoomLayer:setSelectPlayWay2(selectList)  
	for i,type in ipairs(selectList) do
		self.node["playway2_select" .. i]:setSelected(type > 0)
	end 
end

function XTCreateRoomLayer:showSelectPlayWay2(isShow)
	print("###[XTCreateRoomLayer:showSelectPlayWay2] isShow ", isShow)
	if isShow == true then
		self.node.playway2_panel:show()
		self.part:selectPlayWay2(0)
	else
		self.node.playway2_panel:hide()
	end 
end

return XTCreateRoomLayer