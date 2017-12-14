local CURRENT_MODULE_NAME = ...
local CardPart = import(".CardPart")
local ZTCardPart = class("ZTCardPart",CardPart)
ZTCardPart.DEFAULT_VIEW = "ZTCardLayer"

--杠牌事件处理
function ZTCardPart:gangClick()
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

function ZTCardPart:optClick(type)
	-- body
	print("ZTCardPart:optClick_type->",type);
	if type == RoomConfig.Chi then
		self:doChiClick()
	elseif type == RoomConfig.Gang then
		self:gangClick()
	else
		self:requestOpt(type)
	end
	
end

function ZTCardPart:ntfGangList(gangList)
	-- body
	self.gang_list = gangList
	self.view:setGangPicState(true)
end

--返回当前选择的牌的值
function ZTCardPart:selectGang(value)
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

function ZTCardPart:refreshBaoCardOnPart(baoCard)
  	-- body
	print("BS NO refreshBaoCard")
end

function ZTCardPart:baipaiClickHandle()
	-- body
	print("ZTCardPart:baipaiClickHandle----进入摆牌点击事件处理")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ycmj_message_pb.PlayerTableOperationMsg()
    opt_msg.operation = RoomConfig.PLAYER_OPERATION_BAIPAI			--玩家摆牌操作
	print("ZTCardPart:baipaiClickHandle----发送摆牌操作请求")
    net_mode:sendProtoMsgWithSeq(opt_msg,MsgDef.MSG_PLAYER_OPERATION,SocketConfig.GAME_ID)
end

--摆牌显示牌
function ZTCardPart:baipaiShowCards(viewId, huList)
	-- body
	print("ZTCardPart:baipaiShowCards--昭通摆牌，牌数据=", huList)
	SZXX_Util.gTablePrint(huList)
	
	--显示摆牌表现
	self.view:baipaiShowCardsView(viewId, huList)
end

--摆牌成功后，自动摆牌表现
function ZTCardPart:baipaiAutoOutCard()
	self.auto_opt = true
	self.view:baipaiAutoOutCardView()
end

--昭通胡牌后禁用摆牌按钮
function ZTCardPart:showHuCardSp(viewId,value)
	self.view:showHuCardSp(viewId,value)
end

return ZTCardPart
