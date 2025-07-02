ORG 100h

section .data
menuTitle      db "Bienvenidos al parcial final de Arquitectura de computadoras", 0
option1        db "1. Para ir a ingreso de textos desde teclado precione 1", 0
option2        db "2. Para mostrar triangulo precione 2", 0
option3        db "3. Para mostrar casa precione 3", 0
option4        db "4. Para salir presione 4", 0

nombre         db "Henry Saul Martinez Flores - 00012622", 0
msgSalir       db "Fin del programa", 0
msgInvalido    db "Opcion invalida, presione una tecla...", 0

section .text
start:
    mov ax, cs
    mov ds, ax

menu:
    call ClearScreen

    ; Titulo
    mov dh, 2
    mov dl, 10
    call SetCursor
    mov si, menuTitle
    call PrintString

    ; Opciones
    ;1
    mov dh, 5
    mov dl, 5
    call SetCursor
    mov si, option1
    call PrintString

    ;2
    mov dh, 6
    mov dl, 5
    call SetCursor
    mov si, option2
    call PrintString

    ;3
    mov dh, 7
    mov dl, 5
    call SetCursor
    mov si, option3
    call PrintString

    ;4
    mov dh, 8
    mov dl, 5
    call SetCursor
    mov si, option4
    call PrintString

    ; Nombre/carne
    mov dh, 24
    mov dl, 26
    call SetCursor
    mov si, nombre
    call PrintString

    ; Entrada de opción
    mov ah, 1
    int 21h

    cmp al, '1'
    je opcion1
    cmp al, '2'
    je opcion2
    cmp al, '3'
    je opcion3
    cmp al, '4'
    je salir

    jmp opcion_invalida

    opcion1:
    call ClearScreen

    mov dh, 5          
    mov dl, 10         
    call SetCursor

;mode texto opcion 1
.ingresar_tecla:
    mov ah, 0
    int 16h            
    cmp al, 'S'
    je menuTexto       

    cmp al, 13
    je .fin_entrada    

    cmp al, 8
    je .borrar

    
    mov ah, 0Eh
    int 10h

    inc dl            
    call SetCursor
    jmp .ingresar_tecla

.borrar:
    cmp dl, 0
    je .ingresar_tecla
    dec dl             
    call SetCursor
    mov ah, 0Ah       
    mov al, ' '
    int 10h
    call SetCursor   
    jmp .ingresar_tecla

.fin_entrada:
    jmp menuTexto

; Triángulo 
opcion2: 
    call ModoGrafico
    call DibujarTriangulo
   
espera_s:
    mov ah, 0
    int 16h
    cmp al, 'S'
    je menuTexto
    ;cmp al, 's'
    ;je menuTexto
    jmp espera_s

; casa
opcion3: 
    call ModoGrafico
    call DibujarCasa

esperar_s_casa:
    mov ah, 0
    int 16h
    cmp al, 'S'
    je menuTexto
    ;cmp al, 's'
    ;je menuTexto
    jmp esperar_s_casa

salir:
    call ClearScreen
    mov dh, 10
    mov dl, 10
    call SetCursor
    mov si, msgSalir
    ;mov si, nombre
    call PrintString
    call EsperarTecla
    ;cmp al, 'S'
    ;je menuTexto
    ;jmp salir
    mov ah, 4Ch
    int 21h

opcion_invalida:
    call ClearScreen
    mov dh, 10
    mov dl, 10
    call SetCursor
    mov si, msgInvalido
    call PrintString
    call EsperarTecla
    jmp menu

; Subrutinas

;triangulo
ClearScreen:
    mov ah, 0
    mov al, 3 
    int 10h
    ret

menuTexto:
    mov ah, 0
    mov al, 3
    int 10h
    jmp menu

ModoGrafico:
    mov ah, 0
    mov al, 13h
    int 10h
    ret

SetPixel: 
    mov ah, 0Ch
    int 10h
    ret

DibujarTriangulo:
    mov si, 0 

.triangle_loop:
    mov dx, 100        
    add dx, si        

    mov cx, 100      
    mov bx, si       

.draw_line:
    mov al, 4         
    call SetPixel
    inc cx
    dec bx
    jns .draw_line

    inc si
    cmp si, 50     
    jb .triangle_loop
    ret

LineaHorizontal: 
    push cx
    mov bx, cx
    add bx, 20
.draw_line:
    mov al, 6 
    call SetPixel
    inc cx
    cmp cx, bx
    jbe .draw_line
    pop cx
    ret

SetCursor:
    mov ah, 2
    mov bh, 0
    int 10h
    ret

PrintString:
    mov ah, 0Eh
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .next_char
.done:
    ret

EsperarTecla:
    mov ah, 0
    int 16h
    ret

;casa

DibujarCasa:
    ; Cuadrado principal 
    mov dx, 110
.cuerpo_filas:
    mov cx, 120
.cuerpo_cols:
    mov al, 4   
    call SetPixel
    inc cx
    cmp cx, 200
    jbe .cuerpo_cols
    inc dx
    cmp dx, 170
    jbe .cuerpo_filas

    ; Techo 
    mov si, 0
.techo_loop:
    mov dx, 110         
    sub dx, si        

    mov cx, 120        
    add cx, si         
    mov bx, 80
    sub bx, si
    sub bx, si          

.techo_linea:
    mov al, 4         
    call SetPixel
    inc cx
    dec bx
    jns .techo_linea

    inc si
    cmp si, 40       
    jb .techo_loop


    ; Puerta 
    mov dx, 130
.puerta_filas:
    mov cx, 155
.puerta_cols:
    mov al, 7   
    call SetPixel
    inc cx
    cmp cx, 180
    jbe .puerta_cols
    inc dx
    cmp dx, 170
    jbe .puerta_filas
    ret




    




