;#Include basic.ahk

; FUNCTIONS
;
;#####################################################################################
;
;bot_init()
;sleep_rand(rand1,rand2)
;walk_right(tiles)
;walk_left(tiles)
;walk_up
;walk_down
;_battle()
;detect_fight_but()
;detect_pp()
;send_yes()
;send_no()
;send_right()
;send_down()
;detect_chansey()
;detect_safari_ball()
;detect_but_ok()
;safari_caught()
;
;------HIGH LEVEL FUNCTIONS
;bot_auto_battle()
;bot_auto_walk()

;#####################################################################################

; Function:     			carn_pokebot_init()
; Description:  			Initiates the bot
;

carn_pokebot_init(){
CoordMode, Pixel, Window 
CoordMode, Mouse, Window
SetWorkingDir %A_ScriptDir%
SetDefaultMouseSpeed, 10
WinActivate, PokeMMO ahk_class LWJGL

}
;#####################################################################################

; Function:     			sleep_rand(rand1,rand2)
; Description:  			Causes the thread to sleep for a random time between rand1 and rand2
;

sleep_rand(rand1,rand2){
	Random, randomvar, %rand1%, %rand2%
	sleep randomvar
}
;#####################################################################################

; Function:     			walk_right()
; Description:  			Walks to the right... herp derp
;

walk_right(tiles){
    Loop, %tiles%
    {
    Send {Right Down}
	sleep_rand(190,210)
    Send {Right up}
    sleep_rand(90,110)
    }
}

walk_right_fast(tiles){
    Loop, %tiles%
    {
    Send {Right Down}
	sleep_rand(190,210)
    Send {Right up}
    sleep_rand(35,45)
    }
}

bike_right_fast(tiles){
    Loop, %tiles%
    {
    Send {Right Down}
	sleep_rand(190,210)
    Send {Right up}
    ;sleep_rand(35,45)
    }
}

;#####################################################################################

; Function:     			walk_left()
; Description:  			Walks to the left... herp derp
;

walk_left(tiles){
    Loop, %tiles%
    {
    Send {Left Down}
	sleep_rand(190,210)
    Send {Left up}
    sleep_rand(90,110)
    }
}

walk_left_fast(tiles){
    Loop, %tiles%
    {
    Send {Left Down}
	sleep_rand(190,210)
    Send {Left up}
    sleep_rand(35,45)
    }
}

bike_left_fast(tiles){
    Loop, %tiles%
    {
    Send {Left Down}
	sleep_rand(190,210)
    Send {Left up}
    }
}

;#####################################################################################

; Function:     			walk_up()
; Description:  			Walks up... herp derp
;

walk_up(tiles){
    Loop, %tiles%
    {
    Send {Up Down}
	sleep_rand(190,210)
    Send {Up up}
    sleep_rand(90,110)
    }
}

walk_up_fast(tiles){
    Loop, %tiles%
    {
    Send {Up Down}
	sleep_rand(190,210)
    Send {Up up}
    sleep_rand(35,45)
    }
}

bike_up_fast(tiles){
    Loop, %tiles%
    {
    Send {Up Down}
	sleep_rand(190,210)
    Send {Up up}
    }
}

;#####################################################################################

; Function:     			walk_down()
; Description:  			Walks down... herp derp
;

walk_down(tiles){
    Loop, %tiles%
    {
    Send {Down Down}
	sleep_rand(190,210)
    Send {Down up}
    sleep_rand(90,110)
    }
}

walk_down_fast(tiles){
    Loop, %tiles%
    {
    Send {Down Down}
	sleep_rand(190,210)
    Send {Down up}
    sleep_rand(35,45)
    }
}
bike_down_fast(tiles){
    Loop, %tiles%
    {
    Send {Down Down}
	sleep_rand(190,210)
    Send {Down up}
    }
}

;#####################################################################################

; Function:     			detect_battle()
; Description:  			Checks if battle sequence has begun
;

