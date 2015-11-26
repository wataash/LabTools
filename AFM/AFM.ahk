#Include range.ahk

; Right click "H" mark in the taskbar to stop.
;~ SetKeyDelay 500

Space & e::ExitApp
Space & r::Reload
Space & x::execute()
Space::Send {Space} 


execute()
{
    AFM.export_jpg(1, "d:\ashihara\img", 178, 207)
}


class AFM
{
    export_jpg(height_range_nm, export_dir, al3_begin, al3_end)
    {
        ; Be sure: in off-line menu, activate top file
        WinActivate, NanoScope Control

        for i in range(al3_begin, al3_end+1)
        {
            Send, {Enter}  ; open the activated file
            Send, !n  ; If a dialog of "Save" confirmation appears, reply "No".
            Send, !iL  ; Image -> Left
            ; View -> Top -> Data cale, apply, exit
            Send, !vt{Down}{Down}%height_range_nm%n{Enter}{Enter}
            Send, !fs  ; File -> Save
            Send, !u{Up}{Up}{Up}{Enter}  ; Utility -> JPEG Export
            Send, {Tab}%export_dir%{Tab}%i%_%height_range_nm%nm{Enter}
            Send, !y  ; "YES" if "override?" dialog
            Sleep, 100  ; wait for saving
            Send, {Esc}{Down}  ; Activate file list, select next file
        }
    }
    
    config(size, rate, sleep_ms)
    {
        Send, !p  ; panel
        Sleep, %sleep_ms%
        Send, s   ; scan?
        Sleep, %sleep_ms%
        
        ;; throw if "Scan size" not activated
        
        SendInput, %size%
        Sleep, %sleep_ms%
        Loop, 4
        {
            SendInput, {Down}
            Sleep, %sleep_ms%
        }
        ;; throw if not addapted
        SendInput, %rate%
        Loop, 4
        {
            SendInput, {Up}
            Sleep, %sleep_ms%
        }
    }
        
    capture(u_or_d)
    {
        ;; throw if u_or_d not in ["u", "d"]
        Send, ^c  ; capture
        Sleep, %sleep_ms%
        Send, !f  ; frame
        Sleep, %sleep_ms%
        SendInput, %u_or_d%
        ;; throw if not started
        Sleep, %sleep_ms%
    }

    static dbg_cnt = 0
    dbg()
    {
        MsgBox % this.dbg_cnt
        this.dbg_cnt++
        WinActivate, NanoScope Control
        Sleep, 1000
    }
}


sleep_minute(minute)
{
    Sleep, %minute% * 60 * 1000
}


configs := [["30u", ".5Hz", "u", 18]
                 , ["10u", ".5Hz", "d", 18]
                 , ["3u",   "1Hz", "u", 9]
                 , ["1u",   "1Hz", "d", 9]
                 , ["300n", "1Hz", "u", 9]]

;~ for size, rate, u_or_d, run_minute in config
;~ for config in configs
;~ {
    ;~ msgbox % config[0]
    ;~ config(%size%, %rate%, 1000)
    ;~ capture(%u_or_d%)
    ;~ sleep_minute(run_minute)
;~ }
