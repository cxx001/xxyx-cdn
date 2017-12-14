--[[
*名称:TableLayer
*描述:牌桌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local TableScene = class("TableScene",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
TableScene.MENU_ZORDER = 4
function TableScene:onCreate()
	release_print(os.date("%c") .. "[info] 进入牌桌页面")

	if not self.part.match_mode then
		self:initWithFilePath("TableScene",CURRENT_MODULE_NAME,true)
	else
		self:initWithFilePath('matchTableScene', CURRENT_MODULE_NAME, true)
	end

	if self.part.match_mode then
		self.node.bg:hide()
		self.node.match_bg:show()
		self.node.bg_zt_002_1:loadTexture(self.res_base .. '/match_bg_zt_002.png')
		self.node.table_logo:loadTexture(self.res_base .. '/match_logo.png', 1)
		self.node.match_rule:show()
		self.node.match_playway:show()

		self.node.bg_zt_001_1:hide()
		self.node.table_dizhu:hide()
		self.node.table_logo_playway:hide()

		local cpt_info = self.part.cpt_info
		self.node.match_title:setString(cpt_info.cptTitle)
		self.node.match_title:show()
	else
		self.node.match_bg:hide()
		self.node.match_rule:hide()
		self.node.match_playway:hide()
	end

	local date_txt =os.date("%Y-%m-%d")
	self.node.day_txt:setString(date_txt)

	self.node.chat_btn:setLocalZOrder(1000)
	self.part:reSet()
		--self.node.dipan:hide()

	-- local temp_node = self.node.menu_select_right:clone()
	-- temp_node:hide()
	-- temp_node:setName("menu_select_node")
	-- self:addChild(temp_node,TableScene.MENU_ZORDER)

	-- local anim = Util.createSpineAnimationLoop("res/ynmj/room/resource/sp/zi_xiaoguo/ZI_anniu", "guangquan");
 --    self:addChild(anim, 2000);
	-- anim:setScale(1.5);
	-- anim:setPosition(cc.p(display.width / 2, display.height / 2));
end

--点击向左按钮，则弹出设置 退出等按钮
function TableScene:MenuLeftClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	--self:turnSeat(1)
	self.node.menu_select_left:hide()
	local temp_node = self:getChildByName("menu_select_node")
	temp_node:show()
	local pz_bg = temp_node:getChildByName("pz_bg")
	local close_room_btn = pz_bg:getChildByName("close_room_btn")
	local exit_btn = pz_bg:getChildByName("exit_btn")

	local tableId = self.part:getTableid()
	if tableId and tableId > 0 then
		close_room_btn:show()
		exit_btn:hide()
	else
		close_room_btn:hide()
		exit_btn:show()
	end
end

-- 点击向右按钮，则隐藏设置 退出等按钮
function TableScene:MenuRightClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	-- self.node.menu_select_left:show()
	-- self.node.menu_select_right:hide()

end


function TableScene:hideMenu()
	-- body
	-- local temp_node = self:getChildByName("menu_select_node")
	-- temp_node:hide()
end

function TableScene:ExitClick()
	global:getAudioModule():playSound("res/sound/confirm.mp3",false)
	self.part:exitClick()
end

function TableScene:SettingsClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:settingsClick()
end

-- TODO: 按钮放大效果
function TableScene:MenuCtlClick(sender)
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:menuCtlClick(sender)
end


function TableScene:ChatClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:chatClick()
end

function TableScene:OneClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(1)
end

function TableScene:TwoClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(2)
end

function TableScene:ThreeClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(3)
end

function TableScene:FourClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(4)
end

function TableScene:HeadClick(viewId)
	local player_info = self.part:getPlayerInfo(viewId)
	print("HeadClick player_info :",player_info)
	local posX = self.node['head_bg'..viewId]:getPositionX()
	local posY = self.node['head_bg'..viewId]:getPositionY()
	self.part:headClick(player_info , posX , posY , viewId)
end

function TableScene:initTableWithData(playerList,data)
	-- body
	for i,v in ipairs(playerList) do
		if i > 4 then
			return
		else
			self:showPlayer(v)
			print("this is show banker:",v.tablepos,data.dealerpos)
			if v.tablepos == data.dealerpos then
				self.node["bank_icon" .. v.view_id]:show()
			end
		end
	end

	-- self:updateLastCardNum(data.last_card_num)
end

function TableScene:dispalyQuan(currentQuan,totalQuan) --显示当前局数和总局数 1/4局
	local quanStr = string.format("%d/%d%s",currentQuan,totalQuan,string_table.ju_shu)
	self.node.quanBg:show()
	self.node.quanLabel:setString(quanStr)
	release_print(os.date("%c") .. "[info] 牌桌页面展示当前局数 ", currentQuan,totalQuan)
end

function TableScene:offlinePlayer(offlinePos,online)
	-- local name = self.node['name' .. offlinePos]
	-- if online then
	--     name:setColor({r=255,g=255,b=255})
 --    else
 --        name:setColor({r=0,g=0,b=0})
 --    end
 	release_print(os.date("%c") .. "[info] 牌桌页面展示玩家在线状态 ", offlinePos,online)
	if online then
		self.node['offline_icon' .. offlinePos]:hide()
	else
		self.node['offline_icon' .. offlinePos]:show()
	end
end

--剩下多少张
function TableScene:updateLastCardNum(num)
	-- body
	-- self.node.table_info_txt:setString(string.format(string_table.cards_left_txt,num))
	-- 艺术数字
	-- self.node.txt_remaind_card:setString(tostring(num));
end

--显示房号
function TableScene:setRoomID(data)
	release_print(os.date("%c") .. "[info] 牌桌页面展示桌子id ", data.tableinfo.viptableid)
	if 	data.tableinfo.viptableid > 0 then
		self.node.lefttop_dark_bg3:show()
		self.node.txt_num_card:setString(data.tableinfo.viptableid)
	else
		self.node.lefttop_dark_bg3:hide()
	end
end

--根据玩家信息显示玩家
-- view_id 是经过转换的界面位置
function TableScene:showPlayer(playerInfo)
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 4 then
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		head_node:show()
		name:setString(playerInfo.name)
		coin:setString(playerInfo.coin)

		print("---playerInfo.targetPlayerName : ",playerInfo.targetPlayerName)
		print("---playerInfo.headImgUrl : ",playerInfo.headImgUrl)
		if playerInfo.targetPlayerName ~= nil then
			if playerInfo.targetPlayerName and playerInfo.targetPlayerName ~= "" then
				self.part:loadHeadImg(playerInfo.targetPlayerName,head_node)
			end
		else 	
			if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
				self.part:loadHeadImg(playerInfo.headImgUrl,head_node)
			end
		end
	end
end

function TableScene:updatePlayerInfo(playerList)
	-- body
	for i,v in ipairs(playerList) do
		if i > 4 then
			return
		else
			self:showPlayer(v)
		end
	end
end

function TableScene:showGoldOrVipText(isVip,tableId)
	if self.node.goldOrRoomIdLabel then
		if isVip == true  then
			local roomId = string.format(string_table.room_idx_txt,tableId)
			self.node.goldOrRoomIdLabel:setString(roomId)
		else
			self.node.goldOrRoomIdLabel:setString(string_table.gold_play_txt)
		end
	end
end


 --返回座位坐标用于播放表情动画
function TableScene:getPosTable()
	-- body
	local pos_table = {}
	for i=1,RoomConfig.TableSeatNum do
		local head_node = self.node["head_bg" .. i]
		local head_content = head_node:getContentSize()
		local pos 
		if i == RoomConfig.DownSeat or i == RoomConfig.FrontSeat then
			pos = cc.pSub(cc.p(head_node:getPosition()),cc.p(head_content.width*2/5,0))
		else 
			pos = cc.pAdd(cc.p(head_node:getPosition()),cc.p(head_content.width*4/5,0)) 
		end
		table.insert(pos_table,pos)
	end
	return pos_table
end

--轮到某个位置
--seat 逻辑座位 1 -4
function TableScene:turnSeat(seat,time)
	-- body
	for i=1,RoomConfig.TableSeatNum do
		self.node["bearing"..i-1]:stopAllActions()
		self.node["bearing" .. i-1]:hide()
	end
	local cur_bearing = self.node["bearing" .. seat-1]
	cur_bearing:show()
	local seq = cc.Sequence:create(cc.FadeOut:create(1),cc.FadeIn:create(1))
	local action = cc.Repeat:create(seq,RoomConfig.WaitTime/2)
	cur_bearing:runAction(action)
	self:startCountTime(time)
	release_print(os.date("%c") .. "[info] 牌桌页面展示轮到玩家出牌，开始倒计时 ", seat,time)
end

--根据庄家设置方位
function TableScene:setBearingByBanker(banker)
-- loadTexture(frame_name,1)
	local tb = {}
	tb[RoomConfig.MySeat]="loc_e"
	tb[RoomConfig.DownSeat]="loc_n"
	tb[RoomConfig.FrontSeat]="loc_w"
	tb[RoomConfig.UpSeat]="loc_s"

	local cardViewIdName = tb[banker]
	local bearing0 = self.node["bearing0"]
	local bearing1 = self.node["bearing1"]
	local bearing2 = self.node["bearing2"]
	local bearing3 = self.node["bearing3"]

	local bearing0_fixed = self.node["bearing0_fixed"]
	local bearing1_fixed = self.node["bearing1_fixed"]
	local bearing2_fixed = self.node["bearing2_fixed"]
	local bearing3_fixed = self.node["bearing3_fixed"]

	if cardViewIdName ==nil then return end

	local nomalBearing0_fixed = self.res_base.."/"..cardViewIdName.."/down.png"
	local nomalBearing0 = self.res_base.."/"..cardViewIdName.."/down_light.png"
	--app/part/mj3dtable/res/loc_w/down.png
	print("nomalBearing3_fixed-----------:"..nomalBearing0_fixed)
	bearing0_fixed:loadTexture(nomalBearing0_fixed)
	bearing0:loadTexture(nomalBearing0)

	local nomalBearing1_fixed = self.res_base.."/"..cardViewIdName.."/right.png"
	local nomalBearing1 = self.res_base.."/"..cardViewIdName.."/right_light.png"
	bearing1_fixed:loadTexture(nomalBearing1_fixed)
	bearing1:loadTexture(nomalBearing1)

	local nomalBearing2_fixed = self.res_base.."/"..cardViewIdName.."/up.png"
	local nomalBearing2 = self.res_base.."/"..cardViewIdName.."/up_light.png"
	bearing2_fixed:loadTexture(nomalBearing2_fixed)
	bearing2:loadTexture(nomalBearing2)

	local nomalBearing3_fixed = self.res_base.."/"..cardViewIdName.."/left.png"
	local nomalBearing3 = self.res_base.."/"..cardViewIdName.."/left_light.png"
	bearing3_fixed:loadTexture(nomalBearing3_fixed)
	bearing3:loadTexture(nomalBearing3)

	-- cur_bearing:show()
end

function TableScene:CloseRoomClick()
	-- body
	self.part:closeVipRoom()
end

--打开玩法
function TableScene:openPlayWay()
	if self.part.openPlayWay then
		self.part:openPlayWay()
	end
end

--开始倒计时
function TableScene:startCountTime(lastTime)
	-- body
	local cur_time = 1
	local wait_time = RoomConfig.WaitTime

	if lastTime then
		wait_time = lastTime
	end

	if self.time_entry then --如果正在计时就重新开始
		self:unScheduler(self.time_entry)
	end
	self.node.bearing_time:show()
	self.node.bearing_time:setString(wait_time)
	self.time_entry = self:schedulerFunc(function()
		-- body
		if cur_time > wait_time then
			-- self.node.bearing_time:hide()
			self:unScheduler(self.time_entry)
			return
		end
		local time = wait_time - cur_time
		if time < 10 then
			time = "0" .. time
		end
		self.node.bearing_time:setString(time)
		cur_time = cur_time + 1
	end,1,false)
end

--是否显示解散房间按钮
function TableScene:isShowCloseBtn(flag)
--[[ TODO:解散房间按钮在二级菜单
    if flag == true then 
		self.node.close_room_btn:show()
	else
		self.node.close_room_btn:hide()
	end ]]
end
function TableScene:onEnter()
    self.part:onEnter()
end

function TableScene:onExit()
    self.part:onExit()
end

return TableScene
