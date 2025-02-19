DATA SEGMENT
    BUFFER DB 6, ?, 6 DUP('$') ; Buffer para entrada de n�meros
    NUM DW 0                   ; N�mero convertido
    SUM DW 0                   ; Resultado da soma
    COUNT DW 0                 ; Contador de n�meros a somar
    MSG_PROMPT_COUNT DB 'Quantos numeros deseja somar? $'
    MSG_PROMPT_NUMBER DB 0Dh, 0Ah, 'Digite o numero: $'
    MSG_RESULT DB 0Dh, 0Ah, 'Resultado da soma: $'
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA         ; Configurar o segmento de dados
    MOV DS, AX           ; Inicializar segmento de dados

    ; Solicitar quantidade de n�meros
    LEA DX, MSG_PROMPT_COUNT ; Mensagem para quantidade de n�meros
    MOV AH, 09h          ; Fun��o 09h: Exibir string
    INT 21h              ; Chamar interrup��o do DOS

    ; Ler quantidade de n�meros
    LEA DX, BUFFER       ; Endere�o do buffer para entrada
    MOV AH, 0Ah          ; Fun��o 0Ah: Ler string do teclado
    INT 21h              ; Chamar interrup��o do DOS

    ; Converter string para n�mero
    LEA SI, BUFFER+2     ; SI aponta para o n�mero digitado
    CALL STRING_TO_NUM   ; Chamar subrotina para convers�o
    MOV COUNT, AX        ; Armazenar a quantidade de n�meros em COUNT

    ; Inicializar soma
    XOR AX, AX           ; Zerar AX
    MOV SUM, AX          ; Zerar o acumulador de soma

SUM_LOOP:
    ; Verificar se ainda h� n�meros para somar
    CMP COUNT, 0         ; Verificar se COUNT � 0
    JE DISPLAY_RESULT    ; Se COUNT = 0, exibir resultado

    ; Solicitar n�mero do usu�rio
    LEA DX, MSG_PROMPT_NUMBER ; Mensagem para o n�mero
    MOV AH, 09h          ; Fun��o 09h: Exibir string
    INT 21h              ; Chamar interrup��o do DOS

    ; Ler n�mero como string
    LEA DX, BUFFER       ; Endere�o do buffer para entrada
    MOV AH, 0Ah          ; Fun��o 0Ah: Ler string do teclado
    INT 21h              ; Chamar interrup��o do DOS

    ; Converter string para n�mero
    LEA SI, BUFFER+2     ; SI aponta para o n�mero digitado
    CALL STRING_TO_NUM   ; Chamar subrotina para convers�o
    ADD SUM, AX          ; Somar o n�mero digitado a SUM

    ; Decrementar contador
    DEC COUNT            ; COUNT = COUNT - 1
    JMP SUM_LOOP         ; Repetir o loop

DISPLAY_RESULT:
    ; Exibir resultado da soma
    LEA DX, MSG_RESULT   ; Carregar o endere�o da mensagem
    MOV AH, 09h          ; Fun��o 09h: Exibir string
    INT 21h              ; Chamar interrup��o do DOS

    ; Exibir o valor da soma
    MOV AX, SUM          ; Carregar o resultado da soma em AX
    CALL PRINT_NUMBER    ; Chamar subrotina para imprimir o n�mero

    ; Encerrar o programa
    MOV AX, 4C00h        ; Fun��o 4Ch: Encerrar o programa
    INT 21h

; Subrotina: Converter String para N�mero
STRING_TO_NUM:
    XOR AX, AX           ; Zerar AX (armazenar� o n�mero convertido)
    XOR BX, BX           ; Zerar BX (multiplicador)

CONVERT_LOOP:
    MOV CL, [SI]         ; Carregar o pr�ximo caractere
    CMP CL, 0Dh          ; Verificar se � o "Enter" (fim da string)
    JE END_CONVERT       ; Se for Enter, terminar convers�o

    SUB CL, '0'          ; Converter caractere ASCII para valor num�rico
    MOV BX, 10           ; Carregar o valor 10 em BX
    IMUL BX              ; Multiplicar AX por 10
    ADD AX, CX           ; Somar o valor num�rico convertido
    INC SI               ; Avan�ar para o pr�ximo caractere
    JMP CONVERT_LOOP     ; Repetir para o pr�ximo d�gito

END_CONVERT:
    RET

; Subrotina: Exibir N�mero em AX
PRINT_NUMBER:
    PUSH AX              ; Salvar AX
    XOR CX, CX           ; Zerar CX (contar� os d�gitos)
    MOV BX, 10           ; Divisor (base decimal)

CONVERT_TO_STRING:
    XOR DX, DX           ; Limpar DX para divis�o
    DIV BX               ; Dividir AX por 10 (quociente em AX, resto em DX)
    ADD DL, '0'          ; Converter o d�gito para ASCII
    PUSH DX              ; Armazenar o d�gito na pilha
    INC CX               ; Incrementar contador de d�gitos
    TEST AX, AX          ; Verificar se restam mais d�gitos
    JNZ CONVERT_TO_STRING; Repetir at� que AX seja 0

PRINT_DIGITS:
    POP DX               ; Recuperar o pr�ximo d�gito
    MOV AH, 02h          ; Fun��o 02h: Imprimir caractere
    INT 21h              ; Chamar interrup��o do DOS
    LOOP PRINT_DIGITS    ; Repetir at� que todos os d�gitos sejam exibidos
    POP AX               ; Restaurar AX
    RET

CODE ENDS
END START