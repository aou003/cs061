;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Nina Shenoy
; Email: nshen004@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 
; TA: Enoch
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
MENU_LOOP
	LD R7, SUB_MENU_PTR			;Jump to MENU subroutine
	JSRR R7

	ADD R2, R1, #0				;Move value of R1 to R2
	ADD R2, R2, #-1
	BRz CHOICE_1				;User has entered 1

	ADD R2, R1, #0				;Reset value of R2 to R1                     
	ADD R2, R2, #-2             ;...and so on
	BRz CHOICE_2

	ADD R2, R1, #0
	ADD R2, R2, #-3
	BRz CHOICE_3

	ADD R2, R1, #0
	ADD R2, R2, #-4
	BRz CHOICE_4
	
	ADD R2, R1, #0
	ADD R2, R2, #-5
	BRz CHOICE_5
	
	ADD R2, R1, #0
	ADD R2, R2, #-6
	BRz CHOICE_6
	
	ADD R2, R1, #0
	ADD R2, R2, #-7
	BRz CHOICE_7

	CHOICE_1            ;Checks if all machines are busy
		LD R7, SUB_ALL_BUSY_PTR
		JSRR R7
		
		ADD R2, R2, #0
		BRz PRINT_ALLNOTBUSY
		BRp PRINT_ALLBUSY
    
		PRINT_ALLNOTBUSY        ;not all machines are busy
			LEA R0, allnotbusy
			PUTS
			BRnzp MENU_LOOP
		
		PRINT_ALLBUSY           ;all machines are busy
			LEA R0, allbusy
			PUTS
			BRnzp MENU_LOOP
	
	CHOICE_2            ;Checks if all machines are free
		LD R7, SUB_ALL_FREE_PTR
		JSRR R7
		
		ADD R2, R2, #0
		BRz PRINT_ALLNOTFREE
		BRp PRINT_ALLFREE
		
		PRINT_ALLNOTFREE        ;not all machines are free
			LEA R0, allnotfree
			PUTS
			BRnzp MENU_LOOP
		
		PRINT_ALLFREE           ;all machines are free
			LEA R0, allfree
			PUTS
			BRnzp MENU_LOOP
	
	CHOICE_3            ;Returns number of busy machines
        LD R7, SUB_NUM_BUSY_PTR
        JSRR R7

        LEA R0, busymachine1
        PUTS                    ;"there are "
        
        LD R7, SUB_PRINT_NUM
        JSRR R7

        LEA R0, busymachine2
        PUTS                    ;"busy machines"
        BRnzp MENU_LOOP
        
	
	CHOICE_4            ;Returns number of free machines
        LD R7, SUB_NUM_FREE_PTR
        JSRR R7
        
        LEA R0, freemachine1
        PUTS
        
        LD R7, SUB_PRINT_NUM
        JSRR R7
        
        LEA R0, freemachine2
        PUTS
        BRnzp MENU_LOOP
	
	CHOICE_5            ;Report status of machine 'n'
        LD R7, SUB_MACHINE_STATUS_PTR
        JSRR R7
        
        ADD R2, R2, #0
        BRz BUSY
        BRp FREE
        
        BUSY
			LEA R0, status1
			PUTS
			
			LD R7, SUB_PRINT_NUM
			JSRR R7
			
			LEA R0, status2
			PUTS
			BRnzp MENU_LOOP
			
		FREE
			LEA R0, status1
			PUTS
			
			LD R7, SUB_PRINT_NUM
			JSRR R7
			
			LEA R0, status3
			PUTS
			BRnzp MENU_LOOP
			
	
	CHOICE_6            ;Report number of first available machine
        LD R7, SUB_FIRST_FREE_PTR
        JSRR R7
        
        ADD R3, R1, #-16
        BRz NO_FREE_MACHINES
        
        LEA R0, firstfree1
        PUTS
        
        ;ADD R1, R1, #-15
        LD R7, SUB_PRINT_NUM
        JSRR R7
        LD R0, newline
        OUT
        BRnzp MENU_LOOP

        NO_FREE_MACHINES
            LEA R0, firstfree2
            PUTS
            BRnzp MENU_LOOP
	
	CHOICE_7            ;Quit!
		LEA R0, goodbye
		PUTS
		BRnzp END_BUSYNESS



END_BUSYNESS
HALT
;---------------	
;Data
;---------------
;Subroutine pointers
SUB_MENU_PTR .FILL x3200
SUB_ALL_BUSY_PTR .FILL x3500
SUB_ALL_FREE_PTR .FILL x3800
SUB_NUM_BUSY_PTR .FILL x3B00
SUB_NUM_FREE_PTR .FILL x3E00
SUB_MACHINE_STATUS_PTR .FILL x4200
SUB_FIRST_FREE_PTR .FILL x4500

