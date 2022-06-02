.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -40
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

    mv s0, a0
    mv s1, a1
    mv s2, a2

    ####################################################################
    ####################################################################
file_reading_starts:
    #fopen
	mv a1, s0
    li a2, 0
	jal ra, fopen

	#fopen error
	li t0, 0
	blt a0, t0, exit_89
    ####################################################################
    ####################################################################

    ####################################################################
    ####################################################################
	#fread
	mv s3, a0   #file pointer
    mv a1, s3
    mv a2, s1
    li a3, 4
	jal fread #read row numbers

	li t0, 4
	bne a0, t0, exit_91

	mv a1, s3
    mv a2, s2
	li a3, 4
	jal fread #read column numbers

	li t1, 4
	bne a0, t1, exit_91
    ####################################################################
    ####################################################################

    #allocate space for matrix
    mv s7, s1
    mv s8, s2
	lw t2, 0(s7)
	lw t3, 0(s8)
    mul s5, t2, t3  # row * col
    slli s5, s5, 2  # of bytes
    mv a0, s5
    mv  s6, a0 
    jal malloc  # jump to malloc 
    beq a0, zero, exit_88 # if a0 == zero exit malloc fail

    ####################################################################
    ####################################################################


	mv s4, a0
	mv a1, s3
	mv a2, s4
    mv s7, s1
    mv s8, s2
	lw t3, 0(s7)
	lw t4, 0(s8)
	mul a3, t3, t4
	li t3, 4

	mul a3, a3, t3
	jal fread
    li t2, 1
    beq s6, t2, file_reading_ends
	bne a0, s6, exit_91
	j file_reading_ends
	#arguments to fclose

file_reading_ends:
    li t2, 0
    blt s4, t2, file_reading_starts
	mv a1, s3
	jal fclose

	li t0, -1
	beq t0, a0, exit_90
    mv a0, s4


    # Epilogue
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
    addi sp, sp, 40
    ret

exit_88:
	li a1 88
	jal exit2

exit_89:
	li a1 89
	jal exit2

exit_90:
	li a1 90
	jal exit2


exit_91:
	li a1 91
	jal exit2

