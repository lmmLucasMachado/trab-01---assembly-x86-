section .data		; Data section, initialized variables

; scan_var:	db	0		
; scan_var1:	dq	0		
fmt_print:    db "%ld.%03ld", 10, 0
fmt_scanf:    db "%d", 0

fmt:    db "a=%d, rax=%d", 10, 0 ; The printf format, "\n",'0'
fmt2:    db "recorre=%d, n=%d", 10, 0
fmt3:    db "recorre final = %d", 10, 10, 0
fmt4:    db "r13 = %d r14 = %d r15 = %d", 10, 10, 0
numb3	db "%d/%d=%d, %d*%d=%d", 10,10, 0
; numb1  db "Resultado = %ld Dividendo = %ld",10,0
; numb2  db "R12 = %ld R13 = %ld",10,0
; numb3  db "Dentro do div",10,"Variavel 1 = %ld Variavel 2 = %ld",10,0
; numb4  db "Dentro do div\R8 = %ld R10 = %ld",10,0
; teste   dq	(0)

section .bss
   number resb 4
scan_var:	resb 255
scan_var1:	resb 255

section	.text
    global main
    extern printf
    extern scanf

;-------------------- Operacoes basicas ------------------------

;Soma em número de ponto flutuante.
;rsi soma rdi
;retorno em rax
add_f:
    add rsi, rdi
    mov rax, rsi
    ret

;Subtração em número de ponto flutuante.
;rsi subtrai rdi
;retotno em rax
sub_f:
    sub rsi, rdi
    mov rax, rsi
    ret

;Divisão em número de ponto flutuante.
;rsi divide rdi
;retorno em rax como resultado
;retorna em rcx o overflow
div_f:
    mov rax, rsi
    xor  rdx, rdx
    idiv rdi
    mov r10, rdx    ;Salva temporariamente o resto em r10
    ;Salva os registradores r12 e r13 para utiliza-los
    push r12
    push r13
    ;Guarda a resposta da divisão em r12 e o divisor em r13
    mov r12, rax
    mov r13, rdi

    push r15
    xor r15, r15
    xor rcx, rcx    ;Zera o registrador rcx
    xor r8, r8      ;Zera o registrador r8
    mov r9, 100000  ;Faz o registrador r9 ser igual a 100000
    while_divf:
        ;Equanto rdx for zero ou r8 for maior ou igual a 6 ele termina o while
        cmp r10, 0
        je end_while_divf
        cmp r8, 6
        jge end_while_divf

        ;Multiplica o resto por 10 e depois divide pelo divisor
        mov rax, r10
        mov r11, 10
        mul r11

        xor  rdx, rdx
        idiv r13     ;Divide o resto * 10 pelo divisor
        mov r10, rdx;Salva temporariamente o resto em r10

        ;Nessa parte multiplica-se a resposta da divisao para colocar ela na casa correta 
        mul r9
        add r15, rax
        ; ;Printa
        ;Salva a resposta na variavel r8 somando os valores para mante-los no local certo
        add rcx, rax

        ;Divide r9 por 10 e salva ele novamente em r9
        mov rax, r9
        mov r11, 10
        idiv r11
        mov r9, rax
        ;Adiciona mais 1 ao contador r8
        add r8, 1
        jmp while_divf
    end_while_divf:

    ;Multiplica r12 que é a resposta da primeira divisão por 1000000 para coloca-lo no lugar correto
    mov rax, r12
    mov r11, 1000000
    mul r11
    ;Soma o antes da a parte inteira com a parte do ponto fixo e retorna
    add rax, r15

    ;Volta r12 e 13 para seus valores antes de entrarem na função
    pop r15
    pop r13
    pop r12
    ret

;Multiplicação em número de ponto fixo.
;rsi multiplica rdi
;retorno em rax como resultado
;retorna em rcx o overflow
mul_f:
    ;Multiplica os 2 numeros
    mov rax, rsi
    mul rdi         ;Multiplica os 2 numeros
    mov r11, 1000000
    div r11         ;Corrige o ponto flutuante
    ret

;------------------ Fim peracoes basicas ----------------------

;------------------------------------------------------------------------------------------------------;

