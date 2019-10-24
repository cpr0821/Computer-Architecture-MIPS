# Macros file

# Print int
.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
.end_macro

# Print char
.macro print_char (%c)
	.data
macro_char:	.byte 	%c
	.text
	li $v0, 4
	la $a0, macro_char
	syscall
.end_macro

# Print string
.macro print_string (%string)
	.text
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

# Get string from user
.macro get_string (%filename)
	.data
message:	.asciiz	"Please enter the filename to compress or <enter> to exit: "
	.text
	li $v0, 4
	la $a0, message
	syscall
	
	li $v0, 8
	la $a0, %filename
	li $a1, 100
	syscall
.end_macro
	
# Open file
.macro open_file (%file, %file_d)
	.data
error_mess:	.asciiz	"Error opening file. Program terminating."
	.text
	li $v0, 13
	la $a0, %file 
	li $a1, 0
	li $a2, 0
	syscall
	
	beq $v0, -1, error
	sw $v0, %file_d
error:
	li $v0, 4
	la $a0, error_mess
	syscall
	
	li $v0, 10
	syscall
.end_macro

# Close file
.macro close_file (%filedescriptor)
	li $v0, 16
	la $a0, %filedescriptor
	syscall
.end_macro

# Read file
.macro read_file (%filedescriptor, %buffer)
	li $v0, 14
	la $a0, %filedescriptor
	la $a1, %buffer
	li $a2, 1024
	syscall
.end_macro

# Allocate heap memory
.macro allocate_heap_memory (%pointer)
	li $v0, 9
	li $a0, 1024
	syscall
	
	sw $v0, %pointer
.end_macro

# Remove newline
.macro remove_newline(%filename)
	.text
remove:	
	li $s0,0        	# Set index to 0
    	lb $t1, %filename($s0)        # Load character at index
    	addi $s0,$s0,1      	# Increment index
    	bnez $t1,remove    	# Loop until the end of string is reached
    	subi $s0,$s0,2     	# If above not true, Backtrack index to '\n'
    	sb $0, %filename($s0)   # Add the terminating character in its place
.end_macro