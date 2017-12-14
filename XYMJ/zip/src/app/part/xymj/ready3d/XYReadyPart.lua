local CURRENT_MODULE_NAME = ...
local ReadyPart = import(".ReadyPart")
local XYReadyPart = class("XYReadyPart",ReadyPart)
XYReadyPart.DEFAULT_VIEW = "XYReadyLayer"

function XYReadyPart:activate(gameId,data,mySeatID)
	XYReadyPart.super.activate(self, gameId, data, mySeatID)
	self.payType = data.tableinfo.payType
end

-- function XYReadyPart:inviteFriends()
-- 	-- body
-- 	print("tablewating_inviteFriends1")
-- 	if RoomConfig.Ai_Debug then
-- 		local player_info = self:getDebugPlayer()
-- 		local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
-- 		ai_mod:addPlayer(player_info)
-- 	else
-- 		print("tablewating_inviteFriends2",string_table.game_name[tonumber(SocketConfig.GAME_ID)],SocketConfig.GAME_ID)
-- 		local title = string_table.game_title_yi_chang
-- 		local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
-- 		--string_table.vip_table_invite_wechat="房号：%d，%d局，%s速度来战"
-- 		local tmpStr1 = string_table.vip_table_invite_wechat
-- 		local tmpStr2 = ""

-- 		print("XXXXXX -----1----- ", self.playwaytype)
-- 		if self.playwaytype and bit._and(self.playwaytype, 0x10000) == 0x10000 then
-- 			print("XXXXXX -----2-----")
-- 			if self.playwaytype and bit._and(self.playwaytype, 0x40) == 0x40 then
-- 				tmpStr2 = "，"..string_table.playway_type[1]
-- 			else
-- 				tmpStr2 = "，"..string_table.playway_type[2]
-- 			end

-- 			if bit._and(self.playwaytype, 0x20) == 0x20 then
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_yf
-- 			else
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wf
-- 			end

-- 			if bit._and(self.playwaytype, 0x100) == 0x100 then
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ykp
-- 			else
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wkp
-- 			end

-- 			if bit._and(self.playwaytype, 0x200) == 0x200 then
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_ynz
-- 			else
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.playway_type_wnz
-- 			end
-- 		else
-- 			print("XXXXXX -----3-----")
-- 			tmpStr2 = "，"..string_table.playway_type[3]
-- 			if bit._and(self.playwaytype, 0x20) == 0x20 then
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
-- 			elseif bit._and(self.playwaytype, 0x80) == 0x80 then
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
-- 			else
-- 				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
-- 			end
-- 		end

-- 		if self.m_totalhand == nil or self.m_totalhand == 0 then
-- 			self.m_totalhand = 4
-- 		end

-- 		if string_table.game_name[tonumber(SocketConfig.GAME_ID)] then
-- 			tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. "，" .. tmpStr1..tmpStr2
-- 		end

-- 		local payTypeStr = string_table.pay_type_fz
-- 		if self.payType and self.payType == 1 then
-- 			payTypeStr = string_table.pay_type_aa 
-- 		end
		
-- 		local shareContent = string.format(tmpStr1,self.vip_table_id,self.m_totalhand,payTypeStr)
-- 		local shareUrl = string_table.share_weixin_android_url
-- 		--分享内容和分享链接都是从服务器上拉取的
		
-- 		local user = global:getGameUser()
-- 	    local props = user:getProps()
-- 	    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

-- 	    for i,v in ipairs(gameConfigList) do
-- 	    	local gameParam = gameConfigList[i]
-- 			if device.platform == "android" then
-- 				if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
-- 					if gameParam.valueStr then
-- 						shareUrl = gameParam.valueStr --分享链接
-- 					end
-- 				end
-- 			elseif device.platform == "ios" then
-- 				if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
-- 					if gameParam.valueStr then
-- 						shareUrl = gameParam.valueStr --分享链接
-- 					end
-- 				end
-- 			end
-- 		end

