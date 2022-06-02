.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================
relu:
    
    # Prologue
    addi sp, sp, -8 # move sp down 3 rows
    sw s0, 0(sp) # Store register s0
    sw s1, 4(sp) # Store register s1
    addi t0, x0, 1  
    blt t0, a0, initial

# initialize argument
#Counter = 0
 initial:   
    mv t0, x0
    

loop_start:
    add  s0, a0, zero # s0 = a0
    add  s1, a1, zero # s1 = a1
    blt s1, t0, exit_57
    j loop_continue

loop_continue:
    beq t0, s1, loop_end
    lw t2, 0(a0)
    bge t2, zero, loop_increment
    mv t2, x0
    sw t2, 0(a0)
    j loop_start
    

loop_increment:
    li t3, 4
    li t4, 1
    add a0, a0, t3
	add t0, t0, t4
	j loop_continue
        
loop_end:
    # Epilogue
    lw s0, 0(sp) # Restore s0
    lw s1, 4(sp) # Restore s1
    addi sp, sp, 8 
    ret

exit_57:
    li a1, 57
    j exit2