--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local BattleDetailPart = class("BattleDetailPart",cc.load('mvc').PartBase) --登录模块
BattleDetailPart.DEFAULT_VIEW = "BattleDetailLayer"

BattleDetailPart.CMD = {
	MSG_GET_VIP_RECORD_DETAIL		= 0xc30065,					--查询玩家战绩详情
	MSG_GET_VIP_RECORD_DETAIL_ACK	= 0xc30066,					--vip战绩详情列表
}

--[
-- @brief 构造函数
--]
function BattleDetailPart:ctor(owner)
    BattleDetailPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function BattleDetailPart:initialize()
	
end

--激活模块
function BattleDetailPart:activate(data)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(self.CMD.MSG_GET_VIP_RECORD_DETAIL_ACK,handler(self,BattleDetailPart.getGameRecordListAck))
	BattleDetailPart.super.activate(self,CURRENT_MODULE_NAME)

	self.room_data = data
	self:getGameRecordList(data)
end

function BattleDetailPart:getGameRecordList(data)
	local net_manager = global:getNetManager()
	local proto_msg = tablePlayback_pb.GetVipGameRecordMsg()

	local user = global:getGameUser()
    local props = user:getProps()
    local playerID = props["gameplayer" .. SocketConfig.GAME_ID].playerIndex

    -- @ player_id
	proto_msg.roomID = tostring(data.roomIndex)

	-- @ end_time
	proto_msg.time = data.endTime

	net_manager:sendProtoMsg(proto_msg,self.CMD.MSG_GET_VIP_RECORD_DETAIL, game_id or SocketConfig.GAME_ID)
	if not game_id then
		self.owner:startLoading()
	end
end

function BattleDetailPart:getGameRecordListAck(data, appId)
	self.owner:endLoading()
	local net_manager = global:getNetManager()
	local proto_msg = tablePlayback_pb.GetVipGameRecordMsgAck()
	proto_msg:ParseFromString(data)

	print(proto_msg)
	-- @parse proto
	self:parseBattle(proto_msg)
	-- @ update
	self.view:updateUI(self.room_list, self.room_data)
end

function BattleDetailPart:parseBattle(proto_msg)
	local battles = proto_msg.record
	self.room_list = {}
	for i, battle in ipairs(battles) do
		local handIndex = battle.handIndex
		local node = {
			roomid 		= battle.roomid,
			playerID 	= battle.playerID,
			playerName 	= battle.playerName,
			gameScore 	= battle.gameScore,
			handIndex 	= battle.handIndex,
			recordTime  = battle.recordTime,
		}
		if not self.room_list[handIndex] then
			self.room_list[handIndex] = {}
		end
		table.insert(self.room_list[handIndex], node)
	end
end

function BattleDetailPart:deactivate()
	local net_mode = global:getNetManager()
	net_mode:unRegisterMsgListener(self.CMD.MSG_GET_VIP_RECORD_DETAIL_ACK)

	self.view:removeSelf()
 	self.view =  nil

 	--self.owner:recordClick()
end

function BattleDetailPart:getPartId()
	-- body
	return "BattleDetailPart"
end

--[[
@ 分享
]]
function BattleDetailPart:shareCode(roomid, bid)
	local call_back = function(share_code)
	    local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	    local shareUrl = string_table.share_weixin_android_url
	    local user = global:getGameUser()
	    local props = user:getProps()
	    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

	    for i,v in ipairs(gameConfigList) do
	        local gameParam = gameConfigList[i]
	        if device.platform == "android" then
	            if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
	                if gameParam.valueStr then
	                    shareUrl = gameParam.valueStr --分享链接
	                end
	            end
	        elseif device.platform == "ios" then
	            if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
	                if gameParam.valueStr then
	                    shareUrl = gameParam.valueStr --分享链接
	                end
	            end
	        end
	    end
		
		local game_id = SocketConfig.GAME_ID
		local game_name = string_table.game_name[tonumber(game_id)]
		local share_title = string.format(string_table.battle_title, game_name)
		local share_content = string.format(string_table.battle_content, tostring(share_code))
		local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
		lua_bridge:ShareToWX(1, share_content, shareUrl, share_title)		
	end

	local getBattleData = require('app.part.record.GetBattleData').new()
	getBattleData:reqShareCore(roomid, bid, function(code, data)
		local cjson = require("cjson")
		local server_data = cjson.decode(data)
		if code == 200 and server_data.code == 0 then
			call_back(server_data.data)
		else
			-- @ error
			local tips_part = global:createPart("TipsPart",self)
			if tips_part then
				tips_part:activate({info_txt=server_data.msg})
			end
		end
	end)
end

--[[
@ 开始回放
]]
function BattleDetailPart:startRecord(tid, bid, total_ju)
	-- @ loading
	self.owner:startLoading()

	local getBattleData = require('app.part.record.GetBattleData').new()
	getBattleData:reqShareCore(tid, bid, function(code, data)
		self.owner:endLoading()
		local cjson = require("cjson")
		local server_data = cjson.decode(data)
		if code == 200 and server_data.code == 0 then
			local share_code = server_data.data

			-- @loading
			self.owner:startLoading()
			getBattleData:loadRecordData(share_code, function(code, data)
				self.owner:endLoading()
				if code == 200 then
					self:deactivate()

					local ext_data = {
						tid 		= tid,
						bid 		= bid,
						total_ju 	= total_ju,
					}
					self.owner:startRecrod(code, data, ext_data)
				else
					local str = ''
					if code == 400 then
						str = string_table.not_battle_data
					else
						str = string.format(string_table.load_battle_error, code)
					end
					-- @ error
					local tips_part = global:createPart("TipsPart",self)
					if tips_part then
						tips_part:activate({info_txt=str})
					end
				end
			end)
		else
			-- @ error
			local tips_part = global:createPart("TipsPart",self)
			if tips_part then
				tips_part:activate({info_txt=server_data.msg})
			end
		end
	end)
end


return BattleDetailPart 