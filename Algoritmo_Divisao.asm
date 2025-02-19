data segment       
    msgInput db "Insira o numero:",'$' 
    msgResult db "Resultado:",'$'
    num1  db 24 dup(0)
    v1    db 0 ;numero de algarismos decimais
    size1 db 0 ;numero de algarismos do array
    sine1 db 0 ;flag sinal do array
    num2  db 24 dup(0) 
    v2    db 0 
    size2 db 0
    sine2 db 0 
    sine db 0
    size db 0
    v    db 0     
    m     db 10 dup(0) ;usado na divisao    
    result db 24 dup(0)
    siner db 0
    sizer db 0
    vr    db 0      
ends


code segment


start:
    main    Proc
        ; Configura o segmento de dados (ds)
        mov ax, data
        mov ds, ax

        call input ;num1:dividendo num2:divisor
        call PreencherArraym
        call Divisao
        call VResult  
        call setResult2
        call OutputResult                                                                                                                                                            

        ; Finaliza o programa e retorna ao sistema operacional
        mov ax, 4c00h  ; Código de saída
        int 21h        ; Interrupção para saída
        ret            ; Retorno da função main
    main endp
                                             
   
InputNum Proc                                    
    ; Inicializar variáveis a zero
    mov v, 0
    mov sine, 0
    mov size, 0                                   

    ; Exibir mensagem de entrada
    mov dx, offset msgInput
    mov ah, 9
    int 21h

    ; Limpar DX e definir tamanho máximo
    mov cx, 12      ; Máximo de caracteres
    xor dx, dx      ; Limpa DX (contador auxiliar)

