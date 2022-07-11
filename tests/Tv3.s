	.data
msg: .asciiz "Enter your firs float: "
msg2: .asciiz "Enter second float: "
entrada: .space 20

	
	.text
	.globl main

main:	li $v0, 4       # syscall 4 (print_str)
        la $a0, msg     # argument: string
        syscall    		#print_str
		
		li $v0, 6 #read float
		syscall	
		
		mov.s $f4, $f0 #faig un mov al registre f4
		syscall
		
	
		
		li $v0, 4       # syscall 4 (print_str)
        la $a0, msg2   # argument: string
        syscall 
		
		li $v0, 6 #read float
		syscall
		
		
		li $v0, 2 #display float
		add.s $f12 , $f0, $f4	#els sumo i els ensenyem
		syscall
		
		#li $v0, 8 #string imput
		#la $a0, entrada
		#li $a1, 20
		#syscall
		
		#li $v0, 4       # syscall 4 (print_str)
        #la $a0, entrada  # argument: string
        #syscall    		#print_str
		
		li $v0, 10	#finalitzem el main
		syscall
		
