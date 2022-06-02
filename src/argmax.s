.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

    mv s0, a0
    mv s1, a1

	li t0, 1
    beq t0, s1, reset_index
    blt s1, t0, exit_57


reset_index:
    #use MV
    add s0, x0, zero    #Dumb way to do, but it's the first task so.... 
    lw s1, 0(a0) 
    add t0, x0, zero    #Dumb way to do, but it's the first task so.... 

loop_start:
    lw t1, 0(a0)
    ble t1, s1, loop_continue
    mv s0, t0
    mv s1, t1

loop_continue:
    li t1, 1
	addi a0, a0, 4
	add t0, t0, t1
    bge t0, a1, loop_end
	j loop_start

loop_end:
	add a0, s0, x0
    # Epilogue
    lw ra, 8(sp)
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 12
    ret

exit_57:
    li a1, 57
    j exit2


