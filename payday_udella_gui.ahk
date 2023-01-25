; Generated by Auto-GUI 3.0.1
#Include, libs/basic.ahk
#SingleInstance Force

SetWorkingDir %A_ScriptDir%
SetBatchLines -1
Gui -MinimizeBox -MaximizeBox
Gui Font, s9, Segoe UI
Gui Add, Picture, x0 y0 w160 h200, images/gui_bg.png
Gui Font
Gui Font, cWhite
Gui Add, Text, x45 y5 w73 h23 +BackgroundTrans, Auto PayDay
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
Gui Add, Text, vLocation x36 y180 w85 h20 +BackgroundTrans +Center, Ubella Bay
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

Q::
StartTime := A_TickCount
Toggle := 0
BtlCnt := 0
HealCnt := 0
isBattle := 0
carn_pokebot_init()


Toggle := !Toggle
SetTimer, UpdateTime, 1000
While Toggle
{
    If (detect_battle()) {
        If (!isBattle) {
            isBattle := 1
            BtlCnt++
            GuiControl,, BattleCount, %BtlCnt%
        }
        ; ToolTip, detect_battle ,0,0
        GuiControl,, Status, % "Enter Battle"
        While, detect_battle() {
            if (detect_shiny()) {
                send_catch()
            } else If (detect_fight_but()) {
                ; ToolTip, detect_fight_but ,0,0
                GuiControl,, Status, % "Fighting..."
                send_yes()
                sleep_rand(500,1500)
                send_yes()
                sleep_rand(500,1500)
            } else if(detect_battle_move()) {
                sleep_rand(500,1500)
                send_yes()
            } else {
                sleep_rand(500, 2000)
            }
        }
    } else {
        isBattle := 0
        If (detect_pp() || detect_hp() || detect_cannot_fish()) {
            ; GuiControl,, Status, % "Fly to PC"
            ; fly_to_home()
            ; sleep 3000
            ; GuiControl,, Status, % "Healing"
            ; go_pc()
            GuiControl,, Status, % "Healing"
            teleport_and_heal()
            HealCnt++
            GuiControl,, HealCount, %HealCnt%
            ; go to train
            sleep 2000
            walk_down(3)
            walk_left(5)
            walk_down(2)
            Random, randomvar, 6, 10
            walk_right(randomvar)
            walk_down(1)
        } else {
            checkAndTakeItem()
            GuiControl,, Status, % "Fishing..."
            sleep_rand(90,200)
            send_fish()
        }
    }
}

checkAndTakeItem() {
    ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/meow_item.png
	if (ErrorLevel=0)
	{	
        Click, %barrowx%, %barrowy% Left, 1
        Sleep, 1000
        walk_down(2)
        send_yes()
        Sleep, 2000
        send_no()
        sleep_rand(500, 1500)
	}
}


GuiEscape:
GuiClose:
    ExitApp
    return

UpdateTime:
    t := Floor((A_TickCount - StartTime) / 1000)
    m := Floor(t / 60) > 10 ? Floor(t / 60) : SubStr("00" . Floor(t / 60) , -1) 
    r := SubStr("00" . Mod(t,60) , -1) 
    GuiControl,, TimerCount, %m% : %r%
    Return
