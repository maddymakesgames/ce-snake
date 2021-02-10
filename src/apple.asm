place_apple:
    ld a, 26
    call rand_in_range
    ld hl, apple_x
    ; dec a
    ld (hl), a
    ld a, 10
    call rand_in_range
    ld hl, apple_y
    ; dec a
    ld (hl), a

    ld de, 0
    ld a, (apple_x)
    ld e, a
    ld a, (apple_y)
    ld h, a
    call get_board_index

    cp 0
    jp nz, place_apple
    ld (hl), 10000000b

    ld a, (apple_x)
    ld (ti.curCol), a
    ld a, (apple_y)
    ld (ti.curRow), a
    ld a, '*'
    call ti.PutC
    ret