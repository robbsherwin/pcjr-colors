.model small
.data
.code
.stack 100h   ; Define a stack segment with 256 bytes (100h in hexadecimal)

org 100h

start:
    mov ax, 0010h       ; Set video mode 10h (160x200, 16 colors)
    int 10h             ; This is the software interrupt that triggers a BIOS video service call.

    mov bl,34d          ; This moves the color green into the register bl
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

; Wait for Enter key (carriage return)
wait_for_enter:
    mov ah, 0
    int 16h             ; Wait for a key press
    cmp al, 13          ; Check if the key pressed is the Enter key (ASCII code 13)
    jne wait_for_enter     ; If not, keep waiting

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

; Wait for Enter key (carriage return)
wait_for_enter2:
    mov ah, 0
    int 16h             ; Wait for a key press
    cmp al, 13          ; Check if the key pressed is the Enter key (ASCII code 13)
    jne wait_for_enter2     ; If not, keep waiting


; Cycle to the next color
;    mov al, [color_index]   ; Load the current color index 
;    add al, 17             ; Increment by 17 in decimal for the next color 
;    cmp al, 68             ; Check if we've reached the end of the colors
    ; jae - jump above or equal
;    jae wait_for_space      ; If so, jump to wait_for_space
;    mov [color_index], al  ; Store the updated color index
;   jmp color_loop         ; Repeat the color cycle loop


wait_for_space:
    mov ah, 0
    int 16h            ; Wait for a key press
    cmp al, 32         ; Check if the key pressed is the space bar (ASCII code 32)
    jne wait_for_space ; If not, keep waiting

    mov ax, 3          ; Set video mode 3 (80x25 text mode)
    int 10h

    mov ax, 4C00h      ; DOS function: Terminate program
    int 21h

end start