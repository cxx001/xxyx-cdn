--[[
*名称:TeamVoicePart
*描述:队伍语音界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TeamVoicePart = class("TeamVoicePart",cc.load('mvc').PartBase) --登录模块
TeamVoicePart.DEFAULT_PART = {}
TeamVoicePart.DEFAULT_VIEW = "TeamVoiceLayer"
--[
-- @brief 构造函数
--]

TeamVoicePart.CMD = {
	MSG_VOICE_BIND_MEMBER_REQ = 0xc30093, --语音房间绑定玩家uid和腾讯语音memberid
    MSG_VOICE_BIND_MEMBER_ACK = 0xc30094, --绑定成功广播所有玩家绑定关系
}
TeamVoicePart.realVoiceRoomID = nil

function TeamVoicePart:ctor(owner)
    TeamVoicePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function TeamVoicePart:initialize()

end

--激活模块
--[[
	pos_table = { --激活需要传入表情坐标table(相对整个界面的坐标)
		cc.p()
		cc.p()
	}
--]]
function TeamVoicePart:activate(gameId)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
    self.memberMap = {}
	TeamVoicePart.super.activate(self,CURRENT_MODULE_NAME)
	-- self.view:showSelectedPage(self.cur_select)
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD) 
	net_mode:registerMsgListener(TeamVoicePart.CMD.MSG_VOICE_BIND_MEMBER_ACK,handler(self,TeamVoicePart.bindMemberAck)) --牌局开始

    if lua_bridge.registerScriptMemberStatusChanged then
        lua_bridge:registerScriptMemberStatusChanged(function(memberid,status) 
            --通知玩家状态改变
            if self.memberMap[memberid] ~= nil then
                --找到状态改变的玩家
                if self.owner ~= nil then
                    local playerlist = self.owner.player_list
                    for k,v in ipairs(playerlist) do
                        if v.playerIndex == self.memberMap[memberid] then
                            --找到玩家
                            self.view:memberChangeStatus(playerlist[k].view_id,status)
                            break
                        end
                    end
                end
            end
        end)
    end
end

--进入语音房间
function TeamVoicePart:enterVoiceRoom(voiceRoomID)
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	-- self.view:showSelectedPage(self.cur_select)onTouchSpeaker
    self.hasJoinRoom = false
    if voiceRoomID and voiceRoomID ~= "" then
        lua_bridge:registerLuaJoinRoomHandler(function(memberId) 
            local speakerState = cc.UserDefault:getInstance():getBoolForKey("speaker",true)
            if speakerState then
                self.view:openVoiceSpeaker()
            end
            local micState = cc.UserDefault:getInstance():getBoolForKey("micphone",false)
            if micState then
                self.view:openVoiceMic()
            end
            if memberId ~= nil then
                self:bindMemberWithUID(memberId)
            end
        end)

		print("voice join room id",voiceRoomID)
        local joinret = lua_bridge:joinRoom(self.view,voiceRoomID) --打开房间
        if joinret == 0 then
            self.hasJoinRoom = true
            --真正的房间id
            TeamVoicePart.realVoiceRoomID = voiceRoomID 
        elseif joinret == 8194 then
            --加入房间失败,还没有退出房间
            if TeamVoicePart.realVoiceRoomID ~= nil and TeamVoicePart.realVoiceRoomID ~= "" then
                local retcode = lua_bridge:quitRoom(TeamVoicePart.realVoiceRoomID)
                if retcode == 0 then --退出房间成功
                    local ret = lua_bridge:joinRoom(self.view,voiceRoomID) --打开房间
                    if ret == 0 then
                        --加入房间成功
                        TeamVoicePart.realVoiceRoomID = voiceRoomID 
                    end
                elseif retcode == 8195 then
                    print("quit roomname not equal join roomname")
                end
            end
        end
        self.voiceRoomID = voiceRoomID
    end
end

--退出语音房间
function TeamVoicePart:exitVoiceRoom()
    local roomname = nil
	if TeamVoicePart.realVoiceRoomID ~= nil and TeamVoicePart.realVoiceRoomID ~= "" then
        roomname = TeamVoicePart.realVoiceRoomID	
    else
        if self.voiceRoomID ~= nil and self.voiceRoomID ~= "" then
            roomname = self.voiceRoomID
        end
	end	
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    if roomname ~= nil then
        local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
        local retcode = lua_bridge:quitRoom(roomname)
        if retcode == 0 then
            --退出房间成功
            TeamVoicePart.realVoiceRoomID = nil
            self.voiceRoomID = nil
        elseif retcode == 8195 then
            --quit roomname not equal join roomname
            print("quit roomname not equal join roomname")
        end
    end
end

function TeamVoicePart:deactivate()
	self:exitVoiceRoom()
	if self.view then
		self.view:removeSelf()
		self.view =  nil
	end
    self.memberMap = ｛｝
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD) 
	net_mode:unRegisterMsgListener(TeamVoicePart.CMD.MSG_VOICE_BIND_MEMBER_ACK) --牌局开始
