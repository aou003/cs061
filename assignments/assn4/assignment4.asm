;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
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

; output intro prompt
LD R0, introPromptPtr
PUTS

AND R3, R3, x0
AND R4, R4, x0
AND R1, R2, x0

LD R4, DIGIT_COUNTER

GETC
OUT

ADD R1, R0, #0
;Check for newline
ADD R1, R1, #-10
BRz STOP_PROGRAM

;Check for '+'
ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-11		;Decrement digit counter
BRz POS_NUMBER

;Check for '-'
ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-13
BRz NEG_NUMBER

;Check for valid input (between 0 and 9)
ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-16
BRn PRINT_ERROR_MSG	;This prints error if character is less than 48 ('0')
ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R2, R1, #0
BRp POS_NUMBER

ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-9
BRp PRINT_ERROR_MSG	;This prints error if character is greater than 48
ADD R1, R0, #0
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R1, R1, #-16
ADD R2, R1, #0
BRn POS_NUMBER

		
POS_NUMBER
	
	

NEG_NUMBER
			
; Set up flags, counters, accumulators as needed
; Get first character, test for '\n', '+', '-', digit/non-digit 	
; is very first character = '\n'? if so, just quit (no message)!
; is it = '+'? if so, ignore it, go get digits
; is it = '-'? if so, set neg flag, go get digits
; is it < '0'? if so, it is not a digit	- o/p error message, start over
; is it > '9'? if so, it is not a digit	- o/p error message, start over
; if none of the above, first character is first numeric digit - convert it to number & store in target register!			
; Now get remaining digits (max 5) from user, testing each to see if it is a digit, and build up number in accumulator
; remember to end with a newline!

PRINT_ERROR_MSG
	LD R0, NEWLINE
	OUT
	LD R0,errorMessagePtr
	PUTS

STOP_PROGRAM
LEA R0, STOP_PROGRAM_MSG
PUTS			
HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xA100
errorMessagePtr		.FILL xA200
STOP_PROGRAM_MSG		.STRINGZ "Exiting Program...\n"
NEWLINE				.FILL '\n'
DIGIT_COUNTER 		.FILL #6
MINUS_CHAR			.FILL #-45
PLUS_CHAR			.FILL #-43



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
