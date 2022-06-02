.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    ####################################################################
    ####################################################################
file_writing_starts:
    #fopen
    mv  a1, s0 
    li a2, 1 
    jal fopen  
    li t0, 0 
    blt a0, t0, exit_89 
    mv  s4, a0 
    ####################################################################
    ####################################################################

    ####################################################################
    ####################################################################
	#write_matrix
    li a0, 20
    jal malloc
    mv a4, a0
    mv s5, a4
    sw s2, 0(s5)
    sw s3, 4(s5)
    mv a1, s4
    mv a2, a0
    li a3, 2
    li a4, 4
    jal fwrite
    li t2, 1
    blt a0, t2, exit_92
    
    # write row/col 
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul t2, s2, s3
    mv s6, t2
    bne a0, s6, exit_92
    li t3, 0
    blt s6, t3, file_writing_starts

file_writing_ends:
    li t3, 0
    blt s4, t3, file_writing_starts
    mv a1, s4
    jal fclose
    blt a0, zero, exit_90 
    

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    ret


exit_89:
	li a1 89
	jal exit2

exit_90:
	li a1 90
	jal exit2

exit_92:
	li a1 92
	jal exit2

