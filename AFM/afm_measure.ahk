; Right click "H" mark in the taskbar to stop.
MsgBox

configs := []

configs := [["30um", ".5Hz", "d", 18]
             , ["10um",  "1Hz", "u", 9]
             , ["3um",   "1Hz", "d", 9]
             , ["1um",   "1Hz", "u", 9]
             , ["300nm", "1Hz", "d", 9]
             , ["100nm", "1Hz", "u", 9]]
;~ configs.Remove(1)
for index, config in configs
{
    AfmMeasure.execute(config[1], config[2], config[3], config[4])
}


class AfmMeasure
{
    execute(size, rate, u_or_d, capture_minutes)
    {
        ; Do NOT "Show all items" in "Scan Controls".
        
        ; throw if u_or_d not in ["u", "d"]
        
        SetKeyDelay, 500
        WinActivate, NanoScope Control
        
        Send !/r  ; di -> Real-times
        Sleep 2000
        ; Panels -> Scan, Close, Panels -> Scan
        ; To ensure activating "Scan size" and preventing "Show all items".
        Send !ps^{F4}!ps
        Send % size
        
        Send {Down}{Down}{Down}{Down}%rate%
        Send {Up}{Up}{Up}{Up}
        
        Send ^c  ; Capture
        Send !f%u_or_d%  ; Frame -> Up or Down
        
        this.sleep_minute(capture_minutes)
    }

    sleep_minute(minute)
    {
        Sleep % minute * 60 * 1000
    }
}
