--[[
 牌局内手牌：待优化【主要對上下對傢牌】
 后期摆牌，牌局回放手牌
]]
local HandCardLayer = class("HandCardLayer")

function HandCardLayer:init(resBase)
	self.res_base = resBase
	self._currentDrawCard = nil
end

--子节点
function HandCardLayer:setRoot(root)
	self._root = root
end


--重置所有底板
function HandCardLayer:resetAllCard()
	--全部为不可见
	local  Node_center=self._root:getChildByName("Node_center")
	
	local  hcard4= Node_center:getChildByName("hcard4")
	for k,v in pairs(hcard4:getChildren()) do
		v:hide()
	end

	local  hcard2= Node_center:getChildByName("hcard2")
	for k,v in pairs(hcard2:getChildren()) do
		v:hide()
	end

	local  hcard3= Node_center:getChildByName("hcard3")
	for k,v in pairs(hcard3:getChildren()) do
		v:hide()
	end
end

function HandCardLayer:showCard(viewId,index)
	local tb = {}
	tb[RoomConfig.MySeat]=""
	tb[RoomConfig.DownSeat]="hcard2"
	tb[RoomConfig.FrontSeat]="hcard3"
	tb[RoomConfig.UpSeat]="hcard4"
	local cardViewIdName = tb[viewId]
	local  Node_center=self._root:getChildByName("Node_center")
	local cardViewId = Node_center:getChildByName(cardViewIdName)
 	local cardName = cardViewIdName.."_"..index
	local card = cardViewId:getChildByName(cardName)
	card:show()
	return card
end


--屏蔽摸牌的牌
function HandCardLayer:hideCurrentDrawCard()
	if self._currentDrawCard then
	  self._currentDrawCard:hide()
	  self._currentDrawCard = nil
	end
end
--摸牌
function HandCardLayer:showDrawHandCard(viewId,Index)
	self:hideCurrentDrawCard()
	local tb = {}
	tb[RoomConfig.MySeat]=""
	tb[RoomConfig.DownSeat]="hcard2"
	tb[RoomConfig.FrontSeat]="hcard3"
	tb[RoomConfig.UpSeat]="hcard4"
	local cardViewIdName = tb[viewId]
	local  Node_center=self._root:getChildByName("Node_center")
	local cardViewId = Node_center:getChildByName(cardViewIdName)
 	local cardName = cardViewIdName.."_"..Index.."_1"
 	print("cardName："..cardName)
	local card = cardViewId:getChildByName(cardName)
	self._currentDrawCard =card
	self._currentDrawCard:show()
end

return HandCardLayer