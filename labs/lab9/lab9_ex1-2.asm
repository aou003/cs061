;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 
; TA: Enoch
; 
;=================================================
; test harness
.ORIG x3000
;=================================================
LD R4, STACK_BASE					;Initialize base, max, top
LD R5, STACK_MAX
LD R6, STACK_TOS

;Example 1: Test pushing to stack
;I loop through a stack of size 5 until it hits an overflow error
;When this happens, I store a negative value in R0 so it knows to stop
;...the program
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
		HALT
	
	
;-----------------------------------------------------------------------------------------------
; test harness local data:
INPUT_STRING .STRINGZ "Enter value to push into stack: "
PUSH_DONE	 .STRINGZ "Ending example 1...the stack is now full\n"
POP_DONE	 .STRINGZ "Ending example 2... the stack is now empty\n"
PUSHING		 .STRINGZ "Pushing... \n"
POPPING		 .STRINGZ "\nPopping...\n"
STACK_BASE	.FILL xA000
STACK_MAX   .FILL xA005
STACK_TOS	.FILL xA000
SUB_STACK_PUSH_PTR 	.FILL x3200
SUB_STACK_POP_PTR 	.FILL x3400
CHAR_1 .FILL '1'





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
.ORIG x3200
;------------------------------------------------------------------------------------------
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
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3400
;------------------------------------------------------------------------------------------
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
	LD R0, DEC_0
	STR R0, R6, #0
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

