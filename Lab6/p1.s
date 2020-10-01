# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:
    li $t0, 0
    move $t1, $a0
    for:
        bge $t0, 6, end_for
        srl $t1, $t1, 3
        li $t4, 3
        div $t0, $t4
        mfhi $t5
        bne $t5, 0, else
        mul $t2, $t0, 4
        add $t2, $t2, $a1
        li $t6, 31
        and $t3, $t1, $t6
        sw $t3, 0($t2)
        add $t0, $t0, 1
        j for
        else:
            mul $t2, $t0, 4
            add $t2, $t2, $a1
            li $t6, 255
            and $t3, $t1, $t6
            sw $t3, 0($t2)
            add $t0, $t0, 1
            j for
    end_for:         
    jr      $ra
