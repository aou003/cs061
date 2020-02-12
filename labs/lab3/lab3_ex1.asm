;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 022
; TA: Enoch Lim
; 
;=================================================
.ORIG x3000 ;Starting address of program
;-------------------
;Instructions
;-------------------
LD R3, DATA_PTR
ADD R4, R3, #1

LDR R1, R3, #0
LDR R2, R4, #0

ADD R1, R1, #1
ADD R2, R2, #1

STR R1, R3, #0
STR R2, R4, #0


HALT

;-------------------
;Local Data
;-------------------
DATA_PTR .FILL x4000

;;Remote Data
.orig x4000
NEW_DEC_65 .FILL #65
NEW_HEX_41 .FILL x41
