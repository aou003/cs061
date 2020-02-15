;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name:Nina Shenoy
; Email:nshen004@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 022
; TA: Jang Shing
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R2
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------

START

	; output intro prompt
	LD R0, introPromptPtr
	PUTS

	; Set up flags, counters, accumulators as needed
	AND R1, R1, x0
	AND R2, R2, x0		;Will hold binary number
	AND R3, R3, x0		;Will hold neg/pos flag
	AND R4, R4, x0
	AND R6, R6, x0
	AND R7, R7, x0
	LD R5, COUNTER		;Will hold 6


	
	GET_INPUT
		GETC				;Input char
		ADD R1, R0, #0
		ADD R1, R1, #-10
		BRz CHECK_NEWLINE	;check if newline is first char or not
		BRnp PRINT_CHAR
		
	PRINT_CHAR
		OUT					;Prints input and checks to see if valid
		BRnzp CHECK_INPUT
		
	CHECK_INPUT
		ADD R1, R0, #0
		ADD R1, R1, #-16
		ADD R1, R1, #-16
		ADD R1, R1, #-16
		BRn CHECK_OPERATOR		;Check if less than 48 (could be + or -)
		ADD R1, R0, #0
		ADD R1, R1, #-16
		ADD R1, R1, #-16
		ADD R1, R1, #-16
		ADD R1, R1, #-9
		BRp PRINT_ERROR_MSG		;If greater than 57, it is always wrong
		ADD R1, R5, #0
		ADD R1, R1, #-6
		BRz FIRST_DIGIT			;If 0, user has inputted the first digit
		ADD R2, R2, R2			;Else: valid input, add stuff
		ADD R7, R2, R2
		ADD R7, R7, R7
		ADD R2, R2, R7
		
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R2, R2, R0
		ADD R5, R5, #-1
		BRp GET_INPUT
		BRz IS_NEG
		
	FIRST_DIGIT
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R2, R0, R2
		ADD R5, R5, -2			;converts to dec and stores in R2
		BRnzp GET_INPUT
		
	
	CHECK_OPERATOR				;Checks if the value below '0' is either '-' or '+'
		ADD R1, R0, #0
		ADD R1, R1, #-16
		ADD R1, R1, #-16	
		ADD R1, R1, #-11		;If 0, user has entered '+'
		BRz PLUS
		ADD R1, R0, #0
		ADD R1, R1, #-16
		ADD R1, R1, #-16
		ADD R1, R1, #-13		;If 0, user has entered '-'
		BRz MINUS
		
	PLUS
		ADD R1, R5, #0
		ADD R1, R1, #-6
		BRnp PRINT_ERROR_MSG	;If not the first char
		AND R1, R1, x0
		ADD R3, R3, #0			;Set signed bit to 0
		ADD R5, R5, #-1
		BRnzp GET_INPUT
		
	MINUS
		ADD R1, R5, #0
		ADD R1, R1, #-6
		BRnp PRINT_ERROR_MSG
		AND R1, R1, x0
		ADD R5, R5, #-1
		ADD R3, R3, #1		;Set signed bit to 1
		BRnzp GET_INPUT
		
	CHECK_NEWLINE
		ADD R1, R5, #0
		ADD R1, R1, #-6
		BRz END_PROGRAM
		BRnp IS_NEG
		
	IS_NEG
		AND R1, R1, x0
		ADD R1, R3, #0
		BRn TWOS_COMP
		
	TWOS_COMP
		NOT R2, R2
		ADD R2, R2, #1
		BRnzp END_PROGRAM
		
	
	PRINT_ERROR_MSG
		LD R0, NEWLINE
		OUT
		LD R0, errorMessagePtr
		PUTS
		BRnzp START
		
	END_PROGRAM
		LD R0, NEWLINE
		OUT
		HALT


;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xA100
errorMessagePtr		.FILL xA200
STOP_PROGRAM_MSG		.STRINGZ "Exiting Program...\n"
NEWLINE				.FILL '\n'
COUNTER 		.FILL #6
MINUS_CHAR			.FILL #-45
PLUS_CHAR			.FILL #-43
TO_DEC				.FILL #-48



;------------
; Remote data
;------------
.ORIG xA100			; intro prompt
.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"


.ORIG xA200			; error message
.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
