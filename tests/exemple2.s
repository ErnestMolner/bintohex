.data 
input:          .space 201
string2:    .asciiz "they're equal.\n"
finish:         .byte '#'
.text
main:
        la $a0,input
        li $a1,201          #read 200 char 
        li $v0,8            #read string
        syscall 

        jal evaluate

evaluate:

        lw $t1, 0($a0)
        lw $t2,finish
        bne $t1,$t2,test1

        la $a0,string2
        li $v0,4
        syscall

test1:
        li $v0, 10
        syscall