;Student name: Hai Nam Ngo
;Student ID: 103488515

;asking for player's name
MOV R0, #inName 
STR R0, .WriteString
MOV R1, #playerName
STR R1, .ReadString   ;store player's actual name in R!

;asking for number of matchsticks
MatchInput:
MOV R2, #question1
STR R2, .WriteString
LDR R3, .InputNum   ;store actual number of matchsticks in R3
;Compare the input with the requirement
CMP R3, #5
BLT MatchInput ; if R3 lower than 5
CMP R3, #100
BGT MatchInput ; if R3 greater than 100

;print out result for player's name
MOV R4, #outName
STR R4, .WriteString
STR R1, .WriteString

;print out result for number of matchsticks
MOV R5, #outMatchsticks
STR R5, .WriteString
STR R3, .WriteUnsignedNum

;print the notification to screen
MOV R7, #notify1
MOV R8, #notify2
MOV R9, #notify3
STR R7, .WriteString
STR R1, .WriteString
STR R8, .WriteString
STR R3, .WriteUnsignedNum
STR R9, .WriteString

;this is code for userturn
UserTurn:
STR R7, .WriteString
STR R1, .WriteString
MOV R10, #question2
STR R10, .WriteString
; take user's input
LDR R11, .InputNum
;make sure input is between 1-3
CMP R11, #1
BLT UserTurn
CMP R11, #3
BGT UserTurn
;make sure input is lower than the actual number of matchsticks
CMP R11, R3
BGT UserTurn

;calculate the remaining matchsticks
SUB R3, R3, R11
MOV R7, #notify1
MOV R8, #notify2
MOV R9, #notify3
STR R7, .WriteString
STR R1, .WriteString
STR R8, .WriteString
STR R3, .WriteUnsignedNum
STR R9, .WriteString

;Analyse the result
CMP R11, #1
BEQ analysis1
BGT analysis2

analysis1:
CMP R3, #0
BEQ Lose
;return to computer's turn
BGT ComputerTurn

analysis2:
CMP R3, #0
BEQ Draw
;return to computer's turn
BGT ComputerTurn

;code for computer's turn
ComputerTurn:
LDR R0,. Random ;generate random number 
AND R0, R0, #3  ; make it becomes a random number from 0 to 3
CMP R0, #0
BEQ ComputerTurn   ;redo the generating process if random number is 0
CMP R0, R3   ;redo the generating process if random number is higher than the actual number of matchsticks.
BGT ComputerTurn
SUB R3, R3, R0

;print out string to notify this is computer's turn
MOV R6, #computermsg
STR R6, .WriteString
STR R0, .WriteUnsignedNum

MOV R7, #notify1
MOV R8, #notify2
MOV R9, #notify3
STR R7, .WriteString
STR R1, .WriteString
STR R8, .WriteString
STR R3, .WriteUnsignedNum
STR R9, .WriteString

;Analyse the result
CMP R0, #1
BEQ analysis3
BGT analysis4

analysis3:
CMP R3, #0
BEQ Win
;return to computer's turn
BGT UserTurn

analysis4:
CMP R3, #0
BEQ Draw
;return to computer's turn
BGT UserTurn

;return to the user's turn
B UserTurn

Win:
MOV R7, #notify1
STR R7, .WriteString
STR R1, .WriteString
MOV R2, #winmsg
STR R2, .WriteString
B Endgame

Lose:
MOV R7, #notify1
STR R7, .WriteString
STR R1, .WriteString
MOV R2, #losemsg
STR R2, .WriteString
B Endgame

Draw:
MOV R2, #drawmsg
STR R2, .WriteString
B Endgame

Endgame:
MOV R12, #end
STR R12, .WriteString
MOV R7, #decision
STR R7, .ReadString
LDRB R7, [R7]  ; Load the first byte (character) of the input string
CMP R7, #121 ;121 is the ASCII number for "y"
BEQ MatchInput
CMP R7, #110 ;110 is the ASCII number for "n"
BEQ Terminate
B Endgame

Terminate: 
HALT

;stage 1
inName: .asciz "Please enter your name\n"
playerName: .block 128
question1: .asciz "How many matchsticks (5-100)?\n"
error: .asciz "Invalid input...Try again\n"
outName: .asciz "Player 1 is "
outMatchsticks: .asciz "\nMatchsticks: "

;stage2
notify1: .asciz "\nPlayer "
notify2: .asciz ", there are "
notify3: .asciz "matchsticks remaining."
question2: .asciz ", how many do you want to remove (1-3)?"
end: .asciz "\nPlay again (y/n)?\n"

;stage 3 (R0, R2, R4, R5, R6 are ready to be reused by now)
computermsg: .asciz "\nComputer chose to remove "
winmsg: .asciz ", YOU WON!"
losemsg: .asciz ", YOU LOSE!"
drawmsg: .asciz "\nIt's a draw!"
decision: .block 128