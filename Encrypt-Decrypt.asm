;main subroutine
.ORIG x3000
;can use R0,R1,R2,R3

LEA R0, startmsg        ;gives greeting for program
PUTS                    ;shows startmsg on screen 

start LEA R0, query     ;gives the message to input E or D or X
PUTS                    ;shows query on screen

GETC                    ;get input from user which is now in R0

LD R1 E                 ;loading in value of E    
NOT R0 R0               
ADD R0 R0 #1            ;2C of input, R0 will now have same input for all of these checks
ADD R1 R0 R1            ;subrtacting them 
BRz loopE               ;go to loopE to JSRR to subroutine
AND R3 R3 #0            ;checking lowercase e
LD R3 val32             ;loading 32 into R3
ADD R3 R1 R3            ;adding value of R1 and R3
BRz loopE               ;go to loopE to JSRR to subroutine

LD R1 D                 ;loading in value of D    
ADD R1 R0 R1            ;subrtacting them 
BRz loopD               ;go to loopE to JSRR to subroutine
AND R3 R3 #0            ;checking lowercase d
LD R3 val32             ;loading 32 into R3
ADD R3 R1 R3            ;adding value of R1 and R3
BRz loopD               ;go to loopE to JSRR to subroutine

LD R1 X                 ;loading in value of D    
ADD R1 R0 R1            ;subrtacting them 
BRz loopX               ;go to loopE to JSRR to subroutine
AND R3 R3 #0            ;checking lowercase d
LD R3 val32             ;loading 32 into R3
ADD R3 R1 R3            ;adding value of R1 and R3
BRz loopX               ;go to loopE to JSRR to subroutine

LEA R0, invalid         ;loads the message that letter is invalid
PUTS                    ;shows query on screen
BRnzp start             ;go back to starting message if invalid input

E .FILL #69             
D .FILL #68
X .FILL #88
val32 .FILL #32
goEncrypt .FILL Encrypt     ;label for subroutine Encrypt
goDecrypt .FILL Decrypt     ;label for subroutine Decrypt
goClear .FILL clear         ;label for subroutine clear
checkKey .Fill key          ;label for subroutine to check if it is a valid key 

startmsg    .STRINGZ "\nSTARTING PRIVACY MODULE\n"
query       .STRINGZ "\nENTER E OR D OR X\n"
keymsg      .STRINGZ "\nENTER KEY\n"
promptmsg   .STRINGZ "\nENTER MESSAGE\n"
invalid     .STRINGZ "\nINVALID INPUT\n"

loopE LD R4 goEncrypt   ;loading label for subroutine into R4
    JSRR R4             ;JSRR to the subroutine for Encrypt
    BRnzp start         ;go back to promting 
    
loopD LD R4 goDecrypt   ;loading label for subroutine into R4
    JSRR R4             ;JSRR to the subroutine for Decrypt
    BRnzp start         ;go back to prompting 
    
loopX LD R4 goClear     ;loading label for subroutine into R4
    JSRR R4             ;JSRR to the subroutine to clear everything
    HALT
    
;make subroutines for each specific encryption     
Encrypt  ST R7 storeR7
    LD R5 checkKey      ;go to subroutine to check if key is valid
    JSRR R5             ;JSRR to the checkKey subroutine
    LD R5 goSTOREMSG    ;JSRR to the subroutine thats gonna store the message 
    JSRR R5 
    Ld R5 goXORENCRYPT  ; go to XOR encryption after message is
    JSRR R5
    LD R5 goMODe        ;after XOR go to MOD encryption 
    JSRR R5
    LD R7 storeR7       ;load back in correct return address
    RET

Decrypt ST R7 storeR7
    AND R5 R5 #0
    LD R5 checkkey          ;go to subroutine to enter message you want to decrypt
    JSRR R5                 ;JSRR to the checkKey subroutine
    LD R5 goMODd                      
    JSRR R5                 ;JSRR to the Mod decrypt subroutine
    LD R5 goXORDECRYPT
    JSRR R5                 ;JSRR to the XOR decrypt subroutine
    LD R7 storeR7
    RET
    
clear   LD R0 MESSAGE       ;load adress x4000
        ;LD R1 decryptedmsg  ;load adress x5000
        LDR R3 R0 #0        ;load chars in to R3
        ;LDR R4 R1 #0        ;load chars into R4
        
        AND R2 R2 #0        ;clear R2
        ADD R2 R2 #10       ;make a counter the size of the message to stop the loop
clearmsgloop                ;loop to clear both addresses
            AND R3 R3 #0    ;clearing the char for enc
            STR R3 R0 #0
            ADD R0 R0 #1    ;moving up one index of 
            ADD R1 R1 #1
            ADD R2 R2 #-1   ;decrement the counter
            BRp clearmsgloop;if positve, we have not cleard everything

      RET
      
