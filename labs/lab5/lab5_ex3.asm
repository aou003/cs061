;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 5, ex 3
; Lab section: 022
; TA: Jang Shing
; 
;=================================================
.ORIG x3000
;--------------
;Instructions
;--------------
LD R1, SUB_ENTER_BINARY_PTR
JSRR R1							;Jump to Subroutine to convert string to binary
LD R6, NUM_BITS					;Load R6 with 16

LEADING_BIT
	ADD R1, R1, #0;
	BRn IS_NEGATIVE
	BRp IS_POSITIVE
	
IS_NEGATIVE
	LD R0, CHAR_1
	OUT
	AND R5, R5, x0
	ADD R6, R6, #-1
	ADD R5, R6, #0
	ADD R5, R5, #-12
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
	LD R0, CHAR_0
	OUT
	AND R5, R5, x0
	ADD R6, R6, #-1		
	ADD R5, R6, #0		
	ADD R5, R5, #-12	
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
;Local Data
;---------------
NUM_BITS .FILL #16
CHAR_0 .FILL '0'
CHAR_1 .FILL '1'
SPACE .FILL ' '
NEWLINE .FILL '\n'
SUB_ENTER_BINARY_PTR .FILL x3200
HALT

;=================================================
;Subroutine: SUB_ENTER_BINARY_3200
;Input:
;PostCondition:
;Return Value: 16 bit binary number
;=================================================
.ORIG x3200

; 1. Backup Registers
ST R0, BACKUP_R0_3200
ST R1, BACKUP_R1_3200
ST R2, BACKUP_R2_3200
ST R3, BACKUP_R3_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200
ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200
; 2. Algorithm

BEGIN_INPUT
	AND R1,R1, x0
	LD R3, COUNTER
	LEA R0, INTRO_MSG
	PUTS
	GETC		;User enters 'b'
	ADD R0, R0, #0
	BRnzp CHECK_FOR_B

DO_WHILE
	GETC	;Enter character (0,1)
	BRnzp CHECK_INPUT
	ADD R3, R3, #0
	BRz EXIT_SUBROUTINE
	
CHECK_INPUT
	ADD R6, R0, #0
	ADD R6, R6, #-16
	ADD R6, R6, #-16
	ADD R6, R6, #-16
	BRz IS_ZERO
	ADD R6, R6, #-1
	BRz ENTERED_ONE
	ADD R6, R0, #0
	ADD R6, R6, #-16
	ADD R6, R6, #-16
	BRz OUT_SPACE
	BRnp PRINT_ERROR
	
CHECK_FOR_B
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	ADD R0, R0, #-14
	BRz PRINT_B
	BRnp PRINT_ERROR
	
PRINT_B
	LD R0, CHAR_B
	OUT
	BRnzp DO_WHILE

OUT_SPACE
	LD R0, S_SPACE
	OUT
	BRnzp DO_WHILE

	
IS_ZERO
	OUT
	ADD R1, R1, R1 	;Left bit-shift (multiply by 2)
	ADD R1, R1, #0
	ADD R3, R3, #-1	;Decrement bit counter
	BRz EXIT_SUBROUTINE
	BRp DO_WHILE

ENTERED_ONE
	OUT
	ADD R1, R1, R1 ;Left bit-shift (multiply by 2)
	ADD R1, R1, #1
	ADD R3, R3, #-1	;Decrement bit counter
	BRz EXIT_SUBROUTINE
	BRp DO_WHILE

PRINT_ERROR
	LEA R0, ERROR_MSG
	PUTS
	LD R0, NEW_LINE
	OUT
	BRnzp BEGIN_INPUT

EXIT_SUBROUTINE
	LD R0, NEW_LINE
	OUT
; 3. Restore Registers
LD R0, BACKUP_R0_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200
LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200
; 4. Return
RET


;Local Data for Subroutine 
BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R6_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1
INTRO_MSG .STRINGZ "Enter 16 bit binary number: "
COUNTER .FILL #16
;ASCII_TO_DEC .FILL #-16
DEC_0 .FILL #0
S_SPACE .FILL ' '
NEW_LINE .FILL '\n'
CHAR_B .FILL 'b'
ERROR_MSG .STRINGZ "ERROR! MUST ENTER VALID INPUT"


;=================================================
;End Subroutine
;=================================================
.END
