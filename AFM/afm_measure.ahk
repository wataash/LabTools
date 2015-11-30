#Include range.ahk

; Right click "H" mark in the taskbar to stop.
;~ SetKeyDelay, 500

Space & e::ExitApp
Space & r::Reload
Space & x::execute()
Space::Send {Space} 


execute()
{
    ;~ AFM.export_jpg(1, "d:\ashihara\img", 178, 207)
    
    configs := [["30u", ".5Hz", "u", 18]
                 , ["10u",  "1Hz", "d", 18]
                 , ["3u",   "1Hz", "u", 9]
                 , ["1u",   "1Hz", "d", 9]
                 , ["300n", "1Hz", "u", 9]]
    for index, config in configs
    {
        AFM.config_capture(config[1]
            , config[2], config[3], config[4])
    }
}


class AFM
{
    export_jpg(height_range_nm, export_dir, al3_begin, al3_end)
    {
        SetKeyDelay -1
        
        ; Be sure: in off-line menu, activate top file
        
        for i in range(al3_begin, al3_end+1)
        {
            WinActivate, NanoScope Control
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
    
    config_capture(size, rate, u_or_d, capture_minutes)
    {
        ; Do NOT "Show all items" in "Scan Controls".
        ; Activate "Scan size".
        
        ; throw if u_or_d not in ["u", "d"]
        
        SetKeyDelay, 500
        WinActivate, NanoScope Control
        
        Send !ps  ; Panels -> Scan
        Send % size
        
        Send {Down}{Down}{Down}{Down}%rate%
        Send {Up}{Up}{Up}{Up}
        
        Send ^c  ; Capture
        Send !f%u_or_d%  ; Frame -> Up or Down
        
        sleep_minute(capture_minutes)
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
    Sleep % minute * 60 * 1000
}


