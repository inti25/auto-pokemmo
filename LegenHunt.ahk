#Include libs/basic.ahk
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

; Khởi tạo GUI
myGui := Gui("-MinimizeBox -MaximizeBox", "INTI PokemmoBot")
myGui.OnEvent("Close", (*) => ExitApp())
myGui.OnEvent("Escape", (*) => ExitApp())
myGui.SetFont("s9", "Segoe UI") ; Gộp lệnh SetFont

; Thêm các thành phần GUI
myGui.Add("Picture", "x0 y0 w160 h200", "images/gui_bg.png")
myGui.SetFont("cWhite")
myGui.Add("Text", "x45 y5 w73 h23 +BackgroundTrans", "Legen Hunt")
myGui.SetFont("s20 Bold cWhite")
ogcTextBattleCount := myGui.Add("Text", "vBattleCount x6 y140 w68 h27 +BackgroundTrans +Center", "00")
ogcTextHealCount := myGui.Add("Text", "vHealCount x86 y140 w68 h30 +BackgroundTrans +Center", "00")
myGui.SetFont("s12 cWhite")
ogcTextLocation := myGui.Add("Text", "vLocation x36 y180 w85 h20 +BackgroundTrans +Center", "Johto")
myGui.SetFont("s14 cWhite")
ogcTextStatus := myGui.Add("Text", "vStatus x8 y93 w140 h25 +BackgroundTrans +Center", "Press Q to start")
myGui.SetFont("s14 Bold cWhite")
ogcTextTimerCount := myGui.Add("Text", "vTimerCount x8 y43 w140 h25 +BackgroundTrans +Center", "00:00")
myGui.SetFont("s9", "Segoe UI") ; Đặt lại font mặc định
myGui.Show("x911 y308 w158 h200")

; Khởi tạo trạng thái bot
botState := { isRunning: false, battleCount: 0, healCount: 0, isBattle: false, shinyBattle: false, status: "Initiating", startTime: A_TickCount, stepCount: 0, direction: true }

; Hotkey để bật/tắt bot
$q::
{
    if (botState.isRunning) {
        botState.isRunning := false
        SetTimer(WalkTimer, 0)
        SetTimer(UpdateTimer, 0)
        SetTimer(GuiStatusUpdateTimer, 0)
        SetTimer(CheckDisconnectedTimer, 0)
        botState.status := "Stopped"
        UpdateGui()
    } else {
        if (!WinExist("ahk_class GLFW30")) {
            botState.status := "Error: Game window not found"
            UpdateGui()
            return
        }
        botState.isRunning := true
        botState.startTime := A_TickCount
        SetTimer(WalkTimer, 500)
        SetTimer(UpdateTimer, 1000)
        SetTimer(GuiStatusUpdateTimer, 1000)
        SetTimer(CheckDisconnectedTimer, 3000)
    }
}

; Hàm đảm bảo cửa sổ game được focus
EnsureGameFocused()
{
    try {
        if (!WinActive("ahk_class GLFW30")) {
            if (WinExist("ahk_class GLFW30")) {
                WinActivate("ahk_class GLFW30")
                WinWaitActive("ahk_class GLFW30",, 1) ; Chờ tối đa 1 giây để focus
                botState.status := "refocused"
                UpdateGui()
            } else {
                botState.status := "Error: Game window not found"
                botState.isRunning := false
                SetTimer(WalkTimer, 0)
                SetTimer(UpdateTimer, 0)
                SetTimer(GuiStatusUpdateTimer, 0)
                SetTimer(CheckDisconnectedTimer, 0)
                UpdateGui()
            }
        }
    } catch as e {
        botState.status := "Error in focusing game: " . e.Message
        UpdateGui()
    }
}

