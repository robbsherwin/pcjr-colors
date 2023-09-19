.model small
.data
.code
.stack 100h   ; Define a stack segment with 256 bytes (100h in hexadecimal)

org 100h

start:
    mov ax, 0010h       ; Set video mode 10h (160x200, 16 colors)
    int 10h             ; This is the software interrupt that triggers a BIOS video service call.

    ; Set the entire screen to blue (color index 1)
    mov ax, 0B800h      ; Segment address for PCjr video memory
    mov es, ax          ; Sets the Extra Segment register. 
    xor di, di          ; Destination offset (start of video memory)
    mov cx, 04000h      ; Number of bytes (160x200 pixels)
    ;mov al,17	        ; Blue (decimal 17, hex 11h, binary 0001 0001).
    mov al,22h          ; Green? (decimal 34, hex 22h, binary 0010 0010).
    cld                 ; Clear direction flag for forward string operation

    ; repeat storebyte. Repeats it the number of times specified by the cx register. 
    rep stosb          ; Fill screen with blue.

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