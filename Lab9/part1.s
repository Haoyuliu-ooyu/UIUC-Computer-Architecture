.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000      
TIMER_ACK               = 0xffff006c 

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

PICKUP                  = 0xffff00f4

### Puzzle
GRIDSIZE = 8
has_puzzle:        .word 0                         
puzzle:      .half 0:2000             
heap:        .half 0:2000
#### Puzzle



.text
main:
# Construct interrupt mask
	    li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	    mtc0    $t4, $12

#Fill in your code here
        li $t0, 1
        sw $t0, 0xffff0010($zero)

        li $t0, 45
        sw $t0, 0xffff0014($zero)

        li $t0, 1
        sw $t0, 0xffff0018($zero)

        
        
        loop:
        lw $t1, 0xffff0020($zero) #
        lw $t2, 0xffff0024($zero) #y
        li $t0, 1
        sw $t0, 0xffff00f4($zero)
        
            s_1:
            bne $t1, 92, s_2
            bne $t2, 92, s_2
            li $t0, 90
            sw $t0, 0xffff0014($zero)
            li $t0, 1
                sw $t0, 0xffff0018($zero)
            
            s_2:
            bne $t1, 92, s_3
            bne $t2, 116, s_3
            li $t0, 45
            sw $t0, 0xffff0014($zero)
            li $t0, 1
                sw $t0, 0xffff0018($zero)

            s_3:
            bne $t1, 140, s_4
            bne $t2, 164, s_4
            li $t0, 90
            sw $t0, 0xffff0014($zero)
            li $t0, 1
                sw $t0, 0xffff0018($zero)

        s_4:
        bne $t1, 140, s_5
        bne $t2, 188, s_5
        li $t0, 0
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_5:
        bne $t1, 180, s_6
        bne $t2, 188, s_6
        li $t0, 90
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_6:
        bne $t1, 180, s_7
        bne $t2, 228, s_7
        li $t0, 0
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_7:
        bne $t1, 236, s_8
        bne $t2, 228, s_8
        #bne $t3, 0, s_8
        li $t0, 45
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)


        s_8:
        bne $t1, 284, s_9
        bne $t2, 276, s_9
        li $t0, 225
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)
        li $t3, 1
        

        s_9:
        bne $t1, 236, s_10
        bne $t2, 228, s_10
        bne $t3, 1, s_10
        li $t0, 0
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_10:
        bne $t1, 244, s_11
        bne $t2, 228, s_11
        li $t0, 270
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)


        s_11:
        bne $t1, 244, s_12
        bne $t2, 212, s_12
        li $t0, 225
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_12:
        bne $t1, 236, s_13
        bne $t2, 84, s_13
        li $t0, 270
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_13:
        bne $t1, 180, s_14
        bne $t2, 148, s_14
        li $t0, 315
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_14:
        bne $t1, 236, s_15
        bne $t2, 92, s_15
        li $t0, 270
        sw $t0, 0xffff0014($zero)
        li $t0, 1
        sw $t0, 0xffff0018($zero)

        s_15:
        j loop
infinite:
        j       infinite              # Don't remove this! If this is removed, then your code will not be graded!!!

.kdata
chunkIH:    .space 8  #TODO: Decrease this
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        j   interrupt_dispatch
non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
