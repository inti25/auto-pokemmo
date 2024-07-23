#Include OCR.ahk
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
    CoordMode "Pixel", "Window"
    CoordMode "Mouse", "Window"
    SetWorkingDir A_ScriptDir
    SetDefaultMouseSpeed 10
    WinActivate "ahk_class GLFW30"
}
;#####################################################################################

; Function:     			sleep_rand(rand1,rand2)
; Description:  			Causes the thread to sleep for a random time between rand1 and rand2
;

sleep_rand(rand1,rand2){
	randomvar := Random(rand1, rand2)
	Sleep(randomvar)
}
;#####################################################################################

; Function:     			walk_right()
; Description:  			Walks to the right... herp derp
;

walk_right(tiles){
    Loop tiles
    {
    Send("{Right Down}")
	sleep_rand(190,210)
    Send("{Right up}")
    sleep_rand(90,110)
    }
}

walk_right_fast(tiles){
    Loop tiles
    {
    Send("{Right Down}")
	sleep_rand(190,210)
    Send("{Right up}")
    sleep_rand(35,45)
    }
}

bike_right_fast(tiles){
    Loop tiles
    {
    Send("{Right Down}")
	sleep_rand(190,210)
    Send("{Right up}")
    ;sleep_rand(35,45)
    }
}

;#####################################################################################

; Function:     			walk_left()
; Description:  			Walks to the left... herp derp
;

walk_left(tiles){
    Loop tiles
    {
    Send("{Left Down}")
	sleep_rand(190,210)
    Send("{Left up}")
    sleep_rand(90,110)
    }
}

walk_left_fast(tiles){
    Loop tiles
    {
    Send("{Left Down}")
	sleep_rand(190,210)
    Send("{Left up}")
    sleep_rand(35,45)
    }
}

bike_left_fast(tiles){
    Loop tiles
    {
    Send("{Left Down}")
	sleep_rand(190,210)
    Send("{Left up}")
    }
}

;#####################################################################################

; Function:     			walk_up()
; Description:  			Walks up... herp derp
;

walk_up(tiles){
    Loop tiles
    {
    Send("{Up Down}")
	sleep_rand(190,210)
    Send("{Up up}")
    sleep_rand(90,110)
    }
}

walk_up_fast(tiles){
    Loop tiles
    {
    Send("{Up Down}")
	sleep_rand(190,210)
    Send("{Up up}")
    sleep_rand(35,45)
    }
}

bike_up_fast(tiles){
    Loop tiles
    {
    Send("{Up Down}")
	sleep_rand(190,210)
    Send("{Up up}")
    }
}

;#####################################################################################

; Function:     			walk_down()
; Description:  			Walks down... herp derp
;

walk_down(tiles){
    Loop tiles
    {
    Send("{Down Down}")
	sleep_rand(190,210)
    Send("{Down up}")
    sleep_rand(90,110)
    }
}

walk_down_fast(tiles){
    Loop tiles
    {
    Send("{Down Down}")
	sleep_rand(190,210)
    Send("{Down up}")
    sleep_rand(35,45)
    }
}
bike_down_fast(tiles){
    Loop tiles
    {
    Send("{Down Down}")
	sleep_rand(190,210)
    Send("{Down up}")
    }
}


detect_strings(needle, casesense:=False) {
    result := OCR.FromWindow("ahk_class GLFW30", , scale:=1, onlyClientArea:=1, mode:=2)
    ; found := result.FindStrings(needle, casesense)
    if InStr(result.Text, needle , casesense) > 0 {
        return "1"
    } else {
        return "0"
    }
}

count_string(needle, casesense:=False, nCount:=1) {
    result := OCR.FromWindow("ahk_class GLFW30", , scale:=1, onlyClientArea:=1, mode:=2)
    sCount := result.FindStrings(needle, casesense)
    If (sCount.Length >= nCount) {
        return "1"
    } Else {
        return "0"
    }
}

;#####################################################################################

; Function:     			detect_battle()
; Description:  			Checks if battle sequence has begun
;

detect_battle(nCount:=2){
    ; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_battle.png")
	; if (ErrorLevel=0)
    ; {
    ;     return 1
    ; }
    ; else
    ; {
    ;     return 0
    ; }
    return count_string("Lv.", True, nCount)
}

