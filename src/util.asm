; gets the index and value of a board cell
; the address to the board cell is stored in hl and the value is stored in a
; effects de, hl, a
get_board_index:
    ; y_offset = y * 9
    ; total_offset = y_offset + x
    ; final_offset = board + total_offset
    ld l, 9
    mlt hl ; multiply h * l (y * 9)
    ld d, 0
    add hl, de ; add hl + de (mul result + tail_x)
    ld de, board
    add hl, de ; get offset into board
    ld a, (hl) ; load value into a
    ret
; enables the death flag

; places a head character at the current head location
place_head:
    ld a, (head_x)
    ld (ti.curCol), a
    ld a, (head_y)
    ld (ti.curRow), a
    ld a, 'O'
    call ti.PutC
    ret

; places a body character at the current head location
place_body:
    ld a, (head_x)
    ld (ti.curCol), a
    ld a, (head_y)
    ld (ti.curRow), a
    ld a, '0'
    call ti.PutC
    ret

; places a ' ' at the current tail location to clear it
clear_tail:
    ld a, (tail_x)
    ld (ti.curCol), a
    ld a, (tail_y)
    ld (ti.curRow), a
    ld a, ' '
    call ti.PutC
    ret

; a is max
; a is output
; not inclusive
; hl, bc, af and d are destroied
rand_in_range:
    ld d, a
    ld hl, (rand_seed)
    call rand8
    ld (rand_seed), hl
    ld c, a
    call C_Div_D
    ret

; inits continuous key scanning
init_key_scan:
    di
    ld	hl,ti.DI_Mode
    ld	(hl),3
    inc hl
    ld de, 0xA00
    ld (hl), de
    ret

; checks if the tail is enabled and then updates
check_and_update_tail:
    ld hl, snake_flags
    bit 0, (hl)
    jp nz, toggle_tail
    call update_tail
    ret

; toggles the tail enable bit of snake_flags
toggle_tail:
    ld a, (snake_flags)
    xor a, 000000001b
    ld (snake_flags), a
    ret

;This code snippet is 9 bytes and 43cc
;Inputs:
;   HL is the input seed and must be non-zero
;Outputs:
;   A is the 8-bit pseudo-random number
;   HL is the new seed value (will be non-zero)
rand8:
                  ;opcode cc
    add hl,hl     ; 29    11
    sbc a,a       ; 9F     4
    and 00101101b ; E62D   7
    xor l         ; AD     4
    ld l,a        ; 6F     4
    ld a,r        ; ED5F   9
    add a,h       ; 84     4
    ret

;Inputs:
;     C is the numerator
;     D is the denominator
;Outputs:
;     A is the remainder
;     B is 0
;     C is the result of C/D
;     DE,HL are not changed
C_Div_D:
  ld b,8
  xor a
C_Div_D_loop:
  sla c
  rla
  cp d
  jr c,+_
  inc c
  sub d
_:
  djnz C_Div_D_loop
  ret

itoa_8:
;Input:
;   A is a signed integer
;   HL points to where the null-terminated ASCII string is stored (needs at most 5 bytes)
;Output:
;   The number is converted to a null-terminated string at HL
;Destroys:
;   Up to five bytes at HL
;   All registers preserved.
  push hl
  push de
  push bc
  push af
  or a
  jp p,itoa_pos
  neg
  ld (hl),$1A  ;start if neg char on TI-OS
  inc hl
itoa_pos:
;A is on [0,128]
;calculate 100s place, plus 1 for a future calculation
  ld b,'0'
  cp 100 
  jr c,$+5 
  sub 100 
  inc b

;calculate 10s place digit, +1 for future calculation
  ld de,$0A2F
  inc e 
  sub d 
  jr nc,$-2
  ld c,a

;Digits are now in D, C, A
; strip leading zeros!
  ld a,'0'
  cp b 
  jr z,$+5 
  ld (hl),b 
  inc hl 
  db $FE  ; start of `cp *` to skip the next byte, turns into `cp $BB` which will always return nz and nc
  cp e 
  jr z,$+4 
  ld (hl),e 
  inc hl
  add a,c
  add a,d
  ld (hl),a
  inc hl
  ld (hl),0

  pop af
  pop bc
  pop de
  pop hl
  ret