;=======================================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 022
; TA: Jang Shing
; 
;=======================================================================
.ORIG x3000
;=======================================================================
LD R1, STRING_PTR
LD R7, SUB_GET_STRING_PTR	;Load address of subroutine into R7

JSRR R7						;Go to subroutine

LD R0, STRING_PTR			;Load address of string pointer into R0
PUTS						;Print characters until hits null character

HALT

;Local Data (main)
STRING_PTR .FILL STRING
SUB_GET_STRING_PTR .FILL x3200

;Remote Data
.ORIG x3400
STRING .BLKW #100

;=======================================================================
;Subroutine: SUB_GET_STRING
;Paramter(R1): The starting address of the character array
;Postcondition: The subroutine has prompted the user to input a string
;				terminated by the [ENTER] key (sentinel) and has stored
;				the recieved characters in an array of characters 
;				starting at (R1). The array is NULL-terminated. Do not 
;				store the sentinel
;Return Value(R5): The number of non-sentinel characters read from user.
;					R1 contains the starting address of the array unchanged.
;=======================================================================
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
AND R2, R2, x0			;Set contents of R2 to 0
AND R5, R5, x0			;Sets the contents of R5 to 0
AND R3, R3, x0			;Sets the contents of R3 to 0
ADD R2, R1, x0			;Store starting address of string into R2

LEA R0, INTRO_MSG		;Load address of INTO_MSG into R0
PUTS					;Display INTRO_MSG

LOOP
	GETC				;Store user input (char) into R0
	OUT					;Display Character
	ADD R3, R0, x0		;Move contents of R0 to R3
	ADD R3, R3, #-10		;Check for newline
	BRz NULL_TERMINATE_STRING
	STR R0, R2, #0		;Store value in R0 to &(R2+0)
	ADD R2, R2, x1		;Increment pointer 
	ADD R5, R5, x1		;Increment non-sentinel counter
	BRnp LOOP
	
NULL_TERMINATE_STRING
	LD R0, NULL_CHAR
	STR R0, R2, #0

; 3. Restore Registers
LD R0, BACKUP_R0_3200
LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200
; 4. Return
RET

;Subroutine Data
BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R6_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1
INTRO_MSG .STRINGZ "Please enter string(press enter to exit):"
NULL_CHAR .FILL x0
.END
