org 100h

.stack
    DB 2 dup(?)  ; Reserva espa�o para o stack
ends stack

.data   
    Array 13 dup(?)  ; Array para armazenar n�meros tempor�rios

    Nota db 10,13, "Nota: Caso insira uma letra pode continuar" 
         db 10,13, "a escrever o numero pretendido pois" 
         db 10,13, "a letra nao vai afetar o calculo"
         db 10,13, " $"

    String_Barras db 10,13, "Insira o codigo de barras: $"  ; Mensagem para solicitar c�digo de barras
    String_NIF db 10,13, "Insira o NIF: $"  ; Mensagem para solicitar NIF
    String_Cc db 10,13, "Insira o CC: $"  ; Mensagem para solicitar n�mero de CC

    String_Menu db 10,13, " "
                db 10,13, "O que pretende fazer?"  ; Menu de opera��es
                db 10,13, "1: Usar de novo o mesmo algoritmo"
                db 10,13, "2: Voltar ao menu inicial"
                db 10,13, "3: Sair"
                db 10,13, "Escolha a pretendida operacao: $"
                
    String_Exit db 10,13," "
                db 10,13,"O programa terminou$"  ; Mensagem final

    Invalid db 10,13, "Numero Invalido$"  ; Mensagem de n�mero inv�lido  
    Valid db 10,13, "Numero Valido$"  ; Mensagem de n�mero v�lido

    Frase db 10,13,"1: Operacao de Adicao",  ; Op��es de opera��es
          db 10,13,"2: Operacao de Subtracao",
          db 10,13,"3: Operacao de Divisao",
          db 10,13,"4: Operacao de Multiplicacao",
          db 10,13,"5: Raiz Quadrada",
          db 10,13,"6: Validacao do NIF",
          db 10,13,"7: Validacao do numero de CC",                   
          db 10,13,"8: Validacao do Codigo de Barras",
          db 10,13,"9: Sair"
          db 10,13, "Escolha a operacao pretendida: $"  ; Menu de opera��es de escolha

    Index db 1  ; Vari�vel para armazenar a escolha do usu�rio

    Mensagem_Input db 10,13, "Insira o numero:",'$'  ; Mensagem para solicitar um n�mero
    Mensagem_Resultado db 10,13, "Resultado:",'$'  ; Mensagem para exibir o resultado

    ArraySoma 13 dup(?)  ; Array para armazenar n�meros para a opera��o de soma
    Numero_Soma dw 1  ; N�mero usado para somar

    ArraySubtracao 13 dup(?)  ; Array para armazenar n�meros para a opera��o de subtra��o
    Numero_Subtracao dw 1  ; N�mero usado para subtrair

    Mensagem_Input_Divisao db "Insira o numero:",'$'  ; Mensagem para solicitar n�mero na opera��o de divis�o
    Mensagem_Resultado_Divisao db "Resultado:",'$'  ; Mensagem para exibir o resultado da divis�o
                  
    Array_Divisao db 10 dup(0)  ; Array para armazenar a divis�o
    
    Numero_Dividendo  db 24 dup(0)  ; Vari�veis para o dividendo
    Num_Algarismos_Dividendo db 0 
    Tamanho_Dividendo db 0 
    Flag_Dividendo db 0  ; Flag para indicar se o dividendo � v�lido

    Numero_Divisor  db 24 dup(0)  ; Vari�veis para o divisor
    Num_Algarismos_Divisor db 0 
    Tamanho_Divisor db 0
    Flag_Divisor db 0  ; Flag para indicar se o divisor � v�lido

    Flag_Resultado db 0  ; Flag para o resultado da opera��o
    Tamanho_Resultado db 0  ; Tamanho do resultado
    Num_Casas_Decimais db 0  ; N�mero de casas decimais
    Resultado_Divisao db 24 dup(0)  ; Resultado da opera��o de divis�o
    Flag_Resultado_Final db 0  ; Flag para o resultado final
    Tamanho_Resultado_Final db 0  ; Tamanho do resultado final
    Valor_Resultado db 0  ; Valor do resultado

    myVar1 dw ?  ; Vari�vel para multiplica��o
    myVar2 dw ?  ; Vari�vel para multiplica��o
    Numero_Multiplicacao dw 1  ; N�mero usado para multiplica��o
    Array_Multiplicacao 13 dup(?)  ; Array para armazenar multiplica��o
         
ends data