ignore_headbut(){
    If (detect_strings("headbutted") = 1)
        send_no()
}


;#####################################################################################

; Function:     			safari_caught()
; Description:  			Checks if you've caught a pokemon in the safari zone
;

safari_caught(){
    ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/safari_caught.png")
	if (ErrorLevel=0)
    {
        return 1
    }
    else
    {
        return 0
    }
}


;#####################################################################################

; Function:     			detect_safari_ball()
; Description:  			Checks if the fight button is present
;

detect_safari_ball(){
    ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_safari_ball.png")
	if (ErrorLevel=0)
    {
        return 1
    }
    else
    {
        return 0
    }
}

;#####################################################################################

; Function:     			detect_night()
; Description:  			Checks if the fight button is present
;

detect_night(){
    ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_night.png")
	if (ErrorLevel=0)
    {
        return 1
    }
    else
    {
        return 0
    }
}

;#####################################################################################

; Function:     			detect_fight_but()
; Description:  			Checks if the fight button is present
;

detect_fight_but(){
    ; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_battle_but.png")
	; if (ErrorLevel=0)
    ; {
    ;     return 1
    ; }
    ; else
    ; {
    ;     return 0
    ; }
    return detect_strings("Fight", False)
}

;#####################################################################################

; Function:     			detect_but_ok()
; Description:  			Checks if the fight button is present
;

detect_but_ok(){
    ; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_but_ok.png")
	; if (ErrorLevel=0)
    ; {
    ;     return 1
    ; }
    ; else
    ; {
    ;     return 0
    ; }

    return detect_strings("OK", True)
}

detect_but_yes(){
    ; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_but_yes.png")
	; if (ErrorLevel=0)
    ; {
    ;     return 1
    ; }
    ; else
    ; {
    ;     return 0
    ; }
    return detect_strings("Yes", True)
}

;#####################################################################################

; Function:     			detect_pp()
; Description:  			Checks if PP is low
;

detect_pp(){
    heal := "0"
    If (detect_strings("pp:3/", False) = 1)
    {
        heal := "1"
    }
    If (detect_strings("pp:2/", False) = 1) {
        heal := "1"
    }
    If (detect_strings("pp:1/", False) = 1) {
        heal := "1"
    }
    If (detect_strings("pp:0/", False) = 1) {
        heal := "1"
    }
    return heal
; heal := "0"
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/pp3.png")
; 	if (ErrorLevel=0)
; 	{
;         heal := "1"
; 	}
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/pp2.png")
; 	if (ErrorLevel=0)
; 	{
;         heal := "1"
; 	}
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/pp1.png")
; 	if (ErrorLevel=0)
; 	{
;         heal := "1"
; 	}
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/pp0.png")
; 	if (ErrorLevel=0)
; 	{
;         heal := "1"
; 	}

; return heal

}

;#####################################################################################

; Function:     			detect_swc()
; Description:  			Checks if PP of Sweet Scent is low
;

detect_swc(){
heal := "0"
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/swc2.png")
	if (ErrorLevel=0)
	{
        heal := "1"
	}
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/swc0.png")
	if (ErrorLevel=0)
	{
        heal := "1"
	}

return heal

}


;#####################################################################################

; Function:     			detect_hp()
; Description:  			Checks if PP is low
;

detect_hp(){
healhp := "0"
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*1 images/detect_hp_low.png")
	if (ErrorLevel=0)
	{
        healhp := "1"
	}

return healhp

}

detect_cannot_fish(){
    ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_cannot_fish.png")
	if (ErrorLevel=0)
    {
        return 1
    }
    else
    {
        return 0
    }
}

detect_heal_done(){
    ; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_heal_done.png")
	; if (ErrorLevel=0)
    ; {
    ;     return 1
    ; }
    ; else
    ; {
    ;     return 0
    ; }
    return detect_strings("again", True)
}


;#####################################################################################

; Function:     			detect_catch()
; Description:  			Checks if there is a Pokemon we should catch
;

detect_catch(){
bot_catch := "0"
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/catch.png")
	if (ErrorLevel=0)
	{
        bot_catch := "1"
	}
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*TransBlack images/shiny.png")
    if (ErrorLevel=0) ;Initiate runaway sequence
    {
        bot_catch := "1"
    }
return bot_catch
}

