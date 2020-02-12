;=================================================
; Name: Shenoy, nina
; Email:nshen004@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 022
; TA: Jang Shing Enoch Lin
;
;Hello World Example Program
;Also illustrates how to use PUT (aka: Trap x22)
;=================================================
.ORIG x3000
;---------------
;Instructions
;---------------
	LEA R0, MSG_TO_PRINT ;R0<-- the location of the label: MSG_TO_PRINT
	PUTS				 ;Prints string defined at MSG_TO_PRINT
	HALT					 ;Terminate Program
;---------------
;Local Data
;---------------
	MSG_TO_PRINT .STRINGZ "Hello world!!!\n" ;Store 'H' in an address labelled
											 ;MSG_TO_PRINT and then each
											 ;character in its own consec
											 ;memory address, followed by #0
											 ;at the end of the string to mark the end of the string