.code
    
    Main proc  
        mov ax, @data  ; Configura o segmento de dados
        mov ds, ax  ; Configura o registrador DS
        mov bx, offset Array  ; Define o endere�o do array em BX
    
        xor ax,ax  ; Limpa o registrador AX
        int 10h  ; Interrup��o para controlar a tela
    
        mov ah,09h  ; Chama a fun��o de impress�o de string
        lea dx, Frase  ; Carrega o endere�o da string Frase
        int 21h  ; Chama a interrup��o de exibi��o de texto
    
        mov ah,1  ; Solicita entrada de um caractere
        int 21h  ; Chama a interrup��o para ler o caractere
    
        mov [Index],al  ; Armazena o valor da tecla pressionada na vari�vel Index
    
        call Sub_Main  ; Chama a sub-rotina para processar a opera��o escolhida
     
    Main endp

  
    Sub_Main proc            
        mov al,[Index]  ; L� a escolha do usu�rio do �ndice
    
        cmp al,31h
        jl Input_Invalido  ; Se a tecla pressionada for menor que 31h, � inv�lida
        cmp al,39h
        jg Input_Invalido  ; Se a tecla for maior que 39h, � inv�lida
    
        cmp al,31h
        je Soma  ; Se for 31h (n�mero 1), chama a sub-rotina Soma
       
        cmp al,32h
        je Subtracao  ; Se for 32h (n�mero 2), chama a sub-rotina Subtracao
    
        cmp al,33h
        je Divisao  ; Se for 33h (n�mero 3), chama a sub-rotina Divisao
    
        cmp al,34h
        je Multipicacao  ; Se for 34h (n�mero 4), chama a sub-rotina Multipicacao
                  
        ; Raiz Quadrada
        ; cmp al,35h
        ; je Raiz
    
        cmp al,36h
        je NIF  ; Se for 36h (n�mero 6), chama a sub-rotina NIF
    
        cmp al,37h
        je Cartao_Cidadao  ; Se for 37h (n�mero 7), chama a sub-rotina Cartao_Cidadao
    
        cmp al,38h
        je Codigo_Barras  ; Se for 38h (n�mero 8), chama a sub-rotina Codigo_Barras
    
        cmp al,39h
        je Sair  ; Se for 39h (n�mero 9), chama a sub-rotina Sair
    
    Sub_Main endp

    Ending proc
        mov ah,09h
        lea dx,String_Menu  ; Exibe o menu de op��es
        int 21h
    
        mov ah,1  ; Aguarda o input do usu�rio
        int 21h
    
        cmp al,31h  ; Se o usu�rio pressionar '1'
        je Sub_Main  ; Vai para a sub-rotina Sub_Main
    
        cmp al,32h  ; Se o usu�rio pressionar '2'
        je Main  ; Vai para a sub-rotina Main
    
        cmp al,33h  ; Se o usu�rio pressionar '3'
        je Exit  ; Vai para a sub-rotina Exit

    Ending endp

    Exit proc   
        mov ah,09h       
        lea dx,String_Exit  ; Exibe a mensagem de t�rmino do programa
        int 21h
    
        mov ah,4Ch
        int 21h  ; Finaliza o programa e retorna ao sistema operacional
    Exit endp
    
    Print_Valid proc
        mov bx, offset Array  ; Carrega o endere�o de mem�ria de Array
    
        mov ah,09h
        lea dx,Valid  ; Exibe a mensagem de "N�mero v�lido"
        int 21h
        
        jmp Ending  ; Volta para o fim
    Print_Valid endp
    
    Print_Invalid proc
        mov bx, offset Array  ; Carrega o endere�o de mem�ria de Array
    
        mov ah,09h
        lea dx,Invalid  ; Exibe a mensagem de "N�mero inv�lido"
        int 21h
    
        jmp Ending  ; Volta para o fim
    Print_Invalid endp
    
    Input_Invalido proc  
        mov ah,09h
        lea dx,Invalid  ; Exibe a mensagem de "N�mero inv�lido"
        int 21h
    
        jmp Main  ; Retorna para a execu��o da fun��o principal
    Input_Invalido endp
    
    Sair proc
        mov ah,09h       
        lea dx,String_Exit  ; Exibe a mensagem de "Programa terminou"
        int 21h
    
        mov ah,4Ch
        int 21h  ; Finaliza o programa
    Sair endp
    
    Input Proc 
        call InputNum1  ; Chama a sub-rotina para ler o primeiro n�mero
        call InputNum2  ; Chama a sub-rotina para ler o segundo n�mero
        ret
    Input endp
    
    InputNum1 Proc
        lea bx,Numero_Dividendo  ; Carrega o endere�o de "Numero_Dividendo"
        call InputNum  ; Chama a fun��o InputNum para ler o n�mero
        mov cl,Num_Casas_Decimais
        mov Num_Algarismos_Dividendo,cl  ; Salva o n�mero de casas decimais
        mov cl,Tamanho_Resultado
        mov Tamanho_Dividendo,cl  ; Salva o tamanho do n�mero
        mov cl,Flag_Resultado
        mov Flag_Dividendo,cl  ; Salva o flag de resultado
        ret
    InputNum1 endp
    
    InputNum2 Proc
        lea bx,Numero_Divisor  ; Carrega o endere�o de "Numero_Divisor"
        call InputNum  ; Chama a fun��o InputNum para ler o divisor
        mov cl,Num_Casas_Decimais
        mov Num_Algarismos_Divisor,cl  ; Salva o n�mero de casas decimais
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
    
        mov cx, 12  ; N�mero m�ximo de caracteres para entrada
        xor dx, dx  ; Limpa o registrador DX
    
    InputNumLoop:
        mov ah, 0
        int 16h  ; L� o pr�ximo caractere do teclado
        cmp al, 13  ; Verifica se o caractere � Enter (13h)
        je InputNumFim  ; Se for Enter, finaliza a entrada
        cmp al, 44  ; Verifica se o caractere � v�rgula (44h)
        je HandleVirgula  ; Se for v�rgula, trata de forma especial
        cmp al, 45  ; Verifica se o caractere � menos (-)
        je HandleMinus  ; Se for menos, trata de forma especial
        cmp al, 48  ; Verifica se o caractere � menor que '0'
        jl InputNumLoop  ; Se for, continua o loop
        cmp al, 57  ; Verifica se o caractere � maior que '9'
        ja InputNumLoop  ; Se for, continua o loop
        mov ah, 0Eh
        int 10h  ; Exibe o caractere na tela
        sub al, 48  ; Converte o caractere para valor num�rico
        mov [bx], al  ; Armazena o n�mero em mem�ria
        inc Tamanho_Resultado  ; Incrementa o tamanho do n�mero
        inc bx  ; Move para a pr�xima posi��o de mem�ria
    
        cmp Num_Casas_Decimais, 0
        je InputNumLoop  ; Se n�o h� casas decimais, continua o loop
        inc Num_Casas_Decimais  ; Incrementa o n�mero de casas decimais
        jmp InputNumLoop  ; Continua o loop de entrada
    
    HandleVirgula:
        cmp Num_Casas_Decimais, 0  ; Se j� h� casas decimais, ignora
        jne InputNumLoop
        cmp Tamanho_Resultado, 0  ; Se ainda n�o h� n�meros, ignora
        je InputNumLoop
        mov Num_Casas_Decimais, 1  ; Define uma casa decimal
        mov ah, 0Eh
        int 10h  ; Exibe a v�rgula na tela
        jmp InputNumLoop
    
    HandleMinus:
        cmp Tamanho_Resultado, 0  ; Se n�o h� n�mero, ignora
        jne InputNumLoop
        cmp Flag_Resultado, 0  ; Se ainda n�o foi marcado o sinal negativo
        jne InputNumLoop
        mov Flag_Resultado, 1  ; Marca o sinal negativo
        mov ah, 0Eh
        int 10h  ; Exibe o sinal negativo na tela
        jmp InputNumLoop
    
    InputNumFim:
        cmp Num_Casas_Decimais, 0
        jle EndInput  ; Se n�o h� casas decimais, finaliza
        dec Num_Casas_Decimais  ; Decrementa o n�mero de casas decimais
    
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
        sub dl, dh  ; Calcula a diferen�a entre os valores
    
    OutputStringInit:
        mov al, [bx]  ; Carrega o pr�ximo caractere
        add al, 48  ; Converte para caractere
        mov ah, 0Eh
        int 10h  ; Exibe o caractere na tela
        inc bx  ; Avan�a para o pr�ximo caractere
        cmp dl, 0  ; Verifica se o n�mero de casas decimais foi atingido
        jle OutputStringVirgulaUpdate
        sub dl, 1  ; Decrementa o n�mero de casas decimais
    OutputStringVirgulaUpdate:
        jne OutputStringVirgula  ; Se n�o for para mostrar a v�rgula, continua
        mov al, 44  ; Carrega a v�rgula
        mov ah, 0Eh
        int 10h  ; Exibe a v�rgula
        mov dl, 20  ; Define o n�mero de casas decimais restantes
    OutputStringVirgula:
        loop OutputStringInit  ; Continua o loop at� o fim do n�mero
    
        ret
    OutputStringNum proc
        cmp ch, 1  ; Compara o valor de ch com 1 (verificando se o n�mero � negativo)
        jne OutString  ; Se ch n�o for 1, pula a parte de imprimir o sinal negativo
        mov al, 45  ; Carrega o c�digo ASCII de '-' para sinal negativo
        mov ah, 0Eh  ; Fun��o para exibir um caractere na tela
        int 10h  ; Interrup��o para exibir o caractere
    
    OutString:
        call OutputString  ; Chama a sub-rotina OutputString para exibir o n�mero
        ret  ; Retorna da sub-rotina
    OutputStringNum endp
    
    MostrarResultado Proc
        mov dx, offset Mensagem_Resultado_Divisao  ; Carrega o endere�o da mensagem "Resultado da divis�o"
        mov ah, 9  ; Fun��o para exibir uma string na tela
        int 21h  ; Exibe a mensagem
    
        lea bx, Resultado_Divisao  ; Carrega o endere�o do resultado da divis�o
        mov cl, Tamanho_Resultado_Final  ; Carrega o tamanho do resultado
        mov dh, Valor_Resultado  ; Carrega o valor do resultado
        mov ch, Flag_Resultado_Final  ; Carrega o flag que indica se o resultado � negativo
        call OutputStringNum  ; Chama OutputStringNum para exibir o resultado, considerando o sinal
        ret  ; Retorna da sub-rotina
    MostrarResultado endp
    
    Converter_Digitos proc
        mov ax, dx  ; Copia o valor de dx para ax
        mov bx, 10  ; Configura o divisor para 10, para convers�o decimal
    
        xor si, si  ; Zera o registrador si, que ser� usado como ponteiro para armazenar os d�gitos
    
    Conveter_para_decimal:
        xor dx, dx  ; Zera o registrador dx (necess�rio para a divis�o)
        div bx  ; Divide ax por 10, o resultado vai para ax e o resto para dx
        add dl, '0'  ; Converte o resto (valor num�rico) para caractere ASCII
        mov [si], dl  ; Armazena o caractere em [si]
        inc si  ; Avan�a o ponteiro si para o pr�ximo espa�o de mem�ria
    
        test ax, ax  ; Verifica se o valor de ax � zero (n�o h� mais n�meros para dividir)
        jnz Conveter_para_decimal  ; Se ax n�o for zero, continua o loop de convers�o
    
        dec si  ; Decrementa si para apontar para o �ltimo d�gito armazenado
        mov ah, 09h  ; Fun��o para exibir uma string
        lea dx, Mensagem_Resultado  ; Carrega o endere�o da mensagem "Resultado"
        int 21h  ; Exibe a mensagem
    
    Imprimir_digitos:
        mov dl, [si]  ; Carrega o pr�ximo d�gito para o registrador dl
        mov ah, 02h  ; Fun��o para exibir um �nico caractere
        int 21h  ; Exibe o caractere
        dec si  ; Decrementa si para apontar para o pr�ximo d�gito
        jns Imprimir_digitos  ; Se si for positivo, continua exibindo os d�gitos
    
        jmp Ending  ; Pula para o fim da sub-rotina
    Converter_Digitos endp
    
    Converter_Digitos_Multiplicacao proc
        mov ax, dx  ; Copia o valor de dx para ax
        mov bx, 10  ; Configura o divisor para 10, para convers�o decimal
    
        xor si, si  ; Zera o registrador si
    
    convert_to_decimal:
        xor dx, dx  ; Zera o registrador dx (necess�rio para a divis�o)
        div bx  ; Divide ax por 10, o resultado vai para ax e o resto para dx
        add dl, '0'  ; Converte o resto (valor num�rico) para caractere ASCII
        mov [si], dl  ; Armazena o caractere em [si]
        inc si  ; Avan�a o ponteiro si para o pr�ximo espa�o de mem�ria
    
        test ax, ax  ; Verifica se o valor de ax � zero
        jnz convert_to_decimal  ; Se ax n�o for zero, continua o loop de convers�o
    
        dec si  ; Decrementa si para apontar para o �ltimo d�gito armazenado
        mov ah, 09h  ; Fun��o para exibir uma string
        lea dx, Mensagem_Resultado  ; Carrega o endere�o da mensagem "Resultado"
        int 21h  ; Exibe a mensagem
    
    print_digits:
        mov dl, [si]  ; Carrega o pr�ximo d�gito para o registrador dl
        mov ah, 02h  ; Fun��o para exibir um �nico caractere
        int 21h  ; Exibe o caractere
        dec si  ; Decrementa si para apontar para o pr�ximo d�gito
        jns print_digits  ; Se si for positivo, continua exibindo os d�gitos
    
        jmp Ending  ; jump para o fim da sub-rotina
    Converter_Digitos_Multiplicacao endp


    
    Soma proc

      xor ax, ax
      int 10h ; Limpa a tela

      mov SI, offset ArraySoma ; Inicializa o ponteiro para o array que armazenar� os n�meros inseridos
      xor cx, cx              ; Zera o cx
      xor bx, bx              ; Zera o registrador BX 

    Restart:
      mov SI, offset ArraySoma ; Reinicializa o ponteiro para o in�cio do array
      mov ah, 09h
      lea dx, Mensagem_Input   ; Exibe a mensagem pedindo a entrada do n�mero
      int 21h

    Armazenar_Ler_Numeros:
      mov [Numero_Soma], di    ; Armazena o valor acumulado at� agora em DI
      mov ah, 1
      int 21h                  ; L� um caractere do teclado
      cmp al, 0Dh              ; Verifica se a tecla "Enter" foi pressionada
      je Verificar_Soma        ; Vai para a soma se "Enter" for pressionado
      sub al, 30h              ; Converte o caractere ASCII para valor num�rico
      cmp al, 0
      jl Armazenar_Ler_Numeros ; Ignora valores menores que '0'
      cmp al, 9
      jg Armazenar_Ler_Numeros ; Ignora valores maiores que '9'
      mov [SI], al             ; Armazena o valor no array
      inc SI                   ; Move para a pr�xima posi��o do array
      inc cx                   ; Incrementa o contador de n�meros
      jmp Armazenar_Ler_Numeros ; Continua lendo os n�meros

    Verificar_Soma:
      mov SI, offset ArraySoma ; Reinicia o ponteiro para o in�cio do array
      mov dx, di               ; Salva o valor de DI em DX
      xor di, di               ; 
      xor ax, ax               ; 

    Loop_Tag:
      mov dx, [si]             ; Carrega o pr�ximo valor do array
      mov bl, 10               ; Prepara para multiplicar por 10 (posi��o decimal)
      mul bl                   ; Multiplica AX por 10
      add ax, dx               ; Soma o valor ao acumulador
      inc si                   ; Avan�a para o pr�ximo n�mero no array
      cmp si, offset ArraySoma + cl ; Verifica se todos os n�meros foram processados
      loop Loop_Tag            ; Repete at� processar todos os n�meros

      mov di, ax               ; Armazena o resultado acumulado em DI
      mov dx, [Numero_Soma]    ; Recupera o valor inicial de DX
      cmp dx, 0                ; Verifica se � necess�rio reiniciar
      je Restart               ; Reinicia se o valor for zero

    Final:
      add dx, ax               ; Soma o valor acumulado ao total
      mov cx, dx               ; Armazena o resultado em CX
      call Converter_Digitos   ; Converte o valor num�rico em d�gitos ASCII para exibi��o
      mov ah, 02h
      mov dx, cx               ; Exibe o resultado
      int 21h
      jmp Ending               ; Volta para o fim do programa

    Soma endp

    
    ;Subtracao
    Subtracao proc
        xor ax,ax
        int 10h ; Limpa a tela

        mov SI, offset ArraySubtracao ; Inicializa o ponteiro para o array onde os n�meros ser�o armazenados
        xor cx,cx
        xor bx,bx

    Restart_Subtracao:
        mov SI, offset ArraySubtracao ; Reinicializa o ponteiro para o in�cio do array
        mov ah, 09h
        lea dx, Mensagem_Input        ; Exibe a mensagem pedindo a entrada do n�mero
        int 21h

    Armazenar_Ler_Numeros_Subtracao:
        mov [Numero_Subtracao],di     ; Armazena o valor acumulado at� agora em DI
        mov ah,1
        int 21h                       ; L� um caractere do teclado
        cmp al,0Dh                    ; Verifica se a tecla "Enter" foi pressionada
        je Verificar_Subtracao        ; Vai para a verifica��o se "Enter" for pressionado
        sub al,30h                    ; Converte o caractere ASCII para valor num�rico
        cmp al,0
        jl Armazenar_Ler_Numeros_Subtracao ; Ignora valores menores que '0'
        cmp al,9
        jg Armazenar_Ler_Numeros_Subtracao ; Ignora valores maiores que '9'
        mov [SI], al                  ; Armazena o valor no array
        INC SI                        ; Move para a pr�xima posi��o do array
        INC cx                        ; Incrementa o contador de n�meros
        jmp Armazenar_Ler_Numeros_Subtracao ; Continua lendo os n�meros

    Verificar_Subtracao:
        mov SI, offset ArraySubtracao ; Reinicia o ponteiro para o in�cio do array
        mov dx,di                     ; Salva o valor acumulado em DI para DX
        xor di,di
        xor ax,ax

    Loop_Tag_Subtracao: 
        mov dx, [si]                  ; Carrega o pr�ximo valor do array
        mov bl, 10                    ; Prepara para multiplicar por 10 (posi��o decimal)
        mul bl                        ; Multiplica AX por 10
        add ax, dx                    ; Soma o valor ao acumulador
        inc si                        ; Avan�a para o pr�ximo n�mero no array
        cmp si, offset ArraySubtracao + cl ; Verifica se todos os n�meros foram processados
        loop Loop_Tag_Subtracao       ; Repete at� processar todos os n�meros

        mov di,ax                     ; Armazena o resultado acumulado em DI
        mov dx, [Numero_Subtracao]    ; Recupera o valor inicial de DX
        cmp dx,0                      ; Verifica se � necess�rio reiniciar
        je Restart_Subtracao          ; Reinicia se o valor for zero

     Final_Subtracao:
        sub dx,ax                     ; Subtrai o valor acumulado do n�mero inicial
        call Converter_Digitos        ; Converte o valor num�rico em d�gitos ASCII para exibi��o
        mov ah,02h
        mov dl,dl                     ; Exibe o resultado
        int 21h

    Subtracao endp


   Divisao proc
    xor ax,ax              ; Zera o registrador ax
    int 10h                 ; Chama a interrup��o de v�deo (n�o utilizada no c�digo diretamente)
    call Input              ; Chama a fun��o para receber os dados de entrada
    call Preencher_Array    ; Preenche o array com valores baseados no divisor
    call Realizar_Divisao   ; Realiza a opera��o de divis�o
    call Calcular_CasasDecimais_Resultado ; Calcula as casas decimais do resultado
    call Configurar_Resultado ; Configura o formato do resultado final
    call MostrarResultado   ; Mostra o resultado
    Divisao endp
    
    Realizar_Divisao Proc
        xor dx,dx              ; Zera o registrador dx
        xor ax,ax              ; Zera o registrador ax
        xor si,si              ; Zera o registrador si (�ndice)
        mov ch,10              ; Define o valor de ch como 10 (base decimal)
        xor ah,ah              ; Zera o registrador ah
        xor bx,bx              ; Zera o registrador bx
        mov bl,dl              ; Move o valor de dl para bl
        mul ch                  ; Multiplica ax por 10 (base decimal)
    Divisao1:
        add al,[Numero_Dividendo +bx] ; Adiciona o valor do n�mero dividendo ao registrador al
        inc bx                  ; Incrementa o �ndice do n�mero dividendo
        mov dl,bl               ; Restaura o valor de bl para dl
        cmp cl,al               ; Compara o valor de al com cl
        jle DivisaoInternofora  ; Se al for menor ou igual a cl, pula para a pr�xima parte
        mul ch                  ; Multiplica novamente por 10
        cmp bl,12               ; Se o valor de bl for igual a 12, finaliza a divis�o
        je DivisaoFim
        jmp Divisao1            ; Repete a opera��o de divis�o
    
    DivisaoInic:
        xor ah,ah               ; Zera o registrador ah
        xor bx,bx               ; Zera o registrador bx
        mov bl,dl               ; Restaura o valor de dl em bl
        mul ch                  ; Multiplica novamente por 10
    DivisaoInterno:
        add al,[Numero_Dividendo +bx] ; Adiciona o n�mero dividendo ao registrador al
        inc bx                  ; Incrementa o �ndice
        mov dl,bl               ; Restaura o valor de bl em dl
        cmp cl,al               ; Compara al com cl
        jle DivisaoInternofora  ; Se al for menor ou igual a cl, sai do loop
        mov dh,0                ; Zera dh (registro de divis�o)
        mov [Resultado_Divisao +si],dh ; Armazena o resultado parcial na mem�ria
        inc si                  ; Incrementa o �ndice de resultado
        mul ch                  ; Multiplica novamente
        cmp bl,12               ; Se o valor de bl for 12, finaliza
        je DivisaoFim
        jmp DivisaoInterno      ; Repete a opera��o interna de divis�o
    
    DivisaoInternofora:
        xor bx,bx               ; Zera o registrador bx
    
    DivisaoAchaMutiplo:
        mov ah,cl               ; Atribui o valor de cl a ah
        add ah,[Array_Divisao+bx] ; Adiciona o valor do array de divis�o a ah
        cmp al,ah               ; Compara al com ah
        jl DivisaoAchaMutiploFora ; Se al for menor que ah, sai do loop
        cmp bx,9                ; Se bx for maior ou igual a 9, sai do loop
        jae DivisaoAchaMutiploFora
        inc bx                  ; Incrementa bx
        jmp DivisaoAchaMutiplo  ; Continua buscando o m�ltiplo
    
    DivisaoAchaMutiploFora:
        mov [Resultado_Divisao +si],bl ; Armazena o resultado final
        inc si                  ; Incrementa o �ndice
        sub al,[Array_Divisao+bx] ; Subtrai o valor encontrado
        cmp dl,12               ; Se dl for menor que 12, repete a divis�o
        jl DivisaoInic
    
    DivisaoFim:
        mov ax,si               ; Armazena o valor de si em ax
        mov Tamanho_Resultado_Final,al ; Armazena o tamanho final do resultado
        ret
    Realizar_Divisao endp
    
    Preencher_Array Proc
        call Calcular_ValorNum2  ; Calcula o valor num�rico do divisor
        xor bx,bx                ; Zera o registrador bx
        mov bl,9                 ; Define o valor 9 para o loop
        mov cx,ax                ; Armazena o valor de ax em cx
    inicPreencherm:
        mul bx                   ; Multiplica o valor de ax por bx
        mov [Array_Divisao+bx],al ; Armazena o valor de al no array de divis�o
        cmp bx,0                 ; Verifica se o valor de bx � zero
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
        add al,[Numero_Divisor+bx] ; Adiciona o valor do n�mero divisor
        cmp bl,dl                ; Compara se o �ndice chegou ao fim
        je FimCalculo            ; Se chegou ao fim, finaliza
        inc bx                   ; Incrementa bx
        mul cl                   ; Multiplica ax pela base
        jmp InicioCalculo        ; Repete o c�lculo
    
    FimCalculo:
        ret
    Calcular_ValorNum2 endp
    
    Calcular_CasasDecimais_Resultado proc
        mov al,Tamanho_Divisor    ; Obt�m o tamanho do divisor
        sub al,1
        mov ah,Tamanho_Dividendo  ; Obt�m o tamanho do dividendo
        sub al,Num_Algarismos_Divisor ; Calcula a diferen�a
        sub ah,Num_Algarismos_Dividendo
        sub ah,al
        mov al,Tamanho_Resultado_Final ; Define o tamanho final do resultado
        sub al,ah                  ; Ajusta o valor final
        mov Valor_Resultado,al     ; Armazena o valor final
        call Comparacao            ; Realiza a compara��o
        ret
    Calcular_CasasDecimais_Resultado endp
    
    Comparacao proc
        xor bx,bx                ; Zera bx
        xor cx,cx                ; Zera cx
        mov cl,Tamanho_Divisor    ; Define o tamanho do divisor
        sub cl,Num_Algarismos_Divisor ; Ajusta o tamanho do divisor
    Comparacaoinic:
        mov ah,[Numero_Dividendo+bx] ; Compara cada d�gito do dividendo
        mov al,[Numero_Divisor+bx]   ; Compara cada d�gito do divisor
        inc bx                      ; Incrementa o �ndice
        cmp ah,al                   ; Compara os valores
        jl ComparacaoLabel          ; Se ah for menor que al, vai para o r�tulo
        cmp bx,cx                   ; Compara se bx chegou ao final
        jle Comparacaoinic          ; Se n�o chegou ao final, repete a compara��o
    
        ret
    ComparacaoLabel:
        mov al,1                   ; Se os valores foram diferentes, marca a diferen�a
        add Valor_Resultado,al      ; Atualiza o valor final
        ret
    Comparacao endp
    
    Configurar_Resultado proc
        mov al,Tamanho_Resultado_Final ; Obt�m o tamanho do resultado final
        mov ah,Valor_Resultado         ; Obt�m o valor calculado
        cmp al,ah                      ; Compara os dois valores
        jne Configurar_Resultadoaqui   ; Se forem diferentes, ajusta
        lea bx,Resultado_Divisao      ; Carrega o endere�o do resultado
        add bl,Tamanho_Resultado_Final ; Ajusta o ponteiro
        sub bx,1
        mov ax,1
        mov cl,Tamanho_Resultado_Final ; Define o n�mero de zeros a adicionar
        call Add_Zeros                ; Chama a fun��o para adicionar zeros
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
            loop inic             ; Repete o loop at� cx ser zero
            ret
    Add_Zeros endp
    
    Multipicacao proc
        xor ax,ax              ; Zera o registrador ax
        int 10h                 ; Chama a interrup��o de v�deo (n�o utilizada no c�digo diretamente)
    
        mov SI, offset Array_Multiplicacao ; Define o ponteiro SI para o array de multiplica��o
        xor cx,cx              ; Zera cx (contador)
        xor bx,bx              ; Zera bx
    
        Restart_Multiplicacao:  
            mov SI, offset Array_Multiplicacao ; Restaura o ponteiro SI
            mov ah, 09h          ; Chama a interrup��o para mostrar uma mensagem
            lea dx, Mensagem_Input
            int 21h              ; Exibe a mensagem de entrada
    
        Armazenar_Ler_Numeros_Multi:
            mov [Numero_Multiplicacao],di ; Armazena o valor de di em Numero_Multiplicacao
            mov ah,1              ; Chama a interrup��o 21h para ler um caractere
            int 21h
            cmp al,0Dh            ; Verifica se pressionaram Enter
            je Verificar_Multiplicacao ; Se sim, vai verificar a multiplica��o
            sub al,30h            ; Converte o valor de al de ASCII para valor num�rico
            cmp al,0              ; Verifica se o valor � menor que 0
            jl Armazenar_Ler_Numeros_Multi ; Se for, repete a leitura
            cmp al,9              ; Verifica se o valor � maior que 9
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
            loop Loop_Tag_Multiplicacao ; Continua o loop at� cx ser zero
    
            mov di,ax             ; Move o valor final para di
            mov dx, [Numero_Multiplicacao] ; Restaura o valor de Numero_Multiplicacao em dx
            cmp dx,0              ; Verifica se o valor de dx � zero
            je Restart_Multiplicacao ; Se for zero, reinicia a multiplica��o
    
        Final_Multiplicacao:
            mul dx                ; Multiplica ax por dx
            mov myVar1, dx        ; Armazena o valor de dx em myVar1
            mov myVar2, ax        ; Armazena o valor de ax em myVar2
            mov dx, myVar2        ; Move o valor de myVar2 para dx
            call Converter_Digitos_Multiplicacao ; Converte os d�gitos para formato adequado
            mov ah,02h            ; Chama a interrup��o para imprimir um caractere
            mov dx,cx             ; Move o valor de cx para dx
            int 21h               ; Exibe o caractere
            mov ah,4Ch            ; Chama a interrup��o para finalizar o programa
            int 21h
    
        Multipicacao endp    
    
        NIF proc     
        INC SI                   ; Incrementa o valor de SI
        xor ax,ax                ; Zera o registrador ax
        int 10h                   ; Chama a interrup��o de v�deo (n�o utilizada diretamente)
        mov al,[Index]           ; Move o valor de [Index] para al
        cmp al,37h               ; Compara o valor de al com 37h (caractere '7' em ASCII)
        je Nif_E_Cc              ; Se for igual, vai para Nif_E_Cc
    
        Nif_Only:        
        mov ah,09h               ; Exibe uma mensagem de texto
        lea dx, Nota             ; Carrega o endere�o de Nota
        int 21h                   ; Exibe a mensagem
        mov ah,09h               ; Exibe outra mensagem de texto
        lea dx,String_NIF        ; Carrega o endere�o de String_NIF
        int 21h                   ; Exibe a mensagem 
        jmp Ler_Numeros          ; Vai para a parte de ler os n�meros
    
        ends Nif_Only
    
        
        Nif_E_Cc:
        mov ah,09h               ; Exibe uma mensagem (String_Cc)
        lea dx,String_Cc          ; Carrega o endere�o de String_Cc
        int 21h                   ; Exibe a mensagem
    ends Nif_E_Cc 
    
    Ler_Numeros:
        mov ah,1                  ; L� um caractere da entrada
        int 21h
        cmp al,8h                 ; Verifica se o caractere � 'Backspace' (8h)
        jne Passing_Nif           ; Se n�o for, vai para Passing_Nif
        call Delete_Digit         ; Chama a fun��o para deletar o d�gito
        cmp SI,1                  ; Verifica o valor de SI
        je Continu                ; Se for igual a 1, vai para Continu
        DEC SI                     ; Decrementa o valor de SI
    Continu:
        jmp Ler_Numeros           ; Repete o loop para ler o pr�ximo n�mero
    Passing_Nif:
        INC SI                     ; Incrementa o valor de SI
        sub al,30h                 ; Converte o valor de al de ASCII para num�rico
        cmp al,0                   ; Verifica se o n�mero � menor que 0
        jl Ler_Numeros             ; Se for, repete a leitura
        cmp al,9                   ; Verifica se o n�mero � maior que 9
        jg Ler_Numeros             ; Se for, repete a leitura
        DEC SI                     ; Decrementa o valor de SI
        mov [bx], al               ; Armazena o valor de al em [bx]
        INC bx                     ; Incrementa o ponteiro bx
        cmp bx, offset Array+9     ; Verifica se o ponteiro bx alcan�ou o final do array
        jl Ler_Numeros             ; Se n�o, continua o loop
        mov bx, offset Array       ; Se sim, redefine o ponteiro bx para o in�cio do array
    ends Ler_Numeros
    
    xor cx,cx                     ; Zera o contador cx
    mov dl, 9                      ; Inicializa dl com 9 (usado para multiplica��o)
    checksum:
        mov al,0
        mov al,[bx]               ; Move o valor de [bx] para al
        mul dl                     ; Multiplica al por dl
        add cx,ax                  ; Soma o resultado de ax a cx
        DEC dl                     ; Decrementa dl
        INC bx                     ; Incrementa o ponteiro bx
        cmp dl,0                   ; Verifica se dl chegou a 0
        jg checksum                ; Se n�o, repete o loop
        xor dx,dx                  ; Zera dx
        mov ax,cx                  ; Move o valor de cx para ax
        mov cl,11                  ; Define o divisor (11) para o c�lculo do checksum
        div cl                      ; Divide ax por 11
        mov cl, [Index]            ; Carrega o valor de Index em cl
        cmp cl,37h                 ; Compara com 37h (caractere '7' em ASCII)
        je Nif_Inside_Cc           ; Se for igual, vai para Nif_Inside_Cc
        cmp ah,0                   ; Verifica o valor do resto (ah)
        je Print_Valid             ; Se for zero, imprime "v�lido"
        jne Print_Invalid          ; Se n�o for zero, imprime "inv�lido"
    
    Nif_Inside_Cc: 
        ret                        ; Retorna da fun��o NIF
    NIF endp
    
    Cartao_Cidadao proc
        call Nif                   ; Chama a fun��o Nif
        cmp ah,0                   ; Verifica o valor de ah (checksum)
        jne Print_Invalid          ; Se n�o for zero, imprime "inv�lido"
        mov bx, offset Array+9     ; Define o ponteiro bx para o final do array
        lettersAndNumbers:
            xor ax,ax              ; Zera o registrador ax
            mov ah,1               ; L� um caractere
            int 21h
            cmp al,8h              ; Verifica se � 'Backspace'
            jne Passing_Cc          ; Se n�o for, vai para Passing_Cc
            call Delete_Digit       ; Chama a fun��o para deletar o d�gito
            cmp SI,1                ; Verifica o valor de SI
            je Continuing           ; Se for 1, vai para Continuing
            DEC SI                  ; Decrementa SI
    Continuing:
            jmp lettersAndNumbers   ; Continua o loop de leitura
    Passing_Cc:
        INC SI                       ; Incrementa SI
        cmp al,30h                   ; Verifica se o caractere � num�rico (menor que 30h)
        jl lettersAndNumbers         ; Se for, continua o loop
        cmp al,39h                   ; Verifica se o caractere � num�rico (maior que 39h)
        jg letters                    ; Se for, vai para a parte de letras
        cmp al,3Ah                   ; Verifica se o caractere � ':' (separador)
        jl numbers                   ; Se for, vai para a parte num�rica
    letters:
        cmp al, 41h                  ; Verifica se � uma letra mai�scula (A-Z)
        jl lettersAndNumbers         ; Se for menor que A, continua o loop
        cmp al, 5Ah                  ; Verifica se � uma letra mai�scula (A-Z)
        jg lettersAndNumbers         ; Se for maior que Z, continua o loop
        sub al, 7h                   ; Converte letra de mai�scula para n�mero
    numbers:
        DEC SI                       ; Decrementa SI
        sub al, 30h                  ; Converte o caractere de ASCII para num�rico
        mov [bx], al                 ; Armazena o valor de al em [bx]
        INC bx                       ; Incrementa o ponteiro bx
        xor ax,ax                    ; Zera ax
        cmp bx, offset Array+11      ; Verifica se o ponteiro bx alcan�ou o final do array
        jl lettersAndNumbers         ; Se n�o, continua o loop
    
    finalChecksum:
        mov ah,1                     ; L� um caractere
        int 21h
        cmp al,8h                    ; Verifica se � 'Backspace'
        jne Passing_Cartao           ; Se n�o for, vai para Passing_Cartao
        call Delete_Digit            ; Chama a fun��o para deletar o d�gito
        cmp bx, offset Array+12      ; Verifica se o ponteiro bx chegou ao limite
        jl lettersAndNumbers         ; Se n�o, continua o loop
        cmp SI,1                     ; Verifica o valor de SI
        je Conti                     ; Se for igual a 1, vai para Conti
        DEC SI                        ; Decrementa SI
    Conti:
        jmp finalChecksum             ; Continua o loop de verifica��o
    
    Passing_Cartao:
        INC SI                        ; Incrementa SI
        sub al,30h                    ; Converte o caractere de ASCII para num�rico
        cmp al,0                      ; Verifica se � 0
        jl finalChecksum              ; Se for, continua o loop
        cmp al,9                      ; Verifica se � 9
        jg finalChecksum              ; Se for maior que 9, continua o loop
        DEC SI                        ; Decrementa SI
        mov [bx], al                  ; Armazena o valor de al em [bx]
        mov bx, offset Array         ; Restaura o ponteiro bx para o in�cio do array
        mov dl,2                      ; Define o valor 2 (usado para multiplica��o)
        mov cx,0                      ; Zera o contador cx
    addition:
        mov al,0                      ; Zera o registrador al
        mov al,[bx]                   ; Move o valor de [bx] para al
        mul dl                         ; Multiplica al por dl
        cmp ax,10                     ; Verifica se o resultado � maior que 10
        jl continue                   ; Se for, continua
        sub ax,9                      ; Subtrai 9 para ajustar o valor
    continue:
        add cx,ax                     ; Soma o resultado a cx
        add bx,2                      ; Incrementa o ponteiro bx
        cmp bx, offset Array+11       ; Verifica se o ponteiro bx chegou ao final
        jl addition                   ; Se n�o, continua o loop de adi��o
    
    ends addition
    mov bx, offset Array+1          ; Define o ponteiro bx para o segundo elemento do array
    
    finalAddition:
        mov ax,0                   ; Zera o registrador ax
        mov al,[bx]                 ; Move o valor de [bx] para al
        add cl,al                   ; Adiciona al ao contador cl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx, offset Array+12     ; Verifica se o ponteiro bx alcan�ou o final do array
        jl finalAddition            ; Se n�o, repete a adi��o
        mov ax,cx                   ; Move o valor de cx para ax
        mov cl,10                   ; Define o divisor (10)
        div cl                       ; Divide ax por 10
        cmp ah,0                    ; Verifica o valor do resto (ah)
        je Print_Valid              ; Se for zero, imprime "v�lido"
        jne Print_Invalid           ; Se n�o for zero, imprime "inv�lido"
    ends finalAddition
    
    Cartao_Cidadao endp
    
    Codigo_Barras proc
        INC SI                      ; Incrementa o valor de SI
        mov ax,0
        int 10h
        mov ah,09h                  ; Exibe uma mensagem (String_Barras)
        lea dx,String_Barras         ; Carrega o endere�o de String_Barras
        int 21h
    
    Ler_Console:
        mov ah,1                    ; L� um caractere
        int 21h
        cmp al,8h                   ; Verifica se o caractere � 'Backspace' (8h)
        jne Passing_Bar             ; Se n�o for, vai para Passing_Bar
        call Delete_Digit           ; Chama a fun��o para deletar o d�gito
        cmp SI,1                    ; Verifica o valor de SI
        je Continue_Bar             ; Se for 1, vai para Continue_Bar
        DEC SI                      ; Decrementa SI
    Continue_Bar:
        jmp Ler_Console             ; Continua o loop de leitura
    
    Passing_Bar:
        INC SI                      ; Incrementa SI
        sub al,30h                  ; Converte o valor de al de ASCII para num�rico
        cmp al,0                    ; Verifica se o n�mero � menor que 0
        jl Ler_Console              ; Se for, repete a leitura
        cmp al,9                    ; Verifica se o n�mero � maior que 9
        jg Ler_Console              ; Se for, repete a leitura
        DEC SI                      ; Decrementa SI
        mov [bx], al                ; Armazena o valor de al em [bx]
        INC bx                      ; Incrementa o ponteiro bx
        cmp bx, offset Array+13     ; Verifica se o ponteiro bx alcan�ou o limite
        jl Ler_Console              ; Se n�o, continua o loop
    ends Ler_Console
    
        mov bx, offset Array+1      ; Define o ponteiro bx para o segundo elemento do array
        xor ax,ax                   ; Zera o registrador ax
        xor cx,cx                   ; Zera o contador cx
        xor dx,dx                   ; Zera o registrador dx
        mov cl,3                    ; Define o valor de cl como 3 (usado para multiplica��o)
    
    Second_Verification:
        mov al,[bx]                 ; Move o valor de [bx] para al
        add dl,al                   ; Adiciona al a dl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx,offset Array+12      ; Verifica se o ponteiro bx alcan�ou o final
        jl Second_Verification      ; Se n�o, repete o loop
        mov al,dl                   ; Move o valor de dl para al
        xor dx,dx                   ; Zera dx
        mul cl                       ; Multiplica al por cl
        add dx,ax                   ; Soma o resultado de ax a dx
    ends Second_Verification
    
        mov bx, offset Array        ; Define o ponteiro bx para o in�cio do array
        xor ax,ax                   ; Zera o registrador ax
    
    Verification:
        mov al,[bx]                 ; Move o valor de [bx] para al
        add dl,al                   ; Adiciona al a dl
        add bx,2                    ; Incrementa o ponteiro bx
        cmp bx,offset Array+13      ; Verifica se o ponteiro bx alcan�ou o limite
        jl Verification             ; Se n�o, repete o loop
    ends Verification
    
        mov ax,dx                   ; Move o valor de dx para ax
        mov cl,10                   ; Define o divisor (10)
        div cl                       ; Divide ax por 10
        cmp ah,0                    ; Verifica o valor do resto (ah)
        je Print_Valid              ; Se for zero, imprime "v�lido"
        jne Print_Invalid           ; Se n�o for zero, imprime "inv�lido"
    ends Codigo_Barras
    
    Delete_Digit proc
        mov dl,20h                  ; Define o caractere de espa�o (20h)
        mov ah,02h                  ; Fun��o de exibi��o de caractere
        int 21h
        cmp SI,1                    ; Verifica se SI � igual a 1
        jne Comparison              ; Se n�o for, vai para Comparison
        cmp bx,offset Array         ; Verifica se bx alcan�ou o in�cio do array
        je Return                   ; Se for, retorna da fun��o
        DEC bx                      ; Decrementa o ponteiro bx
    
    Comparison:
        mov dl,8h                   ; Define o caractere 'Backspace' (8h)
        mov ah,02h                  ; Fun��o de exibi��o de caractere
        int 21h
    Return:
        ret                         ; Retorna da fun��o Delete_Digit
    
    ends Delete_Digit
