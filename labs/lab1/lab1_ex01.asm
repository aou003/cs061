;------------------------------------
;Shenoy, Nina
;Login: nshen004 (nshen004@cs.ucr.edu)
;Section: 022
;TA: Jang-Shing Enoch Lim
;Lab 1
;Hello world example program
;Also illustrates how to use PUTS (aka: Trap x22)
;
.ORIG x3000
;-----------
;Instructions
;-----------
	LEA R0, MSG_TO_PRINT ;R0 <-- the location of the label: MSG_TO_PRINT
	PUTS				 ;Prints string defined at MSG_TO_PRINT
	
	HALT				 ;Terminate program
;---------
;Local Data
;-----------
MSG_TO_PRINT .STRINGZ "Hello world!!!\n" ;Store 'H' in an address labelled
										 ;MSG_TO_PRINT and then each
										 ;character ('e','l','l','o','w')
										 ;in its own consec memory address
										 ;followed by #0 at the end of the
										 ;string to mark the end of the string
