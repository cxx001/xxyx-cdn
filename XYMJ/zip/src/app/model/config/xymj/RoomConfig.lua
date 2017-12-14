cc.exports.RoomConfig = {}
RoomConfig.TableSeatNum = 4 --座位数
RoomConfig.WaitTime = 15 --等待时间

RoomConfig.HandCardNum = 13 --最大手牌数

RoomConfig.MySeat = 1 --我的位置
RoomConfig.DownSeat = 2 --下家
RoomConfig.FrontSeat = 3 --对家
RoomConfig.UpSeat = 4 --上家

RoomConfig.HandCard = 1 --手牌
RoomConfig.DownCard = 2 --碰杠的牌
RoomConfig.OutCard = 3 --出的牌
RoomConfig.HuCard = 4 --胡的牌
RoomConfig.TingCard  = 5 --听的牌
RoomConfig.SpecialOutCard = 6 -- 出的癞子牌，痞子牌，红中牌

RoomConfig.Chi = 0x01
RoomConfig.Peng = 0x02
RoomConfig.AnGang = 0x04
RoomConfig.MingGang = 0x08
RoomConfig.BuGang = 0x20000000
RoomConfig.LaiziGang = 0x400000 --癞子杠
RoomConfig.Gang = 0x2000000 --血流麻将会冲突

RoomConfig.MAHJONG_OPERTAION_NOTIFY_NAO_ZHUANG = 0x1232 --服务端通知闲家闹庄的消息 4658
RoomConfig.MAHJONG_OPERTAION_NAO_ZHUANG = 0x1233  --客户端选择闹庄消息
RoomConfig.MAHJONG_OPERTAION_CANCLE_NAO_ZHUANG = 0x1234  --客户端选择不闹庄消息
RoomConfig.MAHJONG_OPERTAION_WAITING_TONG_NAO = 0x1235  --闲家等待庄家选择闹庄等待消息
RoomConfig.MAHJONG_OPERTAION_WAITING_NAO_ZHUANG = 0x1236  --庄家等待闲家选择闹庄等待消息
RoomConfig.MAHJONG_OPERTAION_NOTIFY_TONG_NAO = 0x1237  --服务端通知庄家通闹的消息 4663
RoomConfig.MAHJONG_OPERTAION_TONG_NAO = 0x1238  --客户端选择通闹消息
RoomConfig.MAHJONG_OPERTAION_CANCLE_TONG_NAO = 0x1239  --客户端选择不通闹消息
RoomConfig.MAHJONG_OPERTAION_NAO_CHAOSHI = 0x1240  --客户端选择超时消息 4672

RoomConfig.MAHJONG_OPERTAION_XIAZUI = 0x1242  --通知客户端可以下嘴
RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI = 0x1243 --客户端下嘴 和 服务器返回下嘴确认
RoomConfig.MAHJONG_OPERTAION_OVERTIME_XIAZUI = 0x1244 --客户端选择下嘴超时操作

RoomConfig.Character = 0 --万
RoomConfig.Bamboo = 1 --条
RoomConfig.Dot = 2 --筒
RoomConfig.Wind = 3 --风

RoomConfig.EmptyCard = 0x39


RoomConfig.CardType = {
    [RoomConfig.Character] = "character", --万
    [RoomConfig.Bamboo]    = "bamboo", --条
    [RoomConfig.Dot]       = "dot", --筒
    [RoomConfig.Wind]      = "wind", --风
}

if ISYN then
--红中麻将规则
RoomConfig.Rule = {
	[1] = 0x1, --红中麻将
	[2] = 0x2, --合肥点炮
	[3] = 0x100, --合肥自摸
	[4] = 0x40 --湖南红中
}

--玩法带码
RoomConfig.RuleMa = {
	[0] = 0x80, --无码
	[1] = 0x10, --2码
	[2] = 0x8, --4码
	[3] = 0x20, --6码
	[4] = 0x4, --3码
}

