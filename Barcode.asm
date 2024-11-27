org 100h
.data

    array 13 dup(?)
    
    nota db 10,13, "Nota: Caso insira uma letra pode continuar a escrever o codigo de barras pois a letra nao ira afetar o calculo$"
    
    string db 10,13, "Insira o codigo de barras: $"
    
    invalid db 10,13, "Codigo de barras invalido $"
   
    valid db 10,13, "Codigo de barras valido$"

ends data

.code

    Start proc
    
    mov ax, @data   ;inicialization of the data declared above
    mov ds, ax  ;defining that de DATA SEGMENT (ds) points to our data, not to our code (as it does by default)    
    mov bx, offset array    
    
    mov ah,09h
    lea dx, nota
    int 21h
    
    mov ah,09h
    lea dx, string
    int 21h
    
    Ler_Console: 
    
      mov ah,1
      int 21h
    
      cmp al,8h
      je Delete_Digit
      
      sub al,30h
      cmp al,0          ;vamos verificar se o numero introduzido esta entre 0 a 9
      jl Ler_Console
      
      cmp al,9
      jg Ler_Console
      
      mov [bx], al  ;add the value of ax to the element of bx
      
      INC bx        ;increase the bx register so we can access the next element in the array
      
      cmp bx, offset array+13 ; we will check if the array is full
      jl Ler_Console
        
    ends Ler_Console 
    
    mov bx, offset array
    xor ax,ax
    xor cx,cx
    xor dx,dx
    
    Verification:
    
        mov al,[bx]
        
        add dl,al
        
        add bx,2      ;somar as posicoes impares
        
        cmp bx,offset array+13
        jl Verification      
    
    ends Verification
    
    mov bx, offset array+1 ;posicoes pares
    xor ax,ax
    mov cl,3
    mov si,dx
    xor dx,dx
    
    Second_Verification:
        
        mov al,[bx]
        add dl,al        
        
        add bx,2 ; avancar 2 posicoes
        cmp bx,offset array+13;queremos englobar o 12 elemento logo metemos +13 para tambem ir buscar essa posicao
        jl Second_Verification
        
        mov al,dl
        mul cl
        add si,ax
            
    ends Second_Verification
    
    Final_Check:
    
        mov ax,si
        mov cl,10
        div cl 
        
        cmp ah,0
        je Print_Valid
        jne Print_Invalid
    
    ends Final_Check
    
     Print_Valid:               ;printing the pre-defined string if the NIF number is valid
   
    mov ah,09h
    lea dx,valid
    int 21h
    
    ret 
   ends Print_Valid
  
   Print_Invalid:                 ;printing the pre-defined string if the NIF number is invalid
   
    mov ah,09h
    lea dx,invalid
    int 21h
    
    ret 
   ends Print_Invalid
        
    
    Delete_Digit:
      
      cmp bl,2
      je Ler_Console
      
      DEC bx
      jmp Ler_Console     
           
   ends Delete_Digit    
    
  endp