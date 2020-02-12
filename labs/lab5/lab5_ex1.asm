;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 022
; TA: Jang Shing
; 
;=================================================
.ORIG x3000
;--------------
;Instructions
;--------------
LD R1, BINARY_1
LD R2, ARRAY_PTR
LD R4, MAX_VALUE

DO_WHILE
	STR R1, R2, #0	;Stores value of R1 into the address in (R2+0)
	ADD R2, R2, #1	;Increments the pointer in R2, points to next element in array
	ADD R1, R1, R1	;Multiply R1 by 2
	ADD R3, R1, R4	;Add R1 to -1024, if 0, 512 is reached
	BRnp DO_WHILE
	
LD R5, ARRAY_PTR	;R5 will now have the starting & of the array
ADD R5, R5, #6 	;R5 will now have the & of the 7th element in the array
LDR R2, R5, #0 	;Stores value in (R5+0) into R2

LD R1, ARRAY_PTR
LD R5, MAX_VALUE
ADD R5, R5, #1
LD R6, SUB_CONV_TO_BINARY_PTR	;Load address of subroutine into R6

PRINT_LOOP
	LDR R0, R1, #0	;Load value found at &(R1+0) into R0
	JSRR R6			;Call subroutine to convert value into binary and print it out
	ADD R1, R1, #1	;Increment pointer to array
	ADD R5, R5, R0
	BRnp PRINT_LOOP
	
HALT
;--------------
;Local Data
;--------------
BINARY_1 .FILL x1
ARRAY_PTR .FILL ARRAY
NEWLINE .FILL '\n'
MAX_VALUE .FILL #-1024
ASCII .FILL #16
SUB_CONV_TO_BINARY_PTR .FILL x3200
;--------------
;Remote Data
;--------------
.ORIG x4000
ARRAY .BLKW #10

;=================================================
;Subroutine: SUB_CONV_TO_BINARY_3200
;Input: The register containing the 2^n value (R0). This
;		value is not modified by the program
;PostCondition: Store the binary value into R6 and Print it
;Return Value: 
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
LD R6, NUM_BITS		;Load 16 into R6
ADD R2, R0, #0
LEADING_BIT			;Checks if the leading bit is 0 or 1
	ADD R2, R2, #0
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
	ADD R2, R2, R2
	ADD R6, R6, #0
	BRz END_PROGRAM
	BRnp LEADING_BIT
	
PRINT_SPACE
	ADD R2, R2, R2
	LD R0, SPACE
	OUT
	BRnzp LEADING_BIT

END_PROGRAM
LD R0, NEW_LINE
OUT

; 3. Restore backed up registers
LD R0, BACKUP_R0_3200
LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200
LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200
; 4. Return
RET

;Local Data for Subroutine SUB_CONV_TO_BINARY_3200
BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R6_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1
NUM_BITS .FILL #16
NEW_LINE .FILL '\n'
SPACE .FILL ' '
DEC_0 .FILL '0'
DEC_1 .FILL '1'
;=================================================
;End Subroutine
;=================================================
.END