end

function TeamVoicePart:getPartId()
	-- body
	return "TeamVoicePart"
end

function TeamVoicePart:loadImgToSprite(sprite,url)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    lua_bridge:startDownloadImg(url,sprite)
end

function TeamVoicePart:hideVoice()
    --body
    self.view:hideVoice()
end

function TeamVoicePart:showVoice()
    --body
    self.view:showVoice()
end
function TeamVoicePart:getPlayerInfo()
	-- body
	return self.owner:getPlayerInfo(1)
end

function TeamVoicePart:onEnter()
    local roomname = nil
    if not self.hasJoinRoom then
        if TeamVoicePart.realVoiceRoomID ~= nil and TeamVoicePart.realVoiceRoomID ~= "" then
            roomname = TeamVoicePart.realVoiceRoomID         
        else
            if self.voiceRoomID ~= nil and self.voiceRoomID ~= "" then
                roomname = self.voiceRoomID
            end
        end 
    end
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    if roomname ~= nil then
        print("voice join room id",roomname)
        local joinret = lua_bridge:joinRoom(self.view,roomname)
        if joinret == 0 then
            self.hasJoinRoom = true
            TeamVoicePart.realVoiceRoomID = roomname
        elseif joinret == 8194 then
            --加入房间失败,还没有退出房间
            if TeamVoicePart.realVoiceRoomID ~= nil and TeamVoicePart.realVoiceRoomID ~= "" then
                local retcode = lua_bridge:quitRoom(TeamVoicePart.realVoiceRoomID)
                if retcode == 0 then --退出房间成功
                    if self.voiceRoomID ~= nil and self.voiceRoomID ~= "" then
                        local ret = lua_bridge:joinRoom(self.view,self.voiceRoomID) --打开房间
                        if ret == 0 then
                            --加入房间成功
                            TeamVoicePart.realVoiceRoomID = voiceRoomID 
                        end
                    end
                elseif retcode == 8195 then
                    print("quit roomname not equal join roomname")
                end
            end
        end
        print("voice join room ret",joinret)
        self.view:showVoice()
    end
end

function TeamVoicePart:openMicFailed()
    --没有房间才会进这个函数
    local roomname = nil
    if not self.hasJoinRoom then
        if self.voiceRoomID ~= nil and self.voiceRoomID ~= "" then
            roomname = self.voiceRoomID
        end
    end
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    if roomname ~= nil and roomname ~= "" then
        print("voice join room id",roomname)
        local joinret = lua_bridge:joinRoom(self.view,roomname)
        if joinret == 0 then
            --加入语音房间成功
            TeamVoicePart.realVoiceRoomID = roomname
        end
        print("voice join room ret",joinret)
    end
end

function TeamVoicePart:openSpeakerFailed()
    --没有房间才会进这个函数
    local roomname = nil
    if not self.hasJoinRoom then
        if self.voiceRoomID ~= nil and self.voiceRoomID ~= "" then
            roomname = self.voiceRoomID
        end
    end
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    if roomname ~= nil and roomname ~= "" then
        print("voice join room id",roomname)
        local joinret = lua_bridge:joinRoom(self.view,roomname)
        if joinret == 0 then
            --加入语音房间失败
            TeamVoicePart.realVoiceRoomID = roomname
        end
        print("voice join room ret",joinret)
    end
end

function TeamVoicePart:onExit()
	self:exitVoiceRoom()
end

--micphone按钮准备界面时位置
function TeamVoicePart:setReadyPos()
    self.view:setReadyPos()
end

--micphone按钮原位置
function TeamVoicePart:setOriginPos()
    self.view:setOriginPos()
end

function TeamVoicePart:bindMemberWithUID(memberID)
    local user = global:getGameUser()
   	local game_player = user:getProp("gameplayer"..self.game_id)
	local uid = game_player.playerIndex
    
	local bind_msg = game_message_pb.RequestVoiceBindPlayerMsg()
    bind_msg.bindRecord.playerIndex = tonumber(uid)
    bind_msg.bindRecord.voiceRoomMemberId = memberID
    
	local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)

    net_manager:sendProtoMsg(bind_msg,TeamVoicePart.CMD.MSG_VOICE_BIND_MEMBER_REQ,self.game_id)
end

function TeamVoicePart:bindMemberAck(data,appId)
    self.memberMap = {}
    local voiceBindPlayerMsg_ack = game_message_pb.RequestVoiceBindPlayerMsgAck()
    voiceBindPlayerMsg_ack:ParseFromString(data)
	if voiceBindPlayerMsg_ack.resultCode == 0 then
        for k,v in ipairs(voiceBindPlayerMsg_ack.bindRecordList) do
            self.memberMap[v.voiceRoomMemberId] = v.playerIndex
        end
    elseif voiceBindPlayerMsg_ack.resultCode == 1000 then
        print("user not exsit")
    else
        print("error")
	end
end

return TeamVoicePart