Keychar1 .BLKW #1       ;label for the first inputted char
Keychar2 .BLKW #1       ;label for second inputed char
Keychar3 .BLKW #1       ;label for 3rd inputted char
keychar4 .BLKW #1       ;label for 4th inputted char
keychar5 .BLKW #1       ;label for 5th inputted char
CheckKeychar3 .BLKW #1  ;label for the 3rd checked char
CheckKeychar4 .BLKW #1  ;label for the 4th checked char
CheckKeychar5 .BLKW #1  ;label for the 5th checked char
hunded .FILL #100       ;label stores value of 100
ten .Fill #10           ;label stores value of 10
goMULT .FILL MULT               ;label for mult subroutine for the keycheck
goXORENCRYPT .FILL XORencrypt   ;label for xor encryption         
goMODe .FILL MODe               ;label for encryption mod subroutine
goXORDECRYPT .FILL XORdecrypt   ;label for encryption XOR subroutine
goMODd .FILL MODd               ;label for decryption mod subroutine
storeR7 .BLKW #1                ;label to store R7 
storeR7again .BLKW #1           ;another label to store R7
threedignum .BLKW #1            ;label that store the sum of the last three digits of k
neg128 .FILL #128               ;store 128


key AND R0 R0 #0                ;check key subroutine; clearing all registers
    AND R1 R1 #0
    AND R2 R2 #0
    AND R3 R3 #0
    AND R4 R4 #0
    AND R5 R5 #0
    AND R6 R6 #0

returnBeg   LEA R0 keymsg       ;loading "enter key" string 
    PUTS                ;show it on screen
    GETC                ;get input from user, key is now in R0 and it doesnt get perminently saved because R0 will get overwritten with msgs
    ST R0 Keychar1      ;storing 1st character 
    GETC
    ST R0 Keychar2      ;storing 2nd character 
    GETC 
    ST R0 Keychar3      ;storing 3rd character
    GETC 
    ST R0 Keychar4      ;storing 4th character
    GETC 
    ST R0 Keychar5      ;storing 5th character
    
;checking the first char (has to be between 0-7)   
    LD R1 neg48         ;load negtive 48 store in R0  
     
    LD R0 Keychar1      ;loading value of 1st char into R0
    LD R2 zero          ;loading adress of zero into R2
    ADD R3 R2 R0        ;adding R1 with the negetive value of 0 in ASCII and storing in R1
    BRn invalidchar     ;if its negative print invalid and go back  
    
    LD R2 neg7          ;laoding adress of neg7 into R2
    ADD R0 R2 R0        ;checking to see if it is negetive 
    BRp invalidchar     ;branching if negtive bc invalid 
    
;checking the second char (cannot be 1-9)

    LD R0 keychar2      ;loading adress of 2nd char into R0
    LD R2 neg9
    ADD R2 R2 R0
    BRp Donewithsecondchar
    
    LD R2 zero                  ;loading adress of zero into R0
    ADD R2 R2 R0                ;adding R1 with the negetive value of 0 in ASCII and storing in R1
    BRz donewithsecondchar      ;if its negative print invalid and go back
    BRn addback0
    
    LD R2 neg9          ;laoding adress of neg9 into R2
    ADD R3 R2 R0        ;if it is postive, it is greater than 9 
    BRnz invalidchar    ;branching if negtive or 0 because it is 
    
    addback0 NOT R2 R2
    ADD R2 R2 #1
    ADD R2 R2 R0
    BRn Donewithsecondchar
    
;checking the last three numbers to be from 0-127
Donewithsecondchar LD R5 keychar3          ;R5 will hold 3rd char 
ADD R5 R5 R1            ;subtract 48 to get actual number of number inputted
LD R6 hunded            ;want R6 to hold 100
ST R7 storeR7again      ;make sure we store last return address
LD R4 goMULT            ;call multiplication subroutine
LD R7 storeR7again      ;load 
JSRR R4
ST R3 checkKeychar3     ;load result into the label to store the checkedkeychar

LD R5 Keychar4          ;loading in the second
ADD R5 R5 R1            ;subtract 48 to get actual number of number inputted
LD R6 ten               ;want a register to hold 10
LD R4 goMULT
JSRR R4
LD R7 storeR7again

ST R3 checkKeychar4

;Now add up all of key char and key char and subtract them 
LD R3 checkkeychar3     ;laoding checkkeychar3 into R3

LD R2 checkkeychar4     ;loading value of checkkeychar4 into r2

LD R0 keychar5          ;laoding checkkeychar5 into R1
ADD R1 R1 R0            ;subtract 48 to get actual number of number inputted

