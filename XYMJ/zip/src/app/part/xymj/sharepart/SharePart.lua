 local CURRENT_MODULE_NAME = ...
local SharePart = class("SharePart",cc.load('mvc').PartBase) --分享组件
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".get_config_message_pb")
SharePart.DEFAULT_PART = {}
SharePart.DEFAULT_VIEW = ""
SharePart.CMD = {
	MSG_GET_GAME_CONFIG_REQ = 0x01000013,
	MSG_GET_GAME_CONFIG_RSP = 0x01000014,
}

--[
-- @brief 构造函数
--]
function SharePart:ctor(owner)
    SharePart.super.ctor(self, owner)
    self:initialize() 
end

function SharePart:activate(gameID)
 	self.game_id = gameID
 	self:getConfigFromServer()

 	local partId = self:getPartId()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(SharePart.CMD.MSG_GET_GAME_CONFIG_RSP,handler(self,SharePart.onGetConfigFromServer), partId)
end

  
function SharePart:getPartId()
    -- body
    return "SharePart"
end

function SharePart:deactivate() 
	print("###[SharePart:deactivate]this is deactivate") 
end

function SharePart:inviteFriends(tableInfo)  
	local shareContent = self:createShareContent(tableInfo)
	local shareTitle = self:createShareTitle(tableInfo)
	local shareUrl = self:createShareUrl(tableInfo)
	print("###[SharePart:inviteFriends] shareContent is ", shareContent)
	local initTitle = string_table.game_title_yi_chang
	string_table.game_title_yi_chang = shareTitle
	global:getModuleWithId(ModuleDef.BRIDGE_MOD):ShareToWX(1,shareContent,shareUrl)
	string_table.game_title_yi_chang = initTitle
end

function SharePart:getConfigFromServer()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local get_config_req = get_config_message_pb.GetAnnoucementReq()
	net_mode:sendProtoMsg(get_config_req,SharePart.CMD.MSG_GET_GAME_CONFIG_REQ,self.game_id)
end

function SharePart:onGetConfigFromServer(data,appId)
	local get_config_rsp = get_config_message_pb.GetAnnouncementRsp()
	get_config_rsp:ParseFromString(data)
	print("ReadyPart:onGetConfigFromServer:", get_config_rsp)

	if get_config_rsp then
		local msg = {} 
		for i,v in ipairs(get_config_rsp.msg) do
			if v.paraId == 8301 then
				self.mw_url = v.valueStr
			end
		end
		print("this is magic window url : ", self.mw_url)
	end
end

-- function SharePart:createShareContent(tableInfo)
-- 	local tmpStr1 = RoomConfig.InviteFormat or "潜江麻将,真实防作弊!房号:%d，局数:%d,%s%s,底分%d分,%s支付,战个痛快!"

-- 	local playWayStr = ""
-- 	local playWay1 = tableInfo.playwaytype
-- 	for k,v in pairs(RoomConfig.Rule) do 
-- 		if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then
-- 			playWayStr = v.name
-- 			break
-- 		end
-- 	end 

-- 	print("tableInfo.playwaytype ", tableInfo.playwaytype)

-- 	local playWayStr2 = ""
-- 	if bit._and(playWay1,0x10000) == 0x10000 then
-- 		for k,v in pairs(RoomConfig.Rule2) do 
-- 			if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then 
-- 				playWayStr2 = playWayStr2 ~= "" and playWayStr2 ..","..v.name or v.name 
-- 			end
-- 		end
-- 	elseif bit._and(playWay1,0x10000) == 0x10000 then
-- 		if bit._and(playWay1,0x20) == 0x20 then
-- 			playWayStr2 = string_table.bdy_playway1
-- 		elseif bit._and(playWay1,0x80) == 0x80 then
-- 			playWayStr2 = string_table.bdy_playway3
-- 		else
-- 			playWayStr2 = string_table.bdy_playway2
-- 		end
-- 	else

-- 	end

-- 	-- playWayStr2 = playWayStr2 ~= "" and "("..playWayStr2..")" or ""
-- 	-- if "" ~= playWayStr2 then
-- 	-- 	tmpStr1 = RoomConfig.InviteFormatSimple
-- 	-- end

-- 	local difenStr = tonumber(tableInfo.diZhu) 
-- 	local tableID = tonumber(tableInfo.viptableid)
-- 	local payType = "房主"
-- 	local contentStr = string.format(tmpStr1,playWayStr, playWayStr2, tableID, tableInfo.totalhand, payType)
-- 	return contentStr
-- end

function SharePart:createShareTitle(tableInfo)
	local title = string_table.game_title_yi_chang
	if (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x10000) == 0x10000) then
		-- title = "未来信阳麻将"
		title = string_table.game_title_xin_yang
	elseif (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x20000) == 0x20000) then
		-- title = "未来信阳扳倒赢"
		title = string_table.game_title_xin_yang_bdy
	elseif (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x80000) == 0x80000) then
		-- title = "未来罗山13579"
		title = string_table.game_title_xin_yang_ls13579
	else
		-- title = "未来罗山麻将"
		title = string_table.game_title_xin_yang_ls
	end
	title = title  .. "，" .. string_table.vip_table_invite_tableId
	local titleStr = string.format(title, tableInfo.viptableid)
	return titleStr
