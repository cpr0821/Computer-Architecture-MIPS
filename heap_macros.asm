# HW 08 

.include	"macro_file.asm"

.data
heap_pointer:		.word	0
file_name:		.ascii  ""
newline:		.ascii  "\n"
file_descriptor:	.word	0
string:			.ascii	""
input_buffer:		.byte	1024
.text
main:
	# Allocate heap memory
	allocate_heap_memory(heap_pointer)
	
	
	# Loop while filename is not "" 
Loop:	get_string(file_name)
	remove_newline(file_name)
	j Loop
	# If the file name is <enter>, exit
	la $t0, file_name
	lb $t1, ($t0)
	la $t2, newline
	lb $t3, ($t2)
	beq $t1, $t3, exit
	
	# Otherwise open file and get file descriptor, read file into buffer, close file
	open_file(file_name, file_descriptor)
	read_file(file_descriptor, input_buffer)
	close_file(file_descriptor)
	
	
	# Output original data
	la $t0, input_buffer
Output_loop:
	lb $t1, ($t0)		# load byte from buffer in t1 	
	beq $t1, 0, end		# if it's 0, end of data reached
	j Output_loop2
Output_loop2:
	#la $t2, string
	
	sb $t1, string
	print_string(string)
	addi $t0, $t0, 1
	j Output_loop
end:	#end of loop
	
exit:
	li $v0, 10
	syscall
	
