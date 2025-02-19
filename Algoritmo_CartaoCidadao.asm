org 100h

.data

   array 12 dup(?)  ; declaring the array that will be used to store the data of the NIF number
   
   frase db 10,13, "Por favor insira o ser numero de cartao de cidadao: $"; defining a string
   
   invalid db 10,13, "numero CC invalido$"
   
   valid db 10,13, "CC valido$" ; nao sera necessario

ends data
   
.code
    start:
                        
    mov ax, @data   ;inicialization of the data declared above
    mov ds, ax  ;defining that de DATA SEGMENT (ds) points to our data, not to our code (as it does by default)    
    mov bx, offset array ; passing the array to the bx register
    
    mov ah,09h
    lea dx, frase ;printing the string
    int 21h  
    
    call checkBI
    mov bx, offset array+9
    call lettersAndNumbers 
    
    finalChecksum:
      
      mov ah,1
      int 21h
      
      cmp al,8h
      je deleteDigit
      
      sub al,30h
      cmp al,0          ;vamos verificar se o numero introduzido esta entre 0 a 9
      jl finalChecksum
      
      cmp al,9
      jg finalChecksum
           
      mov [bx], al
      mov bx, offset array
      mov dl,2
      mov cx,0
      
     addition:
      mov al,0
      mov al,[bx]
      mul dl
      cmp ax,10
      jl continue
      
      sub ax,9
      
       continue:
          add cx,ax          
          add bx,2
       ends continue
          
        cmp bx, offset array+11 ; we will check if the array is full    
        jl addition      
     ends addition
     
     mov bx, offset array+1
    
    finalAddition:
 
      mov ax,0
      mov al,[bx]
      add cl,al
      add bx,2  
      
      cmp bl,0Eh
      jl finalAddition
      
      mov ax,cx
      mov cl,10
      div cl
      
      cmp ah,0
      je printValid
      jne printInvalid      
      
    ends finalAddition
    
  ends finalChecksum  
     
ends start 
 
checkBI:
 
      mov ah,1
      int 21h
      
      cmp al,8h
      je deleteDigit
      
      sub al,30h
      cmp al,0          ;vamos verificar se o numero introduzido esta entre 0 a 9
      jl checkBI
      
      cmp al,9
      jg checkBI
    
            
      mov [bx], al  ;add the value of ax to the element of bx
      
      INC bx        ;increase the bx register so we can access the next element in the array
      
      cmp bx, offset array+9 ; we will check if the array is full
      jl checkBI ; this is our loop for filling the array
      
      mov bx, offset array ;reset the value bx has so we return to our first element of the array      
      call verification
      
      cmp ah,0
      jne printInvalid  ;verifica os primeiros 9 valores do cc
 
 
 verification:  ;The code for checking if the NIF number is valid
      
      xor cx,cx  ;returns 0 if they are the same, so sets the cx to 0 (faster than mov command)
      mov dl, 9  ; start of our weight-giving variable to make the checksum
   
    checksum:   
      
      mov al,0
      mov al,[bx]  ;accessing our element in the array
      mul dl       ;multiplying the element by its weight
      add cx,ax    ; the result of the multiplication will be stored in ax so we add that value to cx which will hold the sum
      
      DEC dl         ;decrement the value of si beecause the next digit of the NIF number/array has less weight      
      INC bx       ;increment the bx so we move forward in the array by one digit      
      
      cmp dl,0     ; we will check if the array is full
      jg checksum            ;looping until we have calculated all the digits in the array
      
      xor dx,dx    ; dx = 0
      mov ax,cx    ; ax = cx (total addition)
      mov cl,11    
      div cl       ; ax/cl   the remainder will be stored in ah and the quotient in al      
         
      ret
    ends checksum
   ends verification 
     
   ret
   
ends checkBI
 
    
 lettersAndNumbers: 
    
      xor ax,ax
      
      mov ah,1
      int 21h
      
      cmp al,8h
      je deleteDigit
      
      cmp al,30h               ;vamos verificar se o valor introduzido esta entre A a Z
      jl lettersAndNumbers
      
      cmp al,39h
      jg letters
      
      cmp al,3Ah
      jl numbers
    
    letters:
      
      cmp al, 41h         ;vamos verificar se o valor introduzido esta entre A a Z
      jl lettersAndNumbers
      
      cmp al, 5Ah
      jg lettersAndNumbers 
      
    ends letters
      
      sub al, 7h ;subtract 30h so we get our value for each letter from the table(hexadecimal to decimal)
      
   numbers: 
   
      sub al, 30h
      mov [bx], al  ;add the value of ax to the element of bx
      
      INC bx        ;increase the bx register so we can access the next element in the array
      xor ax,ax
      cmp bx, offset array+11 ; we will check if the array is full
      jl lettersAndNumbers ; this is our loop for filling the array
   ends numbers   
      cmp bx, offset array+11 ; we will check if the array is full
      je finalChecksum
    
 ends lettersAndNumbers 
     
   printValid:               ;printing the pre-defined string if the NIF number is valid
   
    mov ah,09h
    lea dx,valid
    int 21h     
        
    mov ah,4Ch
    int 21h
           
   ends printValid
  
  printInvalid:                 ;printing the pre-defined string if the NIF number is invalid
   
    mov ah,09h
    lea dx,invalid
    int 21h
        
    mov ah,4Ch
    int 21h                 
  ends printInvalid
   
 deleteDigit:
      
      DEC bl      
      
      cmp bl,0Ah
      jl checkBI
      
      cmp bl,0EH
      jl lettersAndNumbers          
           
 ends deleteDigit  
                   
                   
end