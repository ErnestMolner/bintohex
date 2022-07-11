	

.data
    message: .asciiz "Enter your binary number: "
    numbin: .space 255 #255 bytes nom
    quatri: .space 255 #255 dyte 
    hexai: .space 255
.text

main:
    li $v0, 4
    la $a0, message
    syscall

    la $a0, numbin
    li $a1, 255
    li $v0, 8
    syscall

    li $t1,0
    la $t0,numbin
    li $t3,1
    li $t4,4
    li $t7, 48
    li $t5, 0
    li $t6, 2
    li $s3, 3
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0
    li $t2, 0
    
    
loop:
    lb   $a0,0($t0)
    beqz $a0,done
    addi $t0,$t0,1
    addi $t1,$t1,1
    j     loop
done:
    sub $t1, $t1, $t3 #per tenir el numero de caracters entrats
    add $t2, $t1, $zero #fem aquesta suma per desplazar el valor al registre t2
    #fem una divisio per trovar quants zeros tenim a devant al primer paquet
    div $t2, $t4
    mfhi $s1
    sub $t5, $t4, $s1
    li $t1,0
    beq $t5, 1, unze
    beq $t5, 2, dosze
    beq $t5, 3, treze
    beq $t5, 4, reto
    
reto:
    li $t5, 0
seg:
    beq $t5, 4, reto
    beq $t2, $t1, fi
    add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #test temporal
    addi $t1, $t1, 1
    addi $t5, $t5, 1
    beq $t5, 1, muli1
    beq $t5, 2, muli2
    beq $t5, 3, muli3
    beq $t5, 4, muli4
    b seg
    
unze:
    li $s4, 0
    li $t5, 2
    add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #test temporal
    addi $t1, $t1, 1
    b muli2
    
dosze:
    li $s4, 0
    li $s5, 0
    li $t5, 3
    add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #test temporal
    addi $t1, $t1, 1
    b muli3

treze:
    li $t5, 4
    li $s4, 0
    li $s5, 0
    li $s6, 0
    add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #test temporal
    addi $t1, $t1, 1
    b muli4

muli1:
    li $s4, 0
    mul $s4, $a0, 8
    b seg
muli2:
    li $s5, 0
    mul $s5, $a0, 4
    b seg
muli3:
    li $s6, 0
    mul $s6, $a0, 2
    b seg
muli4:
    li $s7, 0
    mul $s7, $a0, 1
trasforma:
    li $t8, 0
    add $t8, $s4, $s5
    add $t8, $t8, $s6
    add $t8, $t8, $s7
    bgt $t8, 9, last
    add $a0, $t8, $t7 
    b escriu
last:
    beq $t8, 10, A
    beq $t8, 11, B
    beq $t8, 12, C
    beq $t8, 13, D
    beq $t8, 14, E
    beq $t8, 15, F  
A:
    li $a0, 'A'
    b escriu
B:
    li $a0, 'B'
    b escriu
C:
    li $a0, 'C'
    b escriu
D:
    li $a0, 'D'
    b escriu
E:
    li $a0, 'E'
    b escriu
F:
    li $a0, 'F'
    b escriu
escriu:
    li $v0, 11
    syscall
    b seg
fi:
    
    li   $v0,10
    syscall