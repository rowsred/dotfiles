#Requires AutoHotkey v2.0
#SingleInstance Force

; WAJIB: Jalankan script ini sebagai Administrator
if not A_IsAdmin {
    Run('*RunAs "' A_ScriptFullPath '"')
    ExitApp()
}

; ==========================================
; 1. JINAKKAN HOTKEY WINDOWS (L & R) - KIRI & KANAN
; ==========================================

; Mengatasi Win + L (Lock Screen) dari kiri maupun kanan
$#l:: {
    Send("{LWin Up}{RWin Up}") ; Lepas paksa kedua tombol Win
    Send("!l")                 ; Kirim Alt + L
}

; Mengatasi Win + R (Run Dialog) dari kiri maupun kanan
$#r:: {
    Send("{LWin Up}{RWin Up}") 
    Send("!r")                 ; Kirim Alt + R
}

; ==========================================
; 2. SWAP LWIN <-> LALT (SISI KIRI)
; ==========================================

$LAlt:: {
    Send("{LWin Down}")
    KeyWait("LAlt")
    Send("{LWin Up}")
}

$LWin:: {
    Send("{LAlt Down}")
    KeyWait("LWin")
    Send("{LAlt Up}")
}

; ==========================================
; 3. SWAP RWIN <-> RALT (SISI KANAN)
; ==========================================

$RAlt:: {
    Send("{RWin Down}")
    KeyWait("RAlt")
    Send("{RWin Up}")
}

$RWin:: {
    Send("{RAlt Down}")
    KeyWait("RWin")
    Send("{RAlt Up}")
}

; ==========================================
; 4. ANTI-GLITCH MENU START
; ==========================================
~LWin Up:: {
    Send("{Blur}")
}
~RWin Up:: {
    Send("{Blur}")
}