SUB_PRINT_NUM .FILL x4A00

;Other data 
newline 		.fill '\n'

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3200
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3200

PRINT_MENU
	LD R0, Menu_string_addr			;Print menu
	PUTS

	GETC                            ;Get user input
	OUT

	ADD R1, R0, #0					;Move contents of R0 to R1
	ADD R1, R1, #-12				;Convert from ascii to dec value
	ADD R1, R1, #-12
	ADD R1, R1, #-12
	ADD R1, R1, #-12

    ADD R2, R1, #0                  ;Move contents of R1 to R2
    ADD R2, R2, #-1                 
    BRn PRINT_ERROR                 ;If value is less than 1

    ADD R2, R1, #0                  ;Move contents of R1 to R2
    ADD R2, R2, #-7
    BRp PRINT_ERROR                 ;If value is greater than 7
    
    LD R0, NEWLINE_MENU				;Print newline after input
    OUT
    BRnzp END_MENU_SUB


	PRINT_ERROR						;Invalid input, print error message
		LD R0, NEWLINE_MENU
		OUT
		LEA R0, Error_msg_1
		PUTS
        BRnzp PRINT_MENU
	

END_MENU_SUB						;End the subroutine with the value in R1
    ;HINT Restore
    LD R7, BACKUP_R7_3200
    RET

;--------------------------------
;Data for subroutine MENU
;--------------------------------
BACKUP_R7_3200 .BLKW #1
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
NEWLINE_MENU .FILL '\n'
Menu_string_addr  .FILL x6A00

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3500
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3500

LD R4, BUSYNESS_ADDR_ALL_MACHINES_BUSY         ;Load xABCD into R4
LDR R1, R4, #0

LD R3, BIT_COUNTER                              ;Load R3 with 16

BUSY_LOOP
    ADD R1, R1, #0
    BRn IS_FREE
    ADD R1, R1, R1
    ADD R3, R3, #-1
    BRnp BUSY_LOOP
    BRz ALL_BUSY

IS_FREE             ;Return 0 there is a free machine
    AND R2, R2, x0
    BRnzp END_ALL_BUSY_SUB

ALL_BUSY              ;Return 1 if all machines are busy
    AND R2, R2, x0
    ADD R2, R2, #1
    BRnzp END_ALL_BUSY_SUB

END_ALL_BUSY_SUB        ;end subroutine
    ;HINT Restore
    LD R7, BACKUP_R7_3500
    RET

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BACKUP_R7_3500 .BLKW #1
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xBA00
BIT_COUNTER .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3800
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3800
LDI R4, BUSYNESS_ADDR_ALL_MACHINES_FREE			;Load xABCD into R4
LD R3, BITS_COUNTER								;Load 16 to R3
		
FREE_LOOP                            
	ADD R4, R4, #0  
	BRzp IS_BUSY                ;there is a busy machine, return 0
	ADD R4, R4, R4
	ADD R3, R3, #-1            ;decrement counter
	BRz ALL_FREE                
	BRnp FREE_LOOP             ;loop through each machine (bit) and check the sign
	
IS_BUSY
	AND R2, R2, x0
	BRnzp END_ALL_FREE_SUB
	
ALL_FREE                        ;all machines are free, return 1
	AND R2, R2, x0
	ADD R2, R2, #1
	BRnzp END_ALL_FREE_SUB
	
END_ALL_FREE_SUB
	;HINT Restore
	LD R7, BACKUP_R7_3800
	RET

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BACKUP_R7_3800 .BLKW #1
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xBA00
BITS_COUNTER .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3B00
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3B00

LD R4, BUSYNESS_ADDR_NUM_BUSY_MACHINES
LDR R2, R4, #0        ;Copy xXXXX into R2
AND R1, R1, x0                                  ;Set R1 to 0
LD R3, NUM_BUSY_COUNT                           ;Copy 16 into R2

NUM_BUSY_LOOP
    ADD R2, R2, #0
    BRzp ADD_BUSY                                ;If 0, increment num of busy machines
    ADD R3, R3, #-1                             ;decrement bit counter
    BRz END_NUM_BUSY_SUB
    ADD R2, R2, R2                              ;left bit shift
    BRnp NUM_BUSY_LOOP

ADD_BUSY
    ADD R1, R1, #1
    ADD R3, R3, #-1                             ;decrement bit counter
    BRz END_NUM_BUSY_SUB
    ADD R2, R2, R2                              ;left bit shift
    BRnzp NUM_BUSY_LOOP

END_NUM_BUSY_SUB
    ;HINT Restore
    LD R7, BACKUP_R7_3B00
    RET
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BACKUP_R7_3B00 .BLKW #1
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xBA00
NUM_BUSY_COUNT .FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3E00
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3E00

