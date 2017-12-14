local CURRENT_MODULE_NAME = ...
local CardPart = import(".CardPart")
local HZCardPart = class("HZCardPart",CardPart)
HZCardPart.DEFAULT_VIEW = "CardLayer"

function HZCardPart:refreshBaoCardOnPart(baoCard)
	-- body
	print("HZ NO refreshBaoCard")
end

return HZCardPart
