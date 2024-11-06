# Function: draw_spiral
# Description:
#   Draws a spiral starting from (x, y) with initial size and colour.
# Parameters:
#   int x       - starting x-coordinate (a0)
#   int y       - starting y-coordinate (a1)
#   int size    - initial size of the spiral (a2)
#   int colour  - colour to use for the spiral (a3)
# Registers Used:
#   s0 - x-coordinate (x)
#   s1 - y-coordinate (y)
#   s2 - size (size)
#   s3 - colour (colour)
#   s4 - temporary variable
#   s5 - temporary variable
# Calling Convention:
#   Saves ra and s-registers used.
.globl draw_spiral
draw_spiral:
    # Prologue: Save ra and s-registers
    addi    sp, sp, -28      # Allocate stack space
    sw      ra, 24(sp)
    sw      s0, 20(sp)
    sw      s1, 16(sp)
    sw      s2, 12(sp)
    sw      s3, 8(sp)
    sw      s4, 4(sp)
    sw      s5, 0(sp)

    # Preserve input parameters in s-registers
    move    s0, a0           # s0 = x
    move    s1, a1           # s1 = y
    move    s2, a2           # s2 = size
    move    s3, a3           # s3 = colour

    # Optional: Use different colours for debugging
    # Uncomment the following lines to use different colours
    # for horizontal and vertical lines
    # li      t0, COLOR_RED    # Horizontal line colour
    # li      t1, COLOR_GREEN  # Vertical line colour

draw_spiral_loop:
    ble     s2, 1, draw_spiral_exit  # while(size > 1)

    # Draw horizontal line
    move    a0, s0           # a0 = x
    move    a1, s1           # a1 = y
    move    a2, s2           # a2 = size
    move    a3, s3           # a3 = colour
    jal     draw_horizontal_line

    # Update x and size
    add     s0, s0, s2       # x = x + size
    addi    s0, s0, -1       # x = x - 1
    addi    s2, s2, -1       # size--

    # Draw vertical line
    move    a0, s0           # a0 = x
    move    a1, s1           # a1 = y
    move    a2, s2           # a2 = size
    move    a3, s3           # a3 = colour
    jal     draw_vertical_line

    # Update y and size
    add     s1, s1, s2       # y = y + size
    addi    s1, s1, -1       # y = y - 1
    addi    s2, s2, -1       # size--

    # Update x for the next horizontal line
    sub     s0, s0, s2       # x = x - size
    addi    s0, s0, 1        # x = x + 1

    # Draw horizontal line (reverse direction)
    move    a0, s0           # a0 = x
    move    a1, s1           # a1 = y
    move    a2, s2           # a2 = size
    move    a3, s3           # a3 = colour
    jal     draw_horizontal_line

    # Update size
    addi    s2, s2, -1       # size--

    # Update y for the next vertical line
    sub     s1, s1, s2       # y = y - size
    addi    s1, s1, 1        # y = y + 1

    # Draw vertical line (reverse direction)
    move    a0, s0           # a0 = x
    move    a1, s1           # a1 = y
    move    a2, s2           # a2 = size
    move    a3, s3           # a3 = colour
    jal     draw_vertical_line

    # Update size
    addi    s2, s2, -1       # size--

    j       draw_spiral_loop

draw_spiral_exit:
    # Epilogue: Restore registers and return
    lw      ra, 24(sp)
    lw      s0, 20(sp)
    lw      s1, 16(sp)
    lw      s2, 12(sp)
    lw      s3, 8(sp)
    lw      s4, 4(sp)
    lw      s5, 0(sp)
    addi    sp, sp, 28       # Deallocate stack space
    jr      ra
