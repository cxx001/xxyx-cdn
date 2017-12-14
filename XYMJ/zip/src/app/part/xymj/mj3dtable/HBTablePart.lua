local CURRENT_MODULE_NAME = ...
local HBTablePart = class("HBTablePart", import(".TablePart"))
HBTablePart.DEFAULT_VIEW = "HBTableScene" 

function HBTablePart:activate(gameId,data)
	self.game_id = gameId
	HBTablePart.super.activate(self,gameId,data)
	local tableInfo = data.tableinfo 
	self.view:updateTableShow(tableInfo)
end
 
  
function HBTablePart:gameEnd(data)
	-- body
	local game_end = self:getPart("GameEndPart")
	local card_part =self:getPart("CardPart")
	self.view:hideMenu()
	if game_end then
		local last_round = false
		
		if self.cur_hand > 0 and self.tableid > 1 and self.cur_hand >= self.total_hand then --vip场才有显示战绩
			last_round = true
		end
		
		game_end:activate(self.game_id,data , self.m_seat_id,last_round,self.cur_hand,self.total_hand)
		-- game_end:activate(self.game_id, data, self.m_seat_id,last_round, card_part:getPizi(), card_part:getLaizi())
		if self.tableid > 1 then
			game_end:hideBackBtn() -- vip场小结算隐藏返回按钮
		end
	end

	if card_part then
		card_part:deactivate()
	end

	if self.smalluserinfo_part then
		self.smalluserinfo_part:deactivate()
	end
end

function HBTablePart:getPlayWay1()
	return self.view:getPlayWay1()
end
 
return HBTablePart
