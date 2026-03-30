#Include libs/basic.ahk
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

; ===== KHỞI TẠO GUI =====
myGui := Gui("-MinimizeBox -MaximizeBox", "INTI PokemmoBot")
myGui.OnEvent("Close", (*) => ExitApp())
myGui.OnEvent("Escape", (*) => ExitApp())
myGui.SetFont("s9", "Segoe UI")

myGui.Add("Picture", "x0 y0 w160 h200", "images/gui_bg.png")
myGui.SetFont("cWhite")
myGui.Add("Text", "x45 y5 w73 h23 +BackgroundTrans", "Shiny Hunt")
myGui.SetFont("s20 Bold cWhite")
ogcTextBattleCount := myGui.Add("Text", "vBattleCount x6 y140 w68 h27 +BackgroundTrans +Center", "00")
ogcTextHealCount := myGui.Add("Text", "vHealCount x86 y140 w68 h30 +BackgroundTrans +Center", "00")
myGui.SetFont("cWhite")
ogcTextLocation := myGui.Add("Text", "vLocation x36 y180 w85 h20 +BackgroundTrans +Center", "Shiny Hunt")
myGui.SetFont("s14 cWhite")
ogcTextStatus := myGui.Add("Text", "vStatus x8 y93 w140 h25 +BackgroundTrans +Center", "Press Q to start")
myGui.SetFont("s14 Bold cWhite")
ogcTextTimerCount := myGui.Add("Text", "vTimerCount x8 y43 w140 h25 +BackgroundTrans +Center", "00:00")
myGui.SetFont("s9", "Segoe UI")
myGui.Show("x911 y308 w158 h200")

; ===== TRẠNG THÁI BOT =====
botState := {
    isRunning: false,
    battleCount: 0,
    healCount: 0,
    status: "Initiating",
    startTime: A_TickCount,
    maxBattlesBeforeHeal: 6
}

global LEGENDARY_LIST := ["Shiny", "disconnected"]

; ===== HOTKEY BẬT/TẮT BOT =====
$q::
{
    if (botState.isRunning) {
        StopBot("Stopped")
    } else {
        if (!WinExist("ahk_class GLFW30")) {
            SetStatus("Error: Game window not found")
            return
        }
        botState.isRunning := true
        botState.startTime := A_TickCount
        carn_pokebot_init()

        SetTimer(UpdateTimer, 1000)
        SetTimer(GuiRefreshTimer, 1000)
        SetTimer(CheckDisconnectedTimer, 3000)
        
        SetTimer(HordeHuntTimer, 500)
    }
}

; ===== HELPER: CẬP NHẬT STATUS VÀ GUI =====
SetStatus(msg) {
    if (botState.HasProp("status"))
        botState.status := msg
    ForceUpdateGui()
}

ForceUpdateGui() {
    try {
        ogcTextStatus.Value := botState.status
        ogcTextBattleCount.Value := Format("{:02d}", botState.battleCount)
        ogcTextHealCount.Value := Format("{:02d}", botState.healCount)
    } catch {
    }
}

GuiRefreshTimer() {
    if (!botState.isRunning)
        return
    static lastStatus := "", lastBattleCount := -1, lastHealCount := -1
    if (botState.status != lastStatus || botState.battleCount != lastBattleCount || botState.healCount != lastHealCount) {
        ForceUpdateGui()
        lastStatus := botState.status
        lastBattleCount := botState.battleCount
        lastHealCount := botState.healCount
    }
}

; ===== HELPER: DỪNG BOT =====
StopBot(reason := "Stopped") {
    botState.isRunning := false
    SetTimer(HordeHuntTimer, 0)
    SetTimer(UpdateTimer, 0)
    SetTimer(GuiRefreshTimer, 0)
    SetTimer(CheckDisconnectedTimer, 0)
    SetStatus(reason)
}

; ===== FOCUS CỬA SỔ GAME =====
EnsureGameFocused() {
    try {
        if (WinActive("ahk_class GLFW30"))
            return true
        if (!WinExist("ahk_class GLFW30")) {
            StopBot("Error: Game window not found")
            return false
        }
        WinActivate("ahk_class GLFW30")
        WinWaitActive("ahk_class GLFW30", , 1)
        SetStatus("Refocused game window")
        return true
    } catch as e {
        SetStatus("Focus error: " . e.Message)
        return false
    }
}