InputNumLoop:
    ; Ler caracter do teclado
    mov ah, 0
    int 16h
    ; Verificar tecla ENTER
    cmp al, 13
    je InputNumFim
    ; Verificar vírgula
    cmp al, 44
    je HandleVirgula
    ; Verificar sinal negativo
    cmp al, 45
    je HandleMinus
    ; Verificar se é dígito válido
    cmp al, 48
    jl InputNumLoop
    cmp al, 57
    ja InputNumLoop
    ; Exibir dígito no ecrã
    mov ah, 0Eh
    int 10h
    ; Converter dígito ASCII para valor numérico
    sub al, 48
    mov [bx], al
    inc size
    inc bx

    ; Atualizar número de casas decimais se já houve vírgula
    cmp v, 0
    je InputNumLoop
    inc v
    jmp InputNumLoop

    HandleVirgula:
    ; Apenas uma vírgula permitida
    cmp v, 0
    jne InputNumLoop
    ; Não pode ser a primeira ou última entrada
    cmp size, 0
    je InputNumLoop
    mov v, 1

    ; Exibir vírgula no ecrã
    mov ah, 0Eh
    int 10h
    jmp InputNumLoop

    HandleMinus:
    ; Apenas um sinal negativo permitido, e só como primeiro caracter
    cmp size, 0
    jne InputNumLoop
    cmp sine, 0
    jne InputNumLoop

    mov sine, 1

    ; Exibir sinal negativo no ecrã
    mov ah, 0Eh
    int 10h
    jmp InputNumLoop

    InputNumFim:
    ; Ajustar casas decimais (v - 1, se houver vírgula)
    cmp v, 0
    jle EndInput
    dec v

    EndInput:
    ; Exibir nova linha
    mov al, 13
    mov ah, 0Eh
    int 10h
    mov al, 10
    int 10h
    ret
    InputNum Endp

            
    OutputStringV Proc
    ; Zerando variáveis globais
    mov v, 0
    mov sine, 0
    mov size, 0
    mov ch, 0
    xor dl, dl

    ; Calculando a diferença entre dl e dh (presumivelmente para algum tipo de contador)
    mov dl, cl
    sub dl, dh

    OutputStringInitV:
        mov al, [bx]        ; Carregar próximo caractere
        add al, 48          ; Converter para ASCII
        mov ah, 0Eh
        int 10h             ; Exibe o caractere
        inc bx              ; Avança o ponteiro para o próximo caractere
        cmp dl, 0           ; Se dl <= 0, não exibe vírgula
        jle OutputStringVirgulaUpdate
        sub dl, 1           ; Decrementa dl
        OutputStringVirgulaUpdate:
            ; Se dl == 0, não imprime vírgula
            jne OutputStringVirgula
            mov al, 44          ; Código ASCII da vírgula
            mov ah, 0Eh
            int 10h             ; Exibe vírgula
            mov dl, 20          ; Controla o tamanho, ajustado para números menores que 20
        OutputStringVirgula:
            loop OutputStringInitV

    ret
    OutputStringV endp

    OutputStringNum proc
        ; Verifica se o número tem sinal negativo (ch == 1)
        cmp ch, 1
        jne OutVString     ; Se ch != 1, sai sem imprimir sinal
        ; Se negativo, imprime o sinal de menos
        mov al, 45
        mov ah, 0Eh
        int 10h
    OutVString:
        call OutputStringV  ; Chama OutputStringV para imprimir o número
        ret
    OutputStringNum endp

    OutputResult Proc
        mov dx, offset msgResult
        mov ah, 9
        int 21h             ; Exibe a mensagem de resultado
        lea bx, result
        mov cl, sizer
        mov dh, vr
        mov ch, siner
        call OutputStringNum    ; Chama OutputStringNum para exibir o número
        ret
    OutputResult endp   
    
    VResult Proc  
        mov al,size2
        sub al,1
        mov ah,size1
        sub al,v2
        sub ah,v1
        sub ah,al
        mov al,sizer
        sub al,ah
        mov vr,al
        call comparacao2
        ret
    VResult endp 
    
    setResult2 proc 
        mov al,sizer
        mov ah,vr
        cmp al,ah
        jne setResultaqui2:
        lea bx, result
        add bl,sizer   
        sub bx,1
        mov ax,1 
        mov cl,sizer
        call addzeros 
        mov ax,1
        add sizer,al
        setResultaqui2: 
        ret
    setResult2 endp
    
    comparacao2 proc  
        xor bx,bx
        xor cx,cx
        mov cl, size2
        sub cl,v2
        comparacao2inic: 
        mov ah,[num1+bx]
        mov al,[num2+bx] 
        inc bx
        cmp ah,al
        jl comparacao
        cmp bx,cx
        jle comparacao2inic:
        ret 
        comparacao:
        mov al,1
        add vr,al
        ret
    comparacao2 endp
    
    addzeros proc
        inic:    
        mov  dh,[bx]
        mov [bx],0 
        add bx,ax
        mov [bx],dh
        sub bx,ax
        sub bx,1
        loop inic
        ret
    addzeros endp 
     
    Divisao Proc
        xor dx,dx
        xor ax,ax
        xor si,si
        mov ch,10
        xor ah,ah
        xor bx,bx
        mov bl,dl
        mul ch    
        Divisao1: 
        add al,[num1 +bx]
        inc bx 
        mov dl,bl
        cmp cl,al  
        jle DivisaoInternofora: 
        mul ch 
        cmp bl,12
        je DivisaoFim:
        jmp Divisao1:
        DivisaoInic:
        xor ah,ah
        xor bx,bx
        mov bl,dl
        mul ch    
        DivisaoInterno: 
        add al,[num1 +bx]
        inc bx 
        mov dl,bl
        cmp cl,al  
        jle DivisaoInternofora:
        mov dh,0
        mov [result +si],dh
        inc si 
        mul ch 
        cmp bl,12
        je DivisaoFim:
        jmp DivisaoInterno: 
        DivisaoInternofora:
        xor bx,bx 
        
        DivisaoAchaMutiplo:
        mov ah,cl 
        add ah,[m+bx]
        cmp al,ah
        jl DivisaoAchaMutiploFora:
        cmp bx,9
        jae DivisaoAchaMutiploFora:
        inc bx  
        jmp DivisaoAchaMutiplo:
        DivisaoAchaMutiploFora: 
        mov [result +si],bl
        inc si 
        sub al,[m+bx]
        cmp dl,12
        jl DivisaoInic:
        DivisaoFim:
        mov ax,si
        mov sizer,al
        ret
    Divisao endp     
     
    PreencherArraym Proc 
        call peganum2
        xor bx,bx 
        mov bl,9
        mov cx,ax
        inicPreencherm:  
        mul bx
        mov [m+bx],al
        cmp bx,0
        je Preenchermfim:
        sub bx,1 
        mov ax,cx
        jmp inicPreencherm:  
        Preenchermfim:     
        ret
    PreencherArraym endp    
    
    inputNum1 Proc 
    ;calling InputNum
    lea bx,num1
    call InputNum ;calling InputNum 
    ;seetin return values from InputNum
    mov cl,v
    mov v1,cl
    mov cl,size
    mov size1,cl 
    mov cl,sine
    mov sine1,cl 
    ret
    inputNum1 endp
    
    inputNum2 Proc
    ;calling InputNum
    lea bx,num2
    call InputNum;calling InputNum
                                                    
    ;setting return values from InputNum
    mov cl,v
    mov v2,cl
    mov cl,size
    mov size2,cl 
    mov cl,sine
    mov sine2,cl;setting return values from InputNum        
    ret 
    inputNum2 endp
    
    input Proc 
        call inputNum1  
        call inputNum2                                          
        ret
    input endp   
 
    setResult proc 
        xor bh,bh 
        mov bl,size1 
        mov al,v1
        cmp bl,size2
        ja inicSetResult 
        mov bl,size2 
        mov al,v2
        inicSetResult:
        mov sizer,bl
        mov vr,al 
        ret
    setResult endp
    
    peganum2 Proc
        xor bx,bx 
        mov dl,size2
        sub dl,1
        mov cl,10
        xor ax,ax
        inicpeganum2: 
        add al,[num2+bx] 
        cmp bl,dl
        je peganum2fim:
        inc bx 
        mul cl
        jmp inicpeganum2:  
        peganum2fim:
        ret
    peganum2 endp   
                     
ends

end start 