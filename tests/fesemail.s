.data

fprompt:.asciiz "Entra el teu nom: "
last:.asciiz "uda.ad"
fpromptc: .asciiz "Entra el teu cognom: "
espai: .asciiz " "
oprompt:.asciiz "Your full name is: "
first: .space 255 #255 bytes for first name
cognom:  .space 255 #255 bytes for last name
full:  .space 512 #512 bytes for full name

	.text
main:

    #Prompt for first name
    li $v0, 4
    la $a0, fprompt
    syscall

    #Enter first name
    la $a0, first
    li $a1, 255
    li $v0, 8
    syscall

    #Prompt for last name
    li $v0, 4
    la $a0, lpromptc
    syscall

    #Enter last name
    la $a0, cognom
    li $a1, 255
    li $v0, 8
    syscall

    #Display output lead-up
    li $v0, 4
    la $a0, oprompt
    syscall

    #call the strcpy function
    move $s0 $ra
    la $a0 first
    la $a1 last
    la $a2 full
	la $a3 cognom
    jal char1
    move $ra $s0

    #display the full string
    la $a0 full
    li $v0 4
    syscall

    #display a new-line
    li $a0 10
    li $v0 11
    syscall

    #exit
    jr $ra
	
	char1:
		li $t8 10 #store newline in $t8
		lb   $t0 0($a0)
        sb   $t0 0($a2)
        addi $a2 $a2 1
		
	strcpy:

  #  li $t8 10 #store newline in $t8

    #loop through first string and copy to output string
   sCopyFirst:

        lb   $t0 0($a3)
        beq  $t0 $zero sCopySecond #exit loop on null byte
        beq  $t0 $t8 sCopySecond   #exit loop on new-line
        sb   $t0 0($a2)
        addi $a3 $a3 1
        addi $a2 $a2 1
        b sCopyFirst

    

    #loop through second string and copy to output string 
    sCopySecond:

        lb   $t0 0($a1)
        beq  $t0 $zero sDone #exit on null byte
        beq  $t0 $t8 sDone   #exit on new-line
        sb   $t0 0($a2)
        addi $a1 $a1 1
        addi $a2 $a2 1
        b sCopySecond

    sDone:

        sb $zero 0($a2) #null terminate string
        jr $ra