# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr.s

.data
# your test data goes here
array:	.word	1	255	1024	0xcafebabe	target

.text
main:
	# your test code goes here

	# test operations from lab 4
	li   $10, 7				# $10 = 7 
	li   $11, 3				# $11 = 3
	add  $12, $11, $10		# $12 = 10
	sub  $13, $11, $10      # $13 = -4
	and  $14, $11, $10		# $14 = 3
	and  $19, $11, $0		# $19 = 0
	or   $15, $12, $10      # $15 = 15
	nor  $16, $12, $10      # $16 = 0xfffffff0
	xor  $17, $12, $10      # $17 = 13
	andi $2,  $12, 1        # $2 = 0
	ori  $3 , $12, 2        # $3 = 10
	xori $18, $16, 0xf		# 18 = 0xffffffff

	# test edge case for slt
	li  $4, 0x80000000      
	li  $5, 1
	slt $6, $4, $5          # $6 = 1
	li  $7, 0xc0000000
	li  $8, 0x40000000
	slt $9, $8, $7          # $9 = 0

	# test sb then lb
	la	$21, array	 # $21  = 0x10010000	testing lui
	sb  $17, 0($21)
	lbu $20, 0($21)  # $20 = 13

	# test addm
	addm $22, $21, $10   # $22 = 20
