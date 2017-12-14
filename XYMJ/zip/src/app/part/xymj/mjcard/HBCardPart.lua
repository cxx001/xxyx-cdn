
--湖北合集
local CURRENT_MODULE_NAME = ...
local HBCardPart = class("HBCardPart", import(".CardPart"))
HBCardPart.DEFAULT_VIEW = "HBCardLayer"

function HBCardPart:ctor(owner) 
    HBCardPart.super.ctor(self, owner)
    self:initialize()
    self.cardOrderMap = {}
    self.cardValueMap = {}
end

local ORDER_HONGZHONG = -3
local ORDER_PIZI      = -2
local ORDER_LAIZI     = -1

function HBCardPart:activate(gameId,data)
    -- body
    self.game_id = gameId
    self.cardOrderMap = {
        [0x35] = ORDER_HONGZHONG,                                   --红中
        [bit._and(bit.rshift(data.baocard, 8),0xff)] = ORDER_LAIZI, --癞子
    }

    self.cardValueMap = {
        [0x35] = ORDER_HONGZHONG,                                   --红中
        [bit._and(data.baocard,0xff)] = ORDER_PIZI,                 --痞子
        [bit._and(bit.rshift(data.baocard, 8),0xff)] = ORDER_LAIZI, --癞子
    }

    self.piziValue = bit._and(data.baocard,0xff)
    self.laiziValue = bit._and(bit.rshift(data.baocard, 8),0xff)

    self.OptShowPriority = (function()
        local ret = {}
        local optList = {
            RoomConfig.MAHJONG_OPERTAION_HU,
            RoomConfig.MAHJONG_OPERTAION_ZIMO, 
            RoomConfig.PIZI_NOTIFY,
            RoomConfig.Chi,
            RoomConfig.Peng,
            RoomConfig.Gang,
            RoomConfig.MAHJONG_OPERTAION_CANCEL
        }
        for i, v in pairs(optList) do   --不要用ipairs这里，中间可能有nil
            if v then ret[v] = i end
        end
        return ret
    end)()

    HBCardPart.super.activate(self,gameId,data)
end

function HBCardPart:isLaiZi(cardValue)
    local order = self.cardValueMap[cardValue]
    print("###[HBCardPart:isLaiZi]order  cardValue ",order,cardValue)
    return order == ORDER_LAIZI
end

function HBCardPart:isHongzhong(cardValue) 
    local order = self.cardValueMap[cardValue]
    print("###[HBCardPart:isHongzhong]order  cardValue ",order,cardValue)
    return order == ORDER_HONGZHONG
end

function HBCardPart:isPiZi(cardValue)
    local order = self.cardValueMap[cardValue]
    print("###[HBCardPart:isPiZi]order  cardValue ",order,cardValue)
    return (order == ORDER_HONGZHONG) or (order == ORDER_PIZI)
end

--@function: 判断是痞子赖子，或者其它牌
--@param1: 待测牌值
--@return: true痞子赖子，false其它牌
function HBCardPart:isBaoCard(cardValue)
    return self.cardValueMap[cardValue] and true or false
end

--@function: 指定当前手牌的牌子顺序，以[红中(固定痞子),痞子,赖子,其它牌按值顺序从小到大]的顺序
--@param1: 待测左边牌
--@param2: 待测右边牌
--@return: 待测两张牌，是否满足左右顺序
function HBCardPart:cardOrder(leftCardValue, rightCardValue)
    local leftOrder  = self.cardOrderMap[leftCardValue] or leftCardValue
    local rightOrder = self.cardOrderMap[rightCardValue] or rightCardValue
    print(string.format("###[HBCardPart:cardOrder] leftOrder is %d rightOrder is %d", leftOrder, rightOrder))
    return leftOrder < rightOrder
end

function HBCardPart:refreshMyCard(hcard,dcard,ocard,value) -- 刷新自己的手牌和 dcard_list
	-- body
    table.sort(hcard, function(...) return self:cardOrder(...) end)  
    HBCardPart.super.refreshMyCard(self, hcard, dcard, ocard, value)
