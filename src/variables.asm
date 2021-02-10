; points to pixelShadow2 which should never be used by the OS and thus should be safe to use as ram
ram_base := ti.cmdPixelShadow
; head pos
head_x := ram_base
head_y := ram_base + 1
; tail pos
tail_x := ram_base + 2
tail_y := ram_base + 3
; Any flags used by the game
; 0: set when the tail is inactive
; 1: set when dead
snake_flags := ram_base + 4
; the current score
score := ram_base + 5
; current direction
curr_dir := ram_base + 6
; apple pos
apple_x := ram_base + 7
apple_y := ram_base + 8
; rand int seed
rand_seed := ram_base + 9
; a list of 9x12 bytes to store the state of the board
; TODO: make this bitwise instead of bytewise to save bytes
board := ram_base + 10

end_text:
    db "You had a score of: ",0
num_text:
    db "0000", 0