--[[
*名称:PurchaseLayer
*描述:支付界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local PurchasePart = class("PurchasePart",cc.load('mvc').PartBase) --登录模块
local cjson = require "cjson"
PurchasePart.DEFAULT_PART = {
    "LoadingPart",
    "PayChoseTipPart",
    "PayContinuePart"
}
PurchasePart.DEFAULT_VIEW = "PurchaseLayer"
PurchasePart.ALI_PAY = 1 --阿里支付
PurchasePart.WX_PAY = 0 --微信支付
PurchasePart.IAP_PAY = 2 --苹果支付
-- PurchasePart.CONFIG_URL = "http://api.xiaoxiongyouxi.com/recharge/get-goods?gid="
-- PurchasePart.ALI_ORDER = "http://api.xiaoxiongyouxi.com/recharge/alipay-app?"
-- PurchasePart.WX_ORDER = "http://api.xiaoxiongyouxi.com/recharge/wx-app?"
--[
-- @brief 构造函数
--]
function PurchasePart:ctor(owner)
	PurchasePart.super.ctor(self, owner)
	self:initialize()
end

--[
-- @override
--]
function PurchasePart:initialize()
	self.purchase_config = {}  --当前商品配置
end

--发送Http请求接收商品配置
function PurchasePart:requestPurchaseConfig()
-- body
	print("----------tmp chongzhi self.game_id :",type(self.game_id))

	--self.CONFIG_URL = "http://"..SocketConfig.PURCHASE_URL.."/recharge/get-goods?gid="..self.game_id
	local user = global:getGameUser()
	local uid = user:getProp("uid")

	self.CONFIG_URL = "http://"..SocketConfig.PURCHASE_URL.."/recharge/get-goods?gid="..SocketConfig.GAME_ID.."&uid="..uid
	self.ALI_ORDER = "http://"..SocketConfig.PURCHASE_URL.."/recharge/alipay-app?"
	self.WX_ORDER = "http://"..SocketConfig.PURCHASE_URL.."/recharge/wx-app?"
	self.IAP_ORDER = "http://"..SocketConfig.PURCHASE_URL.."/recharge/apple-app?"

	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	print("self.CONFIG_URL : ",self.CONFIG_URL)
	http_mode:send("req_purchase_config",self.CONFIG_URL,"",0,function(resultCode,data)
		-- body
		if resultCode == HTTP_STATE_SUCCESS then
		    local loading_part = self:getPart("LoadingPart")
		    if loading_part then
		        loading_part:deactivate()
		    end
			local table_data = cjson.decode(data)
			if ISAPPSTORE then
				self.purchase_config = table_data.list
				self.view:initConfig(self.purchase_config) --刷新道具
			else
				--改为全员购钻
				self.purchase_config = table_data.list
				self.view:initConfig(self.purchase_config) --刷新道具
				self.view:setTuijie(table_data.referrer_id) --设置代理ID

				self.bind_agen = table_data.referrer_id
				print("self.bind_agen =     = ",self.bind_agen)

				-- if table_data.referrer_id ~= 0 then--已绑定代理人
				-- 	self.purchase_config = table_data.list
				-- 	self.view:initConfig(self.purchase_config) --刷新道具
				-- 	self.view:setTuijie(table_data.referrer_id) --设置代理ID
				-- else
				-- 	self.owner:getAgenConfig(2)     --跳转web绑定代理人
				-- 	self:deactivate()
				-- 	-- self.purchase_config = table_data.list
				-- 	-- self.view:initConfig(self.purchase_config) --刷新道具
				-- end
			end
		end
		end)
end

function PurchasePart:pcBtnClick(selectType ,selectIndex ,isSelect)
-- body
	if isSelect == false then
		local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.purchase_tip})
	end
	elseif isSelect == true then
		if selectType == 0 then
			self:requestOrder(PurchasePart.WX_PAY,selectIndex)
		elseif selectType == 1 then
			self:requestOrder(PurchasePart.ALI_PAY,selectIndex)
		elseif selectType == 2 then
			self:requestOrder(PurchasePart.IAP_PAY,selectIndex)
	end
	end
end

local function orderParam(rid, gid)
	local params = {
		"timestamp=" .. os.time(),
		"rid=" .. rid,
		"gid=" .. gid,
		"uid=" .. global:getGameUser():getProp("gameplayer" .. gid).playerIndex, --暂时测试用
	}
	table.sort(params)

	local urlParam = table.concat(params, "&")
	local sign = md5.sumhexa(urlParam .. "&key=" .. "Apjh54MBYYvwLjPMOciMwM2Mm2RVFcfZ")
	return urlParam .. "&sign=" .. string.upper(sign)
