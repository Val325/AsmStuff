global _start


section .text

_start:
 
  mov rax, 1                  ; write(
  mov rdi, 1                  ;   STDOUT_FILENO,
  mov rsi, MsgMain            ;   "neofetch-asm\n",
  mov rdx, MsgMainLeg         ;   sizeof("neofetch-asm\n")
  syscall                     ; );



  mov rax, 1                  ; write(
  mov rdi, 1                  ;   STDOUT_FILENO,
  mov rsi, MsgDistro          ;   "distro: ",
  mov rdx, MsgDistroLeg       ;   sizeof("distro: ")
  syscall                     ; );



  mov rax, 2                  ; open(
  mov rdi, PathToNameDistro  ; "/etc/issue",              
  xor rsi, rsi                  ; Readonly
  mov rdx, 0777
  syscall                     ; );
  mov rbx, rax



  xor rax, rax                  ; read(
  mov rdi, rbx                ;   file deskriptor,  
  mov rsi, dataDistro           ;   dataDistro:  resb 50,
  mov rdx, 30                 ;   sizeof)
  syscall                     ; );
  mov [dataDistroLen], rax



  ; Append PathToNameDistro
  mov rsi, MsgDistro                ; *source
  lea rdi, dataDistro        ; *dest
  add rdi, rax                ; Set pointer one byte behind the real name
  mov rcx, 20      ; Count of bytes to copy
  lea rbx, [rax + rcx]        ; Save the total length of the string
  rep movsb                   ; Copy RCX bytes from [RSI] to [RDI]


  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  lea rsi, [dataDistro + 5]      ;   "Hello, world!\n",
  mov rdx, 12   ;   sizeof("Hello, world!\n")
  syscall           ; );

  mov rax, 1        ; write(
  mov rdi, 1        ;   STDOUT_FILENO,
  mov rsi, NullByte      ;   "Hello, world!\n",
  mov rdx, 2   ;   sizeof("Hello, world!\n")
  syscall           ; );        

  mov rax, 60       ; exit(
  mov rdi, 0        ;   EXIT_SUCCESS
  syscall           ; );

section .rodata
  MsgMain: db "neofetch-asm", 10
  MsgMainLeg: equ $ - MsgMain
  MsgDistro: db "distro: "
  MsgDistroLeg: equ $ - MsgDistro
  PathToNameDistro: dw "/etc/os-release", 10
  NullByte db 10
  PathToNameDistroLeg: equ $ - PathToNameDistro
section .bss
  dataDistro resb 1024
  fileDeskript resb 50   
  dataDistroLen resb 1024