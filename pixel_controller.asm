## pixel_controller.asm
# I worked this Lab with fengyu chen
.include "macros.asm"
.include "constants.asm"
.include "pixel_struct.asm"

.globl pixel_update

.text
# void pixel_update()
# 1. This function reads the keyboard input and updates the selected pixel's position accordingly
# 2. It also handles switching between pixels using a button press
pixel_update:
    # Prologue: Save registers that will be used
    addi    $sp, $sp, -16      # Allocate stack space
    sw      $ra, 12($sp)       # Save return address
    sw      $s0, 8($sp)        # Save $s0 (pixel index)
    sw      $s1, 4($sp)        # Save $s1 (pixel address)
    sw      $s2, 0($sp)        # Save $s2 (key input)

    # Get the currently selected pixel index
    jal     pixel_find_selected
    move    $s0, $v0           # $s0 = index of selected pixel

    # Get the address of the selected pixel structure
    move    $a0, $s0           # $a0 = index
    jal     pixel_get_element
    move    $s1, $v0           # $s1 = address of the pixel struct

    # Read keyboard input
    li      $v0, 7            # Syscall to read from keyboard
    syscall
    move    $s2, $v0           # $s2 = key input

    # Update pixel position based on input
    beq     $s2, KEY_U, _move_up
    beq     $s2, KEY_D, _move_down
    beq     $s2, KEY_L, _move_left
    beq     $s2, KEY_R, _move_right
    beq     $s2, KEY_B, _switch_pixel
    j       _pixel_update_exit

_move_up:
    lw      $t0, pixel_y($s1)  # Load y coordinate
    addi    $t0, $t0, -1       # y--
    bgez    $t0, _update_y    # Ensure y is not negative
    li      $t0, 0            # Set y to 0 if negative
_update_y:
    sw      $t0, pixel_y($s1)  # Store updated y
    j       _pixel_update_exit

_move_down:
    lw      $t0, pixel_y($s1)  # Load y coordinate
    addi    $t0, $t0, 1        # y++
    blt     $t0, DISPLAY_H, _update_y_down  # Ensure y is within bounds
    li      $t0, DISPLAY_H-1  # Set y to max if out of bounds
_update_y_down:
    sw      $t0, pixel_y($s1)  # Store updated y
    j       _pixel_update_exit

_move_left:
    lw      $t0, pixel_x($s1)  # Load x coordinate
    addi    $t0, $t0, -1       # x--
    bgez    $t0, _update_x    # Ensure x is not negative
    li      $t0, 0            # Set x to 0 if negative
_update_x:
    sw      $t0, pixel_x($s1)  # Store updated x
    j       _pixel_update_exit

_move_right:
    lw      $t0, pixel_x($s1)  # Load x coordinate
    addi    $t0, $t0, 1        # x++
    blt     $t0, DISPLAY_W, _update_x_right  # Ensure x is within bounds
    li      $t0, DISPLAY_W-1  # Set x to max if out of bounds
_update_x_right:
    sw      $t0, pixel_x($s1)  # Store updated x
    j       _pixel_update_exit

_switch_pixel:
    # Switch to the next pixel
    lw      $t0, pixel_selected($s1)  # Load current selected status
    li      $t1, 0
    sw      $t1, pixel_selected($s1)  # Deselect the current pixel

    # Increment the pixel index and wrap around if necessary
    addi    $s0, $s0, 1        # Increment index
    rem     $s0, $s0, 3        # Wrap around (since there are 3 pixels)

    # Get the address of the new selected pixel
    move    $a0, $s0           # $a0 = new index
    jal     pixel_get_element
    move    $s1, $v0           # $s1 = address of the new pixel struct

    # Select the new pixel
    li      $t1, 1
    sw      $t1, pixel_selected($s1)  # Set selected status

_pixel_update_exit:
    # Epilogue: Restore registers and return
    lw      $ra, 12($sp)       # Restore return address
    lw      $s0, 8($sp)        # Restore $s0
    lw      $s1, 4($sp)        # Restore $s1
    lw      $s2, 0($sp)        # Restore $s2
    addi    $sp, $sp, 16       # Deallocate stack space
    jr      $ra               # Return to caller
