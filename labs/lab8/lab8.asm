;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 022
; TA: Enoch
; 
;=================================================
; Test Harness
.ORIG x3000
;=================================================
LD R7, SUB_PRINT_OPTABLE_PTR
JSRR R7			 

LD R7, SUB_FIND_OPCODE_PTR
JSRR R7


				 
				 
HALT
;-----------------------------------------------------------------------------------------------
; test harness local data:
;-----------------------------------------------------------------------------------------------
SUB_PRINT_OPTABLE_PTR .FILL x3200
SUB_PRINT_OP_PTR .FILL x3400
SUB_FIND_OPCODE_PTR .FILL x3600




;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;		 		 and corresponding opcode in the following format:
;		 		 ADD = 0001
;		  		 AND = 0101
;		  		 BR = 0000
;		  		 …
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3200
;-----------------------------------------------------------------------------------------------
ST R7, BACKUP_R7_3200
LD R1, INSTRUCTIONS_PO_PTR			;R1 will point to instructions
LD R4, OPCODES_PO_PTR

LOOP_INSTRUCTIONS
	LDR R0, R1, #0					;R0 will contain what R1 points to
	BRn END_SUBROUTINE
	OUT								;Display char
	ADD R1, R1, #1					;Incriment instruction pointer
	LDR R3, R1, #0
	BRz PRINT_REMAINING
	BRp LOOP_INSTRUCTIONS
	BRn END_SUBROUTINE

PRINT_REMAINING
	LEA R0, EQUALS
	PUTS
	LD R7, PRINT_OP_PTR
	JSRR R7
	ADD R4, R4, #1
	LD R0, NEWLINE
	OUT
	ADD R1, R1, #1			;Increment R1 so it isnt pointing to a null char
	BRzp LOOP_INSTRUCTIONS
		 
END_SUBROUTINE	
	LD R7, BACKUP_R7_3200
	RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
BACKUP_R7_3200 .BLKW #1
OPCODES_PO_PTR		.fill x4000
INSTRUCTIONS_PO_PTR	.fill x4100
PRINT_OP_PTR .FILL x3400
NEWLINE .FILL #10
EQUALS .STRINGZ " = "


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3400
;-----------------------------------------------------------------------------------------------
ST R7, BACKUP_R7_3400
LD R5, COUNTER

OPCODE_LOOP
	LDR R2, R4, #0
	BRnzp PRINT_OPCODE
	
PRINT_OPCODE
	ADD R2, R2, #0
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	BRnp PRINT_LAST_4
	
PRINT_LAST_4
	ADD R2, R2, #0
	BRn PRINT_1
	BRzp PRINT_0
	
BITSHIFT
	ADD R2, R2, R2
	BRn PRINT_1
	BRzp PRINT_0
	
PRINT_1
	LD R0, CHAR_1
	OUT
	ADD R5, R5, #-1
	BRp BITSHIFT
	BRz END_SUB
	
PRINT_0
	LD R0, CHAR_0
	OUT
	ADD R5, R5, #-1
	BRp BITSHIFT
	BRz END_SUB
	
END_SUB	
	LD R7, BACKUP_R7_3400
	RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
;-----------------------------------------------------------------------------------------------
BACKUP_R7_3400 .BLKW #1
;OPCODES_PO_PTR		.fill x4000
COUNTER .FILL #4
CHAR_1 .FILL '1'
CHAR_0 .FILL '0'



;===============================================================================================
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3600
;-----------------------------------------------------------------------------------------------
ST R7, BACKUP_R7_3600

LD R2, INPUT_STRING_PTR		;R2 <- x4200
LD R7, SUB_GET_STRING_PTR	;GO to GET_STRING subroutine
JSRR R7		

LD R3, instructions_fo_ptr	;R3 <- x4100
LD R4, opcodes_fo_ptr		;R4 <- x4000
LD R2, INPUT_STRING_PTR

AND R5, R5, x0		;R5: instruction table char
AND R6, R6, x0	 	;R6: user input char
AND R1, R1, x0		;Used to check parity
	
INSTRUCTION_LOOP
	LDR R5, R3, x0	;R5 will have characters from instruction table
	LDR R6, R2, x0	;R6 will have characters from user input
	ADD R1, R5, R6
	BRz PRINT_STUFF_1
	NOT R6, R6
	ADD R6, R6, #1	;Twos complement of R6
	ADD R1, R5, R6
	BRnp GO_TO_NEXT_INSTRUCTION
	ADD R3, R3, #1	;Incriment pointers
	ADD R2, R2, #1
	BRnp INSTRUCTION_LOOP
	
