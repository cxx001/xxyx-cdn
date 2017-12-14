--[[
 胡牌推倒管理
]]
local PushOverHandCardLayer = class("PushOverHandCardLayer")
local CURRENT_MODULE_NAME = ...

function PushOverHandCardLayer:init(resBase)
	self.res_base = resBase

	self.card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
	self.card_factory:addSpriteFrames()
end

--子节点
function PushOverHandCardLayer:setRoot(root)
	self._root = root
	self:initHcard()
end

--初始化hCard
function PushOverHandCardLayer:initHcard()
	 local node_Center = self._root:getChildByName("Node_Center")
	 self._hCard2 = node_Center:getChildByName("hCard2")
	 self._hCard3 = node_Center:getChildByName("hCard3")
	 self._hCard4 = node_Center:getChildByName("hCard4")

	 -- self:resetAllDownCard()
end

--更新手牌
function PushOverHandCardLayer:updateHandCards(thdata,viewId,startIndex)
	local index = 0
	for i,v in ipairs(thdata) do
		if index >= startIndex then
			self:updateCard(viewId,v,i)
		end
		index = index + 1 
	end
end

function PushOverHandCardLayer:updateCard(viewId,v,index)
	local cardBg = self:getCardBg(viewId,index)
	if not cardBg then return end
	cardBg:show()
	local cardName ="img_card"
	local card =  cardBg:getChildByName(cardName)
	local cardPath = self:getCardPath(viewId,v)
	card:loadTexture(cardPath,1)
end

function PushOverHandCardLayer:getHCard(viewId)
	local hCard = nil
	local tb = {}
	tb[RoomConfig.DownSeat]=self._hCard2
	tb[RoomConfig.FrontSeat]=self._hCard3
	tb[RoomConfig.UpSeat]=self._hCard4
	hCard = tb[viewId]
	return hCard	
end

function PushOverHandCardLayer:getCardBg(viewId,index)
	local hCard = nil
	hCard = self:getHCard(viewId)
	if not hCard then return nil end
	local cardBgName = "img_bg_"..index
	local cardBg = hCard:getChildByName(cardBgName)
	return cardBg
end

function PushOverHandCardLayer:getCardPath(viewId,v)
	local cardPath =""
	local tb = {}
	tb[RoomConfig.DownSeat]="mj_ar_02"
	tb[RoomConfig.FrontSeat]="mj_ad_01"
	tb[RoomConfig.UpSeat]="mj_al_02"

	local card_type,card_value = self.card_factory:decodeValue(v)
	local fileNameBefore =tb[viewId]
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	cardPath = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],card_value)
	print("PushOverHandCardLayerfileName:"..cardPath)

	return cardPath
end

--重置hCard
function PushOverHandCardLayer:resetAllDownCard()
	--全部为不可见
	self._hCard2:hide()
	self._hCard3:hide()
	self._hCard4:hide()

	self:hideChildrents(self._hCard2)
	self:hideChildrents(self._hCard3)
	self:hideChildrents(self._hCard4)
end

function PushOverHandCardLayer:hideChildrents( hCard )
	for k,v in pairs(hCard:getChildren()) do
		v:hide()
	end
end


return PushOverHandCardLayer