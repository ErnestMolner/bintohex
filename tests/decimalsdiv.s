.globl main
.text
main:
addi $t0, $zero, 4
addi $t1, $zero ,4
li $t4, 4
div $t0, $t1
mflo $s0
mfhi $s1
sub $t4, $t4, $s1
add $a0, $zero, $t4
li $v0, 1
syscall