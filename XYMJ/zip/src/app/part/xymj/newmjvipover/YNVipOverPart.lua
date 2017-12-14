-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local VipOverPart = import(".VipOverPart")
local YNVipOverPart = class("YNVipOverPart",VipOverPart) 


-- function YNVipOverPart:vipOverDataInfo(data,tableid,creatorId)
--     self.tableid =tableid
--     local totoalData = {}   --总分排行信息
--     local roomInfo = {}     --房间号信息

--     local function tempTotal()
--         for i=1,4 do
--             local totoalItemData = {}
--             totoalItemData.headImgUrl="head"
--             totoalItemData.name="你好你哈尼好你好啊你啊回复的"
--             totoalItemData.ID ="jdjfhdfdouisabgewrivoggjpjodpjfposj"
--             totoalItemData.totoalScore=9

--             totoalItemData.zimoCount=2
--             totoalItemData.jiepaoCount=3
--             totoalItemData.dianpaoCount=0
--             totoalItemData.angangCount=2
--             totoalItemData.minggangCount= 2
--             if i==1 then
--                 totoalItemData.isOwnerRoom=true
--                 roomInfo.createRoomName=totoalItemData.name
--             else
--                 totoalItemData.isOwnerRoom=false    
--             end
--             table.insert(totoalData,totoalItemData)          
--         end

--         roomInfo.rooid=1000086 --房间号：
--         roomInfo.num =2   --当前第几局
--         roomInfo.totalSet=6--创建的是多少局的
--         roomInfo.time =os.date("%Y%c%m%c%d %H:%M")      --当前时间
--     end 

--       tempTotal()

--     --排序
--     if #totoalData >0 then
--         table.sort(totoalData,function (a,b )
--         return a.totoalScore > b.totoalScore
--         end)
--     end


--     dump(roomInfo) 

--     dump(totoalData)


--     self.view:updateTotalSort(totoalData,roomInfo)

--     self:vipGameHandRecord(data,tableid,creatorId)
--     print("YNVipOverPart:vipOverDataInfo(data,tableid,creatorId")
--     self.view:setLocalZOrder(1000)
    
--     -- self.view:vipOverDataInfo(data,vip_data,tableid,creatorId)
-- end


function YNVipOverPart:vipOverDataInfo(data,tableid,creatorId,creatorName)
    self.tableid =tableid
    local totoalData = {}   --总分排行信息
    local roomInfo = {}     --房间号信息

    -- print("data.players:",data.players)
    print("creatorId:..."..creatorId)
    for i,v in ipairs(data.players) do
        local totoalItemData = {}
        totoalItemData.headImgUrl=v.headImgUrl
        totoalItemData.name=v.name
        -- totoalItemData.ID =v.uid
        totoalItemData.ID =v.playerIndex
        
        totoalItemData.totoalScore=v.coin

        local vipoverdata =v.vipoverdata
        local hithorsecount = vipoverdata.hithorsecount

        totoalItemData.zimoCount=vipoverdata.zimocount
        totoalItemData.jiepaoCount=vipoverdata.jiepaocount
        totoalItemData.dianpaoCount=vipoverdata.dianpaocount
        totoalItemData.angangCount=bit._and(bit.rshift(hithorsecount,16),0xff)
        totoalItemData.minggangCount= bit._and(bit.rshift(hithorsecount,8),0xff)
        if  v.uid == creatorId then
            totoalItemData.isOwnerRoom=true
            roomInfo.createRoomName=totoalItemData.name
        else
            totoalItemData.isOwnerRoom=false    
        end
        table.insert(totoalData,totoalItemData)          
    end

    if creatorName then
        roomInfo.createRoomName=creatorName
    end

    roomInfo.rooid=tableid --房间号：
    roomInfo.num =self.owner.cur_hand   --当前第几局
    roomInfo.totalSet=self.owner.total_hand --创建的是多少局的
    roomInfo.time =os.date("%Y/%m/%d %X")      --当前时间

    -- local function tempTotal()
    --     for i=1,4 do
    --         local totoalItemData = {}
    --         totoalItemData.headImgUrl="head"
    --         totoalItemData.name="你好你哈尼好你好啊你啊回复的"
    --         totoalItemData.ID ="jdjfhdfdouisabgewrivoggjpjodpjfposj"
    --         totoalItemData.totoalScore=9

    --         totoalItemData.zimoCount=2
    --         totoalItemData.jiepaoCount=3
    --         totoalItemData.dianpaoCount=0
    --         totoalItemData.angangCount=2
    --         totoalItemData.minggangCount= 2
    --         if i==1 then
    --             totoalItemData.isOwnerRoom=true
    --             roomInfo.createRoomName=totoalItemData.name
    --         else
    --             totoalItemData.isOwnerRoom=false    
    --         end
    --         table.insert(totoalData,totoalItemData)          
    --     end

    --     roomInfo.rooid=1000086 --房间号：
    --     roomInfo.num =2   --当前第几局
    --     roomInfo.totalSet=6--创建的是多少局的
    --     roomInfo.time =os.date("%Y%m%d %H:%M")      --当前时间
    -- end 

    --   tempTotal()

    --排序
    if #totoalData >0 then
        table.sort(totoalData,function (a,b )
        return a.totoalScore > b.totoalScore
        end)
    end


    -- dump(roomInfo) 

    dump(totoalData)


    self.view:updateTotalSort(totoalData,roomInfo)

    -- self:vipGameHandRecord(data,tableid,creatorId)
    print("YNVipOverPart:vipOverDataInfo(data,tableid,creatorId")
    self.view:setLocalZOrder(1000)
    
    -- self.view:vipOverDataInfo(data,vip_data,tableid,creatorId)
