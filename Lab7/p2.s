# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:
        if:
        bge $a0, $a1, else
        mul $t0, $a0, $a2
        add $t0, $t0, $a1
        add $v0,  $t0, 1
        jr $ra
        else:
        mul $t1, $a1, $a2
        add $t1, $t1, $a0
        addi $v0, $t1, 1
        jr      $ra

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).

        #stack
        sub $sp, $sp, 52
        sw $ra, 0($sp)
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $s4, 20($sp)
        sw $s5, 24($sp)
        sw $s6, 48($sp)
        sw $a2, 28($sp) #row
        sw $a3, 32($sp) #col
        sw $s7, 36($sp)
        sw $a1, 40($sp)
        sw $a0, 44($sp)

        #store values on s
        lw $s0, 0($a0) #int num_rows = puzzle->num_rows
        lw $s1, 4($a0) #int num_cols = puzzle->num_cols
        lw $s2, 8($a0) #int max_dots = puzzle->max_dots
        add $s3, $a0, 12 #puzzle->board
        add $s4, $a0, 268 #puzzle->doninos_used

        sub $t0, $s1, 1 #num_cols - 1
        # s5 = next_row
        bne $t0, $a3, else_row
        add $s5, $a2, 1
        j _s6_
        else_row:
        move $s5, $a2
        #s6 = next_col
        _s6_:
        add $t0, $a3, 1
        rem $s6, $t0, $s1
        #s7 = row*num_cols+col
        mul $t0, $a2, $s1
        add $s7, $t0, $a3

        #if (row >= num_rows || col >= num_cols) { return 1; }
        blt $a2, $s0, check_next_condition
                li $v0, 1
                jr $ra
        check_next_condition:
                blt $a3, $s1, skip_return
                li $v0, 1
                jr $ra
        skip_return:

        #if (solution[row * num_cols + col] != 0)
        add $t0, $a1, $s7
        lb $t1, 0($t0)
        beq $t1, 0, skip_iffffff
                move $a2, $s5
                move $a3, $s6
                jal solve
                lw $ra, 0($sp)
                lw $s0, 4($sp)
                lw $s1, 8($sp)
                lw $s2, 12($sp)
                lw $s3, 16($sp)
                lw $s4, 20($sp)
                lw $s5, 24($sp)
                lw $s6, 48($sp)
                lw $a2, 28($sp) #row
                lw $a3, 32($sp) #col
                lw $s7, 36($sp)
                lw $a1, 40($sp)
                lw $a0, 44($sp)
                add $sp, $sp, 52
                jr $ra
        skip_iffffff:


        ####### first huuuuge if #######
        #test the conditions
        sub $t0, $s0, 1 #num_rows - 1
        bge $a2, $t0, end_first_if
        add $t0, $s7, $s1 # t0 = (row + 1) * num_cols + col
        add $t1, $t0, $a1
        lb $t1, 0($t1)
        bne $t1, 0, end_first_if
                # domino_code
                add $t1, $s3, $s7 #curr_dots address
                lb $a0, 0($t1) #curr dots
                add $t1, $t0, $s3 #board[(row + 1) * num_cols + col] address
                lb $a1, 0($t1) #board[(row + 1) * num_cols + col]
                move $a2, $s2
                jal encode_domino
                move $t1, $v0 #t1 = domino_code
                #if(dominos_used[domino_code] == 0
                add $t2, $s4, $t1
                lb $t3, 0($t2)
                bne $t3, 0, end_dominos_used_if
                        li $t3, 1
                        sb $t3, 0($t2) #dominos_used[domino_code] = 1
                        lw $a1, 40($sp)
                        add $t4, $a1, $s7 #slution[row*num_cols+col] address
                        sb $t1, 0($t4) #solution[row * num_cols + col] = domino_code
                        lw $a2, 28($sp) #row
                        add $t0, $s7, $s1 # t0 = (row + 1) * num_cols + col
                        add $t2, $a1, $t0 #address
                        sb $t1, 0($t2)
                        #recursive call
                        lw $a0, 44($sp)
                        lw $a1, 40($sp)
                        move $a2, $s5
                        move $a3, $s6
                        jal solve
                        bne $v0, 1, skip_recursive_call
                                li $v0, 1
                                lw $ra, 0($sp)
                                lw $s0, 4($sp)
                                lw $s1, 8($sp)
                                lw $s2, 12($sp)
                                lw $s3, 16($sp)
                                lw $s4, 20($sp)
                                lw $s5, 24($sp)
                                lw $s6, 48($sp)
                                lw $a2, 28($sp) #row
                                lw $a3, 32($sp) #col
                                lw $s7, 36($sp)
                                lw $a1, 40($sp)
                                lw $a0, 44($sp)
                                add $sp, $sp, 52
                                jr $ra
                        skip_recursive_call:
                        # domino_code
                        add $t1, $s3, $s7 #curr_dots address
                        lb $a0, 0($t1) #curr dots
                        add $t0, $s7, $s1
                        add $t1, $t0, $s3 #board[(row + 1) * num_cols + col] address
                        lb $a1, 0($t1) #board[(row + 1) * num_cols + col]
                        move $a2, $s2 #max_dots
                        jal encode_domino
                        move $t1, $v0 #t1 = domino_code
                        add $t2, $s4, $t1 #dominos_used[domino_code] adress
                        li $t3, 0
                        sb $t3, 0($t2)
                        lw $a1, 40($sp)
                        add $t2, $a1, $s7
                        sb $t3, 0($t2)
                        lw $a2, 28($sp)
                        add $t4, $s7, $s1
                        add $t4, $a1, $t4
                        sb $t3, 0($t4)
                end_dominos_used_if:
        end_first_if:

        ##### second huge if #####
        #test the condition
        lw $a1, 40($sp)
        lw $a0, 44($sp)
        lw $a2, 28($sp) #row
        lw $a3, 32($sp)
        sub $t0, $s1, 1 #num_col - 1
        bge $a3, $t0, end_second_if
        add $t0, $s7, 1 #t0 = row*num_cols+col+1
        add $t2, $a1, $t0
        lb $t2, 0($t2)
        bne $t2, 0, end_second_if
                #domino code
                add $t1, $s3, $s7 #curr_dots address
                lb $t7, 0($t1) #curr dots
                move $a0, $t7
                add $t1, $t0, $s3 #board[row * num_cols + col + 1] address
                lb $a1, 0($t1) #board[row * num_cols + col + 1]
                move $a2, $s2
                jal encode_domino
                move $t1, $v0 #t1 = domino_code
                #if(dominos_used[domino_code] == 0
                add $t2, $s4, $t1
                lb $t3, 0($t2)
                bne $t3, 0, end_dominos_used_second_if
                        li $t3, 1
                        sb $t3, 0($t2) #dominos_used[domino_code] = 1
                        lw $a1, 40($sp)
                        add $t4, $a1, $s7 #slution[row*num_cols+col] address
                        sb $t1, 0($t4) #solution[row * num_cols + col] = domino_code
                        add $t4, $s7, 1
                        add $t4, $t4, $a1
                        sb $t1, 0($t4)
                        #recursive call
                        lw $a0, 44($sp)
                        lw $a1, 40($sp)
                        move $a2, $s5
                        move $a3, $s6
                        jal solve
                        bne $v0, 1, skip_second_recursive_call
                                li $v0, 1
                                lw $ra, 0($sp)
                                lw $s0, 4($sp)
                                lw $s1, 8($sp)
                                lw $s2, 12($sp)
                                lw $s3, 16($sp)
                                lw $s4, 20($sp)
                                lw $s5, 24($sp)
                                lw $s6, 48($sp)
                                lw $a2, 28($sp) #row
                                lw $a3, 32($sp) #col
                                lw $s7, 36($sp)
                                lw $a1, 40($sp)
                                lw $a0, 44($sp)
                                add $sp, $sp, 52
                                jr $ra
                        skip_second_recursive_call:
                        #domino code
                        add $t1, $s3, $s7 #curr_dots address
                        lb $a0, 0($t1) #curr dots
                        add $t0, $s7, 1
                        add $t1, $t0, $s3 #board[row * num_cols + col + 1] address
                        lb $a1, 0($t1) #board[row * num_cols + col + 1]
                        move $a2, $s2
                        jal encode_domino
                        move $t1, $v0 #t1 = domino_code
                        add $t2, $s4, $t1 #dominos_used[domino_code] adress
                        li $t3, 0
                        sb $t3, 0($t2)
                        lw $a1, 40($sp)
                        add $t2, $a1, $s7
                        sb $t3, 0($t2)
                        add $t4, $s7, 1
                        add $t4, $a1, $t4
                        sb $t3, 0($t4)
                        end_dominos_used_second_if:
        end_second_if:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        lw $s6, 48($sp)
        lw $a2, 28($sp) #row
        lw $a3, 32($sp) #col
        lw $s7, 36($sp)
        lw $a1, 40($sp)
        lw $a0, 44($sp)
        add $sp, $sp, 52
        li $v0, 0
        jr      $ra