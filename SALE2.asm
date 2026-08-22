; ================================================================
; CAMPUS STATIONERY POS SYSTEM
; AMCS1113 Assignment
; ================================================================

.MODEL SMALL
.STACK 100H
.DATA

; ================================================================
; LOGIN
; ================================================================
USERNAME    DB  'admin', 0
PASSWORD    DB  '1234', 0

IN_USER     DB  21, 0, 20 DUP('$')
IN_PASS     DB  21, 0, 20 DUP('$')

LOGIN_ATTEMPTS DB 0
MAX_ATTEMPTS EQU 3

WELCOME_MSG DB  0AH,0DH,'================================',0AH,0DH
            DB  '   CAMPUS STATIONERY POS',0AH,0DH
            DB  '================================',0AH,0DH,'$'
PROMPT_USER DB  0AH,0DH,'Username: $'
PROMPT_PASS DB  'Password: $'
LOGIN_OK    DB  0AH,0DH,'================================',0AH,0DH
            DB  'Login Successful!',0AH,0DH
            DB  '================================',0AH,0DH,'$'
LOGIN_BAD   DB  0AH,0DH,'Invalid! Remaining attempts: $'
LOGIN_LOCK  DB  0AH,0DH,'================================',0AH,0DH
            DB  'Account Locked! Too many attempts.',0AH,0DH
            DB  '================================',0AH,0DH,'$'

; ================================================================
; MAIN MENU
; ================================================================
MENU_MSG   DB  0AH,0DH,'================================',0AH,0DH
           DB  '        CAMPUS STATIONERY POS',0AH,0DH
           DB  '================================',0AH,0DH
           DB  ' 1. Our Product',0AH,0DH
           DB  ' 2. Inventory Management',0AH,0DH
           DB  ' 3. Reports',0AH,0DH
           DB  ' 4. Logout',0AH,0DH
           DB  ' 5. Exit',0AH,0DH
           DB  '================================',0AH,0DH
           DB  'Select: $'

; ================================================================
; INVENTORY MENU
; ================================================================
INV_MENU   DB  0AH,0DH,'================================',0AH,0DH
           DB  '     INVENTORY MANAGEMENT',0AH,0DH
           DB  '================================',0AH,0DH
           DB  ' 1. Update Stock (Add)',0AH,0DH
           DB  ' 2. Reduce Stock',0AH,0DH
           DB  ' 3. Edit Price',0AH,0DH
           DB  ' 4. Back to Main Menu',0AH,0DH
           DB  '================================',0AH,0DH
           DB  'Select: $'

; ================================================================
; PRODUCTS
; ================================================================
P1  DB  '1. Notebook            $'
P2  DB  '2. Ballpoint Pen       $'
P3  DB  '3. Pencil              $'
P4  DB  '4. Eraser              $'
P5  DB  '5. Ruler               $'
P6  DB  '6. Highlighter         $'
P7  DB  '7. File Folder         $'
P8  DB  '8. Stapler             $'

P_NAMES DW P1, P2, P3, P4, P5, P6, P7, P8

P_PRICES_LO DW 300, 200, 100, 100, 200, 400, 300, 500
P_PRICES_HI DW 0, 0, 0, 0, 0, 0, 0, 0
P_STOCKS DW 15, 25, 30, 20, 15, 10, 12, 8 
P_COUNT  DW 8

; ================================================================
; SALES RECORDS
; ================================================================
P_SOLD DW 0, 0, 0, 0, 0, 0, 0, 0
CART_QTY DW 0, 0, 0, 0, 0, 0, 0, 0
TOTAL_CUSTOMERS DW 0
TOTAL_REVENUE_LO DW 0
TOTAL_REVENUE_HI DW 0

; ================================================================
; INPUT BUFFERS
; ================================================================
BUF_ID  DB  5, 0, 5 DUP('$')
BUF_QTY DB  5, 0, 5 DUP('$')
BUF_PAY DB  6, 0, 6 DUP('$')
BUF_CENTS DB 3, 0, 3 DUP('$')
BUF_NAME DB 21, 0, 20 DUP('$')

; ================================================================
; SALE VARIABLES
; ================================================================
IDX     DW  0
QTY     DW  0
PRICE_LO DW 0
PRICE_HI DW 0
TOTAL_LO DW 0
TOTAL_HI DW 0
SUBTOTAL_LO DW 0
SUBTOTAL_HI DW 0
DISCOUNT_LO DW 0
DISCOUNT_HI DW 0
TAX_LO  DW  0
TAX_HI  DW  0
CHANGE_LO DW 0
CHANGE_HI DW 0
CASH_LO DW  0
CASH_HI DW  0
PAY_TEMP_LO DW 0
PAY_TEMP_HI DW 0

; ================================================================
; PROMPTS
; ================================================================
P_ID    DB  0AH,0DH,'Enter ID (1-8): $'
P_QTY   DB  0AH,0DH,'Enter Qty (1-999): $'
P_PAY   DB  0AH,0DH,'Enter Payment (Ringgit): RM $'
P_PAY_CENTS DB 0AH,0DH,'Enter Payment (Cents 00-99): $'
P_AGAIN DB  0AH,0DH,'Add more items? (y/n): $'

E_ID    DB  0AH,0DH,'ERROR: Invalid ID! Enter 1-8 only.$'
E_QTY   DB  0AH,0DH,'ERROR: Invalid Qty! Enter 1-999 only.$'
E_PAY   DB  0AH,0DH,'ERROR: Not enough payment!$'
E_STOCK DB  0AH,0DH,'ERROR: Not enough stock!$'

; ================================================================
; REDUCE STOCK MESSAGES
; ================================================================
MSG_REDUCE_OK DB  0AH,0DH,'Stock reduced successfully!$'
E_REDUCE      DB  0AH,0DH,'ERROR: Not enough stock to reduce!$'

; ================================================================
; EDIT PRODUCT MESSAGES
; ================================================================
MSG_EDIT_OK   DB  0AH,0DH,'Price updated successfully!$'
E_EDIT_PRICE  DB  0AH,0DH,'ERROR: Invalid price! Ringgit must be 0-999, Cents must be 00-99, price must be RM0.01-RM999.99.$'
EDIT_PRICE    DB  0AH,0DH,'Enter new price (Ringgit, or Enter to skip): RM $'
EDIT_PRICE_CENTS DB 0AH,0DH,'Enter new price (Cents 00-99): $'

