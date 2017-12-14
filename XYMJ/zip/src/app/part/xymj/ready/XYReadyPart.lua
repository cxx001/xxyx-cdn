local CURRENT_MODULE_NAME = ...
local ReadyPart = import(".ReadyPart")
local XYReadyPart = class("XYReadyPart",ReadyPart)
XYReadyPart.DEFAULT_VIEW = "XYReadyLayer"

function XYReadyPart:activate(gameId,data,mySeatID)
	XYReadyPart.super.activate(self, gameId, data, mySeatID)

	for i=1,4 do
		if data.kanpai and data.kanpai[i] and (data.kanpai[i] == 1) then
			self.view:showKanPaiCard(i)
		end
	end

	if data.mcards and (#data.mcards.cardvalue == 4) and (#down_cards[1] == 0) then --可以砍牌，需要展示砍牌按钮
		self.view:showKanpaiMenu()
		if self.owner and self.owner.onKanpaiMenuShow then
			self.owner:onKanpaiMenuShow()
		end
	end

	self.view:hideNaozhuangPanel()
	self.payType = data.tableinfo.payType
end

function XYReadyPart:onSelectNaozhuang()
	print("XYReadyPart:onSelectNaozhuang")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = MahjongOperation.MAHJONG_OPERTAION_NAO_ZHUANG
    net_mode:sendProtoMsg(opt_msg,MsgDef.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function XYReadyPart:onSelectTongnao()
	print("XYReadyPart:onSelectTongnao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = MahjongOperation.MAHJONG_OPERTAION_TONG_NAO
    net_mode:sendProtoMsg(opt_msg,MsgDef.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function XYReadyPart:onSelectCancleNaozhuang()
	print("XYReadyPart:onSelectBunao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = MahjongOperation.MAHJONG_OPERTAION_CANCLE_NAO_ZHUANG
    net_mode:sendProtoMsg(opt_msg,MsgDef.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function XYReadyPart:onSelectCancleTongnao()
	print("XYReadyPart:onSelectBunao")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    opt_msg.opid = MahjongOperation.MAHJONG_OPERTAION_CANCLE_TONG_NAO
    net_mode:sendProtoMsg(opt_msg,MsgDef.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

function XYReadyPart:onNotifyNaozhuang()
	self.view:showNaozhuangPanel()
end

function XYReadyPart:onNotifyWaitNaozhuang()
	self.view:showWaitNaozhuangPanel()
end

function XYReadyPart:onNotifyTongnao()
	self.view:showTongnaoPanel()
end

function XYReadyPart:onNotifyWaitTongnao()
	self.view:showWaitTongnaoPanel()
end

function XYReadyPart:onNotifySelectNaozhuan(viewId)
	self.view:showNaozhuangIcon(viewId)
end

function XYReadyPart:onNotifySelectTongnao(viewId)
	self.view:showTongnaoIcon(viewId)
end

function XYReadyPart:onNotifySelectBunao()
	self.view:hideNaozhuangPanel()
end

function XYReadyPart:inviteFriends()
	-- body
	print("tablewating_inviteFriends1")
	if RoomConfig.Ai_Debug then
		local player_info = self:getDebugPlayer()
		local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mod:addPlayer(player_info)
	else
		print("tablewating_inviteFriends2",string_table.game_name[tonumber(SocketConfig.GAME_ID)],SocketConfig.GAME_ID)
		local title = string_table.game_title_yi_chang
		local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
		--string_table.vip_table_invite_wechat="房号：%d，%d局，%s速度来战"
		local tmpStr1 = string_table.vip_table_invite_wechat
		local tmpStr2 = ""
		if self.playwaytype and bit._and(self.playwaytype, 0x40) == 0x40 then
			tmpStr2 = "，"..string_table.playway_type[1]
		else
			tmpStr2 = "，"..string_table.playway_type[2]
		end

		if bit._and(self.playwaytype, 0x20) == 0x20 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_yf
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wf
		end

		if bit._and(self.playwaytype, 0x100) == 0x100 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ykp
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wkp
		end

		if bit._and(self.playwaytype, 0x200) == 0x200 then
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ynz
		else
			tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wnz
		end

		if self.m_totalhand == nil or self.m_totalhand == 0 then
			self.m_totalhand = 4
		end

		if string_table.game_name[tonumber(SocketConfig.GAME_ID)] then
			tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. "，" .. tmpStr1..tmpStr2
		end
		
		local payTypeStr = string_table.pay_type_fz
		if self.payType and self.payType == 1 then
			payTypeStr = string_table.pay_type_aa
		end

		local shareContent = string.format(tmpStr1,self.vip_table_id,self.m_totalhand,payTypeStr)
		local shareUrl = "https://a.mlinks.cc/Ac1j"--string_table.share_weixin_android_url
		--分享内容和分享链接都是从服务器上拉取的
		
		local user = global:getGameUser()
	    local props = user:getProps()
	    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

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

		shareUrl = "https://a.mlinks.cc/Ac1j?gameid=" .. self.game_id .. "&roomid=" .. self.vip_table_id
		bridge:ShareToWX(1,shareContent,shareUrl)
	end
	-- self:addPlayer(player_info)
end

function XYReadyPart:hideReadyBtn()
	self.view:updateVIPOpBtn(false)
end

return XYReadyPart
