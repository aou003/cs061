;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 
; TA: Jang Shing
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_addr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R6, NUM_BITS		;Load 16 into R6

LEADING_BIT			;Checks if the leading bit is 0 or 1
	ADD R1, R1, #0
	BRn IS_NEGATIVE	;If R1 is negative
	BRzp IS_POSITIVE	;If R1 is positive

IS_NEGATIVE
	LD R0, DEC_1
	OUT
	AND R5, R5, x0		;Set R5 to 0
	ADD R6, R6, #-1 		;Increment bit counter
	ADD R5, R6, #0		;R5 has the current number of outputted bits
	ADD R5, R5, #-12		;If 4 bits, print a space
	BRz PRINT_SPACE
	AND R5, R5, x0
	ADD R5, R6, #0
	ADD R5, R5, #-8
	BRz PRINT_SPACE
	AND R5, R5, x0
	ADD R5, R6, #0
	ADD R5, R5, #-4
	Brz PRINT_SPACE
	BRnzp BITSHIFT_LEFT
	
IS_POSITIVE
	LD R0, DEC_0
	OUT
	AND R5, R5, x0
	ADD R6, R6, #-1		;Increment bit counter
	ADD R5, R6, #0		;R5 has the current number of outputted bits
	ADD R5, R5, #-12	;If 4 bits, print a space
	BRz PRINT_SPACE
	AND R5, R5, x0
	ADD R5, R6, #0
	ADD R5, R5, #-8
	BRz PRINT_SPACE
	AND R5, R5, x0
	ADD R5, R6, #0
	ADD R5, R5, #-4
	BRz PRINT_SPACE
	BRnzp BITSHIFT_LEFT
	
BITSHIFT_LEFT
	ADD R1, R1, R1
	ADD R6, R6, #0
	BRz END_PROGRAM
	BRnp LEADING_BIT
	
PRINT_SPACE
	ADD R1, R1, R1
	LD R0, SPACE
	OUT
	BRnzp LEADING_BIT

END_PROGRAM
LD R0, NEWLINE
OUT
	

HALT
;---------------	
;Data
;---------------
Value_addr	.FILL xB800	; The address where value to be displayed is stored
NUM_BITS .FILL #16
NEWLINE .FILL '\n'
SPACE .FILL ' '
DEC_0 .FILL '0'
DEC_1 .FILL '1'


.ORIG xB800					; Remote data
Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
