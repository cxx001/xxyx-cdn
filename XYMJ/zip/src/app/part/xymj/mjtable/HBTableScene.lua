
local HBTableScene = class("HBTableScene", import(".TableScene"))
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function HBTableScene:updateTableShow(tableInfo)
	print("tableInfo.playwaytype ", tableInfo.playwaytype)
	local playWayTex = self.res_base .. "/"
	local playWay1 = tableInfo.playwaytype   
	for k,v in pairs(RoomConfig.Rule) do 
		if bit._and(playWay1,v.value) == v.value then
			playWayTex = playWayTex..v.tex
			break
		end
	end
	if playWay1 == 0 then
		return
	end
	print(string.format("###[HBTableScene:updateTableShow]playWay1 %02x playWayTex %s", playWay1, playWayTex))
	self.node.table_logo_playway:loadTexture(playWayTex, 1)  

	local logoFile = string.format("%s/table_logo_%d.png", self.res_base, self.part.game_id)
	print("###[HBTableScene:updateTableShow]logoFile ", logoFile)
	self.node.table_logo:loadTexture(logoFile, 1)
	
	local dizhu = tableInfo.diZhu 
	dizhu = dizhu or "0"
	--print("tableInfo.diZhu ",tableInfo.diZhu)
	self.node.table_dizhu:setString("底分:".. dizhu)
end

return HBTableScene
