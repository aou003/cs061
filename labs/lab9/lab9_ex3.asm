;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 9, ex 3
; Lab section: 022
; TA: Enoch
; 
;=================================================
; test harness
.orig x3000

LD R4, STACK_BASE					;Initialize base, max, top
LD R5, STACK_MAX
LD R6, STACK_TOS

;Example 1: Test pushing to stack
;I loop through a stack of size 5 until it hits an overflow error
;When this happens, I store a negative value in R0 so it knows to stop
;...this example and go to example 2
EXAMPLE_1
	LEA R0, PUSHING
	PUTS
	LD R0, CHAR_1			;'1'

	INPUT_LOOP							;print character
		LD R7, SUB_STACK_PUSH_PTR		;go to push subroutine
		JSRR R7
		ADD R0, R0, #0					;check if negative
		BRn END_TEST_HARNESS_1			;indicates overflow!
		OUT
		ADD R0, R0, #1
		BRp INPUT_LOOP
					 
		
	END_TEST_HARNESS_1					;end example 1 test
		LEA R0, PUSH_DONE
		PUTS			
		BRnzp EXAMPLE_2
	
;Example 2: Testing popping from a stack
;I loop through the stack (full) of size 5 until it hits an underlow error
;When this happens, I store a negative value in R0 so it knows to stop
;...this example and go to example 3
EXAMPLE_2

	LEA R0, POPPING
	PUTS
	
	POP_LOOP
		LD R7, SUB_STACK_POP_PTR
		JSRR R7
		ADD R0, R0, #0
		BRn END_TEST_HARNESS_2
		BRzp POP_LOOP
		
	END_TEST_HARNESS_2
		LEA R0, POP_DONE
		PUTS
		BRnzp EXAMPLE_3
		
EXAMPLE_3
	LD R0, RPN_NEWLINE
	OUT
	LEA R0, RPN_PROMPT_1
	PUTS
	GETC
	OUT
	ADD R0, R0, #-12
	ADD R0, R0, #-12
	ADD R0, R0, #-12	
	ADD R0, R0, #-12					;Convert to dec #
	LD R7, SUB_STACK_PUSH_PTR			;Push value 1 onto stack
	JSRR R7


	LD R0, RPN_NEWLINE
	OUT

	LEA R0, RPN_PROMPT_2
	PUTS
	GETC
	OUT
	ADD R0, R0, #-12
	ADD R0, R0, #-12
	ADD R0, R0, #-12
	ADD R0, R0, #-12					;Convert to dec #
	LD R7, SUB_STACK_PUSH_PTR			;Push value 2 onto stack
	JSRR R7
	
	LD R0, RPN_NEWLINE
	OUT

	LEA R0, RPN_PROMPT_3
	PUTS			
	GETC						;Enter operand
	OUT	 
	
	LD R7, SUB_RPN_PTR
	JSRR R7
	
	LD R0, RPN_NEWLINE
	OUT
	LD R7, SUB_STACK_PRINT_PTR
	JSRR R7
	
	HALT
				 
;-----------------------------------------------------------------------------------------------
; test harness local data:
PUSH_DONE	 .STRINGZ "Ending example 1...the stack is now full\n"
POP_DONE	 .STRINGZ "Ending example 2... the stack is now empty\n"
PUSHING		 .STRINGZ "Pushing... \n"
POPPING		 .STRINGZ "\nPopping...\n"
STACK_BASE	.FILL xA000
STACK_MAX   .FILL xA005
STACK_TOS	.FILL xA000
SUB_STACK_PUSH_PTR 	.FILL x3200
SUB_STACK_POP_PTR 	.FILL x3400
SUB_STACK_PRINT_PTR	.FILL x3800
SUB_RPN_PTR			.FILL x3600
CHAR_1 .FILL '1'

RPN_PROMPT_1 .STRINGZ "Enter operand 1 for multipliction: "
RPN_PROMPT_2 .STRINGZ "Enter operand 2 for multiplication: "
RPN_PROMPT_3 .STRINGZ "Enter operand: "
RPN_NEWLINE .FILL '\n'




;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
	
	ST R7, BACKUP_R7_3200

IS_STACK_FULL
	ADD R2, R6, #0			;R2 <- [R6]+0
	NOT R2, R2		
	ADD R2, R2, #1
	ADD R2, R5, R2
	BRz OVERFLOW_ERROR
	BRnp PUSH_TO_STACK
	
OVERFLOW_ERROR
	LEA R0, OVERFLOW_MSG
	PUTS
	AND R0, R0, x0
	ADD R0, R0, #-1
	BRnzp END_SUB_STACK_PUSH
	
PUSH_TO_STACK
	STR R0, R6, #1			;Move value in R0 to base+1
	ADD R6, R6, #1			;Incriment top of stack pointer
	BRnzp END_SUB_STACK_PUSH
					 
				 
END_SUB_STACK_PUSH	
	LD R7, BACKUP_R7_3200	
	RET			 
				 	
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
BACKUP_R7_3200	.BLKW	#1
OVERFLOW_MSG	.STRINGZ "\nOverflow Error!\n"



;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      ;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
ST R7, BACKUP_R7_3400

IS_STACK_EMPTY
	ADD R2, R6, #0
	NOT R2, R2
	ADD R2, R2, #1
	ADD R2, R2, R4
	BRz UNDERFLOW_ERROR
	BRnp POP_FROM_STACK
	
POP_FROM_STACK
	LDR R0, R6, #0
	OUT
	;R0, DEC_0
	;STR R0, R6, #0
	ADD R6, R6, #-1 
	BRnzp END_SUB_STACK_POP
	
