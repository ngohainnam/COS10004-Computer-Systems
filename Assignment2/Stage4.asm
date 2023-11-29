;Student name: Hai Nam Ngo
;Student ID: 103488515

;the main program is here
BL AskForInput
BL Play
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1st Function: main program function
AskForInput:
    Push {R4}
    UserInfo:
        ; Check if playerName is empty
        CMP R5, #0
        BEQ ASkForName
        B MatchStickCheck

    ASkForName:
        ; Asking for player's name
        MOV R4, #inName
        STR R4, .WriteString
        MOV R5, #playerName
        STR R5, .ReadString ; store player's actual name in R5

    MatchStickCheck:
        ; Check if initialMatchsticks is 0 (initial game) or not (replay)
        LDR R7, initialMatchsticks
        CMP R7, #0
        BEQ AskforMatchStick
        B Skip

    AskforMatchStick:
        ; Asking for the number of matchsticks
        MOV R4, #question1
        STR R4, .WriteString
        LDR R7, .InputNum ; store actual number of matchsticks in R7
        CMP R7, #5
        BLT AskforMatchStick
        CMP R7, #100
        BGT AskforMatchStick
        ; Store initial matchstick count in memory
        STR R7, initialMatchsticks
        
    Skip:
    Pop {R4}
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;2nd Function for print out the output and play game
Play:
    Push {R4}
    ; Print out result for player's name
    MOV R4, #outName
    STR R4, .WriteString
    STR R5, .WriteString

    ; Load the initial matchstick count from memory
    LDR R7, initialMatchsticks

    ; Print out result for the number of matchsticks
    MOV R4, #outMatchsticks
    STR R4, .WriteString
    STR R7, .WriteUnsignedNum
    Pop {R4}

    ; Call the print notification function (Nested function call)
    BL PrintNotify
    STR R3, .ClearScreen
    BL DrawSystem
    B UserTurn
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;3rd Function: Use to print notification "Player X, There is ...."
PrintNotify:
    Push {R4,R5,R7} ;push register needed for this function 
    MOV R4, #notify1
    STR R4, .WriteString
    STR R5, .WriteString
    MOV R4, #notify2
    STR R4, .WriteString
    STR R7, .WriteUnsignedNum
    MOV R4, #notify3
    STR R4, .WriteString
    Pop {R4,R5,R7}
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;4th function: Use to ask player if they want to play again
Endgame:
    Push {R4}
    STR R3,.ClearScreen 
    MOV R4, #end
    STR R4, .WriteString
    MOV R4, #decision
    STR R4, .ReadString
    LDRB R4, [R4]  ; Load the first byte (character) of the input string
    CMP R4, #121 ;121 is the ASCII number for "y"
    BEQ Play
    CMP R4, #110 ;110 is the ASCII number for "n"
    BEQ Terminate
    B Endgame
    Pop {R4}
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;5th function: use to visualize the matchsticks
DrawSystem:
    Push {R1, R2, R4, R5, R6, R9, R11, R12}
    MOV R0, #1        ;X coordinate (0-63)
    MOV R1, #1        ;Y coordinate (0-47)
    MOV R6, #0        ;Number of matchsticks drawn
    MOV R11, #0       ;Line counter
    MOV R12, #0       ;Matchsticks in the current line

;Subroutine to draw a matchstick
drawMatchStick:
    MOV R3, #.PixelScreen
;Draw the head
    MOV R2, #.orangered
    LSL R4, R0, #2    ;Multiply X coordinate by 4
    LSL R5, R1, #8    ;Multiply Y coordinate by 256
    ADD R5, R5, R4    ;Get the pixel index
    STR R2, [R3+R5]

;Draw the body
    MOV R2, #.burlywood
    MOV R9, #3        ;The number of pixels for the body

bodyLoop:
;Increment X coordinate by 1 pixel
    ADD R0, R0, #1
;Calculate pixel index
    LSL R4, R0, #2    ;Multiply X coordinate by 4
    LSL R5, R1, #8    ;Multiply Y coordinate by 256
    ADD R5, R5, R4    ;Get the pixel index
;Draw body pixel
    STR R2, [R3+R5]
;Decrement the pixel count and check if it's greater than 0
    SUB R9, R9, #1
    CMP R9, #0
    BGT bodyLoop
;Move to the next matchstick (add a 2-pixel distance)
    ADD R0, R0, #3
;Increment the number of matchsticks drawn
    ADD R6, R6, #1
    ADD R12, R12, #1