; ================================================================
; RECEIPT
; ================================================================
R_HEAD  DB  0AH,0DH,'================================',0AH,0DH
        DB  '        STATIONERY RECEIPT',0AH,0DH
        DB  '================================',0AH,0DH,'$'
R_NOW_HEAD DB 0AH,0DH,'--------------------------------',0AH,0DH
           DB  '          YOUR ORDER',0AH,0DH
           DB  '--------------------------------',0AH,0DH,'$'
R_ALL_HEAD DB 0AH,0DH,'--------------------------------',0AH,0DH
           DB  '     ALL ITEMS (This Session)',0AH,0DH,'$'
R_SUBTOTAL DB 'Subtotal: RM $'
R_DISCOUNT DB 'Discount: RM $'
R_TAX   DB  'Tax (6%): RM $'
R_TOTAL DB  'Total: RM $'
R_CASH  DB  'Cash: RM $'
R_CHANGE DB 'Change: RM $'
R_FOOT  DB  '================================',0AH,0DH
        DB  '         Thank You!',0AH,0DH
        DB  '================================$'

; ================================================================
; TABLE
; ================================================================
TABLE_HEADER DB 0AH,0DH,'Product             Stock  Price',0AH,0DH
             DB  '------------------------------------',0AH,0DH,'$'
TABLE_LINE DB  '------------------------------------',0AH,0DH,'$'

; ================================================================
; REPORT TABLE
; ================================================================
REPORT_HEADER  DB  'No  Product          Sold  Price',0AH,0DH,'$'
REPORT_LINE    DB  '--------------------------------',0AH,0DH,'$'
REPORT_TOTAL   DB  'Total Items Sold : $'
REPORT_REVENUE DB  'Total Revenue    : RM $'
REPORT_CUSTOMERS DB 'Total Customers  : $'

; ================================================================
; CONFIRM
; ================================================================
CONFIRM_MSG DB 0AH,0DH,'Quit? (y/n): $'
CONFIRM_LOGOUT_MSG DB 0AH,0DH,'Are you sure you want to logout? (y/n): $'
MSG_CONTINUE DB 0AH,0DH,'Do you want to continue? (y/n): $'
MSG_TOTAL_DUE DB 0AH,0DH,'Total Amount: RM $'
MSG_CLEAR DB 0AH,0DH,'Press any key to continue...$'
MSG_BUY DB  0AH,0DH,'Do you want to continue buying? (y/n): $'
MSG_RM DB 'RM $'
CONFIRM_UPDATE DB 0AH,0DH,'Confirm add this stock? (y/n): $'
CONFIRM_REDUCE DB 0AH,0DH,'Confirm reduce this stock? (y/n): $'
CONFIRM_PRICE  DB 0AH,0DH,'Confirm this price change? (y/n): $'
MSG_CANCELLED  DB 0AH,0DH,'Cancelled. No changes were made.$'
MSG_UPDATE_OK  DB 0AH,0DH,'Stock updated successfully!$'
E_BLANK        DB 0AH,0DH,'ERROR: This field cannot be blank. Please enter a value.$'
MSG_DISCOUNT_YES DB 0AH,0DH,'You qualify for a 10% discount (spend RM50 or more)!$'

; ================================================================
; MISC
; ================================================================
NEWLINE DB 0AH,0DH,'$'
MSG_TRANS_OK DB 0AH,0DH,'Transaction completed successfully!',0AH,0DH,'$'

; ================================================================
.CODE
; ================================================================

; ================================================================
; MAIN
; ================================================================
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
RESTART:
    CALL LOGIN
    
MENU_LOOP:
    CALL CLEAR_SCREEN
    CALL DISPLAY_MENU
    CALL GET_OPTION
    
    CMP AL, '1'
    JE  DO_SALE
    CMP AL, '2'
    JE  DO_INVENTORY
    CMP AL, '3'
    JE  DO_REPORT
    CMP AL, '4'
    JE  DO_LOGOUT
    CMP AL, '5'
    JE  DO_QUIT
    JMP MENU_LOOP

DO_SALE:
    CALL MAKE_SALE
    JMP MENU_LOOP

DO_INVENTORY:
    CALL INVENTORY_MENU
    JMP MENU_LOOP

DO_REPORT:
    CALL REPORT
    JMP MENU_LOOP

DO_QUIT:
    CALL CONFIRM_EXIT
    CMP AL, 'y'
    JE  EXIT_PROG
    CMP AL, 'Y'
    JE  EXIT_PROG
    JMP MENU_LOOP

DO_LOGOUT:
    CALL CONFIRM_LOGOUT
    CMP AL, 'y'
    JE  RESTART
    CMP AL, 'Y'
    JE  RESTART
    JMP MENU_LOOP

EXIT_PROG:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ================================================================
; CLEAR SCREEN
; ================================================================
CLEAR_SCREEN PROC
    MOV AH, 06H
    MOV AL, 0
    MOV CX, 0
    MOV DX, 184FH
    MOV BH, 07H
    INT 10H
    MOV AH, 02H
    MOV BH, 0
    MOV DX, 0
    INT 10H
    RET
CLEAR_SCREEN ENDP

; ================================================================
; WAIT FOR KEY
; ================================================================
WAIT_KEY PROC
    MOV AH, 09H
    LEA DX, MSG_CLEAR
    INT 21H
    MOV AH, 01H
    INT 21H
    RET
WAIT_KEY ENDP

; ================================================================
; LOGIN
; ================================================================
LOGIN PROC
    MOV LOGIN_ATTEMPTS, 0
L_START:
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, WELCOME_MSG
    INT 21H
    LEA DX, PROMPT_USER
    INT 21H
    MOV AH, 0AH
    LEA DX, IN_USER
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV BL, IN_USER + 2
    CMP BL, 0DH
    JNE L_USER_OK
    MOV AH, 09H
    LEA DX, E_BLANK
    INT 21H
    CALL WAIT_KEY
    JMP L_START