ADD R3 R3 R2            ;adding 3rd and 2nd char and putting that in R3
ADD R3 R1 R3            ;adding the sum of first and second char with the last number stored in R3

LD R0 neg127            ;loading -127 into R0

ADD R0 R3 R0            ;what ever is in R3-R0
BRp invalidchar         ;if positive, it means it is greater than 127
ST R3 threedignum       ;storing the three digit number
    RET              

invalidchar    LEA R0 invalid      ;if it is negtive then prints invalid input and then returns to beggining to enter new key
    PUTS
    BRnzp returnBeg
    
    RET                 ;return because key is valid 


;add all of the 3 labels up and then check if it is less than or equal to 127

MULT AND R3 R3 #0       ;multiplication subroutine
     loop
        ADD R3 R3 R5    ;the inputted char is in R5
        ADD R6 R6 #-1   ;decrement 100, then 10
        BRp loop        ;keep looping if the decrement is not
        RET
 
neg9  .FILL #-57         ;labels for the numbers I am going to be subtracting in the chekcing keysubroutine
neg7  .FILL #-55
neg1  .FILL #-49
zero  .FILL #-48
neg127 .FILL #-127
neg48 .FILL #-48     
neg49 .FILL #-49 
MESSAGE .FILL x4000          ;label for encrypted msg to be stored at x4000
goSTOREMSG .FILL STOREMSG

STOREMSG    LEA R0 promptmsg    ;entermessageprompt
        PUTS                ;display on screen
        LD R1 MESSAGE       ;load adress of message into R1 x4000
        AND R2 R2 #0        ;clear R2
        ADD R2 R2 #10       ;make a counter the size of the message to stop the loop
        storemsgloop GETC   ;loop
            STR R0 R1 #0    ;storing the char
            ADD R1 R1 #1    ;moving the location of memory up one
            ADD R2 R2 #-1   ;decrement the counter
            BRp storemsgloop
        RET
        
XORencrypt 
    AND R5 R5 #0
    ADD R5 R5 #10   ;10
    LD R1 keychar2  ;loading key char in R1 
    LD R0 MESSAGE   ;loading address of message in R0
    LD R6 neg48
    ADD R1 R1 R6    ;check to see if character is 0 and change it to dec value
    BRz loopxor     
    LD R1 keychar2  ;load is back with the ascii value
    
loopxor LDR R6 R0 #0 
    NOT R3 R6       ;!message stored in R3
    NOT R4 R1       ;!of char stores in R4
    
    AND R3 R3 R1    ; !char AND message
    AND R4 R4 R6    ; char AND !message
    
    NOT R3 R3       ; !(!char AND message)
    NOT R4 R4       ; !(char AND !message)
    
    AND R2 R3 R4    ; !((!char AND message) AND !(char AND !message))
    NOT R2 R2       ; !( !(!char AND message) AND !(char AND !message))
    
    STR R2 R0 #0    ;store whatever the value is in register R2 into R0 
    ADD R0 R0 #1    ;move on to the next char in message
    ADD R5 R5 #-1   ;decrement 10
    BRp loopxor
    
    RET          ;loading in return value

;R0 is the divisor. ;need to do k + each individual char mod 128
MODe 
    LD R1 threedignum           ;k= threedignum, loading into R0
    LD R3 MESSAGE               ;load in the MESSAGE into R3
    AND R6 R6 #0                ;clear R6
    AND R4 R4 #0                ;clearing R4
    AND R2 R2 #0                ;making R2 my temp that will hold -128
    ADD R6 R6 #10               ;making the decrement
    LD R0 neg128                ;loading in 128 
    NOT R0, R0                  ;notting the divisor
    ADD R0, R0, #1              ;2s compliment 
    ADD R2, R0, R2              ;making temp the dividend,R2=-128 now and R0
loopmodE
        AND R0 R0 #0            ;label to keep looping through the subroutine
        AND R4 R4 #0
        LDR R5 R3 #0            ;loading values of R3 into R5
        ADD R0 R5 R1            ;keep adding k+char to update each value in message
        ADD R4, R2, R0          
        while BRnz doneneg      ;while loop to subtract
            ADD R4, R4, R2      ;subtract R1-R2 store in R4
            BRzp while
        doneneg BRz donezero    ;exits to the negtive case to add the dividend to get result
            LD R0 neg128        ;loading 128 back in because had to use if for 
            ADD R4, R4, R0      ;add 128 to get the remainder
            STR R4, R3, #0      ;store result into R3
            LDR R5 R3 #0
            ADD R3 R3 #1        ;add one to the offset for MESSAGE
            ADD R6 R6 #-1       ;decrement to make sure we only do this 10 times                    
            BRp loopmodE        
        RET
        donezero                      
            STR R4 R3 #0      ;load result into MESSAGE
            LDR R5 R3 #0
            ADD R3 R3 #1        ;add one to the offset for MESSAGE
            ADD R6 R6 #-1       ;decrement to make sure we only do this 10 times
            BRp loopmodE        ;loop again if R6 is not zero
        RET

