cc.exports.SocketConfig = {}

SocketConfig.ROOM_ID                                        = 2004                          --默认昭通摆牌
SocketConfig.IS_SEQ                                         = true                          --双序号开关 true 开 false关

SocketConfig.GAME_ID                                        = LOBBY_GAME_ID             
SocketConfig.PURCHASE_URL                                   = "api.xiaoxiongyouxi.com"      --充值域名

SocketConfig.MSG_GAME_SEND_SCROLL_MES                       = 0xc30015                      --跑马灯协议

SocketConfig.MSG_GET_VIP_ROOM_RECORD                        = 0xc30063                      --查询玩家vip战绩
SocketConfig.MSG_GET_VIP_ROOM_RECORD_ACK                    = 0xc30064                      --vip战绩消息列表

SocketConfig.MSG_SYSTEM_NOTIFY_MSG                          = 0xc30500                      --系统消息

SocketConfig.MSG_CLOSE_VIP_TABLE_ACK                        = 0xc30086                      --关闭房间ack
SocketConfig.MSG_NOTIFY_SEQ_TO_CLIENT_MSG                   = 0xc30087                      --收到刷新序号消息，向服务器获取解散房间状态

SocketConfig.MSG_REQUEST_BUY_DAOJU                          = 0xc30071                      --流水查询
SocketConfig.MSG_GAME_GET_PLAYER_DIAMOND_LOG_ACK            = 0xC3025A                      --流水查询ack
SocketConfig.SEND_PLAYER_CMD_GET_MY_SEND_DIAMOND_LOG        = 0x17676                       --流水查询 支出
SocketConfig.SEND_PLAYER_CMD_GET_MY_ADD_DIAMOND_LOG         = 0x17677                       --流水查询 收入
SocketConfig.SEND_PLAYER_CMD_GET_MY_SUB_DIAMOND_LOG         = 0x17678                       --流水查询 总收入

SocketConfig.MSG_GET_IP_LIST_CONFIG_REQ                     = 0x01000003                    --线路切换发送
SocketConfig.MSG_GET_IP_LIST_CONFIG_RSP                     = 0x01000004                    --线路切换ack

SocketConfig.MSG_GET_GAME_CONFIG_REQ                        = 0x01000007                    --申请代理
SocketConfig.MSG_GET_GAME_CONFIG_RSP                        = 0x01000008                    --申请代理ack

SocketConfig.MSG_GET_CHECK_UPDATE_REQ			    = 0x01000011		    --更新检测信息请求
SocketConfig.MSG_GET_CHECK_UPDATE_RSP			    = 0x01000012		    --更新检测信息回应


SocketConfig.MSG_DDZ_SEND_LEISURE_SAFE_AREA_MATCH_SUCCESS   = 0xf0000c                      --分配成功（斗地主用）
SocketConfig.MSG_DDZ_SEND_RECONNECT_TABLE                   = 0xf0000f                      --断线重连（斗地主用）
SocketConfig.MSG_DDZ_SEND_LEISURE_OUT_LEISURE               = 0xf01007                      --退出游戏（斗地主用）

SocketConfig.MSG_GET_PLAYERS_GPS_INFO                       = 0xc30503                      --发送GPS位置
SocketConfig.MSG_GET_PLAYERS_GPS_INFO_ACK                   = 0xc30504                      --GPS ack



-- add from MsgDef

-- 没有搜到
SocketConfig.MSG_NONE                                       = 0x0   
SocketConfig.MSG_HEART_BEATING                              = 0xa10001                      --心跳包
SocketConfig.MSG_HEART_BEATING_ACK                          = 0xa10002                      --心跳包回复

SocketConfig.MSG_GAME_LOGIN                                 = 0xc30001  
SocketConfig.MSG_GAME_LOGIN_ACK                             = 0xc30023  

-- 没有搜到
SocketConfig.MSG_LINK_VALIDATION                            = 0xa10003                      --目前没有用到
SocketConfig.MSG_LINK_VALIDATION_ACK                        = 0xa10004                      --目前没有用到

SocketConfig.MSG_GAME_UPDATE_PLAYER_PROPERTY                = 0xc30002                      --更新玩家信息

SocketConfig.MSG_CREATE_VIP_ROOM                            = 0xc30100                      --创建vip房间         回复 0xc30004
SocketConfig.MSG_ENTER_VIP_ROOM                             = 0xc30102                      --请求进入VIP房间     回复 0xc30004
SocketConfig.MSG_REQUEST_START_GAME                         = 0xc30003                      --请求开始游戏        回复 0xc30004
SocketConfig.MSG_REQUEST_START_GAME_ACK                     = 0xc30004                      --请求开始游戏回复
    
SocketConfig.MSG_PLAYER_OPERATION_NTF                       = 0xc30061                      --玩家操作通知命令,提醒玩家进行操作
SocketConfig.MSG_PLAYER_OPERATION                           = 0xc30062                      --玩家操作命令

SocketConfig.MSG_GAME_OPERATION                             = 0xc30008  
SocketConfig.MSG_GAME_OPERATION_ACK                         = 0xc30009  

SocketConfig.MSG_GAME_START                                 = 0xc30060                      -- 牌局开始

SocketConfig.MSG_POST_USER_INFO                             = 0xc30067  
SocketConfig.MSG_POST_USER_INFO_ACK                         = 0xc30068  

SocketConfig.MSG_GAME_OVER_ACK                              = 0xc3000d                      --游戏结束通知
SocketConfig.MSG_GAME_VIP_ROOM_CLOSE                        = 0xc30200                      --解散房间通知 
SocketConfig.MSG_GAME_OTHERLOGIN_ACK                        = 0xc30205                      --异地登录
SocketConfig.MSG_GET_PATCH_VESION                           = 0x01000005                    --获取版本更新信息
SocketConfig.MSG_GET_PATCH_VESION_ACK                       = 0x01000006                    --获取版本更新信息回复

