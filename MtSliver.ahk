#Include libs/basic.ahk
#SingleInstance Force

SetWorkingDir(A_ScriptDir)

; Khởi tạo GUI
myGui := Gui("-MinimizeBox -MaximizeBox", "INTI PokemmoBot")
myGui.OnEvent("Close", (*) => ExitApp())
myGui.OnEvent("Escape", (*) => ExitApp())
myGui.SetFont("s9", "Segoe UI")

myGui.Add("Picture", "x0 y0 w160 h200", "images/gui_bg.png")
myGui.SetFont("cWhite")
myGui.Add("Text", "x45 y5 w73 h23 +BackgroundTrans", "Speed EVs")
myGui.SetFont("s20 Bold cWhite")
ogcTextBattleCount := myGui.Add("Text", "vBattleCount x6 y140 w68 h27 +BackgroundTrans +Center", "00")
ogcTextHealCount := myGui.Add("Text", "vHealCount x86 y140 w68 h30 +BackgroundTrans +Center", "00")
myGui.SetFont("cWhite")
ogcTextLocation := myGui.Add("Text", "vLocation x36 y180 w85 h20 +BackgroundTrans +Center", "Mt. Sliver")
myGui.SetFont("s14 cWhite")
ogcTextStatus := myGui.Add("Text", "vStatus x8 y93 w140 h25 +BackgroundTrans +Center", "Press Q to start")
myGui.SetFont("s14 Bold cWhite")
ogcTextTimerCount := myGui.Add("Text", "vTimerCount x8 y43 w140 h25 +BackgroundTrans +Center", "00:00")
myGui.SetFont("s9", "Segoe UI")
myGui.Show("x911 y308 w158 h200")

; Khởi tạo trạng thái bot
botState := {
    isRunning: false,
    battleCount: 0,
    healCount: 0,
    fightOption: 0,
    status: "Initiating",
    startTime: A_TickCount,
    maxBattlesBeforeHeal: 6
}

; Hotkey bật/tắt bot
$q::
{
    if (botState.isRunning) {
        StopBot()
    } else {
        if (!WinExist("ahk_class GLFW30")) {
            botState.status := "Error: Game window not found"
            UpdateGui()
            return
        }
        botState.isRunning := true
        botState.startTime := A_TickCount
        carn_pokebot_init()
        SetTimer(FishingTimer, 500)
        SetTimer(UpdateTimer, 1000)
        SetTimer(GuiStatusUpdateTimer, 1000)
    }
}

; Hàm dừng bot
StopBot() {
    botState.isRunning := false
    SetTimer(FishingTimer, 0)
    SetTimer(UpdateTimer, 0)
    SetTimer(GuiStatusUpdateTimer, 0)
    botState.status := "Stopped"
    UpdateGui()
}

; Đảm bảo cửa sổ game được focus
EnsureGameFocused() {
    try {
        if (!WinActive("ahk_class GLFW30")) {
            if (WinExist("ahk_class GLFW30")) {
                WinActivate("ahk_class GLFW30")
                WinWaitActive("ahk_class GLFW30",, 1)
                botState.status := "Game window refocused"
                UpdateGui()
            } else {
                botState.status := "Error: Game window not found"
                StopBot()
            }
        }
    } catch as e {
        botState.status := "Error in focusing game: " . e.Message
        UpdateGui()
    }
}

; Hàm câu cá
FishingTimer() {
    if (!botState.isRunning)
        return
    try {
        EnsureGameFocused()
        botState.status := "Using Sweet Scent..."
        sleep_rand(90, 200)
        send_sweet_scent()
        if (DetectBattle()) {
            FightInit()
        }
    } catch as e {
        botState.status := "Error in fishing: " . e.Message
        UpdateGui()
    }
}

; Khởi tạo trận đấu
FightInit() {
    if (!botState.isRunning)
        return
    try {
        botState.status := "Entering battle..."
        UpdateGui()
        maxAttempts := 10
        loop maxAttempts {
            if (!DetectBattle()) {
                return
            }
            EnsureGameFocused()
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
    } catch as e {
        botState.status := "Error in fight init: " . e.Message
        UpdateGui()
    }
}

; Hàm chiến đấu
Fight() {
    if (!botState.isRunning)
        return
    try {
        EnsureGameFocused()
        botState.status := "Fighting"
        botState.fightOption := 0
        UpdateGui()

        ; Kiểm tra Pokémon không mong muốn hoặc Shiny
        if (detect_run_default(["Tranquill", "Combee", "Sunkern"])) {
            botState.fightOption := 1
        } else if (detect_shiny()) {
            botState.fightOption := 2
        }

        ; Thực hiện hành động dựa trên fightOption
        if (botState.fightOption = 0) {
            ; Gửi Yes để chiến đấu
            loop 3 {
                send_yes()
                sleep_rand(400, 1200)
                if (!DetectBattle()) {
                    break
                }
            }
            Sleep(6000)
        } else if (botState.fightOption = 1) {
            botState.status := "Running..."
            UpdateGui()
            send_run()
            Sleep(2000)
        } else if (botState.fightOption = 2) {
            botState.status := "Catching Shiny..."
            UpdateGui()
            ; send_catch()
            send_get_request()
            Sleep(2000)
        }
        Quit()
    } catch as e {
        botState.status := "Error in fight: " . e.Message
        UpdateGui()
    }
}

; Thoát trận đấu
Quit() {
    if (!botState.isRunning)
        return
    try {
        EnsureGameFocused()
        if (!DetectBattle()) {
            botState.status := "Exiting battle..."
            botState.battleCount++
            UpdateGui()
            if (detect_pp() || detect_hp() || botState.battleCount >= botState.maxBattlesBeforeHeal) {
                Heal()
            }
        } else {
            Fight()
        }
    } catch as e {
        botState.status := "Error in quit: " . e.Message
        UpdateGui()
    }
}

; Hồi phục
Heal() {
    if (!botState.isRunning)
        return
    try {
        EnsureGameFocused()
        botState.status := "Teleporting..."
        UpdateGui()
        Sleep(4000) ; Giảm thời gian chờ
        botState.status := "Healing..."
        teleport_and_heal()
        botState.healCount++
        botState.battleCount := 0
        botState.status := "Moving..."
        UpdateGui()
        Sleep(1000)
        randomvar := Random(5, 10)
        walk_left(randomvar)
        walk_up(2)
    } catch as e {
        botState.status := "Error in heal: " . e.Message
        UpdateGui()
    }
}

; Cập nhật thời gian
UpdateTimer() {
    if (!botState.isRunning)
        return
    t := Floor((A_TickCount - botState.startTime) / 1000)
    m := Format("{:02d}", Floor(t / 60))
    r := Format("{:02d}", Mod(t, 60))
    ogcTextTimerCount.Value := m ":" r
}

; Cập nhật GUI
GuiStatusUpdateTimer() {
    if (!botState.isRunning)
        return
    static lastStatus := "", lastBattleCount := 0, lastHealCount := 0
    if (botState.status != lastStatus || botState.battleCount != lastBattleCount || botState.healCount != lastHealCount) {
        EnsureGameFocused()
        ogcTextStatus.Value := botState.status
        ogcTextBattleCount.Value := botState.battleCount
        ogcTextHealCount.Value := botState.healCount
        lastStatus := botState.status
        lastBattleCount := botState.battleCount
        lastHealCount := botState.healCount
    }
}

; Phát hiện trận đấu
DetectBattle() {
    try {
        return detect_battle()
    } catch {
        return false
    }
}

; Cập nhật GUI
UpdateGui() {
    GuiStatusUpdateTimer()
}