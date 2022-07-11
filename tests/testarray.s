#Store A, B in memory
.data    
A:  .word   0:5         #Allocate 20 consecutive bytes for 5-element integer word array A
B:  .word   1, 2, 4, 8, 16  #Integer words stored in 5-element array B
space: .asciiz " "  #space as separator

.text
main:
    #Register Map
    #i --> $s0
    #A[0] --> $s1   address of start of A
    #B[0] --> $s2   address of start of B   
    #A[i] --> $t0
    #B[i] --> $t1
    #(A[i] + B[i]) --> $t3
    #((A[i] + B[i]) * 2) --> $t3
    li  $s0, 0      #Load immediate value 0 into i
    li $t4,5        #upper limit
    la $s1,A        #address of start of A
    la $s2,B        #address of start of B  

    #Begin for loop:
    #for(i=0; i<5; i++){ A[i] = B[i] - 1; }
FOR_LOOP:  
    bge     $s0, $t4, END_FOR #Branch if i >= 5, go to END_FOR
    lw $t1,($s2)              #$t1=B[i]
    addi $t1, $t1, -1         #$t1=B[i]-1
    sw $t1,($s1)              #A[i]=B[i]-1
    addi $s1, $s1,4           #next element A[i+1]
    addi $s2, $s2,4           #next element B[i+1]
    addi    $s0, $s0, 1       #Add immediate value 1 to i (i++)
    j FOR_LOOP                #Jump back to the top to loop again

END_FOR:                      #End for loop
    addi $s0, $s0, -1      #Add immediate value -1 to i (i--)
    addi $s1, $s1,-4          #previous element A[i-1]
    addi $s2, $s2,-4          #previous element B[i-1]

    #Begin while loop:  
    #while(i >= 0) { A[i] = (A[i] + B[i]) * 2; i--; }
WHILE_LOOP:
    blt     $s0, 0, END_WHILE #Branch END_WHILE when (i < 0)
    lw $t0,($s1)              #$t0=A[i]
    lw $t1,($s2)              #$t1=B[i]
    add $t3, $t0,$t1          #$t3=A[i] + B[i]
    mul $t3, $t3, 2           #$t3=(A[i] + B[i]) * 2
    sw $t3,($s1)              #A[i] = (A[i] + B[i]) * 2
    addi $s1, $s1,-4          #previous element A[i-1]
    addi $s2, $s2,-4          #previous element B[i-1]
    addi    $s0, $s0, -1      #Add immediate value -1 to i (i--)
    j WHILE_LOOP              #Branch back to the while loop

END_WHILE:

PRINT:                        #print array A[i]
    li $s0, 0                 #i=0
    la $s1, A                 #$s1=A[0]
LOOP:
    bge $s0, $t4, END         # if i >=5 goto END
    lw $a0, ($s1)             #  $a0 = A[i]
    li $v0, 1         #function print integers          
    syscall
    la $a0, space             #print separator (1 space)
    li $v0, 4         #function print strings               
    syscall
    addi $s1, $s1, 4          #next element A[i+1]
    addi $s0, $s0, 1          #i++
    b LOOP

END:
    li $v0, 10                # $v0 (10=exit)
    syscall                   #End program

