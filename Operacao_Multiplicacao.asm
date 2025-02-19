org 100h

.stack

DB 2 dup(?)

ends stack

.data

Array 13 dup(?)

Index db 1  ;guardar o index dos algoritmos
Numero_Soma dw 1; guardar o primeiro numero
myVar1 dw ?
myVar2 dw ?
message db 'Hello, world!$'  ; Message to display, with '$' as string terminator for DOS interrupt
Nota db 10,13, "Nota: Caso insira uma letra pode continuar"
db 10,13, "a escrever o numero pretendido pois"
db 10,13, "a letra nao vai afetar o calculo"
db 10,13, " $"
String_Soma db 10,13, "Insira o valor : $"

String_Barras db 10,13, "Insira o codigo de barras: $"

String_NIF db 10,13, "Insira o NIF: $"

String_Cc db 10,13, "Insira o CC: $"

String_Menu db 10,13, " "
db 10,13, "O que pretende fazer?"
db 10,13, "1: Usar de novo o mesmo algoritmo"
db 10,13, "2: Voltar ao menu inicial"
db 10,13, "3: Sair"
db 10,13, "Escolha a pretendida operacao: $"

String_Exit db 10,13," "
db 10,13,"O programa terminou$"

Invalid db 10,13, "Numero Invalido$"

Valid db 10,13, "Numero Valido$"

Frase db 10,13,"1: Soma",
db 10,13,"2: Subtracao",
db 10,13,"8: Sair"
db 10,13, "Escolha a pretendida operacao: $"

msgInput db 10,13, "Insira o numero:",'$'
msgResult db 10,13, "Resultado:",'$'

ends data

.code

Main proc
mov ax, @data   ;inicialization of the data declared above
mov ds, ax  ;defining that de DATA SEGMENT (ds) points to our data, not to our code (as it does by default)
mov bx, offset Array ; passing the array to the bx register

xor ax,ax
int 10h       ;define uma nova janela com um tipo de frame especifico(text e janela width and Height)
;mas neste caso ajuda-nos a simplesmente limpar o que estava antes

mov ah,09h
lea dx, Frase ;printing the string
int 21h

mov ah,1
int 21h

mov [Index],al ; definir o valor do index do algoritmo na variavel

call Sub_Main

Main endp

Sub_Main proc    ;Com este procedimento podemos reutilizar codigo por guardar qual "indice" do algoritmo
;que foi escolhido, assim nao temos que fazer o procedimento "Print_Valid" e "Print_Invalid"
;7 vezes diferentes, todas elas para cada algoritmo por causa da funcao que fica no numero 2.
mov al,[Index]

cmp al,31h
jl Invalid_Main

cmp al,31h
je Soma

cmp al,32h
je Subtracao
cmp al,33h

cmp al,38h
je Exit

cmp al,38h
jg Invalid_Main

Sub_Main endp

Subtracao proc
xor ax,ax
int 10h



mov SI, offset Array

xor cx,cx
xor bx,bx

RestartSubtracao:

mov SI, offset Array


mov ah, 09h                 ; Exibe a segunda mensagem de input
lea dx, msgInput            ; Carrega o endereço da string "msgInput"
int 21h                     ; Exibe a mensagem na tela

Ler_Con1:

mov [Numero_Soma],di

mov ah,1
int 21h

cmp al,0Dh
je Finn1

sub al,30h
cmp al,0          ;vamos verificar se o numero introduzido esta entre 0 a 9
jl Ler_Con

cmp al,9
jg Ler_Con

mov [SI], al  ;add the value of ax to the element of bx

INC SI        ;increase the bx register so we can access the next element in the array

INC cx

jmp Ler_Con1

Finn1:

mov SI, offset Array

mov dx,di
xor di,di
xor ax,ax

Loop_Tag1:

mov dl, [si]
mov bl, 10
mul bl

ADD ax, dx

inc si

cmp si, offset Array + cl ; tem de ser com um loop
loop Loop_Tag1

mov di,ax

mov dx, [Numero_Soma]

cmp dx,0
je RestartSubtracao

Final1:

SUB dx,ax

call convertt

mov ah,02h
mov dl,dl
int 21h

mov ah,4Ch
int 21h

Subtracao endp

Soma proc

xor ax,ax                  ; Zera o registrador AX
int 10h                     ; Chama a interrupção 10h para redefinir o vídeo (método típico para reiniciar a tela em alguns sistemas)



mov SI, offset Array        ; Define o ponteiro para o início do array (onde os números inseridos serão armazenados)

xor cx,cx                   ; Zera o contador CX (usado como contador de números inseridos)
xor bx,bx                   ; Zera o registrador BX (não está sendo utilizado neste código diretamente)



Restart:
mov SI, offset Array        ; Redefine o ponteiro para o início do array



mov ah, 09h                 ; Exibe a segunda mensagem de input
lea dx, msgInput            ; Carrega o endereço da string "msgInput"
int 21h                     ; Exibe a mensagem na tela

Ler_Con:

mov [Numero_Soma],di        ; Armazena o valor de DI (que parece ser um acumulador) em 'Numero_Soma'

mov ah,1                    ; Prepara a função 01h da interrupção 21h (leitura de um caractere da entrada)
int 21h                     ; Lê um caractere digitado pelo usuário e coloca no registrador AL

;jmp NextInput
cmp al,0Dh                  ; Compara o valor de AL com 0Dh (código de Enter, fim de linha)
;jmp NextInput
je Finn                      ; Se Enter for pressionado (AL == 0Dh), pula para a label 'Finn'

