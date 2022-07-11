; multi-segment executable file template.

#start=Traffic_Lights.exe# 

data segment
    tots_groc   equ     0000_0100_1001_0010b       ;posa tots els semafors en groc
    estat1      equ     0000_0010_0100_1000b       ;aquests 4 estats posa 3 semafors en vermell i un sense color (el semafor sense color va canviant)
    estat2      equ     0000_0010_0100_0001b       
    estat3      equ     0000_0010_0000_1001b 
    estat4      equ     0000_0000_0100_1001b
    nordsud     equ     0000_0001_0000_0100b       ;posa els semafors al nord i sud en verd
    vermell     equ     001b                       ;posa el primer semafor en vermell
    groc        equ     010b                       ;posa el primer semafor en groc
    verd        equ     100b                       ;posa el primer semafor en verd
    temps       db      4 dup(?)                   ;taula on guardem el temps entrat amb els sliders
    milio       dw      000Fh,4240h                ;es una taula de dos posicions on guardem un milio en hexa (el dividim en dos words per que sigui mes senzill calcular el temps)
    tmicro      dw      0000h,0000h                ;taula igual que l'anterior, pero hi guardem el temps resultant
   
ends

code segment
    
start: 


; Nosaltres tenim 3 casos: 
;                          1-   Cas "Config"  --> INT 90h  
;                          2-   Cas "Per defecte"   --> INT 91h
;                          3-   Cas "Intermitent"   --> INT 92h  
    
    mov ax, data    ; Segments a lloc
    mov ds, ax
    mov es, ax
    
    xor ax, ax
    mov es, ax   
    
;Preparem la rutina de Config

    mov al, 90h   
    mov bl, 4h
    mul bl
    mov bx, ax
    
    mov si, offset [config]    
    mov es:[bx], si
    add bx, 2
    mov ax, cs
    mov es:[bx], ax   
    
;Preparem la rutina de Per Defecte

    mov al, 91h
    mov bl, 4h
    mul bl
    mov bx, ax
    
    mov si, offset [defecte]    
    mov es:[bx], si
    add bx, 2
    mov ax, cs
    mov es:[bx], ax  
    
;Preparem la rutina de Intermitent

    mov al, 92h
    mov bl, 4h
    mul bl
    mov bx, ax
    
    mov si, offset [intermitent]    
    mov es:[bx], si
    add bx, 2
    mov ax, cs
    mov es:[bx], ax       

    call clear
    
;bucle d'espera (espera una interrupcio)  
espera:
    xor ax,ax

    jmp espera
 
    int 20h     ; aturar execucio       
    

;IMPLEMENTACIO DE MODULS

;modul config
config:
    pusha
    cli
           
    call llegirt    ;llegim info sliders i ho guardem a taula temps   
    
    ;---------PRIMER SEMAFOR---------
    
    mov ax, estat1  ;posem 3 semafors en vermell 
    add ax, verd    ;posem el semafor restant en verd
    out 4, ax       ;output
    
    mov si, 0       ;indiquem posicio de la taula temps
    call tempo      ;cridem funcio temps per fer x segons entrats per l'slider
    
    mov ax, estat1  ;posem 3 semafors en vermell
    add ax, groc    ;posem el semafor restant en groc
    out 4, ax       ;output
    
    call 2seg       ;el semafor esta en groc 2 segons
    
    ;---------SEGON SEMAFOR---------        
                
    mov ax, estat2  ;posem 3 semafors en vermell (aquest cop diferents)
    mov bl, verd    ;posem en un registre auxiliar el color verd
    shl bx, 3       ;com volem el segon semafor en verd, fem un shift de 3 cap a l'esquerra: passem de 100 a 10_0000
    add ax, bx      ;afegim el verd amb els altres semafors en vermell
    out 4, ax       ;output
    
    inc si          ;incrementem si => si = 1 (temps[1])
    call tempo      ;fem x segons en verd
    
    mov ax, estat2  ;tornem a fer el mateix procediment pero en comptes de verd,o fem amb groc
    mov bl, groc
    shl bx, 3
    add ax, bx
    out 4, ax
    
    call 2seg       ;2 segons en groc
                
    ;---------TERCER SEMAFOR--------- 
    
    mov ax, estat3  ;per a cada semafor fem el mateix procediment, pero cada vegada fem un shift del verd i groc de 3 mes.
    mov bl, verd
    shl bx, 6       ;en aquest cas, fem un shift de 6 en comptes de 3
    add ax, bx
    out 4, ax
    
    inc si
    call tempo
    
    mov ax, estat3
    mov bl, groc
    shl bx, 6
    add ax, bx
    out 4, ax
                 
    call 2seg 
    
    ;---------QUART SEMAFOR--------- 
    
    mov ax, estat4
    mov bl, verd
    shl bx, 9       ;aquest cop el shift es de 9
    add ax, bx
    out 4, ax  
    
    inc si
    call tempo
    
    mov ax, estat4
    mov bl, groc
    shl bx, 9
    add ax, bx
    out 4, ax
    
    call 2seg 
    call clear      ;fem un "clear" de la pantalla (els posem tots en vermell)
      
    sti 
    popa
    iret
    
