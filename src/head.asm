; update the heads position and run collision logic
update_head: 
    call place_body

    ; get the current board cell
    ld de, 0
    ld a, (head_x)
    ld e, a
    ld a, (head_y)
    ld h, a
    call get_board_index

    ; check the key pressed
    ld a, (ti.kbdG7)
    cp 0
    jr nz, head_dir_check
    ld a, (curr_dir)
head_dir_check:

    bit ti.kbitUp, a
    jr nz, head_up
    bit ti.kbitDown, a
    jr nz, head_down
    bit ti.kbitRight, a
    jr nz, head_right
    bit ti.kbitLeft, a
    jr nz, head_left

head_down:
    ld d, a
    ld a, (curr_dir)
    bit ti.kbitUp, a
    jr nz, head_up
    ld a, d
    ld (hl), 00000011b
    ld hl, head_y
    inc (hl)
    jr head_end
head_up:
    ld d, a
    ld a, (curr_dir)
    bit ti.kbitDown, a
    jp nz, head_down
    ld a, d
    ld (hl), 00000101b
    ld hl, head_y
    dec (hl)
    jr head_end
head_right:
    ld d, a
    ld a, (curr_dir)
    bit ti.kbitLeft, a
    jr nz, head_left
    ld a, d
    ld (hl), 00001001b
    ld hl, head_x
    inc (hl)
    jr head_end
head_left:
    ld d, a
    ld a, (curr_dir)
    bit ti.kbitRight, a
    jp nz, head_right
    ld a, d
    ld (hl), 00010001b
    ld hl, head_x
    dec (hl)
head_end:
    ; save the current direction
    and a, 01111111b
    ld (curr_dir), a

    ; check if we moved outside the bounds of the screen
    ld a, (head_x)
    cp 26
    jr z, kill
    cp 0xff
    jp z, kill
    ld a, (head_y)
    cp 0xff
    jr z, kill
    cp 10
    jr z, kill

    ld de, 0
    ld a, (head_x)
    ld e, a
    ld a, (head_y)
    ld h, a
    call get_board_index

    ld a, (hl)
    bit 0, a
    jp nz, kill
    bit 7, a
    jr z, head_ret
score_inc:
    ld hl, score
    inc (hl)
    call toggle_tail
    call place_apple

head_ret:
    call place_head
    ret

kill:
    ld a, (snake_flags)
    xor a, 00000010b
    ld (snake_flags), a
    ret