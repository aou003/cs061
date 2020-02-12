;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 2, ex 4
; Lab section: 022
; TA: Enoch
; 
;=================================================
.ORIG x3000 ;Starting address of program

;------------
;Instructions
;------------
LD R0, HEX_61
LD R1, HEX_1A

LOOP
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp LOOP

HALT

;-------------
;Local Data
;-------------
HEX_61 .FILL x61
HEX_1A .FILL x1A

.END
