
local TableScene = import(".TableScene")
local XYTableScene = class("XYTableScene",TableScene)

function XYTableScene:onCreate()
	XYTableScene.super.onCreate(self)
end

function XYTableScene:showNaozhuangIcon(viewId)
	local naozhuangIcon = self.node['icon_naozhuang' .. viewId]
	if naozhuangIcon then
		naozhuangIcon:show()
	end
end

function XYTableScene:showTongnaoIcon(viewId)
	local tongnaoIcon = self.node['icon_tongnao' .. viewId]
	if tongnaoIcon then
		tongnaoIcon:show()
	end
end

function XYTableScene:isNaozhuangIconShow()
	local ret = false

	if self.node.icon_naozhuang1 and self.node.icon_naozhuang1:isVisible() then
		ret = true
	elseif self.node.icon_tongnao1 and self.node.icon_tongnao1:isVisible() then
		ret = true
	end

	return ret
end

function XYTableScene:updateTableShow(tableInfo)
	local tableNode = self.node.Node_center
	local table_logo_playway = tableNode:getChildByName("table_logo_playway")

	local table_logo = tableNode:getChildByName("table_logo")
	local match_playway_str = ''
	local playWayTex = self.res_base .. "/"
	local playWay = tableInfo.playwaytype
	local selectPlayWayType = ""
	if bit._and(playWay, 0x10000) == 0x10000 then
		playWayTex = playWayTex .. "table_logo_wdz.png"
		match_playway_str = string_table.xymj_playway1
		if bit._and(playWay, 0x40) == 0x40 then
			selectPlayWayType = string_table.playway_type_bgz_only 
		elseif bit._and(playWay, 0x80) == 0x80 then
			selectPlayWayType = string_table.playway_type_mtp 
		end
	elseif bit._and(playWay, 0x20000) == 0x20000 then
		playWayTex = playWayTex .. "table_logo_bdy.png"
		match_playway_str = string_table.match_playway2
		if bit._and(playWay, 0x20) == 0x20 then
			selectPlayWayType = string_table.bdy_playway1
		elseif bit._and(playWay, 0x80) == 0x80 then
			selectPlayWayType = string_table.bdy_playway3
		else
			selectPlayWayType = string_table.bdy_playway2
		end
	elseif bit._and(playWay, 0x40000) == 0x40000 then
		playWayTex = playWayTex .. "table_logo_ls.png"
		match_playway_str = string_table.playway_type_ls
		if bit._and(playWay, 0x20) == 0x20 then
			selectPlayWayType = string_table.ls_playway1
		elseif bit._and(playWay, 0x40) == 0x40 then
			selectPlayWayType = string_table.ls_playway2
		else
			selectPlayWayType = string_table.ls_playway3
			self:showLaiziForKanjin()
		end		
	elseif bit._and(playWay, 0x80000) == 0x80000 then
		-- playWayTex = playWayTex .. "table_logo_ls13579.png"
		table_logo:loadTexture(self.res_base .. "/" .. "table_logo_ls13579.png", 1)
		if bit._and(playWay, 0x100) == 0x100 then
			playWayTex = playWayTex .. "dianpiao_lose_one_logo.png"
		elseif bit._and(playWay, 0x80) == 0x80 then
			playWayTex = playWayTex .. "zimo_logo.png"
		else
			playWayTex = playWayTex .. "dianpiao_lose_three_logo.png"
		end
		
		match_playway_str = string_table.playway_type_ls13579
		if bit._and(playWay, 0x20) == 0x20 then
			selectPlayWayType = string_table.ls13579_playway2
		elseif bit._and(playWay, 0x40) == 0x40 then
			selectPlayWayType = string_table.ls13579_playway3
		else
			selectPlayWayType = string_table.ls13579_playway1
		end

		if bit._and(playWay, 0x200) == 0x200 then
			selectPlayWayType = selectPlayWayType .. " " ..  string_table.ls13579_playway4
		else
			selectPlayWayType = selectPlayWayType .. " " ..  string_table.ls13579_playway5
		end
	else
		playWayTex = ""
	end

		
	if playWayTex == "" then
		table_logo_playway:hide()
	else
		table_logo_playway:loadTexture(playWayTex, 1)
		table_logo_playway:show()
	end

	local table_dizhu = tableNode:getChildByName("table_dizhu")
	table_dizhu:setString(selectPlayWayType)

	-- @ add by jarry
	if self.part.match_mode then
		-- @ 比赛规则
		local ui_match_rule = tableNode:getChildByName('match_rule')
		ui_match_rule:setString(selectPlayWayType)

		-- @ 胡法
		local ui_match_playway = tableNode:getChildByName('match_playway')
		ui_match_playway:setString(match_playway_str)

		-- @ 隐藏vip、金币场缺省ui
		table_logo_playway:hide()
		table_dizhu:hide()
	end
end

function XYTableScene:showLaiziForKanjin()
	local diffY = 60
	if self.node.quanBg then
		self.node.quanBg:setPositionY(self.node.quanBg:getPositionY() - diffY)
	end
	if self.node.lefttop_dark_bg3 then
		self.node.lefttop_dark_bg3:setPositionY(self.node.lefttop_dark_bg3:getPositionY() - diffY)
	end
end

return XYTableScene