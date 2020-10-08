# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         
#     op_sub,         
#     op_mul,         
#     op_div,         
#     op_rem,         
#     op_neg,         
#     op_paren,
#     constant
# } node_type_t;

# typedef struct {
#     node_type_t type;
#     bool computed;
#     int value;
#     ast_node* left;
#     ast_node* right;
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:
        bne $a0, 0, passed_check_null
        li $v0, 0
        jr $ra
        passed_check_null:

        lbu $t0, 4($a0)
        beq $t0, 0, passed_edge_case
        lw $v0, 8($a0)
        jr $ra
        passed_edge_case:
        sub $sp, $sp, 12
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $s0, 8($sp)
        lw $t0, 12($a0) #left node
        move $a0, $t0
        jal value
        move $s0, $v0
        lw $a0, 4($sp)
        lw $t1, 16($a0) #right node
        move $a0, $t1
        jal value
        move $t1, $v0
        move $t0, $s0
        lw $a0, 4($sp)
        
        lw $t2, 0($a0) #type
        switch:
                bne $t2, 7, not_constant
                lw $v0, 8($a0)
                jr $ra
        not_constant:
                bne $t2, 0, not_add
                add $t4, $t0, $t1
                sw $t4, 8($a0)
                j end_switch
        not_add:
                bne $t2, 1, not_sub
                sub $t4, $t0, $t1
                sw $t4, 8($a0)
                j end_switch
        not_sub:
                bne $t2, 2, not_mul
                mul $t4, $t0, $t1
                sw $t4, 8($a0)
                j end_switch
        not_mul:
                bne $t2, 3, not_div
                div $t4, $t0, $t1
                sw $t4, 8($a0)
                j end_switch
        not_div:
                bne $t2, 4, not_rem
                rem $t4, $t0, $t1
                sw $t4, 8($a0)
                j end_switch
        not_rem:
                bne $t2, 5, not_neg
                mul $t4, $t0, -1
                sw $t4, 8($a0)
                j end_switch
        not_neg:
                bne $t2, 6, end_switch
                sw $t0, 8($a0)
                j end_switch 
        end_switch:
                li $t5, 1
                sb $t5, 4($a0)
                lw $v0, 8($a0)
        lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $s0, 8($sp)
        add $sp, $sp, 12
        jr      $ra
