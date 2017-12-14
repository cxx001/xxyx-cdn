cc.exports.GameVerInfo = {
	-- 合集大厅版本号
	HALL_VERSION = "1.0.0.0";
	-- 子游戏版本号
	-- 主版本号
	MAIN_VERSION_NUMBER = 1; 	
	-- 子版本号
	SUB_VERSION_NUMBER = 0;	
	-- 修正版本号	
	REVISION_NUMBER = 0;	
	-- 编译版本号	
	BUILD_NUMBER = 0;
};

-- 获取主版本号
function GameVerInfo.getMainVersionNumber(  )
	return GameVerInfo.MAIN_VERSION_NUMBER;
end
-- 获取子版本号
function GameVerInfo.getSubVersionNumber(  )
	return GameVerInfo.SUB_VERSION_NUMBER;
end
-- 获取修正版本号
function GameVerInfo.getRevisionNumber(  )
	return GameVerInfo.REVISION_NUMBER;
end
-- 获取编译版本号
function GameVerInfo.getBuildNumber(  )
	return GameVerInfo.BUILD_NUMBER;
end
-- 获取子游戏版本字符串
-- 格式：1.0.0.1001
function GameVerInfo.getGameVersionString(  )
	local strVer = string.format("%d.%d.%d.%d", 
		GameVerInfo.MAIN_VERSION_NUMBER, GameVerInfo.SUB_VERSION_NUMBER, 
		GameVerInfo.REVISION_NUMBER, GameVerInfo.BUILD_NUMBER);
	return strVer;
end
-- 获取子游戏版本数字
-- 主版本号、子版本号、修正版号为2位，编译版本号为4位
function GameVerInfo.getGameVersionNumber(  )
	local strVer = string.format("%02d%02d%02d%04d", 
		GameVerInfo.MAIN_VERSION_NUMBER, GameVerInfo.SUB_VERSION_NUMBER, 
		GameVerInfo.REVISION_NUMBER, GameVerInfo.BUILD_NUMBER);
	local verNum = tonumber(strVer);
	return verNum;
end
