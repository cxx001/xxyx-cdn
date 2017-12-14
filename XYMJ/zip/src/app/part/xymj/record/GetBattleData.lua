
local GetBattleData = class('GetBattleData')

local LOAD_DOTA_URL		 = 'http://testapi.xiaoxiongyouxi.com/game-log/get-file-data?code='
local GET_SHARE_CORE_URL = 'http://testapi.xiaoxiongyouxi.com/game-log/fetch-share-code?'

local keys = {
	[262402] = '!*rxCnSu34SIOyj&KlchEhVF%ni5PjTS',
	[262407] = 'sQRitw3cFPcCFR2LbXHFbumlfMfjWIwj',
}

--[[
@ 获取分享码
]]
function GetBattleData:reqShareCore(tid, bid, call_back)
	local url = GET_SHARE_CORE_URL
	local params = {
		gid 		= tostring(SocketConfig.GAME_ID),
		tid			= tostring(tid),
		bid			= tostring(bid),
		timestamp	= tostring(os.time()),
	}

	-- @ sort
	local sorted_tbl = {}
    for i in pairs(params) do  
        table.insert(sorted_tbl,i)  
    end  
    table.sort(sorted_tbl)

    -- @ ?key=value&key=value
    local key_values = ''
    for i, name in ipairs(sorted_tbl) do
    	-- @ add key=
    	key_values = key_values .. name .. '='

    	-- @ add value
    	key_values = key_values .. params[name]

    	-- @ add &
    	if i < #sorted_tbl then
    		key_values = key_values .. '&'
    	end
    end

    -- @ 项目md5_key  '!*rxCnSu34SIOyj&KlchEhVF%ni5PjTS'
    local game_id = tonumber(SocketConfig.GAME_ID)
    local result = md5.sumhexa(key_values .. '&key=' .. keys[game_id])
    -- @ 将md5转换大写，作为签名
	local sign = string.upper(result)
	-- @ 拼接sign
	url = url .. key_values .. '&sign=' .. sign

	print('reqShareCore:', url)
	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	local tag = "req_share_data_" .. os.time()
	http_mode:send(tag, url,"",0,function(code, data)
		-- @todo
		print('req_share_data', code, data)
		if call_back then
			call_back(code, data)
		end
	end)
end

--[[
@ 根据分享码获取牌局数据
]]
function GetBattleData:loadRecordData(share_code, call_back)

	local url = LOAD_DOTA_URL .. share_code
	print('loadRecordData', url)
	local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
	local tag = "load_record_data_" .. os.time()
	http_mode:send(tag, url,"",0,function(code, data)
		-- @todo
		if call_back then
			call_back(code, data)
		end
	end)
end

return GetBattleData