L_USER_OK:
    CALL GET_PASSWORD
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV BL, IN_PASS + 2
    CMP BL, 0DH
    JNE L_PASS_OK
    MOV AH, 09H
    LEA DX, E_BLANK
    INT 21H
    CALL WAIT_KEY
    JMP L_START
L_PASS_OK:
    LEA SI, IN_USER + 2
    LEA DI, USERNAME
    CALL COMPARE
    CMP AL, 0
    JNE L_FAIL
    
    LEA SI, IN_PASS + 2
    LEA DI, PASSWORD
    CALL COMPARE
    CMP AL, 0
    JNE L_FAIL
    
    MOV AH, 09H
    LEA DX, LOGIN_OK
    INT 21H
    CALL WAIT_KEY
    RET

L_FAIL:
    INC LOGIN_ATTEMPTS
    MOV AH, 09H
    LEA DX, LOGIN_BAD
    INT 21H
    MOV AL, MAX_ATTEMPTS
    SUB AL, LOGIN_ATTEMPTS
    ADD AL, 1
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, LOGIN_ATTEMPTS
    CMP AL, MAX_ATTEMPTS
    JE  L_LOCKED
    CALL WAIT_KEY
    JMP L_START

L_LOCKED:
    MOV AH, 09H
    LEA DX, LOGIN_LOCK
    INT 21H
    MOV AH, 4CH
    INT 21H
LOGIN ENDP

; ================================================================
; GET PASSWORD
; ================================================================
GET_PASSWORD PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV AH, 09H
    LEA DX, PROMPT_PASS
    INT 21H
    MOV BX, 0
GP_LOOP:
    MOV AH, 07H
    INT 21H
    CMP AL, 0DH
    JE  GP_DONE
    CMP AL, 08H
    JE  GP_BACKSPACE
    CMP BX, 19
    JE  GP_LOOP
    MOV SI, OFFSET IN_PASS + 2
    ADD SI, BX
    MOV [SI], AL
    INC BX
    MOV DL, '*'
    MOV AH, 02H
    INT 21H
    JMP GP_LOOP
GP_BACKSPACE:
    CMP BX, 0
    JE  GP_LOOP
    DEC BX
    MOV SI, OFFSET IN_PASS + 2
    ADD SI, BX
    MOV BYTE PTR [SI], '$'
    MOV DL, 08H
    MOV AH, 02H
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV DL, 08H
    INT 21H
    JMP GP_LOOP
GP_DONE:
    MOV SI, OFFSET IN_PASS + 2
    ADD SI, BX
    MOV BYTE PTR [SI], 0DH
    INC SI
    MOV BYTE PTR [SI], '$'
    POP DX
    POP CX
    POP BX
    POP AX
    RET
GET_PASSWORD ENDP

; ================================================================
; COMPARE STRINGS
; ================================================================
COMPARE PROC
CMP_LOOP:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, 0DH
    JE  CMP_CHK_END
    CMP BL, 0
    JE  CMP_NO
    CMP AL, BL
    JNE CMP_NO
    INC SI
    INC DI
    JMP CMP_LOOP
CMP_CHK_END:
    CMP BL, 0
    JE  CMP_OK
CMP_NO:
    MOV AL, 1
    RET
CMP_OK:
    MOV AL, 0
    RET
COMPARE ENDP

; ================================================================
; DISPLAY MENU
; ================================================================
DISPLAY_MENU PROC
    MOV AH, 09H
    LEA DX, MENU_MSG
    INT 21H
    RET
DISPLAY_MENU ENDP

; ================================================================
; GET OPTION
; ================================================================
GET_OPTION PROC
    MOV AH, 01H
    INT 21H
    RET
GET_OPTION ENDP

; ================================================================
; STRING TO NUMBER
; ================================================================
STR_TO_NUM PROC
    MOV AX, 0
    MOV BX, 10
SN_LOOP:
    MOV CL, [SI]
    CMP CL, 0DH
    JE  SN_DONE
    CMP CL, '0'
    JB  SN_DONE
    CMP CL, '9'
    JA  SN_DONE
    SUB CL, 30H
    MOV CH, 0
    MUL BX
    ADD AX, CX
    INC SI
    JMP SN_LOOP
SN_DONE:
    RET
STR_TO_NUM ENDP

; ================================================================
; PRINT NUMBER
; ================================================================
PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0
    MOV BX, 10
PN_LOOP:
    MOV DX, 0
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PN_LOOP
PN_DISP:
    POP DX
    ADD DL, 30H
    MOV AH, 02H
    INT 21H
    LOOP PN_DISP
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP

; ================================================================
; PRINT MONEY - prints a 32-bit value stored in CENTS as "XXX.YY"
; Caller must set DX:AX = the value in cents BEFORE calling
; (DX = high word, AX = low word - needed because a single 16-bit
; register can only hold up to 65535, i.e. RM655.35; anything from
; RM655.36 to RM999.99 needs the extra bits carried in DX)
; e.g. DX=0,AX=2350 prints "23.50" | DX=1,AX=34499 prints "999.99"
; ================================================================
PRINT_MONEY PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV BX, 100
    DIV BX              ; DX:AX (32-bit) / 100 -> AX=ringgit part, DX=cents part (0-99)
    MOV CX, DX          ; save cents part in CX - CALL PRINT_NUM preserves CX for us
    
    CALL PRINT_NUM       ; prints the ringgit part (plain number, no leading zeros)
    
    MOV AH, 02H
    MOV DL, '.'
    INT 21H
    
    MOV AX, CX            ; AX = cents part (0-99)
    MOV BX, 10
    MOV DX, 0
    DIV BX                ; AX = tens digit, DX = ones digit
    MOV CX, DX             ; save ones digit
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H                ; print tens digit
    
    MOV DL, CL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H                ; print ones digit
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_MONEY ENDP

; ================================================================
; GE32 - compares two 32-bit values: is (DX:AX) >= (CX:BX) ?
; Returns AL = 1 if true, AL = 0 if false. Needed because a single
; CMP instruction can't compare 32-bit values - we compare the high
; words first, and only look at the low words if the high words tie.
; ================================================================
GE32 PROC
    PUSH DX
    
    CMP DX, CX
    JG  GE32_YES          ; high(A) > high(B) -> A is bigger, done
    JL  GE32_NO            ; high(A) < high(B) -> A is smaller, done
    ; high words are equal - the low words decide it
    CMP AX, BX
    JAE GE32_YES
    
