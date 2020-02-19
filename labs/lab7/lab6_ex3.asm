;=================================================
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 022
; TA: Enoch
; 
;=================================================
.ORIG x3000
;=================================================
LD R1, NUM_1
LD R2, NUM_2

CHECK_MSB
	ADD R1, R1, #0
	BRn MSB_1
	BRp MSB_2

MSB_1
	ADD R1, R1, R1
	ADD R1, R1, #1
	BRnzp CHECK_MSB

MSB_0
	ADD R1, R1, R1
	BRnzp CHECK_MSB
HALT

;Local Data
NUM_1 .FILL #8
NUM_2 .FILL #2

.END