SocketConfig.MSG_TALKING_IN_GAME                            = 0xc30300                      --聊天消息

SocketConfig.MSG_GET_GAME_LIST_CONFIG_REQ                   = 0x01000001                    --C2S 合辑获取游戏列表
SocketConfig.MSG_GET_GAME_LIST_CONFIG_RSP                   = 0x01000002                    --S2C 合辑获取游戏列表
SocketConfig.MSG_GET_LUNBOTU_REQ                            = 0x0100000b                    --C2S 获取轮播图信息
SocketConfig.MSG_GET_LUNBOTU_RSP                            = 0x0100000c                    --C2C 获取轮播图信息


SocketConfig.MSG_REQUEST_MYTABLE_LIST_MSG = 0xc30089 --群主查询当前代开房记录
SocketConfig.MSG_REQUEST_MYTABLE_LIST_MSG_ACK = 0xc30090;

SocketConfig.MSG_REQUEST_HISTORYTABLE_LIST_MSG = 0xc30091 --群主查询历史代开房记录
SocketConfig.MSG_REQUEST_HISTORYTABLE_LIST_MSG_ACK = 0xc30092; 


-- add from MsgDef
-- result字段
SocketConfig.MsgResult = { --
    CMD_EXE_OK                              = 0,    
    CMD_EXE_FAILED                          = 1000, 
    WRONG_PASSWORD                          = 1001, 
    FANGKIA_NOT_FOUND                       = 1100,      -- 房卡不足
    GOLD_LOW_THAN_MIN_LIMIT                 = 1101,      -- 金币低于下限
    GOLD_HIGH_THAN_MAX_LIMIT                = 1102,      -- 金币超过上限
    CAN_ENTER_VIP_ROOM                      = 1103,      -- 可以进入VIP房间
    VIP_TABLE_IS_FULL                       = 1104,      -- vip桌子已经满座了
    VIP_TABLE_IS_GAME_OVER                  = 1105,      -- VIP桌子已经结束了
    IS_PLAYING_CAN_NOT_ENTER_ROOM           = 1106,      -- 正在游戏中不能进入其他房间

    TODAY_GAME_RECORD_OUT_LIMIT_IN_ROOM     = 1200,      -- 今日输赢超过房间上限
    TODAY_GAME_RECORD_OUT_LIMIT_IN_GAME     = 1201,      -- 今日输赢超过游戏上限

    --VIP_TABLE_NOT_FOUND                     = 1300,      -- 桌子未找到
    VIP_TABLE_ASK_OK                        = 2000,      -- 查询房间返回
    GROUP_CREATEROOM                        = 1302,      --房主创建房间
    VIP_TABLE_KAIFANG_NUM_LIMIT             = 1303, --群主代开房个数达到上限
    VIP_TABLE_NOT_FOUND                     = 1300,      -- 桌子未找到
    USERID_ERROR                            = 1400,      -- 用户不存在
    VIP_TABLE_NOT_JOIN                      = 1500       -- 桌子不容许加入
}

-- add from MsgDef
-- 胡
SocketConfig.MahjongHuCode = {
    DIAN_PAO                = 0x0002,             -- 点炮
    MYSELF_ZHUANG_JIA       = 0x0004,             -- 自己是不是庄家
    ZI_MO                   = 0x0008,             -- 自摸
    QIANG_GANG_HU           = 0x010,              -- 抢杠胡
    HUA_ZHU                 = 0x020,              -- 花猪
    DAI_GEN                 = 0x040,              -- 有四张一样的在手里，胡牌的时候，不包括杠
    CHA_HUA_ZHU             = 0x080,              -- 查花猪
    TING                    = 0x0100,             -- 是否听牌
    TARGET_ZHUANG_JIA       = 0x0200,             -- 输赢的对方是庄家
    DAI_YAO_JIU             = 0x00400,            -- 带幺九
    QINGYISE                = 0x00800,            -- 清一色
    JIN_GOU_GOU             = 0x01000,            -- 金钩钓，玩家胡牌时，其他牌都被用作碰牌、杠牌；手牌中只剩下唯一的一张牌，不计对对胡。
    LONG_QI_DUI             = 0x02000,            -- 龙七对，玩家手牌为暗七对牌型，没有碰过或者杠过，并且有四张牌是一样的
    JIANG_JIN_GOU_GOU       = 0x04000,            -- 将金钩钓,指金钩钓里手牌、碰牌和杠牌的牌必须是2、5、8。
    PENG_PENG_HU            = 0x08000,            -- 碰碰胡
    SHANG_PAO               = 0x10000,            -- 杠上炮
    QIXIAODUI               = 0x20000,            -- 七小对
    SHI_BA_LUO_HAN          = 0x40000,            -- 十八罗汉
    SHANG_KAI_HUA           = 0x80000,            -- 杠上花
    WIN                     = 0x100000,           -- 赢
    LOSE                    = 0x200000,           -- 输
    TIAN_HU                 = 0x400000,           -- 天胡
    DI_HU                   = 0x800000,           -- 地胡
    CHA_DA_JIAO             = 0x1000000,          -- 查大叫
    LIU_JU                  = 0x2000000,          -- 流局
    DIAN_PAO_HU             = 0x4000000,          -- 点炮胡
    PING_HU_ZI_MO           = 0x8000000,          -- 平胡自摸加1番
    PING_HU                 = 0x10000000,         -- 平胡
    DIAN_GANG               = 0x20000000,         -- 点杠
}
