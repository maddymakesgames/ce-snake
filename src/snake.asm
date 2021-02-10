include 'include/ez80.inc'
include 'include/tiformat.inc'
include 'include/ti84pceg.inc'
format ti executable 'SNAKE'

include 'init.asm'
main_loop:
    ld a, 20
    call ti.DelayTenTimesAms

    call check_and_update_tail
    call update_head

    ld hl, snake_flags
    bit 1, (hl)
    jr z, main_loop

exit:
    xor a, a
    ld (ti.curCol), a
    xor a, a
    ld (ti.curRow), a
    ld hl, end_text
    call ti.PutS
    ld a, 20
    ld (ti.curCol), a
    xor a, a
    ld (ti.curRow), a
    ld a, (score)
    ld hl, num_text
    call itoa_8
    call ti.PutS

    jp ti.NewLine

include 'head.asm'
include 'tail.asm'
include 'apple.asm'
include 'util.asm'
include 'variables.asm'