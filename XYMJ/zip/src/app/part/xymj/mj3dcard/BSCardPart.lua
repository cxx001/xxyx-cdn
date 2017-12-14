local CURRENT_MODULE_NAME = ...
local CardPart = import(".CardPart")
local BSCardPart = class("BSCardPart",CardPart)
BSCardPart.DEFAULT_VIEW = "BSCardLayer"

--杠牌事件处理
function BSCardPart:gangClick()
	-- body
	-- self.gang_data = {
	-- 	0x31323231,0x33333331,0x34343431,0x32323231,0x33333333
	-- }
	if self.gang_list then
		local size = #self.gang_list
		if size == 1 then --只有一个直接杠
			self.server_data =  self.gang_list[1].cardValue
			self:requestOpt(MahjongOperation.MING_GANG)
			self.view:hideOpt()
		elseif size > 1 and size <= 4 then --可以杠的列表小于等于4直接列出杠的情况 
			self.view:showGangList(self.gang_list) --列出刚的相信列表
		else
			local gang_list = {}
			local gang_list1 = {}
			for i,v in ipairs(self.gang_list) do
				local c1 = bit._and(v.cardValue,0xff)
				gang_list[c1] = v --以值为索引防止重复
			end

			for k,v in pairs(gang_list) do
				table.insert(gang_list1,v)
			end

			self.view:showGangSelect(gang_list1) --列出杠的选择列表
		end
	end
end

function BSCardPart:optClick(type)
	-- body
	print("BSCardPart:optClick_type->",type);
	if type == RoomConfig.Chi then
		self:doChiClick()
	elseif type == RoomConfig.Gang then
		self:gangClick()
	else
		self:requestOpt(type)
	end
	
end

function BSCardPart:showAnGang() --暗杠是否要显示一张牌给别人看 保山暗杠需要显示一张牌给别人看
	-- body
	return true
end


function BSCardPart:ntfGangList(gangList)
	-- body
	self.gang_list = gangList
	self.view:setGangPicState(true)
end

--返回当前选择的牌的值
function BSCardPart:selectGang(value)
	-- body
	local gang_list = {}
	for i,v in ipairs(self.gang_data) do
		local c1 = bit._and(v,0xff)
		print("this is select gang:",c1,value)
		if c1 == value then
			table.insert(gang_list,v)
		end
	end
	
	if #gang_list == 1 then
		self:requestOpt(MahjongOperation.MING_GANG)
	else
		self.view:showGangList(gang_list)
	end
	
end

function BSCardPart:refreshBaoCardOnPart(baoCard)
  	-- body
	print("BS NO refreshBaoCard")
end

return BSCardPart
