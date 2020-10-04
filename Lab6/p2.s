# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
    sub $sp, $sp, 24
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)
    li $s0, 0 #i = 0
    for_1:
        sub $t0, $a1, 1
        bge $s0, $t0, end_for1
        move $s2, $s0 #min_idx = i
        add $s1, $s0, 1 #j=i+1
        for_2:
            bge $s1, $a1 end_for2 
            mul $t1, $s1, 4
            add $t1, $t1, $a0
            lw $t3, 0($t1)
            mul $t2, $s2, 4
            add $t2, $t2, $a0
            lw $a1, 0($t2)
            move $a0, $t3
            jal compare
            lw $a0, 4($sp)
            lw $a1, 8($sp)
            bne $v0, 1, end_if
            move $s2, $s1
            end_if:
            addi $s1, 1
            j for_2
        end_for2:
        beq $s2, $s0, end_if__
        mul $t0, $s0, 4
        add $t0, $t0, $a0 
        lw $t1, 0($t0) #temp = array[i]
        mul $t2, $s2, 4
        add $t2, $t2, $a0
        lw $t3, 0($t2) #array[min_idx]
        sw $t3, 0($t0) #array[i] = array[min_idx]
        sw $t1, 0($t2) #array[min_idx] = temp
        end_if__:
        addi $s0, 1
        j for_1
    end_for1:
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    lw $s2, 20($sp)
    add $sp, $sp, 24
    jr      $ra



# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) {
#       char orig = map[i][j].repr;
#
#       if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#       if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#       if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#       if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#       if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }

#       if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:
    sub $sp, $sp, 32
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 28($sp)
    sw $ra, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    sw $s2, 20($sp)
    sb $s3, 24($sp)
    li $s0, 0 #i=0
    li $s2, 0 #numchanged
    for1:
        bge $s0, 15, end_for_1
        li $s1, 0 #j=0
        for2:
            bge $s1, 15, end_for_2
            mul $a2, $s0, 15
            add $a2, $a2, $s1
            mul $a2, $a2, 12
            add $a2, $a2, $a0 #map[i][j]
            lbu $s3, 0($a2)
            lw $a0, 4($a2) #x
            lw $a1, 8($a2) #y
            jal fst
            jal scd
            jal thrd
            jal four
            jal fif
            lw $a0, 0($sp)
            lbu $t4, 0($a2)
            beq $s3, $t4, end_if________
            addi $s2, 1
            end_if________:
            addi $s1, 1
            j for2
        end_for_2:
        addi $s0, 1
        j for1
    end_for_1:
    move $v0, $s2
    lw $a0, 0($sp)
    lw $a1, 4($sp)
    lw $a2, 28($sp)
    lw $ra, 8($sp)
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    lw $s2, 20($sp)
    lbu $s3, 24($sp)
    add $sp, $sp, 32
    jr      $ra


.globl fst
fst:
    bne $a0, 0, end_fst
    bne $a1, 0, end_fst
    li $t0, '.'
    sb $t0, 0($a2)
    end_fst:
        jr $ra

.globl scd
scd:
    beq $a0, 0 , end_scd
    bne $a1, 0, end_scd
    li $t0, '_'
    sb $t0, 0($a2)
    end_scd:
        jr $ra

.globl thrd
thrd:
    bne $a0, 0, end_thrd
    beq $a1, 0, end_thrd
    li $t0, '|'
    sb $t0, 0($a2)
    end_thrd:
        jr $ra

.globl four
four:
     mul $t1, $a0, $a1
     ble $t1, 0, end_four
     li $t0, '/'
     sb $t0, 0($a2)
     end_four:
        jr $ra

.globl fif
fif:
    mul $t1, $a0, $a1
    bge $t1, 0, end_fif
    li $t0, '\\'
    sb $t0, 0($a2)
    end_fif:
        jr $ra
