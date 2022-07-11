.data

fprompt:.asciiz "Please enter your first name: "
lprompt:.asciiz "Please enter your last name: "
oprompt:.asciiz "Your full name is: "
first: .space 255 #255 bytes for first name
last:  .space 255 #255 bytes for last name
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
    la $a0, lprompt
    syscall

    #Enter last name
    la $a0, last
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
    jal strcpy
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
	
	strcpy:

    li $t8 10 #store newline in $t8

    #loop through first string and copy to output string
   sCopyFirst:

        lb   $t0 0($a0)
        beq  $t0 $zero sCopySpace #exit loop on null byte
        beq  $t0 $t8 sCopySpace   #exit loop on new-line
        sb   $t0 0($a2)
        addi $a0 $a0 1
        addi $a2 $a2 1
        b sCopyFirst

    sCopySpace:

        li   $t0 ' '
        sb   $t0 0($a2)
        addi $a2 $a2 1 

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