end

function HBCardPart:requestOutCard(value)
    print("###[HBCardPart:requestOutCard] 请求出牌 ", value) 
    HBCardPart.super.requestOutCard(self, value)
end

function HBCardPart:laiziGangClick(value)
    if not self.gang_list then
        print("###[HBCardPart:laiziGangClick] self.gang_list is nil")
        return
    end 
    for i, v in ipairs(self.gang_list) do
        local c1 = bit._and(bit.rshift(v.cardValue, 0),0xff)
        print("###[HBCardPart:laiziGangClick] cur gang_list value is ",c1)
        if c1 == value then 
            self.server_data = v.cardValue
            self:requestOpt(RoomConfig.MAHJONG_OPERTAION_MING_GANG)
            self.view:hideOpt()
        end 
    end
end

 

function HBCardPart:refreshBaoCardOnPart(baoCard) 
    if not baoCard then
        print("###[HBCardPart:refreshBaoCardOnPart] baoCard is nil")
        return
    end

    local cardConfig = {} 
    cardConfig.baoInfo1 = {}
    cardConfig.baoInfo2 = {}

    local bao1 = bit._and(baoCard,0xff);
    local bao2 = bit._and(bit.rshift(baoCard,8),0xff) 
    cardConfig.baoInfo1.type, cardConfig.baoInfo1.value = self.view.card_factory:decodeValue(bao1)
    cardConfig.baoInfo1.srcValue = bao1


    cardConfig.baoInfo2.type, cardConfig.baoInfo2.value = self.view.card_factory:decodeValue(bao2)  
    cardConfig.baoInfo2.srcValue = bao2

    self.view:refreshBaoCardOnLayer(cardConfig)
end



function HBCardPart:showAddOpt(value,disPlayGuo) 
    -- body
    if self.auto_opt then
       return
    end

    self.server_data = value
    print("###[HBCardPart:showAddOpt] this is show add opt:",#self.opt_list)
    if disPlayGuo then
        table.insert(self.opt_list,RoomConfig.MAHJONG_OPERTAION_CANCEL)
    end
    table.sort(self.opt_list, function(opt1, opt2) return self.OptShowPriority[opt1] <= self.OptShowPriority[opt2] end)
    dump(self.opt_list)
    self.view:showAddOpt(clone(self.opt_list))
    self.opt_list = {}
end


function HBCardPart:restoreDownCard(handCard,cardList)

    local down_cards = {}  --处理断线重连，需要展示已经吃杠碰的牌的情况
    for i=1,4 do
        local num = 0
        local view_id = self:changeSeatToView(i-1)
        local down_card = cardList[i] 
        down_cards[view_id] = down_card and down_card.cards or {} 
    end 
    self:refreshMyCard(handCard,down_cards[1],{})
    for i=2,4 do
        local down_card = down_cards[i]
        for _,card in ipairs(down_card) do
            local card_value = card.cardValue
            local c1 = bit._and(card_value,0xff)
            local c2 = bit._and(bit.rshift(card_value,8),0xff)
            local c3 = bit._and(bit.rshift(card_value,16),0xff)
            local card_data = {mcard={c1,c2},ocard=c3}
            
            if self:isPiZi(c1) then 
                self:optCard(i,RoomConfig.PIZI_NOTIFY,card_data,true)
                break
            elseif card.type == RoomConfig.BuGang or card.type == RoomConfig.MingGang then --断线重连补杠要变明杠才好显示牌
                card.type = RoomConfig.MingGang
                card_data = {mcard={c1,c2,c2},ocard=c3}
            elseif card.type == RoomConfig.AnGang then
                card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,c1},ocard=RoomConfig.EmptyCard}
            end 
            self:optCard(i,card.type,card_data,true)
        end
    end
end

function HBCardPart:getPizi()
    return self.piziValue
end


function HBCardPart:getLaizi()
    return self.laiziValue
end

function HBCardPart:showAnGang()
    return true
end

return HBCardPart