UNDERFLOW_ERROR
	LEA R0, UNDERFLOW_MSG
	PUTS
	AND R0, R0, x0
	ADD R0, R0, #-1
	BRnzp END_SUB_STACK_POP
				 				 
END_SUB_STACK_POP
	LD R7, BACKUP_R7_3400			
	RET			 
				 
				 
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
BACKUP_R7_3400	.BLKW #1
UNDERFLOW_MSG	.STRINGZ "\nUnderflow Error!!!\n"
DEC_0			.FILL #0


;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
.orig x3600

ST R7, BACKUP_R7_3600
ST R6, TOP					;Store current Top address

LD R1, POP_PTR				;Pop first value
JSRR R1

LD R7, TOP			;At this point, R0 should contain the first value to be multiplied
ADD R7, R7, #-1
ST R7, TOP			;Update new top of stack

LDR R1, R7, #0

AND R3, R3, #0
ADD R6, R6, #0

MULTIPLY_1
	ADD R3, R3, R0
	ADD R1, R1, #-1
	BRp MULTIPLY_1
	BRnz PUSH_PRODUCT
	
PUSH_PRODUCT
	LD R2, POP_PTR
	JSRR R2
	ADD R0, R3, #0
	LD R2, PUSH_PTR
	JSRR R2
	BRnzp END_RPN
				 
END_RPN	
	LD R7, BACKUP_R7_3600
	RET
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

BACKUP_R7_3600	.BLKW #1
POP_PTR	.FILL x3400
PUSH_PTR .FILL x3200
TOP		.BLKW #1





;===============================================================================================	
; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;					You can use your lab 7 s/r.
;Takes the value at the top of the stack and prints it to the console
.ORIG x3800

ST R7, BACKUP_R7_3800
ST R4, BACKUP_R4_3800
ST R5, BACKUP_R5_3800
ST R6, BACKUP_R6_3800

LDR R1, R6, #0
ADD R2, R1, #0		;R2 <- R1
LD R4, COUNTER		; R4 <- 0
LD R5, TO_ASCII
AND R6, R6, x0

CHECK_MAGNITUDE
    LD R3, NEG_TEN_THOUSAND
    ADD R2, R2, R3
    BRp RESET_FOR_0
    
    ADD R2, R1, #0
    LD R3, NEG_ONE_THOUSAND
    ADD R2, R2, R3
    BRp RESET_FOR_1
    
    ADD R2, R1, #0
    LD R3, NEG_ONE_HUNDRED
    ADD R2, R2, R3
    BRp RESET_FOR_2
    
    LD R3, NEG_10
    ADD R2, R1, #0
    ADD R2, R2, R3
    BRp RESET_FOR_3
    
    LD R3, NEG_1
    ADD R2, R1, #0
    ADD R2, R2, R3
    BRp RESET_FOR_4

RESET_FOR_0
    ADD R2, R1, #0
    ADD R6, R6, #5
    BRnzp LOOP_0
    
RESET_FOR_1
    ADD R2, R1, #0
    ADD R6, R6, #4
    BRnzp LOOP_1
    
RESET_FOR_2
    ADD R2, R1, #0
    ADD R6, R6, #3
    BRnzp LOOP_2
    
RESET_FOR_3
    ADD R2, R1, #0
    ADD R6, R6, #2
    BRnzp LOOP_3
    
RESET_FOR_4
    ADD R2, R1, #0
    ADD R6, R6, #1
    BRnzp LOOP_4

LOOP_0
    LD R3, NEG_TEN_THOUSAND
	ADD R2, R2, R3
	BRn PRINT_TEN_THOUSANDS
	ADD R4, R4, #1
	BRzp LOOP_0
	
LOOP_1
	LD R3, NEG_ONE_THOUSAND
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
	BRp CONV_TO_THOUSANDS
	
PRINT_THOUSANDS
	ADD R0, R4, #0		;Convert from decimal to ascii
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1		;Decrement digit counter
	BRp CONV_TO_HUNDREDS

PRINT_HUNDREDS
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRnp CONV_TO_TENS
	
PRINT_TENS
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRnp CONV_TO_ONES
	
PRINT_ONES
	ADD R0, R4, #0
	ADD R0, R0, R5
	OUT
	ADD R6, R6, #-1
	BRnzp END_PROGRAM

CONV_TO_THOUSANDS
	LD R3, POS_TEN_THOUSAND
	ADD R2, R2, R3		;Add 10,000 to R2
	AND R4, R4, x0
	BRz LOOP_1
	BRp CONV_TO_THOUSANDS
	
	
CONV_TO_HUNDREDS
	LD R3, POS_ONE_THOUSAND
	ADD R2, R2, R3		;Add 1000 to R2
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
	BRnzp LOOP_4
	
	
END_PROGRAM
LD R7, BACKUP_R7_3800
LD R4, BACKUP_R4_3800
LD R5, BACKUP_R5_3800
LD R6, BACKUP_R6_3800
RET


;Subroutine PRINT_DECIMAL data
BACKUP_R7_3800 .BLKW #1
BACKUP_R4_3800	.BLKW #1
BACKUP_R5_3800	.BLKW #1
BACKUP_R6_3800	.BLKW #1
NEG_TEN_THOUSAND .FILL #-10000
POS_TEN_THOUSAND .FILL #10000
NEG_ONE_THOUSAND .FILL #-1000
POS_ONE_THOUSAND .FILL #1000
NEG_ONE_HUNDRED .FILL #-100
POS_ONE_HUNDRED .FILL #100
NEG_10 .FILL #-10
POS_10 .FILL #10
NEG_1 .FILL #-1
TO_ASCII .FILL #48
NUM_DIGITS .FILL #4



COUNTER .FILL #0



