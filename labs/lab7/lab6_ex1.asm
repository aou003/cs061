;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 022
; TA: Enoch
; 
;=================================================
.ORIG x3000
;=================================================
LD R7, SUB_LOADVAL_PTR	;Invoke subroutine 1
JSRR R7

ADD R1, R1, #1		;Add 1 to the number

LD R7, SUB_PRINTVAL_PTR		;Invoke subroutine 2
JSRR R7


HALT
;---------------------------
;Test Harness Data
;---------------------------
SUB_LOADVAL_PTR .FILL x3200
SUB_PRINTVAL_PTR .FILL x3400

;=======================================================================
;Subroutine(1): SUB_LOADVAL
;Return Value(R1): Takes a hardcoded value and loads it into a register
;=======================================================================
.ORIG x3200
;=======================================================================
ST R7, BACKUP_R7_3200

LD R1, VALUE

LD R7, BACKUP_R7_3200

RET
;---------------------------
;Subroutine 1 Data
;---------------------------
BACKUP_R7_3200 .BLKW #1
VALUE .FILL #1234

;=======================================================================
;Subroutine(2): SUB_PRINTVAL
;Parameter(R1): Takes the value in the register and prints it to the
;				console
;=======================================================================
.ORIG x3400
;=======================================================================
ST R7, BACKUP_R7_3400

ADD R2, R1, #0		;R2 <- R1
LD R4, COUNTER		; R4 <- 0
LD R5, TO_ASCII
LD R6, NUM_DIGITS	; R6 <- 4


;LD R3, NEG_TEN_THOUSAND
;ADD R2, R2, R3
;BRn RESET_VALUE

;RESET_VALUE
;	ADD R2, R2, R3
;	BRp LOOP_1

;LOOP_0
;	ADD R2, R2, R3
;	BRn PRINT_TEN_THOUSANDS
;	ADD R4, R4, #1
;	BRzp LOOP_0
	
LD R3, NEG_ONE_THOUSAND	;R3 <- -1000
LOOP_1
	ADD R2, R2, R3		;Subtract value in R2 by 1000
	BRn PRINT_THOUSANDS	;If negative, print digit
	ADD R4, R4, #1		;Increment Counter
	BRzp LOOP_1
	
LOOP_2
	LD R3, NEG_ONE_HUNDRED
	ADD R2, R2, R3			;Subtract value in R2 by 100
	BRn PRINT_HUNDREDS		;If negative, print digit
	ADD R4, R4, #1			;Increment Counter
	BRzp LOOP_2
	
LOOP_3
	LD R3, NEG_10
	ADD R2, R2, R3
	BRn PRINT_TENS
	ADD R4, R4, #1
	BRzp LOOP_3
	
LOOP_4
	LD R3, NEG_1
	ADD R2, R2, R3
	BRn PRINT_ONES
	ADD R4, R4, #1
	BRzp LOOP_4
	
PRINT_TEN_THOUSANDS
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRz END_PROGRAM
	ADD R2, R1, #0
	BRp CONV_TO_THOUSANDS
	
PRINT_THOUSANDS
	ADD R0, R4, #0		;Convert from decimal to ascii
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1		;Decrement digit counter
	BRz END_PROGRAM		;If no more digits, end program
	ADD R2, R1, #0		;Reset R2 to original value
	BRp CONV_TO_HUNDREDS

PRINT_HUNDREDS
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRz END_PROGRAM
	BRnp CONV_TO_TENS
	
PRINT_TENS
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRnzp END_PROGRAM
	BRnp CONV_TO_ONES
	
PRINT_ONES
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRnzp END_PROGRAM

CONV_TO_THOUSANDS
	ADD R2, R2, R3		;Add 10,000 to R2
	AND R4, R4, x0
	BRz LOOP_1
	BRp CONV_TO_THOUSANDS
	
	
CONV_TO_HUNDREDS
	ADD R2, R2, R3		;Add 1000 to R2
	;ADD R4, R4, #-1		;Decrement R4 (thousands counter)
	AND R4, R4, x0
	BRz LOOP_2			;When in 100's range, go to loop2
	BRp CONV_TO_HUNDREDS

CONV_TO_TENS
	LD R3, POS_ONE_HUNDRED
	ADD R2, R2, R3
	AND R4, R4, x0
	BRz LOOP_3
	BRp CONV_TO_TENS
	
CONV_TO_ONES
	LD R3, POS_10
	ADD R2, R2, R3
	AND R4, R4, x0
	BRzp LOOP_4
	
	
END_PROGRAM
LD R7, BACKUP_R7_3400
RET
	
	

;-------------------------
;Subroutine 2 Data
;-------------------------
BACKUP_R7_3400 .BLKW #1
NEG_TEN_THOUSAND .FILL #-10000
POS_TEN_THOUSAND .FILL #10000
NEG_ONE_THOUSAND .FILL #-1000
NEG_ONE_HUNDRED .FILL #-100
POS_ONE_HUNDRED .FILL #100
NEG_10 .FILL #-10
POS_10 .FILL #10
NEG_1 .FILL #-1
TO_ASCII .FILL #48
NUM_DIGITS .FILL #4



COUNTER .FILL #0

.END