GE32_NO:
    POP DX
    MOV AL, 0
    RET
    
GE32_YES:
    POP DX
    MOV AL, 1
    RET
GE32 ENDP

; ================================================================
; MUL32x16 - multiplies a 32-bit value (DX:AX) by a small 16-bit
; number (BX), result back in DX:AX. Needed because MUL only
; multiplies two 16-bit numbers together (giving a 32-bit result) -
; it can't take a 32-bit number as input directly, so we split the
; 32-bit value into its two halves and combine the two partial
; products ourselves.
; ================================================================
MUL32x16 PROC
    PUSH CX
    PUSH BX
    
    MOV CX, BX          ; CX = the multiplier (save it, BX gets reused by MUL)
    PUSH AX              ; save the low word of the value being multiplied
    MOV AX, DX           ; AX = high word of the value
    MUL CX                ; DX:AX = high_word * multiplier
    MOV BX, AX             ; BX = that result's low word - this becomes part of our new high word
    POP AX                  ; restore the low word of the original value
    MUL CX                   ; DX:AX = low_word * multiplier (this is the main 32-bit product)
    ADD DX, BX                ; fold in the shifted contribution from the high word
    
    POP BX
    POP CX
    RET
MUL32x16 ENDP

; ================================================================
; PRINT NUMBER TWO DIGITS - ????
; ================================================================
PRINT_NUM_TWO_DIGITS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; cap at 999 instead of 99, now supports 3-digit numbers
    CMP AX, 999
    JBE  PNTD_OK
    MOV AX, 999
    
PNTD_OK:
    MOV CX, AX          ; CX = value to print (0-999)
    
    ; ---- hundreds digit ----
    MOV AX, CX
    MOV BX, 100
    MOV DX, 0
    DIV BX              ; AX = hundreds digit, DX = remainder (0-99)
    MOV CX, DX          ; keep remainder for the tens/ones step below
    CMP AX, 0
    JNE PNTD_H_SHOW
    MOV DL, ' '         ; no leading zero for the hundreds place
    JMP PNTD_H_PRINT
PNTD_H_SHOW:
    MOV DL, AL
    ADD DL, 30H
PNTD_H_PRINT:
    MOV AH, 02H
    INT 21H
    
    ; ---- tens + ones digits ----
    MOV AX, CX          ; AX = remainder (0-99)
    MOV BX, 10
    MOV DX, 0
    DIV BX              ; AX = tens digit, DX = ones digit
    MOV BL, DL          ; save ones digit BEFORE DL is reused below
    MOV DL, AL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H             ; print tens digit
    
    MOV DL, BL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H             ; print ones digit
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM_TWO_DIGITS ENDP

; ================================================================
; SHOW TABLE
; ================================================================
SHOW_TABLE PROC
    MOV AH, 09H
    LEA DX, TABLE_HEADER
    INT 21H
    
    ; ??1
    LEA DX, P1
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[0]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[0]
    MOV DX, P_PRICES_HI[0]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??2
    LEA DX, P2
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[2]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[2]
    MOV DX, P_PRICES_HI[2]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??3
    LEA DX, P3
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[4]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[4]
    MOV DX, P_PRICES_HI[4]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??4
    LEA DX, P4
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[6]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[6]
    MOV DX, P_PRICES_HI[6]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??5
    LEA DX, P5
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[8]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[8]
    MOV DX, P_PRICES_HI[8]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??6
    LEA DX, P6
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[10]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[10]
    MOV DX, P_PRICES_HI[10]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??7
    LEA DX, P7
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[12]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[12]
    MOV DX, P_PRICES_HI[12]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; ??8
    LEA DX, P8
    MOV AH, 09H
    INT 21H
    MOV AX, P_STOCKS[14]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[14]
    MOV DX, P_PRICES_HI[14]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    RET
SHOW_TABLE ENDP

; ================================================================
; GET ID
; ================================================================
GET_ID PROC
    MOV AH, 09H
    LEA DX, P_ID
    INT 21H
    
    MOV AH, 0AH
    LEA DX, BUF_ID
    INT 21H
    
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    ; ??????? Enter (???)
    MOV BL, BUF_ID + 2
    CMP BL, 0DH
    JE  GID_EMPTY
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JB  GID_ERR
    CMP AX, 8
    JA  GID_ERR
    
    DEC AX
    MOV IDX, AX
    CLC
    RET

GID_EMPTY:
    ; ???,??????
    MOV AX, 0
    STC
    RET

GID_ERR:
    MOV AH, 09H
    LEA DX, E_ID
    INT 21H
    CALL WAIT_KEY
    STC
    RET
GET_ID ENDP

; ================================================================
; GET QTY
; ================================================================
GET_QTY PROC
    MOV AH, 09H
    LEA DX, P_QTY
    INT 21H
    
    MOV AH, 0AH
    LEA DX, BUF_QTY
    INT 21H
    
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_QTY + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JB  GQT_ERR
    CMP AX, 999
    JA  GQT_ERR
    
    MOV QTY, AX
    CLC
    RET

GQT_ERR:
    MOV AH, 09H
    LEA DX, E_QTY
    INT 21H
    CALL WAIT_KEY
    STC
    RET
GET_QTY ENDP

; ================================================================
; MAKE SALE
; ================================================================
MAKE_SALE PROC
    MOV TOTAL_LO, 0
    MOV TOTAL_HI, 0
    INC TOTAL_CUSTOMERS
    
    MOV SI, 0
    MOV CX, 8
MS_RESET_CART:
    MOV CART_QTY[SI], 0
    ADD SI, 2
    DEC CX
    JZ  MS_RESET_DONE
    JMP MS_RESET_CART
MS_RESET_DONE:
    