;#####################################################################################

; Function:     			detect_shiny()
; Description:  			Checks for shiny
;

detect_shiny() {
; bot_catch := "0"
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/shiny.png")
; if (ErrorLevel=0)
; {
;     bot_catch := "1"
; }
; return bot_catch
    return detect_strings("Shiny", false)
}

;#####################################################################################

; Function:     			detect_shiny()
; Description:  			Checks for shiny
;

detect_pokeball_bag(){
bot_ball_bag := "0"
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/detect_pokeball_bag.png")
	if (ErrorLevel=0)
	{
        bot_ball_bag := "1"
	}
return bot_ball_bag
}

;#####################################################################################

; Function:     			detect_run(image1,image2,image3)
; Description:  			Checks if we should try running
;

detect_run(image1,image2,image3){
bot_run := "0"
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 " image1)
	if (ErrorLevel=0)
	{
        bot_run := "1"
	}
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 " image2)
    if (ErrorLevel=0) ;Initiate runaway sequence
    {
        bot_run := "1"
    }
ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 " image3 ".")
    if (ErrorLevel=0) ;Initiate runaway sequence
    {
        bot_run := "1"
    }
return bot_run
}

;#####################################################################################

; Function:     			detect_run_default()
; Description:  			Checks if we should try running
;

detect_run_default(pokemon_names) {
; bot_run := "0"

For index, pokemonName in pokemon_names 
{
    If (detect_strings(pokemonName, false)) {
        return "1"
    }
}
return "0"

; If (detect_strings("Tranquill", false)) {
;     bot_run := "1"
; }
; If (detect_strings("Combee", false)) {
;     bot_run := "1"
; }
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/run_1.png")
; 	if (ErrorLevel=0)
; 	{
;         bot_run := "1"
; 	}
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/run_2.png")
;     if (ErrorLevel=0) ;Initiate runaway sequence
;     {
;         bot_run := "1"
;     }
; ErrorLevel := !ImageSearch(&barrowx, &barrowy, 0, 0, 1920, 1080, "*25 images/run_3.png")
;     if (ErrorLevel=0) ;Initiate runaway sequence
;     {
;         bot_run := "1"
;     }
; return bot_run
}

;#####################################################################################

; Function:     			send_yes()
; Description:  			Sends the key "Z"
;

send_yes(){
    Send("{z down}")
    sleep_rand(18,22)
    Send("{z up}")
}

;#####################################################################################

; Function:     			send_no()
; Description:  			Sends the key "X"
;

send_no(){
    Send("{x down}")
    sleep_rand(18,22)
    Send("{x up}")
}

;#####################################################################################

; Function:     			send_right()
; Description:  			Sends the key "right"
;

send_right(){
    Send("{right down}")
    sleep_rand(18,22)
    Send("{right up}")
}

;#####################################################################################

; Function:     			send_left()
; Description:  			Sends the key "left"
;

send_left(){
    Send("{left down}")
    sleep_rand(18,22)
    Send("{left up}")
}

;#####################################################################################

; Function:     			send_up()
; Description:  			Sends the key "up"
;

send_up(){
    Send("{up down}")
    sleep_rand(18,22)
    Send("{up up}")
}

;#####################################################################################

; Function:     			send_down()
; Description:  			Sends the key "down"
;

send_down(){
    Send("{Down down}")
    sleep_rand(18,22)
    Send("{Down up}")
}

;#####################################################################################

; Function:     			send_run()
; Description:  			Chooses the option to run away rather than fight
;

send_run(){
    send_right()
    Sleep(100)
    send_down()
    send_yes()
}

;#####################################################################################

; Function:     			send_catch()
; Description:  			Attempts to catch the Pokemon
;

send_catch(){
    send_right()
    Sleep(100)
    send_yes()
    Sleep(500)
    if (detect_pokeball_bag()){
        send_yes()
        Sleep(500)
    } else {
        send_right()
        Sleep(500)
        send_right()
        Sleep(300)
        send_yes()
    }
}

;#####################################################################################

