--[[
*名称:WebViewLayer
*描述:网页界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local WebViewPart = class("WebViewPart",cc.load('mvc').PartBase) --登录模块
WebViewPart.DEFAULT_VIEW = "WebViewLayer"
local cjson = require("cjson")
--[
-- @brief 构造函数
--]
function WebViewPart:ctor(owner)
    WebViewPart.super.ctor(self, owner)
    
    self:initialize()

end

--[
-- @override
--]
function WebViewPart:initialize()
    self.mWebView = nil
    self.mNeedToChangeOrientation = false
    self.mXorKeyWord = ""
end

--激活模块
function WebViewPart:activate(web_orientation, url, keyword, inputParam, src_orientation)
    WebViewPart.super.activate(self,CURRENT_MODULE_NAME)
    
    if self.view then
        self:_initWebView(url, keyword, web_orientation, inputParam, src_orientation)
    end

end

function WebViewPart:deactivate()
    self.mWebView = nil
    if self.view then
        self.view:removeSelf()
        self.view = nil
    end
    
end

function WebViewPart:getPartId()
    -- body
    return "WebViewPart"
end

-- 取得密钥
function WebViewPart:getKeyWord()
    return self.mXorKeyWord
end

-- 设置密钥
function WebViewPart:setKeyWord( keyword )
    self.mXorKeyWord = keyword
end

-- 取得webview节点
function WebViewPart:getWebViewNode()
    return self.mWebView
end


-- 说明:
-- 用于设置加载的URL地址
function WebViewPart:loadURL( url ) 
    self.mWebView:loadURL( url )
end

-- 说明:
-- 设置背景是否透明化(true/false)
function WebViewPart:setTransprent( isTransprent )
    self.mWebView:setTransprent( isTransprent )
end

-- 说明:
-- 此接口需要先调用 setContentSize 接口
function WebViewPart:sendParamToJS( inputParam )
    --local encryptionString = webview:xorEncryption( self:getKeyWord(), inputParam )
    --local str = string.format("javascript:sendParamToJS(\"%s\")", encryptionString )
    local str = string.format("javascript:sendParamToJS(\"%s\")", inputParam )
    self.mWebView:evaluateJS(str)
end

-- 此接口暂不开放,不建议调用
function WebViewPart:sendStringToServer( inputParam )
    local postMessageMsg = webview_struct_pb.PostMessageMsg()
    postMessageMsg.operationID = WEBVIEW.POST_MESSAGE_OPERATION
    if inputParam then
        postMessageMsg.txt = inputParam
    end
    local buff_str = postMessageMsg:SerializeToString()
    local buff_lenth = postMessageMsg:ByteSize()
    net_manager:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_POST_USER_INFO,SocketConfig.GAME_ID)  
end


-- webview 
-- 初始化webview
function WebViewPart:_initWebView(url, keyword, web_orientation, inputParam, src_orientation)
    src_orientation = src_orientation or 1
    printInfo("WebViewPart:_initWebView url =%s,keyword = %s,web_orientation = %s,src_orientation = %s,inputParam = %s", url, keyword, web_orientation, src_orientation, inputParam)
    
    if web_orientation ~= src_orientation then
        self.mNeedToChangeOrientation = true
        local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
        lua_bridge:changeActivityOrientation(web_orientation)
    end
    local winSize = cc.Director:getInstance():getWinSize()

    if self.view == nil then
        printWarn( "self.view is nil and return" )
        return
    end

    local webview = ccexp.WebView:create()

    self.mWebView = webview
    self.mWebViewWidth = winSize.width
    self.mWebViewHeight = winSize.height
    
    webview:setContentSize(self.mWebViewWidth,self.mWebViewHeight)
    webview:setAnchorPoint(0,0)
    webview:setJavascriptInterfaceScheme("objc")
    webview:setScalesPageToFit(true)
    self.view:addChild(webview)
    webview:setOnShouldStartLoading(function(sender, url)
        printInfo("onWebViewShouldStartLoading, url is %s", url)
        return true
    end)
    webview:setOnDidFinishLoading(function(sender, url)
        printInfo("onWebViewDidFinishLoading, url is %s", url)   
        self.mWebView:evaluateJS(self.str)  
    end)
    webview:setOnDidFailLoading(function(sender, url)
        printInfo("setOnDidFailLoading, url is %s", url)        
    end)
    webview:setOnJSCallback( function( sender, url ) 
        -- 说明:
        -- 以下是JS回客户端数据处理地方,当前实现对字符串加/解密功能;
        url = string.sub(url,string.len("objc://")+1) 
        printInfo("OnJSCallback, url is %s", url) 
        local decode_data = cjson.decode(url)
        if tonumber(decode_data.Encrypt) == 1 then  --是否加密，1加密
            local decryptionString = webview:xorDecryption( self:getKeyWord(), decode_data.Data)
            if device.platform == "android" then
                decryptionString = self:decodeURI(decryptionString)
            end
            printInfo("--------------decryptionString=%s ",decryptionString)
            local table_data = {}
            table_data.FuncName = decode_data.FuncName
            table_data.Data = decryptionString
            local json_str = cjson.encode(table_data)
            printInfo("--------------json_str=%s",json_str)
            json_str = string.gsub(json_str,"\\","\\\\")
            json_str = string.gsub(json_str,"\"","\\\"")
            local str = string.format("javascript:sendDecryptionToJS(\"%s\")", json_str)
            printInfo("--------------sendstr=%s",str)
            self.mWebView:evaluateJS(str)
        end
    end )

    webview:setOnCloseWebViewCallback( function( sender, url )
        printInfo("OnCloseWebViewCallback, url is %s", url )
        
        if self.mNeedToChangeOrientation == true then
            self.mNeedToChangeOrientation = false
            
            local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
            lua_bridge:changeActivityOrientation(src_orientation)
        end

        self:deactivate()
    end)
   
    self:setKeyWord(keyword)
    if inputParam ~= nil then
        inputParam = self.mWebView:xorEncryption(keyword, inputParam )
    end

    local str = string.format("javascript:clientToJS(%d,%d,\"%s\")", self.mWebViewWidth, self.mWebViewHeight, inputParam ) 
    self.str= str
    self:loadURL(url)
end

function WebViewPart:decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

function WebViewPart:encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

-- 以上是私有接口
-- 注: 不建议外部调用
---------------------------------------------------------------------------------------------------


return WebViewPart 


