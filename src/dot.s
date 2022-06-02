.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:
	#ector < 1
    li t5, 1     #comparision variable
    blt a2, t5, exit_57
    # stride < 1
    blt a3, t5, exit_58
    blt a4, t5, exit_58
    
    # Prologue
    addi sp, sp, -24 # sp = sp + -24
    sw ra, 0(sp) # Push return address
    sw s0, 4(sp) # 
    sw s1, 8(sp) # 
    sw s2, 12(sp) # 
    sw s3, 16(sp) # 
    
    #counter t0 = 0
    li t0, 0
    li t1, 0
    #s0 = 0, s1=0
    mv s0, zero #Ahhh you're gettin' smarter, son
    mv s1, zero
    #counter for stride
    mv s2, a3
    mv s3, a4

loop_start:
	beq t0, a2 loop_end #end LOOP when counter == len(array)
   
    lw t4, 0(a0)
    lw t5, 0(a1)

    mul s0, t4, t5    #multiply the two lodaded elements
    add s1, s1, s0
    
    slli t4, t0, 2 #offsets
    addi t2, zero, 2
    sll t4, s2, t2
    sll t5, s3, t2

    add a0, a0, t4
    add a1, a1, t5
    beq t0, s1, loop_increment

loop_increment:
    addi t4, zero, 1
    #increment counter
    add t0, t0, t4
    j loop_start

loop_end:
	mv a0 s1
    # Epilogue
    lw s3, 16(sp) # 
    lw s2, 12(sp) # 
    lw s1, 8(sp) # 
    lw s0, 4(sp) # 
    lw ra, 0(sp) # Push return address
    addi sp, sp, 24 # sp = sp + 24
    ret
    
# exit  code 57,58
exit_57:
	li a1 57
    jal exit2
exit_58:
	li a1 58
    jal exit2