;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 022
; TA: Enoch Lim
; 
;=================================================
.ORIG x3000
;----------------
;Instructions
;----------------
LD R1, ARRAY_PTR
LD R2, NUM_CHARS
LEA R0, PROMPT
PUTS

DO_WHILE
	GETC
	OUT
	STR R0, R1, #0
	ADD R1, R1, #1
	ADD R2, R2, #-1
	BRp DO_WHILE

LD R1, ARRAY_PTR
LD R2, NUM_CHARS
LD R0, NEWLINE
OUT

PRINT_LOOP
	LDR R0, R1, #0
	OUT
	LD R0, NEWLINE
	OUT
	ADD R1, R1, #1
	ADD R2, R2, #-1
	BRp PRINT_LOOP
	

	

HALT
;------------------
;Local Data
;------------------
ARRAY_PTR .FILL CHAR_ARRAY
CHAR_ARRAY .BLKW #10
NUM_CHARS .FILL #10
PROMPT .STRINGZ "Please enter 10 characters: "
NEWLINE .FILL x0A

.END
