#-This a program I had to do for class las year couldent find anithing on the interent so im puting it
#-out there for people to use, if you have any questions message me no probs 
#-this program is in catalan if you want to translate the coments
.data
msg: .asciiz "\n Entra el teu primer float: "
msg2: .asciiz "\n Entra el segon float: "
op0: .asciiz " Entra 0 pero sortir \n"
op1: .asciiz "\n Prem 1 per la opcio suma de floats \n"
op2: .asciiz " Prem 2 per la crear email \n"
op3: .asciiz " Prem 3 per transformar binari a hexa \n"
entra: .asciiz "Entram la opci: "
error: .asciiz "\n entra una opcio valida"
entrada: .space 20
nom:.asciiz "Siusplau entra el teu nom: "
congnom:.asciiz "Siusplau entra el teu congnom: "
email:.asciiz "@uda.ad"
oprompt:.asciiz "Email es: "
first: .space 255 #255 bytes nom
last:  .space 255 #255 bytes congnom
full:  .space 512 #512 bytes email
 message: .asciiz "Entra el numero binari: "
    numbin: .space 255 #255 bytes nom
    quatri: .space 255 #255 dyte 
    hexai: .space 255
.text

main:
	li $v0, 4	#a els diferents op es on tenim les missatges de les diferentes opcions
    la $a0, op1
    syscall
	
	li $v0, 4
    la $a0, op2
    syscall
	
	li $v0, 4
    la $a0, op3
    syscall
	
	li $v0, 4
    la $a0, op0
    syscall
	
	li $v0, 4
    la $a0, entra
    syscall
	
	li $t1, 1
	li $t2, 2
	li $t3, 3
	#entra op
    li $v0, 5	#llegim el caracter selecionat
    syscall
	
	beqz $v0, terminacio  #els diferentes salts a les diferentes opcions de procediment
	beq $v0, $t1, proc1
	beq $v0, $t2, proc2
	beq $v0, $t3, proc3
	bge $v0, $t3, errori
	
terminacio:
	li $v0, 10	#finalitzem el main
	syscall
	
errori: 
	li $v0, 4 #salta a el error escriu missatge d'error i et retorna a el menu
    la $a0, error
    syscall
	b main
	
	
#-------------------Programa floats----------------------------------------	
proc1: #tens que fer dos enters a aquest programa !
		li $v0, 4       # syscall 4 (print_str)
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
		
		
		b main
		
	#----------------------------------Programa email----------------------------------
		
proc2:
		
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
	b main

 
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
		
	#-----------------------------------Programa hexa ------------------------------------------
proc3:	

	li $v0, 4
    la $a0, message #fem un display del nostre missatge
    syscall

    la $a0, numbin #aqui guardem el numero es pot varia aquest numero al data segment si ho vols aumentar la capacitat
    li $a1, 255 #aquest numero tambe tindira que ser variat 
    li $v0, 8
    syscall
#aqui inicialitzo totes les variables ha on m'interesa
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
	
	
loop: #aquest loop serveix per mirar el tamainy de la string 
    lb   $a0,0($t0)
    beqz $a0,done
    addi $t0,$t0,1
    addi $t1,$t1,1
    j     loop
done:
    sub $t1, $t1, $t3 #per tenir el numero de caracters entrats
	add $t2, $t1, $zero #fem aquesta suma per desplazar el valor al registre t2
	#fem una divisio per trovar quants zeros tenim a devant al primer paquet
	div $t2, $t4 #aquesta divisio la faig per saver quin quina quantitat de zeros calen 
	mfhi $s1 #faig la extraccio del residu
	sub $t5, $t4, $s1 #aixos simplement ho faig per que es mes facil per mi pensa amb terminis de zeros que falten no es necesari ho faig per facilitat de compresio
	li $t1,0
	beq $t5, 1, unze #salto a les diferentes opcions depenet de quants zeros em calen
	beq $t5, 2, dosze
	beq $t5, 3, treze
	beq $t5, 4, reto
	
reto:
	li $t5, 0
seg:
	beq $t5, 4, reto #torno a inicia a zero un cop em fet 4
	beq $t2, $t1, fi
    add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #aixos serveix per trasformarlo amb un int resto 48
	addi $t1, $t1, 1 #increment del meu index
	addi $t5, $t5, 1 #tractament de paquets de 4
	beq $t5, 1, muli1 #salto a les diferentes opcions 
	beq $t5, 2, muli2
	beq $t5, 3, muli3
	beq $t5, 4, muli4
    b seg
	
unze:
	li $s4, 0 # tractament de quan es un zero 
	li $t5, 2
	add $s0, $zero, $t1
    la $a1,numbin
    addu $a1,$a1,$s0   # $a1 = &str[x].  assumes x is in $s0
    lbu $a0,($a1)      # read the character
    sub $a0, $a0, $t7 #test temporal
	addi $t1, $t1, 1
    b muli2
	
dosze:
	li $s4, 0 #dos zeros 
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
	li $t5, 4 #3zeros 
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

muli1: #faig les multiplicacions pertinents , depenent de la possicio a la que es trova el nostre 1 o 0
	li $s4, 0
	mul $s4, $a0, 8 #si esta el primer
	b seg
muli2:
	li $s5, 0
	mul $s5, $a0, 4 #si esta el segon
	b seg
muli3:
	li $s6, 0
	mul $s6, $a0, 2 #si esta el trecer
	b seg
muli4:
	li $s7, 0 #si esta el ultim 
	mul $s7, $a0, 1
trasforma: #sumo els valors multiplicats
	li $t8, 0
	add $t8, $s4, $s5
	add $t8, $t8, $s6
	add $t8, $t8, $s7
	bgt $t8, 9, ulti #si el resultat de la multiplicacio es mes de 9 tinc que transformarlo amb una lletra
	add $a0, $t8, $t7 #si no es mes gran transformem amb asciiz un altre cop i guardem a a0
	b escriu
ulti: #aqui transformo les lletres deoenet del valro obtingut a t8
	beq $t8, 10, A #es vastant obi com funciona aixos 
	beq $t8, 11, B
	beq $t8, 12, C
	beq $t8, 13, D
	beq $t8, 14, E
	beq $t8, 15, F	
A:
	li $a0, 'A' #fiquem es chars a $a0
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
escriu: #escrivim aquest numero o lletra i tornem al bucles 
	li $v0, 11
	syscall
	b seg
fi: #quan plegem tornem al main 
    #aqui et deixo la meva obra mestra es pot obtimitzar a nivell de variables utilitzades pero a nuvell algorithmic no savria com esta molt obtimitzat (el hexa)
    b main