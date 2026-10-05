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

WELCOME_MSG DB  0AH,0DH,'=================================',0AH,0DH
            DB  '      CAMPUS STATIONERY POS',0AH,0DH
            DB  '=================================',0AH,0DH,'$'
PROMPT_USER DB  0AH,0DH,'Username: $'
PROMPT_PASS DB  'Password: $'
LOGIN_OK    DB  0AH,0DH,'================================',0AH,0DH
            DB  '        Login Successful!',0AH,0DH
            DB  '================================',0AH,0DH,'$'
LOGIN_BAD   DB  0AH,0DH,'Invalid! Remaining attempts: $'
LOGIN_LOCK  DB  0AH,0DH,'================================',0AH,0DH
            DB  'Account Locked! Too many attempts.',0AH,0DH
            DB  '================================',0AH,0DH,'$'

; ================================================================
; AUTH MENU / REGISTER
; ================================================================
CURRENT_ROLE DB 0          ; 0 = admin, 1 = customer

AUTH_MSG    DB  0AH,0DH,'=================================',0AH,0DH
            DB  '      CAMPUS STATIONERY POS',0AH,0DH
            DB  '=================================',0AH,0DH
            DB  ' 1. Login',0AH,0DH
            DB  ' 2. Register',0AH,0DH
            DB  ' 3. Exit',0AH,0DH
            DB  '================================',0AH,0DH
            DB  'Select: $'

MAX_CUSTOMERS   EQU 20
CUST_NAME_LEN   EQU 21     ; 20 chars + NUL
CUST_PASS_LEN   EQU 5      ; 4 digits + NUL
CUST_COUNT  DB  0
CUST_NAMES  DB  MAX_CUSTOMERS * CUST_NAME_LEN DUP(0)
CUST_PASS   DB  MAX_CUSTOMERS * CUST_PASS_LEN DUP(0)

IN_NAME     DB  21, 0, 20 DUP('$')
IN_PASS2    DB  21, 0, 20 DUP('$')

REG_HEADER  DB  0AH,0DH,'================================',0AH,0DH
            DB  '           REGISTER',0AH,0DH
            DB  '================================',0AH,0DH,'$'
PROMPT_NAME DB  0AH,0DH,'Name: $'
PROMPT_NEWPASS DB 0AH,0DH,'Password (4 digits): $'
PROMPT_CONFIRMPASS DB 0AH,0DH,'Confirm Password (4 digits): $'
E_REG_FULL  DB  0AH,0DH,'ERROR: Registration is full, please try again later.$'
E_REG_TAKEN DB  0AH,0DH,'ERROR: This name is already taken. Please choose another.$'
E_REG_PASS  DB  0AH,0DH,'ERROR: Password must be exactly 4 digits (0-9).$'
E_REG_MISMATCH DB 0AH,0DH,'ERROR: Passwords do not match.$'
P_REG_RETRY DB 0AH,0DH,'Try again? (y/n): $'
MSG_REG_OK  DB  0AH,0DH,'Registration successful! You can now login.$'

; ================================================================
; MAIN MENU
; ================================================================
MENU_MSG   DB  0AH,0DH,'=================================',0AH,0DH
           DB  '      CAMPUS STATIONERY POS',0AH,0DH
           DB  '=================================',0AH,0DH
           DB  ' 1. Our Product',0AH,0DH
           DB  ' 2. Inventory Management',0AH,0DH
           DB  ' 3. Reports',0AH,0DH
           DB  ' 4. Logout',0AH,0DH
           DB  ' 5. Exit',0AH,0DH
           DB  '================================',0AH,0DH
           DB  'Select: $'

CUST_MENU_MSG DB 0AH,0DH,'=================================',0AH,0DH
           DB  '      CAMPUS STATIONERY POS',0AH,0DH
           DB  '=================================',0AH,0DH
           DB  ' 1. Our Product',0AH,0DH
           DB  ' 2. Logout',0AH,0DH
           DB  ' 3. Exit',0AH,0DH
           DB  '================================',0AH,0DH
           DB  'Select: $'

; ================================================================
; INVENTORY MENU
; ================================================================
INV_MENU   DB  0AH,0DH,'====================================',0AH,0DH
           DB  '     INVENTORY MANAGEMENT',0AH,0DH
           DB  '====================================',0AH,0DH
           DB  ' 1. Update Stock',0AH,0DH
           DB  ' 2. Reduce Stock',0AH,0DH
           DB  ' 3. Edit Price',0AH,0DH
           DB  ' 4. Back to Main Menu',0AH,0DH
           DB  '====================================',0AH,0DH
           DB  'Select: $'

; ================================================================
; OUR PRODUCT MENU
; ================================================================
OPM_MENU   DB  0AH,0DH,'====================================',0AH,0DH
           DB  '            OUR PRODUCT',0AH,0DH
           DB  '====================================',0AH,0DH
           DB  ' 1. Buy Product',0AH,0DH
           DB  ' 2. Delete Product',0AH,0DH
           DB  ' 3. View Cart',0AH,0DH
           DB  ' 4. Back to Main Menu',0AH,0DH
           DB  '====================================',0AH,0DH
           DB  'Select: $'

P_DEL_QTY   DB  0AH,0DH,'Enter Qty to delete: $'
E_NOT_IN_CART DB 0AH,0DH,'ERROR: This item is not in your cart.$'
E_DEL_QTY   DB  0AH,0DH,'ERROR: Invalid Qty! You cannot delete more than what is in your cart.$'
MSG_DEL_OK  DB  0AH,0DH,'Item removed from cart!$'
P_DEL_AGAIN DB  0AH,0DH,'Continue deleting? (y/n): $'

CART_HEAD   DB  0AH,0DH,'---------- YOUR CART ----------',0AH,0DH,'$'
MSG_CART_EMPTY DB 0AH,0DH,'Your cart is empty.$'
CART_TOTAL_LABEL DB 0AH,0DH,'Cart Total: RM $'

CONFIRM_ORDER DB 0AH,0DH,'Confirm order? (y/n): $'
CONFIRM_CANCEL DB 0AH,0DH,'Cancel order? (y/n): $'
MSG_ORDER_CANCELLED DB 0AH,0DH,'Order cancelled. Your cart has been cleared.$'

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
CART_EMPTY_FLAG DB 0
TOTAL_CUSTOMERS DW 0
TOTAL_REVENUE_LO DW 0
TOTAL_REVENUE_HI DW 0

; ================================================================
; INPUT BUFFERS
; ================================================================
BUF_ID  DB  5, 0, 5 DUP('$')
BUF_QTY DB  5, 0, 5 DUP('$')
BUF_PAY DB  8, 0, 8 DUP('$')
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

; ================================================================
; PROMPTS
; ================================================================
P_ID    DB  0AH,0DH,'Enter ID (1-8): $'
P_QTY   DB  0AH,0DH,'Enter Qty (1-999): $'
P_PAY   DB  0AH,0DH,'Enter Payment, e.g. 10.50: RM $'
P_AGAIN DB  0AH,0DH,'Add more items? (y/n): $'

E_ID    DB  0AH,0DH,'ERROR: Invalid ID! Enter 1-8 only.$'
E_QTY   DB  0AH,0DH,'ERROR: Invalid Qty! Enter 1-999 only.$'
E_PAY   DB  0AH,0DH,'ERROR: Not enough payment!$'
E_PAY_FORMAT DB 0AH,0DH,'ERROR: Invalid amount! Enter an amount like 10.50, 5.5 or 20.$'
E_STOCK DB  0AH,0DH,'ERROR: Not enough stock!$'
E_MAXSTOCK DB 0AH,0DH,'ERROR: Stock is already at maximum (999)! Cannot add more.$'
YN_INVALID DB 0AH,0DH,'Invalid input! Please enter Y or N only: $'

; ================================================================
; REDUCE STOCK MESSAGES
; ================================================================
MSG_REDUCE_OK DB  0AH,0DH,'Stock reduced successfully!$'
E_REDUCE      DB  0AH,0DH,'ERROR: Not enough stock to reduce!$'

