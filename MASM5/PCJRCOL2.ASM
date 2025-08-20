.model small
.data
.code
.stack 100h   ; Define a stack segment with 256 bytes (100h in hexadecimal)

org 100h

start:
    mov ax, 0010h       ; Set video mode 10h (160x200, 16 colors)
    int 10h             ; This is the software interrupt that triggers a BIOS video service call.

    mov bl,34d          ; This moves the color green into the register bl
    mov dl,1d           ; Initialize color counter to 1
color_loop:
    ; Set the entire screen to blue (color index 1)
    mov ax, 0B800h      ; Segment address for PCjr video memory
    mov es, ax          ; Sets the Extra Segment register. 
    xor di, di          ; Destination offset (start of video memory)
    mov cx, 04000h      ; Number of bytes (160x200 pixels)
    mov al,bl           ; This will move green into the al register.
    ;mov al,17          ; Blue (decimal 17, hex 11h, binary 0001 0001).
    ;mov al,22h         ; Green? (decimal 34, hex 22h, binary 0010 0010).
    cld                 ; Clear direction flag for forward string operation

    ; repeat storebyte. Repeats it the number of times specified by the cx register. 
    rep stosb          ; Fill screen with blue.

; Wait for joystick button press (either button 1 or 2)
wait_for_joystick:
    mov dx, 201h        ; Load port address into DX register
    in al, dx            ; Read joystick port
    test al, 30h        ; Test bits 4 and 5 (joystick buttons 1 and 2)
    jnz wait_for_joystick  ; If buttons are not pressed (bits are 1), keep waiting

color_loop2:
    ; BLUE 17, GREEN 34, CYAN 51, next color is 68 
    mov ax, 0B800h      ; Segment address for PCjr video memory
    mov es, ax          ; Sets the Extra Segment register. 
    xor di, di          ; Destination offset (start of video memory)
    mov cx, 04000h      ; Number of bytes (160x200 pixels)
    add bl,17d          ; Add 17 to what is in bl. In theory, this is now cyan. 
    mov al,bl           ; Cyan (decimal 51)
    cld                 ; Clear direction flag for forward string operation

    ; repeat storebyte. Repeats it the number of times specified by the cx register. 
    rep stosb          ; Fill screen with blue.
    inc dl              ; Increment color counter

; Wait for Enter key (carriage return)
;wait_for_enter2:
;    mov ah, 0
;    int 16h                     ; Wait for a key press
;    cmp al, 13                  ; Check if the key pressed is the Enter key (ASCII code 13)
;    jne wait_for_enter2         ; If not, keep waiting

; Wait for joystick button press (either button 1 or 2)
wait_for_joystick2:
    mov dx, 201h                ; Load port address into DX register
    in al, dx                   ; Read joystick port
    test al, 30h                ; Test bits 4 and 5 (joystick buttons 1 and 2)
    jnz wait_for_joystick2      ; If buttons are not pressed (bits are 1), keep waiting    

; See if we want to end the program or not. 
    ;cmp dl, 15d                 ; Check if we've reached the end of the colors (15 colors total)

    ;jae - jump above or equal
    ;jae end_program             ; If so, end program. 
    ;jmp color_loop2             ; Otherwise, repeat the color cycle loop

end_program:
    mov ax, 3          ; Set video mode 3 (80x25 text mode)
    int 10h

    mov ax, 4C00h      ; DOS function number for terminating a program.
    int 21h            ; DOS function: terminate program
end start