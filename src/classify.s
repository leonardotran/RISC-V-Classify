.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
     # Prologue
    # Prologue
    addi t0, zero, 5
    bne t0, a0, exit_72

    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp) 
    sw s1, 8(sp) 
    sw s2, 12(sp) 
    sw s3, 16(sp) 
    sw s4, 20(sp) 
    sw s5, 24(sp) 
    sw s6, 28(sp) 
    sw s7, 32(sp) 
    sw s8, 36(sp) 
    sw s9, 40(sp) 
    sw s10, 44(sp) 
    sw s11, 48(sp) 



    li s0, 4 # s0 is argc
    mv s1, a1 # s1 is argv
    mv s2, a2 # s2 is print_classification
    mv s3, a0    
    mv  s4, a0 # s4 = a0
    mv  s5, a0 # s5 = a0
    mv  s6, a0 # s5 = a0
    mv  s7, a0 # s7 = a0
    mv  s8, a0 # s8 = a0
    mv  s9, a0 # s5 = a0
    mv  s10, a0 # s10 = a0
    mv  s11, a0 # s11 = a0

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
 
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    
    li a0, 20   #2 is enough, but why not 5? 
    jal malloc 
    beq a0, x0, exit_88
    mv s3, a0    
    

    li t0, 4
    lw t1, 4(s1)    #a1[1] = *(a1 + 4)
    mv a0, t1
    mv a1, s3
    add t1, s3, t0
    mv a2, t1
    jal ra, read_matrix 
    mv s5, a0   #s5 points to m0
    
  
    # Load pretrained m1
    li a0, 20
    jal malloc 
    blt a0, x0, exit_88
    mv s4, a0

    li t0, 4
    lw t1, 8(s1)    #a1[2] = *(a1 + 8)
    mv a0, t1
    mv a1, s4
    add t2, s4, t0
    mv a2, t2
    jal ra, read_matrix 
    mv s6, a0   #s6 points to m0

         

    # Load input matrix

    li a0, 20
    jal malloc 
    blt a0, x0, exit_88
    mv s7, a0
    
    li t0, 4
    
    lw t1, 12(s1)   #a1[3] = *(a1 + 12)
    mv a0, t1
    mv a1, s7
    add t3, s7, t0
    mv a2, t3
    jal ra, read_matrix 
    mv s9, a0  #s9 points to m0
    
    # =====================================
    # RUN LAYERS
    # =====================================
 

   # 1. LINEAR LAYER:    m0 * input 
    blt a0, x0, exit_88
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    mv t4, s3
    mv t5, s7
    slli t1, t1, 2
    lw t1, 0(t4)
    lw t2, 4(t5)
    mul a0, t1, t2
    mv s10, a0
    mv t6, s10
    slli t3, t6, 2
    mv a0, t3
    jal malloc 
    mv s8, a0

    mv a0, s5
    mv t0, s3
    mv t2, s7
    lw t3, 0(t0)
    lw t4, 4(t0)
    mv a1, t3
    mv a2, t4
    mv a3, s9
    lw t5, 0(t2)
    lw t6, 4(t2)
    mv a4, t5
    mv a5, t6
    mv a6, s8
    jal ra, matmul


    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    mv t5, s3
    mv t6, s7
    slli t0, t0, 2
    lw t0, 0(t5)
    lw t1, 4(t6)
    mul a0, t0, t1 
    mv a0, s0
    addi a0, s8, 0 
    lw t2, 0(t5)
    lw t3, 4(t6)
    mul a1, t0, t1 
    mv a1, s1
    mv t4, s10
    addi a1, t4, 0
    jal ra, relu #sometimes use addi to make it easier too look. Got dizzied from using mv alone!

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    blt a0, x0, exit_88
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    mv t5, s4
    mv t6, s7
    lw t0, 0(t5)
    lw t1, 4(t6)
    mul a0, t0, t1 
    mv s10, a0
    mv t4, s10
    slli t3, t4, 2
    mv a0, t3
    jal malloc #allocates memory for new output
    mv s11, a0 
    mv t6, s11              # s11 points to layer 3 matrix


    addi a0, s6, 0          # a0 = pointer to start of m1
    lw t0, 0(s4)            # a1 = number of m1 rows
    lw t1, 4(s4)            # a2 = number of m1 cols
    mv t4, s3
    mv t5, s7
    mv a1, t0
    mv a2, t1
    addi a3, s8, 0          # a3 = pointer to start of layer 2
    slli t0, t0, 2
    lw t2, 0(t4)            # a4 = number of layer 2 rows = d rows = m0 rows 
    lw t3, 4(t5)            # a5 = number of layer 2 cols = d cols = input cols 
    mv a4, t2
    mv a5, t3
    addi a6, t6 , 0          
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================

    # Write output matrix
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    mv t6, s11  
    slli t0, t0, 2
    lw t0, 16(s1)   #a1[4] = *(a1 + 16)
    mv a0, t0
    mv a1, t6
    mv t4, s4
    mv t5, s7
    lw t1, 0(t4)
    lw t2, 4(t5)
    mv a2, t1
    mv a3, t2
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    
    # Call argmax
    lw t0, 0(sp)
    lw t1, 4(sp)  
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    mv t5, s4
    mv t6, s7
    slli t0, t0, 2
    lw t0, 0(t5)
    lw t1, 4(t6)
    mul a0, t0, t1 
    mv s10, a0
    slli t3, s10, 2
    mv a0, t3
    mv a0, s11
  
    lw t2, 0(t5)
    lw t3, 4(t6)
    mul a1, t2, t3 
    mv s10, a1
    slli t4, s10, 2
    mv a1, t4
    mv a1, s10
    jal ra, argmax
    mv s0, a0
    

    #print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    bne s2, zero, free_all
    mv a1, s0
    jal ra, print_int
    

    # Print newline afterwards for clarity
    li a1, '\n'
    jal ra, print_char
    
   
free_all:

    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s11
    jal free


    #epilouge
    mv a0, s0
    lw ra, 0(sp)
    lw s0, 4(sp) 
    lw s1, 8(sp) 
    lw s2, 12(sp) 
    lw s3, 16(sp) 
    lw s4, 20(sp) 
    lw s5, 24(sp) 
    lw s6, 28(sp) 
    lw s7, 32(sp) 
    lw s8, 36(sp) 
    lw s9, 40(sp) 
    lw s10, 44(sp) 
    lw s11, 48(sp) 
    addi sp, sp, 52
    ret

exit_88:
    li a1, 88
    j exit2

exit_72:
    li a1, 72
    j exit2