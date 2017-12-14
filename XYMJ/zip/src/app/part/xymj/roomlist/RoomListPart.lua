local CURRENT_MODULE_NAME = ...
local RoomListPart = class("RoomListPart",cc.load('mvc').PartBase) --代开房列表组件
RoomListPart.DEFAULT_PART = {"SharePart"}
RoomListPart.DEFAULT_VIEW = "RoomListNode"
RoomListPart.CMD = {
    MSG_REQUEST_MYTABLE_LIST_MSG_ACK = SocketConfig.MSG_REQUEST_MYTABLE_LIST_MSG_ACK, --请求房间列表
    MSG_REQUEST_MYTABLE_LIST_MSG = SocketConfig.MSG_REQUEST_MYTABLE_LIST_MSG,


    MSG_REQUEST_HISTORYTABLE_LIST_MSG = SocketConfig.MSG_REQUEST_HISTORYTABLE_LIST_MSG, --群主查询历史代开房记录
    MSG_REQUEST_HISTORYTABLE_LIST_MSG_ACK = SocketConfig.MSG_REQUEST_HISTORYTABLE_LIST_MSG_ACK,

    MSG_ENTER_VIP_ROOM = SocketConfig.MSG_ENTER_VIP_ROOM,
    MSG_REQUEST_START_GAME_ACK = SocketConfig.MSG_REQUEST_START_GAME_ACK,
}
 
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".MyTableListMsg_pb")
--[
-- @brief 构造函数
--]
function RoomListPart:ctor(owner)
    RoomListPart.super.ctor(self, owner)
    self:initialize() 
end
 
--激活模块
function RoomListPart:activate(gameID, pos, node)
    self.game_id = gameID
	self.view = global:importViewWithName(CURRENT_MODULE_NAME,self.DEFAULT_VIEW,self)
	self.view:setPosition(pos) 
    self.parentView = node
   	node:addChild(self.view, 999) 
    local sharePart = self:getPart("SharePart")
    sharePart:activate(self.game_id)
    self:registNetMsg(true)  

    self.curRoomList = {}
    self.historyList = {} 
    self:requestCurrentList(true)  
end

function RoomListPart:registNetMsg(isReg)
    local partId = self:getPartId()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    if isReg then
        net_mode:registerMsgListener(RoomListPart.CMD.MSG_REQUEST_MYTABLE_LIST_MSG_ACK,handler(self,RoomListPart.onCurRoomListResp), partId) 
        net_mode:registerMsgListener(RoomListPart.CMD.MSG_REQUEST_HISTORYTABLE_LIST_MSG_ACK,handler(self,RoomListPart.onHisRoomListResp), partId) 
        net_mode:registerMsgListener(RoomListPart.CMD.MSG_REQUEST_START_GAME_ACK,handler(self,RoomListPart.onEnterRoomAck), partId)
    else
        net_mode:unRegisterMsgListener(RoomListPart.CMD.MSG_REQUEST_MYTABLE_LIST_MSG_ACK, partId)
        net_mode:unRegisterMsgListener(RoomListPart.CMD.MSG_REQUEST_HISTORYTABLE_LIST_MSG_ACK, partId)
        net_mode:unRegisterMsgListener(RoomListPart.CMD.MSG_REQUEST_START_GAME_ACK, partId)
    end
end

 

function RoomListPart:onCurRoomListResp(data)

    local mytableListAck = MyTableListMsg_pb.RequestMyTableListMsgAck()
    mytableListAck:ParseFromString(data) 

    print(string.format("###[RoomListPart:onRoomListResp]result %x", mytableListAck.result)) 
    if mytableListAck.result ~= SocketConfig.MsgResult.CMD_EXE_OK then
        print("###[RoomListPart:onRoomListResp]mytableListAck.result ~= RoomConfig.MsgResult.CMD_EXE_OK")
        return
    end  

    self:onCurrentListResp(mytableListAck) 
end