--玩法
RoomConfig.PlayRule = {
	[1] = 0x10000, --个旧
	[2] = 0x20000, --保山
	[3] = 0x40000, --昭通
	-- 1, --黄冈赖子杠
	-- 4, --黄冈晃晃
	-- 5, --荆门双开
	-- 6, --黄石发财晃晃
}

else

--潜江麻将规则
RoomConfig.Rule = {
	[1] = { value = 0x10000, name = "信阳麻将", tex = "quanxin.png", Rule2 = {1,2}},
	[2] = { value = 0x20000, name = "扳倒赢", tex = "yilaidaodi.png", Rule2 = {3,4,5}},
}

RoomConfig.Rule2 = {
	[0] = { value = 0, 			name = ""},       		--不选择
	[1] = { value = 0x40, 		name = "五大嘴,八公嘴"},   		--红中
	[2] = { value = 0x80, 		name = "满堂跑"},   	--四癞杠
}

RoomConfig.Rule3 = {
	[1] = { value = 0x20, 		name = "自摸胡"},   --朝天双大胡
	[2] = { value = 0x80,		name = "点炮输一家"},
	[3] = { value = 0,			name = "点炮输三家"}
}


--玩法带码
RoomConfig.RuleMa = {
	[0] = 0x80, --无码
	[1] = 0x10, --2码
	[2] = 0x8, --4码
	[3] = 0x20, --6码
	[4] = 0x4, --3码
}

--玩法
RoomConfig.PlayRule = {
	1, --黄冈赖子杠
	4, --黄冈晃晃
	5, --荆门双开
	6, --黄石发财晃晃
}

end


-- -- GameOperation
-- RoomConfig.GameOperation = {
-- 	REQUEST_UPDATE_PALYER_DATA  		= 1002,
-- 	MULTI_PLAY_START  					= 1003,			-- 服务器通知客户端，多人战斗开始
-- 	TABLE_ADD_NEW_PLAYER 				= 1004,			-- 服务器通知客户端，桌子上坐上一个新玩家
-- 	PLAYER_LEFT_TABLE  					= 1005,			-- 服务器通知客户端，桌子上有玩家离开
-- 	GAME_TIME_OVER 						= 1006,			-- 服务器通知客户端，本局时间到，游戏结束
-- 	BUY_ITEM 							= 1007,			-- 客户端通知服务器，购买物品
-- 	USE_ITEM 							= 1008,			-- 客户端通知服务器，使用道具
-- 	CHANGE_HEAD 						= 1009,			-- 客户端通知服务器，更换头像
-- 	CONTINUE_GAME 						= 1010,			-- 客户端通知服务器，游戏结束，玩家继续游戏
-- 	BACK_TO_LOBBY 						= 1011,			-- 客户端通知服务器，游戏结束，玩家返回大厅
-- 	BUY_LIFE 							= 1012,			-- 客户端通知服务器，购买单机生命值
-- 	BUY_BIG_GIFT 						= 1013,			-- 客户端通知服务器，购买大礼包
-- 	EXCHANGE_GIFT_CODE 					= 1014,			-- 客户端通知服务器，领取礼品卡
-- 	CHANGENAME 							= 1015,			-- 客户端通知服务器，修改名字
-- 	DEAD_ALIVE 							= 1016,			-- 客户端通知服务器，死了重生
-- 	GEM_EXCHANGE_GOLD 					= 1017,			-- 客户端通知服务器，晶石换金币
-- 	GUIDE_GAME_OVER 					= 1018,			-- 客户端通知服务器第一局新手指引结束

--         												-- 个人信息修改操作ID定义
-- 	CHANGED_PASSWORD 					= 1025,			-- 修改密码
-- 	CHANGED_LOGO     					= 1026,			-- 修改头象
-- 	CHANGED_CANFRIEND 					= 1027,			-- 是否允许加好友


-- 	GOT_GOLD_AUTO_SAVE 					= 1028,			-- 系统救济，赠送金币
-- 	SET_TUOGUAN      					= 1029,			-- 设置托管状态
-- 	ROOM_DISMISS  						= 1030,			-- 房主离开，房间解散
-- 	CHANGEPLAYERACCOUNT  				= 1031,			-- 修改玩家账号
-- 	COMPLETE_ACCOUNT_AND_PASSWORD 		= 1033,			-- 补全帐号和密码
-- 	APPLY_CLOSE_VIP_ROOM 				= 1034,			-- 房主申请解散VIP房间
-- 	AGREE_FRIEND_APPLY_RESULT  			= 1035,			-- 同意好友验证消息
-- 	REJECT_FRIEND_APPLY_RESULT  		= 1036,			-- 拒绝好友验证消息
-- 	COMPLETE_PHONE_NUMBER 				= 1037,			-- 绑定手机号码    
-- 	UPLOAD_CITY_NAME 					= 1038,			-- 上传位置信息
-- 	UPLOAD_RECOMMANDER 					= 1039,
-- 	BUY_DIAMOND  						= 1050
-- }

