
local XTCardOptNode = class("XTCardOptNode", import(".CardOptNode"))

function XTCardOptNode:getGangAniByGangType(gangType)
	local texture = nil
	if gangType == RoomConfig.LaiziGang then
		texture = self.res_base .. "/piao.png"
	else
		texture = XTCardOptNode.super.getGangAniByGangType(self, gangType)
	end
	return texture
end

return XTCardOptNode