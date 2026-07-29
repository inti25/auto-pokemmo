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
myGui.Add("Text", "x45 y5 w73 h23 +BackgroundTrans", "Legen Hunt")
myGui.SetFont("s20 Bold cWhite")
ogcTextBattleCount := myGui.Add("Text", "vBattleCount x6  y140 w68 h27 +BackgroundTrans +Center", "00")
ogcTextHealCount := myGui.Add("Text", "vHealCount   x86 y140 w68 h30 +BackgroundTrans +Center", "00")
myGui.SetFont("s12 cWhite")
ogcTextLocation := myGui.Add("Text", "vLocation    x36 y180 w85 h20 +BackgroundTrans +Center", "Johto")
myGui.SetFont("s14 cWhite")
ogcTextStatus := myGui.Add("Text", "vStatus      x8  y93  w140 h25 +BackgroundTrans +Center", "Press Q to start")
myGui.SetFont("s14 Bold cWhite")
ogcTextTimerCount := myGui.Add("Text", "vTimerCount  x8  y43  w140 h25 +BackgroundTrans +Center", "00:00")
myGui.SetFont("s9 cBlack", "Segoe UI")
ogcDirCombo := myGui.Add("DropDownList", "vRunDirection x40 y180 w80 Choose1", ["Ngang", "Dọc"])

; Đọc vị trí đã lưu, dùng mặc định nếu chưa có
guiPos := LoadGuiPos()
myGui.Show("x" guiPos.x " y" guiPos.y " w158 h200")
; Bắt WM_MOVE để lưu vị trí mỗi khi cửa sổ bị kéo
OnMessage(0x0003, SaveGuiPos)

; ===== TRẠNG THÁI BOT =====
botState := {
    isRunning: false,
    battleCount: 0,
    healCount: 0,
    isBattle: false,
    status: "Initiating",
    startTime: A_TickCount,
    stepCount: 0,
    direction: true
}

; Danh sách Pokémon đặc biệt cần thông báo
global LEGENDARY_LIST := ["Raikou", "Entei", "Suicune", "Articuno", "Zapdos", "Moltres", "Shiny", "disconnected"]

; ===== HOTKEY BẬT/TẮT BOT =====
$q:: {
    if (botState.isRunning) {
        StopBot("Stopped")
    } else {
        if (!WinExist("ahk_exe PokeMMO.exe")) {
            SetStatus("Error: Game window not found")
            return
        }
        botState.isRunning := true
        botState.startTime := A_TickCount
        SetTimer(WalkTimer, 500)
        SetTimer(UpdateTimer, 1000)
        SetTimer(GuiRefreshTimer, 1000)
        SetTimer(CheckDisconnectedTimer, 3000)
    }
}

; ===== HELPER: DỪNG BOT =====
StopBot(reason := "Stopped") {
    botState.isRunning := false
    SetTimer(WalkTimer, 0)
    SetTimer(UpdateTimer, 0)
    SetTimer(GuiRefreshTimer, 0)
    SetTimer(CheckDisconnectedTimer, 0)
    SetStatus(reason)
}

; ===== HELPER: CẬP NHẬT STATUS VÀ GUI NGAY =====
; Dùng cho các trường hợp cần update tức thì (kể cả khi bot đã stop)
SetStatus(msg) {
    botState.status := msg
    ForceUpdateGui()
}

; ===== GUI: FORCE UPDATE (dùng trực tiếp, không phụ thuộc isRunning) =====
ForceUpdateGui() {
    ogcTextStatus.Value := botState.status
    ogcTextBattleCount.Value := botState.battleCount
    ogcTextHealCount.Value := botState.healCount
}

; ===== GUI: REFRESH TIMER (chỉ update khi có thay đổi, tiết kiệm CPU) =====
GuiRefreshTimer() {
    if (!botState.isRunning)
        return
    static lastStatus := "", lastBattleCount := 0, lastHealCount := 0
    if (botState.status != lastStatus ||
        botState.battleCount != lastBattleCount ||
        botState.healCount != lastHealCount) {
        ForceUpdateGui()
        lastStatus := botState.status
        lastBattleCount := botState.battleCount
        lastHealCount := botState.healCount
    }
}

; ===== FOCUS CỬA SỔ GAME =====
EnsureGameFocused() {
    try {
        if (WinActive("ahk_exe PokeMMO.exe"))
            return true
        if (!WinExist("ahk_exe PokeMMO.exe")) {
            StopBot("Error: Game window not found")
            return false
        }
        WinActivate("ahk_exe PokeMMO.exe")
        WinWaitActive("ahk_exe PokeMMO.exe", , 1)
        SetStatus("Refocused game window")
        return true
    } catch as e {
        SetStatus("Error focusing game: " . e.Message)
        return false
    }
}

; ===== TIMER: DI CHUYỂN =====
WalkTimer() {
    if (!botState.isRunning)
        return
    try {
        EnsureGameFocused()
        ignore_headbut()
        botState.status := "Walking..."
        if (ogcDirCombo.Text == "Ngang") {
            if (botState.direction)
                walk_left_fast(1)
            else
                walk_right_fast(1)
        } else {
            if (botState.direction)
                walk_up_fast(1)
            else
                walk_down_fast(1)
        }

        botState.stepCount++
        if (botState.stepCount > 3) {
            botState.direction := !botState.direction
            botState.stepCount := 0
        }

        if (DetectBattle())
            FightInit()
    } catch as e {
        SetStatus("Walk error: " . e.Message)
    }
}

; ===== KHỞI TẠO TRẬN ĐẤU =====
; Chờ tối đa 10 giây để nút Fight xuất hiện
FightInit() {
    if (!botState.isRunning)
        return
    SetStatus("Entering battle...")
    loop 10 {
        Sleep(1000)
        if (!botState.isRunning)  ; Cho phép thoát sớm nếu bot bị stop
            return
        if (detect_fight_but()) {
            Fight()
            return
        }
        SetStatus("Waiting for battle... (" . A_Index . "/10)")
    }
    SetStatus("Battle button not found — skipping")
}

; ===== CHIẾN ĐẤU =====
Fight() {
    if (!botState.isRunning)
        return
    SetStatus("Fighting...")
    try {
        stringDetected := detect_run_default(LEGENDARY_LIST)
        if (stringDetected && stringDetected != "0") {
            SetStatus("Special: " . stringDetected . "!")
            send_get_request(stringDetected)
            ; Không walk hay Quit ngay — chờ người chơi xử lý
            StopBot("⚠ Legendary found: " . stringDetected)
            return
        }
        send_run()
        Sleep(1000)
        Quit()
    } catch as e {
        SetStatus("Fight error: " . e.Message)
    }
}

; ===== THOÁT TRẬN ĐẤU =====
Quit() {
    if (!botState.isRunning)
        return
    if (!DetectBattle()) {
        botState.battleCount++
        SetStatus("Exiting battle #" . botState.battleCount)
        if (detect_pp() || detect_hp())
            Heal()
    } else {
        Fight()  ; Vẫn còn trong battle → tiếp tục fight
    }
}

; ===== HỒI PHỤC =====
Heal() {
    if (!botState.isRunning)
        return
    try {
        SetStatus("Teleporting to heal...")
        Sleep(1000)
        teleport_and_heal()
        botState.healCount++
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
    } catch as e {
        SetStatus("Disconnect check error: " . e.Message)
    }
}

; ===== WRAPPER: PHÁT HIỆN TRẬN ĐẤU =====
DetectBattle() {
    try {
        return detect_battle(1)
    } catch {
        return false
    }
}

