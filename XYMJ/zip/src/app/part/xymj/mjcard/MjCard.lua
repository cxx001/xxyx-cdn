--[[
*名称:MjCard
*描述:麻将牌对象类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local MjCard = class("MjCard",ccui.ImageView) 

--初始化
function MjCard:ctor()
	-- body
	self.stand = false --是否选取
    self.value = 0x39 --空牌
    self.select = false --是否被选中
    self.moved = false --是否移动过，需要根据是否移动过判断是不是双击事件
end

--设置牌值
function MjCard:setValue(value)
    self.value = value
end

--返回牌值
function MjCard:getValue()
	-- body
	return self.value
end

--是否选取
function MjCard:isStand()
	-- body
	return self.stand
end

--按下事件
function MjCard:touchBegan(tPoint)
    -- body
    self.pos = cc.p(self:getPosition())
    local size = self:getContentSize()
    local card_rect = cc.rect(self.pos.x-size.width/2,self.pos.y-size.height/2,size.width,size.height) --锚点是居中的所以rect的起点应该减半个宽高
    if cc.rectContainsPoint(card_rect,tPoint) then
        self.select = true --当前牌被选中
    else
        self.select = false
    end
    --print("this is selected------------:",self.select,self.value)
end

--移动事件
function MjCard:touchMoved(tPoint)
    -- body
    --print("This is mjcard--------------touchmoved------- self.select ", self.select)
    if self.select == true then
        --print("This is mjcard--------------touchmoved------- tPoint ", tPoint)
        self:setPosition(tPoint) --选中的牌跟随移动
        self.moved = true
    end
end

--放开事件 返回是否双击或者超线（用于判断是否可以出牌）
function MjCard:touchEnd(tPoint,outLine)
    -- body
   
    if self.select == true then
        if self.moved == false and self.stand == true then
            return true
        end

  		if self:getPositionY() > outLine then
  			return true
  		end
        if self.pos then
            self:setPosition(self.pos)
        end
        self:setSelectState(true)
    else
    	if self.pos then
            self:setPosition(self.pos)
        end
        self:setSelectState(false)
    end
    self.select = false --触摸结束重置选中状态 
    self.moved = false
    print("this is mj touch end ------------:",self.select,self.value) 
    return false
end

--设置点击状态
function MjCard:setSelectState(flag)
    -- body
    local size = self:getContentSize()
    local pos_y = self:getPositionY()
    
    if flag == true then
        self:setPositionY(pos_y + size.height/3)
    end
    
    if flag == self.stand then --当前状态和设置状态一样
        return 
    end
    self.stand = flag
end

return MjCard