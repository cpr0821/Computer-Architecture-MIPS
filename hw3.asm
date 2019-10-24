# Homework 3: MIPS Programming Basics
# Name: Camryn Rogers

.data
prompt:		.asciiz		"Please enter some text."
stringaddress:	.space		100
length:		.word		100
charCount:	.word		0
charMessage:	.asciiz		" characters \n"
wordCount:	.word		0
wordMessage:	.asciiz		" words "
exitMessage:	.asciiz		"Message: "
goodbye:	.asciiz		"Good bye!"

.text
main:
	loop:
	# Prompt for some text
	li	$v0, 54
	la	$a0, prompt
	la 	$a1, stringaddress
	lw	$a2, length
	syscall
	
	# if cancel or blank input, break loop
	beq $a1, -2, exit
	beq $a1, -3, exit
	
	# Store string address in $a0  and length into $a1 and call function
	la $a0, stringaddress
	lw $a1, length
	jal counter
	
	# Store counts in memory
	sw $v0, charCount
	sw $v1, wordCount
	
	 # Display counts and input
	 la $a0, stringaddress
	 li $v0, 4
	 syscall
	 
	 lw $a0, wordCount
	 li $v0, 1
	 syscall
	 
	 la $a0, wordMessage
	 li $v0, 4
	 syscall
	 
	 lw $a0, charCount
	 li $v0, 1
	 syscall
	 
	 la $a0, charMessage
	 li $v0, 4
	 syscall
	 
	 # Go back to the top
	 j loop  
	 
	 # Exit message
	 exit:
	 li $v0, 59
	 la $a0, exitMessage
	 la $a1, goodbye
	 syscall
	 
	 li $v0, 10
	 syscall
	
	# Function to count number of characters and number of words  
counter:
	# Push $s0 on to stack
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	move $s1, $a0
	
	li $t0, -1 		# initialize character count to -1 (I kept getting one extra for charCount)
	li $t1, 1		# initailize word count to 1
	
	loop2:	
	lb $t2,($s1)		# loads the next character into t1
	beq $t2, '\0', exit2	# if the character is null, exit loop
	addi $t0, $t0, 1	# increment the character counter by 1
	beq $t2, ' ', space	# if the character is a space, go to word
	j nextChar
	
	space:
	addi $t1, $t1, 1	# if it's a space, add 1 to space counter
	j nextChar	
	
	nextChar:
	addi $s1, $s1, 1	# increment string pointer by 1
	j loop2			# return to the top of the loop
	
	exit2:
	# Pop $s0 back from stack
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	
	# Return character and word count in $v0 and $v1 respectively
	move $v0, $t0
	move $v1, $t1
	
	jr $ra 
