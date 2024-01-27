#SingleInstance Force
#Include libs/OCR.ahk
#Include libs/basic.ahk

Q::
{
    result := OCR.FromWindow("ahk_class GLFW30", , scale:=3, onlyClientArea:=1, mode:=2)
    ; found := result.FindStrings("PP:1", False)
    MsgBox result.Text
    MsgBox detect_pp()
    if detect_pp() = 0
        MsgBox "detect_pp 0"
    Else
        MsgBox "detect_pp 1"
}