LDI R2, BUSYNESS_ADDR_NUM_FREE_MACHINES         ;Copy xXXXX into R2
AND R1, R1, x0                                  ;Set R1 to 0
LD R3, NUM_FREE_COUNT                           ;Copy 16 into R2

NUM_FREE_LOOP
    ADD R2, R2, #0
    BRn ADD_FREE                                ;If 0, increment num of busy machines
    ADD R3, R3, #-1                             ;decrement bit counter
    BRz END_NUM_FREE_SUB
    ADD R2, R2, R2                              ;left bit shift
    BRzp NUM_FREE_LOOP

ADD_FREE
    ADD R1, R1, #1
    ADD R3, R3, #-1                             ;decrement bit counter
    BRz END_NUM_FREE_SUB
    ADD R2, R2, R2                              ;left bit shift
    BRnzp NUM_FREE_LOOP

;HINT Restore
END_NUM_FREE_SUB
	LD R7, BACKUP_R7_3E00
	RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BACKUP_R7_3E00 .BLKW #1
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xBA00
NUM_FREE_COUNT .FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4200
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_4200

LD R7, SUB_GET_MACHINE_NUM_PTR
JSRR R7

AND R4, R4, x0		;Set R4 to 0
ADD R3, R1, #0		;Copy contents of R1 to R3

LD R4, MAX_NUM_LOOPS
NOT R3, R3
ADD R3, R3, #1
ADD R4, R4, R3		;How many times to bit shift left

LDI R5, BUSYNESS_ADDR_MACHINE_STATUS

ADD R4, R4, #0
BRz CHECK_STATUS

GO_TO_MACHINE_N
	ADD R5, R5, R5
	ADD R4, R4, #-1
	BRz CHECK_STATUS
	BRnp GO_TO_MACHINE_N

CHECK_STATUS
	ADD R5, R5, #0
	BRzp N_IS_BUSY
	BRn N_IS_FREE
	
N_IS_BUSY
	AND R2, R2, x0
	BRnzp END_SUB_MACHINE_STATUS

N_IS_FREE
	AND R2, R2, x0
	ADD R2, R2, #1
	BRnzp END_SUB_MACHINE_STATUS
	
END_SUB_MACHINE_STATUS
	;HINT Restore
	LD R7, BACKUP_R7_4200
	RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
SUB_GET_MACHINE_NUM_PTR .FILL x4800
BACKUP_R7_4200 .BLKW #1
BUSYNESS_ADDR_MACHINE_STATUS.Fill xBA00
MAX_NUM_LOOPS .FILL #15

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4500
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_4500
LDI R2, BUSYNESS_ADDR_FIRST_FREE
AND R5, R5, x0          ;will contain counter
AND R1, R1, x0          ;will contain return value

ADD R5, R5, #15         ;counts down from 15

BITSHIFT_LEFT_LOOP
    ADD R5, R5, #0      ;if counter is 0, check if free
    BRz CHECK_IF_FREE
    ADD R2, R2, R2      ;bitshift left
    ADD R5, R5, #-1
    BRp BITSHIFT_LEFT_LOOP

CHECK_IF_FREE
    ADD R2, R2, #0
    BRn END_SUB_FIRST_FREE
    ADD R1, R1, #1
    AND R5, R5, x0
    ADD R5, R5, #15
    NOT R4, R1
    ADD R4, R4, #1
    ADD R5, R5, R4
    ADD R4, R1, #-16
    BRz END_SUB_FIRST_FREE
    LDI R2, BUSYNESS_ADDR_FIRST_FREE
    BRnzp BITSHIFT_LEFT_LOOP

;HINT Restore
END_SUB_FIRST_FREE
    LD R7, BACKUP_R7_4500
    RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xBA00