; Hàm di chuyển
WalkTimer()
{
    if (!botState.isRunning)
        return
    try {
        botState.status := "Walking..."
        ignore_headbut()
        if (botState.direction) {
            walk_down(1)
        } else {
            walk_up(1)
        }
        botState.stepCount++
        if (botState.stepCount > 3) {
            botState.direction := !botState.direction
            botState.stepCount := 0
        }
        if (DetectBattle()) {
            FightInit()
        }
    } catch as e {
        botState.status := "Error: " . e.Message
        UpdateGui()
    }
}

; Khởi tạo trận đấu
FightInit()
{
    if (!botState.isRunning)
        return
    botState.status := "Entering battle..."
    UpdateGui()
    maxAttempts := 10
    loop maxAttempts {
        Sleep(1000)
        if (detect_fight_but()) {
            Fight()
            return
        }
        botState.status := "Waiting for battle button..."
        UpdateGui()
    }
    botState.status := "Battle button not found"
    UpdateGui()
}

; Hàm chiến đấu
Fight()
{
    if (!botState.isRunning)
        return
    botState.status := "Fighting"
    UpdateGui()
    try {
        legendaryList := ["Raikou", "Entei", "Suicune", "Articuno", "Zapdos", "Moltres", "Shiny", "disconnected"]
        stringDetected := detect_run_default(legendaryList)
        if (stringDetected) {
            botState.status := "Special Pokémon..."
            UpdateGui()
            send_get_request(stringDetected)
            walk_down(1)
        } else {
            send_run()
            Sleep(1000)
        }
        Quit()
    } catch as e {
        botState.status := "Error in fight: " . e.Message
        UpdateGui()
    }
}

; Thoát trận đấu
Quit()
{
    if (!botState.isRunning)
        return
    if (!DetectBattle()) {
        botState.status := "Exiting battle..."
        botState.battleCount++
        UpdateGui()
        if (detect_pp() || detect_hp()) {
            Heal()
        }
    } else {
        Fight()
    }
}

; Hàm hồi phục
Heal()
{
    if (!botState.isRunning)
        return
    try {
        botState.status := "Teleport"
        UpdateGui()
        Sleep(1000)
        botState.status := "Healing"
        UpdateGui()
        teleport_and_heal()
        botState.healCount++
        botState.status := "Moving..."
        UpdateGui()
        Sleep(1000)
        randomvar := Random(35, 40)
        walk_down(1)
        walk_left(randomvar)
        walk_up(2)
    } catch as e {
        botState.status := "Error in heal: " . e.Message
        UpdateGui()
    }
}

; Cập nhật thời gian
UpdateTimer()
{
    if (!botState.isRunning)
        return
    EnsureGameFocused()
    t := Floor((A_TickCount - botState.startTime) / 1000)
    m := Format("{:02d}", Floor(t / 60))
    r := Format("{:02d}", Mod(t, 60))
    ogcTextTimerCount.Value := m ":" r
}

; Cập nhật trạng thái GUI
GuiStatusUpdateTimer()
{
    if (!botState.isRunning)
        return
    static lastStatus := "", lastBattleCount := 0, lastHealCount := 0
    if (botState.status != lastStatus || botState.battleCount != lastBattleCount || botState.healCount != lastHealCount) {
        ogcTextStatus.Value := botState.status
        ogcTextBattleCount.Value := botState.battleCount
        ogcTextHealCount.Value := botState.healCount
        lastStatus := botState.status
        lastBattleCount := botState.battleCount
        lastHealCount := botState.healCount
    }
}

; Kiểm tra ngắt kết nối
CheckDisconnectedTimer()
{
    if (!botState.isRunning)
        return
    try {
        if (detect_strings("disconnected")) {
            botState.status := "Disconnected detected"
            UpdateGui()
            send_get_request()
        }
    } catch as e {
        botState.status := "Error in disconnect check: " . e.Message
        UpdateGui()
    }
}

; Hàm tiện ích để cập nhật GUI
UpdateGui()
{
    GuiStatusUpdateTimer()
}

; Hàm giả định để phát hiện trận đấu
DetectBattle()
{
    try {
        return detect_battle(1)
    } catch {
        return false
    }
}