MS_LOOP:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    
    CALL GET_ID
    JC  MS_CHECK_EMPTY
    
    CALL GET_QTY
    JC  MS_LOOP
    
    MOV BX, IDX
    ADD BX, BX
    MOV AX, P_STOCKS[BX]
    CMP AX, QTY
    JAE MS_STOCK_OK
    
    MOV AH, 09H
    LEA DX, E_STOCK
    INT 21H
    CALL WAIT_KEY
    CALL CLEAR_SCREEN
    JMP MS_LOOP

MS_CHECK_EMPTY:
    MOV AX, IDX
    CMP AX, 0
    JNE MS_LOOP
    
    MOV AH, 09H
    LEA DX, MSG_BUY
    INT 21H
    MOV AH, 01H
    INT 21H
    
    CMP AL, 'y'
    JE  MS_LOOP
    CMP AL, 'Y'
    JE  MS_LOOP
    CMP AL, 'n'
    JE  MS_GO_MENU
    CMP AL, 'N'
    JE  MS_GO_MENU
    JMP MS_LOOP

MS_GO_MENU:
    JMP MS_EXIT

MS_STOCK_OK:
    MOV BX, IDX
    ADD BX, BX
    MOV AX, P_STOCKS[BX]
    SUB AX, QTY
    MOV P_STOCKS[BX], AX
    
    MOV BX, IDX
    ADD BX, BX
    MOV AX, P_SOLD[BX]
    ADD AX, QTY
    MOV P_SOLD[BX], AX
    
    MOV AX, CART_QTY[BX]
    ADD AX, QTY
    MOV CART_QTY[BX], AX
    
    MOV BX, IDX
    ADD BX, BX
    MOV AX, P_PRICES_LO[BX]
    MOV DX, P_PRICES_HI[BX]
    MOV PRICE_LO, AX
    MOV PRICE_HI, DX
    MOV BX, QTY
    CALL MUL32x16          ; DX:AX = price(32-bit) * QTY - this line's total, in cents
    ADD TOTAL_LO, AX
    ADC TOTAL_HI, DX        ; accumulate into the running 32-bit TOTAL, carrying if needed
    
    MOV AH, 09H
    LEA DX, P_AGAIN
    INT 21H
    MOV AH, 01H
    INT 21H
    
    CMP AL, 'y'
    JE  MS_AGAIN
    CMP AL, 'Y'
    JE  MS_AGAIN
    JMP MS_PAY_START

MS_AGAIN:
    CALL CLEAR_SCREEN
    JMP MS_LOOP

MS_PAY_START:
    CALL CLEAR_SCREEN
    
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    MOV SUBTOTAL_LO, AX
    MOV SUBTOTAL_HI, DX     ; keep the pre-tax, pre-discount amount for the receipt
    
    MOV DISCOUNT_LO, 0
    MOV DISCOUNT_HI, 0
    
    MOV CX, 0
    MOV BX, 5000
    CALL GE32                ; is SUBTOTAL (DX:AX) >= 5000 cents (RM50.00)?
    CMP AL, 1
    JE  MS_APPLY_DISCOUNT
    JMP MS_NO_DISCOUNT
    
MS_APPLY_DISCOUNT:
    MOV AX, SUBTOTAL_LO
    MOV DX, SUBTOTAL_HI
    MOV BX, 10
    CALL MUL32x16            ; DX:AX = subtotal * 10
    MOV BX, 100
    DIV BX                    ; AX = the discount amount (10% of subtotal)
    MOV DISCOUNT_LO, AX
    MOV DISCOUNT_HI, 0
    
    MOV AH, 09H
    LEA DX, MSG_DISCOUNT_YES
    INT 21H
    
MS_NO_DISCOUNT:
    MOV AX, SUBTOTAL_LO
    MOV DX, SUBTOTAL_HI
    SUB AX, DISCOUNT_LO
    SBB DX, DISCOUNT_HI
    MOV TOTAL_LO, AX
    MOV TOTAL_HI, DX          ; TOTAL = subtotal minus discount (before tax)
    
    MOV BX, 6
    CALL MUL32x16              ; DX:AX = TOTAL * 6
    MOV BX, 100
    DIV BX                      ; AX = the tax amount (6% of the discounted total)
    MOV TAX_LO, AX
    MOV TAX_HI, 0
    
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    ADD AX, TAX_LO
    ADC DX, TAX_HI
    MOV TOTAL_LO, AX
    MOV TOTAL_HI, DX            ; TOTAL now includes tax - this is what's due
    
    MOV AH, 09H
    LEA DX, MSG_TOTAL_DUE
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
MS_PAY:
    MOV AH, 09H
    LEA DX, P_PAY
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_PAY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_PAY + 2
    CALL STR_TO_NUM
    MOV BX, 100
    MUL BX                  ; DX:AX = ringgit part * 100 (a full 32-bit product)
    MOV PAY_TEMP_LO, AX
    MOV PAY_TEMP_HI, DX      ; save it while we read the cents field below
    
    MOV AH, 09H
    LEA DX, P_PAY_CENTS
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_CENTS
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_CENTS + 2
    CALL STR_TO_NUM
    
    CMP AX, 99
    JBE MS_PAY_CENTS_OK
    MOV AH, 09H
    LEA DX, E_PAY
    INT 21H
    JMP MS_PAY
    
MS_PAY_CENTS_OK:
    ADD PAY_TEMP_LO, AX
    ADC PAY_TEMP_HI, 0        ; combine ringgit-in-cents and cents into one 32-bit total
    MOV AX, PAY_TEMP_LO
    MOV DX, PAY_TEMP_HI
    MOV CASH_LO, AX
    MOV CASH_HI, DX           ; keep it for the receipt's "Cash: RM __" line
    
    MOV AX, CASH_LO
    MOV DX, CASH_HI
    MOV BX, TOTAL_LO
    MOV CX, TOTAL_HI
    CALL GE32                  ; is CASH (DX:AX) >= TOTAL (CX:BX)?
    CMP AL, 1
    JE  MS_PAY_OK
    MOV AH, 09H
    LEA DX, E_PAY
    INT 21H
    JMP MS_PAY

