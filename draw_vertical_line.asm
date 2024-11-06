.include "constants.asm"
.include "macros.asm"

.text
.globl draw_vertical_line

# Function: draw_vertical_line
# Draws a vertical line from (x, y) to (x, y + size - 1)
# Parameters:
#   a0 - x-coordinate
#   a1 - y-coordinate
#   a2 - size
#   a3 - colour

draw_vertical_line:
    # Prologue: Save ra and s-registers
    enter   s0, s1, s2, s3, s4

    # Preserve input parameters in s-registers
    move    s0, a0             # s0 = x
    move    s1, a1             # s1 = y
    move    s2, a2             # s2 = size
    move    s3, a3             # s3 = colour

    li      s4, 0              # s4 = i = 0 (loop counter)

_draw_vertical_line_loop:
    # Check if i >= size; if so, exit loop
    bge     s4, s2, _draw_vertical_line_exit

    # Set pixel at (x, y + i)
    move    a0, s0             # a0 = x (fixed)
    add     a1, s1, s4         # a1 = y + i
    move    a2, s3             # a2 = colour
    jal     display_set_pixel  # Call display_set_pixel(x, y + i, colour)

    # Increment loop counter i
    inc     s4
    j       _draw_vertical_line_loop

_draw_vertical_line_exit:
    # Epilogue: Restore registers and return
    leave   s0, s1, s2, s3, s4

