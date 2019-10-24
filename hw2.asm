# Homework 2: MIPS Programming Basics
# Name: Camryn Rogers

.data
a:	.word	0
b:	.word	0
c:	.word	0
out1:	.word	0
out2:	.word	0
out3:	.word	0
username:	.space		20
promptname:	.asciiz		"What is your name? "
promptint:	.asciiz		"Please enter an integer between 0-100: "
results:	.asciiz		"Your answers are: "
space:		.asciiz		" "

.text
main:
	# Prompt for name
	li	$v0, 4
	la	$a0, promptname
	syscall
	
	# Read in name
	li	$v0, 8
	la	$a0, username
	li	$a1, 20
	syscall
	
	# Prompt for integer 1
	li	$v0, 4
	la	$a0, promptint
	syscall
	
	# Read in integer 1
	li	$v0, 5
	syscall
	sw	$v0, a 
	
	# Prompt for integer 2
	li	$v0, 4
	la	$a0, promptint
	syscall
	
	# Read in integer 2
	li	$v0, 5
	syscall
	sw	$v0, b
	
	# Prompt for integer 3
	li	$v0, 4
	la	$a0, promptint
	syscall
	
	# Read in integer 3
	li	$v0, 5
	syscall
	sw	$v0, c
	
	# Calculate ans1 = 2a - b + 9
	lw	$t0, a
	lw	$t1, b
	add	$t0, $t0, $t0
	sub	$t1, $t0, $t1
	add	$t1, $t1, 9
	sw	$t1, out1
	
	# Calculate ans2 = c - b + (a - 5)
	lw	$t0, a
	lw	$t1, b
	lw	$t2, c
	sub	$t2, $t2, $t1
	sub	$t0, $t0, 5
	add	$t2, $t2, $t0
	sw	$t2, out2
	
	# Calculate ans3 = (a - 3) + (b + 4) - (c + 7)
	lw	$t0, a
	lw	$t1, b
	lw	$t2, c
	sub	$t0, $t0, 3
	add	$t1, $t1, 4
	add	$t2, $t2, 7
	add	$t0, $t0, $t1
	sub	$t0, $t0, $t2
	sw	$t0, out3
		
	# Display username and results
	li	$v0, 4
	la	$a0, username
	syscall
	
	li	$v0, 4
	la	$a0, results
	syscall
	
	li	$v0, 1
	lw	$a0, out1 
	syscall
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 1
	lw	$a0, out2
	syscall
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 1
	lw	$a0, out3
	syscall
	
exit:
	li	$v0, 10
	syscall
		
# Test 1 values: 1, 2, 3
# Expected results: 9, -3, -6

# Test 2 values: 0, 0, 2
# Expected results: 9, -3, -8