GO_TO_NEXT_INSTRUCTION
	ADD R3, R3, #1		;incriment instruction pointer
	LDR R5, R3, #0		;load char into R5. If null, go to reset input string ptr
	BRz RESET_INPUT_STRING
	BRp GO_TO_NEXT_INSTRUCTION
	BRn PRINT_ERROR_MSG	;if negative, reached end of table, print error
	
	
CHECK_IF_END_OF_TABLE
	ADD R3, R3, #1
	LDR R5, R3, #0
	BRn PRINT_ERROR_MSG
	ADD R3, R3, #-1
	BRnzp RESET_INPUT_STRING
	
RESET_INPUT_STRING
	ADD R4, R4, #1		;Incriment opcode ptr
	LD R2, INPUT_STRING_PTR
	ADD R3, R3, #1
	BRnzp INSTRUCTION_LOOP
	
PRINT_STUFF_1
	LD R2, INPUT_STRING_PTR
	INPUT_PRINT_LOOP
		LDR R0, R2, #0
		OUT
		ADD R2, R2, #1
		LDR R1, R2, #0
		BRz PRINT_STUFF_2
		BRp INPUT_PRINT_LOOP

PRINT_STUFF_2
	LEA R0, EQUAL
	PUTS
	LD R7, SUB_PRINT_OPCODE_PTR
	JSRR R7
	LD R0, newline
	OUT
	BRnzp END_FIND_OP_SUB


PRINT_ERROR_MSG
	LEA R0, ERROR_MSG
	PUTS
	BRnzp END_FIND_OP_SUB
				 
END_FIND_OP_SUB			 
	LD R7, BACKUP_R7_3600			 
	RET
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
;-----------------------------------------------------------------------------------------------
BACKUP_R7_3600			.BLKW #1
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100
SUB_GET_STRING_PTR		.FILL x3800
SUB_PRINT_OPCODE_PTR 	.FILL x3400
INPUT_STRING_PTR		.FILL x4200
ERROR_MSG 				.STRINGZ "invalid instruction\n"
EQUAL                   .STRINGZ " = "
newline					.FILL '\n'



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
.ORIG x3800
;-----------------------------------------------------------------------------------------------
ST R7,BACKUP_R7_3800

AND R3, R3, x0
LEA R0, INPUT_PROMPT
PUTS					;Display input prompt

ENTER_INSTRUCTION
	GETC				;User enters character
	OUT
	ADD R3, R0, x0
	ADD R3, R3, #-10
	BRz END_GET_STRING_SUB
	STR R0, R2, #0		;Store char into memory
	ADD R2, R2, #1		;Increment Pointer
	BRnp ENTER_INSTRUCTION
	
	
END_GET_STRING_SUB
	AND R0, R0, x0
	LDR R0, R2, #0		;Null terminate input string
	LD R7, BACKUP_R7_3800
	RET

;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
BACKUP_R7_3800 .BLKW #1
INPUT_PROMPT .STRINGZ "Enter instruction: "
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
;-----------------------------------------------------------------------------------------------
.ORIG x4000			
OPCODES		.FILL #1
			.FILL #5
			.FILL #0
			.FILL #-4
			.FILL #4
			.FILL #4
			.FILL #2
			.FILL #-6
			.FILL #6
			.FILL #-2
			.FILL #-7
			.FILL #-4
			.FILL #-8
			.FILL #3
			.FILL #-5
			.FILL #7
			.FILL #-1


.ORIG x4100			
INSTRUCTIONS	.STRINGZ "ADD"
				.STRINGZ "AND"
				.STRINGZ "BR"
				.STRINGZ "JMP"
				.STRINGZ "JSR"
				.STRINGZ "JSRR"
				.STRINGZ "LD"
				.STRINGZ "LDI"
				.STRINGZ "LDR"
				.STRINGZ "LEA"
				.STRINGZ "NOT"
				.STRINGZ "RET"
				.STRINGZ "RTI"
				.STRINGZ "ST"
				.STRINGZ "STI"
				.STRINGZ "STR"
				.STRINGZ "TRAP"
				.FILL #-1


;===============================================================================================
