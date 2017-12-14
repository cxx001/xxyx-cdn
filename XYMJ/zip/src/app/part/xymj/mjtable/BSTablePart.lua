local CURRENT_MODULE_NAME = ...
local YNTablePart = import(".YNTablePart")
local BSTablePart = class("BSTablePart",YNTablePart)

function BSTablePart:showAnGang() --保山麻将要显示暗杠的牌
	-- body
	return true
end

return BSTablePart