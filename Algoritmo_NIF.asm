org 100h

.data

   array 9 dup(?)  ; declaring the array that will be used to store the data of the NIF number
    
   length db 9 ; declaring a variable with the value of 8
   
   frase db 10,13, "Por favor insira o ser NIF: $"; defining a string
   
   invalid db 10,13, "NIF invalido $"
   
   valid db 10,13, "NIF valido$"

ends data
   
.code
    start:
                        
    mov ax, @data   ;inicialization of the data declared above
    mov ds, ax  ;defining that de DATA SEGMENT (ds) points to our data, not to our code (as it does by default)    
    mov bx, offset array ; passing the array to the bx register
    
    mov ah,09h
    lea dx, frase ;printing the string
    int 21h  
    
    lerConsole:
      mov ah,1
      int 21h
      
      cmp al,8h
      je deleteDigit
      
      sub al,30h
      cmp al,0          ;vamos verificar se o numero introduzido esta entre 0 a 9
      jl lerConsole
      
      cmp al,9
      jg lerConsole
      
      
      mov [bx], al  ;add the value of ax to the element of bx
      
      INC bx        ;increase the bx register so we can access the next element in the array
      
      cmp bx, offset array+9 ; we will check if the array is full
      jl lerConsole ; this is our loop for filling the array
      
      mov bx, offset array ;reset the value bx has so we return to our first element of the array      
      call verification
       
      ret 
    ends lerConsole
    
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
    
      cmp ah,0    ; se o resto for zero entao o check digit esta correto
      je printValid
      jne printInvalid
         
    ends checksum
   ends verification
   
    printValid:               ;printing the pre-defined string if the NIF number is valid
   
    mov ah,09h
    lea dx,valid
    int 21h
    
    ret 
   ends printValid
  
   printInvalid:                 ;printing the pre-defined string if the NIF number is invalid
   
    mov ah,09h
    lea dx,invalid
    int 21h
    
    ret 
   ends printInvalid
   
   deleteDigit:
      
      cmp bl,2
      je lerConsole
      
      DEC bx
      jmp lerConsole     
           
   ends deleteDigit  

 ends start
end