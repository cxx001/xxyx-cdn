--[[
*名称:VipOverLayer
*描述:大结算界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local VipOverLayer = class("VipOverLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

--分享回放：
--房间号+第几局
local CURRENT_MODULE_NAME = ...
function VipOverLayer:onCreate()
    -- body
    cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/newmjvipover/res/vipend_picture.plist")

    self:addMask()
    self:initWithFilePath("VipOverLayer",CURRENT_MODULE_NAME)
    self.node.player_list:setItemModel(self.node.playerPanelbg2)
    self.node.player_list1:setItemModel(self.node.player_panel1)
    self.node.player_list:addScrollViewEventListener(handler(self, VipOverLayer.listViewEvent))
    self.node.Slider_Percent:addEventListener(handler(self, VipOverLayer.sliderEvent))
    self.node.player_list:setScrollBarEnabled(false)
    self.node.player_list1:setScrollBarEnabled(false)
    self._canSelected= true
    self._canSlide=true

    -- self.node.banner_1:show()
    -- self.node.Sprite_840:hide()
end


function VipOverLayer:addMask()
    -- body
    local mask_layer = cc.LayerColor:create()
    mask_layer:initWithColor(cc.c4b(0,0,0,220))
    self:addChild(mask_layer)
    local  listenner = cc.EventListenerTouchOneByOne:create()
    listenner:setSwallowTouches(true)
    listenner:registerScriptHandler(function(touch, event)
        return true
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self)
end


function VipOverLayer:sliderEvent()
    local percent = self.node.Slider_Percent:getPercent()
    self.node.player_list:jumpToPercentVertical(percent)
end

function VipOverLayer:listViewEvent(sender, event)
    if event == ccui.ScrollviewEventType.scrolling or
    event == ccui.ScrollviewEventType.containerMoved then
        local listView = self.node.player_list
        local pInner = listView:getInnerContainer()
        local listheight = listView:getLayoutSize().height - pInner:getContentSize().height
        local percent = (pInner:getPositionY()/listheight) * 100.0
        self.node.Slider_Percent:setPercent(100-percent)
    end
end

--设置显示总分排行
function VipOverLayer:setTotalStyle(data,roomInfo)
    --self:showTotoalScore()
    --dump(self._totalSortData)
    for i,v in ipairs(data) do
        self.node.player_list1:insertDefaultItem(i -1)
        local item  = self.node.player_list1:getItem(i-1)
        self:updateTotoalScoreItem(item,v,i)
    end

    self:setRoomId(roomInfo.rooid)

    if string.utf8len(roomInfo.createRoomName) > 5 then
        roomInfo.createRoomName = string.utf8sub(roomInfo.createRoomName,1,5)
        roomInfo.createRoomName = roomInfo.createRoomName .."..."
    end
    self:setRoomOnwerName(roomInfo.createRoomName)
    self:setSetNum(roomInfo.num,roomInfo.totalSet)
    self:setTime(roomInfo.time)
end

--设置总分排行中显示的房间信息
function VipOverLayer:setRoomId( roomid )
    self.node.roomid_txt:setString(roomid)
    self.node.roomid1_txt:setString(roomid)
end
function VipOverLayer:setRoomOnwerName(name)
    self.node.roomonwername_txt:setString(name.."")
end
function VipOverLayer:setSetNum(num,setNum)
    self.node.roomsetnum_txt:setString(num.."/"..setNum)
end
function VipOverLayer:setTime(time)
    if self.node.time_txt then
        self.node.time_txt:setString(time)
    end
    if self.node.time1_txt then
        self.node.time1_txt:setString(time)
    end
end

function VipOverLayer:updateTotoalScoreItem(item,dataItem,i)
    local Image_ranknum = item:getChildByName("Image_ranknum")
    local head_bg       = item:getChildByName("head_bg")

    local head_node = cc.Sprite:create(self.res_base .. "/logo0.png")
    head_node:setAnchorPoint(cc.p(0,0))
    local  size =head_bg:getContentSize()
    local  head_nodeWidth=head_node:getTextureRect().width
    local  head_nodeHeight= head_node:getTextureRect().height
    head_bg:getParent():addChild(head_node)
    head_node:setPositionX(head_bg:getPositionX())
    head_node:setPositionY(head_bg:getPositionY())
    head_bg:hide()

    head_node:setScaleX(size.width/head_nodeWidth)
    head_node:setScaleY(size.width/head_nodeHeight)

    if dataItem.headImgUrl and dataItem.headImgUrl ~= "" then
        self.part:loadHeadImg(dataItem.headImgUrl,head_node)
    end

    local name_txt      = item:getChildByName("name_txt")
    local ID_show_txt   = item:getChildByName("ID_show_txt")
    local id_txt   = item:getChildByName("id_txt")
    if string.utf8len(dataItem.name) > 5 then
        dataItem.name = string.utf8sub(dataItem.name,1,5)
        dataItem.name = dataItem.name .."..."
    end
    name_txt:setString(dataItem.name.."")

    ID_show_txt:setString(dataItem.ID)
    --房主標示
    local Image_rooms   = item:getChildByName("Image_rooms")
    local Image_win   = item:getChildByName("Image_win")

    local function setBright(b)
        local color =cc.c3b(255,246,202)  
        if b then
           color = cc.c3b(219,255,52)
            local bright=self.res_base .."/fourth_1.png"
            item:loadTexture(bright,1)
        end
        name_txt:setColor(color)
        ID_show_txt:setColor(color)
        id_txt:setColor(color)
    end

    local AtlasLabel_zimo       = item:getChildByName("AtlasLabel_zimo")
    local AtlasLabel_jiepao     = item:getChildByName("AtlasLabel_jiepao")
    local AtlasLabel_dianpao    = item:getChildByName("AtlasLabel_dianpao")
    local AtlasLabel_angang     = item:getChildByName("AtlasLabel_angang")
    local AtlasLabel_minggang   = item:getChildByName("AtlasLabel_minggang")
    local AtlasLabel_totalscore = item:getChildByName("AtlasLabel_totalscore")

    local AtlasLabel_zimo_0       = item:getChildByName("AtlasLabel_zimo_0")
    local AtlasLabel_jiepao_0     = item:getChildByName("AtlasLabel_jiepao_0")
    local AtlasLabel_dianpao_0    = item:getChildByName("AtlasLabel_dianpao_0")
    local AtlasLabel_angang_0     = item:getChildByName("AtlasLabel_angang_0")
    local AtlasLabel_minggang_0   = item:getChildByName("AtlasLabel_minggang_0")
    local AtlasLabel_totalscore_0 = item:getChildByName("AtlasLabel_totalscore_0")


    local AtlasLabel_totalscore = item:getChildByName("AtlasLabel_totalscore")

    setBright(dataItem.isOwnerRoom)

    if dataItem.isOwnerRoom ==false then
        Image_rooms:hide()
        AtlasLabel_zimo_0:hide()
        AtlasLabel_jiepao_0:hide()   
        AtlasLabel_dianpao_0:hide()
        AtlasLabel_angang_0:hide() 
        AtlasLabel_minggang_0:hide() 
        AtlasLabel_totalscore_0:hide()

        AtlasLabel_zimo:show()
        AtlasLabel_jiepao:show()   
        AtlasLabel_dianpao:show()
        AtlasLabel_angang:show() 
        AtlasLabel_minggang:show() 
        AtlasLabel_totalscore:show()
        self:setNumStyle(AtlasLabel_zimo,dataItem.zimoCount,false)
        self:setNumStyle(AtlasLabel_jiepao,dataItem.jiepaoCount,false)
        self:setNumStyle(AtlasLabel_dianpao, dataItem.dianpaoCount,false)
        self:setNumStyle(AtlasLabel_angang,dataItem.angangCount,false)
        self:setNumStyle(AtlasLabel_minggang,dataItem.minggangCount,false)
        self:setNumStyle(AtlasLabel_totalscore,dataItem.totoalScore,true)
    else
        Image_rooms:show()
        AtlasLabel_zimo:hide()
        AtlasLabel_jiepao:hide()   
        AtlasLabel_dianpao:hide()
        AtlasLabel_angang:hide() 
        AtlasLabel_minggang:hide() 
        AtlasLabel_totalscore:hide()

        AtlasLabel_zimo_0:show()
        AtlasLabel_jiepao_0:show()   
        AtlasLabel_dianpao_0:show()
        AtlasLabel_angang_0:show() 
        AtlasLabel_minggang_0:show() 
        AtlasLabel_totalscore_0:show()

        self:setNumStyle(AtlasLabel_zimo_0,dataItem.zimoCount,false)
        self:setNumStyle(AtlasLabel_jiepao_0,dataItem.jiepaoCount,false)
        self:setNumStyle(AtlasLabel_dianpao_0, dataItem.dianpaoCount,false)
        self:setNumStyle(AtlasLabel_angang_0,dataItem.angangCount,false)
        self:setNumStyle(AtlasLabel_minggang_0,dataItem.minggangCount,false)
        self:setNumStyle(AtlasLabel_totalscore_0,dataItem.totoalScore,true)
    end

    local numtb = {"one","two","three","four"}
    local imgRankPath =self.res_base .. "/"..numtb[i]..".png"
    print("dddd---------------"..imgRankPath)
    Image_ranknum:loadTexture(imgRankPath)
    if i == 1 then
        Image_win:show()
    else
        Image_win:hide()
    end
end

function VipOverLayer:setNumStyle(atl,num,b)
    if not b then
        atl:setString(""..num)
        return
    end
    local strTag = ""
    if num < 0 then
        strTag ="/"
    elseif num >0 then
        strTag ="."
    end
    atl:setString(strTag..num)   
end


---------------
--设置各局流水样式
function VipOverLayer:updateLiuShuiItem(item,dataItem,i)
    local dItem        = item:getChildByName("player_panel2")
    local AtlasLabel1  = dItem:getChildByName("AtlasLabel1")
    local AtlasLabel2  = dItem:getChildByName("AtlasLabel2")
    local AtlasLabel3  = dItem:getChildByName("AtlasLabel3")
    local AtlasLabel4  = dItem:getChildByName("AtlasLabel4")
    local Image_sort   = dItem:getChildByName("Image_sort")

    local sharedBtn    = dItem:getChildByName("Button_8_0")
    local backPlay     = dItem:getChildByName("Button_8")

    local AtlasLabel_sort_num = Image_sort:getChildByName("AtlasLabel_sort_num")
    AtlasLabel_sort_num:setString(i)

    AtlasLabel1:setString(dataItem.playerOneScore)
    AtlasLabel2:setString(dataItem.playerTwoScore)
    AtlasLabel3:setString(dataItem.playerThreeScore)
    AtlasLabel4:setString(dataItem.playerFourScore)

    self:setNumStyle(AtlasLabel1,dataItem.playerOneScore,true)
    self:setNumStyle(AtlasLabel2,dataItem.playerTwoScore,true)
    self:setNumStyle(AtlasLabel3,dataItem.playerThreeScore,true)
    self:setNumStyle(AtlasLabel4,dataItem.playerFourScore,true)
end


--各局流水分享
function VipOverLayer:sharedItemClick(pSender,event)
    local handIndex =self.node.player_list:getCurSelectedIndex() + 1
    print("sharedItemClick----handIndex-----------------------:"..handIndex)
    self:sharedRecord(self.part:getRoomNumAddHandIndex(handIndex))
end

--各局流水回放
function VipOverLayer:backPlayClick(pSender,event)
    local handIndex =self.node.player_list:getCurSelectedIndex() +1 
    print("backPlayClick----handIndex-----------------------:"..handIndex)
    self:backPlayRecord(self.part:getRoomNumAddHandIndex(handIndex))
end

--回放
function VipOverLayer:backPlayRecord(idx)
        print("----backPlayRecord-----------------------:"..idx)
end
--分享
function VipOverLayer:sharedRecord(idx)
    print("----sharedRecord-----------------------:"..idx)
end

function VipOverLayer:setLiuShuiStyle(handData,roomInfo)
    --玩家标题;
    for i,v in ipairs(handData.playerTitleInfoList) do
        local info = self.node["info"..i]
        self:setLiushuiTitleItem(info,v.name,v.isOwnerRoom,v.isWiner)
    end
    --分数记录流水
    for i,v in ipairs(handData.recordDataList) do
        self.node.player_list:insertDefaultItem(i -1)
        local item  = self.node.player_list:getItem(i-1)
        self:updateLiuShuiItem(item,v,i)
    end

    print("handData.recordDataList :"..#handData.recordDataList)

    if #handData.recordDataList <= 4 then
        self.node.Slider_Percent:hide()
        self._canSlide = false
    end

    --设置流水时间
    local function setLiuShuiTime(date,time)
       self.node.Text_date:setString(date)
       self.node.Text_time:setString(time)
    end

    setLiuShuiTime(roomInfo.date,roomInfo.time)
end

function VipOverLayer:setLiushuiTitleItem(item,name,isOwnerRoom,isWiner)
    local txt_name = item:getChildByName("txt_name")
    -- local Text_ID = item:getChildByName("Text_ID")
    local sp_win = item:getChildByName("sp_win")
    local Sp_room = item:getChildByName("Sp_room")

    txt_name:setString(name)
    -- Text_ID:setString(ID)
    if isOwnerRoom then
        Sp_room:show()
        txt_name:setColor(cc.c3b(255, 144, 0))
    else 
        Sp_room:hide()
        txt_name:setColor(cc.c3b(255, 255, 255))
    end

    if isWiner then
        sp_win:show()
    else
        sp_win:hide()
    end
end
------------------------------------------
function VipOverLayer:vipOverDataInfo(data,vipData,tableId,creatorId,creatorName)
    print("VipOverLayer:vipOverDataInfo")
end

--data:总分流水信息
--roomInfo:房间内的信息
function VipOverLayer:updateTotalSort(data,roomInfo)
    self:setTotalStyle(data,roomInfo)
    print("VipOverLayer:updateTotalSortVipOverLayer:updateTotalSortVipOverLayer:updateTotalSort")
end

--各局流水
function VipOverLayer:updateHandlerRecord(handData,roomInfo)
    self:setLiuShuiStyle(handData,roomInfo)
end

function VipOverLayer:onClose()
    self.part:returnGame()
end

function VipOverLayer:showTotoalScore()
    self.node.banner_1:show()
    self.node.banner_2:hide()

    self.node.Panel_Liushui:hide()
    self.node.Panel_total:show()

    -- local path=self.res_base .. "/banner.png"
    -- self.node.banner_1:setTexture(path)
    -- self.node.player_list1:show()
    -- self.node.Node_Tittle:show()
    -- self.node.show_btn:show()
    -- self.node.nodeInfo:show()
    -- self.node.nodeInfo_1:hide()

    -- self.node.Sprite_15:hide()
    -- self.node.player_list:hide()   
    -- self.node.Slider_Percent:hide()
end

function VipOverLayer:showLiuShui()
    self.node.banner_1:hide()
    self.node.banner_2:show()
    
    self.node.Panel_Liushui:show()
    self.node.Panel_total:hide()
--     self.node.banner_1:setTexture(path)
--     self.node.player_list1:hide()
--     self.node.Node_Tittle:hide()
--     self.node.show_btn:hide()

--     self.node.nodeInfo:hide()
--     self.node.nodeInfo_1:show()
--     self.node.Sprite_15:show()
--     self.node.player_list:show()
--     if self._canSlide then
--         self.node.Slider_Percent:show()       
--     end
 end

function VipOverLayer:totalScoreClick()
    self:showTotoalScore()
end
function VipOverLayer:liuShuiClick()
    --if self._canSelected == false  then return end

    self:showLiuShui()
end

function VipOverLayer:ShowClick()
    local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    -- bridge:saveGamePic()

    local shareContent = string_table.wx_one_friend
    local shareUrl = string_table.share_weixin_android_url
    --分享内容和分享链接都是从服务器上拉取的

    local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

    for i,v in ipairs(gameConfigList) do
        local gameParam = gameConfigList[i]
        if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_CONTENT then
            if gameParam.valueStr then
                shareContent = gameParam.valueStr --分享内容
            end
        end

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

    if bridge.savePicAndShare then
        bridge:savePicAndShare(nil,shareContent,shareUrl,2)
    else
        bridge:saveGamePic()
        local time = nil
        time = self:schedulerFunc(function()
            if time ~= nil then
                self:unScheduler(time)
            end
            bridge:ShareToWX(2,shareContent,shareUrl) --分享图片
        end,1,false)
    end
    -- self:BackClick()
end


return VipOverLayer