function RoomListPart:onHisRoomListResp(data)
    local historytableListAck = MyTableListMsg_pb.RequestQunzhuRoomRecordMsgAck()
    historytableListAck:ParseFromString(data) 

    print(string.format("###[RoomListPart:onRoomListResp]result %x", historytableListAck.result))    
    if historytableListAck.result ~= SocketConfig.MsgResult.CMD_EXE_OK then
        print("###[RoomListPart:onRoomListResp]historytableListAck.result ~= RoomConfig.MsgResult.CMD_EXE_OK")
        return
    end  
    self:onHistoryListResp(historytableListAck) 
end

function RoomListPart:onEnterRoomAck(data,appID) 
    self:endLoading()
    local enter_room_ack = StartGameMsgAck_pb.StartGameMsgAck()  
    enter_room_ack:ParseFromString(data)
    if enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_KAIFANG_NUM_LIMIT then 
        local tips_part = global:createPart("TipsPart",self.owner)
        if tips_part then
            tips_part:activate({info_txt=RoomConfig.MaxCreateRoomTips})
        end 
    end
end



function RoomListPart:requestHistoryList(isSendMsg)
    print("###[RoomListPart:requestHistoryList]isSendMsg ", isSendMsg)
    if not isSendMsg then
        self.view:updateHistoryList(self.historyList) 
        return
    end
 
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local requestHisTableListMsg = MyTableListMsg_pb.RequestQunzhuRoomRecordMsg()  
    net_mode:sendProtoMsg(requestHisTableListMsg, RoomListPart.CMD.MSG_REQUEST_HISTORYTABLE_LIST_MSG, SocketConfig.GAME_ID)

    -- --测试数据
    -- self:startLoading() 
    -- local scheduler = cc.Director:getInstance():getScheduler() 
    -- self.schedulerID = scheduler:scheduleScriptFunc(function() 

    --     self:onHistoryListResp(self:getTestData(30)) 
    --     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID) 

    -- end,0.5,false)  
end

function RoomListPart:onHistoryListResp(data)
    print("###[RoomListPart:onHistoryListResp]")
    self:endLoading()
    self.historyList = self:decodeHisRoomListData(data) 
    self.view:setHistoryTotalPage(#self.historyList)
    self.view:updateHistoryList(self.view:getHistoryListByPage(1))
end

--
function RoomListPart:requestCurrentList(isSendMsg)
    print("###[RoomListPart:requestCurrentList]isSendMsg ", isSendMsg) 
    --无需重复请求
    if not isSendMsg then
        print("###[RoomListPart:requestCurrentList] self.curRoomList is ")
        dump(self.curRoomList)
        self.view:updateCurrentList(self.curRoomList)
        return
    end 

    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local requestMyTableListMsg = MyTableListMsg_pb.RequestMyTableListMsg()  
    net_mode:sendProtoMsg(requestMyTableListMsg, RoomListPart.CMD.MSG_REQUEST_MYTABLE_LIST_MSG, self.game_id)


    -- --测试数据
    -- local scheduler = cc.Director:getInstance():getScheduler() 
    -- self.schedulerID = scheduler:scheduleScriptFunc(function() 
    --     self:onCurrentListResp(self:getTestData(6)) 
    --     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)  
    -- end,0.5,false)  
end

