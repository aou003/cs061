;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 4, ex 4
; Lab section: 022
; TA: Jang Shing
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

LD R1, ARRAY_PTR
LD R5, MAX_VALUE
ADD R5, R5, #1
PRINT_LOOP
	LDR R0, R1, #0	;Load value found at &(R1+0) into R0
	ADD R3, R0, #0
	ADD R0, R0, #8	;Add 48 to convert to ascii
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8

	OUT				;Display value in R0
	ADD R1, R1, #1	;Increment pointer to array
	BRnp PRINT_LOOP
	
HALT
;--------------
;Local Data
;--------------
BINARY_1 .FILL x1
ARRAY_PTR .FILL ARRAY
NEWLINE .FILL '\n'
MAX_VALUE .FILL #-1024
ASCII .FILL #16
NUM_LOOPS .FILL #10
;--------------
;Remote Data
;--------------
.ORIG x4000
ARRAY .BLKW #10

.END
