org 100h

.stack
    DB 2 dup(?)  ; Reserva espaço para o stack
ends stack

.data   
    Array 13 dup(?)  ; Array para armazenar números temporários

    Nota db 10,13, "Nota: Caso insira uma letra pode continuar" 
         db 10,13, "a escrever o numero pretendido pois" 
         db 10,13, "a letra nao vai afetar o calculo"
         db 10,13, " $"

    String_Barras db 10,13, "Insira o codigo de barras: $"  ; Mensagem para solicitar código de barras
    String_NIF db 10,13, "Insira o NIF: $"  ; Mensagem para solicitar NIF
    String_Cc db 10,13, "Insira o CC: $"  ; Mensagem para solicitar número de CC

    String_Menu db 10,13, " "
                db 10,13, "O que pretende fazer?"  ; Menu de operações
                db 10,13, "1: Usar de novo o mesmo algoritmo"
                db 10,13, "2: Voltar ao menu inicial"
                db 10,13, "3: Sair"
                db 10,13, "Escolha a pretendida operacao: $"
                
    String_Exit db 10,13," "
                db 10,13,"O programa terminou$"  ; Mensagem final

    Invalid db 10,13, "Numero Invalido$"  ; Mensagem de número inválido  
    Valid db 10,13, "Numero Valido$"  ; Mensagem de número válido

    Frase db 10,13,"1: Operacao de Adicao",  ; Opções de operações
          db 10,13,"2: Operacao de Subtracao",
          db 10,13,"3: Operacao de Divisao",
          db 10,13,"4: Operacao de Multiplicacao",
          db 10,13,"5: Raiz Quadrada",
          db 10,13,"6: Validacao do NIF",
          db 10,13,"7: Validacao do numero de CC",                   
          db 10,13,"8: Validacao do Codigo de Barras",
          db 10,13,"9: Sair"
          db 10,13, "Escolha a operacao pretendida: $"  ; Menu de operações de escolha

    Index db 1  ; Variável para armazenar a escolha do usuário

    Mensagem_Input db 10,13, "Insira o numero:",'$'  ; Mensagem para solicitar um número
    Mensagem_Resultado db 10,13, "Resultado:",'$'  ; Mensagem para exibir o resultado

    ArraySoma 13 dup(?)  ; Array para armazenar números para a operação de soma
    Numero_Soma dw 1  ; Número usado para somar

    ArraySubtracao 13 dup(?)  ; Array para armazenar números para a operação de subtração
    Numero_Subtracao dw 1  ; Número usado para subtrair

    Mensagem_Input_Divisao db "Insira o numero:",'$'  ; Mensagem para solicitar número na operação de divisão
    Mensagem_Resultado_Divisao db "Resultado:",'$'  ; Mensagem para exibir o resultado da divisão
                  
    Array_Divisao db 10 dup(0)  ; Array para armazenar a divisão
    
    Numero_Dividendo  db 24 dup(0)  ; Variáveis para o dividendo
    Num_Algarismos_Dividendo db 0 
    Tamanho_Dividendo db 0 
    Flag_Dividendo db 0  ; Flag para indicar se o dividendo é válido

    Numero_Divisor  db 24 dup(0)  ; Variáveis para o divisor
    Num_Algarismos_Divisor db 0 
    Tamanho_Divisor db 0
    Flag_Divisor db 0  ; Flag para indicar se o divisor é válido

    Flag_Resultado db 0  ; Flag para o resultado da operação
    Tamanho_Resultado db 0  ; Tamanho do resultado
    Num_Casas_Decimais db 0  ; Número de casas decimais
    Resultado_Divisao db 24 dup(0)  ; Resultado da operação de divisão
    Flag_Resultado_Final db 0  ; Flag para o resultado final
    Tamanho_Resultado_Final db 0  ; Tamanho do resultado final
    Valor_Resultado db 0  ; Valor do resultado

    myVar1 dw ?  ; Variável para multiplicação
    myVar2 dw ?  ; Variável para multiplicação
    Numero_Multiplicacao dw 1  ; Número usado para multiplicação
    Array_Multiplicacao 13 dup(?)  ; Array para armazenar multiplicação
         
ends data

