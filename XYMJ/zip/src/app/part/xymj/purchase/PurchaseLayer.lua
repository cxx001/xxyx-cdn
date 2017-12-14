--[[
*名称:PurchaseLayer
*描述:支付界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local PurchaseLayer = class("PurchaseLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function PurchaseLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("PurchaseLayer",CURRENT_MODULE_NAME)
	self.isSelect = false
    local scale = display.width/1280
	self.node.Image_bg:setScale(scale)
	for i=1,8 do
		PurchaseLayer["goodClick" .. i] = function(self)
		print("goodClick"..i)
			self.part:selectTimes(i)
		end
	end

	for i=1,8 do
		self.node["btn_good"..i]:hide()	
	end

	if self.node.Sprite_41 then
		self.node.Sprite_41:hide()
	end

	-- if ISAPPSTORE then
	-- 	self.node.wx_btn:hide()
	-- 	self.node.ali_btn:hide()
	-- 	self.node.iap_btn:show()
	-- else
	-- 	self.node.wx_btn:show()
	-- 	self.node.ali_btn:show()
	-- 	self.node.iap_btn:hide()
	-- end
end

function PurchaseLayer:addMask()
    -- body
    local mask_layer = cc.LayerColor:create()
    mask_layer:initWithColor(cc.c4b(0,0,0,200))
    self:addChild(mask_layer)
    local  listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch, event)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)
end


--根据商品配置初始化商品列表
function PurchaseLayer:initConfig(config)
	-- body
	-- if ISAPPSTORE then
	-- 	self.node["good_check1"]:show()
	-- 	local good_name = self.node["good_name1"]
	-- 	good_name:setString(string_table.mall_text_rmb..6)
	-- 	return
	-- end

	-- for i,v in ipairs(config) do
	-- 	self.node["good_check" .. i]:show()
	-- 	local good_name = self.node["good_name" .. i]
	-- 	good_name:setString(string_table.mall_text_rmb..v.price)
	-- end

	-- body
	-- if ISAPPSTORE then
	-- 	self.node["btn_good1"]:show()
	-- 	local good_name = self.node["good_name1"]
	-- 	good_name:setString(string_table.mall_text_rmb..6)
	-- 	return
	-- end

	if ISAPPSTORE then
		self.node["btn_good1"]:show()
		local moneyBg =self.node["btn_good1"]:getChildByName("Sprite_1_0") 
		local AtlasLabel_money = moneyBg:getChildByName("AtlasLabel_money")
		AtlasLabel_money:setString(6)
		local AtlasLabel_num = self.node["btn_good1"]:getChildByName("AtlasLabel_num")
		AtlasLabel_num:setString(6)
		return
	end

	for i,v in ipairs(config) do
		self.node["btn_good" .. i]:show()
		local moneyBg =self.node["btn_good" .. i]:getChildByName("Sprite_1_0") 
		local RMBTag =moneyBg:getChildByName("Sprite_1_0_0") 
		local AtlasLabel_money = moneyBg:getChildByName("AtlasLabel_money")
		AtlasLabel_money:setString(v.price)
		local posx_RMBTag= (RMBTag:getContentSize().width+moneyBg:getContentSize().width)/2
		local posy_RMBTag = RMBTag:getContentSize().height/2+18
		posx_RMBTag= posx_RMBTag - (RMBTag:getContentSize().width+AtlasLabel_money:getContentSize().width)/2
		RMBTag:setPosition(cc.p(posx_RMBTag,posy_RMBTag))
		local posx_money =RMBTag:getPositionX()+RMBTag:getContentSize().width/2
		posx_money= posx_money + AtlasLabel_money:getContentSize().width/2
		local posy_money =moneyBg:getContentSize().height/2+5
		AtlasLabel_money:setPositionX(posx_money)
		AtlasLabel_money:setPositionY(posy_money)

		local AtlasLabel_num = self.node["btn_good" .. i]:getChildByName("AtlasLabel_num")
		AtlasLabel_num:setString(v.num)
	end

 	local user = global:getGameUser()
 	local recommender_Id = user:getProp("recommender_Id"..self.part.game_id)
 	if recommender_Id and recommender_Id.recommenderId then
  		local recommenderId = recommender_Id.recommenderId
 		self:setTuijie(recommenderId)
 	end
end

function PurchaseLayer:setTuijie(ID)
	if ID == 0 then
		return
	end
	if self.node.Sprite_41 then
		self.node.Sprite_41:show()
	end
	self.node.AtlasLabel_tuijie_ID:setString(ID)

end


function PurchaseLayer:setDiamond(num)
	return
	self.node.AtlasLabel_diamond:setString(num)
end

function PurchaseLayer:setCoin(coin)
	return
	self.node.AtlasLabel_coin:setString(coin)
end

function PurchaseLayer:CloseClick() 
	self.part:deactivate()   
end

-- function PurchaseLayer:setSelectTimes(type,cur_num ,cur_price)
-- 	-- body
-- 	for i=1,8 do --关闭当前选择
-- 		if i ~= type then
-- 			self.node["good_check" .. i]:setSelected(false)
-- 			self.node["good_check" .. i]:setTouchEnabled(true)
-- 			self.isSelect = true
-- 		else 
-- 			self.node["good_check" .. i]:setTouchEnabled(false)
-- 			self.isSelect = false
-- 		end
-- 	end

-- 	local cur_money = self.node.cur_money_txt
-- 	cur_money:setString(string.format(string_table.pay_text_price_yuan,cur_price))
-- 	local diamond_num = self.node.diamond_txt
-- 	diamond_num:setString(cur_num)

-- 	self.selectIndex = type

-- 	if ISAPPSTORE then
-- 		local cur_money = self.node.cur_money_txt
-- 		cur_money:setString("")
-- 		local diamond_num = self.node.diamond_txt
-- 		diamond_num:setString(6)
-- 		self.selectIndex = type
-- 	end
-- end

-- function PurchaseLayer:WxBtnClick()
-- 	self.part:pcBtnClick(0 , self.selectIndex , self.isSelect )
-- end

-- function PurchaseLayer:AliBtnClick()
-- 	self.part:pcBtnClick(1 , self.selectIndex , self.isSelect )
-- end

-- function PurchaseLayer:IAPBtnClick()
-- 	self.part:pcBtnClick(2 , self.selectIndex , self.isSelect )
-- end
return PurchaseLayer