RoomConfig.GAME_OPERATION_SET_TUOGUAN= 1029			-- 设置托管状态
RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE= 1005			-- 服务器通知客户端，桌子上有玩家离开
RoomConfig.GAME_OPERATION_TABLE_ADD_NEW_PLAYER= 1004			-- 服务器通知客户端，桌子上坐上一个新玩家
RoomConfig.GAME_OPERATION_APPLY_CLOSE_VIP_ROOM= 1034			-- 房主申请解散VIP房间


-- MahjongOperation
RoomConfig.MAHJONG_OPERTAION_PUSH_OVER        					= 0x30000   --[[牌局内结束：推倒牌--]]
RoomConfig.MAHJONG_OPERTAION_TING         						= 0x40    	--听牌

RoomConfig.MAHJONG_OPERTAION_NONE 								= 0x0				--无操作
RoomConfig.MAHJONG_OPERTAION_CHI 								= 0x01				--吃
RoomConfig.MAHJONG_OPERTAION_PENG 								= 0x02				--碰
RoomConfig.MAHJONG_OPERTAION_AN_GANG 							= 0x04				--暗杠
RoomConfig.MAHJONG_OPERTAION_MING_GANG 							= 0x08				--明杠
RoomConfig.MAHJONG_OPERTAION_CHU 								= 0x10				--出牌
RoomConfig.MAHJONG_OPERTAION_HU 								= 0x20				--胡牌
RoomConfig.MAHJONG_OPERTAION_ZIMO 								= 0x30			 	--自摸
-- RoomConfig.MAHJONG_OPERTAION_SELECT_CARD_TING 					= 0x4000000 		--玩家請求聽牌明細
RoomConfig.MAHJONG_OPERTAION_SELECT_CARD_TING 					= 0x4110000 		--玩家請求聽牌明細

RoomConfig.MAHJONG_OPERTAION_CANCEL 							= 0x80				--给玩家提示操作，玩家点取消

RoomConfig.MAHJONG_OPERTAION_OFFLINE 							= 0x100				--断线
RoomConfig.MAHJONG_OPERTAION_ONLINE 							= 0x200				--断线后又上线
RoomConfig.MAHJONG_OPERTAION_AUTO_CHU 							= 0x400				--听牌后自动出牌
RoomConfig.MAHJONG_OPERTAION_GAME_OVER 							= 0x800				--牌局结束

RoomConfig.MAHJONG_OPERTAION_GAME_OVER_CHANGE_TABLE 			= 0x1000			--牌局结束，玩家选择换桌
RoomConfig.MAHJONG_OPERTAION_GAME_OVER_CONTINUE 				= 0x2000			--牌局结束，玩家选择继续开始游戏