end

function SharePart:createShareContent(tableInfo)
	local tmpStr1 = string_table.vip_table_invite_wechat_xy
	local tmpStr2 = ""
	
	if (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x10000) == 0x10000) then
		if tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x40) == 0x40 then
			tmpStr2 = "，"..string_table.playway_type_bgz
		else
			tmpStr2 = "，"..string_table.playway_type_mtp
		end

		if bit._and(tableInfo.playwaytype, 0x400) == 0x400 then --点炮输一家
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3
		elseif bit._and(tableInfo.playwaytype, 0x1000) == 0x1000 then --自摸胡
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
		end

		if bit._and(tableInfo.playwaytype, 0x20) == 0x20 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_yf
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wf
		end

		if bit._and(tableInfo.playwaytype, 0x100) == 0x100 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ykp
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wkp
		end

		if bit._and(tableInfo.playwaytype, 0x200) == 0x200 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ynz
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wnz
		end
	elseif (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x20000) == 0x20000) then
		-- tmpStr2 = "，"..string_table.playway_type[3]
		if bit._and(tableInfo.playwaytype, 0x20) == 0x20 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
		elseif bit._and(tableInfo.playwaytype, 0x80) == 0x80 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
		end

		if bit._and(tableInfo.playwaytype, 0x40) == 0x40 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway5 --无风
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway4 --乱三风
		end

		if bit._and(tableInfo.playwaytype, 0x200) == 0x200 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway6 --跑子
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway7 --无跑子
		end
	elseif (tableInfo.playwaytype and bit._and(tableInfo.playwaytype, 0x80000) == 0x80000) then
		if bit._and(tableInfo.playwaytype, 0x80) == 0x80 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
		elseif bit._and(tableInfo.playwaytype, 0x100) == 0x100 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
		end

		if bit._and(tableInfo.playwaytype, 0x20) == 0x20 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway2 -- 8套
		elseif bit._and(tableInfo.playwaytype, 0x40) == 0x40 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway3 -- 10套
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway1 -- 5套
		end

		if bit._and(tableInfo.playwaytype, 0x200) == 0x200 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway4 --独赢
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway5 --无独赢
		end
	else
		-- tmpStr2 = "，"..string_table.playway_type[4]
		if bit._and(tableInfo.playwaytype, 0x20) == 0x20 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway1 --活嘴
		elseif bit._and(tableInfo.playwaytype, 0x40) == 0x40 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway2 --死嘴
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway3 --坎金
		end	

		if bit._and(tableInfo.playwaytype, 0x20) == 0x20 or bit._and(tableInfo.playwaytype, 0x40) == 0x40 then
			if bit._and(tableInfo.playwaytype, 0x100) == 0x100 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
			elseif bit._and(tableInfo.playwaytype, 0x200) == 0x200 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
			end

			if bit._and(tableInfo.playwaytype, 0x400) == 0x400 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway4 --有甩张
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway5 --不甩张
			end
		end		
	end

	if tableInfo.m_totalhand == nil or tableInfo.m_totalhand == 0 then
		tableInfo.m_totalhand = 4
	end

	-- 添加子游戏名称
	-- if string_table.game_name[tonumber(SocketConfig.GAME_ID)] then
	-- 	--tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. "，" .. tmpStr1..tmpStr2
	-- 	tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. tmpStr1..tmpStr2
	-- end
	
	tmpStr1 = tmpStr1 .. tmpStr2

	local payTypeStr = string_table.pay_type_fz
	-- if tableInfo.payType and tableInfo.payType == 1 then
	-- 	payTypeStr = string_table.pay_type_aa
	-- end

	local shareContent = string.format(tmpStr1,tableInfo.totalhand,payTypeStr)
	return shareContent
end

function SharePart:createShareUrl(tableInfo)
	local shareUrl = string_table.share_weixin_android_url
	--分享内容和分享链接都是从服务器上拉取的
	local gameConfigList = global:getGameUser():getProps()["gameplayer" .. self.game_id].gameConfigList

	for i,v in ipairs(gameConfigList) do
		local gameParam = gameConfigList[i]
		if device.platform == "android" then
			if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
				if gameParam.valueStr then
					shareUrl = gameParam.valueStr --分享链接
				end
			end
		elseif device.platform == "ios" then
			if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
				if gameParam.valueStr then
					shareUrl = gameParam.valueStr --分享链接
				end
			end
		end
	end

	shareUrl = self.mw_url and self.mw_url or shareUrl
	shareUrl = shareUrl .. "?gameid=" .. self.game_id .. "&roomid=" .. tableInfo.viptableid

	return shareUrl
end

return SharePart