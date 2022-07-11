	.data
ms: .asciiz "Entra el teu nom: "
entrada: .space 20

	.text
	.globl main
	
main:	
		li $v0, 4       # syscall 4 (print_str)
        la $a0, ms    # argument: string
        syscall    		#print_str
		
		li $v0, 8 #string imput
		la $a0, entrada
		li $a1, 20
		syscall
		
		li $v0, 4       # syscall 4 (print_str)
        la $a0, entrada  # argument: string
        syscall    		#print_str
		
		li $v0, 10	#finalitzem el main
		syscall