## This file implements the functions that display the pixels based on the model
# I worked this Lab with fengyu chen
# Include the macros file so that we save some typing! :)
.include "macros.asm"
# Include the constants settings file with the board settings! :)
.include "constants.asm"
# We will need to access the pixel model, include the structure offset definitions
.include "pixel_struct.asm"

# This function needs to be called by other files, so it needs to be global
.globl pixel_draw
.text
# void pixel_draw()
#   Draws all the pixels on the display, based on their position and selected status.
#   Selected pixels are drawn in a different color than non-selected pixels.
pixel_draw:
    # Prologue: Save registers that will be used
    addi    $sp, $sp, -16      # Allocate stack space
    sw      $ra, 12($sp)       # Save return address
    sw      $s0, 8($sp)        # Save $s0
    sw      $s1, 4($sp)        # Save $s1
    sw      $s2, 0($sp)        # Save $s2

    li      $t0, 0            # $t0 = index (loop counter)
    li      $t1, 3            # Total number of pixels is 3

_pixel_draw_loop:
    bge     $t0, $t1, _pixel_draw_exit  # Exit loop if index >= 3

    # Get the address of the pixel structure
    move    $a0, $t0          # $a0 = index
    jal     pixel_get_element
    move    $s0, $v0          # $s0 = address of the pixel struct

    # Load x, y, and selected status from the pixel struct
    lw      $s1, pixel_x($s0)      # $s1 = x coordinate
    lw      $s2, pixel_y($s0)      # $s2 = y coordinate
    lw      $t2, pixel_selected($s0)  # $t2 = selected status

    # Determine color based on selected status
    beqz    $t2, _pixel_not_selected
    li      $t3, COLOR_RED        # $t3 = color for selected pixel
    j       _pixel_draw_pixel

_pixel_not_selected:
    li      $t3, COLOR_BLUE       # $t3 = color for non-selected pixel

_pixel_draw_pixel:
    # Check if the coordinates are within the display bounds
    bgez    $s1, _x_in_bounds
    j       _pixel_draw_skip     # Skip if x is out of bounds
_x_in_bounds:
    blt     $s1, DISPLAY_W, _y_in_bounds
    j       _pixel_draw_skip     # Skip if x is out of bounds
_y_in_bounds:
    bgez    $s2, _y_check2
    j       _pixel_draw_skip     # Skip if y is out of bounds
_y_check2:
    blt     $s2, DISPLAY_H, _draw_pixel
    j       _pixel_draw_skip     # Skip if y is out of bounds

_draw_pixel:
    # Draw the pixel on the display
    move    $a0, $s1               # $a0 = x coordinate
    move    $a1, $s2               # $a1 = y coordinate
    move    $a2, $t3               # $a2 = color
    jal     display_set_pixel

_pixel_draw_skip:
    # Increment index and loop
    addi    $t0, $t0, 1
    j       _pixel_draw_loop

_pixel_draw_exit:
    # Epilogue: Restore registers and return
    lw      $ra, 12($sp)       # Restore return address
    lw      $s0, 8($sp)        # Restore $s0
    lw      $s1, 4($sp)        # Restore $s1
    lw      $s2, 0($sp)        # Restore $s2
    addi    $sp, $sp, 16       # Deallocate stack space
    jr      $ra               # Return to caller