BACKUP_R7_4500 .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4800
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
ST R7, BACKUP_R7_4800
START

	; output intro prompt
	LEA R0, prompt
	PUTS

	; Set up flags, counters, accumulators as needed
	AND R1, R1, x0		;Will hold binary number
	AND R2, R2, x0		
	AND R3, R3, x0		;Will hold neg/pos flag
	AND R4, R4, x0
	AND R6, R6, x0
	AND R7, R7, x0
	LD R5, COUNTER		;Will hold 6

	GET_INPUT
		GETC				;Input char
		ADD R2, R0, #0
		ADD R2, R2, #-10
		BRz CHECK_NEWLINE	;check if newline is first char or not
		BRnp CHECK_INPUT
		
		
	CHECK_INPUT
        OUT
		ADD R2, R0, #0
		ADD R2, R2, #-16
		ADD R2, R2, #-16
		ADD R2, R2, #-16        ;Converts from ascii to dec
		BRn CHECK_OPERATOR		;Check if less than 48 (could be + or -)
		ADD R2, R0, #0
		ADD R2, R2, #-16
		ADD R2, R2, #-16
		ADD R2, R2, #-16
		ADD R2, R2, #-9
		BRp PRINT_ERROR_MSG		;If greater than 57, it is always wrong
		ADD R2, R5, #0
		ADD R2, R2, #-6
		BRz FIRST_DIGIT			;If 0, user has inputted the first digit
		ADD R1, R1, R1			;Else: valid input, add stuff
		ADD R7, R1, R1
		ADD R7, R7, R7
		ADD R1, R1, R7
		
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R1, R1, R0          ;Converts to Decimal, stores this value into R2
		ADD R5, R5, #-1         ;Decrement counter
		BRp GET_INPUT           ;If not 0, continue looping
		BRz END_PROGRAM           ;If 0, check to see if neg flag is set
		
	FIRST_DIGIT
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R0, R0, -16
		ADD R1, R0, R1
		ADD R5, R5, -2			;converts to dec and stores in R2
		BRnzp GET_INPUT
		
	
	CHECK_OPERATOR				;Checks if the value below '0' is either '-' or '+'
		ADD R2, R0, #0
		ADD R2, R2, #-16
		ADD R2, R2, #-16	
		ADD R2, R2, #-11		;If 0, user has entered '+'
		BRz PLUS
		ADD R2, R0, #0
		ADD R2, R2, #-16
		ADD R2, R2, #-16
		ADD R2, R2, #-13		;If 0, user has entered '-'
		BRz PRINT_ERROR_MSG
		
	PLUS
		ADD R2, R5, #0
		ADD R2, R2, #-6
		BRnp PRINT_ERROR_MSG	;If not the first char
		AND R2, R2, x0
		ADD R3, R3, #0			;Set signed bit to 0
		ADD R5, R5, #-1         ;Decrement Counter
		BRnzp GET_INPUT
		
		
	CHECK_NEWLINE
		ADD R2, R5, #0
		ADD R2, R2, #-6
		BRz PRINT_ERROR_MSG
		BRnp CHECK_SUB_VALIDITY
		
	CHECK_SUB_VALIDITY
		ADD R2, R1, #0;
		ADD R2, R2, #-15
		BRp PRINT_ERROR_MSG			;If input is larger than 15
		BRnz END_PROGRAM
		
        
	PRINT_ERROR_MSG
        LD R0, GET_INPUT_NEWLINE
        OUT
        OUT
		LEA R0, Error_msg_2
		PUTS
		BRnzp START
		
	END_PROGRAM
		LD R0, GET_INPUT_NEWLINE
		OUT
		LD R7, BACKUP_R7_4800
		RET

;--------------------------------
;Data for subroutine Get input
;--------------------------------
BACKUP_R7_4800 .BLKW #1
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
GET_INPUT_NEWLINE .FILL '\n'
COUNTER .FILL #6
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4A00
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
ST R7, BACKUP_R7_4A00
ST R2, BACKUP_R2_4A00

AND R0, R0, x0
AND R3, R3, x0             ;Will be counter for digits
ADD R2, R1, #0             ;Copy value from R1 to R2      

CHECK_MAGNITUDE
    ADD R2, R2, #-10
    BRzp PRINT_TEN
    BRn RESET_ONES

RESET_ONES
    ADD R2, R1, #0
    BRnzp COUNT_ONES

PRINT_TEN
    ADD R2, R1, #0         ;Reset value of R2
    LD R0, ASCII_1
    OUT
    ADD R2, R2, #-10
    BRnzp COUNT_ONES

COUNT_ONES
    ADD R2, R2, #-1
    BRn PRINT_ONES
    ADD R3, R3, #1
    BRzp COUNT_ONES

PRINT_ONES
    AND R0, R0, x0
    LD R4, TOASCII
    ADD R3, R3, R4
    ADD R0, R0, R3
    OUT
    BRnzp END_PRINT_NUM_SUB

END_PRINT_NUM_SUB
	LD R7, BACKUP_R7_4A00
	LD R2, BACKUP_R2_4A00
    RET

;--------------------------------
;Data for subroutine print number
;--------------------------------
BACKUP_R7_4A00 .BLKW #1
BACKUP_R2_4A00 .BLKW #1
ASCII_1 .FILL #49
NEG_DEC_10 .FILL #-10
POS_DEC_10 .FILL #10

TOASCII .FILL #48


.ORIG x6A00
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xBA00			 ; Remote data
BUSYNESS .FILL x0000 ;xFFFF	; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END