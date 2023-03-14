#Include libs/basic_newV2.ahk
#SingleInstance Force

SetWorkingDir(A_ScriptDir)
; REMOVED: SetBatchLines -1
myGui := Gui()
; myGui.OnEvent("Close", GuiEscape)
; myGui.OnEvent("Escape", GuiEscape)
myGui.Opt("-MinimizeBox -MaximizeBox")
myGui.SetFont("s9", "Segoe UI")
myGui.Add("Picture", "x0 y0 w160 h200", "images/gui_bg.png")
myGui.SetFont()
myGui.SetFont("cWhite")
myGui.Add("Text", "x45 y5 w73 h23 +BackgroundTrans", "Auto PayDay")
myGui.SetFont()
myGui.SetFont("s9", "Segoe UI")
myGui.SetFont()
myGui.SetFont("s20 Bold cWhite")
ogcTextBattleCount := myGui.Add("Text", "vBattleCount x6 y140 w68 h27 +BackgroundTrans +Center", "00")
myGui.SetFont()
myGui.SetFont("s9", "Segoe UI")
myGui.SetFont()
myGui.SetFont("s20 Bold cWhite")
ogcTextHealCount := myGui.Add("Text", "vHealCount x86 y140 w68 h30 +BackgroundTrans +Center", "00")
myGui.SetFont()
myGui.SetFont("s9", "Segoe UI")
myGui.SetFont()
myGui.SetFont("cWhite")
ogcTextLocation := myGui.Add("Text", "vLocation x36 y180 w85 h20 +BackgroundTrans +Center", "Ubella Bay")
myGui.SetFont()
myGui.SetFont("s9", "Segoe UI")
myGui.SetFont()
myGui.SetFont("s14 cWhite")
ogcTextStatus := myGui.Add("Text", "vStatus x8 y93 w140 h25 +BackgroundTrans +Center", "Press Q to start")
myGui.SetFont()
myGui.SetFont("s9", "Segoe UI")
myGui.SetFont()
myGui.SetFont("s14 Bold cWhite")
ogcTextTimerCount := myGui.Add("Text", "vTimerCount x8 y43 w140 h25 +BackgroundTrans +Center", "00 : 00")
myGui.SetFont()

myGui.Title := "Window"
myGui.Show("x911 y308 w158 h200")

Toggle := 0
BtlCnt := 0
HealCnt := 0
isBattle := 0
shinyBattle := 0
StartTime := 0
gui_status:="Initiating"
StartTime := A_TickCount

Return

Q::
{ ; V1toV2: Added bracket
    carn_pokebot_init()
    SetTimer(UPDATE,1000)
    SetTimer(GUISTATUSUPDATE,250)
    FISHING()
Return
} ; Added bracket before function

FISHING()
{ ; V1toV2: Added bracket
    Loop{
        gui_status := "Fishing..."
        sleep_rand(90,200)
        send_fish()
        If (detect_cannot_fish()) {
            HEAL()
        }
        if detect_battle() = 1
            {
                FIGHTINIT()
                Continue
            }
    }
Return
} ; V1toV2: Added Bracket before label

FIGHTINIT()
{ ; V1toV2: Added bracket
    if detect_battle() = 1
    {
        fight_opt := 0
        gui_status := "Entering battle..."
        Sleep(1200)
        if detect_fight_but() = 1
        {
            FIGHT()
        }
        else
        {
            FIGHTINIT()
        }
    }
    else
    {
    }
return
} ; V1toV2: Added Bracket before label

FIGHT()
{ ; V1toV2: Added bracket
    gui_status := "Fighting"
    if detect_run_default() = 1
    {
        fight_opt := 1
    }
    if detect_shiny() = 1
    {
        fight_opt := 2
    }
    if (fight_opt = 0)
    {
        send_yes()
        Sleep(400)
        send_yes()
        Sleep(3000)
    }
    if (fight_opt = 1)
    {
        gui_status := "Running..."
        send_run()
    }
    if (fight_opt = 2)
    {
        gui_status := "Catching"
        send_catch()
    }
    Sleep(300)
    QUIT()
Return
} ; V1toV2: Added Bracket before label

QUIT()
{ ; V1toV2: Added bracket
    if detect_battle() = 0
    {
        gui_status := "Exiting battle..."
        BtlCnt+=1
        If (detect_pp() || detect_hp() || detect_cannot_fish()) {
            HEAL()
        }

        If (detect_but_yes()) {
            send_no()
        }
    }
    else
    {
        FIGHT()
    }
Return
} ; V1toV2: Added bracket before function

HEAL()
{ ; V1toV2: Added bracket
    gui_status := "Healing"
    teleport_and_heal()
    HealCnt+=1
    ; go to train
    Sleep(2000)
    walk_down(3)
    walk_left(5)
    walk_down(2)
    randomvar := Random(6, 10)
    walk_right(randomvar)
    walk_down(1)
Return
} ; V1toV2: Added bracket before function

GuiEscape()
{ ; V1toV2: Added bracket
    ExitApp()
    return
}
GuiClose() {
    ExitApp()
    return
} ; V1toV2: Added Bracket before label

UPDATE()
{ ; V1toV2: Added bracket
    t := Floor((A_TickCount - StartTime) / 1000)
    m := Floor(t / 60) > 10 ? Floor(t / 60) : SubStr("00" . Floor(t / 60), -2) 
    r := SubStr("00" . Mod(t,60), -2) 
    ogcTextTimerCount.Value := m " : " r
Return
} ; V1toV2: Added Bracket before label

GUISTATUSUPDATE()
{ ; V1toV2: Added bracket
    ogcTextStatus.Value := gui_status
    ogcTextBattleCount.Value := BtlCnt
    ogcTextHealCount.Value := HealCnt
Return
} ; V1toV2: Added bracket in the end










