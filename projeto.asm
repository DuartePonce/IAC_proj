;*********************************************************************************
; Grupo-1
; Duarte Ponce, Antonio Delgado e Rodrigo Salgueiro
; 107489, 106658, 106505
;*********************************************************************************


;*********************************************************************************
;Constantes principais a declarar:
;*********************************************************************************

DISPLAYS   EQU 0A000H       ; POUT-1
TEC_LIN    EQU 0C000H       ; POUT-2
TEC_COL    EQU 0E000H       ; PIN
LINHA      EQU 1            ; Variável de linha 
MASCARA    EQU 0FH          ; Para isolar os 4 bits de menor peso, ao ler as colunas do teclado
N_LINHAS   EQU  32	        ; número de linhas do ecrã (altura)
N_COLUNAS  EQU  64	        ; número de colunas do ecrã (largura)
LARGURA    EQU 16           ; Largura do painel
ALTURA     EQU 6            ; Altura do painel
TAMANHO_ASTEROIDE    EQU 5  ; Tamanho do asteroide
LIN        EQU 26           ; Linha inicial de desenho do painel
COL        EQU 24           ; Coluna inicial do desenho do painel
IMAGEM1    EQU 0            
IMAGEM2    EQU 1
COLUNA_SONDA    EQU 32      ; Posicao inical da sona
LINHA_SONDA     EQU 25      ; Posicao inicial da sonda
SOM1            EQU 0
SONDA1_CORD    EQU 25

ENERGIA_INICIAL EQU 103

;*********************************************************************************
;Cores
;*********************************************************************************
VERMELHO        EQU 0FF00H  
ROXO_ESCURO     EQU 0F829H
ROXO_CLARO      EQU 0F62AH
PRETO           EQU 0F000H
CINZENTO        EQU 0FBBBH
VERDE           EQU 0F6F6H

;*********************************************************************************
;Comandos a declarar 
;*********************************************************************************

COMANDOS			     EQU	6000H			; endereço de base dos comandos do MediaCenter
DEFINE_LINHA    	     EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   	     EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    	     EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     	     EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 	         EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SOM                      EQU COMANDOS + 48H     ; Seleciona o audio
REPRODUCAO               EQU COMANDOS + 5AH     ; Reproduz o audio  

;*********************************************************************************
;Zona de dados
;*********************************************************************************
PLACE 2000H
painel_lista:

    WORD 0,0,0, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, 0,0,0
    WORD 0, ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO, 0
    WORD 0, ROXO_ESCURO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_ESCURO, 0
    WORD ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, CINZENTO, PRETO, CINZENTO, PRETO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, CINZENTO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO

asteroide_n_mineravel:
    WORD VERMELHO, 0,0,0, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, VERMELHO, PRETO, VERMELHO, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, 0,0,0, VERMELHO

asteroide_mineravel:
    WORD 0
    WORD 0
    WORD 0
    WORD 0
    WORD 0

sonda:
    WORD VERDE

tab:
    WORD    0 
    WORD    interrupcao_sonda
    WORD    interrupcao_energia   
    WORD    0

sondas:
    WORD SONDA1_CORD, SONDA1_CORD
    WORD 0, 0
    WORD 0, 0

energia_nave:
    WORD ENERGIA_INICIAL
;*********************************************************************************
; Stacks 
;*********************************************************************************

	STACK 100H		
SP_inicial:	

	STACK 100H		; espaço reservado para a pilha do processo "teclado"
SP_teclado:			; este é o endereço com que o SP deste processo deve ser inicializado

    STACK 100H
SP_sonda1:

    STACK 100H
SP_energia:

tecla_carregada:
	LOCK 0
sonda1:
    LOCK 0
energia:
    LOCK 0
;*********************************************************************************
;Codigo principal
;*********************************************************************************
PLACE      0

apaga_imagem:
    MOV  SP, SP_inicial
    MOV  BTE, tab
    MOV  [APAGA_AVISO], R1          ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)                
menu_principal:
    MOV	 R1, IMAGEM1			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    CALL teclado
obtem_tecla:	
	MOV	R1, [tecla_carregada]	; bloqueia neste LOCK até uma tecla ser carregada
    
    MOV R3, 81H   
    CMP	R1, R3		; é a coluna da tecla C?
	JZ	testa_C

