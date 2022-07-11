.data
	myArray: .space 30
.text
main:
	li $t2, 12
	li $t3, 0
	li $t0, 0
loop:
	addi $s0, $zero, 2
	sw $s0, myArray($t0)
	beq $t0, $t2, surt
	addi $t0, $t0, 4
	#index
	b loop
surt:
	lw $t6, myArray($t3)
	addi $a0, $t6, 0
	li $v0, 1
	syscall 
	

	