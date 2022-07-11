.data
string: .asciiz "Tania"
resul: .space 1000

.text       
.globl main 
main:  
addi $s0, $zero, 4
la $a1,string
addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
lbu $a0,($a1)      # read the character
li $v0,11
syscall            # and print it