testa_C:
    CALL fundo_jogo
    CALL sonda_1
    CALL energia_inicio
    EI1
    EI2
    EI

;*********************************************************************************
; teclado
;*********************************************************************************

PROCESS SP_teclado 

teclado:
    MOV  R6, LINHA
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

ciclo:
    MOV  R1, 0

espera_tecla:        ; neste ciclo espera-se at� uma tecla ser premida
    YIELD
    MOV  R1, 10H
    CMP  R1, R6   
    JZ   reset
    MOV  R1, R6 
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    SHL  R6, 1
    CMP  R0, 0         ; h� tecla premida?

    JZ   espera_tecla       ; se nenhuma tecla premida, repete

    SHL  R1, 4              ; coloca linha no nibble high
    OR   R1, R0             ; junta coluna (nibble low)
    MOV	[tecla_carregada], R1 ; desbloquia teclado
    
ha_tecla:              ; neste ciclo espera-se at� NENHUMA tecla estar premida
    YIELD 
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R0, 0         ; h� tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera at� n�o haver
    JMP ciclo

reset:
    MOV  R6, LINHA
    JMP espera_tecla

;*********************************************************************************
;Codigo painel - codigo que desenha e da setup ao painel de jogo mudando a imagem 
;                de fundo e desenhando o painel
;*********************************************************************************

fundo_jogo:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6

    MOV	 R1, IMAGEM2			                    ; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
posicao_painel:
    MOV  R1, LIN
    MOV  R2, COL 
	MOV	 R4, painel_lista		; endereço da tabela que define o painel

    MOV  R5, LARGURA			    ; largura do painel
    MOV  R6, ALTURA               ; guarda a altura do painel

desenha_pixels:       		    ; desenha os pixels do painel a partir da tabela
	MOV	 R3, [R4]			    ; obtém a cor do próximo pixel do painel
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
	ADD	 R4, 2			        ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1                  ; próxima coluna
    SUB  R5, 1			        ; menos uma coluna para tratar
    JNZ  desenha_pixels         ; continua até percorrer toda a largura do objeto

linha_pixel_seg:
    MOV  R5, LARGURA             ; reseta o valor de r5 com r8
    MOV  R2, COL            ; reseta o valor da coluna para r2
    ADD  R1, 1              ; adiciona um ao r1 para avaancar a linha
    SUB  R6, 1             ; subtrai o numero de linhas ate chegar a zero
    JNZ  desenha_pixels
    
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    RET


;*********************************************************************************
; Sonda
;*********************************************************************************

PROCESS SP_sonda1
sonda_1:
    MOV R4, sondas
    MOV R1, [R4]
ciclo_sonda:
    CALL desenhar_sonda
    MOV R2, [sonda1]    ; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL apagar_sonda
    JMP ciclo_sonda

desenhar_sonda:
    MOV R3, VERDE
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R1	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
    RET
apagar_sonda:
    MOV R3, 0
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R1	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas

    SUB R1, 1
    MOV [R4], R1

    RET

PROCESS SP_energia
energia_inicio:
    MOV R4, energia_nave
    MOV R9, [R4]
energia_purpolsores:
    SUB R9, 3
    CALL converte
    MOV R1, [energia]
    JMP energia_purpolsores
    ; (das perdas de energia ao disparar e os ganhos ao minerar asteroides bons)
; energia_disparo
; energia_as_mineravel
converte:
    MOV R0, DISPLAYS
    MOV R1, R9
    MOV R3, 0
    MOV R4, 16
    MOV R5, 10
    CALL converte_aux
    MOV [R0], R3
    RET
converte_aux:
    MOV R2, R1
    MOD R2, R5
    DIV R1, R5
    MUL R2, R4
    ADD R3, R2
    SHL R4, 4
    CMP R1, 0
    JNZ converte_aux
    SHR R3, 4
    RET

;*********************************************************************************
; Interrupcoes
;*********************************************************************************
interrupcao_sonda:
    MOV [sonda1], R1 ; desbloqueia processo da sonda (qualquer registo serve)
    RFE

interrupcao_energia:
    MOV  [energia], R1
    RFE