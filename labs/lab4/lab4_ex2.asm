;=================================================
; Name: Nina
; Email: nshen004@ucr.edu
; 
; Lab: lab 4, ex 2
; Lab section: 022
; TA: Jang Shing
; 
;=================================================
.ORIG x3000
;------------------
;Instructions
;------------------
AND R1, R1, x0	;Set R1 to 0
LD R2, ARRAY_PTR

DO_WHILE
	STR R1, R2, #0	;Stores value of R1 into the address in R2
	ADD R2, R2, #1	;Increments the pointer in R2, points to next element in array
	ADD R1, R1, #1	;Increments value in R1
	ADD R3, R1, #-10 ;If R3 now contains 0, the array is full
	BRnp DO_WHILE
	
LD R5, ARRAY_PTR	;R5 will now have the starting & of the array
ADD R5, R5, #6 	;R5 will now have the & of the 7th element in the array
LDR R2, R5, #0 	;Stores value in (R5+0) into R2

;Now, print the characters corresponding to the numbers in the array
LD R1, ARRAY_PTR

CHAR_LOOP
	LDR R0, R1, #0	;Store the value in (R1+0) into R0, so R0 will contain the & of the first element of the array
	ADD R2, R0, #0	;Move the value in R0 to R2. This will be the counter
	ADD R0, R0, #8	;Add 48 to convert from number in R0 to ascii
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8
	ADD R0, R0, #8
	OUT
	LD R0, NEWLINE
	OUT
	ADD R1, R1, #1	;Increment pointer to next address in array
	ADD R2,R2, #-9
	BRnp CHAR_LOOP

HALT	
;---------------
;Local Data
;---------------
DEC_0 .FILL #0
ARRAY_PTR .FILL ARRAY
NEWLINE .FILL '\n'
;---------------
;Remote Data
;---------------
.ORIG x4000
ARRAY .BLKW #10

.END

