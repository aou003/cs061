;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name:Nina Shenoy
; Email:nshen004@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: 022
; TA: Enoch
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
GETC					;User inputs character which is stored in R0
ADD R1, R0, #0			;Move value in R0 -> R1
OUT						;Display R0 value
LD R0, newline			;Print newline
OUT

GETC					;User inputs character which is stored in R0
ADD R2, R0, #0			;Move value in R0 -> R2
OUT						;Display R0 value
LD R0, newline			;Print newline
OUT

ADD R0, R1, #0			;Move value in R1 -> R0
OUT						;Display value in R0
LEA R0, minus			;Load '-' into R0
PUTS						;Display '-'
ADD R0, R2, #0			;Move value in R2 -> R0
OUT						;Display value in R0
LEA R0, equals			;Move '=' to R0
PUTS					;Display '='

ADD R1, R1, #-16		;Convert ASCII to number
ADD R1, R1, #-16
ADD R1, R1, #-16

ADD R2, R2, #-16		;Convert ASCII to number
ADD R2, R2, #-16
ADD R2, R2, #-16
	
NOT R2, R2				;Take 2's complement of number in R2
ADD R2, R2, #1

ADD R3, R1, R2			;Add R1 and R2, store number in R0
BRzp IS_POSITIVE

IS_NEGATIVE
	NOT R3, R3
	ADD R3, R3, #1
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	LEA R0, negative
	PUTS
	ADD R0, R3, #0
	OUT
	BRzp PRINT_NEWLINE
	
IS_POSITIVE
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R3, R3, #8
	ADD R0, R3, #0
	OUT
	BRzp PRINT_NEWLINE

PRINT_NEWLINE
	LD R0, newline
	OUT

HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
minus .STRINGZ " - "
negative .STRINGZ "-"
equals .STRINGZ " = "


;---------------	
;END of PROGRAM
;---------------	
.END