detect_battle(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_battle.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

detect_battle_move(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_battle_move.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

detect_select_target(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_select_target.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}


;#####################################################################################

; Function:     			detect_chansey()
; Description:  			Checks if battle sequence has begun
;

detect_chansey(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/chansey.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			safari_caught()
; Description:  			Checks if you've caught a pokemon in the safari zone
;

safari_caught(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/safari_caught.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}


;#####################################################################################

; Function:     			detect_safari_ball()
; Description:  			Checks if the fight button is present
;

detect_safari_ball(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_safari_ball.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			detect_train()
; Description:  			Checks if you're stuck at trainer tips in Safari Zone
;
detect_train(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_train.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			detect_night()
; Description:  			Checks if the fight button is present
;

detect_night(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_night.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			detect_fight_but()
; Description:  			Checks if the fight button is present
;

detect_fight_but(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_battle_but.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			detect_but_ok()
; Description:  			Checks if the fight button is present
;

detect_but_ok(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_but_ok.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

detect_but_yes(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_but_yes.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

;#####################################################################################

; Function:     			detect_pp()
; Description:  			Checks if PP is low
;

detect_pp(){
heal=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/pp3.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/pp2.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/pp1.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/pp0.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
    
Return %heal%

}

;#####################################################################################

; Function:     			detect_swc()
; Description:  			Checks if PP of Sweet Scent is low
;

detect_swc(){
heal=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/swc2.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/swc0.png
	if (ErrorLevel=0)
	{	
        heal=1
	}
    
Return %heal%

}


;#####################################################################################

; Function:     			detect_hp()
; Description:  			Checks if PP is low
;

detect_hp(){
healhp=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *1 images/detect_hp_low.png
	if (ErrorLevel=0)
	{	
        healhp=1
	}

Return %healhp%

}

detect_cannot_fish(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_cannot_fish.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}

detect_heal_done(){
    ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_heal_done.png
	if (ErrorLevel=0)
    {
        return, 1
    }
    else
    {
        return, 0
    }
}


;#####################################################################################

; Function:     			detect_catch()
; Description:  			Checks if there is a Pokemon we should catch
;

detect_catch(){
bot_catch=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/catch.png
	if (ErrorLevel=0)
	{	
        bot_catch=1
	}
ImageSearch, barrowx, barrowy, 0, 0, 1920,1080, *TransBlack images/shiny.png
    if (ErrorLevel=0) ;Initiate runaway sequence
    {	
        bot_catch=1
    }
Return %bot_catch%
}

;#####################################################################################

; Function:     			detect_shiny()
; Description:  			Checks for shiny
;

detect_shiny(){
bot_catch=0
ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/shiny.png
	if (ErrorLevel=0)
	{	
        bot_catch=1
	}
Return %bot_catch%
}

;#####################################################################################

; Function:     			detect_shiny()
; Description:  			Checks for shiny
;

detect_pokeball_bag(){
bot_ball_bag=0
ImageSearch barrowx, barrowy, 0, 0, 1920, 1080, *25 images/detect_pokeball_bag.png
	if (ErrorLevel=0)
	{	
        bot_ball_bag=1
	}
Return %bot_ball_bag%
}

;#####################################################################################

; Function:     			detect_run(image1,image2,image3)
; Description:  			Checks if we should try running
;

detect_run(image1,image2,image3){
bot_run=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 %image1%
	if (ErrorLevel=0)
	{	
        bot_run=1
	}
ImageSearch, barrowx, barrowy, 0, 0, 1920,1080, *25 %image2%
    if (ErrorLevel=0) ;Initiate runaway sequence
    {	
        bot_run=1
    }
ImageSearch, barrowx, barrowy, 0, 0, 1920,1080, *25 %image3%.
    if (ErrorLevel=0) ;Initiate runaway sequence
    {	
        bot_run=1
    }
Return %bot_run%
}

;#####################################################################################

; Function:     			detect_run_default()
; Description:  			Checks if we should try running
;

detect_run_default(){
bot_run=0
ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/run_1.png
	if (ErrorLevel=0)
	{	
        bot_run=1
	}
ImageSearch, barrowx, barrowy, 0, 0, 1920,1080, *25 images/run_2.png
    if (ErrorLevel=0) ;Initiate runaway sequence
    {	
        bot_run=1
    }
ImageSearch, barrowx, barrowy, 0, 0, 1920,1080, *25 images/run_3.png
    if (ErrorLevel=0) ;Initiate runaway sequence
    {	
        bot_run=1
    }
Return %bot_run%
}

;#####################################################################################

; Function:     			send_yes()
; Description:  			Sends the key "Z"
;

send_yes(){
    Send {z down}
    sleep_rand(18,22)
    Send {z up}
}

;#####################################################################################

; Function:     			send_no()
; Description:  			Sends the key "X"
;

send_no(){
    Send {x down}
    sleep_rand(18,22)
    Send {x up}
}

;#####################################################################################

; Function:     			send_right()
; Description:  			Sends the key "right"
;

send_right(){
    Send {right down}
    sleep_rand(18,22)
    Send {right up}
}

;#####################################################################################

; Function:     			send_left()
; Description:  			Sends the key "left"
;

send_left(){
    Send {left down}
    sleep_rand(18,22)
    Send {left up}
}

;#####################################################################################

; Function:     			send_up()
; Description:  			Sends the key "up"
;

send_up(){
    Send {up down}
    sleep_rand(18,22)
    Send {up up}
}

;#####################################################################################

; Function:     			send_down()
; Description:  			Sends the key "down"
;

send_down(){
    Send {Down down}
    sleep_rand(18,22)
    Send {Down up}
}

;#####################################################################################

; Function:     			send_run()
; Description:  			Chooses the option to run away rather than fight
;

send_run(){
    send_right()
    sleep 100
    send_down()
    send_yes()
}

;#####################################################################################

; Function:     			send_catch()
; Description:  			Attempts to catch the Pokemon
;

send_catch(){
    send_right()
    sleep 100
    send_yes()
    sleep 500
    if (detect_pokeball_bag()){
        send_yes()
        sleep 500
    } else {
        send_right()
        sleep 500
        send_right()
        sleep 300
        send_yes()
    }
}

;#####################################################################################

; Function:     			send_catch_ultra()
; Description:  			Attempts to catch the Pokemon with the best ball available
;

send_catch_ultra(){
    send_right()
    sleep 100
    send_yes()
    sleep 500
    send_right()
    sleep 500
    send_right()
    sleep 300
    send_down()
    sleep 100
    send_down()
    sleep 100
    send_down()
    sleep 100
    send_yes()
   
}

;#####################################################################################

; Function:     			send_fish()
; Description:  			Activates the fishing sequence
;

send_fish(){
    Send {F3 down}
    sleep_rand(18,22)
    Send {F3 up}
    sleep 2000
    ImageSearch barrowx, barrowy, 50, 50, 1920, 1080, *25 images/detect_arrow_down.png
	if (ErrorLevel=0)
    {
        send_yes()
    }
}

send_sweet_scent(){
    Send {F7 down}
    sleep_rand(18,22)
    Send {F7 up}
    sleep 3000
}

fly_to_home() {
    Send {F2 down}
    sleep_rand(18,22)
    Send {F2 up}
    sleep 1000
    send_yes()
    sleep 3000
}

go_pc() {
    walk_up(2)
    sleep 2000
    walk_up(8)
    sleep_rand(500, 1000)
    While, (!detect_heal_done()) {
        send_yes()
        sleep_rand(1000,1500)
    }
    send_yes()
    sleep_rand(500, 1000)
    walk_down(9)
}

teleport_and_heal() {
    Send {F4 down}
    sleep_rand(18,22)
    Send {F4 up}
    sleep 3000
    While, (!detect_heal_done()) {
        send_yes()
        sleep_rand(1000,1500)
    }
    send_yes()
    sleep_rand(500, 1000)
    walk_down(9)
}

heal_pokemon() {
    fly_to_home()
    sleep_rand(3000, 5000)
    go_pc()
}

;#####################################################################################

; Function:     			send_card()
; Description:  			Toggles trainer card
;

send_card(){
    Send {c down}
    sleep_rand(18,22)
    Send {c up}
}

;#####################################################################################

; Function:     			send_bag_open()
; Description:  			Opens bag
;

send_bag_open(){
    Send {B down}
    sleep_rand(60,70)
    Send {B up}
    sleep 800
   
}

;#####################################################################################

; Function:     			send_bag_close()
; Description:  			Closes bag
;

send_bag_close(){
    Send {B down}
    sleep_rand(18,22)
    Send {B up}
}


;-----FUNCTIONS ADDED IN 3.1
;#####################################################################################

; Function:     			toggle_bike()
; Description:  			Toggles the bike
;

toggle_bike(){
    Send {F1 down}
    sleep_rand(18,22)
    Send {F1 up}
}

;#####################################################################################

; Function:     			toggle_map()
; Description:  			Toggles the map
;

toggle_map(){
    Send {F3 down}
    sleep_rand(18,22)
    Send {F3 up}
}

/*
;#####################################################################################

; Function:     			pause_walker()
; Description:  			Toggles pausing walker.exe
;

pause_walker(){
    
    DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
    SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
    PostMessage, 0x111, 65306,,, Walker
    Send {Left Up}
    Send {Right Up}
    Send {Down Up}
    Send {Up Up}
    
	;Send {BS}
}


;########################----HIGH LEVEL FUNCTION----####################################

; Function:     			walk_right_check()--- and others
; Description:  			Checks if there is a battle while walkin
;


