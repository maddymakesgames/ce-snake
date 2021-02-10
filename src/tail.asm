; clears the current tail location and moves the tail
update_tail:
    ; clear the current tail cell
    call clear_tail

    ; get current board space
    ld de, 0
    ld a, (tail_x)
    ld e, a
    ld a, (tail_y)
    ld h, a
    call get_board_index
    
tail_dir_check:
    ld (hl), 0

    bit 1, a
    jr nz, tail_down
    bit 2, a
    jr nz, tail_up
    bit 3, a
    jr nz, tail_right
    bit 4, a
    jr nz, tail_left
    jr tail_end

tail_right:
    ld hl, tail_x
    inc (hl)
    jr tail_end
tail_left:
    ld hl, tail_x
    dec (hl)
    jr tail_end
tail_down:
    ld hl, tail_y
    inc (hl)
    jr tail_end
tail_up:
    ld hl, tail_y
    dec (hl)
    jr tail_end
tail_end:
    ret
