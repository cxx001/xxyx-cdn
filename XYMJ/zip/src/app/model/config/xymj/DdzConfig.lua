cc.exports.DdzConfig = {}
DdzConfig.TableSeatNum = 3 --座位数
DdzConfig.WaitTime = 15 --等待时间

DdzConfig.HandCardNum = 20 --最大手牌数
DdzConfig.BackCardNum = 3 --背牌的数
DdzConfig.MySeat = 1 --我自己的座位

DdzConfig.DownSeat = 2 --下家
DdzConfig.UpSeat = 3 --上家

--手牌状态
DdzConfig.NORMAL = 1 --正常状态
DdzConfig.STAND = 2 --选取状态

DdzConfig.HandCard = 1 --手牌
DdzConfig.OutCard = 2 --出的牌


DdzConfig.AirCraft1 = 6 --飞机
DdzConfig.AirCraft2 = 7 --飞机带单
DdzConfig.AirCraft3 = 8 --飞机带双
DdzConfig.Bomb = 11 --炸弹
DdzConfig.Connect = 4 --连队
DdzConfig.Rocket = 2 --火箭
DdzConfig.Spring =  3--春天
DdzConfig.Company = 5 --顺子

DdzConfig.CARD_SPACE = 5/12 --牌的间隙

DdzConfig.Ai_Debug = false --是否开启ai数据


DdzConfig.GameID = 0x00060000 --斗地主项目的游戏id

-----------------------------游戏状态
DdzConfig.ReadyState = 0   --未开始状态
DdzConfig.PlayingState = 1 --游戏状态
DdzConfig.GameEndState = 2 --结算状态
-----------------------------玩家状态
DdzConfig.PlayerUnready = 0 --未准备
DdzConfig.PlayerReady = 1 --已准备
DdzConfig.PlayerPlaying = 2 --游戏状态
DdzConfig.PlayerShowCard = 3 --亮牌状态


DdzConfig.EMPTY_CARD = 0x55 --空牌
------------------------结果码
DdzConfig.Success = 1 --请求成功
DdzConfig.CanCreateTable = 200 --可以创建或者进入桌子
DdzConfig.HasNiuError = 100 --有牛无牛错误
DdzConfig.CardsError = 101 --牌不匹配错误
DdzConfig.SuitPatternError = 102 --计算牌不是10的倍数
----------------------------------
DdzConfig.REQ_CHECK_TABLE 		= 0xc30003 --检测桌子
DdzConfig.REQ_ENTER_TABLE 		= 0xc30102 --加入桌子
DdzConfig.ACK_ENTER_TABLE 		= 0xa00004 --加入桌子返回

DdzConfig.REQ_CREATE_TABLE 		= 0xc30100 --创建桌子
DdzConfig.ACK_CREATE_TABLE 		= 0xa00002 --创建桌子返回

DdzConfig.NTF_GAME_END 			= 0x000011 --每盘结算
DdzConfig.NTF_GAME_OVER 			= 0x000012 --最终结算

DdzConfig.NTF_PLAYER_ENTER 		= 0x000018 --通知玩家进入房间
 
DdzConfig.REQ_READY 				= 0x000005 --请求准备
DdzConfig.ACK_READY 				= 0x000006 --准备返回
DdzConfig.NTF_READY 				= 0x000007 --通知玩家准备



DdzConfig.REQ_OUT_CARD 			= 0x000009 --出牌
DdzConfig.ACK_OUT_CARD			= 0x000010 --出牌返回
DdzConfig.NTF_OUT_CARD			= 0x000019 --出牌通知

DdzConfig.REQ_TALKING 			= 0x000013 --聊天请求
DdzConfig.ACK_TALKING			= 0x000014 --聊天返回
DdzConfig.NTF_TALKING			= 0x000015 --聊天通知

DdzConfig.REQ_CLOSE_VIP_ROOM  	= 0x000020 --请求解散房间
DdzConfig.ACK_CLOSE_VIP_ROOM	    = 0x000021 --请求解散房间响应
DdzConfig.NTF_CLOSE_VIP_ROOM		= 0x000022 --通知解散房间
DdzConfig.REQ_CLOSE_VIP_RESULT	= 0x000023 --解散房间操作
DdzConfig.NTF_CLOSE_VIP_RESULT	= 0x000024 --解散房间操作通知
DdzConfig.ADDPLAYER_NTF 		= 0xf0000b --玩家加入房间
DdzConfig.REQ_PLAYER_READY		= 0xf01006 --玩家准备
DdzConfig.ACK_PLAYER_READY		= 0xf0009c --玩家准备返回
DdzConfig.REQ_PLAYER_CALL		= 0xf01003 --叫分
DdzConfig.ACK_PLAYER_CALL		= 0xf00206 --叫分返回
DdzConfig.DDZ_SEND_LEISURE_ON_GAME_START = 0xf00003 --開始返回
DdzConfig.SEND_CARD_NTF 		= 0xf00003 --发牌
DdzConfig.ACK_AUTO_OUTCARD		= 0xf00005 --自动出牌
DdzConfig.REQ_AUTO_OUTCARD 		= 0xf01002 --请求托管
DdzConfig.REQ_OUTCARD			= 0xf01004 --出牌
DdzConfig.NTF_OUTCARD        	= 0xf00007	--出牌通知
DdzConfig.NTF_PASS_CARD			= 0xf00008 --过牌通知
DdzConfig.REQ_PASS_CARD 		= 0xf01005 --请求过牌

DdzConfig.NTF_END_CARD			= 0xf00004 --结束

