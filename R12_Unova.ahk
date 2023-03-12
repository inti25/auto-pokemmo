#Include, libs/basic.ahk
#SingleInstance Force

SetWorkingDir %A_ScriptDir%
SetBatchLines -1
Gui -MinimizeBox -MaximizeBox
Gui Font, s9, Segoe UI
Gui Add, Picture, x0 y0 w160 h200, images/gui_bg.png
Gui Font
Gui Font, cWhite
Gui Add, Text, x45 y5 w73 h23 +BackgroundTrans, Speed EV Training
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s20 Bold cWhite
Gui Add, Text, vBattleCount x6 y140 w68 h27 +BackgroundTrans +Center, 00
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s20 Bold cWhite
Gui Add, Text, vHealCount x86 y140 w68 h30 +BackgroundTrans +Center, 00
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, cWhite
Gui Add, Text, vLocation x36 y180 w85 h20 +BackgroundTrans +Center, R12 Unova
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s14 cWhite
Gui Add, Text, vStatus x8 y93 w140 h25 +BackgroundTrans +Center, Press Q to start
Gui Font
Gui Font, s9, Segoe UI
Gui Font
Gui Font, s14 Bold cWhite
Gui Add, Text, vTimerCount x8 y43 w140 h25 +BackgroundTrans +Center, 00 : 00
Gui Font

Gui Show, x911 y308 w158 h200, Window
Return

carn_pokebot_init()
Q::
    Toggle := 0
    BtlCnt := 0
    HealCnt := 0
    isBattle := 0
    shinyBattle := 0
    StartTime := 0
    gui_status:="Initiating"
    StartTime := A_TickCount
    SetTimer, UPDATE, 1000
    SetTimer, GUISTATUSUPDATE, 250
    Gosub, TRAINING
Return

TRAINING:
    Loop {
        gui_status := "Sweet Scent..."
        sleep_rand(90,200)
        send_sweet_scent()
        if detect_battle() = 1
            {
                gosub FIGHTINIT
                Continue
            }
    }
Return

FIGHTINIT:
    if detect_battle() = 1
    {
        fight_opt := 0
        gui_status := "Entering battle..."
        sleep 1200
        if detect_fight_but() = 1
        {
            gosub FIGHT
        }
        else
        {
            gosub FIGHTINIT
        }
    }
    else
    {
    }
return

FIGHT:
    gui_status := "Fighting"
    if detect_run_default() = 1
    {
        fight_opt := 1
    }
    if detect_shiny() = 1
    {
        fight_opt := 2
    }
    if fight_opt = 0
    {
        send_yes()
        sleep 400
        send_yes()
        sleep 400
        send_yes()
        sleep 3000
    }
    if fight_opt = 1
    {
        gui_status := "Running..."
        send_run()
    }
    if fight_opt=2
    {
        gui_status := "Catching"
        send_catch()
    }
    sleep 300
    gosub QUIT
Return

QUIT:
    if detect_battle() = 0
    {
        gui_status := "Exiting battle..."
        BtlCnt+=1
        If (detect_pp() || detect_hp() || detect_swc()) {
            gosub HEAL
        }

        If (detect_but_yes()) {
            send_no()
        }
    }
    else
    {
        gosub FIGHT
    }
Return

HEAL:
    gui_status := "Healing"
    teleport_and_heal()
    HealCnt+=1
    ; go to train
    sleep 2000
    Random, randomvar, 35, 40
    walk_left(randomvar)
    walk_up(1)
Return

GuiEscape:
GuiClose:
    ExitApp
    return

UPDATE:
    t := Floor((A_TickCount - StartTime) / 1000)
    m := Floor(t / 60) > 10 ? Floor(t / 60) : SubStr("00" . Floor(t / 60) , -1) 
    r := SubStr("00" . Mod(t,60) , -1) 
    GuiControl,, TimerCount, %m% : %r%
Return

GUISTATUSUPDATE:
    GuiControl,, Status, %gui_status%
    GuiControl,, BattleCount, %BtlCnt%
    GuiControl,, HealCount, %HealCnt%
Return