;Check if we've drawn the desired number of matchsticks
    CMP R6, R7
    BEQ EndDraw
;Check if we need to start a new line
    CMP R12, #10
    BEQ newLine
;If not, continue on the same line
    B drawMatchStick

newLine:
;Start a new line (Y+4, X=1)
    ADD R1, R1, #4
    MOV R0, #1
    ADD R11, R11, #1
    MOV R12, #0       ;Reset matchsticks in the current line
;Check if we've drawn all lines (up to 10)
    CMP R11, #10
    BLT drawMatchStick

EndDraw:
    Pop {R1, R2, R4, R5, R6, R9, R11, R12}
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;begin of the user's turn
UserTurn:
    MOV R4, #notify1
    STR R4, .WriteString
    STR R5, .WriteString
    MOV R4, #question2
    STR R4, .WriteString

    ; Take user's input
    LDR R6, .InputNum
    ; Make sure input is between 1-3
    CMP R6, #1
    BLT UserTurn
    CMP R6, #3
    BGT UserTurn
    ; Make sure input is lower than the actual number of matchsticks
    CMP R6, R7
    BGT UserTurn

    ; Calculate the number of matchsticks remaining
    SUB R7, R7, R6
    MOV R4, #userremovemsg
    STR R4, .WriteString
    STR R6, .WriteUnsignedNum
    MOV R4, #matchsticks
    STR R4, .WriteString
    STR R3, .ClearScreen 
    BL DrawSystem 

    ; Analyse the result if the input is 1
    CMP R6, #1
    BEQ analysis1
    BGT analysis2

    analysis1:
        CMP R7, #0
        BEQ Lose

    analysis2:
        CMP R7, #0
        BEQ Draw

    ; Return to computer's turn
    B ComputerTurn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;code for computer's turn
ComputerTurn:
    LDR R6,. Random ;generate random number 
    AND R6, R6, #3  ; make it becomes a random number from 0 to 3
    CMP R6, #0
    BEQ ComputerTurn   ;redo the generating process if random number is 0
    CMP R6, R7   ;redo the generating process if random number is higher than the actual number of matchsticks.
    BGT ComputerTurn
    SUB R7, R7, R6

    ;print out string to notify of the number of matchsticks has been removed by computer
    MOV R4, #computerturn
    STR R4, .WriteString 
    MOV R4, #computermsg
    STR R4, .WriteString
    STR R6, .WriteUnsignedNum
    MOV R4, #matchsticks
    STR R4, .WriteString

    ;print the notification to screen
    BL PrintNotify
    STR R3, .ClearScreen 
    BL DrawSystem  

    ;Analyse the result
    CMP R6, #1
    BEQ analysis3
    BGT analysis4

    analysis3:
        CMP R7, #0
        BEQ Win

    analysis4:
        CMP R7, #0
        BEQ Draw
;return to the user's turn
B UserTurn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Branch to identify the result for the game are displayed here
Win:
    MOV R4, #notify1
    STR R4, .WriteString
    STR R5, .WriteString
    MOV R4, #winmsg
    STR R4, .WriteString
    BL Endgame

Lose:
    MOV R4, #notify1
    STR R4, .WriteString
    STR R5, .WriteString
    MOV R4, #losemsg
    STR R4, .WriteString
    BL Endgame

Draw:
    MOV R4, #drawmsg
    STR R4, .WriteString
    BL Endgame

Terminate:
    MOV R7, #0
    STR R7, initialMatchsticks
    HALT

;stage 1
inName: .asciz "Please enter your name\n"
playerName: .block 128
question1: .asciz "How many matchsticks (5-100)?\n"
outName: .asciz "Player 1 is "
outMatchsticks: .asciz "\nMatchsticks: "

;stage2
notify1: .asciz "\nPlayer "
notify2: .asciz ", there are "
notify3: .asciz "matchsticks remaining."
question2: .asciz ", how many do you want to remove (1-3)?"

;stage 3
computerturn: .asciz "\nComputer Player's turn"
computermsg: .asciz "\nComputer chose to remove "
userremovemsg: .asciz "\nYou chose to remove "
matchsticks: .asciz "matchsticks."
initialMatchsticks: .word 0 ; To store the initial matchstick count
winmsg: .asciz ", YOU WON!"
losemsg: .asciz ", YOU LOSE!"
drawmsg: .asciz "\nIt's a draw!"
end: .asciz "\nPlay again (y/n)?\n"
decision: .block 128