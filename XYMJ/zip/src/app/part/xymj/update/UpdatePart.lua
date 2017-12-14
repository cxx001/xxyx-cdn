--[[
*名称:UpdateLayer
*描述:检查更新界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local AssetsDelegate = require("packages.delegate.AssetsDelegate")
local UpdatePart = class("UpdatePart",cc.load('mvc').PartBase,AssetsDelegate) --登录模块
UpdatePart.DEFAULT_VIEW = "UpdateScene"
UpdatePart.DEFAULT_PART = {}

require("app.model.config.SocketConfig")
require("app.model.protobufmsg.update_message_pb")


--[
-- @brief 构造函数
--]
function UpdatePart:ctor(owner)
    UpdatePart.super.ctor(self, owner)
    self.updating = false			--是否正在更新
    self.firstUpdate = true			--是否首次更新
    self:initialize()
end

--[
-- @override
--]
function UpdatePart:initialize()
	self.gameidName = "" .. LOBBY_GAME_ID
	self.manifestName = "version/" .. LOBBY_GAME_ID
	self.hotUpdateUrl = HOT_UPDATE_REPLACE_URL
	--大厅是否热更新
	self.isHotUpdate = false
	
    local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    bridge:getDeviceInfo()
    local netManager = global:getModuleWithId(ModuleDef.NET_MOD)
    print("this is set channel:",DEVICE_INFO.channel)
    netManager:setChannel(tonumber(DEVICE_INFO.channel))
end

--激活模块
function UpdatePart:activate(data)
    UpdatePart.super.activate(self,CURRENT_MODULE_NAME)
    global:setCurrentPart(self)
	
	--检测本地存储的热更新资源版本号，若不为空且与HOT_UPDATE_VERSION不一致，则删除缓存目录下的res和src目录
    self:checkHotUpdateVersion()

	--更新检测网络回应消息注册
	local netManager = global:getModuleWithId(ModuleDef.NET_MOD)
   	netManager:registerMsgListener(SocketConfig.MSG_GET_CHECK_UPDATE_RSP,handler(self,UpdatePart.recvCheckUpdateAck))
	
	--添加一个延迟，等更新页面渲染完毕再开始执行检测更新，避免出现收不到版本检测的消息的情况
	if self.view.schedule_start_update then
		self.view:unScheduler(self.view.schedule_start_update)
		self.view.schedule_start_update = nil
	end

	self.view.schedule_start_update = self.view:schedulerFunc(function()
		self.view:unScheduler(self.view.schedule_start_update)
		self.view.schedule_start_update = nil
		--发送检测更新请求
		if QUICK_START_SUB_GAME == true then --绕过更新检测
			global:run()
		else
			self:sendCheckUpdateReq()
		end
	end,0.1,false)
	
end

--[[
函数名称: sendCheckUpdateReq
函数功能: 发送检测更新请求
参数说明: 无
返回值: 无
--]]
function UpdatePart:sendCheckUpdateReq()
	local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)
	local check_update_msg_req = update_message_pb.GetCheckUpdateMsgReq()
	
	
	--平台类型 【--1：win32--2：Android--4：ios】
	if device.platform == "android" then
		check_update_msg_req.strong_update_src.platform_type = 2
	elseif device.platform == "ios" then
		check_update_msg_req.strong_update_src.platform_type = 4
	else --win32
		check_update_msg_req.strong_update_src.platform_type = 1
	end
	--强更版本号
	check_update_msg_req.strong_update_src.strong_update_ver = STRONG_UPDATE_VERSION
	
	--热更源数据设置
	local user_default = cc.UserDefault:getInstance()
	local user_id = user_default:getIntegerForKey(enUserData.KEY_USER_ID, 0)
	local channel_id = APP_CHANNEL_ID
	--user_id = 123456
	
	--repeated HotUpdateCheck_SourceData嵌套重复结构是用add()增加元素
	local hot_update_data = check_update_msg_req.hot_update_src:add()
	hot_update_data.game_id = SocketConfig.GAME_ID
	hot_update_data.user_id = user_id
	hot_update_data.channel_id = channel_id
	
	--repeated 基础类型数据是用append(具体数值)增加元素
	--check_update_msg_req.hot_update_src:append("1")
	
	--这个获取的是什么版本号?【在哪里面取的】
	local version = cc.Application:getInstance():getVersion()
	print("UpdatePart:sendCheckUpdateReq()--cc.Application:getInstance():getVersion()=", version)
	
	--发送更新检测信息请求
	print("UpdatePart:sendCheckUpdateReq()--请求检测更新，请求数据=", check_update_msg_req)
	net_manager:sendProtoMsg(check_update_msg_req,SocketConfig.MSG_GET_CHECK_UPDATE_REQ,SocketConfig.GAME_ID)
end


--[[
函数名称: recvCheckUpdateAck
函数功能: 收到检测更新回应
参数说明: data：检测更新回应数据
          appID：游戏gameid
返回值: 无
--]]
function UpdatePart:recvCheckUpdateAck(data,appID)
	local check_update_msg_rsp = update_message_pb.GetCheckUpdateMsgRsp()
	check_update_msg_rsp:ParseFromString(data)
	print("UpdatePart:recvCheckUpdateAck--收到更新检测数据=", check_update_msg_rsp)
	
	if check_update_msg_rsp.ret_code ~= 0 then
		printError("UpdatePart:recvCheckUpdateAck--ret_code=%d, check update failed", check_update_msg_rsp.ret_code)
		error("UpdatePart:recvCheckUpdateAck--check update failed")
	end

	-- check_update_msg_rsp.login_mode = 2 -- 测试暂用，等和server联调
	ISAPPSTORE = (check_update_msg_rsp.login_mode == 2)  -- 1：微信登录 2：游客登录
	if ISAPPSTORE then
		QUICK_LOGIN = true
        self.view:setVisibleUpdateInfo(false)
	else
		QUICK_LOGIN = false
        self.view:setVisibleUpdateInfo(true)
	end
	
	local strong_update_url = nil--强更url
	local isStrUpdate = check_update_msg_rsp.strong_update_tge.isStrUpdate
	--isStrUpdate = true--测试用
	if isStrUpdate then--检测需要强更
		
		local android_url = check_update_msg_rsp.strong_update_tge.strupdate_android_url
		local ios_url = check_update_msg_rsp.strong_update_tge.strupdate_ios_url
		
		if device.platform == "android" then--android平台强更url
			strong_update_url = android_url
		elseif device.platform == "ios" then--ios平台强更url
			strong_update_url = ios_url
		else--win32平台强更url
			while (true)--win32平台的强更url为Android或ios强更url
			do
				if android_url and string.len(android_url) > 0 then
					strong_update_url = android_url
					break;
				end
				
				if ios_url and string.len(ios_url) > 0 then
					strong_update_url = ios_url
					break;
				end
				
				strong_update_url = "https://www.baidu.com"
				break;
			end
		end
		
		local tips_part = global:createPart("TipsPart",self)
		tips_part:activate({info_txt=string_table.must_new_version,mid_click=function()
			-- body
			if type(strong_update_url) == "string" and string.len(strong_update_url) > 0 then
				--设置打开强更标记
				local user_default = cc.UserDefault:getInstance()
				user_default:setBoolForKey(enUserData.STRONG_UPDATE_FLAG,true)
				user_default:flush()
				
				print("UpdatePart:recvCheckUpdateAck--强更url=", strong_update_url)
				cc.Application:getInstance():openURL(strong_update_url)
			else
				error("UpdatePart:recvCheckUpdateAck--strong_update_url error")
			end
		end})
		
		--强更提示更新的提示框范例【确定，取消】
--[[		tips_part:activate({info_txt = string_table.update_new_version,
			left_click = function()
				cc.Application:getInstance():openURL(urlname)
			end,
			right_click = function()
				tips_part = nil
				if self.view then
					self.view:setLoginBtnState(true)
				end
			end})--]]
		
	else--检测不需要强更，开始执行热更检测

		--如果没有配置热更数据，直接跳过，进入MyApp
		if check_update_msg_rsp.hot_update_tge == nil or #check_update_msg_rsp.hot_update_tge <= 0 then
		   --运行MyApp
		   global:run()
		   return
		end
		
		local cur_gameid = check_update_msg_rsp.hot_update_tge[1].game_id
		local is_hot_update = check_update_msg_rsp.hot_update_tge[1].isHotUpdate
		local hot_update_url = check_update_msg_rsp.hot_update_tge[1].hotupdate_url
		self.isHotUpdate = is_hot_update
		
		--模拟数据测试用
		--is_hot_update = true
		--目前本地version文件的热更域名是"http://oi7w7wswn.bkt.clouddn.com/"
		--hot_update_url = "http://oontw37mk.bkt.clouddn.com/"
		if is_hot_update then--需要检测热更新
		
			if type(cur_gameid) == number and cur_gameid > 0 then
				self.gameidName = tostring(cur_gameid)
			end
			
			if type(hot_update_url) == "string" and string.len(hot_update_url) > 0 then
				self.hotUpdateUrl = hot_update_url
			end
			printInfo("UpdatePart:recvCheckUpdateAck--当前更新游戏id=%s, 需要替换的热更url=%s", self.gameidName, self.hotUpdateUrl)
			
			--开始执行大厅热更新流程
			self:startUpdateFile()

		else--跳过检测热更新，运行MyApp-初始化其他模块
			
--[[			--创建cc.AssetsManagerEx对象
			if self.am == nil then
				self.am = {}
				self.update_path = cc.FileUtils:getInstance():getWritablePath() .. "/UpdateAssets/"
			end
			
			if self.am[self.manifestName] == nil then
				self.am[self.manifestName] = cc.AssetsManagerEx:create(self.manifestName .. ".manifest",self.update_path)
				self.am[self.manifestName]:retain()
			else
				printInfo("the %s.manifest of cc.AssetsManagerEx is already created",self.manifestName)
			end
			
			--获取本地Manifest文件中的版本号--作为大厅展示的版本号
			local local_manifest = self.am[self.manifestName]:getLocalManifest()
			APP_VERSION = local_manifest:getVersion()
			global:run(APP_VERSION)--]]
			
			--运行MyApp
			global:run()
		end
			
	end
	
end

--AssetsManagerEx热更新回调函数
function UpdatePart:makeListener()
	return function(event)
		local event_code = event:getEventCode()
        local assetId = event:getAssetId() --文件名
        local percent = event:getPercent() --进度
        local message = event:getMessage() --附加信息
       	print("UpdatePart:makeListener()--热更新回调事件信息:",event_code,assetId,percent,message,self.manifestName)
		
		if event_code == 1 then --manifest文件下载错误
			self.updating = false
			self.view:showUpdateMessage("网络连接异常，点击屏幕重试")
        elseif event_code == 2 then --manifest文件解析错误
			self.updating = false
			if not ISAPPSTORE then
				self.view:showUpdateMessage("更新文件解析错误，点击屏幕重试")
			end
        elseif event_code == 3 then --有新版本需要热更
			APP_VERSION = self.am[self.manifestName]:getRemoteManifest():getVersion()
			print("有新版本需要热更，app_version=",APP_VERSION)
       	elseif event_code == 4 then --已经是最新版本
			if self.am and self.am[self.manifestName] then
				APP_VERSION = self.am[self.manifestName]:getLocalManifest():getVersion()
				print("已是最新热更版本，app_version=",APP_VERSION)
			end
			--热更检测结束，运行MyApp
       		global:run()
		elseif event_code == 5 then	--正在热更新下载中
       		self.view:updateProgress(percent)
		elseif event_code == 6 then --已经下载完assets中的一个zip包
		elseif event_code == 7 then --下载assets中的一个zip包出错
		elseif event_code == 8 then --成功热更到最新版本
			if self.am and self.am[self.manifestName] then
				APP_VERSION = self.am[self.manifestName]:getLocalManifest():getVersion()
				print("成功热更到最新版本，app_version=",APP_VERSION)
			end
			--热更流程结束，运行MyApp
       		global:run()
        elseif event_code == 9 then --更新下载assets中的zip包失败【一个zip包下载失败，也算更新失败】
			self.updating = false
			if not ISAPPSTORE then
				self.view:showUpdateMessage("更新失败，点击屏幕重试")
			end
		elseif event_code == 10 then --解压assets中的zip包失败【一个zip包解压失败，也算解压失败】
			self.updating = false
			if not ISAPPSTORE then
				self.view:showUpdateMessage("更新失败，点击屏幕重试")
			end
       	end
	end
end

function UpdatePart:startUpdateFile()
	print("UpdateScene:onCreate()--开始热更新流程")
	if not self.updating then
		self.firstUpdate = false
		self.updating = true
		if not ISAPPSTORE then
			self.view:showUpdateMessage("正在检测更新")
		end
		self:reInitServiceConfig(self.manifestName, self.view, self:makeListener())
		if self.am and self.am[self.manifestName] then
			local gameidName = self.gameidName
			local hotUpdateUrl = self.hotUpdateUrl
			self.am[self.manifestName]:setReplaceHotUpdateUrl(hotUpdateUrl,gameidName)
		end
		self:updateFile(self.manifestName)
	else
		--正在更新中，不执行任何操作
		print("UpdateScene:onCreate()--正在进行热更中...")
	end
end

--更新场景点击回调事件【从UpdateScene调过来】
function UpdatePart:ClickUpdateInfo(...)
	if not self.firstUpdate and self.isHotUpdate then
		self:startUpdateFile()
	end
end

function UpdatePart:checkHotUpdateVersion()
	local localHotUpdateVersion = cc.UserDefault:getInstance():getStringForKey("local_hotupdate_ver_" .. LOBBY_GAME_ID, "")
	if localHotUpdateVersion ~= HOT_UPDATE_VERSION then
		local writablePath = cc.FileUtils:getInstance():getWritablePath() .. "UpdateAssets/"
		local resAssetsPath = writablePath .. "res/"
		local srcAssetsPath = writablePath .. "src/"
		cc.FileUtils:getInstance():removeDirectory(resAssetsPath)
		cc.FileUtils:getInstance():removeDirectory(srcAssetsPath)
		cc.UserDefault:getInstance():setStringForKey("local_hotupdate_ver_" .. LOBBY_GAME_ID, HOT_UPDATE_VERSION)
	end
end

function UpdatePart:deactivate()
  if self.view ~= nil then
    self.view:removeSelf()
    self.view = nil
  end
end

function UpdatePart:getPartId()
	-- body
	return "UpdatePart"
end

return UpdatePart 