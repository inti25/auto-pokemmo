#Include, libs/basic.ahk
#SingleInstance, Force

Q::

Toggle := 0
carn_pokebot_init()


Toggle := !Toggle
While Toggle
{
    If (detect_battle()) {
        ToolTip, detect_battle ,0,0
        If (detect_fight_but()) {
            ToolTip, detect_fight_but ,0,0
            send_yes()
            sleep_rand(500,1500)
            send_yes()
            sleep_rand(500,1500)
        } else if(detect_battle_move()) {
            sleep_rand(500,1500)
            send_yes()
        }
    } else {
        If (detect_pp() || detect_cannot_fish()) {
            ToolTip, pp is low go pc to heal ,0,0
            fly_to_home()
            sleep 3000
            ToolTip, heal ,0,0
            go_pc()
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
            ToolTip, fishing ,0,0
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