raiz_quadrada:
    push r12
    push r13
    push r14
    mov r12, rdi    ; r12 = numero 
    xor r13, r13    ; r13 = n
    mov r14, rdi     ; r14 = recorre

    for_raiz_quadrada:
        cmp r13, 10
        jge fim_for_raiz


		; push    rbp		; set up stack frame
		; mov rdi, fmt2
		; ; mov	rax, r13	; put a from store into register
		; mov rsi, r14
		; mov rdx, r13
		; call    printf		; Call C function
		; pop     rbp		; same as "leave" op

        ;recorre/2
        mov rsi, r14
        mov rdi, 2000000
        call div_f      ;Faz a operaçao recorre/2
        push r15
        mov r15, rax    ;r15 = recorre/2


		; push    rbp		; set up stack frame
		; mov rdi, fmt3
		; ; mov	rax, r13	; put a from store into register
		; mov rsi, r15
		; ; mov rdx, r13
		; mov rax, 0
		; call    printf		; Call C function
		; pop     rbp		; same as "leave" op

        mov rdi, r14
        mov rsi, 2000000
        call mul_f      ;Faz a operação recorre*2

        mov rdi, rax
        mov rsi, r12    
        call div_f      ;Divido o numero pelo recorre*2

        mov rdi, r15
        mov rsi, rax
        call add_f
        mov r14, rax

		; push    rbp		; set up stack frame
		; mov rdi, fmt2
		; ; mov	rax, r13	; put a from store into register
		; mov rsi, r14
		; mov rdx, r13
		; mov rax, 0 
		; call    printf		; Call C function
		; pop     rbp		; same as "leave" op
        
        pop r15
        add r13, 1
        jmp for_raiz_quadrada
    fim_for_raiz:


    mov rax, r14
    pop r14
    pop r13
    pop r12
    add rax, 1
    ret




main:				; the program label for the entry point

	; Descomente para usar raiz
	push rbp
	mov rdi, fmt_scanf
	mov rsi, scan_var
	xor rax, rax      ; no xmm registers
	call scanf
	pop rbp

	; Descomente para soma, subtracao, multiplicacao e divisao
	; push rbp
	; mov rdi, fmt_scanf
	; mov rsi, scan_var1
	; xor rax, rax
	; call scanf
	; pop rbp

	; Descomente para usar raiz
	mov rax, [scan_var]
	mov r10, 1000000
	mul r10
	mov rdi, rax
	call raiz_quadrada

	; Descomente para soma, subtracao, multiplicacao e divisao
	; mov rax, [scan_var]
	; mov r10, 1000000
	; mul r10
	; mov rsi, rax
	; mov rax, [scan_var1]
	; mov r10, 1000000
	; mul r10
	; mov rdi, rax

	; Descomente uma das opções para escolher
	; call add_f	;Adicao
	; call sub_f	;Subtracao
	; call div_f	;Divisao
	; call mul_f	;Multiplicacao


    call print_number

	push    rbp		; set up stack frame
	mov rdi, fmt_print
	mov rsi, rax	
	mov rdx, r11
	mov	rax, 0	; put a from store into register
	call    printf		; Call C function
	pop     rbp		; same as "leave" op


	mov	rax,0		;  normal, no error, return value
	ret			; return


print_number:
    push r13
    push r14
    push r15

    mov r13, rax

    mov r15, 1000000; rax /10000000
    xor rdx, rdx
    idiv r15

    mov r14, rax
    xor rdx, rdx

    mov rax, r14; parte inteira *1000000
    mul r15



    sub r13, rax; parte inteira - total


    ;----
    xor rdx, rdx
    idiv r15; parte inteira
    mov r14, rax;

    mov rax, r13
    mov r15, 1000
	xor rdx, rdx
    idiv r15


    mov r13, rax

    ;r14 parte inteira
    ;r13 parte decimal
    mov rax, r14 ; int
    mov r11, r13 ; dec



    pop r15 
    pop r14 ; int
    pop r13 ; dec
    
    ret




; super print
; push rbp
    ; push rdi
    ; push rdx
    ; push rax
    ; push r8
    ; push r9
    ; push r10
    ; mov rdi, fmt4
    ; mov rsi, r12
    ; mov rdx, r13
    ; mov rcx, r10
    ; mov rax, 0
    ; call printf
    ; ; pop rax
    ; pop r10
    ; pop r9
    ; pop r8
    ; pop rax
    ; pop rdx
    ; pop rdi
    ; pop rbp