.code
    
    Main proc  
        mov ax, @data  ; Configura o segmento de dados
        mov ds, ax  ; Configura o registrador DS
        mov bx, offset Array  ; Define o endereço do array em BX
    
        xor ax,ax  ; Limpa o registrador AX
        int 10h  ; Interrupção para controlar a tela
    
        mov ah,09h  ; Chama a função de impressão de string
        lea dx, Frase  ; Carrega o endereço da string Frase
        int 21h  ; Chama a interrupção de exibição de texto
    
        mov ah,1  ; Solicita entrada de um caractere
        int 21h  ; Chama a interrupção para ler o caractere
    
        mov [Index],al  ; Armazena o valor da tecla pressionada na variável Index
    
        call Sub_Main  ; Chama a sub-rotina para processar a operação escolhida
     
    Main endp

  
    Sub_Main proc            
        mov al,[Index]  ; Lê a escolha do usuário do índice
    
        cmp al,31h
        jl Input_Invalido  ; Se a tecla pressionada for menor que 31h, é inválida
        cmp al,39h
        jg Input_Invalido  ; Se a tecla for maior que 39h, é inválida
    
        cmp al,31h
        je Soma  ; Se for 31h (número 1), chama a sub-rotina Soma
       
        cmp al,32h
        je Subtracao  ; Se for 32h (número 2), chama a sub-rotina Subtracao
    
        cmp al,33h
        je Divisao  ; Se for 33h (número 3), chama a sub-rotina Divisao
    
        cmp al,34h
        je Multipicacao  ; Se for 34h (número 4), chama a sub-rotina Multipicacao
                  
        ; Raiz Quadrada
        ; cmp al,35h
        ; je Raiz
    
        cmp al,36h
        je NIF  ; Se for 36h (número 6), chama a sub-rotina NIF
    
        cmp al,37h
        je Cartao_Cidadao  ; Se for 37h (número 7), chama a sub-rotina Cartao_Cidadao
    
        cmp al,38h
        je Codigo_Barras  ; Se for 38h (número 8), chama a sub-rotina Codigo_Barras
    
        cmp al,39h
        je Sair  ; Se for 39h (número 9), chama a sub-rotina Sair
    
    Sub_Main endp

    Ending proc
        mov ah,09h
        lea dx,String_Menu  ; Exibe o menu de opções
        int 21h
    
        mov ah,1  ; Aguarda o input do usuário
        int 21h
    
        cmp al,31h  ; Se o usuário pressionar '1'
        je Sub_Main  ; Vai para a sub-rotina Sub_Main
    
        cmp al,32h  ; Se o usuário pressionar '2'
        je Main  ; Vai para a sub-rotina Main
    
        cmp al,33h  ; Se o usuário pressionar '3'
        je Exit  ; Vai para a sub-rotina Exit

    Ending endp

    Exit proc   
        mov ah,09h       
        lea dx,String_Exit  ; Exibe a mensagem de término do programa
        int 21h
    
        mov ah,4Ch
        int 21h  ; Finaliza o programa e retorna ao sistema operacional
    Exit endp
    
    Print_Valid proc
        mov bx, offset Array  ; Carrega o endereço de memória de Array
    
        mov ah,09h
        lea dx,Valid  ; Exibe a mensagem de "Número válido"
        int 21h
        
        jmp Ending  ; Volta para o fim
    Print_Valid endp
    
    Print_Invalid proc
        mov bx, offset Array  ; Carrega o endereço de memória de Array
    
        mov ah,09h
        lea dx,Invalid  ; Exibe a mensagem de "Número inválido"
        int 21h
    
        jmp Ending  ; Volta para o fim
    Print_Invalid endp
    
    Input_Invalido proc  
        mov ah,09h
        lea dx,Invalid  ; Exibe a mensagem de "Número inválido"
        int 21h
    
        jmp Main  ; Retorna para a execução da função principal
    Input_Invalido endp
    
    Sair proc
        mov ah,09h       
        lea dx,String_Exit  ; Exibe a mensagem de "Programa terminou"
        int 21h
    
        mov ah,4Ch
        int 21h  ; Finaliza o programa
    Sair endp
    
    Input Proc 
        call InputNum1  ; Chama a sub-rotina para ler o primeiro número
        call InputNum2  ; Chama a sub-rotina para ler o segundo número
        ret
    Input endp
    
    InputNum1 Proc
        lea bx,Numero_Dividendo  ; Carrega o endereço de "Numero_Dividendo"
        call InputNum  ; Chama a função InputNum para ler o número
        mov cl,Num_Casas_Decimais
        mov Num_Algarismos_Dividendo,cl  ; Salva o número de casas decimais
        mov cl,Tamanho_Resultado
        mov Tamanho_Dividendo,cl  ; Salva o tamanho do número
        mov cl,Flag_Resultado
        mov Flag_Dividendo,cl  ; Salva o flag de resultado
        ret
    InputNum1 endp
    
    InputNum2 Proc
        lea bx,Numero_Divisor  ; Carrega o endereço de "Numero_Divisor"
        call InputNum  ; Chama a função InputNum para ler o divisor
        mov cl,Num_Casas_Decimais
        mov Num_Algarismos_Divisor,cl  ; Salva o número de casas decimais
        mov cl,Tamanho_Resultado
        mov Tamanho_Divisor,cl  ; Salva o tamanho do divisor
        mov cl,Flag_Resultado
        mov Flag_Divisor,cl  ; Salva o flag de resultado
        ret
    InputNum2 endp
    
    InputNum Proc
        mov Num_Casas_Decimais, 0  ; Inicializa as casas decimais
        mov Flag_Resultado, 0  ; Inicializa o flag de resultado
        mov Tamanho_Resultado, 0  ; Inicializa o tamanho do resultado
    
        mov dx, offset Mensagem_Input_Divisao  ; Exibe a mensagem de input
        mov ah, 9
        int 21h
    
        mov cx, 12  ; Número máximo de caracteres para entrada
        xor dx, dx  ; Limpa o registrador DX
    
    InputNumLoop:
        mov ah, 0
        int 16h  ; Lê o próximo caractere do teclado
        cmp al, 13  ; Verifica se o caractere é Enter (13h)
        je InputNumFim  ; Se for Enter, finaliza a entrada
        cmp al, 44  ; Verifica se o caractere é vírgula (44h)
        je HandleVirgula  ; Se for vírgula, trata de forma especial
        cmp al, 45  ; Verifica se o caractere é menos (-)
        je HandleMinus  ; Se for menos, trata de forma especial
        cmp al, 48  ; Verifica se o caractere é menor que '0'
        jl InputNumLoop  ; Se for, continua o loop
        cmp al, 57  ; Verifica se o caractere é maior que '9'
        ja InputNumLoop  ; Se for, continua o loop
        mov ah, 0Eh
        int 10h  ; Exibe o caractere na tela
        sub al, 48  ; Converte o caractere para valor numérico
        mov [bx], al  ; Armazena o número em memória
        inc Tamanho_Resultado  ; Incrementa o tamanho do número
        inc bx  ; Move para a próxima posição de memória
    
        cmp Num_Casas_Decimais, 0
        je InputNumLoop  ; Se não há casas decimais, continua o loop
        inc Num_Casas_Decimais  ; Incrementa o número de casas decimais
        jmp InputNumLoop  ; Continua o loop de entrada
    
    HandleVirgula:
        cmp Num_Casas_Decimais, 0  ; Se já há casas decimais, ignora
        jne InputNumLoop
        cmp Tamanho_Resultado, 0  ; Se ainda não há números, ignora
        je InputNumLoop
        mov Num_Casas_Decimais, 1  ; Define uma casa decimal
        mov ah, 0Eh
        int 10h  ; Exibe a vírgula na tela
        jmp InputNumLoop
    
    HandleMinus:
        cmp Tamanho_Resultado, 0  ; Se não há número, ignora
        jne InputNumLoop
        cmp Flag_Resultado, 0  ; Se ainda não foi marcado o sinal negativo
        jne InputNumLoop
        mov Flag_Resultado, 1  ; Marca o sinal negativo
        mov ah, 0Eh
        int 10h  ; Exibe o sinal negativo na tela
        jmp InputNumLoop
    
    InputNumFim:
        cmp Num_Casas_Decimais, 0
        jle EndInput  ; Se não há casas decimais, finaliza
        dec Num_Casas_Decimais  ; Decrementa o número de casas decimais
    
    EndInput:
        mov al, 13
        mov ah, 0Eh
        int 10h  ; Exibe o Enter
        mov al, 10
        int 10h  ; Exibe a nova linha
        ret
    InputNum Endp
    
    OutputString Proc
        mov Num_Casas_Decimais, 0  ; Inicializa as casas decimais
        mov Flag_Resultado, 0  ; Inicializa o flag de resultado
        mov Tamanho_Resultado, 0  ; Inicializa o tamanho do resultado
        mov ch, 0
        xor dl, dl
    
        mov dl, cl
        sub dl, dh  ; Calcula a diferença entre os valores
    
    OutputStringInit:
        mov al, [bx]  ; Carrega o próximo caractere
        add al, 48  ; Converte para caractere
        mov ah, 0Eh
        int 10h  ; Exibe o caractere na tela
        inc bx  ; Avança para o próximo caractere
        cmp dl, 0  ; Verifica se o número de casas decimais foi atingido
        jle OutputStringVirgulaUpdate
        sub dl, 1  ; Decrementa o número de casas decimais
    OutputStringVirgulaUpdate:
        jne OutputStringVirgula  ; Se não for para mostrar a vírgula, continua
        mov al, 44  ; Carrega a vírgula
        mov ah, 0Eh
        int 10h  ; Exibe a vírgula
        mov dl, 20  ; Define o número de casas decimais restantes
    OutputStringVirgula:
        loop OutputStringInit  ; Continua o loop até o fim do número
    
        ret
    OutputStringNum proc
        cmp ch, 1  ; Compara o valor de ch com 1 (verificando se o número é negativo)
        jne OutString  ; Se ch não for 1, pula a parte de imprimir o sinal negativo
        mov al, 45  ; Carrega o código ASCII de '-' para sinal negativo
        mov ah, 0Eh  ; Função para exibir um caractere na tela
        int 10h  ; Interrupção para exibir o caractere
    
    OutString:
        call OutputString  ; Chama a sub-rotina OutputString para exibir o número
        ret  ; Retorna da sub-rotina
    OutputStringNum endp
    
    MostrarResultado Proc
        mov dx, offset Mensagem_Resultado_Divisao  ; Carrega o endereço da mensagem "Resultado da divisão"
        mov ah, 9  ; Função para exibir uma string na tela
        int 21h  ; Exibe a mensagem
    
        lea bx, Resultado_Divisao  ; Carrega o endereço do resultado da divisão
        mov cl, Tamanho_Resultado_Final  ; Carrega o tamanho do resultado
        mov dh, Valor_Resultado  ; Carrega o valor do resultado
        mov ch, Flag_Resultado_Final  ; Carrega o flag que indica se o resultado é negativo
        call OutputStringNum  ; Chama OutputStringNum para exibir o resultado, considerando o sinal
        ret  ; Retorna da sub-rotina
    MostrarResultado endp
    
    Converter_Digitos proc
        mov ax, dx  ; Copia o valor de dx para ax
        mov bx, 10  ; Configura o divisor para 10, para conversão decimal
    
        xor si, si  ; Zera o registrador si, que será usado como ponteiro para armazenar os dígitos
    
    Conveter_para_decimal:
        xor dx, dx  ; Zera o registrador dx (necessário para a divisão)
        div bx  ; Divide ax por 10, o resultado vai para ax e o resto para dx
        add dl, '0'  ; Converte o resto (valor numérico) para caractere ASCII
        mov [si], dl  ; Armazena o caractere em [si]
        inc si  ; Avança o ponteiro si para o próximo espaço de memória
    
        test ax, ax  ; Verifica se o valor de ax é zero (não há mais números para dividir)
        jnz Conveter_para_decimal  ; Se ax não for zero, continua o loop de conversão
    
        dec si  ; Decrementa si para apontar para o último dígito armazenado
        mov ah, 09h  ; Função para exibir uma string
        lea dx, Mensagem_Resultado  ; Carrega o endereço da mensagem "Resultado"
        int 21h  ; Exibe a mensagem
    
    Imprimir_digitos:
        mov dl, [si]  ; Carrega o próximo dígito para o registrador dl
        mov ah, 02h  ; Função para exibir um único caractere
        int 21h  ; Exibe o caractere
        dec si  ; Decrementa si para apontar para o próximo dígito
        jns Imprimir_digitos  ; Se si for positivo, continua exibindo os dígitos
    
        jmp Ending  ; Pula para o fim da sub-rotina
    Converter_Digitos endp
    
    Converter_Digitos_Multiplicacao proc
        mov ax, dx  ; Copia o valor de dx para ax
        mov bx, 10  ; Configura o divisor para 10, para conversão decimal
    
        xor si, si  ; Zera o registrador si
    
    convert_to_decimal:
        xor dx, dx  ; Zera o registrador dx (necessário para a divisão)
        div bx  ; Divide ax por 10, o resultado vai para ax e o resto para dx
        add dl, '0'  ; Converte o resto (valor numérico) para caractere ASCII
        mov [si], dl  ; Armazena o caractere em [si]
        inc si  ; Avança o ponteiro si para o próximo espaço de memória
    
        test ax, ax  ; Verifica se o valor de ax é zero
        jnz convert_to_decimal  ; Se ax não for zero, continua o loop de conversão
    
        dec si  ; Decrementa si para apontar para o último dígito armazenado
        mov ah, 09h  ; Função para exibir uma string
        lea dx, Mensagem_Resultado  ; Carrega o endereço da mensagem "Resultado"
        int 21h  ; Exibe a mensagem
    
    print_digits:
        mov dl, [si]  ; Carrega o próximo dígito para o registrador dl
        mov ah, 02h  ; Função para exibir um único caractere
        int 21h  ; Exibe o caractere
        dec si  ; Decrementa si para apontar para o próximo dígito
        jns print_digits  ; Se si for positivo, continua exibindo os dígitos
    
        jmp Ending  ; jump para o fim da sub-rotina
    Converter_Digitos_Multiplicacao endp


    
    Soma proc

      xor ax, ax
      int 10h ; Limpa a tela

      mov SI, offset ArraySoma ; Inicializa o ponteiro para o array que armazenará os números inseridos
      xor cx, cx              ; Zera o cx
      xor bx, bx              ; Zera o registrador BX 

    Restart:
      mov SI, offset ArraySoma ; Reinicializa o ponteiro para o início do array
      mov ah, 09h
      lea dx, Mensagem_Input   ; Exibe a mensagem pedindo a entrada do número
      int 21h

    Armazenar_Ler_Numeros:
      mov [Numero_Soma], di    ; Armazena o valor acumulado até agora em DI
      mov ah, 1
      int 21h                  ; Lê um caractere do teclado
      cmp al, 0Dh              ; Verifica se a tecla "Enter" foi pressionada
      je Verificar_Soma        ; Vai para a soma se "Enter" for pressionado
      sub al, 30h              ; Converte o caractere ASCII para valor numérico
      cmp al, 0
      jl Armazenar_Ler_Numeros ; Ignora valores menores que '0'
      cmp al, 9
      jg Armazenar_Ler_Numeros ; Ignora valores maiores que '9'
      mov [SI], al             ; Armazena o valor no array
      inc SI                   ; Move para a próxima posição do array
      inc cx                   ; Incrementa o contador de números
      jmp Armazenar_Ler_Numeros ; Continua lendo os números

    Verificar_Soma:
      mov SI, offset ArraySoma ; Reinicia o ponteiro para o início do array
      mov dx, di               ; Salva o valor de DI em DX
      xor di, di               ; 
      xor ax, ax               ; 

    Loop_Tag:
      mov dx, [si]             ; Carrega o próximo valor do array
      mov bl, 10               ; Prepara para multiplicar por 10 (posição decimal)
      mul bl                   ; Multiplica AX por 10
      add ax, dx               ; Soma o valor ao acumulador
      inc si                   ; Avança para o próximo número no array
      cmp si, offset ArraySoma + cl ; Verifica se todos os números foram processados
      loop Loop_Tag            ; Repete até processar todos os números

      mov di, ax               ; Armazena o resultado acumulado em DI
      mov dx, [Numero_Soma]    ; Recupera o valor inicial de DX
      cmp dx, 0                ; Verifica se é necessário reiniciar
      je Restart               ; Reinicia se o valor for zero

    Final:
      add dx, ax               ; Soma o valor acumulado ao total
      mov cx, dx               ; Armazena o resultado em CX
      call Converter_Digitos   ; Converte o valor numérico em dígitos ASCII para exibição
      mov ah, 02h
      mov dx, cx               ; Exibe o resultado
      int 21h
      jmp Ending               ; Volta para o fim do programa

    Soma endp

    
    ;Subtracao
    Subtracao proc
        xor ax,ax
        int 10h ; Limpa a tela

        mov SI, offset ArraySubtracao ; Inicializa o ponteiro para o array onde os números serão armazenados
        xor cx,cx
        xor bx,bx

    Restart_Subtracao:
        mov SI, offset ArraySubtracao ; Reinicializa o ponteiro para o início do array
        mov ah, 09h
        lea dx, Mensagem_Input        ; Exibe a mensagem pedindo a entrada do número
        int 21h

    Armazenar_Ler_Numeros_Subtracao:
        mov [Numero_Subtracao],di     ; Armazena o valor acumulado até agora em DI
        mov ah,1
        int 21h                       ; Lê um caractere do teclado
        cmp al,0Dh                    ; Verifica se a tecla "Enter" foi pressionada
        je Verificar_Subtracao        ; Vai para a verificação se "Enter" for pressionado
        sub al,30h                    ; Converte o caractere ASCII para valor numérico
        cmp al,0
        jl Armazenar_Ler_Numeros_Subtracao ; Ignora valores menores que '0'
        cmp al,9
        jg Armazenar_Ler_Numeros_Subtracao ; Ignora valores maiores que '9'
        mov [SI], al                  ; Armazena o valor no array
        INC SI                        ; Move para a próxima posição do array
        INC cx                        ; Incrementa o contador de números
        jmp Armazenar_Ler_Numeros_Subtracao ; Continua lendo os números

    Verificar_Subtracao:
        mov SI, offset ArraySubtracao ; Reinicia o ponteiro para o início do array
        mov dx,di                     ; Salva o valor acumulado em DI para DX
        xor di,di
        xor ax,ax

    Loop_Tag_Subtracao: 
        mov dx, [si]                  ; Carrega o próximo valor do array
        mov bl, 10                    ; Prepara para multiplicar por 10 (posição decimal)
        mul bl                        ; Multiplica AX por 10
        add ax, dx                    ; Soma o valor ao acumulador
        inc si                        ; Avança para o próximo número no array
        cmp si, offset ArraySubtracao + cl ; Verifica se todos os números foram processados
        loop Loop_Tag_Subtracao       ; Repete até processar todos os números

        mov di,ax                     ; Armazena o resultado acumulado em DI
        mov dx, [Numero_Subtracao]    ; Recupera o valor inicial de DX
        cmp dx,0                      ; Verifica se é necessário reiniciar
        je Restart_Subtracao          ; Reinicia se o valor for zero

     Final_Subtracao:
        sub dx,ax                     ; Subtrai o valor acumulado do número inicial
        call Converter_Digitos        ; Converte o valor numérico em dígitos ASCII para exibição
        mov ah,02h
        mov dl,dl                     ; Exibe o resultado
        int 21h

    Subtracao endp


   Divisao proc
    xor ax,ax              ; Zera o registrador ax
    int 10h                 ; Chama a interrupção de vídeo (não utilizada no código diretamente)
    call Input              ; Chama a função para receber os dados de entrada
    call Preencher_Array    ; Preenche o array com valores baseados no divisor
    call Realizar_Divisao   ; Realiza a operação de divisão
    call Calcular_CasasDecimais_Resultado ; Calcula as casas decimais do resultado
    call Configurar_Resultado ; Configura o formato do resultado final
    call MostrarResultado   ; Mostra o resultado
    Divisao endp
    
    Realizar_Divisao Proc
        xor dx,dx              ; Zera o registrador dx
        xor ax,ax              ; Zera o registrador ax
        xor si,si              ; Zera o registrador si (índice)
        mov ch,10              ; Define o valor de ch como 10 (base decimal)
        xor ah,ah              ; Zera o registrador ah
        xor bx,bx              ; Zera o registrador bx
        mov bl,dl              ; Move o valor de dl para bl
        mul ch                  ; Multiplica ax por 10 (base decimal)
    Divisao1:
        add al,[Numero_Dividendo +bx] ; Adiciona o valor do número dividendo ao registrador al
        inc bx                  ; Incrementa o índice do número dividendo
        mov dl,bl               ; Restaura o valor de bl para dl
        cmp cl,al               ; Compara o valor de al com cl
        jle DivisaoInternofora  ; Se al for menor ou igual a cl, pula para a próxima parte
        mul ch                  ; Multiplica novamente por 10
        cmp bl,12               ; Se o valor de bl for igual a 12, finaliza a divisão
        je DivisaoFim
        jmp Divisao1            ; Repete a operação de divisão
    
    DivisaoInic:
        xor ah,ah               ; Zera o registrador ah
        xor bx,bx               ; Zera o registrador bx
        mov bl,dl               ; Restaura o valor de dl em bl
        mul ch                  ; Multiplica novamente por 10
    DivisaoInterno:
        add al,[Numero_Dividendo +bx] ; Adiciona o número dividendo ao registrador al
        inc bx                  ; Incrementa o índice
        mov dl,bl               ; Restaura o valor de bl em dl
        cmp cl,al               ; Compara al com cl
        jle DivisaoInternofora  ; Se al for menor ou igual a cl, sai do loop
        mov dh,0                ; Zera dh (registro de divisão)
        mov [Resultado_Divisao +si],dh ; Armazena o resultado parcial na memória
        inc si                  ; Incrementa o índice de resultado
        mul ch                  ; Multiplica novamente
        cmp bl,12               ; Se o valor de bl for 12, finaliza
        je DivisaoFim
        jmp DivisaoInterno      ; Repete a operação interna de divisão
    
    DivisaoInternofora:
        xor bx,bx               ; Zera o registrador bx
    
    DivisaoAchaMutiplo:
        mov ah,cl               ; Atribui o valor de cl a ah
        add ah,[Array_Divisao+bx] ; Adiciona o valor do array de divisão a ah
        cmp al,ah               ; Compara al com ah
        jl DivisaoAchaMutiploFora ; Se al for menor que ah, sai do loop
        cmp bx,9                ; Se bx for maior ou igual a 9, sai do loop
        jae DivisaoAchaMutiploFora
        inc bx                  ; Incrementa bx
        jmp DivisaoAchaMutiplo  ; Continua buscando o múltiplo
    
    DivisaoAchaMutiploFora:
        mov [Resultado_Divisao +si],bl ; Armazena o resultado final
        inc si                  ; Incrementa o índice
        sub al,[Array_Divisao+bx] ; Subtrai o valor encontrado
        cmp dl,12               ; Se dl for menor que 12, repete a divisão
        jl DivisaoInic
    
    DivisaoFim:
        mov ax,si               ; Armazena o valor de si em ax
        mov Tamanho_Resultado_Final,al ; Armazena o tamanho final do resultado
        ret
    Realizar_Divisao endp
    
    Preencher_Array Proc
        call Calcular_ValorNum2  ; Calcula o valor numérico do divisor
        xor bx,bx                ; Zera o registrador bx
        mov bl,9                 ; Define o valor 9 para o loop
        mov cx,ax                ; Armazena o valor de ax em cx
    inicPreencherm:
        mul bx                   ; Multiplica o valor de ax por bx
        mov [Array_Divisao+bx],al ; Armazena o valor de al no array de divisão
        cmp bx,0                 ; Verifica se o valor de bx é zero
        je Preenchermfim         ; Se for zero, finaliza o preenchimento
        sub bx,1                 ; Decrementa bx
        mov ax,cx                ; Restaura o valor de cx em ax
        jmp inicPreencherm       ; Continua preenchendo o array
    Preenchermfim:
        ret
    Preencher_Array endp
    
    Calcular_ValorNum2 Proc
        xor bx,bx                ; Zera bx
        mov dl,Tamanho_Divisor    ; Define o tamanho do divisor
        sub dl,1                 ; Decremente o valor de dl
        mov cl,10                ; Define a base 10
        xor ax,ax                ; Zera ax
    
    InicioCalculo:
        add al,[Numero_Divisor+bx] ; Adiciona o valor do número divisor
        cmp bl,dl                ; Compara se o índice chegou ao fim
        je FimCalculo            ; Se chegou ao fim, finaliza
        inc bx                   ; Incrementa bx
        mul cl                   ; Multiplica ax pela base
        jmp InicioCalculo        ; Repete o cálculo
    
    FimCalculo:
        ret
    Calcular_ValorNum2 endp
    
    Calcular_CasasDecimais_Resultado proc
        mov al,Tamanho_Divisor    ; Obtém o tamanho do divisor
        sub al,1
        mov ah,Tamanho_Dividendo  ; Obtém o tamanho do dividendo
        sub al,Num_Algarismos_Divisor ; Calcula a diferença
        sub ah,Num_Algarismos_Dividendo
        sub ah,al
        mov al,Tamanho_Resultado_Final ; Define o tamanho final do resultado
        sub al,ah                  ; Ajusta o valor final
        mov Valor_Resultado,al     ; Armazena o valor final
        call Comparacao            ; Realiza a comparação
        ret
    Calcular_CasasDecimais_Resultado endp
    
    Comparacao proc
        xor bx,bx                ; Zera bx
        xor cx,cx                ; Zera cx
        mov cl,Tamanho_Divisor    ; Define o tamanho do divisor
        sub cl,Num_Algarismos_Divisor ; Ajusta o tamanho do divisor
    Comparacaoinic:
        mov ah,[Numero_Dividendo+bx] ; Compara cada dígito do dividendo
        mov al,[Numero_Divisor+bx]   ; Compara cada dígito do divisor
        inc bx                      ; Incrementa o índice
        cmp ah,al                   ; Compara os valores
        jl ComparacaoLabel          ; Se ah for menor que al, vai para o rótulo
        cmp bx,cx                   ; Compara se bx chegou ao final
        jle Comparacaoinic          ; Se não chegou ao final, repete a comparação
    
        ret
    ComparacaoLabel:
        mov al,1                   ; Se os valores foram diferentes, marca a diferença
        add Valor_Resultado,al      ; Atualiza o valor final
        ret
    Comparacao endp
    
    Configurar_Resultado proc
        mov al,Tamanho_Resultado_Final ; Obtém o tamanho do resultado final
        mov ah,Valor_Resultado         ; Obtém o valor calculado
        cmp al,ah                      ; Compara os dois valores
        jne Configurar_Resultadoaqui   ; Se forem diferentes, ajusta
        lea bx,Resultado_Divisao      ; Carrega o endereço do resultado
        add bl,Tamanho_Resultado_Final ; Ajusta o ponteiro
        sub bx,1
        mov ax,1
        mov cl,Tamanho_Resultado_Final ; Define o número de zeros a adicionar
        call Add_Zeros                ; Chama a função para adicionar zeros
        mov ax,1
        add Tamanho_Resultado_Final,al ; Atualiza o tamanho final
    Configurar_Resultadoaqui:
        ret
    Configurar_Resultado endp
    
    
        Add_Zeros proc
        inic:    
            mov  dh,[bx]          ; Armazena o valor de [bx] em dh
            mov [bx],0            ; Zera o valor em [bx]
            add bx,ax             ; Soma o valor de ax ao ponteiro bx
            mov [bx],dh           ; Armazena o valor de dh em [bx]
            sub bx,ax             ; Subtrai o valor de ax de bx
            sub bx,1              ; Decremente o valor de bx
            loop inic             ; Repete o loop até cx ser zero
            ret
    Add_Zeros endp
    
    Multipicacao proc
        xor ax,ax              ; Zera o registrador ax
        int 10h                 ; Chama a interrupção de vídeo (não utilizada no código diretamente)
    
        mov SI, offset Array_Multiplicacao ; Define o ponteiro SI para o array de multiplicação
        xor cx,cx              ; Zera cx (contador)
        xor bx,bx              ; Zera bx
    
        Restart_Multiplicacao:  
            mov SI, offset Array_Multiplicacao ; Restaura o ponteiro SI
            mov ah, 09h          ; Chama a interrupção para mostrar uma mensagem
            lea dx, Mensagem_Input
            int 21h              ; Exibe a mensagem de entrada
    
        Armazenar_Ler_Numeros_Multi:
            mov [Numero_Multiplicacao],di ; Armazena o valor de di em Numero_Multiplicacao
            mov ah,1              ; Chama a interrupção 21h para ler um caractere
            int 21h
            cmp al,0Dh            ; Verifica se pressionaram Enter
            je Verificar_Multiplicacao ; Se sim, vai verificar a multiplicação
            sub al,30h            ; Converte o valor de al de ASCII para valor numérico
            cmp al,0              ; Verifica se o valor é menor que 0
            jl Armazenar_Ler_Numeros_Multi ; Se for, repete a leitura
            cmp al,9              ; Verifica se o valor é maior que 9
            jg Armazenar_Ler_Numeros_Multi ; Se for, repete a leitura
            mov [SI], al          ; Armazena o valor de al em [SI]
            INC SI                ; Incrementa o ponteiro SI
            INC cx                ; Incrementa o contador cx
            jmp Armazenar_Ler_Numeros_Multi ; Continua o loop
    
        Verificar_Multiplicacao:
            mov SI, offset Array_Multiplicacao ; Restaura o ponteiro SI
            mov dx,di             ; Restaura o valor de di em dx
            xor di,di             ; Zera di
            xor ax,ax             ; Zera ax
    
        Loop_Tag_Multiplicacao:
            mov dx, [si]          ; Move o valor de [si] para dx
            mov bl, 10            ; Define o valor 10 (base decimal)
            mul bl                ; Multiplica ax por 10
            add ax, dx            ; Soma o valor de dx a ax
            inc si                ; Incrementa o ponteiro si
            cmp si, offset Array_Multiplicacao + cl ; Verifica se chegou ao final do array
            loop Loop_Tag_Multiplicacao ; Continua o loop até cx ser zero
    
            mov di,ax             ; Move o valor final para di
            mov dx, [Numero_Multiplicacao] ; Restaura o valor de Numero_Multiplicacao em dx
            cmp dx,0              ; Verifica se o valor de dx é zero
            je Restart_Multiplicacao ; Se for zero, reinicia a multiplicação
    
        Final_Multiplicacao:
            mul dx                ; Multiplica ax por dx
            mov myVar1, dx        ; Armazena o valor de dx em myVar1
            mov myVar2, ax        ; Armazena o valor de ax em myVar2
            mov dx, myVar2        ; Move o valor de myVar2 para dx
            call Converter_Digitos_Multiplicacao ; Converte os dígitos para formato adequado
            mov ah,02h            ; Chama a interrupção para imprimir um caractere
            mov dx,cx             ; Move o valor de cx para dx
            int 21h               ; Exibe o caractere
            mov ah,4Ch            ; Chama a interrupção para finalizar o programa
            int 21h
    
        Multipicacao endp    
    
        NIF proc     
        INC SI                   ; Incrementa o valor de SI
        xor ax,ax                ; Zera o registrador ax
        int 10h                   ; Chama a interrupção de vídeo (não utilizada diretamente)
        mov al,[Index]           ; Move o valor de [Index] para al
        cmp al,37h               ; Compara o valor de al com 37h (caractere '7' em ASCII)
        je Nif_E_Cc              ; Se for igual, vai para Nif_E_Cc
    
        Nif_Only:        
        mov ah,09h               ; Exibe uma mensagem de texto
        lea dx, Nota             ; Carrega o endereço de Nota
        int 21h                   ; Exibe a mensagem
        mov ah,09h               ; Exibe outra mensagem de texto
        lea dx,String_NIF        ; Carrega o endereço de String_NIF
        int 21h                   ; Exibe a mensagem 
        jmp Ler_Numeros          ; Vai para a parte de ler os números
    
        ends Nif_Only
    
        
        Nif_E_Cc:
        mov ah,09h               ; Exibe uma mensagem (String_Cc)
        lea dx,String_Cc          ; Carrega o endereço de String_Cc
        int 21h                   ; Exibe a mensagem
    ends Nif_E_Cc 
    
    Ler_Numeros:
        mov ah,1                  ; Lê um caractere da entrada
        int 21h
        cmp al,8h                 ; Verifica se o caractere é 'Backspace' (8h)
        jne Passing_Nif           ; Se não for, vai para Passing_Nif
        call Delete_Digit         ; Chama a função para deletar o dígito
        cmp SI,1                  ; Verifica o valor de SI
        je Continu                ; Se for igual a 1, vai para Continu
        DEC SI                     ; Decrementa o valor de SI
    Continu:
        jmp Ler_Numeros           ; Repete o loop para ler o próximo número
    Passing_Nif:
        INC SI                     ; Incrementa o valor de SI
        sub al,30h                 ; Converte o valor de al de ASCII para numérico
        cmp al,0                   ; Verifica se o número é menor que 0
        jl Ler_Numeros             ; Se for, repete a leitura
        cmp al,9                   ; Verifica se o número é maior que 9
        jg Ler_Numeros             ; Se for, repete a leitura
        DEC SI                     ; Decrementa o valor de SI
        mov [bx], al               ; Armazena o valor de al em [bx]
        INC bx                     ; Incrementa o ponteiro bx
        cmp bx, offset Array+9     ; Verifica se o ponteiro bx alcançou o final do array
        jl Ler_Numeros             ; Se não, continua o loop
        mov bx, offset Array       ; Se sim, redefine o ponteiro bx para o início do array
    ends Ler_Numeros
    
    xor cx,cx                     ; Zera o contador cx
    mov dl, 9                      ; Inicializa dl com 9 (usado para multiplicação)
    checksum:
        mov al,0
        mov al,[bx]               ; Move o valor de [bx] para al
        mul dl                     ; Multiplica al por dl
        add cx,ax                  ; Soma o resultado de ax a cx
        DEC dl                     ; Decrementa dl
        INC bx                     ; Incrementa o ponteiro bx
        cmp dl,0                   ; Verifica se dl chegou a 0
        jg checksum                ; Se não, repete o loop
        xor dx,dx                  ; Zera dx
        mov ax,cx                  ; Move o valor de cx para ax
        mov cl,11                  ; Define o divisor (11) para o cálculo do checksum
        div cl                      ; Divide ax por 11
        mov cl, [Index]            ; Carrega o valor de Index em cl
        cmp cl,37h                 ; Compara com 37h (caractere '7' em ASCII)
        je Nif_Inside_Cc           ; Se for igual, vai para Nif_Inside_Cc
        cmp ah,0                   ; Verifica o valor do resto (ah)
        je Print_Valid             ; Se for zero, imprime "válido"
        jne Print_Invalid          ; Se não for zero, imprime "inválido"
    
    Nif_Inside_Cc: 
        ret                        ; Retorna da função NIF
    NIF endp
    
    Cartao_Cidadao proc
        call Nif                   ; Chama a função Nif
        cmp ah,0                   ; Verifica o valor de ah (checksum)
        jne Print_Invalid          ; Se não for zero, imprime "inválido"
        mov bx, offset Array+9     ; Define o ponteiro bx para o final do array
        lettersAndNumbers:
            xor ax,ax              ; Zera o registrador ax
            mov ah,1               ; Lê um caractere
            int 21h
            cmp al,8h              ; Verifica se é 'Backspace'
            jne Passing_Cc          ; Se não for, vai para Passing_Cc
            call Delete_Digit       ; Chama a função para deletar o dígito
            cmp SI,1                ; Verifica o valor de SI
            je Continuing           ; Se for 1, vai para Continuing
            DEC SI                  ; Decrementa SI
    Continuing:
            jmp lettersAndNumbers   ; Continua o loop de leitura
    Passing_Cc:
        INC SI                       ; Incrementa SI
        cmp al,30h                   ; Verifica se o caractere é numérico (menor que 30h)
        jl lettersAndNumbers         ; Se for, continua o loop
        cmp al,39h                   ; Verifica se o caractere é numérico (maior que 39h)
        jg letters                    ; Se for, vai para a parte de letras
        cmp al,3Ah                   ; Verifica se o caractere é ':' (separador)
        jl numbers                   ; Se for, vai para a parte numérica
    letters:
        cmp al, 41h                  ; Verifica se é uma letra maiúscula (A-Z)
        jl lettersAndNumbers         ; Se for menor que A, continua o loop
        cmp al, 5Ah                  ; Verifica se é uma letra maiúscula (A-Z)
        jg lettersAndNumbers         ; Se for maior que Z, continua o loop
        sub al, 7h                   ; Converte letra de maiúscula para número
    numbers:
        DEC SI                       ; Decrementa SI
        sub al, 30h                  ; Converte o caractere de ASCII para numérico
        mov [bx], al                 ; Armazena o valor de al em [bx]
        INC bx                       ; Incrementa o ponteiro bx
        xor ax,ax                    ; Zera ax
        cmp bx, offset Array+11      ; Verifica se o ponteiro bx alcançou o final do array
        jl lettersAndNumbers         ; Se não, continua o loop
    
    finalChecksum:
        mov ah,1                     ; Lê um caractere
        int 21h
        cmp al,8h                    ; Verifica se é 'Backspace'
        jne Passing_Cartao           ; Se não for, vai para Passing_Cartao
        call Delete_Digit            ; Chama a função para deletar o dígito
        cmp bx, offset Array+12      ; Verifica se o ponteiro bx chegou ao limite
        jl lettersAndNumbers         ; Se não, continua o loop
        cmp SI,1                     ; Verifica o valor de SI
        je Conti                     ; Se for igual a 1, vai para Conti
        DEC SI                        ; Decrementa SI
    Conti:
        jmp finalChecksum             ; Continua o loop de verificação
    
    Passing_Cartao:
        INC SI                        ; Incrementa SI
        sub al,30h                    ; Converte o caractere de ASCII para numérico
        cmp al,0                      ; Verifica se é 0
        jl finalChecksum              ; Se for, continua o loop
        cmp al,9                      ; Verifica se é 9
        jg finalChecksum              ; Se for maior que 9, continua o loop
        DEC SI                        ; Decrementa SI
        mov [bx], al                  ; Armazena o valor de al em [bx]
        mov bx, offset Array         ; Restaura o ponteiro bx para o início do array
        mov dl,2                      ; Define o valor 2 (usado para multiplicação)
        mov cx,0                      ; Zera o contador cx
    addition:
        mov al,0                      ; Zera o registrador al
        mov al,[bx]                   ; Move o valor de [bx] para al
        mul dl                         ; Multiplica al por dl
        cmp ax,10                     ; Verifica se o resultado é maior que 10
        jl continue                   ; Se for, continua
        sub ax,9                      ; Subtrai 9 para ajustar o valor
    continue:
        add cx,ax                     ; Soma o resultado a cx
        add bx,2                      ; Incrementa o ponteiro bx
        cmp bx, offset Array+11       ; Verifica se o ponteiro bx chegou ao final
        jl addition                   ; Se não, continua o loop de adição
    
    ends addition
    mov bx, offset Array+1          ; Define o ponteiro bx para o segundo elemento do array
    
    finalAddition:
        mov ax,0                   ; Zera o registrador ax
        mov al,[bx]                 ; Move o valor de [bx] para al
        add cl,al                   ; Adiciona al ao contador cl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx, offset Array+12     ; Verifica se o ponteiro bx alcançou o final do array
        jl finalAddition            ; Se não, repete a adição
        mov ax,cx                   ; Move o valor de cx para ax
        mov cl,10                   ; Define o divisor (10)
        div cl                       ; Divide ax por 10
        cmp ah,0                    ; Verifica o valor do resto (ah)
        je Print_Valid              ; Se for zero, imprime "válido"
        jne Print_Invalid           ; Se não for zero, imprime "inválido"
    ends finalAddition
    
    Cartao_Cidadao endp
    
    Codigo_Barras proc
        INC SI                      ; Incrementa o valor de SI
        mov ax,0
        int 10h
        mov ah,09h                  ; Exibe uma mensagem (String_Barras)
        lea dx,String_Barras         ; Carrega o endereço de String_Barras
        int 21h
    
    Ler_Console:
        mov ah,1                    ; Lê um caractere
        int 21h
        cmp al,8h                   ; Verifica se o caractere é 'Backspace' (8h)
        jne Passing_Bar             ; Se não for, vai para Passing_Bar
        call Delete_Digit           ; Chama a função para deletar o dígito
        cmp SI,1                    ; Verifica o valor de SI
        je Continue_Bar             ; Se for 1, vai para Continue_Bar
        DEC SI                      ; Decrementa SI
    Continue_Bar:
        jmp Ler_Console             ; Continua o loop de leitura
    
    Passing_Bar:
        INC SI                      ; Incrementa SI
        sub al,30h                  ; Converte o valor de al de ASCII para numérico
        cmp al,0                    ; Verifica se o número é menor que 0
        jl Ler_Console              ; Se for, repete a leitura
        cmp al,9                    ; Verifica se o número é maior que 9
        jg Ler_Console              ; Se for, repete a leitura
        DEC SI                      ; Decrementa SI
        mov [bx], al                ; Armazena o valor de al em [bx]
        INC bx                      ; Incrementa o ponteiro bx
        cmp bx, offset Array+13     ; Verifica se o ponteiro bx alcançou o limite
        jl Ler_Console              ; Se não, continua o loop
    ends Ler_Console
    
        mov bx, offset Array+1      ; Define o ponteiro bx para o segundo elemento do array
        xor ax,ax                   ; Zera o registrador ax
        xor cx,cx                   ; Zera o contador cx
        xor dx,dx                   ; Zera o registrador dx
        mov cl,3                    ; Define o valor de cl como 3 (usado para multiplicação)
    
    Second_Verification:
        mov al,[bx]                 ; Move o valor de [bx] para al
        add dl,al                   ; Adiciona al a dl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx,offset Array+12      ; Verifica se o ponteiro bx alcançou o final
        jl Second_Verification      ; Se não, repete o loop
        mov al,dl                   ; Move o valor de dl para al
        xor dx,dx                   ; Zera dx
        mul cl                       ; Multiplica al por cl
        add dx,ax                   ; Soma o resultado de ax a dx
    ends Second_Verification
    
        mov bx, offset Array        ; Define o ponteiro bx para o início do array
        xor ax,ax                   ; Zera o registrador ax
    
    Verification:
        mov al,[bx]                 ; Move o valor de [bx] para al
        add dl,al                   ; Adiciona al a dl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx,offset Array+13      ; Verifica se o ponteiro bx alcançou o limite
        jl Verification             ; Se não, repete o loop
    ends Verification
    
        mov ax,dx                   ; Move o valor de dx para ax
        mov cl,10                   ; Define o divisor (10)
        div cl                       ; Divide ax por 10
        cmp ah,0                    ; Verifica o valor do resto (ah)
        je Print_Valid              ; Se for zero, imprime "válido"
        jne Print_Invalid           ; Se não for zero, imprime "inválido"
    ends Codigo_Barras
    
    Delete_Digit proc
        mov dl,20h                  ; Define o caractere de espaço (20h)
        mov ah,02h                  ; Função de exibição de caractere
        int 21h
        cmp SI,1                    ; Verifica se SI é igual a 1
        jne Comparison              ; Se não for, vai para Comparison
        cmp bx,offset Array         ; Verifica se bx alcançou o início do array
        je Return                   ; Se for, retorna da função
        DEC bx                      ; Decrementa o ponteiro bx
    
    Comparison:
        mov dl,8h                   ; Define o caractere 'Backspace' (8h)
        mov ah,02h                  ; Função de exibição de caractere
        int 21h
    Return:
        ret                         ; Retorna da função Delete_Digit
    
    ends Delete_Digit
