#Include filenames.ahk
#include list2lists.ahk

; Right click "H" mark in the taskbar to stop.

MsgBox

SetKeyDelay 100 ; 20ms too fast
filenamess := list2lists(filenames(), 23)
;~ filenamess.Remove(1, 5)
height_ranges := [1, 2, 3, 5, 10]
;~ height_ranges.Remove(1, 2)
export_dirs := []
for _i, h in height_ranges
    export_dirs.Push("D:\ashihara\img-AFM\top-img-AFM\" h "nm-top-img-AFM")
AfmExport.export_jpg_all_var_range(export_dirs, filenamess, height_ranges)

        
class AfmExport
{
    export_jpg_selected(export_dir, filename, height_range)
    {
        ; Select a file in off-line menu before.
        
        ;~ Send !/o  ; di -> Off-line
                WinActivate, NanoScope Control
        Send {Enter}  ; open the active file
        ; If a dialog of "Save" confirmation appears, reply "No".
        Send !n
        Send !iL  ; Image -> Left
        ; View -> Top -> Data cale, apply, exit
        Send !vt{Down}{Down}%height_range%n{Enter}{Enter}
        ;~ Send !fs  ; File -> Save
        Send !u{Up}{Up}{Up}{Enter}  ; Utility -> JPEG Export
        Send {Tab}
        SendInput % export_dir
        Send {Tab}
        SendInput % filename "_" height_range "nm.jpg"
        Send {Enter}
        Send !y  ; "YES" if "override?" dialog
        Sleep 100  ; Wait for saving
        Send {Esc}  ; Deactivate "Utility" menu
    }
    
    export_jpg_all(export_dir, filenamess, height_range)
    {
        ; Select the first file in off-line menu before.
        ; Assuming all the files under processing are AFM data files,
        ; not including jpg, txt or so on.
        for _i1, filenames in filenamess
        {
            for _i2, filename in filenames
            {
                ; todo: if filename does not end with ".afm", skip export.
                this.export_jpg_selected(export_dir, filename, height_range)
                Send {Down}  ; Select next file
            }
            Send {Up 50}  ; Select top, hard coded
            Send {Right}  ; Select next column
        }
    }
    
    export_jpg_all_var_range(export_dirs, filenamess, height_ranges)
    {
        ; Read the comment in export_jpg_all.
        for i, height_range in height_ranges
        {
            export_dir := export_dirs[i]
            this.export_jpg_all(export_dir, filenamess, height_range)
            Send {Left 100}  ; Select left top, hard coded
        }
    }
}