function RoomListPart:onCurrentListResp(data) 
    self.curRoomList = self:decodeCurRoomListData(data) 
    self.view:updateCurrentList(self.curRoomList)
    if next(self.curRoomList) ~= nil then
        self.view:refreshRoomList()
    end

    if nil ~= self.owner.updateRedPoint then
        self.owner:updateRedPoint(#self.curRoomList)
    end
   
end

function RoomListPart:requestEnterRoom(tableInfo)
    self:startLoading()
    local tableID = tableInfo.tableID
    print("###[RoomListNode:onEnterRoom] tableID ", tableID)
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local enter_vip_room = wllobby_message_pb.ReqStartGame()
    enter_vip_room.roomid = tonumber(tableID)
    enter_vip_room.gametype = 1
    enter_vip_room.tableid = "ask_enter_room"
    enter_vip_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案 
    net_mode:sendProtoMsg(enter_vip_room,RoomListPart.CMD.MSG_ENTER_VIP_ROOM,self.game_id) 
end

function RoomListPart:startLoading()
    -- body
    local loading_part = global:createPart("LoadingPart",self.owner)
    self:addPart(loading_part)
    loading_part:activate(self.game_id) 
end

function RoomListPart:endLoading(eventCode)
    -- body
    local loading_part = self:getPart("LoadingPart")
    if loading_part then
        loading_part:deactivate()
    end

end

function RoomListPart:updateRoomLeftTime(tableID, time)
    for i = #self.curRoomList, 1, -1 do
        local info = self.curRoomList[i]
        if info.tableID == tableID then
            if time <= 0 then
                table.remove(self.curRoomList, i)
            else
                self.curRoomList[i].leftSecond = time
            end 
        end
    end
end

--因为客户端先行，所以转换proto协议字段
function RoomListPart:decodeCurRoomListData(data)  
    local infoList = {} 
    for i = 1, #data.myTableList do
        local info = data.myTableList[i]
        local newInfo = {} 
        newInfo.tableID = info.vipTableID  
        newInfo.playerNum = info.currentPlayerNum 
        newInfo.timeNum = info.totalHandNum 
        newInfo.curTimeNum = info.curHandNum        
        newInfo.leftSecond = tonumber(info.leftSeconds) 

        newInfo.playwaytype = info.vipRule
        newInfo.diZhu   = info.diZhu 
        table.insert(infoList, newInfo) 
    end 
    print("###[RoomListPart:decodeCurRoomListData]infoList is ")
    dump(infoList)
    return infoList    
end

--因为客户端先行，所以转换proto协议字段
function RoomListPart:decodeHisRoomListData(data)  
    local infoList = {} 
    for i = 1, #data.myTableList do
        local info = data.myTableList[i]
        local newInfo = {} 
        newInfo.recordID = info.recordID
        newInfo.tableID = info.vipTableID  
        newInfo.playerNum = info.currentPlayerNum 
        newInfo.timeNum = info.totalHandNum 
        newInfo.curTimeNum = info.curHandNum        
        newInfo.leftSecond = tonumber(info.leftSeconds) 

        newInfo.playwaytype = info.vipRule
        newInfo.diZhu   = info.diZhu
        newInfo.payType = info.isShareDiamond 
        newInfo.winnerID = info.dayingjiaID
        newInfo.winnerName = info.dayingjiaName  
        newInfo.endTime = os.date("%Y/%m/%d/ %H:%M", info.endTime) 

        table.insert(infoList, newInfo) 
    end 
    print("###[RoomListPart:decodeHisRoomListData]infoList is ")
    dump(infoList)
    return infoList    
end

function RoomListPart:getHistoryList()
    return self.historyList
end

function RoomListPart:getPartId()
    -- body
    return "RoomListPart"
end

function RoomListPart:deactivate()
    self:registNetMsg(false)  
    if self.view ~= nil then
        self.view:removeSelf()
        self.view =  nil
    end
    print("this is deactivate------:",self.view) 
end

function RoomListPart:getTestData(num)
    local data = {}
    data.myTableList = {}
    for i = 1, num do
        local info = {}
        info.recordID = i
        info.vipTableID = "1000"..i
        info.currentPlayerNum = 4 
        info.totalHandNum = 16
        info.curHandNum = 1       
        info.leftSeconds = 5 + (i-1)* 3 

        info.vipRule = 0x1001
        info.diZhu = 1
        info.isShareDiamond = 1   
        info.dayingjiaID = "2000"..i
        info.dayingjiaName = "30000"..i  
        info.endTime = os.time()
        table.insert(data.myTableList, info)
    end
    return data
end

 



return RoomListPart