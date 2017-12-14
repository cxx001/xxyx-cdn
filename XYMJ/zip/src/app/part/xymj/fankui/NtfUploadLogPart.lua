local CURRENT_MODULE_NAME = ...
local NtfUploadLogPart = class("NtfUploadLogPart",cc.load('mvc').PartBase) --登录模块
NtfUploadLogPart.DEFAULT_VIEW = ""
NtfUploadLogPart.CMD = {
	MSG_UPLOADLOG_NTF = SocketConfig.MSG_UPLOADLOG_NTF or 0xc30660, --服务器下推日志上传
}
NtfUploadLogPart.defaultContent = "userID %s date %s [server push log]"
pcall(require,"app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".logReported_pb")
pcall(require,"app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".logReported_pb")
--[
-- @brief 构造函数
--]
function NtfUploadLogPart:ctor(owner)
    NtfUploadLogPart.super.ctor(self, owner)
    self:initialize() 
end
 

function NtfUploadLogPart:activate(gameId) 
	NtfUploadLogPart.super.ctor(self, owner)
	self.gameId = gameId 

	local netManager = global:getModuleWithId(ModuleDef.NET_MOD)
	netManager:registerMsgListener(NtfUploadLogPart.CMD.MSG_UPLOADLOG_NTF,handler(self,NtfUploadLogPart.onUploadLogMsg)) 

	--测试代码
	-- local user = global:getGameUser()
	-- local uid = user:getProp("uid")
	-- self:onUploadLogFile(uid, "log_2017_9_18", "测试")
end

function NtfUploadLogPart:onUploadLogMsg(data,appID) 
	local logMsg = logReported_pb.LogReported()  
    logMsg:ParseFromString(data)

	local uid = logMsg.playerIndex
	local date = logMsg.operationTime
	local desc = logMsg.description or ""
	self:onUploadLogFile(uid, date, desc)
end

function NtfUploadLogPart:onUploadLogFile(target_uid, target_date, desc) 
	local user = global:getGameUser()
	local uid = user:getProp("uid")
	if tostring(target_uid) ~= tostring(uid) then
		release_print("###[NtfUploadLogPart:onUploadLogFile]target_uid ~= uid: ", target_uid,uid) 
		return
	end
	local logFilepath = self:getLogFilePath(target_date)  
	if not logFilepath then
		release_print(string.format("###[NtfUploadLogPart:onUploadLogFile]file is not exist :target_uid %s target_date %s",
			tostring(target_uid), tostring(target_date)))
		return
	end
	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	local content = string.format(NtfUploadLogPart.defaultContent, target_uid, target_date) 
	if writeInfo then
		writeInfo(desc)
	else
		release_print(desc)
	end
	
	release_print("###[NtfUploadLogPart:onUploadLogFile]content logFilepath ",content,logFilepath) 
	http_mode:UpLoadLogFile(target_uid, self.gameId, logFilepath, content)
end

function NtfUploadLogPart:getLogFilePath(date) 
	local fileInstance = cc.FileUtils:getInstance()
	local logFileName = string.format("%slog/%s.txt",fileInstance:getWritablePath(), date)
    release_print("###[NtfUploadLogPart:getLogFilePath]logFileName ", logFileName); 
    if fileInstance:isFileExist(logFileName) then 
    	return logFileName
    else
    	logFileName = string.format("%slog/%s.gz",fileInstance:getWritablePath(), date) 
    	release_print("###[NtfUploadLogPart:getLogFilePath]logFileName ", logFileName);     	
    	if fileInstance:isFileExist(logFileName) then
    		logFileName = string.gsub(logFileName, ".gz", ".txt") 
    		return logFileName
    	end
    end 

    return null
end

function NtfUploadLogPart:deactivate()
	if self.view then
		self.view:removeSelf()
	  	self.view =  nil
	end
end

function NtfUploadLogPart:getPartId()
	-- body
	return "NtfUploadLogPart"
end

return NtfUploadLogPart