MS_PAY_OK:
    MOV AX, CASH_LO
    MOV DX, CASH_HI
    SUB AX, TOTAL_LO
    SBB DX, TOTAL_HI
    MOV CHANGE_LO, AX
    MOV CHANGE_HI, DX
    
    MOV AX, TOTAL_REVENUE_LO
    MOV DX, TOTAL_REVENUE_HI
    ADD AX, TOTAL_LO
    ADC DX, TOTAL_HI
    MOV TOTAL_REVENUE_LO, AX
    MOV TOTAL_REVENUE_HI, DX
    
    CALL PRINT_RECEIPT
    JMP MS_DONE

MS_DONE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  MS_NEW
    CMP AL, 'Y'
    JE  MS_NEW
    RET

MS_NEW:
    MOV TOTAL_LO, 0
    MOV TOTAL_HI, 0
    INC TOTAL_CUSTOMERS
    
    MOV SI, 0
    MOV CX, 8
MS_NEW_RESET_CART:
    MOV CART_QTY[SI], 0
    ADD SI, 2
    DEC CX
    JZ  MS_NEW_RESET_DONE
    JMP MS_NEW_RESET_CART
MS_NEW_RESET_DONE:
    
    CALL CLEAR_SCREEN
    JMP MS_LOOP

MS_EXIT:
    RET
MAKE_SALE ENDP

; ================================================================
; PRINT RECEIPT
; ================================================================
PRINT_RECEIPT PROC
    MOV AH, 09H
    LEA DX, R_HEAD
    INT 21H
    
    ; ---- ALL ITEMS (running total for this whole session) ----
    MOV AH, 09H
    LEA DX, R_ALL_HEAD
    INT 21H
    
    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    
    ; ??1
    MOV AX, P_SOLD[0]
    CMP AX, 0
    JE  PR_SKIP_1
    LEA DX, P1
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[0]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    ; ?? = ?? � ??
    MOV AX, P_PRICES_LO[0]
    MOV DX, P_PRICES_HI[0]
    MOV BX, P_SOLD[0]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_1:

    ; ??2
    MOV AX, P_SOLD[2]
    CMP AX, 0
    JE  PR_SKIP_2
    LEA DX, P2
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[2]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[2]
    MOV DX, P_PRICES_HI[2]
    MOV BX, P_SOLD[2]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_2:

    ; ??3
    MOV AX, P_SOLD[4]
    CMP AX, 0
    JE  PR_SKIP_3
    LEA DX, P3
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[4]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[4]
    MOV DX, P_PRICES_HI[4]
    MOV BX, P_SOLD[4]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_3:

    ; ??4
    MOV AX, P_SOLD[6]
    CMP AX, 0
    JE  PR_SKIP_4
    LEA DX, P4
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[6]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[6]
    MOV DX, P_PRICES_HI[6]
    MOV BX, P_SOLD[6]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_4:

    ; ??5
    MOV AX, P_SOLD[8]
    CMP AX, 0
    JE  PR_SKIP_5
    LEA DX, P5
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[8]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[8]
    MOV DX, P_PRICES_HI[8]
    MOV BX, P_SOLD[8]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_5:

    ; ??6
    MOV AX, P_SOLD[10]
    CMP AX, 0
    JE  PR_SKIP_6
    LEA DX, P6
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[10]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[10]
    MOV DX, P_PRICES_HI[10]
    MOV BX, P_SOLD[10]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_6:

    ; ??7
    MOV AX, P_SOLD[12]
    CMP AX, 0
    JE  PR_SKIP_7
    LEA DX, P7
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[12]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[12]
    MOV DX, P_PRICES_HI[12]
    MOV BX, P_SOLD[12]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_7:

    ; ??8
    MOV AX, P_SOLD[14]
    CMP AX, 0
    JE  PR_SKIP_8
    LEA DX, P8
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[14]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[14]
    MOV DX, P_PRICES_HI[14]
    MOV BX, P_SOLD[14]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_8:
    
    ; ---- YOUR ORDER (items bought in THIS transaction only) ----
    MOV AH, 09H
    LEA DX, R_NOW_HEAD
    INT 21H
    
    MOV SI, 0
    MOV CX, 8
PR_NOW_LOOP:
    MOV AX, CART_QTY[SI]
    CMP AX, 0
    JNE PR_NOW_PRINT
    JMP PR_NOW_SKIP
    
PR_NOW_PRINT:
    MOV DX, P_NAMES[SI]
    MOV AH, 09H
    INT 21H
    MOV AX, CART_QTY[SI]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[SI]
    MOV DX, P_PRICES_HI[SI]
    MOV BX, CART_QTY[SI]
    CALL MUL32x16
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
PR_NOW_SKIP:
    ADD SI, 2
    DEC CX
    JZ  PR_NOW_DONE
    JMP PR_NOW_LOOP
    
PR_NOW_DONE:

    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_SUBTOTAL
    INT 21H
    MOV AX, SUBTOTAL_LO
    MOV DX, SUBTOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AX, DISCOUNT_LO
    OR  AX, DISCOUNT_HI      ; combine both words - result is 0 only if BOTH are 0
    JZ  PR_SKIP_DISCOUNT
    MOV AH, 09H
    LEA DX, R_DISCOUNT
    INT 21H
    MOV AX, DISCOUNT_LO
    MOV DX, DISCOUNT_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_DISCOUNT:
    
    MOV AH, 09H
    LEA DX, R_TAX
    INT 21H
    MOV AX, TAX_LO
    MOV DX, TAX_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_TOTAL
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_CASH
    INT 21H
    MOV AX, CASH_LO
    MOV DX, CASH_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_CHANGE
    INT 21H
    MOV AX, CHANGE_LO
    MOV DX, CHANGE_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_FOOT
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG_TRANS_OK
    INT 21H
    
    CALL WAIT_KEY
    RET
PRINT_RECEIPT ENDP

; ================================================================
; INVENTORY MENU
; ================================================================
INVENTORY_MENU PROC
IM_LOOP:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    MOV AH, 09H
    LEA DX, INV_MENU
    INT 21H
    CALL GET_OPTION
    
    CMP AL, '1'
    JE  IM_UPDATE
    CMP AL, '2'
    JE  IM_REDUCE
    CMP AL, '3'
    JE  IM_EDIT
    CMP AL, '4'
    JE  IM_BACK
    JMP IM_LOOP

IM_UPDATE:
    CALL UPDATE_STOCK
    JMP IM_LOOP

