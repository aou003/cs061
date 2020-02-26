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
				 
				 
HALT
;-----------------------------------------------------------------------------------------------
; test harness local data:
;-----------------------------------------------------------------------------------------------
SUB_PRINT_OPTABLE_PTR .FILL x3200
SUB_PRINT_OP_PTR .FILL x3400




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
				 
				 
				 
				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
;-----------------------------------------------------------------------------------------------
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100



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
				 
				 
				 
				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data



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