; ===== TIMER: KIỂM TRA NGẮT KẾT NỐI =====
CheckDisconnectedTimer() {
    if (!botState.isRunning)
        return
    try {
        if (detect_strings("disconnected")) {
            SetStatus("Disconnected detected!")
            send_get_request("disconnected")
            StopBot("Stopped — Disconnected")
        }
    } catch {
    }
}


; ===== TIMER: HORDE HUNT =====
HordeHuntTimer() {
    if (!botState.isRunning)
        return

    ; Ngăn timer chồng chéo khi xử lý lâu
    static isBusy := false
    if (isBusy)
        return
    isBusy := true

    try {
        EnsureGameFocused()

        ; Cần hồi phục
        if (botState.battleCount >= botState.maxBattlesBeforeHeal || detect_pp() || detect_hp()) {
            Heal()
            isBusy := false
            return
        }

        SetStatus("Using Sweet Scent...")
        sleep_rand(90, 200)
        send_sweet_scent()

        ; Chờ trận đấu xuất hiện (tối đa 15s)
        SetStatus("Waiting for encounter...")
        battleStarted := false
        loop 15 {
            Sleep(800)
            if (!botState.isRunning) {
                isBusy := false
                return
            }
            if (DetectBattle()) {
                battleStarted := true
                break
            }
        }

        if (battleStarted) {
            FightInit()
        } else {
            SetStatus("No battle found... Retrying")
        }
    } catch as e {
        SetStatus("Hunt error: " . e.Message)
    }

    isBusy := false
}

; ===== KHỞI TẠO TRẬN ĐẤU =====
FightInit() {
    if (!botState.isRunning)
        return
    SetStatus("Entering battle...")

    loop 15 {
        Sleep(1000)
        if (!botState.isRunning)
            return
        if (detect_fight_but()) {
            Fight()
            return
        }
        SetStatus("Waiting for battle button... (" . A_Index . "/15)")
    }
    SetStatus("Battle button not found — skipping")
}

; ===== CHIẾN ĐẤU =====
Fight() {
    if (!botState.isRunning)
        return
    SetStatus("Fighting...")

    try {
        if (detect_shiny()) {
            SetStatus("Shiny found!")
            send_get_request()
            StopBot("⚠ Shiny caught/found!")
            return
        }

        SetStatus("Running...")
        send_run()
        Sleep(2000)
        Quit()
    } catch as e {
        SetStatus("Fight error: " . e.Message)
    }
}

; ===== THOÁT TRẬN ĐẤU =====
Quit() {
    if (!botState.isRunning)
        return

    ; Đợi hoạt ảnh kết thúc kinh nghiệm
    loop 4 {
        if (!DetectBattle())
            break
        Sleep(1000)
    }

    if (!DetectBattle()) {
        botState.battleCount++
        SetStatus("Exiting battle #" . botState.battleCount)
        if (botState.battleCount >= botState.maxBattlesBeforeHeal || detect_pp() || detect_hp()) {
            Heal()
        }
    } else {
        SetStatus("Still in battle, fighting again...")
        Fight()
    }
}

; ===== HỒI PHỤC =====
Heal() {
    if (!botState.isRunning)
        return
    try {
        SetStatus("Teleporting to heal...")
        Sleep(4000)
        SetStatus("Healing...")
        teleport_and_heal()

        botState.healCount++
        botState.battleCount := 0

        SetStatus("Moving back to hunt zone...")
        Sleep(1000)
        randomvar := Random(35, 40)
        walk_down(1)
        walk_left(randomvar)
        walk_up(2)
    } catch as e {
        SetStatus("Heal error: " . e.Message)
    }
}

; ===== TIMER: CẬP NHẬT ĐỒNG HỒ =====
UpdateTimer() {
    if (!botState.isRunning)
        return
    t := Floor((A_TickCount - botState.startTime) / 1000)
    m := Format("{:02d}", Floor(t / 60))
    s := Format("{:02d}", Mod(t, 60))
    ogcTextTimerCount.Value := m ":" s
}

; ===== WRAPPER: PHÁT HIỆN TRẬN ĐẤU =====
DetectBattle() {
    try {
        return detect_battle()
    } catch {
        return false
    }
}