IM_REDUCE:
    CALL REDUCE_STOCK
    JMP IM_LOOP

IM_EDIT:
    CALL EDIT_PRICE_PROC
    JMP IM_LOOP

IM_BACK:
    RET
INVENTORY_MENU ENDP

; ================================================================
; UPDATE STOCK
; ================================================================
UPDATE_STOCK PROC
US_START:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    
    MOV AH, 09H
    LEA DX, P_ID
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_ID
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV AL, BUF_ID + 2
    CMP AL, 0DH
    JNE US_ID_NOT_BLANK
    JMP US_CHECK_CONTINUE
US_ID_NOT_BLANK:
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JAE US_ID_CHECK1
    JMP US_ERR_ID
US_ID_CHECK1:
    MOV BX, P_COUNT
    CMP AX, BX
    JBE US_ID_CHECK2
    JMP US_ERR_ID
US_ID_CHECK2:
    
    DEC AX
    MOV IDX, AX
    
    MOV AH, 09H
    LEA DX, P_QTY
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_QTY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_QTY + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JAE US_QTY_CHECK1
    JMP US_ERR_QTY
US_QTY_CHECK1:
    CMP AX, 999
    JBE US_QTY_CHECK2
    JMP US_ERR_QTY
US_QTY_CHECK2:
    
    MOV QTY, AX             ; save the validated quantity, the confirm prompt below will overwrite AX
    
    MOV AH, 09H
    LEA DX, CONFIRM_UPDATE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  US_DO_UPDATE
    CMP AL, 'Y'
    JE  US_DO_UPDATE
    
    MOV AH, 09H
    LEA DX, MSG_CANCELLED
    INT 21H
    CALL WAIT_KEY
    RET
    
US_DO_UPDATE:
    MOV BX, IDX
    ADD BX, BX
    MOV CX, P_STOCKS[BX]
    ADD CX, QTY
    MOV P_STOCKS[BX], CX
    
    MOV AH, 09H
    LEA DX, MSG_UPDATE_OK
    INT 21H
    CALL WAIT_KEY
    RET

US_ERR_ID:
    MOV AH, 09H
    LEA DX, E_ID
    INT 21H
    CALL WAIT_KEY
    JMP US_START

US_ERR_QTY:
    MOV AH, 09H
    LEA DX, E_QTY
    INT 21H
    CALL WAIT_KEY
    JMP US_START

US_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  US_GO_START
    CMP AL, 'Y'
    JE  US_GO_START
    RET
US_GO_START:
    JMP US_START
UPDATE_STOCK ENDP

; ================================================================
; REDUCE STOCK
; ================================================================
REDUCE_STOCK PROC
RS_START:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    
    MOV AH, 09H
    LEA DX, P_ID
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_ID
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV AL, BUF_ID + 2
    CMP AL, 0DH
    JNE RS_ID_NOT_BLANK
    JMP RS_CHECK_CONTINUE
RS_ID_NOT_BLANK:
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JAE RS_ID_CHECK1
    JMP RS_ERR_ID
RS_ID_CHECK1:
    MOV BX, P_COUNT
    CMP AX, BX
    JBE RS_ID_CHECK2
    JMP RS_ERR_ID
RS_ID_CHECK2:
    
    DEC AX
    MOV IDX, AX
    
    MOV AH, 09H
    LEA DX, P_QTY
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_QTY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_QTY + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JAE RS_QTY_CHECK1
    JMP RS_ERR_QTY
RS_QTY_CHECK1:
    CMP AX, 999
    JBE RS_QTY_CHECK2
    JMP RS_ERR_QTY
RS_QTY_CHECK2:
    
    MOV BX, IDX
    ADD BX, BX
    MOV CX, P_STOCKS[BX]
    CMP CX, AX
    JB  RS_NO_STOCK
    
    MOV QTY, AX             ; save the validated quantity, the confirm prompt below will overwrite AX
    
    MOV AH, 09H
    LEA DX, CONFIRM_REDUCE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  RS_DO_REDUCE
    CMP AL, 'Y'
    JE  RS_DO_REDUCE
    
    MOV AH, 09H
    LEA DX, MSG_CANCELLED
    INT 21H
    CALL WAIT_KEY
    RET
    
RS_DO_REDUCE:
    SUB CX, QTY
    MOV P_STOCKS[BX], CX
    
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_REDUCE_OK
    INT 21H
    CALL WAIT_KEY
    RET

RS_NO_STOCK:
    MOV AH, 09H
    LEA DX, E_REDUCE
    INT 21H
    CALL WAIT_KEY
    JMP RS_START

RS_ERR_ID:
    MOV AH, 09H
    LEA DX, E_ID
    INT 21H
    CALL WAIT_KEY
    JMP RS_START

RS_ERR_QTY:
    MOV AH, 09H
    LEA DX, E_QTY
    INT 21H
    CALL WAIT_KEY
    JMP RS_START

RS_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  RS_GO_START
    CMP AL, 'Y'
    JE  RS_GO_START
    RET
RS_GO_START:
    JMP RS_START
REDUCE_STOCK ENDP

; ================================================================
; EDIT PRICE - ????
; ================================================================
EDIT_PRICE_PROC PROC
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    
EP_START:
    MOV AH, 09H
    LEA DX, P_ID
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_ID
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV AL, BUF_ID + 2
    CMP AL, 0DH
    JNE EP_ID_NOT_BLANK
    JMP EP_CHECK_CONTINUE
EP_ID_NOT_BLANK:
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JGE EP_ID_OK
    JMP EP_ERR
    
EP_ID_OK:
    CMP AX, 8
    JLE EP_ID_VALID
    JMP EP_ERR
    
EP_ID_VALID:
    DEC AX
    MOV IDX, AX
    
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AX, IDX
    ADD AX, AX
    MOV SI, AX
    MOV DX, P_NAMES[SI]
    MOV AH, 09H
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, IDX
    ADD AX, AX
    MOV SI, AX
    MOV AX, P_PRICES_LO[SI]
    MOV DX, P_PRICES_HI[SI]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, EDIT_PRICE
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_PAY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV AL, BUF_PAY + 2
    CMP AL, 0DH
    JNE EP_NOT_BLANK
    JMP EP_DONE
