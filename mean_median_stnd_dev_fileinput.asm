# Homework 6: MIPS FP Operations
# Name: Camryn Rogers

.data
fin:			.asciiz		"input.txt"
byteErrorMessage:	.asciiz		"There were less than or equal to zero bytes read. Now exiting."
arrayBefore:		.asciiz		"The array before: "
arrayAfter:		.asciiz		"The array after: "
mean:			.asciiz		"The mean is: "
median:			.asciiz		"The median is: "
sdMessage:		.asciiz		"The standard deviation is: "
space:			.asciiz		" "
newline:		.asciiz		"\n"
sdValue:		.double		0.0
buffer:			.space		80
numBytes:		.word		0
array:			.word		20

.text
main:
	
	# Set $a0 equal to the address of the filename
	# and $a1 to the address of the buffer where data is stored
	la	$a0, fin
	la	$a1, buffer
	
	# Call numBytesRead
	jal numBytesRead
	
	# If numBytes<=0, error message and exit, else set equal to numBytes
	blez $v0, byteError  
	sw $v0, numBytes
	
	# Call string to int after setting a0 and a1
	la $a0, array
	li $a1, 20
	la $a2, buffer
	jal stringToInt
	move $s0, $a0
	
	# Print before array message and the array as is
	li $v0, 4
	la $a0, arrayBefore
	syscall
	
	# a0 still has beginnig of array
	move $a0, $s0
	jal printArray
	
	# Print after array message and the array as is
	li $v0, 4
	la $a0, arrayAfter
	syscall
	
	# a0 still has beginning of array
	move $a0, $s0
	jal printArray
	
	# Print mean message
	li $v0, 4
	la $a0, mean
	syscall
	
	# Calculate mean
	move $a0, $s0
	li $a1, 20
	jal calcMean
	
	# Print mean and new line
	li $v0, 2
	add.s $f12, $f12, $f0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	
	
	# Print standard deviation message
	li $v0, 4
	la $a0, sdMessage
	syscall
	
	# Calculate standard deviation
	move $a0, $s0
	li $a1, 20
	jal calcSD
	
	# Save and print standard deviation and new line
	li $v0, 2
	swc1 $f1, sdValue
	mov.s $f12, $f1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	j exit
numBytesRead:

	# Move a registers to s registers 
	move $s0, $a0
	move $s1, $a1
	
	# Open file with no flags for reading, move file descriptor to s2
	li $v0, 13
	move $a0, $s0
	li $a1, 0
	li $a2, 0
	syscall
	move $s2, $v0
	
	# Make a0 the file descriptor, read 80 char from file and put in buffer
	move $a0, $s2
	li $v0, 14
	move $a1, $s1
	li $a2, 80
	syscall
	
	# Close file
	li $v0, 16
	syscall
	
	# return to main
	move $v0, $s2
	jr $ra
	
byteError:

	# Print error message and exit
	li	$v0, 4
	la	$a0, byteErrorMessage
	syscall
	
	j exit
	
stringToInt:

	move $s0, $a0	# s0= array
	move $s1, $a1	# s1 = 20
	move $s2, $a2	# s2 = buffer
	li $s3, 0	# sum = s3 = 0

loop1:	lb $t1, ($s2)		# load byte from buffer in t1 	
	beq $t1, 0, end		# if it's 0, end of data reached
	j loop2
		
loop2:	beq $t1, 10, save	# if the byte is a newline, save
	blt $t1, 48, ignore	# if less than 48, ignore
	bgt $t1, 57, ignore	# if greater than 57, ignore
	sub $t1, $t1, 48		# subtract 48
	mul $s3, $s3, 10	# multiply sum by 10
	add $s3, $s3, $t1	# add converted ascii to sum
	addi $s2, $s2, 1	# add one to the buffer
	j loop1			# get next byte

ignore: addi $s2, $s2, 1	# add one to the buffer
	j loop1			# jump to loop 1 to get next byte
	
save:	sw $s3, ($s0)		# store int in array 
	addi $s0, $s0, 4	# add 4 to array to get to next word
	addi $s2, $s2, 1	# add one to the buffer
	li $s3, 0		# set sum back to zero
	j loop1			# get next byte from loop 1
	
end:	jr $ra			# go back to main

printArray:

	move $s0, $a0		# s0 = beg of array
	li $t0, 0		# counter = t0 = 0
	j printloop
	
printloop:
	beq $t0, 20, endprint	# loop 20 times
	li $v0, 1		# print integer in array
	lw $a0, ($s0)		# load it up
	syscall			# call ittt
	li $v0, 4		# print space
	la $a0, space		
	syscall
	addi $s0, $s0, 4	# go to next element
	addi $t0, $t0, 1	# increment counter
	j printloop

endprint:
	sub $s0, $s0, 80	# go back to beginning of array
	li $v0, 4		# newline
	la $a0, newline
	syscall
	jr $ra
	
calcMean:
	move $s0, $a0		# s0 = beg of array
	move $s1, $a1		# s1 = size of array
	li $t0, 0		# counter = t0 = 0
	li $t1, 0		# sum = t1 = 0
	j meanloop
	
meanloop:
	beq $t0, 20, endmean	# loop 20 times
	lw $t2, ($s0)		# t2 = element
	add $t1, $t1,$t2	# add element to sum
	addi $s0, $s0, 4	# go to next element
	addi $t0, $t0, 1	# increment counter
	j meanloop

endmean:
	sub $s0, $s0, 80	# go back to beginning of array
	mtc1 $t1, $f1		# move to float
	mtc1 $s1, $f2		# move to float
	div.s $f0, $f1, $f2	# mean, single precision
	jr $ra
	
calcSD:
	move $s0, $a0		# s0 = beg of array
	move $s1, $a1		# s1 = size of array
	li $t0, 0		# counter = t0 = 0
	li $t1, 0		# sum = t1 = 0
	li $t3, 1		# one
	mtc1 $t3, $f5		# one but in f5
	cvt.s.w $f5, $f5	# convert
	mtc1 $t1, $f1		# move sum to float
	cvt.s.w $f1, $f1	# convert
	mtc1 $s1, $f2		# move n to float
	cvt.s.w $f2, $f2	# convert
	j SDloop
	
SDloop:
	beq $t0, 20, endSD	# loop 20 times
	lw $t2, ($s0)		# t2 = element
	mtc1 $t2, $f3		# t2 is now f3
	cvt.s.w $f3, $f3	# convert
	sub.s $f3, $f3, $f0	# element = element - average
	mul.s $f3, $f3, $f3	# element = element^2
	add.s $f1, $f1, $f3	# sum = sum + element
	addi $s0, $s0, 4	# go to next element
	addi $t0, $t0, 1	# increment counter
	j SDloop

endSD:
	sub $s0, $s0, 80	# go back to beginning of array
	sub.s $f2, $f2, $f5	# n-1
	div.s $f1, $f1, $f2	# sum = sum/(n-1)
	sqrt.s $f1, $f1		# sum = sqrt(sum), f1 = s.d.
	jr $ra

exit:	
	 li $v0, 10
	 syscall