-- 		bridge:ShareToWX(1,shareContent,shareUrl)
-- 	end
-- 	-- self:addPlayer(player_info)
-- end

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
		local tmpStr1 = string_table.vip_table_invite_wechat_xy
		local tmpStr2 = ""

		if (self.playwaytype and bit._and(self.playwaytype, 0x10000) == 0x10000) then
			--添加玩法
			-- title = "未来信阳麻将"
			title = string_table.game_title_xin_yang
			if self.playwaytype and bit._and(self.playwaytype, 0x40) == 0x40 then
				tmpStr2 = "，"..string_table.playway_type_bgz
			else
				tmpStr2 = "，"..string_table.playway_type_mtp
			end

			if bit._and(self.playwaytype, 0x400) == 0x400 then --点炮输一家
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3
			elseif bit._and(self.playwaytype, 0x1000) == 0x1000 then --自摸胡
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
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
		elseif (self.playwaytype and bit._and(self.playwaytype, 0x20000) == 0x20000) then
			-- tmpStr2 = "，"..string_table.playway_type_bdy
			-- title = "未来信阳扳倒赢"
			title = string_table.game_title_xin_yang_bdy
			if bit._and(self.playwaytype, 0x20) == 0x20 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
			elseif bit._and(self.playwaytype, 0x80) == 0x80 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
			end

			if bit._and(self.playwaytype, 0x40) == 0x40 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway5 --无风
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway4 --乱三风
			end

			if bit._and(self.playwaytype, 0x200) == 0x200 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway6 --跑子
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway7 --无跑子
			end
		elseif (self.playwaytype and bit._and(self.playwaytype, 0x80000) == 0x80000) then
			-- tmpStr2 = "，"..string_table.playway_type_bdy
			-- title = "罗山13579"
			title = string_table.game_title_xin_yang_ls13579
			if bit._and(self.playwaytype, 0x80) == 0x80 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
			elseif bit._and(self.playwaytype, 0x100) == 0x100 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
			end

			if bit._and(self.playwaytype, 0x20) == 0x20 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway2 -- 8套
			elseif bit._and(self.playwaytype, 0x40) == 0x40 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway3 -- 10套
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway1 -- 5套
			end

			if bit._and(self.playwaytype, 0x200) == 0x200 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway4 --独赢
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls13579_playway5 --无独赢
			end
		else
			-- tmpStr2 = "，"..string_table.playway_type[4]
			-- title = "未来罗山麻将"
			title = string_table.game_title_xin_yang_ls
			if bit._and(self.playwaytype, 0x20) == 0x20 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway1 --活嘴
			elseif bit._and(self.playwaytype, 0x40) == 0x40 then
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway2 --死嘴
			else
				tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway3 --坎金
			end			

			if bit._and(self.playwaytype, 0x20) == 0x20 or bit._and(self.playwaytype, 0x40) == 0x40 then
				if bit._and(self.playwaytype, 0x100) == 0x100 then
					tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway1 --自摸胡
				elseif bit._and(self.playwaytype, 0x200) == 0x200 then
					tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway3 --点炮输一家
				else
					tmpStr2 = tmpStr2 .. "，" .. string_table.bdy_playway2 --点炮输三家
				end

				if bit._and(self.playwaytype, 0x400) == 0x400 then
					tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway4 --有甩张
				else
					tmpStr2 = tmpStr2 .. "，" .. string_table.ls_playway5 --不甩张
				end
			end
		end

		if self.m_totalhand == nil or self.m_totalhand == 0 then
			self.m_totalhand = 4
		end

		--添加子游戏名称
		-- if string_table.game_name[tonumber(SocketConfig.GAME_ID)] then
		-- 	--tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. "，" .. tmpStr1..tmpStr2
		-- 	tmpStr1 = string_table.game_name[tonumber(SocketConfig.GAME_ID)] .. tmpStr1..tmpStr2
		-- end
		
		tmpStr1 = tmpStr1 .. tmpStr2

		local payTypeStr = string_table.pay_type_fz
		if self.payType and self.payType == 1 then
			payTypeStr = string_table.pay_type_aa
		end

		title = title .. "，" .. string_table.vip_table_invite_tableId
		local titleStr = string.format(title, self.vip_table_id)
		local  shareContent = string.format(tmpStr1,self.m_totalhand,payTypeStr)
		local shareUrl = (self.mw_url ~= "") and self.mw_url or "https://b.mlinks.cc/Ac1j"--string_table.share_weixin_android_url
		--分享内容和分享链接都是从服务器上拉取的
		
		-- local user = global:getGameUser()
	 --    local props = user:getProps()
	 --    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

	 --    for i,v in ipairs(gameConfigList) do
	 --    	local gameParam = gameConfigList[i]
		-- 	if device.platform == "android" then
		-- 		if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
		-- 			if gameParam.valueStr then
		-- 				shareUrl = gameParam.valueStr --分享链接
		-- 			end
		-- 		end
		-- 	elseif device.platform == "ios" then
		-- 		if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
		-- 			if gameParam.valueStr then
		-- 				shareUrl = gameParam.valueStr --分享链接
		-- 			end
		-- 		end
		-- 	end
		-- end

		shareUrl = shareUrl .. "?gameid=" .. self.game_id .. "&roomid=" .. self.vip_table_id
		if bridge.ShareToWXWithTitle then
			bridge:ShareToWXWithTitle(1,titleStr,shareContent,shareUrl)
		else
			local initTitle = string_table.game_title_yi_chang
			string_table.game_title_yi_chang = titleStr
			bridge:ShareToWX(1,shareContent,shareUrl)
			string_table.game_title_yi_chang = initTitle
		end
	end
	-- self:addPlayer(player_info)
end

function XYReadyPart:hideReadyBtn()
	if self.view then
		self.view:updateVIPOpBtn(false)
	end
end

return XYReadyPart
