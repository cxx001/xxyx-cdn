local CURRENT_MODULE_NAME = ...
local XNReadyPart = class("XNReadyPart", import(".ReadyPart"))

function XNReadyPart:createShareContent()
	local playWay1 = self.m_tableInfo.playwaytype

	local playWayStr = ""
	for k,v in pairs(RoomConfig.Rule) do 
		if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then
			playWayStr = v.name
			break
		end
	end

	local playWayStr2 = "" 
	for k,v in pairs(RoomConfig.Rule2) do 
		if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then 
			print("### v.name ", v.name)
			playWayStr2 = (playWayStr2 ~= "") and (playWayStr2 ..","..v.name) or v.name 
		end
	end
	playWayStr2 = (playWayStr2 ~= "") and ("("..playWayStr2..")") or ""

	return string.format("正宗咸宁麻将，真实防作弊！房号：%d，局数：%d，%s %s，战个痛快！", 
		self.vip_table_id, self.m_totalhand, playWayStr, playWayStr2)
end

return XNReadyPart
