; load initial values into ram
init:
    ld a, 12
    ld (head_x), a
    ld (tail_x), a

    ld a, 4
    ld (head_y), a
    ld (tail_y), a

    ld a, 00000001b
    ld (snake_flags), a

    ld a, 100b
    ld (curr_dir), a

    ld a, 0
    ld (score), a

    ld a, 82 ; found from random.org
    ld (rand_seed), a

    ld hl, board
    ld bc, 25*10
    call ti.MemClear

    ; Setup the screen for printing
    call ti.RunIndicOff
    call ti.ClrLCD
    call ti.HomeUp
    call init_key_scan

    res ti.appAutoScroll, (iy + ti.appFlags)

    call place_head
    call place_apple
    ; init breakpoints
    scf
    sbc hl, hl
    ; ld de, place_apple
    ld (hl), 3
    ; ld de, score_inc
    ld (hl), 3