XORdecrypt 
    AND R0 R0 #0                ;clearing all registers
    AND R1 R1 #0
    AND R2 R2 #0
    AND R3 R3 #0
    AND R4 R4 #0
    AND R5 R5 #0
    AND R6 R6 #0
    
    ADD R5 R5 #10           ;10
    LD R1 keychar2          ;loading key char in R1 
    LD R0 decryptedmsg      ;loading address of message in R0
    LD R6 neg48
    
    ADD R1 R1 R6    ;check to see if character is 0 and change it to dec value
    BRz loopxor     
    LD R1 keychar2;load is back with the ascii value
    
loopxor2 LDR R6 R0 #0 
    NOT R3 R6       ;!message stored in R3
    NOT R4 R1       ;!of char stores in R4

    AND R3 R3 R1    ; !char AND message
    AND R4 R4 R6    ; char AND !message

    NOT R3 R3       ; !(!char AND message)
    NOT R4 R4       ; !(char AND !message)

    AND R2 R3 R4    ; !((!char AND message) AND !(char AND !message))
    NOT R2 R2       ; !( !(!char AND message) AND !(char AND !message))
    STR R2 R0 #0    ;store whatever the value is in register R2 into R0 
    ADD R0 R0 #1    ;move on to the next char in message
    ADD R5 R5 #-1   ;decrement 10
    BRp loopxor2
    
      ;loading in return value
    RET    
    
decryptedMsg .FILL x5000     ;label for decrypted msg ot be stored at x5000

MODd AND R0 R0 #0                ;clearing all registers
    AND R1 R1 #0
    AND R2 R2 #0
    AND R3 R3 #0
    AND R4 R4 #0
    AND R5 R5 #0
    AND R6 R6 #0
    
    LD R3 MESSAGE               ;load in the MESSAGE into R3
    LD R6 decryptedMsg          ;load in the decrypted              ;making R2 my temp that will hold -128
    ADD R4 R4 #10               ;making the decrement
    
    CopyChar LDR R1 R3 #0       ;loop to move the characters in message to decrypted message
        STR R1 R6 #0            ;storing char from message into encrypted message
        ADD R6 R6 #1            ;incrementing both message and decrytpedsmg
        ADD R3 R3 #1
        ADD R4 R4 #-1
        BRp CopyChar
        
    AND R0 R0 #0                ;clearing all registers
    AND R1 R1 #0
    AND R2 R2 #0
    AND R3 R3 #0
    AND R4 R4 #0
    AND R5 R5 #0
    AND R6 R6 #0
    
    LD R1 threedignum           ;-k= NOT threedignum, loading into R0
    NOT R1 R1                   ;2C of three dig number
    ADD R1 R1 #1
    
    LD R3 decryptedmsg          ;load in the MESSAGE into R3
                 
    ADD R6 R6 #10               ;making the decrement
    LD R0 neg128                ;loading in 128 
    NOT R0, R0                  ;notting the divisor
    ADD R0, R0, #1              ;2s compliment 
    ADD R2, R0, R2              ;making temp the dividend,R2=-128 now and R0
loopmodD
        AND R0 R0 #0            ;label to keep looping through the subroutine
        AND R4 R4 #0
        LDR R5 R3 #0            ;loading values of R3 into R5
        ADD R0 R5 R1            ;keep adding char-k to update each value in message
        ADD R4, R4, R0          
        whileD BRnz donenegD    ;while loop to subtract
            ADD R4, R4, R2      ;subtract R1-R2 store in R4
            BRzp while
        donenegD BRz donezeroD  ;exits to the negtive case to add the dividend to get result
            LD R0 neg128        ;loading 128 back in because had to use if for 
            ADD R4, R4, R0      ;add 128 to get the remainder
            STR R4, R3, #0      ;store result into R3
            LDR R5 R3 #0
            ADD R3 R3 #1        ;add one to the offset for MESSAGE
            ADD R6 R6 #-1       ;decrement to make sure we only do this 10 times                    
            BRp loopmodD        
        RET
        donezeroD                      
            STR R4 R3 #0      ;load result into MESSAGE
            LDR R5 R3 #0
            ADD R3 R3 #1        ;add one to the offset for MESSAGE
            ADD R6 R6 #-1       ;decrement to make sure we only do this 10 times
            BRp loopmodD        ;loop again if R6 is not zero
        RET

.END
