.data
String: .space 1000
StringSize: .word  250
Msg: .asciiz "String length is: "
espai: .asciiz " "
novastring: .space 1000

.text       
.globl main 
main:   
lw $a1, StringSize
la $a0, String                    # a0 points to the string
li $v0, 8
syscall

add $t2, $a0, $zero               # t2 points to the string
add $t1, $zero, $zero             # t1 holds the count
addi $t3, $zero, 10
la $a0, espai					#mov el espai al registre a0
add $t4, $a0, $zero				#mov el espai al registre t4

LoopString: lb $t0, 0($t2)        # get a byte from string
beq $t0, $t4, mousal				#comparo amb espai
beq $t0, $zero,  EndLoopString    # zero means end of string
beq $t0, $t3, Pointer             # remove newline (linefeed)
addi $t1,$t1, 1                   # increment count

Pointer:    addi $t2,$t2, 1       # move pointer one character
        j LoopString              # go round the loop again
EndLoopString:

mousal: beq $t0, $zero,  para    # zero means end of string
		addi $t2,$t2, 1
		
para:

#la $a0, Msg                       # system call to print
#add, $v0, $zero, 4                # out a message
#syscall

add $a0, $t1, $zero               # system call to print
add, $v0, $zero, 1                # out the length worked out
syscall     

add, $v0, $zero, 10
syscall                           # good byeee :) ...