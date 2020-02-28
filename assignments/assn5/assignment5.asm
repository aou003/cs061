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
	ADD R2, R2, #-2
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
    
		PRINT_ALLNOTBUSY
			LEA R0, allnotbusy
			PUTS
			BRnzp MENU_LOOP
		
		PRINT_ALLBUSY
			LEA R0, allbusy
			PUTS
			BRnzp MENU_LOOP
	
	CHOICE_2            ;Checks if all machines are free
    LD R7, SUB_ALL_FREE_PTR
    JSRR R7
	
	CHOICE_3            ;Returns number of busy machines
    LD R7, SUB_NUM_BUSY_PTR
    JSRR R7
	
	CHOICE_4            ;Returns number of free machines
    LD R7, SUB_NUM_FREE_PTR
    JSRR R7
	
	CHOICE_5            ;Report status of machine 'n'
    LD R7, SUB_MACHINE_STATUS_PTR
    JSRR R7
	
	CHOICE_6            ;Report number of first available machine
    LD R7, SUB_FIRST_FREE_PTR
    JSRR R7
	
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

END_ALL_BUSY_SUB
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


IS_BUSY
ALL_FREE
END_ALL_FREE_SUB
	;HINT Restore
	LD R7, BACKUP_R7_3800
	RET

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BACKUP_R7_3800 .BLKW #1
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xBA00

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

;HINT Restore
RET
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xBA00


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

;HINT Restore
RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xBA00


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

;HINT Restore
RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xBA00

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

;HINT Restore
RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xBA00

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

;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
	
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

;--------------------------------
;Data for subroutine print number
;--------------------------------



.ORIG x6A00
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xBA00			; Remote data
BUSYNESS .FILL xABCD		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
