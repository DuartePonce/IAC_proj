; Exemplo de utilização de interrupções (precisa do circuito circuito-teste-interrupções.cir)

; O display conta ao ritmo do relógio ligado à interrupção 0

; *********************************************************************************
; * Dados 
; *********************************************************************************
DISPLAYS   EQU 0A000H  		; endereço dos displays de 7 segmentos (periférico POUT-1)

	PLACE	0100H
pilha:
	STACK 10H				; espaço reservado para a pilha 
						; (20H bytes, pois são 10H WORDs)
SP_inicial:				; este é o endereço (120H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11EH (120H-2)

tab:
	WORD	rot0				; tabela de interrupções (neste caso só tem uma WORD)
	
; *********************************************************************************
; * Código
; *********************************************************************************
	PLACE	0			; o código tem de começar em 0000H
	MOV	SP, SP_inicial		; inicializa SP
	MOV	BTE, tab			; inicializa BTE
	MOV	R0, 0			; inicializa contador
	EI0					; permite interrupção 0
	EI					; permite interrupções (geral)
fim:	
	JMP	fim				; fica à espera

; **********************************************************************
; ROT0 - Rotina que trata da interrupção 0 (incrementa contador)
; **********************************************************************
rot0:
	PUSH	R1	
	ADD	R0, 1	     	; incrementa contador
	MOV	R1, DISPLAYS		; endereço do periférico
	MOVB	[R1], R0	     	; atualiza display
	POP	R1
	RFE			     	; regressa da interrupção
