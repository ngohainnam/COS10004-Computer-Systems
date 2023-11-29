;Student name: Hai Nam Ngo
;Student ID: 103488515

;asking for player's name
MOV R0, #inName 
STR R0, .WriteString
MOV R1, #playerName
STR R1, .ReadString   ;store player's actual name in R!
STR R1, .WriteString
;newline command
MOV R6, #0x0A
STRB R6, .WriteChar

;asking for number of matchsticks
MatchInput:
MOV R2, #question
STR R2, .WriteString
LDR R3, .InputNum   ;store actual number of matchsticks in R3

;Compare the input with the requirement
CMP R3, #5
BLT Error ; if R3 lower than 5, go to Error section
CMP R3, #100
BGT Error ; if R3 greater than 100, go to Error section
B Cont ;Otherwise, go to Cont section

Error:
MOV R7, #error
STR R7, .WriteString
B MatchInput

Cont:
STR R3, .WriteUnsignedNum

;print out result for player's name
MOV R4, #outName
STR R4, .WriteString
STR R1, .WriteString

;print out result for number of matchsticks
MOV R5, #outMatchsticks
STR R5, .WriteString
STR R3, .WriteUnsignedNum
HALT

inName: .asciz "Please enter your name: "
playerName: .block 128
question: .asciz "How many matchsticks (5-100)? "
error: .asciz "\nInvalid input...Try again\n"
outName: .asciz "\nPlayer 1 is "
outMatchsticks: .asciz "\nMatchsticks: "

