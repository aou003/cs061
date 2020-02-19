;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 022
; TA: Enoch
; 
;=================================================
.ORIG x3000
;=================================================
AND R1, R1, x0		;Will hold the # of binary 1's
AND R2, R2, x0		;Contains a copy of the value in R0
AND R3, R3, x0

LEA R0, INTRO_MSG	;Load & of message into R0
PUTS				;Display message
GETC 
OUT

ADD R3, R0, #0		;R3 will hold R0 contents

LD R7, SUB_COUNT_1_PTR		;Load subroutine & into R7
JSRR R7						;Go to subroutine

LD R0, NEWLINE
OUT

LEA R0, END_MSG_PT1		;Message part 1
PUTS
	
ADD R0, R3, #0			;Display user input character
OUT

LEA R0, END_MSG_PT2		;Message part 2
PUTS

ADD R0, R1, #0		;Convert # of 1's from decimal to ASCII
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
ADD R0, R0, #12
OUT					;Display count

LD R0, NEWLINE
OUT
HALT
;---------------------------
;Local Data
;---------------------------
INTRO_MSG .STRINGZ "Enter a single character from the keyboard: "
END_MSG_PT1 .STRINGZ "The number of 1's in '"
END_MSG_PT2 .STRINGZ "' is: "
NEWLINE .FILL '\n'
SUB_COUNT_1_PTR .FILL x3400

;=======================================================================
;Subroutine: SUB_COUNT_1
;Parameter(R0): The character that the user has entered
;Return Value(R1): The number of binary 1's of the character
;=======================================================================
.ORIG x3400
;=======================================================================
ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R7, BACKUP_R7_3400

ADD R2, R0, #0		;R2 <- R0
LD R6, NUM_BITS		;R6 <- 16
LD R1, COUNTER		;R1 <- 0

LOOP
	ADD R2, R2, #0	;LEA R2
	BRn ONE			;If neg, increment 1 count
	BRzp LEFT_SHIFT	;Else, left shift
	
ONE
	ADD R1, R1, #1
	ADD R2, R2, R2
	ADD R6, R6, #-1
	BRz END_SUBROUTINE
	BRnp LOOP
	
LEFT_SHIFT
	ADD R2, R2, R2
	ADD R6, R6, #-1
	BRz END_SUBROUTINE
	BRnp LOOP
	
	
END_SUBROUTINE
LD R0, BACKUP_R0_3400
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R7_3400
RET
;---------------------------
;Subroutine Data
;---------------------------
BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1
BACKUP_R2_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1

NUM_BITS .FILL #16
COUNTER .FILL #0	;Count the numbers of binary 1's

.END
