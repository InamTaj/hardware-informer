; PURPOSE: Shows status of Floppy, Math processor, DMA, if Caps lock OFF/ON, Number of Disk Drives and Video Mode

.model small
.stack 100h
.data
    capsmsg1 db "Caps Lock is ON. $"            ; string initialized to respective message
    capsmsg2 db "Caps Lock is OFF. $"            
    floppymsg1 db "Floppy = ON $"                
    floppymsg2 db "Floppy = OFF $"                
    mathmsg1 db "Math co-processor = ON $"        
    mathmsg2 db "Math co-processor = OFF $"        
    dmamsg1 db "DMA = ON $"                        
    dmamsg2 db "DMA = ON $"                        
    drivemsg db "Number of Drives = $"            
    videomsg db "Video Mode = $"                
    videomsg1 db " None$"                        
    videomsg2 db " 40*25 Color$"                
    videomsg3 db " 80*25 Color$"                
    videomsg4 db " 80*25 Monochrome$"    

.code
start:
    mov ax, @data        ; Load address of data in AX
    mov ds, ax           ; Move AX into DS to point DS to data
    
    mov ah, 2            ; Service # to get status of Special Keys
    int 16h              ; Interrupt to do job
    
    mov cl, 2            ; Initialize CL = 2
    shl al, cl           ; Shift left two times to check 2nd bit for caps-lock
    jnc nocaps1          ; Jump if carry = 0 to nocaps1 label
    
    lea dx, capsmsg1     ; Load address of string capsmsg1
    mov ah, 9h           ; Service # to display string
    int 21h              ; Interrupt to do job
    
            ; Following piece of code for formatting
    mov dl, 13           ; Copying ASCII of carriage return in DL
    mov ah, 2h           ; Service # to display single character
    int 21h              ; Interrupt to do job
    mov dl, 10           ; Copying ASCII of new line in DL
    mov ah, 2h           ; Service # to display single character
    int 21h              ; Interrupt to do job

    lea dx, drivemsg     ; Load address of string drivemsg
    mov ah, 9h
    int 21h

    int 11h
    mov cl, 6            ; Initialize CL = 6
    mov bx, ax           ; Move BX = AX (Equipment List)
    and bx, 0c0h         ; and BX with 0c0h to get status of 6th and 7th bit
    shr al, cl           ; Shift right 6 into AL
    mov dl, al           ; Move (result) AL in DL
    add dl, 31h          ; Add 31h in DL to get ASCII (1h more because if answer 00, then drive = 1)

    mov ah, 2h           ; Service # to display single character
    int 21h
    jmp videostat        ; Jump to label of videostat

    nocaps1:             ; Start of nocaps1 label
    jmp nocaps2          ; Again jumped to nocaps2 (2 jumps applied because of large size of code)

videostat:               ; Start of videostat label
    
            ; Following piece of code for formatting
    mov dl, 13
    mov ah, 2h
    int 21h
    mov dl, 10
    mov ah, 2h
    int 21h

    lea dx, videomsg     ; Load address of string videomsg
    mov ah, 9h
    int 21h

    int 11h              ; Interrupt to get Equipment List
    mov cl, 6            ; Initialize CL = 6
    mov bx, ax           ; Copy Equipment List AX into BX
    shr bx, cl           ; Shift-Right BX upto 6 bits
    jc labelone          ; Jump if carry to labelone
    jmp labelzero        ; Jump if not carry to labelzero
    
labelzero:               ; Start of labelzero
    mov cl, 5            ; Initialize CL = 5
    mov bx, ax           ; Move AX to BX for checking the 2nd bit
    shr bx, cl           ; Shift-Right BX upto 5 bits for its status
    jc labelzerone       ; Jump if carry to labelzerone
    jmp labelzerozero    ; Jump if not carry to labelzerozero

labelzerozero:           ; Start of labelzerozero
    lea dx, videomsg1    ; If 2nd bit is zero. Load address of string videomsg1.
    mov ah,9h
    int 21h
    jmp endme            ; Jump to end of program

labelzerone:             ; Start of labelzerone
    lea dx,videomsg2     ; If 2nd bit is 1, load address of string videmsg2
    mov ah,9h
    int 21h
    jmp endme            ; Jump to end of Program

labelone:                ; Start of labelone
    mov cl,5             ; Initialize CL = 5
    mov bx,ax            ; Move AX to BX for checking 2nd bit
    shr bx,cl            ; Shift-Right BX upto 5 bits for its status
    jc labeloneone       ; Jump if carry to labeloneone
    jmp labelonezero     ; Jump if not carry to labelonezero

labelonezero:            ; Start of labelonezero
    lea dx,videomsg3     ; If 2nd bit is 0, load address string of videomsg3
    mov ah,9h
    int 21h
    jmp endme            ; Jump to end of Program

labeloneone:             ; Start of labeloneone
    lea dx,videomsg4     ; If 2nd bit is 0, load address string of videomsg4
    mov ah,9h
    int 21h
    jmp endme            ; Jump to end of Program

nocaps2:                 ; Start of labelnocaps2
    lea dx, capsmsg2     ; Load address of string capsmsg2
    mov ah, 9h
    int 21h

            ; Following piece of code for formatting
    mov dl, 13
    mov ah, 2h
    int 21h
    mov dl, 10
    mov ah, 2h
    int 21h

    int 11h              ; Interrupt to get Equipment List
    mov bx, ax           ; Copy Equipment List AX into BX
    and bx, 1            ; And BX with 1 to check status of bit 1 for floppy status
    jz nofloppy          ; Jump if answer is zero to nofloppy label

    lea dx, floppymsg1   ; Load address of string floppymsg1
    mov ah, 9h
    int 21h
    jmp mathprocessor    ; jump to mathprocessor label

nofloppy:                ; Start of nofloppy label
    lea dx, floppymsg2   ; Load address of string floppymsg2
    mov ah, 9h
    int 21h

mathprocessor:           ; Start of mathprocessor label
            ; Following piece of code for formatting
    mov dl, 13
    mov ah, 2h
    int 21h
    mov dl, 10
    mov ah, 2h
    int 21h

    int 11h              ; Interrupt to get Equipment List
    mov bx, ax           ; Copy Equipment List AX into BX
    and ax, 2            ; And BX with 1 to check status of bit 2 for math processor status
    jz nomath            ; Jump if answer is zero to nomath label

    lea dx, mathmsg1     ; Load address of string mathmsg1
    mov ah, 9h
    int 21h
    jmp dma              ; Jump to label dma

nomath:                  ; Start of nomath label
    lea dx, mathmsg2     ; Load address of string mathmsg2
    mov ah, 9h
    int 21h

dma:                     ; Start of dma label
            ; Following piece of code for formatting
    mov dl, 13
    mov ah, 2h
    int 21h
    mov dl, 10
    mov ah, 2h
    int 21h

    int 11h              ; Interrupt to get Equipment List
    mov bx, ax           ; Copy Equipment List AX into BX
    and bx, 8            ; And BX with 1 to check status of bit 2 for math processor status
    jz nodma             ; Jump if answer is zero to nodma label
    
    lea dx, dmamsg1      ; Load address of string dmamsg1
    mov ah, 9h
    int 21h
    jmp endme            ; Jump to End of program
    
nodma:                   ; Start of nodma label
    lea dx, dmamsg2      ; Load address of string dmamsg2
    mov ah, 9h    
    int 21h

endme:                   ; Start of endme label
    mov ah, 4ch          ; Service # to terminate program normally
    int 21h              ; Interrupt to do job

end start