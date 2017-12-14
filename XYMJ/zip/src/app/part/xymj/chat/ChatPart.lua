--[[
*名称:ChatLayer
*描述:聊天界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local ChatPart = class("ChatPart",cc.load('mvc').PartBase) --登录模块
ChatPart.DEFAULT_PART = {}
ChatPart.DEFAULT_VIEW = "ChatLayer"
--[
-- @brief 构造函数
--]
ChatPart.CMD = {
    MSG_TALKING_IN_GAME        = 0xc30300, --聊天消息
} 
function ChatPart:ctor(owner)
    ChatPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function ChatPart:initialize()
	self.cur_select =  self.FACE_TYPE --默认打开表情页面
	self.record_list = {}
end

--获取相对应的模板
function ChatPart:getChatTempItem(msgType,pos)
	
end

--激活模块
--[[
	pos_table = { --激活需要传入表情坐标table(相对整个界面的坐标)
		cc.p()
		cc.p()
	}
--]]
function ChatPart:activate(gameId,posTable,voiceRoomID)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	-- if voiceRoomID and voiceRoomID ~= "" then
	-- 	self.voiceRoomID = voiceRoomID
	-- else
	-- 	self.voiceRoomID = nil
	-- end
	if not posTable then
		printLog('warning',"pos table is nil activate chat part fail")
	end

	self.m_pos = seat_id

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(ChatPart.CMD.MSG_TALKING_IN_GAME,handler(self,ChatPart.recTalkingInGameMsg))

	self.pos_table = posTable
	self.voice_record_show = false --是否隐藏聊天记录界面
	ChatPart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:intRecordProgress(29)
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:addEventListener("nativeOnRecordVoiceEnd",handler(self,ChatPart.onRecordVoiceEnd))
	-- self.view:showSelectedPage(self.cur_select)
end

function ChatPart:IsSetDialect()
	if self.owner then
		return self.owner:IsSetDialect()
	end
	return false
end
function ChatPart:getGameAssetsPath()
	if self.owner then
		return self.owner:getGameAssetsPath()
	end	
	return ""
end


function ChatPart:showFaceWithIndex(faceId,index)
	-- body
	if self.pos_table[index] then
		self.view:showFaceWithPos(faceId,self.pos_table[index])
	end
end


function ChatPart:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(ChatPart.CMD.MSG_TALKING_IN_GAME)
	if self.view then
		self.view:hideIME()
		self.view:removeSelf()
		self.view =  nil
	end
end

function ChatPart:getPartId()
	-- body
	return "ChatPart"
end

--开始录音
function ChatPart:recordVoiceTouchDown()
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	local player_info = self.owner:getPlayerInfo(1)

	local audio_mod = global:getModuleWithId(ModuleDef.AUDIO_MOD)
	audio_mod:pause()
	lua_bridge:recordVoiceTouchDown(player_info.uid)
end

--结束录音
function ChatPart:recordVoiceTouchUp()
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:recordVoiceTouchUp()
end

function ChatPart:onRecordVoiceEnd(event)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:playRecordAudio(event.vpath,event.vlen,function(audioData,size)
		-- body
		self:sendTalkingInGameMsg(3,nil,"",audioData,event.vlen)
	end)
	local user = global:getGameUser()
	local data = {
		isme = true,
		img_url = "",
		voice_path = event.vpath,
		voice_lenth = math.floor(event.vlen)
	}
	local index = #self.record_list
	table.insert(self.record_list,data)
	-- self.view:voiceListAddCell(index,data)
end

function ChatPart:sendText(str , pos, flag , sex)
	-- body
	self.view:showTextWithPos(str,self.pos_table[pos],pos,flag,sex)
end


--播放从服务端接收的语音数据
function ChatPart:playAudioMsg(data)
	-- body
	if data == nil then
		return
	end
	print("this is playAudioMsg:",string.len(data.audio))
	if string.len(data.audio) < 40 then --判断数据长度
		return
	end

	local user = global:getGameUser()
	local uid = user:getProp("uid")
	local cur_time = os.time()
	local random_num = math.random()
	local save_path = string.format("%saudio_%d_%d_%d.spx", cc.FileUtils:getInstance():getWritablePath(),cur_time,random_num,uid)
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)

	if lua_bridge:saveFile(save_path,data.audio,string.len(data.audio)) == false then
		printInfo("Warring","play audio msg save file fail")
		return
	end

	-- body
	lua_bridge:playRecordAudio(save_path,data.audioLenth)

	local user = global:getGameUser()
	local audio_data = {
		isme = false,
		img_url = "",
		voice_path = save_path,
		voice_lenth = math.floor(data.audioLenth)
	}
	local index = #self.record_list
	table.insert(self.record_list,audio_data)
	-- self.view:voiceListAddCell(index,audio_data)
	local view_id = self:changeSeatToView(data.playerPos)
	self.view:showYuYinWithPos(self.pos_table[view_id],view_id)
end

function ChatPart:faceEvent()
	-- body
	if self.cur_select ~= self.view.FACE_TYPE then
		self.cur_select = self.view.FACE_TYPE
		self.view:showSelectedPage(self.cur_select)
	end
end

function ChatPart:textEvent()
	-- body
	if self.cur_select ~= self.view.TEXT_TYPE then
		self.cur_select = self.view.TEXT_TYPE
		self.view:showSelectedPage(self.cur_select)
	end
end

function ChatPart:voiceRecordEvent()
	-- body
	self.voice_record_show = not self.voice_record_show
	self.view:setVoiceRecordState(self.voice_record_show)
end

function ChatPart:loadImgToSprite(sprite,url)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    lua_bridge:startDownloadImg(url,sprite)
end

function ChatPart:playRecord(index)
	-- body
	local data = self.record_list[index]
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:playRecordAudio(data.voice_path,data.voice_lenth)
end

function ChatPart:hideSz()
	-- body
	self.view:hideSz()
end

function ChatPart:showSz()
	-- body
	self.view:ChatClick()
end

function ChatPart:hideSzBtn()
	-- body
	self.view:hideSzBtn()
end

function ChatPart:hideVoice()
    --body
    self.view:hideVoice()
end

function ChatPart:showVoice()
    --body
    self.view:showVoice()
end
function ChatPart:getPlayerInfo()
	-- body
	return self.owner:getPlayerInfo(1)
end

function ChatPart:getPlayerInfo()
 	-- body
	return self.owner:getPlayerInfo(1)
end

function ChatPart:sendTalkingInGameMsg(msgType , msgNo , msgText ,audio ,audioLenth)				--请求版本是否更新
	print("----send sendTalkingInGameMsg success")
	local net_manager = global:getNetManager()
	local send_talking_msg = ycmj_message_pb.TalkingInGameMsg()

  	local user = global:getGameUser()
	local sex = user:getProp("sex")	
	send_talking_msg.playerSex = sex        --貌似服务端不会帮我们填好位置和性别
	send_talking_msg.msgType = msgType 		--消息类型  0：系统自带快捷语音 1：系统表情 2:自定义文字,3语音
	if msgNo then
		send_talking_msg.msgNo = msgNo 
	end

	if msgText then
		send_talking_msg.msgText = msgText
	end

	if audio then
		send_talking_msg.audio = audio
	end

	if audioLenth then
		send_talking_msg.audioLenth = audioLenth
	end	
	
	local buff_str = send_talking_msg:SerializeToString()
	local buff_lenth = send_talking_msg:ByteSize()

	net_manager:sendProtoMsg(send_talking_msg,ChatPart.CMD.MSG_TALKING_IN_GAME,self.game_id)
end

function ChatPart:recTalkingInGameMsg(data,appId)
	local rec_talking_msg = ycmj_message_pb.TalkingInGameMsg()
	rec_talking_msg:ParseFromString(data)
	print("recTalkingInGameMsg : ",rec_talking_msg)
	local msgType = rec_talking_msg.msgType
	local msgText = rec_talking_msg.msgText
	local playsex = rec_talking_msg.playerSex
	local playerPos = self:changeSeatToView(rec_talking_msg.playerPos)

	if msgType == 0 then
		self:sendText(msgText,playerPos,true,playsex)
	elseif msgType == 1 then
		self.view:showFaceWithPos(rec_talking_msg.msgNo,self.pos_table[playerPos])
	elseif  msgType == 2 then
		self:sendText(msgText,playerPos,false,playsex)
	elseif msgType == 3 then
		self:playAudioMsg(rec_talking_msg)
	end
end

--将逻辑座位转换为界面座位
function ChatPart:changeSeatToView(seatId) --座位顺时针方向增加 1 - 4
	return self.owner:changeSeatToView(seatId)
end

function ChatPart:setTablePos(tablePos)
	self.pos_table = posTable
end

function ChatPart:setChatBtnStat(isShow)
	if self.view then
		self.view:setChatBtnStat(isShow)
	end
end

function ChatPart:onEnter()
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    if not audio_manager:isMusicPlaying() then
        --sdk初始化问题，防止直接进入房间时没有播放背景音
        audio_manager:playMusic("res/sound/sc_bgm0.mp3")
    end
end

function ChatPart:onExit()
end

return ChatPart
