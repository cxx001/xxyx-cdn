print("part config is xymj")

-- hook
-- 合并自己的语言包文件,如果有的话
package.loaded["app.module.language.xymj.string_zh"] = nil
pcall(require,"app.module.language.xymj.string_zh")

package.loaded["app.model.config.xymj.RoomConfig"] = nil
pcall(require,"app.model.config.xymj.RoomConfig")

module = (function()
	local origin = module
	return function(name, ...)
		cc.exports[name] = {}
		package.loaded[name] = nil
		return origin(name, ...)
	end
end)()

local part_base = "app.part.xymj."
-- local part_base = "app.part."
PartConfig.prePath = ".xymj"

local xymj_part_config = { --组件配置
	AdPart = part_base .. "ad.AdPart",
	AddRoomPart =part_base ..  "addroom.AddRoomPart",
	-- BroadcastPart = part_base .. "broadcast.BroadcastPart",
	CardPart = part_base .."mj3dcard.XYCardPart",
	NormalCardPart = part_base .."mjcard.XYCardPart",
	CardOptPart = part_base .."mjcardopt.CardOptPart",
	ChatPart = part_base .."chat.ChatPart",
	CreateRoomPart = part_base .."createroom.XYCreateRoomPart",
	-- GameEndPart =part_base .. "mjgameend.XYGameEndPart",
	GameEndPart =part_base .. "newmjgameend.XYGameEndPart",

	HelpPart = part_base .."help.HelpPart",
	LoadingPart =part_base .. "loading.LoadingPart",
	LobbyPart = part_base .."lobby.LobbyPart",
	NoticePart = part_base .."notice.NoticePart",
	PurchasePart = part_base .."purchase.PurchasePart",
	RecordPart = part_base .."record.RecordPart",
	SettingsPart = part_base .."settings.SettingsPart",
	RoomSettingPart = part_base .. "roomsetting.RoomSettingPart",
	SmallUserInfoPart  = part_base .."smalluserinfo.SmallUserInfoPart",
	TablePart =part_base .. "mj3dtable.XYTablePart",
	NormalTablePart =part_base .. "mjtable.XYTablePart",
	TipsPart = part_base .."tips.TipsPart",
	UpdatePart = part_base .."update.UpdatePart",
	UserInfoPart = part_base .."userinfo.UserInfoPart",
	-- VipOverPart =part_base .. "mjvipover.VipOverPart",
	VipOverPart =part_base .. "newmjvipover.YNVipOverPart",
	
	WifiAndNetPart = part_base .."newwifiandnet.WifiAndNetPart",
	ReferrerPart =part_base .. "referrer.ReferrerPart",
	ReadyPart = part_base .."ready3d.XYReadyPart",
	NormalReadyPart = part_base .."ready.XYReadyPart",
	DissolvePart = part_base .."dissolve.DissolvePart",
	WebViewPart = part_base .. "webview.WebViewPart",
	GpsPart = part_base .. "gps.GpsPart",
	GpsTipPart = part_base .. "gpstip.GpsTipPart",
	NaozhuangPart = part_base .. "naozhuang.NaozhuangPart",
    BattlePart = part_base .. "record.BattlePart",
    BattleDetailPart = part_base .. 'record.BattleDetailPart',
    OtherBattlePart = part_base .. 'record.OtherBattlePart',
    RecordStopPart = part_base .. 'record.RecordStopPart',
    RecordMainPart = part_base .. 'mjtable.RecordMainPart',
    RoomListPart = part_base .. "roomlist.RoomListPart",
    SharePart = part_base .. "sharepart.SharePart",
    XiazuiPart = part_base .. "xiazui.XiazuiPart",
    RoomMenuPart = part_base.."roommenu.RoomMenuPart",
    RedpacketMgrPart = part_base .. "redpacketmgr.RedpacketMgrPart",
    RedpacketTipsPart =	part_base .. 'redpacket.RedpacketTipsPart',	--红包展示组件
    RewardTipsPart = part_base .. 'rewardtips.RewardTipsPart',	--红包奖励展示组件
    PlayWayPart = part_base .. 'playWay.PlayWayPart',
    SelectMatchPart = part_base .. 'mjmatch.select.SelectMatchPart',
    DetailMatchPart = part_base .. 'mjmatch.detail.DetailMatchPart',
    MatchOverPart = part_base .. 'mjmatch.matchOver.MatchOverPart',
    WinMatchPart = part_base .. 'mjmatch.winMatch.WinMatchPart',
    ReadyMatchPart = part_base .. 'mjmatch.readyMatch.ReadyMatchPart',
    MatchMainPart = part_base .. 'mjtable.MatchMainPart',    
    LoseMatchPart = part_base .. 'mjmatch.loseMatch.LoseMatchPart',
    PayChoseTipPart = part_base .. 'newpayChoseTip.PayChoseTipPart',
    TeamVoicePart = part_base .. 'teamVoice.TeamVoicePart',
    DuihuanPart = part_base .. 'duihuan.DuihuanPart',
    DuiHuanRecordPart = part_base .. 'duihuanrecord.DuiHuanRecordPart',
    DuihuanTipsPart = part_base .. 'duihuantips.DuihuanTipsPart',
    TelNumInputPart = part_base .. 'telnuminput.TelNumInputPart',
    ThrowCardPart = part_base .. 'throwcard.ThrowCardPart',
    NtfUploadLogPart = part_base .."fankui.NtfUploadLogPart",
    PayContinuePart = part_base .."payContinueTip.PayContinuePart",
}


if PartConfig then
	-- for i,v in pairs(xymj_layer_config) do
	-- 	PartConfig.view[i] = v 	
	-- end

	for i,v in pairs(xymj_part_config) do
		PartConfig.part[i] = v
	end
else
	cc.exports.PartConfig = {}
	--PartConfig.view = xymj_layer_config
end

package.loaded["app.part.xymj.lobby.res.LobbyScene-UI"] = nil
require("app.part.xymj.lobby.res.LobbyScene-UI")
package.loaded["app.part.xymj.lobby.LobbyScene"] = nil
require("app.part.xymj.lobby.LobbyScene")
package.loaded["app.part.xymj.lobby.LobbyPart"] = nil
require("app.part.xymj.lobby.LobbyPart")

local gameVersionFile = "app.model.config.xymj.gameversion"
package.loaded[gameVersionFile] = nil --重新加载gameVersionFile
require(gameVersionFile)

cc.exports.SingleGame = false --是否是单品游戏