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
BLT Error ; if R3 lower than 5, go to Error section
CMP R3, #100
BGT Error ; if R3 greater than 100, go to Error section
B Cont ;Otherwise, go to Cont section

Error:
MOV R6, #error
STR R6, .WriteString
B MatchInput

Cont:
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

;ask player for the number of matchsticks to remove
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
STR R7, .WriteString
STR R1, .WriteString
STR R8, .WriteString
STR R3, .WriteUnsignedNum
STR R9, .WriteString
CMP R3, #0
BEQ Lose 
B UserTurn

Lose:
MOV R12, #endgame
STR R12, .WriteString
HALT
;stage 1
inName: .asciz "Please enter your name\n"
playerName: .block 128
question1: .asciz "How many matchsticks (5-100)?"
error: .asciz "\nInvalid input...Try again\n"
outName: .asciz "\nPlayer 1 is "
outMatchsticks: .asciz "\nMatchsticks: "

;stage2
notify1: .asciz "\nPLayer "
notify2: .asciz ", there are "
notify3: .asciz "matchsticks remaining."
question2: .asciz ", how many do you want to remove (1-3)?"
endgame: .asciz "\nGame Over"

