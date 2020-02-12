;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 4, ex 3
; Lab section: 022
; TA: Jang-Shing
; 
;=================================================
.ORIG x3000
;--------------
;Instructions
;--------------
LD R1, BINARY_1
LD R2, ARRAY_PTR
LD R4, MAX_VALUE

DO_WHILE
	STR R1, R2, #0	;Stores value of R1 into the address in (R2+0)
	ADD R2, R2, #1	;Increments the pointer in R2, points to next element in array
	ADD R1, R1, R1	;Multiply R1 by 2
	ADD R3, R1, R4	;Add R1 to -1024, if 0, 512 is reached
	BRnp DO_WHILE
	
LD R5, ARRAY_PTR	;R5 will now have the starting & of the array
ADD R5, R5, #6 	;R5 will now have the & of the 7th element in the array
LDR R2, R5, #0 	;Stores value in (R5+0) into R2

HALT
;--------------
;Local Data
;--------------
BINARY_1 .FILL x1
ARRAY_PTR .FILL ARRAY
NEWLINE .FILL '\n'
MAX_VALUE .FILL #-1024
;--------------
;Remote Data
;--------------
.ORIG x4000
ARRAY .BLKW #10

.END