EP_NOT_BLANK:
    
    LEA SI, BUF_PAY + 2
    CALL STR_TO_NUM
    
    CMP AX, 999
    JBE EP_RINGGIT_OK
    JMP EP_PRICE_ERR
    
EP_RINGGIT_OK:
    MOV BX, 100
    MUL BX                  ; DX:AX = ringgit part * 100 - MUL always gives a full 32-bit
                             ; result, so this is correct even for large ringgit values
    MOV PAY_TEMP_LO, AX
    MOV PAY_TEMP_HI, DX      ; save the 32-bit value while we read the cents field below
    
    MOV AH, 09H
    LEA DX, EDIT_PRICE_CENTS
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_CENTS
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_CENTS + 2
    CALL STR_TO_NUM
    
    CMP AX, 99
    JBE EP_CENTS_OK
    JMP EP_PRICE_ERR
    
EP_CENTS_OK:
    ADD PAY_TEMP_LO, AX
    ADC PAY_TEMP_HI, 0       ; add cents into the 32-bit total, carrying into the high
                             ; word if the low word wraps past 65535
    
    MOV AX, PAY_TEMP_LO
    MOV DX, PAY_TEMP_HI
    
    CMP DX, 0
    JNE EP_CHECK_MAX
    CMP AX, 0
    JNE EP_CHECK_MAX
    JMP EP_PRICE_ERR         ; both zero - price would be RM0.00, reject
    
EP_CHECK_MAX:
    CMP DX, 1
    JBE EP_CHECK_MAX2
    JMP EP_PRICE_ERR          ; high word > 1 means way over RM999.99, reject
    
EP_CHECK_MAX2:
    CMP DX, 1
    JNE EP_PRICE_VALID          ; high word is 0 -> value is <= 65535, always in range
    CMP AX, 34463
    JBE EP_PRICE_VALID
    JMP EP_PRICE_ERR              ; high word is 1 but too far over -> exceeds RM999.99
    
EP_PRICE_VALID:
    MOV AX, PAY_TEMP_LO
    MOV DX, PAY_TEMP_HI
    MOV PRICE_LO, AX
    MOV PRICE_HI, DX  ; save the validated new price - the confirm prompt below overwrites AX/DX
    
    MOV AH, 09H
    LEA DX, CONFIRM_PRICE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  EP_DO_UPDATE
    CMP AL, 'Y'
    JE  EP_DO_UPDATE
    
    MOV AH, 09H
    LEA DX, MSG_CANCELLED
    INT 21H
    CALL WAIT_KEY
    RET
    
EP_DO_UPDATE:
    MOV BX, IDX
    ADD BX, BX
    MOV AX, PRICE_LO
    MOV DX, PRICE_HI
    MOV P_PRICES_LO[BX], AX
    MOV P_PRICES_HI[BX], DX
    JMP EP_DONE
    
EP_PRICE_ERR:
    MOV AH, 09H
    LEA DX, E_EDIT_PRICE
    INT 21H
    CALL WAIT_KEY
    JMP EP_START
    
EP_DONE:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_EDIT_OK
    INT 21H
    CALL WAIT_KEY
    RET

EP_ERR:
    MOV AH, 09H
    LEA DX, E_ID
    INT 21H
    CALL WAIT_KEY
    JMP EP_START

EP_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  EP_GO_START
    CMP AL, 'Y'
    JE  EP_GO_START
    RET
EP_GO_START:
    JMP EP_START
EDIT_PRICE_PROC ENDP

; ================================================================
; REPORT
; ================================================================

REPORT PROC
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, R_HEAD
    INT 21H
    
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AH, 09H
    LEA DX, REPORT_HEADER
    INT 21H
    MOV AH, 09H
    LEA DX, REPORT_LINE
    INT 21H
    
    MOV DI, 0
    
    ; ??1
    LEA DX, P1
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[0]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[0]
    MOV DX, P_PRICES_HI[0]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[0]
    ADD DI, AX

    ; ??2
    LEA DX, P2
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[2]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[2]
    MOV DX, P_PRICES_HI[2]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[2]
    ADD DI, AX

    ; ??3
    LEA DX, P3
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[4]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[4]
    MOV DX, P_PRICES_HI[4]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[4]
    ADD DI, AX

    ; ??4
    LEA DX, P4
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[6]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[6]
    MOV DX, P_PRICES_HI[6]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[6]
    ADD DI, AX

    ; ??5
    LEA DX, P5
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[8]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[8]
    MOV DX, P_PRICES_HI[8]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[8]
    ADD DI, AX

    ; ??6
    LEA DX, P6
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[10]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[10]
    MOV DX, P_PRICES_HI[10]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[10]
    ADD DI, AX

    ; ??7
    LEA DX, P7
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[12]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[12]
    MOV DX, P_PRICES_HI[12]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[12]
    ADD DI, AX

    ; ??8
    LEA DX, P8
    MOV AH, 09H
    INT 21H
    MOV AX, P_SOLD[14]
    CALL PRINT_NUM_TWO_DIGITS
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, P_PRICES_LO[14]
    MOV DX, P_PRICES_HI[14]
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    MOV AX, P_SOLD[14]
    ADD DI, AX

    MOV AH, 09H
    LEA DX, REPORT_LINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_TOTAL
    INT 21H
    MOV AX, DI
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_REVENUE
    INT 21H
    MOV AX, TOTAL_REVENUE_LO
    MOV DX, TOTAL_REVENUE_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_CUSTOMERS
    INT 21H
    MOV AX, TOTAL_CUSTOMERS
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_LINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_FOOT
    INT 21H
    
    CALL WAIT_KEY
    RET
REPORT ENDP
; ================================================================
; CONFIRM EXIT
; ================================================================
CONFIRM_EXIT PROC
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, CONFIRM_MSG
    INT 21H
    MOV AH, 01H
    INT 21H
    RET
CONFIRM_EXIT ENDP

CONFIRM_LOGOUT PROC
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, CONFIRM_LOGOUT_MSG
    INT 21H
    MOV AH, 01H
    INT 21H
    RET
CONFIRM_LOGOUT ENDP

; ================================================================
; END
; ================================================================
END MAIN