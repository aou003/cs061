;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 6, ex 2
; Lab section: 022
; TA: Jang Shing
; 
;=================================================
.ORIG x3000
;=================================================
LD R1, STRING_PTR
LD R7, SUB_GET_STRING_PTR	;Load address of subroutine into R7
JSRR R7						;Go to subroutine

LD R0, STRING_PTR			;Load address of string pointer into R0
PUTS						;Print characters until hits null character
LD R0, NEWLINE
OUT

LD R7,SUB_IS_A_PALINDROME_PTR
JSRR R7 

HALT

;Local Data (main)
STRING_PTR .FILL STRING
SUB_GET_STRING_PTR .FILL x3200
SUB_IS_A_PALINDROME_PTR .FILL x3400
NEWLINE .FILL '\n'

;Remote Data
.ORIG x4000
STRING .BLKW #100

HALT
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


;=======================================================================
;Subroutine: IS_A_PALINDROME
;Paramter(R1): The starting address of a null-terminated string
;Parameter(R5): The number of characters in the array
;Postcondition: The subroutine has determined whether the string at R1 is
;				a palindrome or not, and returned a flag to that effect
;Return Value(R5): The number of non-sentinel characters read from user.
;					R1 contains the starting address of the array unchanged.
;=======================================================================
.ORIG x3400
;=======================================================================
;1. Backup Registers
ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400

;2. Algorithm
AND R2, R2, x0		;Store value of 0 into R2
ADD R2, R1, R5		;Go to null char of the string
ADD R2, R2, #-1 	;Go to last char of string

;R1 should have the address of the first character
;R2 should have the address of the last character

;If the string has 1 letter:
ADD R4, R5, #0
ADD R4, R4, #-1
BRz IS_A_PALINDROME

LDR R3, R1, #0		;Load value in R1 & into R3
LDR R4, R2, #0		;Load value in R2 & into R4

;Test w/two letter string
;LDR R3, R1, #0
;LDR R4, R2, #0
;NOT R4, R4
;ADD R4, R4, #1
;ADD R6, R3, R4
;BRz IS_A_PALINDROME
;BRnp NOT_A_PALINDROME

PALINDROME_LOOP
	NOT R4, R4
	ADD R4, R4, #1
	ADD R6, R3, R4
	BRnp NOT_A_PALINDROME
	
	
NOT_A_PALINDROME
	LEA R0, NOT_PALINDROME_MSG
	PUTS
	BRnzp END_PALINDROME_SUB

IS_A_PALINDROME
	LEA R0, IS_PALINDROME_MSG
	PUTS
	BRnzp END_PALINDROME_SUB
	
END_PALINDROME_SUB

;3. Restore Registers
LD R7, BACKUP_R7_3400
;4. Return
RET

;Subroutine Data
BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1
BACKUP_R2_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
BACKUP_R4_3400 .BLKW #1
BACKUP_R6_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1
NOT_PALINDROME_MSG .STRINGZ "This string is not a palindrome\n"
IS_PALINDROME_MSG .STRINGZ "This string is a palindrome\n"
 

.END


