;=======================================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 022
; TA: Jang Shing
; 
;=======================================================================
.ORIG x3000
;=======================================================================
LD R0, STRING_PTR
LD R7, SUB_GET_STRING_PTR

JSSR R7




HALT

;Local Data (main)
STRING_PTR .FILL x3400
SUB_GET_STRING_PTR .FILL x3200


;=======================================================================
;Subroutine: SUB_GET_STRING
;Paramter(R1): The starting address of the character array
;Postcondition: The subroutine has prompted the user to input a string
;				terminated by the [ENTER] key (sentinel) and has stored
;				the recieved characters in an array of characters 
;				starting at (R1). The array is NULL-terminated. Do not 
;				store the sentinel
;Return Value(R5): The number of non-sentinel characters read from user.
;					R1 contains the starting address of the array unchanged.
;=======================================================================
.ORIG x3200



;Subroutine Data
INTRO_MSG .STRINGZ "Please enter string(press enter to exit).
.END