; ================================================================
; EDIT PRODUCT MESSAGES
; ================================================================
MSG_EDIT_OK   DB  0AH,0DH,'Price updated successfully!$'
E_EDIT_PRICE  DB  0AH,0DH,'ERROR: Invalid price! Enter an amount like 0.23, 5.5 or 12 (RM0.01-RM999.99).$'
EDIT_PRICE    DB  0AH,0DH,'Enter new price, e.g. 0.23 (or Enter to skip): RM $'

; ================================================================
; RECEIPT
; ================================================================
R_HEAD  DB  0AH,0DH,'=====================================',0AH,0DH
        DB  '         STATIONERY RECEIPT',0AH,0DH
        DB  '=====================================',0AH,0DH,'$'
R_NOW_HEAD DB 0AH,0DH,'-------------------------------------',0AH,0DH
           DB  '            YOUR ORDER',0AH,0DH
           DB  '-------------------------------------',0AH,0DH,'$'
R_ALL_HEAD DB 0AH,0DH,'-------------------------------------',0AH,0DH
           DB  '     ALL ITEMS (This Session)',0AH,0DH,'$'
R_SUBTOTAL DB 'Subtotal:                   RM $'
R_DISCOUNT DB 'Discount:                 - RM $'
R_TAX   DB  'Tax (6%):                 + RM $'
R_TOTAL DB  'Total:                      RM $'
R_CASH  DB  'Cash:                       RM $'
R_CHANGE DB 'Change:                     RM $'
R_FOOT  DB  '=====================================',0AH,0DH
        DB  '             Thank You!',0AH,0DH
        DB  '=====================================$'

; ================================================================
; TABLE
; ================================================================
TABLE_HEADER DB 0AH,0DH,'Product                Stock  Price',0AH,0DH
             DB  '-------------------------------------',0AH,0DH,'$'
TABLE_LINE DB  '-------------------------------------',0AH,0DH,'$'

; ================================================================
; REPORT TABLE
; ================================================================
REPORT_HEADER  DB  'No  Product            Sold  Price',0AH,0DH,'$'
REPORT_LINE    DB  '-------------------------------------',0AH,0DH,'$'
REPORT_TOTAL   DB  'Total Items Sold : $'
REPORT_REVENUE DB  'Total Revenue    : RM $'
REPORT_CUSTOMERS DB 'Total Customers  : $'

; ================================================================
; CONFIRM
; ================================================================
CONFIRM_MSG DB 0AH,0DH,'Quit? (y/n): $'
CONFIRM_LOGOUT_MSG DB 0AH,0DH,'Are you sure you want to logout? (y/n): $'
MSG_CART_LOGOUT_WARN DB 0AH,0DH,'You still have items in your cart. Logging out will clear it.',0AH,0DH,'Continue? (y/n): $'
MSG_CONTINUE DB 0AH,0DH,'Do you want to continue? (y/n): $'
MSG_TOTAL_DUE DB 0AH,0DH,'Total Amount: RM $'
MSG_CLEAR DB 0AH,0DH,'Press any key to continue...$'
MSG_BUY DB  0AH,0DH,'Do you want to continue buying? (y/n): $'
MSG_RM DB 'RM $'
CONFIRM_UPDATE DB 0AH,0DH,'Confirm add this stock? (y/n): $'
CONFIRM_REDUCE DB 0AH,0DH,'Confirm reduce this stock? (y/n): $'
CONFIRM_PRICE  DB 0AH,0DH,'Confirm this price change? (y/n): $'
CONFIRM_DELETE DB 0AH,0DH,'Confirm delete this item? (y/n): $'
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
    CALL AUTH_MENU
    
MENU_LOOP:
    CALL CLEAR_SCREEN
    CALL DISPLAY_MENU
    CALL GET_OPTION
    
    CMP CURRENT_ROLE, 1
    JE  MENU_CUSTOMER
    
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

MENU_CUSTOMER:
    CMP AL, '1'
    JE  DO_SALE
    CMP AL, '2'
    JE  DO_LOGOUT
    CMP AL, '3'
    JE  DO_QUIT
    JMP MENU_LOOP

DO_SALE:
    CALL OUR_PRODUCT_MENU
    JMP MENU_LOOP

DO_INVENTORY:
    CALL INVENTORY_MENU
    JMP MENU_LOOP

DO_REPORT:
    CALL REPORT
    JMP MENU_LOOP

DO_QUIT:
    CALL CONFIRM_EXIT
    CMP AL, 'Y'
    JE  EXIT_PROG
    JMP MENU_LOOP

DO_LOGOUT:
    ; is the cart non-empty? scan it fresh instead of trusting a stale flag
    MOV BX, 0
    MOV CX, 8
    MOV DX, 0                   ; DX = 0 -> empty so far, 1 -> found something
DL_CHECK_LOOP:
    MOV AX, CART_QTY[BX]
    CMP AX, 0
    JE  DL_CHECK_NEXT
    MOV DX, 1
DL_CHECK_NEXT:
    ADD BX, 2
    DEC CX
    JNZ DL_CHECK_LOOP
    
    CMP DX, 0
    JE  DL_CONFIRM               ; cart's empty, nothing to warn about
    
    LEA DX, MSG_CART_LOGOUT_WARN
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    CMP AL, 'Y'
    JE  DL_CONFIRM
    JMP MENU_LOOP                 ; they backed out - stay logged in, cart untouched
    
DL_CONFIRM:
    CALL CONFIRM_LOGOUT
    CMP AL, 'Y'
    JE  DL_DO_LOGOUT
    JMP MENU_LOOP
    
DL_DO_LOGOUT:
    ; clear the cart so the next person to log in starts fresh
    MOV SI, 0
    MOV CX, 8
DL_CLEAR_LOOP:
    MOV CART_QTY[SI], 0
    ADD SI, 2
    DEC CX
    JNZ DL_CLEAR_LOOP
    MOV TOTAL_LO, 0
    MOV TOTAL_HI, 0
    
    JMP RESTART

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
    MOV DX, 184FH          ; scroll the whole 80x25 screen (row/col 0,0 to 24,79)
    MOV BH, 07H
    INT 10H
    MOV AH, 02H
    MOV BH, 0
    MOV DX, 0               ; put the cursor back at the top-left corner
    INT 10H
    RET
CLEAR_SCREEN ENDP

; ================================================================
; PRINT COLOR - like the normal "MOV AH,09H / INT 21H" string print,
; but in a colour. DOS's own print function always uses whatever
; colour is already on screen, so instead we use two BIOS calls
; per character:
;   AH=09H writes one character in a chosen colour at the cursor,
;          but does NOT move the cursor (CX = how many times to
;          write it - we just want 1)
;   AH=0EH "types" the same character again - this doesn't change
;          the colour already sitting there, it just moves the
;          cursor forward one space (and handles CR/LF for us)
;
; IN: DX = offset of a '$'-terminated string, BL = colour attribute
;     (use the COLOR_xxx constants below)
; ================================================================
COLOR_SUCCESS EQU 0AH        ; bright green
COLOR_ERROR   EQU 0CH        ; bright red
COLOR_WARN    EQU 0EH        ; yellow

