; Purpose: Obtains Real-time Clock from Clock of computer and displays on screen.

.model small
.data
    timestring db " : : $"        ; String is initialized to respective message
    stringAM db "AM$"
    stringPM db "PM$"

.code
start:
    mov ax, @data            ; Loading Data
    mov ds, ax               ; Initializing Data Segment

    mov ah, 0h               ; Service # to get time from Clock
    int 1Ah                  ; Software Interrupt to perform function

    mov ax, dx               ; Moving DX (L.O.W.) in AX
    mov dx, cx               ; Moving CX (H.O.W.) in DX

            ; This part to convert ticks to seconds
    mov bx, 91               ; Initializing BX = 91
    div bx                   ; Divide BX, quotient in ax
    mov bx, 5                ; Initializing BX = 5
    mul bx                   ; Multipy BX to AX(dx:ax=ax*bx ), No. of seconds

    mov bx, 60               ; Initializing BX = 60
    div bx                   ; Divide BX, (DX:AX)/BX now minutes(quotent) in AX,
                             ; seconds(reminder) in DX
    mov bx, ax               ; Initializing BX = AX, saving minutes

            ; This part to set Seconds in string
    mov ax, dx               ; Initializing AX = DX, saving seconds
    mov dl, 10               ; Initializing DL = 10
    div dl                   ; Divide DL , AX/DL , quotient in AL, remainder in AH
    add al, 30h              ; Adding 30h to answer to get its ASCII
    mov timestring[6], al    ; Storing AL into string at proper place
    add ah, 30h              ; Adding 30h to answer to get its ASCII
    mov timestring[7], ah    ; Storing AH into string at proper place

            ; This part to set Minutes in string
    mov ax, bx               ; Initializing AX = BX, to get minutes
    mov dl, 60               ; Initializing DL = 60
    div dl                   ; Divide DL, AX/DL , Quotient (Hours) in AL , Remainder
                             ; (Minutes) in AH

    mov bh, 0                ; Initializing BH = 0
    mov bl, al               ; Initializing BL = AL, Hours saved in BL
    mov al, ah               ; Initializing AL = AH, Minutes saved in AL
    mov ah, 0                ; Initializing AH = 0

    mov dl, 10               ; Initializing DL = 10
    div dl                   ; Divide DL. H.O.Minute in AL, L.O.Minute in AH
    add al, 30h              ; Add 30h to AL to get its ASCII
    mov timestring[3], al    ; Moving AL in string at proper place
    add ah, 30h              ; Add 30h to AH to get its ASCII
    mov timestring[4],ah     ; Moving AL in string at proper place

            ; This part to set Hours
    mov ax, bx               ; Initializing AX = BX , get hours
    div dl                   ; Divide BL, BL/BX, 1st hour digit in AL, 2nd hour digit in AH
    add al, 30h              ; Add 30h to AL to get its ASCII
    mov timestring[0], al    ; Moving AL in string at proper place
    add ah, 30h              ; Add 30h to AL to get its ASCII
    mov timestring[1], ah    ; Moving AL in string at proper place
    
    add dl, timestring[0]    ; Adding 1st digit to DL
    add dl, timestring[1]    ; Adding 2nd digit to DL
    
    lea dx, timestring       ; Load Address of Time String
    mov ah, 9h               ; Service # to display String
    int 21h                  ; Software Interrupt to perform Function

    cmp dl, 3                ; Comparison instruction to check if time is Post Meridian
    ja pmlabel               ; Jump if above to pmlabel
    
    lea dx, stringAM         ; Loading Address of stringAM
    mov ah, 9h
    int 21h
    jmp endme                ; Jump to terminate program
    
pmlabel:
    lea dx, stringPM         ; Start of PM label
    mov ah, 9h    
    int 21h 

endme:                       ; Start of end label
    mov ah, 4ch                
    int 21h

end start