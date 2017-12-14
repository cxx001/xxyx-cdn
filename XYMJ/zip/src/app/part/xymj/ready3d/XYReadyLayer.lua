
local ReadyLayer = import(".ReadyLayer")
local XYReadyLayer = class("XYReadyLayer",ReadyLayer)

function XYReadyLayer:updateTableShow(tableInfo)
	local tableNode = self.node.tableNode
	local table_logo_playway = tableNode:getChildByName("table_logo_playway")

	local playWayTex = self.res_base .. "/"
	local playWay = tableInfo.playwaytype
	local selectPlayWayType = ""
	local table_logo = tableNode:getChildByName("table_logo")
		
	if bit._and(playWay, 0x10000) == 0x10000 then
		playWayTex = playWayTex .. "table_logo_wdz.png"
		if bit._and(playWay, 0x40) == 0x40 then
			selectPlayWayType = string_table.playway_type_bgz_only 
		elseif bit._and(playWay, 0x80) == 0x80 then
			selectPlayWayType = string_table.playway_type_mtp 
		end
	elseif bit._and(playWay, 0x20000) == 0x20000 then
		playWayTex = playWayTex .. "table_logo_bdy.png"
		if bit._and(playWay, 0x20) == 0x20 then
			selectPlayWayType = string_table.bdy_playway1
		elseif bit._and(playWay, 0x80) == 0x80 then
			selectPlayWayType = string_table.bdy_playway3
		else
			selectPlayWayType = string_table.bdy_playway2
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
		if bit._and(playWay, 0x20) == 0x20 then
			selectPlayWayType = string_table.ls13579_playway2 --8套
		elseif bit._and(playWay, 0x40) == 0x40 then
			selectPlayWayType = string_table.ls13579_playway3 --10套
		else
			selectPlayWayType = string_table.ls13579_playway1 --5套
		end

		if bit._and(playWay, 0x200) == 0x200 then
			selectPlayWayType = selectPlayWayType .. "  " .. string_table.ls13579_playway4 -- 独赢
		else
			selectPlayWayType = selectPlayWayType .. "  " .. string_table.ls13579_playway5 -- 无独赢
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

end

return XYReadyLayer