end

local function orderParamIAP(rid, gid)
	local params = {
		"timestamp=" .. os.time(),
		-- "rid=" .. rid,
		"gid=" .. gid,
		"uid=" .. global:getGameUser():getProp("gameplayer" .. gid).playerIndex, --暂时测试用
		"iap_product_id=" .. rid,
		"price=" .. "6",
		"type=" .. "1",
		"amount=" .. "6",
	}
	table.sort(params)

	local urlParam = table.concat(params, "&")
	local sign = md5.sumhexa(urlParam .. "&key=" .. "Apjh54MBYYvwLjPMOciMwM2Mm2RVFcfZ")
	return urlParam .. "&sign=" .. string.upper(sign)
end

--下订单
function PurchasePart:requestOrder(payType,selectIndex)
	-- body
	if ISAPPSTORE and payType == PurchasePart.IAP_PAY then
		local loading_part = global:createPart("LoadingPart",self)
		self:addPart(loading_part)
		loading_part:activate()

		local purchase_id = "com.highlight.mjpe.diamond6"
		local game_id = self.game_id
		local order_url = self.IAP_ORDER .. orderParamIAP(purchase_id, game_id)
		print("order_url : ",order_url)

		local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
		http_mode:send("req_order",order_url,"",0,function(resultCode,data)
			-- body
			if resultCode == HTTP_STATE_SUCCESS then
			--下完订单就需要走支付流程
				print("-----------------现在走支付流程")
				local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
				lua_bridge:setPlayerID(global:getGameUser():getProp("gameplayer" .. game_id).playerIndex)
				lua_bridge:payCall(payType,data)

				-- local loading_part = self:getPart("LoadingPart")
				if loading_part then
				loading_part:deactivate()
				end
			end
		end)
		return
	end

	local order_type = (payType == PurchasePart.WX_PAY) and self.WX_ORDER or self.ALI_ORDER --默认是阿里的请求地址
	local purchase_id = self.purchase_config[selectIndex].id

	local order_url = order_type .. orderParam(purchase_id, self.game_id)
	print("order_url : ",order_url)

	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	http_mode:send("req_order",order_url,"",0,function(resultCode,data)
		-- body
		if resultCode == HTTP_STATE_SUCCESS then
		--下完订单就需要走支付流程
			print("-----------------现在走支付流程")
			local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
			lua_bridge:payCall(payType,data) 
		end
	end)
end

--激活模块
function PurchasePart:activate(gameId,data)
-- 	self.owner:startLoading()
    -- gameId = 262401 --临时测试数据
    self.game_id = gameId
	PurchasePart.super.activate(self,CURRENT_MODULE_NAME)
    local loading_part = self:getPart("LoadingPart")
    if loading_part then
        loading_part:activate(gameId)
    end
	self:requestPurchaseConfig()
	-- self.view:initConfig(self.purchase_config)
end

function PurchasePart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view = nil
	end
end

function PurchasePart:selectTimes(type)
-- body
	self.cur_good = type
	if ISAPPSTORE then
    	self:requestOrder(PurchasePart.IAP_PAY,self.cur_good)
	else
    	-- local payChoseTipPart = self:getPart("PayChoseTipPart")
    	-- if payChoseTipPart then
     --    	payChoseTipPart:activate(self.cur_good)
    	-- end
        if self.bind_agen and self.bind_agen ~= 0 then
    	    local payChoseTipPart = self:getPart("PayChoseTipPart")
    	    if payChoseTipPart then
        	    payChoseTipPart:activate(self.cur_good , self.bind_agen)
    	    end
        else
	        local PayContinuePart = self:getPart("PayContinuePart")
	        if PayContinuePart then
    	        PayContinuePart:activate(0, self.cur_good, self.bind_agen) -- 缺省为微信支付
	        end
        end
	end
	-- for i,v in ipairs(self.purchase_config) do
	-- 	if type == i then
	-- 		self.cur_num = v.num
	-- 		self.cur_price = v.price
	-- 	end
	-- end
	-- self.view:setSelectTimes(self.cur_good,self.cur_num ,self.cur_price)

end

function PurchasePart:getPartId()
-- body
	return "PurchasePart"
end

return PurchasePart
