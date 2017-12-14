--[[
*名称:PayChoseTipPart
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local cjson = require "cjson"
local CURRENT_MODULE_NAME = ...
local PayContinuePart = class("PayContinuePart",cc.load('mvc').PartBase) --登录模块
PayContinuePart.DEFAULT_VIEW = "PayContinueLayer"
PayContinuePart.DEFAULT_PART = {
    "LoadingPart"
}
PayContinuePart.Req_Zuanshi_Tag = "req_zuanshi_config"
--[
-- @brief 构造函数
--]
function PayContinuePart:ctor(owner)
    PayContinuePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function PayContinuePart:initialize()
	
end

--激活模块
function PayContinuePart:activate(payType , index , bind_agen)
    PayContinuePart.super.activate(self,CURRENT_MODULE_NAME)
    self.selectIndex = index
    self.payType = payType
    self.bind_agen = bind_agen
    self:requestZuanshiPrice()
end

function PayContinuePart:requestZuanshiPrice(  )
    local configUrl = "http://"..SocketConfig.PURCHASE_URL.."/recharge/get-config?gid=524552&key=bindAvgPrice,unbindAvgPrice"

    print("requestZuanshiPrice")
    local loading_part = self:getPart("LoadingPart")
    loading_part:activate()

	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD) 
	http_mode:send(PayContinuePart.Req_Zuanshi_Tag, configUrl,"",0,function(resultCode,data)
		-- body
		if resultCode == HTTP_STATE_SUCCESS then
		    local loading_part = self:getPart("LoadingPart")
		    if loading_part then
		        loading_part:deactivate()
		    end
			local table_data = cjson.decode(data)
			print("table_data=")
			dump(table_data)
			if table_data.data[1]>table_data.data[2] then
				table_data.data[1] , table_data.data[2] = table_data.data[2] , table_data.data[1]
			end
			self.view:updateZuanPrice(table_data.data[1] , table_data.data[2])
		end
	end)
end

function PayContinuePart:continuePay()
	--self.owner:requestOrder(self.payType,self.selectIndex)
    local payChoseTipPart = self.owner:getPart("PayChoseTipPart")
    if payChoseTipPart then
        payChoseTipPart:activate(self.selectIndex , self.bind_agen)
    end
end

function PayContinuePart:createBindPart(  )
	print("bindAgent --------")
	global:getCurrentPart():getAgenConfig(2)

	-- local user = global:getGameUser()
 -- 	local uid = user:getProp("uid")
 -- 	local logintime = os.time() 							     --时间戳
 -- 	local sign = md5.sumhexa(keyword .. logintime .. uid)	     --签名md5加密
 -- 	local time_uid = "&logintime=" .. logintime.. "&uid="..uid
 -- 	local webviewpart = self:getCurPart():getPart("WebViewPart")
 -- 	if not webviewpart then
 -- 		return
 -- 	end
 -- 	if self.bind_agen == 2 then --绑定代理 
 -- 		url = url.."?gid="..SocketConfig.GAME_ID.."&r=wx/route&url=bind-member&sign="..sign..time_uid
	-- 		print("加了签名的url1 ： ",url) 
 -- 	elseif self.bind_agen == 1 then --代理后台
 -- 		url = url.."?gid="..SocketConfig.GAME_ID.."&r=wx/route&url=index&sign="..sign..time_uid
 -- 		print("加了签名的url2 ： ",url) 
 -- 	end
 -- 	webviewpart:activate(0,url,keyword,inputParam)
	-- webviewpart:setTransprent(false)
end

function PayContinuePart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD) 
	http_mode:unRegisterRequest(PayContinuePart.Req_Zuanshi_Tag)
end

function PayContinuePart:getPartId()
	-- body
	return "PayContinuePart"
end

return PayContinuePart 