PRINT_COLOR PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    MOV SI, DX               ; SI = the string to print
PCOL_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  PCOL_DONE
    
    CMP AL, 0DH               ; CR/LF have no visible glyph to colour -
    JE  PCOL_CTRL              ; painting them just leaves junk characters on screen,
    CMP AL, 0AH                 ; so skip straight to the teletype step for these two
    JE  PCOL_CTRL
    
    MOV AH, 09H                 ; paint this character in colour (cursor doesn't move yet)
    MOV BH, 0
    MOV CX, 1
    INT 10H
    
PCOL_CTRL:
    MOV AH, 0EH                  ; "type" it (again, for normal chars) just to move the cursor
    INT 10H
    
    INC SI
    JMP PCOL_LOOP
    
PCOL_DONE:
    POP SI
    POP CX
    POP BX
    POP AX
    RET
PRINT_COLOR ENDP

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
; GET Y/N - reads one keypress and only accepts y/Y/n/N.
; Any other key (including space) is rejected and re-prompted.
; Returns: AL = 'Y' or 'N' (normalized uppercase)
; ================================================================
GET_YN PROC
GYN_LOOP:
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'
    JE  GYN_YES
    CMP AL, 'Y'
    JE  GYN_YES
    CMP AL, 'n'
    JE  GYN_NO
    CMP AL, 'N'
    JE  GYN_NO
    
    PUSH AX
    LEA DX, YN_INVALID
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    POP AX
    JMP GYN_LOOP
    
GYN_YES:
    MOV AL, 'Y'
    RET
GYN_NO:
    MOV AL, 'N'
    RET
GET_YN ENDP

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
    MOV AH, 0AH             ; standard DOS buffered input, username is plain text (no masking)
    LEA DX, IN_USER
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV BL, IN_USER + 2
    CMP BL, 0DH
    JNE L_USER_OK
    JMP L_CHECK_CONTINUE       ; blank Enter -> maybe they haven't registered yet, offer a way out
L_USER_OK:
    MOV AH, 09H
    LEA DX, PROMPT_PASS
    INT 21H
    MOV DI, OFFSET IN_PASS + 2  ; password is masked, so this goes through GET_MASKED_INPUT instead
    MOV CX, 19
    CALL GET_MASKED_INPUT
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV BL, IN_PASS + 2
    CMP BL, 0DH
    JNE L_PASS_OK
    JMP L_CHECK_CONTINUE       ; blank Enter -> same escape hatch as above
L_PASS_OK:
    LEA SI, IN_USER + 2         ; first check: is this the admin/staff account?
    LEA DI, USERNAME
    CALL COMPARE
    CMP AL, 0
    JNE L_TRY_CUSTOMER
    
    LEA SI, IN_PASS + 2
    LEA DI, PASSWORD
    CALL COMPARE
    CMP AL, 0
    JNE L_TRY_CUSTOMER
    
    MOV CURRENT_ROLE, 0        ; admin/staff
    JMP L_SUCCESS

L_TRY_CUSTOMER:
    CALL FIND_CUSTOMER          ; not admin - see if it matches a registered customer instead
    JNC L_CUSTOMER_OK
    JMP L_FAIL
L_CUSTOMER_OK:
    MOV CURRENT_ROLE, 1         ; customer

L_SUCCESS:
    LEA DX, LOGIN_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    CLC
    RET

L_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  L_GO_START
    STC                         ; user doesn't want to continue -> bail out to Auth Menu
    RET
L_GO_START:
    JMP L_START

L_FAIL:
    INC LOGIN_ATTEMPTS
    LEA DX, LOGIN_BAD
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    MOV AL, MAX_ATTEMPTS         ; work out and print how many tries are actually left
    SUB AL, LOGIN_ATTEMPTS
    ADD AL, 30H                  ; turn the number into its ASCII digit
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, LOGIN_ATTEMPTS
    CMP AL, MAX_ATTEMPTS
    JE  L_LOCKED
    CALL WAIT_KEY
    JMP L_START

L_LOCKED:
    LEA DX, LOGIN_LOCK
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    MOV AH, 4CH                  ; too many bad tries - kill the whole program, no way back in
    INT 21H
LOGIN ENDP

; ================================================================
; GET MASKED INPUT - reads keys with a '*' echo until Enter.
; IN:  DI = destination buffer pointer, CX = max characters allowed
; OUT: [DI..] is filled with a CR-terminated string
; ================================================================
GET_MASKED_INPUT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    
    MOV SI, DI               ; SI = base of the destination buffer
    MOV BX, 0                  ; BX = characters typed so far
GMI_LOOP:
    MOV AH, 07H                ; read one key, no echo (we do our own '*' echo below)
    INT 21H
    CMP AL, 0DH
    JE  GMI_DONE
    CMP AL, 08H
    JE  GMI_BACKSPACE
    CMP BX, CX
    JE  GMI_LOOP                ; already at max length - ignore extra keys
    MOV DI, SI
    ADD DI, BX
    MOV [DI], AL
    INC BX
    MOV DL, '*'
    MOV AH, 02H
    INT 21H
    JMP GMI_LOOP
GMI_BACKSPACE:
    CMP BX, 0
    JE  GMI_LOOP                ; nothing typed yet - nothing to delete
    DEC BX
    MOV DL, 08H                  ; move cursor back, print a space to erase the '*', move back again
    MOV AH, 02H
    INT 21H
    MOV DL, ' '
    INT 21H
    MOV DL, 08H
    INT 21H
    JMP GMI_LOOP
GMI_DONE:
    MOV DI, SI
    ADD DI, BX
    MOV BYTE PTR [DI], 0DH      ; CR-terminate, same convention as DOS's own buffered input
    
    POP SI
    POP CX
    POP BX
    POP AX
    RET
GET_MASKED_INPUT ENDP

; ================================================================
; COMPARE STRINGS
; ================================================================
COMPARE PROC
    PUSH BX                     ; callers (e.g. FIND_CUSTOMER) use BX as a loop index -
                                 ; don't let this proc's use of BL clobber it
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
    POP BX
    RET
CMP_OK:
    MOV AL, 0
    POP BX
    RET
COMPARE ENDP

; ================================================================
; STRCMP_CR - compares two CR-terminated strings (used to check
; that Password and Confirm Password match during Register).
; Returns AL=0 if equal, AL=1 if different.
; ================================================================
STRCMP_CR PROC
SC_LOOP:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, 0DH
    JE  SC_CHK_END
    CMP BL, 0DH
    JE  SC_NO
    CMP AL, BL
    JNE SC_NO
    INC SI
    INC DI
    JMP SC_LOOP
SC_CHK_END:
    CMP BL, 0DH
    JE  SC_OK
SC_NO:
    MOV AL, 1
    RET
SC_OK:
    MOV AL, 0
    RET
STRCMP_CR ENDP

; ================================================================
; CHECK 4-DIGIT PASSWORD - validates that a CR-terminated string
; is exactly 4 characters long and every character is a digit.
; IN:  SI = pointer to a CR-terminated string
; OUT: CF = 1 if invalid
; ================================================================
CHECK_4DIGIT_PASSWORD PROC
    PUSH CX
    MOV CX, 0
CFD_LOOP:
    MOV AL, [SI]
    CMP AL, 0DH
    JE  CFD_CHECK_LEN
    CMP AL, '0'
    JB  CFD_BAD
    CMP AL, '9'
    JA  CFD_BAD
    INC SI
    INC CX
    CMP CX, 4
    JA  CFD_BAD
    JMP CFD_LOOP
CFD_CHECK_LEN:
    CMP CX, 4
    JNE CFD_BAD
    POP CX
    CLC
    RET
CFD_BAD:
    POP CX
    STC
    RET
CHECK_4DIGIT_PASSWORD ENDP

; ================================================================
; COPY CR TO NUL - copies a CR-terminated source string into a
; NUL-terminated destination (used to save name/password into the
; fixed-size customer records).
; IN:  SI = source (CR-terminated), DI = destination
; ================================================================
COPY_CR_TO_NUL PROC
    PUSH AX
CCTN_LOOP:
    MOV AL, [SI]
    CMP AL, 0DH
    JE  CCTN_DONE
    MOV [DI], AL
    INC SI
    INC DI
    JMP CCTN_LOOP
CCTN_DONE:
    MOV BYTE PTR [DI], 0
    POP AX
    RET
COPY_CR_TO_NUL ENDP

; ================================================================
; PRINT STR CR - prints a CR-terminated string (does not print the
; CR itself). Used to redraw things like the typed Name after a
; screen clear.
; IN: SI = pointer to a CR-terminated string
; ================================================================
PRINT_STR_CR PROC
    PUSH AX
    PUSH DX
PSC_LOOP:
    MOV AL, [SI]
    CMP AL, 0DH
    JE  PSC_DONE
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    INC SI
    JMP PSC_LOOP
PSC_DONE:
    POP DX
    POP AX
    RET
PRINT_STR_CR ENDP

; ================================================================
; FIND CUSTOMER - checks IN_USER/IN_PASS against the registered
; customer list. OUT: CF = 1 if no match found.
; ================================================================
FIND_CUSTOMER PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV CL, CUST_COUNT
    MOV CH, 0
    CMP CX, 0
    JE  FC_NOTFOUND
    
    MOV BX, 0                  ; BX = which customer we're checking (0-based)
FC_LOOP:
    MOV AX, BX
    MOV DX, CUST_NAME_LEN
    MUL DX                       ; work out this customer's offset into CUST_NAMES
    MOV DI, OFFSET CUST_NAMES
    ADD DI, AX
    LEA SI, IN_USER + 2
    CALL COMPARE                 ; COMPARE preserves BX, so it's safe to keep looping on it
    CMP AL, 0
    JNE FC_NEXT
    
    MOV AX, BX
    MOV DX, CUST_PASS_LEN
    MUL DX                       ; same idea, but for that customer's password slot
    MOV DI, OFFSET CUST_PASS
    ADD DI, AX
    LEA SI, IN_PASS + 2
    CALL COMPARE
    CMP AL, 0
    JNE FC_NEXT
    
    JMP FC_FOUND
    
FC_NEXT:
    INC BX
    CMP BX, CX
    JB  FC_LOOP
    
FC_NOTFOUND:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    STC
    RET
    
FC_FOUND:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    CLC
    RET
FIND_CUSTOMER ENDP

; ================================================================
; FIND CUSTOMER BY NAME - checks whether IN_NAME is already taken.
; OUT: CF = 1 if the name is free (not found), CF = 0 if taken.
; ================================================================
FIND_CUSTOMER_BY_NAME PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    MOV CL, CUST_COUNT
    MOV CH, 0
    CMP CX, 0
    JE  FCN_FREE
    
    MOV BX, 0                  ; BX = which existing customer slot we're comparing against
FCN_LOOP:
    MOV AX, BX
    MOV DX, CUST_NAME_LEN
    MUL DX
    MOV DI, OFFSET CUST_NAMES
    ADD DI, AX
    LEA SI, IN_NAME + 2
    CALL COMPARE
    CMP AL, 0
    JE  FCN_TAKEN
    
    INC BX
    CMP BX, CX
    JB  FCN_LOOP
    
FCN_FREE:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    STC
    RET
    
FCN_TAKEN:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    CLC
    RET
FIND_CUSTOMER_BY_NAME ENDP

; ================================================================
; AUTH MENU - Login / Register / Exit, shown before any main menu
; ================================================================
AUTH_MENU PROC
AUTH_LOOP:
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, AUTH_MSG
    INT 21H
    CALL GET_OPTION
    
    CMP AL, '1'
    JE  AUTH_DO_LOGIN
    CMP AL, '2'
    JE  AUTH_DO_REGISTER
    CMP AL, '3'
    JE  AUTH_DO_EXIT
    JMP AUTH_LOOP

AUTH_DO_LOGIN:
    CALL LOGIN                ; CF=1 if the user backed out (blank + chose not to continue)
    JC  AUTH_LOOP              ; back to the Auth Menu so they can Register instead
    RET                         ; CF=0 -> login succeeded, go on to the main menu
                                ; (a lockout terminates the program directly, doesn't reach here)

AUTH_DO_REGISTER:
    CALL REGISTER
    JMP AUTH_LOOP              ; back to the auth menu so they can now login

AUTH_DO_EXIT:
    MOV AH, 4CH
    INT 21H
AUTH_MENU ENDP

; ================================================================
; REGISTER - creates a new customer account (Name + 4-digit
; Password + Confirm Password), kept in memory for this session.
; ================================================================
REGISTER PROC
REG_START:
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, REG_HEADER
    INT 21H
    
    CMP CUST_COUNT, MAX_CUSTOMERS
    JB  REG_CONTINUE
    LEA DX, E_REG_FULL
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

REG_CONTINUE:
    MOV AH, 09H
    LEA DX, PROMPT_NAME
    INT 21H
    MOV AH, 0AH
    LEA DX, IN_NAME
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV BL, IN_NAME + 2
    CMP BL, 0DH
    JNE REG_NAME_OK
    JMP REG_CHECK_CONTINUE     ; blank Enter -> offer a way out instead of exiting straight away

REG_NAME_OK:
    LEA SI, IN_NAME + 2          ; can't reuse the admin username as a customer name
    LEA DI, USERNAME
    CALL COMPARE
    CMP AL, 0
    JNE REG_CHECK_DUP
    LEA DX, E_REG_TAKEN
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

REG_CHECK_DUP:
    CALL FIND_CUSTOMER_BY_NAME   ; also can't reuse a name already taken by another customer
    JC  REG_NAME_FREE
    LEA DX, E_REG_TAKEN
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

REG_NAME_FREE:
    MOV AH, 09H
    LEA DX, PROMPT_NEWPASS
    INT 21H
    MOV DI, OFFSET IN_PASS + 2
    MOV CX, 19
    CALL GET_MASKED_INPUT
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, IN_PASS + 2
    CALL CHECK_4DIGIT_PASSWORD   ; password must be exactly 4 digits
    JNC REG_PASS_OK
    JMP REG_PASS_INVALID

REG_PASS_OK:
    MOV AH, 09H
    LEA DX, PROMPT_CONFIRMPASS
    INT 21H
    MOV DI, OFFSET IN_PASS2 + 2
    MOV CX, 19
    CALL GET_MASKED_INPUT
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, IN_PASS2 + 2
    CALL CHECK_4DIGIT_PASSWORD
    JNC REG_CONFIRM_OK
    JMP REG_PASS_INVALID

REG_CONFIRM_OK:
    LEA SI, IN_PASS + 2          ; the two passwords typed have to match
    LEA DI, IN_PASS2 + 2
    CALL STRCMP_CR
    CMP AL, 0
    JNE REG_DO_MISMATCH
    JMP REG_MATCH
REG_DO_MISMATCH:
    JMP REG_MISMATCH

REG_PASS_INVALID:
    LEA DX, E_REG_PASS
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    JMP REG_ASK_RETRY

REG_MISMATCH:
    LEA DX, E_REG_MISMATCH
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR

REG_ASK_RETRY:
    MOV AH, 09H
    LEA DX, P_REG_RETRY
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JNE REG_GIVE_UP
    
    CALL CLEAR_SCREEN            ; keep the name they already picked, just redo the passwords
    MOV AH, 09H
    LEA DX, REG_HEADER
    INT 21H
    MOV AH, 09H
    LEA DX, PROMPT_NAME
    INT 21H
    LEA SI, IN_NAME + 2
    CALL PRINT_STR_CR
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    JMP REG_NAME_FREE          ; screen is now short again, but Name and the header are still shown
REG_GIVE_UP:
    RET

REG_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  REG_GO_START
    RET                          ; user doesn't want to continue -> bail out to Auth Menu
REG_GO_START:
    JMP REG_START

REG_MATCH:
    MOV AL, CUST_COUNT           ; save the new name into slot CUST_COUNT of CUST_NAMES
    MOV AH, 0
    MOV DX, CUST_NAME_LEN
    MUL DX
    MOV DI, OFFSET CUST_NAMES
    ADD DI, AX
    LEA SI, IN_NAME + 2
    CALL COPY_CR_TO_NUL
    
    MOV AL, CUST_COUNT           ; same idea for the password, into the matching slot of CUST_PASS
    MOV AH, 0
    MOV DX, CUST_PASS_LEN
    MUL DX
    MOV DI, OFFSET CUST_PASS
    ADD DI, AX
    LEA SI, IN_PASS + 2
    CALL COPY_CR_TO_NUL
    
    INC CUST_COUNT
    
    LEA DX, MSG_REG_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET
REGISTER ENDP

; ================================================================
; DISPLAY MENU
; ================================================================
DISPLAY_MENU PROC
    CMP CURRENT_ROLE, 1
    JE  DM_CUSTOMER
    
    MOV AH, 09H
    LEA DX, MENU_MSG
    INT 21H
    RET
    
DM_CUSTOMER:
    MOV AH, 09H
    LEA DX, CUST_MENU_MSG
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
    SUB CL, 30H            ; ASCII digit -> actual number (0-9)
    MOV CH, 0
    MUL BX                   ; shift what we have so far left one decimal place...
    ADD AX, CX                ; ...then add the new digit
    INC SI
    JMP SN_LOOP
SN_DONE:
    RET
STR_TO_NUM ENDP

; ================================================================
; VALIDATE_DIGITS
; ================================================================
VALIDATE_DIGITS PROC
    PUSH AX
    PUSH SI
    
    MOV AL, [SI]
    CMP AL, 0DH
    JE  VD_BAD          ; empty input (blank Enter, no digits typed) is NOT valid
    
VD_LOOP:
    MOV AL, [SI]
    CMP AL, 0DH
    JE  VD_OK
    CMP AL, '0'
    JB  VD_BAD
    CMP AL, '9'
    JA  VD_BAD
    INC SI
    JMP VD_LOOP
VD_OK:
    POP SI
    POP AX
    CLC
    RET
VD_BAD:
    POP SI
    POP AX
    STC
    RET
VALIDATE_DIGITS ENDP

; ================================================================
; PARSE MONEY - parses a string like "12.34", "0.2", "5", ".23"
; into a 32-bit cents value, so ringgit and cents can be typed
; together in one field (e.g. "0.23") instead of two separate ones.
; IN:  SI = pointer to a CR-terminated input buffer
; OUT: DX:AX = amount in cents (32-bit)
;      CF = 1 if the string isn't a valid money amount
; ================================================================
PARSE_MONEY PROC
    PUSH BX
    PUSH CX
    PUSH DI
    
    MOV AL, [SI]
    CMP AL, 0DH
    JNE PM_NOT_EMPTY
    JMP PM_BAD                 ; empty input
PM_NOT_EMPTY:
    CMP AL, '.'
    JNE PM_HAS_RINGGIT
    JMP PM_RINGGIT_DONE        ; string starts with '.' -> ringgit part is 0 (e.g. ".23")
PM_HAS_RINGGIT:
    
    CALL STR_TO_NUM             ; AX = ringgit part; SI advances past the digits it consumed
    CMP AX, 999
    JBE PM_RINGGIT_SIZE_OK
    JMP PM_BAD                   ; ringgit part too large
PM_RINGGIT_SIZE_OK:
    JMP PM_HAVE_RINGGIT
    
PM_RINGGIT_DONE:
    MOV AX, 0
PM_HAVE_RINGGIT:
    MOV BX, AX                   ; BX = ringgit part
    
    MOV DI, 0                     ; DI = cents value, defaults to 0
    
    MOV AL, [SI]
    CMP AL, 0DH
    JNE PM_CHECK_DOT
    JMP PM_COMBINE                 ; no decimal point at all -> cents stays 0 (e.g. "5")
PM_CHECK_DOT:
    CMP AL, '.'
    JE  PM_GOT_DOT
    JMP PM_BAD                      ; anything else here is a stray invalid character
PM_GOT_DOT:
    INC SI
    
    MOV AL, [SI]
    CMP AL, 0DH
    JNE PM_CHECK_D1
    JMP PM_COMBINE                    ; e.g. "5." -> cents 0
PM_CHECK_D1:
    CMP AL, '0'
    JAE PM_D1_MIN_OK
    JMP PM_BAD
PM_D1_MIN_OK:
    CMP AL, '9'
    JBE PM_D1_OK
    JMP PM_BAD
PM_D1_OK:
    SUB AL, '0'
    MOV AH, 0
    MOV DI, AX                         ; DI = first cent digit (0-9)
    INC SI
    
    MOV AL, [SI]
    CMP AL, 0DH
    JNE PM_CHECK_D2
    JMP PM_ONE_DIGIT                    ; only one digit typed after the dot -> tenths
PM_CHECK_D2:
    CMP AL, '0'
    JAE PM_D2_MIN_OK
    JMP PM_BAD
PM_D2_MIN_OK:
    CMP AL, '9'
    JBE PM_D2_OK
    JMP PM_BAD
PM_D2_OK:
    SUB AL, '0'
    MOV AH, 0
    MOV CX, AX                           ; CX = second cent digit
    MOV AX, DI
    MOV DX, 10
    MUL DX
    ADD AX, CX
    MOV DI, AX                            ; DI = combined two-digit cents (0-99)
    INC SI
    
    MOV AL, [SI]
    CMP AL, 0DH
    JE  PM_COMBINE
    JMP PM_BAD                             ; more than 2 decimal digits - invalid
    
PM_ONE_DIGIT:
    MOV AX, DI
    MOV DX, 10
    MUL DX
    MOV DI, AX                              ; single typed digit means tenths -> *10
    
PM_COMBINE:
    MOV AX, BX
    MOV CX, 100
    MUL CX                                   ; DX:AX = ringgit * 100 (32-bit)
    ADD AX, DI
    ADC DX, 0                                 ; add the cents on top
    
    POP DI
    POP CX
    POP BX
    CLC
    RET
    
PM_BAD:
    POP DI
    POP CX
    POP BX
    STC
    RET
PARSE_MONEY ENDP

; ================================================================
; PRINT NUMBER
; ================================================================
PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0                 ; CX = how many digits we end up pushing
    MOV BX, 10
PN_LOOP:
    MOV DX, 0
    DIV BX                      ; AX/10 -> AX=quotient, DX=remainder (the next digit, right to left)
    PUSH DX                       ; stack the digits so we can pop them back out in the right order
    INC CX
    CMP AX, 0
    JNE PN_LOOP
PN_DISP:
    POP DX
    ADD DL, 30H                    ; number -> ASCII digit
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
; e.g. DX=0,AX=2350 prints "23.50" | DX=1,AX=34463 prints "999.99"
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
; PRINT MONEY ALIGNED - same as PRINT_MONEY, but pads the ringgit
; part with leading spaces so it's always 3 characters wide
; (e.g. "  5.00", " 23.50", "999.99"). Used on the receipt's
; Subtotal/Discount/Tax/Total/Cash/Change lines so the numbers all
; line up on the right, decimal points included, no matter how many
; digits each one has. DX:AX = value in cents, same as PRINT_MONEY.
; ================================================================
PRINT_MONEY_ALIGNED PROC
    PUSH BX
    PUSH AX
    PUSH DX                ; stash the real DX:AX (the full cents value) - we're about to trash it
    
    MOV BX, 100
    DIV BX                  ; AX = ringgit part, just to measure how many spaces we need
    
    CMP AX, 100
    JAE PMA_DONE_PAD
    MOV AH, 02H
    MOV DL, ' '
    INT 21H
    CMP AX, 10
    JAE PMA_DONE_PAD
    MOV DL, ' '
    INT 21H
PMA_DONE_PAD:
    
    POP DX                  ; get the real DX:AX back...
    POP AX
    CALL PRINT_MONEY          ; ...and print it normally, right after the spaces we just added
    
    POP BX
    RET
PRINT_MONEY_ALIGNED ENDP

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
; Function 1: *
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
; PRINT NUMBER TWO DIGITS
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
; SHOW TABLE - prints the product list (stock + price for each of
; the 8 products). Same 8 lines of code repeated per product since
; there's no easy way to loop over the P1..P8 name labels here.
; ================================================================
SHOW_TABLE PROC
    MOV AH, 09H
    LEA DX, TABLE_HEADER
    INT 21H
    
    ; Product 1 row
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

    ; Product 2 row
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

    ; Product 3 row
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

    ; Product 4 row
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

    ; Product 5 row
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

    ; Product 6 row
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

    ; Product 7 row
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

    ; Product 8 row
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
    
    ; blank Enter -> treated as "done" (signalled separately below)
    MOV BL, BUF_ID + 2
    CMP BL, 0DH
    JE  GID_EMPTY
    
    LEA SI, BUF_ID + 2
    CALL VALIDATE_DIGITS
    JC  GID_ERR
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JB  GID_ERR
    CMP AX, 8
    JA  GID_ERR
    
    DEC AX                    ; product IDs are shown as 1-8, but arrays are 0-based
    MOV IDX, AX
    CLC
    RET

GID_EMPTY:
    ; blank Enter pressed - signal "done" distinctly from an invalid ID
    MOV AX, 0
    STC
    RET

GID_ERR:
    LEA DX, E_ID
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    MOV AX, 1
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
    CALL VALIDATE_DIGITS
    JC  GQT_ERR
    
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
    LEA DX, E_QTY
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    STC
    RET
GET_QTY ENDP

; ================================================================
; OUR PRODUCT MENU
; ================================================================
OUR_PRODUCT_MENU PROC
    ; NOTE: the cart is intentionally NOT reset here - it should
    ; keep whatever's in it across visits to this menu, and only
    ; get cleared by an explicit Cancel in View Cart, or once an
    ; order is actually paid for.
OPM_LOOP:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    MOV AH, 09H
    LEA DX, OPM_MENU
    INT 21H
    CALL GET_OPTION
    
    CMP AL, '1'
    JE  OPM_BUY
    CMP AL, '2'
    JE  OPM_DELETE
    CMP AL, '3'
    JE  OPM_VIEWCART
    CMP AL, '4'
    JE  OPM_BACK
    JMP OPM_LOOP

OPM_BUY:
    CALL BUY_PRODUCT
    JMP OPM_LOOP

OPM_DELETE:
    CALL DELETE_PRODUCT
    JMP OPM_LOOP

OPM_VIEWCART:
    CALL VIEW_CART
    CMP AL, 1                ; AL=1 means the order was paid & completed - go back to Main Menu
    JE  OPM_BACK
    JMP OPM_LOOP              ; AL=0 means stay in the Our Product menu (cart kept or cleared)

OPM_BACK:
    RET
OUR_PRODUCT_MENU ENDP

; ================================================================
; BUY PRODUCT
; ================================================================
BUY_PRODUCT PROC
BP_LOOP:
    CALL CLEAR_SCREEN
    CALL SHOW_TABLE
    
    CALL GET_ID
    JNC BP_GOT_ID
    CMP AX, 0
    JNE BP_ID_INVALID
    JMP BP_DONE               ; blank Enter -> finished buying, back to Our Product menu
BP_ID_INVALID:
    JMP BP_LOOP                ; invalid ID (error already shown) -> ask again
    
BP_GOT_ID:
    CALL GET_QTY
    JC  BP_LOOP
    
    MOV BX, IDX
    ADD BX, BX                  ; *2 because P_STOCKS/CART_QTY etc. are word arrays
    MOV AX, P_STOCKS[BX]
    SUB AX, CART_QTY[BX]        ; AX = stock still available (actual stock minus what's already in the cart)
    CMP AX, QTY
    JAE BP_STOCK_OK
    
    LEA DX, E_STOCK
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP BP_LOOP

BP_STOCK_OK:
    MOV BX, IDX
    ADD BX, BX
    
    MOV AX, CART_QTY[BX]
    ADD AX, QTY
    MOV CART_QTY[BX], AX        ; only reserve it in the cart - stock/sold totals are
                                  ; only updated once the order is actually paid for
    
    MOV AX, P_PRICES_LO[BX]
    MOV DX, P_PRICES_HI[BX]
    MOV PRICE_LO, AX
    MOV PRICE_HI, DX
    MOV BX, QTY
    CALL MUL32x16              ; DX:AX = price(32-bit) * QTY - this line's total, in cents
    ; Function 2: +
    ADD TOTAL_LO, AX
    ADC TOTAL_HI, DX            ; accumulate into the running 32-bit TOTAL, carrying if needed
    
    MOV AH, 09H
    LEA DX, P_AGAIN
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JNE BP_YN_DONE
    JMP BP_LOOP
BP_YN_DONE:
    
BP_DONE:
    RET
BUY_PRODUCT ENDP

; ================================================================
; DELETE PRODUCT
; ================================================================
DELETE_PRODUCT PROC
DP_LOOP:
    CALL CLEAR_SCREEN
    CALL PRINT_CART
    
    CMP CART_EMPTY_FLAG, 1
    JNE DP_CART_HAS_ITEMS
    CALL WAIT_KEY               ; nothing to delete - don't even ask for an ID
    JMP DP_DONE
DP_CART_HAS_ITEMS:
    
    CALL GET_ID
    JNC DP_GOT_ID
    CMP AX, 0
    JNE DP_ID_INVALID
    JMP DP_DONE                ; blank Enter -> finished deleting, back to Our Product menu
DP_ID_INVALID:
    JMP DP_LOOP                 ; invalid ID (error already shown) -> ask again

DP_GOT_ID:
    MOV BX, IDX
    ADD BX, BX
    MOV AX, CART_QTY[BX]
    CMP AX, 0
    JNE DP_HAS_ITEM
    
    LEA DX, E_NOT_IN_CART
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP DP_LOOP

DP_HAS_ITEM:
    MOV AH, 09H
    LEA DX, P_DEL_QTY
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_QTY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    LEA SI, BUF_QTY + 2
    CALL VALIDATE_DIGITS
    JC  DP_ERR_QTY
    
    LEA SI, BUF_QTY + 2
    CALL STR_TO_NUM
    
    CMP AX, 1
    JB  DP_ERR_QTY
    
    MOV BX, IDX
    ADD BX, BX
    CMP AX, CART_QTY[BX]
    JA  DP_ERR_QTY              ; can't delete more than what's currently in the cart
    
    MOV QTY, AX                  ; save it - the confirm prompt below will overwrite AX
    MOV AH, 09H
    LEA DX, CONFIRM_DELETE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  DP_DO_DELETE
    
    MOV AH, 09H
    LEA DX, MSG_CANCELLED
    INT 21H
    CALL WAIT_KEY
    JMP DP_LOOP
    
DP_ERR_QTY:
    LEA DX, E_DEL_QTY
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP DP_LOOP

DP_DO_DELETE:
    MOV BX, IDX
    ADD BX, BX
    
    MOV AX, QTY
    SUB CART_QTY[BX], AX          ; remove from the cart - stock/sold were never touched
                                   ; by Buy Product, so there's nothing to give back here
    
    MOV AX, P_PRICES_LO[BX]
    MOV DX, P_PRICES_HI[BX]
    MOV PRICE_LO, AX
    MOV PRICE_HI, DX
    MOV BX, QTY
    CALL MUL32x16                 ; DX:AX = price * qty removed
    SUB TOTAL_LO, AX
    SBB TOTAL_HI, DX               ; take it back out of the running total
    
    LEA DX, MSG_DEL_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    
    MOV AH, 09H
    LEA DX, P_DEL_AGAIN
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JNE DP_YN_DONE
    JMP DP_LOOP
DP_YN_DONE:
    
DP_DONE:
    RET
DELETE_PRODUCT ENDP

; ================================================================
; PRINT CART - shows current cart contents & running total.
; Used by both Delete Product (so you can see what to delete)
; and View Cart.
; ================================================================
PRINT_CART PROC
    MOV AH, 09H
    LEA DX, CART_HEAD
    INT 21H
    
    MOV CART_EMPTY_FLAG, 1
    MOV SI, 0
    MOV CX, 8
PC_LOOP:
    MOV AX, CART_QTY[SI]
    CMP AX, 0
    JE  PC_SKIP
    
    MOV CART_EMPTY_FLAG, 0
    
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
    
PC_SKIP:
    ADD SI, 2
    DEC CX
    JZ  PC_CHECK_EMPTY
    JMP PC_LOOP
    
PC_CHECK_EMPTY:
    CMP CART_EMPTY_FLAG, 1
    JNE PC_SHOW_TOTAL
    MOV AH, 09H
    LEA DX, MSG_CART_EMPTY
    INT 21H
    JMP PC_DONE

PC_SHOW_TOTAL:
    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    MOV AH, 09H
    LEA DX, CART_TOTAL_LABEL
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

PC_DONE:
    RET
PRINT_CART ENDP

; ================================================================
; VIEW CART
; Shows the cart, then asks to confirm the order. Returns:
;   AL = 1  -> order was paid and printed (caller should exit to Main Menu)
;   AL = 0  -> stay in the Our Product menu (cart kept, or cleared by cancel)
; ================================================================
VIEW_CART PROC
    CALL CLEAR_SCREEN
    CALL PRINT_CART
    
    CMP CART_EMPTY_FLAG, 1
    JNE VC_ASK_CONFIRM
    
    CALL WAIT_KEY
    MOV AL, 0
    RET

VC_ASK_CONFIRM:
    LEA DX, CONFIRM_ORDER
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    CMP AL, 'Y'
    JNE VC_NOT_CONFIRMED
    JMP VC_DO_CONFIRM
VC_NOT_CONFIRMED:
    
    LEA DX, CONFIRM_CANCEL
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    CMP AL, 'Y'
    JE  VC_DO_CANCEL
    
    ; "no, don't cancel" -> keep the cart, go back to the Our Product menu
    MOV AL, 0
    RET

VC_DO_CANCEL:
    MOV SI, 0
    MOV CX, 8
VC_CANCEL_LOOP:
    MOV CART_QTY[SI], 0          ; just clear the cart - stock/sold were never touched
    ADD SI, 2
    DEC CX
    JZ  VC_CANCEL_DONE
    JMP VC_CANCEL_LOOP
VC_CANCEL_DONE:
    MOV TOTAL_LO, 0
    MOV TOTAL_HI, 0
    
    LEA DX, MSG_ORDER_CANCELLED
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL WAIT_KEY
    MOV AL, 0
    RET

VC_DO_CONFIRM:
    CALL PROCESS_PAYMENT
    JC  VC_PAY_CANCELLED        ; user backed out at the payment prompt - keep the cart
    
    ; order is paid for - clear the cart so it's ready for a new order
    MOV SI, 0
    MOV CX, 8
VC_CLEAR_LOOP:
    MOV CART_QTY[SI], 0
    ADD SI, 2
    DEC CX
    JZ  VC_CLEAR_DONE
    JMP VC_CLEAR_LOOP
VC_CLEAR_DONE:
    MOV TOTAL_LO, 0
    MOV TOTAL_HI, 0
    
    MOV AL, 1
    RET
    
VC_PAY_CANCELLED:
    MOV AL, 0
    RET
VIEW_CART ENDP

; ================================================================
; PROCESS PAYMENT - applies discount/tax, takes payment, prints
; the receipt. Assumes TOTAL_LO/TOTAL_HI holds the cart's subtotal
; and CART_QTY holds this order's items.
; ================================================================
PROCESS_PAYMENT PROC
    CALL CLEAR_SCREEN
    
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    MOV SUBTOTAL_LO, AX
    MOV SUBTOTAL_HI, DX      ; keep the pre-tax, pre-discount amount for the receipt
    
    MOV DISCOUNT_LO, 0
    MOV DISCOUNT_HI, 0
    
    MOV CX, 0
    MOV BX, 5000
    CALL GE32                ; is SUBTOTAL (DX:AX) >= 5000 cents (RM50.00)?
    CMP AL, 1
    JE  PP_APPLY_DISCOUNT
    JMP PP_NO_DISCOUNT
    
PP_APPLY_DISCOUNT:
    MOV AX, SUBTOTAL_LO
    MOV DX, SUBTOTAL_HI
    MOV BX, 10
    CALL MUL32x16            ; DX:AX = subtotal * 10
    MOV BX, 100
    DIV BX                    ; AX = the discount amount (10% of subtotal)
    MOV DISCOUNT_LO, AX
    MOV DISCOUNT_HI, 0
    
    LEA DX, MSG_DISCOUNT_YES
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    
PP_NO_DISCOUNT:
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
    ; Function 2: +
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
    
PP_PAY:
    MOV AH, 09H
    LEA DX, P_PAY
    INT 21H
    MOV AH, 0AH
    LEA DX, BUF_PAY
    INT 21H
    MOV AH, 02H
    MOV DL, 0AH
    INT 21H
    
    MOV AL, BUF_PAY + 2
    CMP AL, 0DH
    JNE PP_PAY_NOT_BLANK
    JMP PP_ASK_CANCEL          ; blank Enter -> offer to cancel instead of being stuck here forever
PP_PAY_NOT_BLANK:
    
    LEA SI, BUF_PAY + 2
    CALL PARSE_MONEY
    JC  PP_PAY_FORMAT_ERR
    
    MOV CASH_LO, AX
    MOV CASH_HI, DX           ; keep it for the receipt's "Cash: RM __" line
    
    MOV BX, TOTAL_LO
    MOV CX, TOTAL_HI
    CALL GE32                  ; is CASH (DX:AX) >= TOTAL (CX:BX)?
    CMP AL, 1
    JNE PP_NOT_ENOUGH
    JMP PP_PAY_OK
PP_NOT_ENOUGH:
    JMP PP_PAY_ERR
    
PP_ASK_CANCEL:
    LEA DX, CONFIRM_CANCEL
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    CMP AL, 'Y'
    JE  PP_DO_CANCEL
    
    ; "no, don't cancel" -> redisplay the amount due and ask for payment again
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, MSG_TOTAL_DUE
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    JMP PP_PAY
    
PP_DO_CANCEL:
    MOV AX, SUBTOTAL_LO
    MOV DX, SUBTOTAL_HI
    MOV TOTAL_LO, AX
    MOV TOTAL_HI, DX           ; undo the discount/tax math so the cart's total is correct again
    STC                          ; tell VIEW_CART the order was NOT paid for
    RET
    
PP_PAY_FORMAT_ERR:
    LEA DX, E_PAY_FORMAT
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, MSG_TOTAL_DUE
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    JMP PP_PAY

PP_PAY_ERR:
    LEA DX, E_PAY
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    CALL CLEAR_SCREEN
    MOV AH, 09H
    LEA DX, MSG_TOTAL_DUE
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    JMP PP_PAY

PP_PAY_OK:
    MOV AX, CASH_LO
    MOV DX, CASH_HI
    SUB AX, TOTAL_LO
    SBB DX, TOTAL_HI
    MOV CHANGE_LO, AX
    MOV CHANGE_HI, DX          ; CHANGE = cash given - amount due
    
    MOV AX, TOTAL_REVENUE_LO
    MOV DX, TOTAL_REVENUE_HI
    ; Function 2: +
    ADD AX, TOTAL_LO
    ADC DX, TOTAL_HI
    MOV TOTAL_REVENUE_LO, AX
    MOV TOTAL_REVENUE_HI, DX     ; add this sale onto the running total for Report
    
    INC TOTAL_CUSTOMERS
    
    ; the order is now actually paid for - THIS is the moment stock
    ; and the "sold" totals (used by Report) get committed for real
    MOV SI, 0
    MOV CX, 8
PP_COMMIT_LOOP:
    MOV AX, CART_QTY[SI]
    CMP AX, 0
    JE  PP_COMMIT_SKIP
    SUB P_STOCKS[SI], AX
    ; Function 2: +
    ADD P_SOLD[SI], AX
PP_COMMIT_SKIP:
    ADD SI, 2
    DEC CX
    JZ  PP_COMMIT_DONE
    JMP PP_COMMIT_LOOP
PP_COMMIT_DONE:
    
    CALL PRINT_RECEIPT
    CLC                          ; tell VIEW_CART the order WAS paid for
    RET
PROCESS_PAYMENT ENDP

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
    
    ; Product 1 row
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
    ; line total = price * qty sold
    MOV AX, P_PRICES_LO[0]
    MOV DX, P_PRICES_HI[0]
    MOV BX, P_SOLD[0]
    CALL MUL32x16
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_1:

    ; Product 2 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_2:

    ; Product 3 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_3:

    ; Product 4 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_4:

    ; Product 5 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_5:

    ; Product 6 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_6:

    ; Product 7 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_7:

    ; Product 8 row
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_8:
    
    MOV AH, 09H
    LEA DX, TABLE_LINE          ; close off the ALL ITEMS table with a bottom border
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG_CLEAR            ; pause here - with a full 8-product list this screen is
    INT 21H                       ; already close to full, don't let it scroll away unread
    CALL WAIT_KEY
    CALL CLEAR_SCREEN
    
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
    CALL PRINT_MONEY_ALIGNED
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
    CALL PRINT_MONEY_ALIGNED
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
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
PR_SKIP_DISCOUNT:
    
    MOV AH, 09H
    LEA DX, R_TAX
    INT 21H
    MOV AX, TAX_LO
    MOV DX, TAX_HI
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_TOTAL
    INT 21H
    MOV AX, TOTAL_LO
    MOV DX, TOTAL_HI
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_CASH
    INT 21H
    MOV AX, CASH_LO
    MOV DX, CASH_HI
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_CHANGE
    INT 21H
    MOV AX, CHANGE_LO
    MOV DX, CHANGE_HI
    CALL PRINT_MONEY_ALIGNED
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, TABLE_LINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, R_FOOT
    INT 21H
    
    LEA DX, MSG_TRANS_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    
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
; UPDATE STOCK - restocking: pick a product by ID, then add a
; quantity (1-999) to what it currently has, capped at 999 total.
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
    CALL VALIDATE_DIGITS
    JNC US_ID_DIGITS_OK
    JMP US_ERR_ID
US_ID_DIGITS_OK:
    
    LEA SI, BUF_ID + 2
    CALL STR_TO_NUM
    
    CMP AX, 1                 ; ID must be within 1..P_COUNT (currently always 8 products)
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
    CALL VALIDATE_DIGITS
    JNC US_QTY_DIGITS_OK
    JMP US_ERR_QTY
US_QTY_DIGITS_OK:
    
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
    
    MOV BX, IDX
    ADD BX, BX
    MOV CX, P_STOCKS[BX]
    ADD CX, AX               ; CX = stock after adding the requested quantity
    CMP CX, 999
    JBE US_MAXSTOCK_OK
    JMP US_ERR_MAXSTOCK      ; would exceed the 999 stock cap - reject
US_MAXSTOCK_OK:
    
    MOV QTY, AX             ; save the validated quantity, the confirm prompt below will overwrite AX
    
    MOV AH, 09H
    LEA DX, CONFIRM_UPDATE
    INT 21H
    CALL GET_YN
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
    
    LEA DX, MSG_UPDATE_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

US_ERR_ID:
    LEA DX, E_ID
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP US_START

US_ERR_QTY:
    LEA DX, E_QTY
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP US_START

US_ERR_MAXSTOCK:
    LEA DX, E_MAXSTOCK
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP US_START

US_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  US_GO_START
    RET
US_GO_START:
    JMP US_START
UPDATE_STOCK ENDP

; ================================================================
; REDUCE STOCK - basically the mirror of UPDATE_STOCK: pick a
; product, then take away a quantity instead of adding it (e.g. for
; damaged/expired stock). Can't reduce below 0.
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
    CALL VALIDATE_DIGITS
    JNC RS_ID_DIGITS_OK
    JMP RS_ERR_ID
RS_ID_DIGITS_OK:
    
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
    CALL VALIDATE_DIGITS
    JNC RS_QTY_DIGITS_OK
    JMP RS_ERR_QTY
RS_QTY_DIGITS_OK:
    
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
    JB  RS_NO_STOCK          ; can't reduce more than what's actually in stock
    
    MOV QTY, AX             ; save the validated quantity, the confirm prompt below will overwrite AX
    
    MOV AH, 09H
    LEA DX, CONFIRM_REDUCE
    INT 21H
    CALL GET_YN
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
    LEA DX, MSG_REDUCE_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

RS_NO_STOCK:
    LEA DX, E_REDUCE
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP RS_START

RS_ERR_ID:
    LEA DX, E_ID
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP RS_START

RS_ERR_QTY:
    LEA DX, E_QTY
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP RS_START

RS_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  RS_GO_START
    RET
RS_GO_START:
    JMP RS_START
REDUCE_STOCK ENDP

; ================================================================
; EDIT PRICE - pick a product, show its current price, then let
; the user type a new one (RM0.01 to RM999.99). Blank Enter cancels.
; ================================================================
EDIT_PRICE_PROC PROC
EP_START:
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
    JNE EP_ID_NOT_BLANK
    JMP EP_CHECK_CONTINUE
EP_ID_NOT_BLANK:
    
    LEA SI, BUF_ID + 2
    CALL VALIDATE_DIGITS
    JNC EP_ID_DIGITS_OK
    JMP EP_ERR
EP_ID_DIGITS_OK:
    
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
    ADD AX, AX             ; *2, same word-array indexing as everywhere else
    MOV SI, AX
    MOV DX, P_NAMES[SI]
    MOV AH, 09H
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG_RM
    INT 21H
    MOV AX, IDX              ; show the current price before asking for the new one
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
    JMP EP_SKIP
EP_NOT_BLANK:
    
    LEA SI, BUF_PAY + 2
    CALL PARSE_MONEY
    JNC EP_PARSED_OK
    JMP EP_PRICE_ERR
EP_PARSED_OK:
    
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
    MOV PRICE_LO, AX
    MOV PRICE_HI, DX  ; save the validated new price - the confirm prompt below overwrites AX/DX
    
    MOV AH, 09H
    LEA DX, CONFIRM_PRICE
    INT 21H
    CALL GET_YN
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
    LEA DX, E_EDIT_PRICE
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP EP_START
    
EP_DONE:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    LEA DX, MSG_EDIT_OK
    MOV BL, COLOR_SUCCESS
    CALL PRINT_COLOR
    CALL WAIT_KEY
    RET

EP_SKIP:
    MOV AH, 09H
    LEA DX, MSG_CANCELLED
    INT 21H
    CALL WAIT_KEY
    RET

EP_ERR:
    LEA DX, E_ID
    MOV BL, COLOR_ERROR
    CALL PRINT_COLOR
    CALL WAIT_KEY
    JMP EP_START

EP_CHECK_CONTINUE:
    MOV AH, 09H
    LEA DX, MSG_CONTINUE
    INT 21H
    CALL GET_YN
    CMP AL, 'Y'
    JE  EP_GO_START
    RET
EP_GO_START:
    JMP EP_START
EDIT_PRICE_PROC ENDP

; ================================================================
; ================================================================
; REPORT - shows how many of each product have been sold (and their
; price) since the program started, plus a summary at the bottom
; (total items, total revenue, total customers served this session).
; Same repeated 8-times pattern as SHOW_TABLE, just showing P_SOLD
; instead of P_STOCKS. DI is used as a running total of items sold
; across all 8 products, added to as we go.
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
    
    ; Product 1 row
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

    ; Product 2 row
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

    ; Product 3 row
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

    ; Product 4 row
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

    ; Product 5 row
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

    ; Product 6 row
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

    ; Product 7 row
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

    ; Product 8 row
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
    MOV AX, DI               ; DI now holds the sum of P_SOLD across all 8 products
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_REVENUE
    INT 21H
    MOV AX, TOTAL_REVENUE_LO   ; running total of everything actually paid (after discount/tax)
    MOV DX, TOTAL_REVENUE_HI
    CALL PRINT_MONEY
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    
    MOV AH, 09H
    LEA DX, REPORT_CUSTOMERS
    INT 21H
    MOV AX, TOTAL_CUSTOMERS     ; counts completed transactions, not unique people
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
    LEA DX, CONFIRM_MSG
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    RET
CONFIRM_EXIT ENDP

CONFIRM_LOGOUT PROC
    CALL CLEAR_SCREEN
    LEA DX, CONFIRM_LOGOUT_MSG
    MOV BL, COLOR_WARN
    CALL PRINT_COLOR
    CALL GET_YN
    RET
CONFIRM_LOGOUT ENDP

; ================================================================
; END
; ================================================================
END MAIN