end


--各局流水
function YNVipOverPart:vipGameHandRecord(data,tableid,creatorId)
    local handData = {}             --各局流水信息
    local roomInfo = {}             --房间号信息
    local recordDataList= {}        --信息记录列表

    local function getWinner(tablepos)
        if tablepos==data.winPos then
            return true
        end
        return false
    end 
    local function getCreateRoom(playerIndex)
        if tonumber(playerIndex) == tonumber(creatorId) then
            return true
        end   
        return false
    end 

    local playerTitleInfoList= {}   --玩家标题信息；列表
    --[[
    for i,v in ipairs(data.players) do
        local player = v
        local playerTitleInfo={}
        playerTitleInfo.isOwnerRoom =getCreateRoom(player.playerIndex)
        playerTitleInfo.name=player.name
        playerTitleInfo.ID=player.uid
        playerTitleInfo.isWiner = getWinner(player.tablepos)
        playerTitleInfo.tablepos = player.tablepos
        playerTitleInfoList[playerTitleInfo.tablepos+1]=playerTitleInfo
    end--]]

    local function createTempTitleInfoList()
        for i=1,4 do
            local player = v
            local playerTitleInfo={}
            playerTitleInfo.isOwnerRoom =false
            playerTitleInfo.name="你好你哈尼好"
            playerTitleInfo.ID="niofsaoifhdshfsd"
            playerTitleInfo.isWiner = false
            if i==1 then
                playerTitleInfo.isWiner = true
                playerTitleInfo.isOwnerRoom = true 
            end
            playerTitleInfo.tablepos =i
            playerTitleInfoList[i]=playerTitleInfo
        end
    end 

    local function createTempRecord()
        for i=1,8 do
            local recordData = {}                           --每条信息的记录
            local  playerOneScore =98
            local  playerTwoScore =98
            local  playerThreeScore =50
            local  playerFourScore =20

            recordData.playerOneScore=playerOneScore
            recordData.playerTwoScore=playerTwoScore
            recordData.playerThreeScore=playerThreeScore
            recordData.playerFourScore=playerFourScore
            recordDataList[i] =recordData
        end
    end


    --第几局第几个座位的得分数
    local function getOneSocreByTablesPosInHandIndex(hIndex,datas,tablePos)
        local score = 0
        for i,v in ipairs(datas.records) do
            if tonumber(hIndex) == tonumber(v.handIndex) then
                for j,vl in ipairs(v.details) do
                    local dValue = vl
                    if tonumber(dValue.tablePos) == tonumber(tablePos) then
                        score= dValue.gameScore
                        break
                    end
                end
            end
        end

        print("hIndex:---"..hIndex.."---------tablePos:"..tablePos.."--------score:"..score)
        return score
    end

    --第一局：座位第一个，

    --记录分数
    --[[
    for i,v in ipairs(data.records) do
        local recordData = {}                           --每条信息的记录
        --服务器座位从0开始
        local  playerOneScore =getOneSocreByTablesPosInHandIndex(v.handIndex,data,0)
        local  playerTwoScore =getOneSocreByTablesPosInHandIndex(v.handIndex,data,1)
        local  playerThreeScore =getOneSocreByTablesPosInHandIndex(v.handIndex,data,2)
        local  playerFourScore =getOneSocreByTablesPosInHandIndex(v.handIndex,data,3)

        recordData.playerOneScore=playerOneScore
        recordData.playerTwoScore=playerTwoScore
        recordData.playerThreeScore=playerThreeScore
        recordData.playerFourScore=playerFourScore
        recordDataList[v.handIndex] =recordData
    end
    roomInfo.rooid=tableid --房间号：
    roomInfo.time =os.date("%Y%m%d %H:%M")--当前时间--]]

    roomInfo.date =os.date("%Y/%m/%d")
    roomInfo.time =os.date("%H:%M:%S")
    --假数据
     createTempTitleInfoList()
     createTempRecord()

    handData.playerTitleInfoList=playerTitleInfoList 
    print("playerTitleInfoList---------------------------")
    dump(playerTitleInfoList)

    handData.recordDataList=recordDataList
    print("recordDataList---------------------------")
    dump(handData.recordDataList)

    self.view:updateHandlerRecord(handData,roomInfo)
end

function YNVipOverPart:getRoomNumAddHandIndex(handIndex)
    return self.tableid ..handIndex
end



--[[
TablePart:closeVipRoomAck:  players {
    tablepos: 2
    desc:
    playerIndex: 100247
    fan: 0
    gameresult: 0
    canfrind: 0
    intable: 0
    gamestate: 0
    vipoverdata {
        wincount: 0
        dianpaocount: 0
        hithorsecount: 0
        gangcount: 0
        zimocount: 0
        jiepaocount: 0
        zhuangcount: 0
    }
    uid: 41e5fcada37079a19241e232121586f5
    name: 1492745521
    headImg: 0
    headImgUrl: headImg
    ip:
    sex: 0
    coin: 0
}
--]]



return YNVipOverPart