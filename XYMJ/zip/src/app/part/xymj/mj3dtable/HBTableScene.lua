
local HBTableScene = class("HBTableScene", import(".TableScene"))
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function HBTableScene:updateTableShow(tableInfo) 
	self.playWay1 = 0x01
	local tableNode = self.node.Node_center
	local table_logo = tableNode:getChildByName("table_logo")
	local table_logo_playway = tableNode:getChildByName("table_logo_playway")
	local table_dizhu = tableNode:getChildByName("table_dizhu")

	print("tableInfo.playwaytype ", tableInfo.playwaytype)
	local playWayTex = self.res_base .. "/"
	local playWay1 = tableInfo.playwaytype   
	for k,v in pairs(RoomConfig.Rule) do 
		if bit._and(playWay1,v.value) == v.value then
			playWayTex = playWayTex..v.tex
			self.playWay1 = v.value
			break
		end
	end
	if playWay1 == 0 then
		return
	end
	print(string.format("###[HBTableScene:updateTableShow]playWay1 %02x playWayTex %s", playWay1, playWayTex))
	table_logo_playway:loadTexture(playWayTex, 1)  

	local logoFile = string.format("%s/table_logo_%d.png", self.res_base, self.part.game_id)
	print("###[HBTableScene:updateTableShow]logoFile ", logoFile)
	table_logo:loadTexture(logoFile, 1)
	
	local dizhu = tableInfo.diZhu 
	dizhu = dizhu or "0" 
	table_dizhu:setString("底分:".. dizhu)
end

function HBTableScene:getPlayWay1()
	return self.playWay1
end

return HBTableScene
