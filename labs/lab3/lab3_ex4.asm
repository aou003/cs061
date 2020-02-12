;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 022
; TA: Enoch Lim
; 
;=================================================
.ORIG x3000
;----------------
;Instructions
;----------------
LD R1, ARRAY_PTR
LEA R0, PROMPT
PUTS

DO_WHILE
	GETC			;User enters character (stored into R0)
	OUT				;Character is outputted to console
	STR R0, R1, #0	;Value of R0 is stored into address R1 + 0
	ADD R1, R1, #1	;Increment value of R1 (Array pointer points to next location)
	ADD R0, R0, #-10 ;R0 will contain 0 if the character entered is a newline (dec 10)
	BRnp DO_WHILE

LD R1, ARRAY_PTR

PRINT_LOOP
	LDR R0, R1, #0	;Load the  value found from (R1+0) into R0 (Array Pointer)
	OUT				;Print R0 (first char in Array)
	ADD R4, R0, #0	;Store R0 contents into R4 (R4 will act as a temp storage space)
	LD R0, NEWLINE	;Store newline into R0
	OUT				;Print newline
	ADD R1, R1, #1	;Increment R1 (Array pointer points to next thing)
	ADD R4, R4, #-10	;Check printed character is newline (R4 will contain 0 if so because 10-10=0)
	BRnp PRINT_LOOP		;Branch if R4 contains a value that is not 0

HALT
;------------------
;Local Data
;------------------
NEWLINE .FILL x0A
ARRAY_PTR .FILL x4000
PROMPT .STRINGZ "Please enter characters (enter when done): "

.END
