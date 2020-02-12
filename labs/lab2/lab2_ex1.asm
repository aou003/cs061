;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 2. ex 1
; Lab section: 022
; TA: Enoch Lin
; 
;=================================================
.ORIG x3000 ;Starting address of program

;-------------------
;Instructions
;-------------------
LD R3, DEC_65
LD R4, HEX_41

HALT
;------------------
;Local Data
;------------------
DEC_65 .FILL #65
HEX_41 .FILL x41

.END