RoomConfig.MAHJONG_OPERTAION_SEARCH_VIP_ROOM 					= 0x4000			--客户端通知服务器查找vip房间 **/
RoomConfig.MAHJONG_OPERTAION_ADD_CHU_CARD 						= 0x8000			--玩家打出的牌，没有被人吃碰胡，在打这个牌的玩家面前摆一张牌 **/
RoomConfig.MAHJONG_OPERTAION_SHOW_TABLE_TIPS 					= 0x10000			--[[显示提示在桌面--]]
RoomConfig.MAHJONG_OPERTAION_TIP 								= 0x20000			--[[提示当前谁在操作--]]

RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED 				= 0x40000			--玩家点胡，此局结束显示结果
RoomConfig.MAHJONG_OPERTAION_OVERTIME_AUTO_CHU 					= 0x80000			--超时自动出牌
RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_REMIND 				= 0x100000			--提醒房主续卡
RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_SUCCESSFULLY			= 0x200000			--提醒房主续卡成功
RoomConfig.MAHJONG_OPERTAION_WAITING_OR_CLOSE_VIP				= 0x400000			--VIP房间有人逃跑，是否继续等待
RoomConfig.MAHJONG_OPERTAION_NO_START_CLOSE_VIP  				= 0x800000			--VIP房间超时未开始游戏，房间结束
RoomConfig.MAHJONG_OPERTAION_UPDATE_PLAYER_GOLD   				= 0x1000000			--更新桌上金币
RoomConfig.MAHJONG_OPERTAION_SET_CLEAR_COLOR  					= 0x2000000			--设置缺门花色
RoomConfig.MAHJONG_OPERTAION_HUAN_SAN_ZHANG  					= 0x4000000			--换3张
RoomConfig.MAHJONG_OPERTAION_REMOVE_CARDS	= 0x4000000	-- 通知移除玩家手里的牌（用于抢杠胡的情景下，服务器主动下发）
RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_FAILED 				= 0x8000000			--提醒房主续卡失败

RoomConfig.MAHJONG_OPERTAION_HU_CARD_LIST_UPDATE 				= 0x10000000		--提醒玩家可以胡的牌
RoomConfig.MAHJONG_OPERTAION_BU_GANG 							= 0x20000000		--补杠，自己摸起来，3个已经碰了，再补杠
RoomConfig.MAHJONG_OPERTAION_REMOE_CHU_CARD						= 0x40000000		--玩家打出的牌，被吃碰杠走了
RoomConfig.MAHJONG_OPERTAION_CHA_TING 							= 0x80000000		--查询我听牌

RoomConfig.MAHJONG_OPERTAION_GANG_NOTIFY 						= 0x9914878			--玩家杠的通知，杠不杠的成功，看有没有人抢

RoomConfig.MAHJONG_OPERATION_GET_CLOSE_VIP_ROOM_MSG 			= 0x500000		    --查询关闭房间全量，向服务端请求解散VIP房间状态全量消息操作
RoomConfig.MAHJONG_OPERTAION_POP_LAST 							= 0x70000000		--提示抓尾，云南麻将系列的字段 与 血流的有冲突
RoomConfig.PLAYER_OPERATION_BAIPAI 								= 0x1000000			--玩家摆牌操作
RoomConfig.MAHJONG_OPERTAION_SHUAIPAI 							= 0x1250			--玩家甩牌操作

RoomConfig.PIZI_NOTIFY 											= 0x12000			
RoomConfig.PIZI_NOTIFY_AN 										= 0x13000			

RoomConfig.MAHJONG_OPERTAION_SITDOWN = 0x766000	            --玩家准备
RoomConfig.MAHJONG_OPERTAION_CANCEL_SITDOWN = 0x767000		--玩家取消准备

--子游戏重写这个
RoomConfig.InviteFormat = "%s,%s,房号:%d,局数:%d,%s支付,战个痛快!" 
RoomConfig.InviteFormatSimple = "信阳麻将,房号:%d,局数:%d,%s%s,%s支付"
 
RoomConfig.MaxCreateRoomTips  ="已超过最大上限"

RoomConfig.Ai_Debug = false --是否开启ai数据



