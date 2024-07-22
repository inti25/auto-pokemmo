#SingleInstance Force
#Include libs/OCR.ahk
#Include libs/basic.ahk

Q::
{
    ;send_get_request()
    result := OCR.FromWindow("ahk_class GLFW30", , scale:=3, onlyClientArea:=1, mode:=2)
    ; found := result.FindStrings("PP:1", False)
    MsgBox result.Text
}
