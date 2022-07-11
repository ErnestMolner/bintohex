.data

nom:.asciiz "Siusplau entra el teu nom: "
congnom:.asciiz "Siusplau entra el teu congnom: "
email:.asciiz "@uda.ad"
oprompt:.asciiz "Email es: "
first: .space 255 #255 bytes nom
last:  .space 255 #255 bytes congnom
full:  .space 512 #512 bytes email

	.text
main:

    #Sortida del primer missatge
    li $v0, 4
    la $a0, nom
    syscall

    #entrada nom 
    la $a0, first
    li $a1, 255
    li $v0, 8
    syscall

    #Sortida del segon missatge
    li $v0, 4
    la $a0, congnom
    syscall

    #entrada congnom
    la $a0, last
    li $a1, 255
    li $v0, 8
    syscall

    #Fem instrucio 
    li $v0, 4
    la $a0, oprompt
    syscall

    #assignem valors a variables
    move $s0 $ra
    la $a0 first
    la $a1 email
    la $a2 last
	la $a3 full
    jal char1
    move $ra $s0

    #ensenym la cadena
    la $a0 full
    li $v0 4
    syscall

    #eneyem la nova cadena 
  #  li $a0 10
  #  li $v0 11
  #  syscall

    #exit
    jr $ra
	
	char1:
		li $t8 10 #nova cadena a t8
		lb   $t0 0($a0)
        sb   $t0 0($a3)
        addi $a3 $a3 1
	
	strcpy:

 

    #loop Copialcadena1 on afegim tota la cadena 2
   Copialcadena1:

        lb   $t0 0($a2)
        beq  $t0 $zero Copialcadena2 #sortim al byte null
        beq  $t0 $t8 Copialcadena2   #sortim a una nova linea
        sb   $t0 0($a3)
        addi $a2 $a2 1
        addi $a3 $a3 1
        b Copialcadena1

    

    #loop Copialcadena2 afegim la cadena amb l'email
    Copialcadena2:

        lb   $t0 0($a1)
        beq  $t0 $zero fet #sortim al byte null
        beq  $t0 $t8 fet   #sortim a una nova linea
        sb   $t0 0($a3)
        addi $a1 $a1 1
        addi $a3 $a3 1
        b Copialcadena2

    fet:

        sb $zero 0($a2) #finalitzacio de la cadena 
        jr $ra #tornem a ra
		
		#agreixo a Craig Estey per el seus exemples d'adiccio de strings 