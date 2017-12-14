--[[
*名称:RewardTipsLayer
*描述:奖励获得tips界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:Hunter.lei
*创建日期:2017.5.2
*修改日期:2017.5.2
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CURRENT_MODULE_NAME = ...
local RedpacketMgrPart = class("RedpacketMgrPart",cc.load('mvc').PartBase) --登录模块
RedpacketMgrPart.DEFAULT_PART = {}
RedpacketMgrPart.DEFAULT_VIEW = "RedpacketMgrLayer"
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".RedPacketMessage_pb")
--[
-- @brief 构造函数
--]
RedpacketMgrPart.CMD = {
    SPLIT_RED_PACKET_REQ_CMD = 0x01020002,--拆红包请求
    SPLIT_RED_PACKET_RSP_CMD = 0X01020003,    --拆红包返回响应
    RECEI_RED_PACKET_REQ_CMD = 0X01020004,    --领红包请求
    RECEI_RED_PACKET_RSP_CMD = 0X01020005,    --领红包响应
    QUERY_RED_PACKET_REQ_MSG = 0X01020006, --查询红包
    QUERY_RED_PACKET_RSP_MSG = 0X01020007
    --拆包协议
}
function RedpacketMgrPart:ctor(owner)
    RedpacketMgrPart.super.ctor(self, owner)
    self:initialize()
    self.redpackData = {}
    self:registerHandleMessage()
end

--[
-- @override
--]
function RedpacketMgrPart:initialize()

end

--激活模块
function RedpacketMgrPart:activate(gameId)
    self.game_id = gameId
	--激活模块
    RedpacketMgrPart.super.activate(self, CURRENT_MODULE_NAME)
end

--刷新数据和界面
function RedpacketMgrPart:setDataInfo(data)
    --[[local vip_data = {}
    for k,v in ipairs(data.players) do
        vip_data[k] = {}
        if v.vipoverdata then
            local hithorsecount = v.vipoverdata.hithorsecount
            vip_data[k].dianpaoCount = v.vipoverdata.dianpaocount
            vip_data[k].ming_gang = bit._and(bit.rshift(hithorsecount,8),0xff)
            vip_data[k].an_gang = bit._and(bit.rshift(hithorsecount,16),0xff)
            vip_data[k].hit_horse = bit._and(bit.rshift(hithorsecount,0),0xff)
        end
    end]]
    self.view:updateActivityTime(data.startTime,data.endTime,data.dailyStartTime,data.dailyEndTime)
    self.redpackData = {}
    self.redpacketOrder = {}
    local places = {}
    places[1] = 0
    places[3] = 1
    places[0] = 2
    places[2] = 3
    table.sort(data.redPackets,function(info1, info2) return places[info1.packetStatus]<places[info2.packetStatus] end)
    for k,v in ipairs(data.redPackets) do
        table.insert(self.redpacketOrder,v.packetId)
        if self.redpackData[v.packetId] == nil then
            self.redpackData[v.packetId] = v          
        end
    end
    self.view:redpacketDataInfo(self.redpackData,self.redpacketOrder)
end

--查询红包
function RedpacketMgrPart:onQueryRedPacketReqMsg()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = RedPacketMessage_pb.QueryRedPacketReqMsg()
    local user = global:getGameUser()
    local props = user:getProps()
    local game_info = props["gameplayer" .. self.game_id]

    opt_msg.userId = tonumber(game_info.playerIndex)
    --opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
    opt_msg.playerName = props.name
    opt_msg.gameId = tostring(self.game_id)

    net_mode:sendProtoMsg(opt_msg,RedpacketMgrPart.CMD.QUERY_RED_PACKET_REQ_MSG,self.game_id)
end

--查询红包返回
function RedpacketMgrPart:QueryRedPacketRspMsg(data)
    if self.view ~= nil then
        local queryRedPacket_resp = RedPacketMessage_pb.QueryRedPacketRspMsg()
        queryRedPacket_resp:ParseFromString(data)
        if queryRedPacket_resp.resultCode == 200 then  --success
            --查询红包信息成功
            self:setDataInfo(queryRedPacket_resp)
        end
        --self:setDataInfo(data)
    end
end

--拆红包
function RedpacketMgrPart:onSplitRedPacket(packetId)
    -- body
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = RedPacketMessage_pb.OpenRedPacketReqMsg()
    local data = self.redpackData[packetId]
    if data then
        local user = global:getGameUser()
        local props = user:getProps()
        opt_msg.packetId = data.packetId
        opt_msg.gameId = self.game_id
        opt_msg.shareCode = data.shareCode
        opt_msg.activityId = data.activityId
        opt_msg.playerName = props.name
        opt_msg.wxOpenId = props.wxopenid or ""--tostring(1)
        opt_msg.userId = props.uid
        net_mode:sendProtoMsg(opt_msg,RedpacketMgrPart.CMD.SPLIT_RED_PACKET_REQ_CMD,self.game_id)
    end
    
end

--领红包请求
function RedpacketMgrPart:onReceiveRedPacket(packetId)
    -- body
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = RedPacketMessage_pb.GetRedPacketReqMsg()
    local data = self.redpackData[packetId]
    if data then
        local user = global:getGameUser()
        local props = user:getProps()
        local game_info = props["gameplayer" .. self.game_id]

        opt_msg.packetId = data.packetId
        opt_msg.redRedPacketNum = data.redRedPacketNum
        opt_msg.userId = tonumber(game_info.playerIndex)
        opt_msg.gameId = self.game_id
        opt_msg.prizeType = data.prizeType
        net_mode:sendProtoMsg(opt_msg,RedpacketMgrPart.CMD.RECEI_RED_PACKET_REQ_CMD,self.game_id)
    end
end

--注册返回消息
function RedpacketMgrPart:registerHandleMessage()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(RedpacketMgrPart.CMD.SPLIT_RED_PACKET_RSP_CMD,handler(self,RedpacketMgrPart.SplitRedPacketRsp),"RedpacketMgrPart")
    net_mode:registerMsgListener(RedpacketMgrPart.CMD.RECEI_RED_PACKET_RSP_CMD,handler(self,RedpacketMgrPart.ReceiveRedPacketRsp),"RedpacketMgrPart")
    net_mode:registerMsgListener(RedpacketMgrPart.CMD.QUERY_RED_PACKET_RSP_MSG,handler(self,RedpacketMgrPart.QueryRedPacketRspMsg),"RedpacketMgrPart")
end

--拆红包消息返回
function RedpacketMgrPart:SplitRedPacketRsp(data)
    local openRedPacket_resp = RedPacketMessage_pb.OpenRedPacketRspMsg()
    openRedPacket_resp:ParseFromString(data)
    if openRedPacket_resp.resultCode == 200 then  --success
        --拆红包成功
        self:onClose()
        --[[local item = self.view:getItemByID(openRedPacket_resp.packetId)
        if item then
            local status = 1 --待领取
            if not openRedPacket_resp.isNeedShare then
                status = 3
            end
            local des = "金币"
            if openRedPacket_resp.prizeType == 1 then
                des = "钻石"
            elseif openRedPacket_resp.prizeType == 2 then
                des = "元"
            end
            des = openRedPacket_resp.prize .. des
            self.view:updateItem(item,status,des)
        end]]
    end
end

--领红包红包消息返回
function RedpacketMgrPart:ReceiveRedPacketRsp(data)
    -- body 解析package
    local getRedPacket_resp = RedPacketMessage_pb.GetRedPacketRspMsg ()
    getRedPacket_resp:ParseFromString(data)
    if getRedPacket_resp.resultCode == 200 then  --success
        --领取红包成功
        local item = self.view:getItemByID(getRedPacket_resp.packetId)
        if item then
            self.view:updateItem(item,getRedPacket_resp.packetStatus)
            self.redpackData[getRedPacket_resp.packetId].packetStatus = getRedPacket_resp.packetStatus
        end 
    end
    local h = self:isRed()
    if not h then
        --没有可以操作的红包了
        cc.Director:getInstance():getEventDispatcher():dispatchCustomEvent("hideredpoint");
    end
end

function RedpacketMgrPart:isRed()
    local has = false
    for _,k in pairs(self.redpackData) do
        if k.packetStatus ~= 2 then
            has = true
            break
        end
    end
    return has
end

--分享到朋友圈
function RedpacketMgrPart:shareToWX(packetId)
    local data = self.redpackData[packetId]
    if data then
        local shareUrl = data.shareLink
        local shareContent = ""
        local shareTitle = "天降红包雨，现金送不停！快来抢我分享的红包吧！"
        self.view:shareToWXCircleFriend(shareTitle,shareContent,shareUrl)
        --global:setShareState(true)
    end
end
--关闭界面
function RedpacketMgrPart:onClose()
    -- body
    --local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    --local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
    --opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
    --net_mode:sendProtoMsg(opt_msg,VipOverPart.CMD.MSG_GAME_OPERATION,self.game_id)
    self:deactivate()
end

function RedpacketMgrPart:deactivate()
    if self.view then
        self.view:removeSelf()
        self.view =  nil
    end
end

function RedpacketMgrPart:getPartId()
	-- body
	return "RedpacketMgrPart"
end

return RedpacketMgrPart