.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:

    # Error checks
    addi t0,zero, 1
    #The height or width of either matrix is less than 1.
    blt a1, t0, exit_59     #check rows m0
    blt a2, t0, exit_59     #check cols m0
    blt a4, t0, exit_59     #check rows m1
    blt a5, t0, exit_59     #check cols m1
    #The number of columns (width) of the first matrix A is not equal to the 
    #number of rows (height) of the second matrix B.
    bne a2, a4, exit_59
    


    # Prologue
    addi sp, sp, -28
    sw ra,  0(sp)
    sw s0,  4(sp)
    sw s1,  8(sp)
    sw s2,  12(sp)
    sw s3,  16(sp)
    sw s4,  20(sp)
    sw s5,  24(sp)

    #set up registers
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5

    li s0, 0
    li s1, 0
    li s2, 0
    li s3, 0
    li t0, 0
    
outer_loop_start:
    bge s1, a1, outer_loop_end  #ending condition
    li t1, 0
    mv s2, t1
    j inner_loop_start

inner_loop_start:
    bge s2, a5, inner_loop_end  #ending condition
    slli t2 s2 2
    add  t2 t2 a3

    #Prologue
    addi sp, sp, -32
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw a7, 28(sp)

    li t4, 2
    li t0, 0
    mul t0, s1, t4
    mul t1, a2, t4
    mul t2, t0, t1  #offset
    add a0, a0, t2
    
    slli t0, s2, 2 #offset
    add t6, a3, t0
    mv a1, t6
    
    addi a3, zero, 1    #row vector stride = 1
    mv a2, s4
    mv a4, s5

    jal ra, dot
    add t1, a0, zero


    #Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp) 
    lw a7, 28(sp)
    addi sp, sp, 32

    #store result
    li t5, 4
    slli t2, s0, 2
    mv a7, a6
    add t2, t2, a7
    sw t1, 0(t2)
    li t6, 1    
    add s0, s0, t6  #incremnent 
    bge s0, s2, loop_increment

    j inner_loop_start

loop_increment: 

    add s2, s2, t6  #incremnent  
    j inner_loop_start

inner_loop_end:
    addi s1, s1, 1
    bne s1, t1, outer_loop_start

outer_loop_end:
    # Epilogue
    
    lw ra,  0(sp)
    lw s0,  4(sp)
    lw s1,  8(sp)
    lw s2,  12(sp)
    lw s3,  16(sp)
    lw s4,  20(sp)
    lw s5,  24(sp)
    addi sp, sp, 28
    
    ret


exit_59:
    li a1, 59
    jal exit2