; modul per defecte

defecte:
    pusha
    cli 
    
    call llegirt    ;llegim info sliders i ho guardem a taula temps
    
;semafors nord sud en verd!
    mov ax, nordsud ;posem en un registre semafors nord i sud en verd
    mov bx, nordsud ;tornem a guardar el mateix en bx
    shl bx, 1       ;ja que nosaltres volem que els semafors est i oest en vermell, fem un shift cap a l'esquerra de 1 per que siguin vermells
    add ax, bx      ;juntem els dos 
    out 4, ax       ;output
    
    mov si, 0       ;volem que segueixin el temps del primer semafor => primera posicio de la taula temps (0)
    call tempo      ;fem x temps
    
    mov ax, nordsud ;tornem a posar en un registre semafors nord i sud en verd
    shr ax, 1       ;fem shift cap a la dreta de 1 per que siguin de color groc
    mov bx, nordsud ;tornem a posar est i oest en vermell
    shl bx, 1 
    add ax, bx      ;els juntem
    out 4, ax       ;output
    
    call 2seg       ;estan en groc durant 2 segons
    
;semafors est i oest en verd!
    mov ax, nordsud ;guardem nord i sud en verd
    shl ax, 3       ;fem un shift cap a l'esquerra de tres per que ara siguin de color verd est i oest
    mov bx, nordsud ;tornem a guardar nord i sud verd a un altre registre
    shr bx, 2       ;fem shift cap a la dreta per que canviin a vermell
    add ax, bx      ;els juntem
    out 4, ax       ;output
    
    mov si, 2       ;volem que segueixin el temps del tercer semafor => tercera posicio de la taula temps (2)
    call tempo      ;fem x temps
    
    mov ax, nordsud 
    shl ax, 2       ;fem un shift cap a l'esquerra de dos per que sigui de color groc
    mov bx, nordsud
    shr bx, 2       ;nord i sud en vermell (com abans)
    add ax, bx 
    out 4, ax
    
    call 2seg       ;2 segons en groc
    call clear      ;fem un "clear" de la pantalla => els posem tots en vermell
    
    sti
    popa
    iret
    
;modul intermitent
intermitent:
    pusha
    cli

bucleinter:    
    mov ax, tots_groc;posem tots els semafors en groc
    out 4, ax       ;output
    
    ; wait 1 second (1 million microseconds)
    mov     cx, 0Fh    ;  000F4240h = 1,000,000
    mov     dx, 4240h
    mov     ah, 86h
    int     15h
    
    mov ax, 0       ;posem tots els semafors sense color
    out 4, ax       ;output
    
    ; wait 1 second (1 million microseconds)
    mov     cx, 0Fh    ;  000F4240h = 1,000,000
    mov     dx, 4240h
    mov     ah, 86h
    int     15h   
    
    jmp bucleinter  ;fem que sigui un bucle interminable
    
    sti
    popa
    iret 


;--------MODULS AUXILIARS--------

clear   proc near   ;fem un "CLEAR" dels semafors => els posem tots en vermell   
    mov ax, tots_groc ;tots els semafors en groc
    shr ax, 1       ;shift cap a l'esquerra de 1 => tots en vermell 
    out 4, ax       ;output
    ret  
clear   endp


tempo   proc near   ;funcio de temps amb info de slider
    mov ax, milio[2];guardem dins de ax els 2 primers valors del milio (0Fh)
    mov bl, temps[si];guardem a bl el valor de temps entrat amb l'slider
    mul bx          ;els multipliquem 
    mov tmicro[2], ax;el guardem a la primera posicio de la taula final
    
    xor bx, bx      ;posem a 0 bx
    mov cx, dx
    
    mov ax, milio[0];guardem dins de ax la resta de valors del milio (4240h)
    mov bl, temps[si];guardem a bl el valor de temps entrat amb l'slider
    mul bx          ;els multipliquem
    mov tmicro[0], ax;els guardem a l'altra casella de sortida 
    
    mov cx, tmicro[0];posem a cx els primer 4 bytes (4240h)
    mov dx, tmicro[2];posem a dx els 4 ultims (0Fh)
    mov ah, 86h
    int 15h 
    
    ret
tempo   endp 
      
      
2seg    proc near
    ; wait 2 seconds (2 million microseconds)
    mov     cx, 1Eh    ;  001E8480h = 2,000,000
    mov     dx, 8480h
    mov     ah, 86h
    int     15h
    ret
2seg    endp

llegirt proc near   ;llegim els inputs dels sliders i els guardem dins d'una taula (temps)
    mov dx, 1001h   ;guardem dins de dx el port
    in  al, dx      ;guardem l'input del port dins de al
    mov [temps], al ;guardem al dins de la taula
    inc dx          ;incrementem dx => seguent port (1002h)
    
    in  al, dx
    mov [temps+1], al
    inc dx
    
    in  al, dx
    mov [temps+2], al
    inc dx
    
    in  al, dx
    mov [temps+3], al
    
    ret
llegirt endp

ends
end start