cc.exports.NiuNiuConfig = {}
NiuNiuConfig.TableSeatNum = 5 --座位数
NiuNiuConfig.WaitTime = 15 --等待时间
NiuNiuConfig.HandCards = 5 --最大手牌

NiuNiuConfig.MySeat = 1 --我自己的座位

NiuNiuConfig.Ai_Debug = false --是否开启ai数据

NiuNiuConfig.GameID = 0x30000 --牛牛项目的游戏id

-----------------------------游戏状态
NiuNiuConfig.ReadyState = 0   --未开始状态
NiuNiuConfig.PlayingState = 1 --游戏状态
NiuNiuConfig.GameEndState = 2 --结算状态
-----------------------------玩家状态
NiuNiuConfig.PlayerUnready = 0 --未准备
NiuNiuConfig.PlayerReady = 1 --已准备
NiuNiuConfig.PlayerPlaying = 2 --游戏状态
NiuNiuConfig.PlayerShowCard = 3 --亮牌状态
------------------------结果码
NiuNiuConfig.Success = 1 --请求成功
NiuNiuConfig.CanCreateTable = 200 --可以创建或者进入桌子
NiuNiuConfig.HasNiuError = 100 --有牛无牛错误
NiuNiuConfig.CardsError = 101 --牌不匹配错误
NiuNiuConfig.SuitPatternError = 102 --计算牌不是10的倍数
NiuNiuConfig.CloseRoom = 252  --不可以频繁请求解散房间
----------------------------------
NiuNiuConfig.REQ_CHECK_TABLE 		= 0xc30003 --检测桌子
NiuNiuConfig.REQ_ENTER_TABLE 		= 0xc30102 --加入桌子
NiuNiuConfig.ACK_ENTER_TABLE 		= 0xa00004 --加入桌子返回

NiuNiuConfig.REQ_CREATE_TABLE 		= 0xc30100 --创建桌子
NiuNiuConfig.ACK_CREATE_TABLE 		= 0xa00002 --创建桌子返回

NiuNiuConfig.NTF_GAME_END 			= 0x000011 --每盘结算
NiuNiuConfig.NTF_GAME_OVER 			= 0x000012 --最终结算

NiuNiuConfig.NTF_PLAYER_ENTER 		= 0x000018 --通知玩家进入房间
 
NiuNiuConfig.REQ_READY 				= 0x000005 --请求准备
NiuNiuConfig.ACK_READY 				= 0x000006 --准备返回
NiuNiuConfig.NTF_READY 				= 0x000007 --通知玩家准备

NiuNiuConfig.SEND_CARD_NTF 			= 0x000008 --发牌

NiuNiuConfig.REQ_OUT_CARD 			= 0x000009 --出牌
NiuNiuConfig.ACK_OUT_CARD			= 0x000010 --出牌返回
NiuNiuConfig.NTF_OUT_CARD			= 0x000019 --出牌通知

NiuNiuConfig.REQ_TALKING 			= 0x000013 --聊天请求
NiuNiuConfig.ACK_TALKING			= 0x000014 --聊天返回
NiuNiuConfig.NTF_TALKING			= 0x000015 --聊天通知

NiuNiuConfig.REQ_CLOSE_VIP_ROOM  	= 0x000020 --请求解散房间
NiuNiuConfig.ACK_CLOSE_VIP_ROOM	    = 0x000021 --请求解散房间响应
NiuNiuConfig.NTF_CLOSE_VIP_ROOM		= 0x000022 --通知解散房间
NiuNiuConfig.REQ_CLOSE_VIP_RESULT	= 0x000023 --解散房间操作
NiuNiuConfig.NTF_CLOSE_VIP_RESULT	= 0x000024 --解散房间操作通知