; Function:     			send_catch_ultra()
; Description:  			Attempts to catch the Pokemon with the best ball available
;

send_catch_ultra(){
    send_right()
    Sleep(100)
    send_yes()
    Sleep(500)
    send_right()
    Sleep(500)
    send_right()
    Sleep(300)
    send_down()
    Sleep(100)
    send_down()
    Sleep(100)
    send_down()
    Sleep(100)
    send_yes()

}

;#####################################################################################

; Function:     			send_fish()
; Description:  			Activates the fishing sequence
;

send_fish(){
    Send("{F3 down}")
    sleep_rand(15,22)
    Send("{F3 up}")
    Sleep(2000)
    ErrorLevel := !ImageSearch(&barrowx, &barrowy, 50, 50, 1920, 1080, "*25 images/detect_arrow_down.png")
	if (ErrorLevel=0)
    {
        send_yes()
    }
}

send_sweet_scent(useLeppa := False){
    Send("{F7 down}")
    sleep_rand(18,22)
    Send("{F7 up}")
    Sleep(3000)
    If (useLeppa == True) {
        If (detect_strings("Leppa Berry", True)) {
            send_yes()
            Sleep(3000)
            ; Send("{F7 down}")
            ; sleep_rand(18,22)
            ; Send("{F7 up}")
            ; Sleep(3000)
        }
    }
}

send_use_leppa() {
    Send("{F9 down}")
    sleep_rand(18,22)
    Send("{F9 up}")
    sleep_rand(18,22)
    send_yes()
    sleep_rand(18,22)
    send_yes()
    Sleep(3000)
}

fly_to_home() {
    Send("{F2 down}")
    sleep_rand(18,22)
    Send("{F2 up}")
    Sleep(1000)
    send_yes()
    Sleep(3000)
}

go_pc() {
    walk_up(2)
    Sleep(2000)
    walk_up(8)
    sleep_rand(500, 1000)
    While (!detect_heal_done()) {
        sleep_rand(500,1500)
        send_yes()
        sleep_rand(1000,1500)
    }
    sleep_rand(500,1500)
    send_yes()
    sleep_rand(500, 1000)
    walk_down(9)
}

teleport() {
    Send("{F4 down}")
    sleep_rand(100,200)
    Send("{F4 up}")
    Sleep(5000)
}

teleport_and_heal() {
    sleep_rand(1000,1500)
    teleport()
    While (!detect_heal_done()) {
        sleep_rand(1000,1500)
        send_yes()
        sleep_rand(2000,2500)
        surf := detect_strings("surf", True)
        If (surf = "1") {
            send_no()
            teleport()
        }
    }
    sleep_rand(1000,1500)
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
    Send("{c down}")
    sleep_rand(18,22)
    Send("{c up}")
}

;#####################################################################################

; Function:     			send_bag_open()
; Description:  			Opens bag
;

send_bag_open(){
    Send("{B down}")
    sleep_rand(60,70)
    Send("{B up}")
    Sleep(800)

}

;#####################################################################################

; Function:     			send_bag_close()
; Description:  			Closes bag
;

send_bag_close(){
    Send("{B down}")
    sleep_rand(18,22)
    Send("{B up}")
}


;-----FUNCTIONS ADDED IN 3.1
;#####################################################################################

; Function:     			toggle_bike()
; Description:  			Toggles the bike
;

toggle_bike(){
    Send("{F1 down}")
    sleep_rand(18,22)
    Send("{F1 up}")
}

;#####################################################################################

; Function:     			toggle_map()
; Description:  			Toggles the map
;

toggle_map(){
    Send("{F3 down}")
    sleep_rand(18,22)
    Send("{F3 up}")
}

send_get_request() {
    result := OCR.FromWindow("ahk_class GLFW30", , scale:=2, onlyClientArea:=1, mode:=2)
    mess := ""
    mess .= Format("https://api.telegram.org/bot6565296312:AAHmIL0gk6r03AyHIOjkxirx5u4NgrOGVM4/sendMessage?text={1}&chat_id=@inti_pokemmo", result.Text)
    whr := ComObject("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", mess, true)
    whr.Send()
    ; Using 'true' above and the call below allows the script to remain responsive.
    whr.WaitForResponse()
    Sleep(10000)
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


