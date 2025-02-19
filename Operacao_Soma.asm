DATA SEGMENT
    BUFFER DB 6, ?, 6 DUP('$') ; Buffer para entrada de números
    NUM DW 0                   ; Número convertido
    SUM DW 0                   ; Resultado da soma
    COUNT DW 0                 ; Contador de números a somar
    MSG_PROMPT_COUNT DB 'Quantos numeros deseja somar? $'
    MSG_PROMPT_NUMBER DB 0Dh, 0Ah, 'Digite o numero: $'
    MSG_RESULT DB 0Dh, 0Ah, 'Resultado da soma: $'
DATA ENDS

CODE SEGMENT
START:
    MOV AX, DATA         ; Configurar o segmento de dados
    MOV DS, AX           ; Inicializar segmento de dados

    ; Solicitar quantidade de números
    LEA DX, MSG_PROMPT_COUNT ; Mensagem para quantidade de números
    MOV AH, 09h          ; Função 09h: Exibir string
    INT 21h              ; Chamar interrupção do DOS

    ; Ler quantidade de números
    LEA DX, BUFFER       ; Endereço do buffer para entrada
    MOV AH, 0Ah          ; Função 0Ah: Ler string do teclado
    INT 21h              ; Chamar interrupção do DOS

    ; Converter string para número
    LEA SI, BUFFER+2     ; SI aponta para o número digitado
    CALL STRING_TO_NUM   ; Chamar subrotina para conversão
    MOV COUNT, AX        ; Armazenar a quantidade de números em COUNT

    ; Inicializar soma
    XOR AX, AX           ; Zerar AX
    MOV SUM, AX          ; Zerar o acumulador de soma

SUM_LOOP:
    ; Verificar se ainda há números para somar
    CMP COUNT, 0         ; Verificar se COUNT é 0
    JE DISPLAY_RESULT    ; Se COUNT = 0, exibir resultado

    ; Solicitar número do usuário
    LEA DX, MSG_PROMPT_NUMBER ; Mensagem para o número
    MOV AH, 09h          ; Função 09h: Exibir string
    INT 21h              ; Chamar interrupção do DOS

    ; Ler número como string
    LEA DX, BUFFER       ; Endereço do buffer para entrada
    MOV AH, 0Ah          ; Função 0Ah: Ler string do teclado
    INT 21h              ; Chamar interrupção do DOS

    ; Converter string para número
    LEA SI, BUFFER+2     ; SI aponta para o número digitado
    CALL STRING_TO_NUM   ; Chamar subrotina para conversão
    ADD SUM, AX          ; Somar o número digitado a SUM

    ; Decrementar contador
    DEC COUNT            ; COUNT = COUNT - 1
    JMP SUM_LOOP         ; Repetir o loop

DISPLAY_RESULT:
    ; Exibir resultado da soma
    LEA DX, MSG_RESULT   ; Carregar o endereço da mensagem
    MOV AH, 09h          ; Função 09h: Exibir string
    INT 21h              ; Chamar interrupção do DOS

    ; Exibir o valor da soma
    MOV AX, SUM          ; Carregar o resultado da soma em AX
    CALL PRINT_NUMBER    ; Chamar subrotina para imprimir o número

    ; Encerrar o programa
    MOV AX, 4C00h        ; Função 4Ch: Encerrar o programa
    INT 21h

; Subrotina: Converter String para Número
STRING_TO_NUM:
    XOR AX, AX           ; Zerar AX (armazenará o número convertido)
    XOR BX, BX           ; Zerar BX (multiplicador)

CONVERT_LOOP:
    MOV CL, [SI]         ; Carregar o próximo caractere
    CMP CL, 0Dh          ; Verificar se é o "Enter" (fim da string)
    JE END_CONVERT       ; Se for Enter, terminar conversão

    SUB CL, '0'          ; Converter caractere ASCII para valor numérico
    MOV BX, 10           ; Carregar o valor 10 em BX
    IMUL BX              ; Multiplicar AX por 10
    ADD AX, CX           ; Somar o valor numérico convertido
    INC SI               ; Avançar para o próximo caractere
    JMP CONVERT_LOOP     ; Repetir para o próximo dígito

END_CONVERT:
    RET

; Subrotina: Exibir Número em AX
PRINT_NUMBER:
    PUSH AX              ; Salvar AX
    XOR CX, CX           ; Zerar CX (contará os dígitos)
    MOV BX, 10           ; Divisor (base decimal)

CONVERT_TO_STRING:
    XOR DX, DX           ; Limpar DX para divisão
    DIV BX               ; Dividir AX por 10 (quociente em AX, resto em DX)
    ADD DL, '0'          ; Converter o dígito para ASCII
    PUSH DX              ; Armazenar o dígito na pilha
    INC CX               ; Incrementar contador de dígitos
    TEST AX, AX          ; Verificar se restam mais dígitos
    JNZ CONVERT_TO_STRING; Repetir até que AX seja 0

PRINT_DIGITS:
    POP DX               ; Recuperar o próximo dígito
    MOV AH, 02h          ; Função 02h: Imprimir caractere
    INT 21h              ; Chamar interrupção do DOS
    LOOP PRINT_DIGITS    ; Repetir até que todos os dígitos sejam exibidos
    POP AX               ; Restaurar AX
    RET

CODE ENDS
END START