sub al,30h                  ; Subtrai 30h de AL para converter o caractere ASCII para o valor numérico correspondente
cmp al,0                    ; Verifica se o valor de AL é menor que 0 (número inválido)
jl Ler_Con                  ; Se for menor que 0, retorna ao início do loop para pedir outro número

cmp al,9                    ; Verifica se o número inserido é maior que 9
jg Ler_Con                  ; Se for maior que 9, retorna ao início do loop para pedir outro número

mov [SI], al                ; Armazena o valor numérico de AL no array em SI (posição atual do array)

INC SI                      ; Incrementa o ponteiro SI para a próxima posição do array

INC cx                      ; Incrementa o contador CX (contando o número de elementos inseridos)


jmp Ler_Con                 ; Retorna ao início do loop para pedir outro número


Finn:
mov SI, offset Array        ; Redefine o ponteiro para o início do array

mov dx,di                   ; Copia o valor de DI para DX (aparentemente, DI está acumulando a soma)
xor di,di                   ; Zera o registrador DI

xor ax,ax                   ; Zera o registrador AX (usado para a soma dos valores)

Loop_Tag:
mov dl, [si]              ; Copia o valor da posição apontada por SI para DL (caracter na posição atual do array)
mov bl, 10                ; Carrega 10 em BL (preparação para multiplicação por 10)
mul bl                     ; Multiplica AX por 10, colocando o resultado em AX
add ax, dx                 ; Adiciona o valor de DL ao acumulador AX

inc si                     ; Incrementa o ponteiro SI para a próxima posição do array

cmp si, offset Array + cl  ; Verifica se o ponteiro SI alcançou o final do array
loop Loop_Tag              ; Se não alcançou o final, repete o loop (decrementa CX e continua se CX != 0)

mov di,ax                   ; Move o valor de AX para DI (aparentemente, DI contém a soma dos números)

mov dx, [Numero_Soma]       ; Move o valor armazenado em Numero_Soma para DX

cmp dx,0                    ; Verifica se DX é igual a 0
je Restart                  ; Se DX for 0, reinicia o processo

Final:

MUL dx
;; multiplicacao dx:ax (16+16)

mov myVar1, dx
mov myVar2, ax
; xor ax,ax
;mov ax, myVar1
;call convertt
mov dx, myVar2
call convertt

;mov cx,dx ;MEXER



;call convertt               ; Chama uma função (não definida no código) para converter o valor em DX para um formato específico

mov ah,02h                  ; Prepara a função 02h da interrupção 21h (mostrar caractere)
mov dx,cx                   ; Coloca o valor de DL (que é o valor que será mostrado) no registrador DL

int 21h                     ; Exibe o caractere no console

mov ah,4Ch                  ; Prepara a função 4Ch da interrupção 21h (finalizar o programa)
int 21h                     ; Chama a interrupção 21h para terminar o programa

Soma endp



convertt proc
; Assume DX contains 001Ah (26 decimal)
; The goal is to print the decimal value 26
mov ax, dx          ; Copy DX to AX (AX = 001Ah = 26 decimal)  MEXER
mov bx, 10          ; Set divisor (10) to divide the number

xor si,si
; Convert AX (26) to decimal string
convert_to_decimal:
xor dx, dx         ; Clear DX, this will hold the remainder    MEXER
div bx             ; Divide AX by 10. Quotient in AX, remainder in DX
add dl, '0'        ; Convert the remainder (digit) to ASCII
mov [si], dl       ; Store the digit in the buffer
inc si             ; Move to the next position in the buffer
test ax, ax        ; Test if quotient is 0 (if AX == 0)
jnz convert_to_decimal ; If AX is not zero, continue the division

; Print the number in the buffer (print digits in reverse order)

dec si                 ; Move SI back to the last digit in the buffer

mov ah, 09h                 ; Exibe a segunda mensagem de input
lea dx, msgResult            ; Carrega o endereço da string "msgInput"
int 21h


print_digits:

mov dl, [si]       ; Load the current digit (ASCII) into DL
mov ah, 02h        ; DOS function to display a character
int 21h            ; Call DOS interrupt to print the character
dec si             ; Move to the previous character
jns print_digits   ; Continue until we've printed all digits

ret

convertt endp


Print_Invalid proc                 ;printing the pre-defined string if the number is invalid

mov bx, offset Array

mov ah,09h
lea dx,Invalid
int 21h

jmp Ending
Print_Invalid endp

Print_Valid proc                 ;printing the pre-defined string if the number is invalid

mov bx, offset Array

mov ah,09h
lea dx,Valid
int 21h

jmp Ending
Print_Valid endp

Invalid_Main proc

mov ah,09h
lea dx,Invalid
int 21h

jmp Main
Invalid_Main endp

Delete_Digit proc

mov dl,20h
mov ah,02h
int 21h

cmp SI,1
jne Comparison

cmp bx,offset Array
je Return

DEC bx

Comparison:
mov dl,8h               ;ver valor guardado anteriormente em dl
mov ah,02h
int 21h

Return:
ret

Delete_Digit endp

Exit proc

mov ah,09h
lea dx,String_Exit
int 21h

mov ah,4Ch
int 21h

Exit endp

Ending proc

mov ah,09h
lea dx,String_Menu      ;imprimir a string definida no data para saber o que o nosso utilizador pretende fazer de seguida
int 21h

mov ah,1                ;Receber o numero
int 21h

cmp al,31h                ;Reiniciar o algoritmo do NIF
je Sub_Main

cmp al,32h                ;Ir para o menu
je Main

cmp al,33h                ;chamar o procedimento Exit para terminar o programa
je Exit

Ending endp

ends code