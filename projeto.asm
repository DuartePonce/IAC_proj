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
SONDA2_LINHA    EQU 25
SONDA2_COLUNA   EQU 31
SONDA3_LINHA    EQU 25
SONDA3_COLUNA   EQU 39

ENERGIA_INICIAL EQU 103
PIN   EQU 0E000H ; endereço do periférico PIN (entrada)
TIPO 	EQU 0
COLUNA 	EQU 0
DIRECAO	EQU 0
ASTEROIDE_ESQ EQU 0
ASTEROIDE_MEIO EQU 29
ASTEROIDE_DIR EQU 59

;*********************************************************************************
;Cores
;*********************************************************************************
ROXO_ESCURO     EQU 0F829H
ROXO_CLARO      EQU 0F62AH
PRETO           EQU 0F000H
CINZENTO        EQU 0FBBBH

VERMELHO        EQU 0FF00H  
VERDE           EQU 0F6F6H
AZUL            EQU 0F0FFH
AMARELO         EQU 0FFF0H
ROSA            EQU 0FF0FH
AZUL_VERDE      EQU 0F0FAH
AMARELO_FRACO   EQU 0FFDAH
LARANJA         EQU 0DF80H
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
ECRA                     EQU COMANDOS + 04H     ; Seleciona ecras
OBTEM_COR                EQU COMANDOS + 10H   ;Obtem cor

;*********************************************************************************
;Zona de dados
;*********************************************************************************
PLACE 2000H
painel_lista:

    WORD 0,0,0, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, 0,0,0
    WORD 0, ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO, 0
    WORD 0, ROXO_ESCURO, ROXO_CLARO, 0, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, 0, ROXO_CLARO, ROXO_ESCURO, 0
    WORD ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, CINZENTO, PRETO, CINZENTO, PRETO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, CINZENTO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, 0, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, 0, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO

asteroide_n_mineravel:
    WORD VERMELHO, 0,0,0, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, VERMELHO, PRETO, VERMELHO, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, 0,0,0, VERMELHO

asteroide_mineravel:
    WORD 0, CINZENTO, CINZENTO, CINZENTO, 0
    WORD CINZENTO, AZUL, CINZENTO, VERDE, CINZENTO
    WORD CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO
    WORD CINZENTO, AMARELO, CINZENTO, VERMELHO, CINZENTO
    WORD 0, CINZENTO, CINZENTO, CINZENTO, 0
explosao_sprite:
    WORD VERMELHO, 0, 0, VERMELHO, 0
    WORD 0, 0, VERMELHO, 0, VERMELHO
    WORD 0, VERMELHO, 0, 0, 0
    WORD 0, 0, 0, VERMELHO, 0
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
sonda:
    WORD VERDE
qual_asteroide:
    WORD  1
cores_possiveis:
    WORD VERDE, VERMELHO, AZUL, AMARELO, ROSA, AZUL_VERDE, AMARELO_FRACO, LARANJA
coordenadas_cor:
    WORD  28, 27
    WORD  31, 27
    WORD  31, 36
    WORD  28, 36
tab:
    WORD    interrupcao_asteroide
    WORD    interrupcao_sonda
    WORD    interrupcao_energia   
    WORD    interrupcao_cores

sondas:
    WORD SONDA1_CORD, SONDA1_CORD
    WORD SONDA2_LINHA, SONDA2_COLUNA
    WORD SONDA3_LINHA, SONDA3_COLUNA

sonda_ligada:
    WORD 0
    WORD 0
    WORD 0
impacto_flags:
    WORD 0 ;Flag de impacto sonda 1
    WORD 0 ;Flag de impacto sonda 2
    WORD 0 ;Flag de impacto sonda 3
descontar:
    WORD 0
tab_asteroide:
	WORD TIPO, COLUNA, DIRECAO

tab_col:
	WORD 0FFFFH, 0, 0, 0, 1
tab_dir:
	WORD 1, 0FFFFH, 0, 1, 0FFFFH
asteroide_atuais:
    WORD 0
    WORD 0
    WORD 0
    WORD 0

energia_nave:
    WORD ENERGIA_INICIAL
termina_jogo:
    WORD 0
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
SP_sonda2:

    STACK 100H
SP_sonda3:

    STACK 100H
SP_energia:
    STACK 100H
SP_asteroide:

    STACK 100H
SP_cores:

	
tecla_carregada:
	LOCK 0
sonda1:
    LOCK 0
sonda2:
    LOCK 0
sonda3:
    LOCK 0
energia:
    LOCK 0
asteroide:
    LOCK 0
cores:
    LOCK 0

;*********************************************************************************
;Codigo principal
;*********************************************************************************
PLACE      0

inicio:
    MOV  SP, SP_inicial
    MOV  BTE, tab
    MOV  [APAGA_AVISO], R1          ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    EI0
    EI1
    EI2
    EI3
    EI
menu_principal:
    MOV	 R1, IMAGEM1			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    CALL teclado
obtem_tecla:	
	MOV	R1, [tecla_carregada]	; bloqueia neste LOCK até uma tecla ser carregada
    
    MOV R3, 81H   
    CMP	R1, R3		; é a coluna da tecla C?
	JZ	testa_C

    MOV R3, 11H   
    CMP	R1, R3		; é a coluna da tecla 0?
	JZ	testa_0

    MOV R3, 12H   
    CMP	R1, R3		; é a coluna da tecla 1?
	JZ	testa_1

    MOV R3, 14H   
    CMP	R1, R3		; é a coluna da tecla 2?
	JZ	testa_2


    JMP obtem_tecla

testa_C:
    MOV R4, termina_jogo ; jogo começa
    MOV R7, 0
    MOV [R4], R7
    CALL fundo_jogo

    CALL inicio_cor
    MOV [energia], R1

    CALL energia_inicio

    
    CALL inicia_asteroide
    CALL inicia_asteroide
    CALL inicia_asteroide
    CALL inicia_asteroide

    JMP obtem_tecla

testa_0:
    MOV R2, sonda_ligada
    MOV R0, [R2]
    CMP R0, 0
    JNZ obtem_tecla

    MOV R0, 1
    MOV [R2], R0
    CALL sonda_1

    MOV R10, descontar
    MOV [R10], R0

    MOV [energia], R1
     
    
    JMP obtem_tecla

testa_1:
    MOV R2, sonda_ligada
    MOV R0, [R2+2]
    CMP R0, 0
    JNZ obtem_tecla

    MOV R0, 1
    MOV [R2+2], R0
    CALL sonda_2

    MOV R10, descontar
    MOV [R10], R0

    MOV [energia], R1
    

    JMP obtem_tecla

testa_2:
    MOV R2, sonda_ligada
    MOV R0, [R2+4]
    CMP R0, 0
    JNZ obtem_tecla

    MOV R0, 1
    MOV [R2+4], R0
    CALL sonda_3

    MOV R10, descontar
    MOV [R10], R0


    MOV [energia], R1
    JMP obtem_tecla
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
; SONDA 1
;*********************************************************************************

PROCESS SP_sonda1
sonda_1:
    MOV R1, 1
    MOV [ECRA], R1
    MOV R4, sondas
    MOV R1, [R4]
ciclo_sonda1:
    MOV R10, termina_jogo
    MOV [R10], R11
    CMP R11, 1
    JZ termina_sonda1
    CALL desenhar_sonda1
    CMP R5, 1
    JZ termina_sonda1
    MOV R2, [sonda1]    ; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL apagar_sonda1

    MOV R5, 13 ; verifica se chegou ao limite
    CMP R5, R1
    JNZ ciclo_sonda1
termina_sonda1:
    MOV R4, sondas
    MOV R1, SONDA1_CORD 
    MOV [R4], R1 
    MOV [R4 + 2], R1

    MOV R0, sonda_ligada
    MOV R1, 0H
    MOV [R0], R1
    RET
desenhar_sonda1:
    MOV R6, R1 
    SUB R6, 1
    MOV R7, R1
    SUB R7, 1
    MOV  [DEFINE_LINHA], R6	    ; seleciona a linha
    MOV  [DEFINE_COLUNA], R7	; seleciona a coluna
    MOV R5, [OBTEM_COR]
    CMP R5, 0
    JNZ impacto1
    MOV R3, VERDE
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R1	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
    RET
apagar_sonda1:
    MOV R3, 0
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R1	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas

    SUB R1, 1
    MOV [R4], R1
    MOV [R4 + 2], R1

    RET
impacto1:
    MOV R4, impacto_flags
    MOV R5, 1
    MOV [R4], R5
    MOV [asteroide], R1
    RET
;*********************************************************************************
; SONDA 2
;*********************************************************************************

PROCESS SP_sonda2
sonda_2:
    MOV [ECRA], R1
    MOV R4, sondas
    MOV R1, [R4 + 4]
    MOV R2, [R4 + 6]
ciclo_sonda2:
    MOV R10, termina_jogo
    MOV [R10], R11
    CMP R11, 1
    JZ termina_sonda2
    CALL desenhar_sonda2
    CMP R5, 1
    JZ termina_sonda2
    MOV R0, [sonda2]    ; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL apagar_sonda2

    MOV R5, 13 ; verifica se chegou ao limite
    CMP R5, R1
    JNZ ciclo_sonda2
termina_sonda2:
    MOV R4, sondas
    MOV R1, SONDA2_LINHA
    MOV R2, SONDA2_COLUNA
    MOV [R4 + 4], R1
    MOV [R4 + 6], R2

    MOV R0, sonda_ligada
    MOV R1, 0H
    MOV [R0 + 2], R1
    RET
desenhar_sonda2: ; primeiro verifica
    MOV R6, R1 
    SUB R6, 1
    MOV  [DEFINE_LINHA], R6	    ; seleciona a linha
    MOV R5, [OBTEM_COR]
    CMP R5, 0
    JNZ impacto2
    MOV R3, VERDE
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
    RET
apagar_sonda2:
    MOV R3, 0
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas

    SUB R1, 1
    MOV [R4 + 4], R1
    MOV [R4 + 6], R2
    RET

impacto2:
    MOV R4, impacto_flags
    MOV R5, 1
    MOV [R4 + 2], R5
    MOV [asteroide], R1
    RET
;*********************************************************************************
; SONDA 3
;*********************************************************************************

PROCESS SP_sonda3
sonda_3:
    MOV R1, 1
    MOV [ECRA], R1
    MOV R4, sondas
    MOV R1, [R4 + 8]
    MOV R2, [R4 + 10]
ciclo_sonda3:
    MOV R10, termina_jogo
    MOV [R10], R11
    CMP R11, 1
    JZ termina_sonda3
    CALL desenhar_sonda3
    CMP R5, 1
    JZ termina_sonda3
    MOV R0, [sonda3]    ; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL apagar_sonda3

    MOV R5, 13 ; verifica se chegou ao limite
    CMP R5, R1
    JNZ ciclo_sonda3
termina_sonda3:
    MOV R4, sondas
    MOV R1, SONDA3_LINHA
    MOV R2, SONDA3_COLUNA 
    MOV [R4 + 8], R1 
    MOV [R4 + 10], R2

    MOV R0, sonda_ligada
    MOV R1, 0H
    MOV [R0 + 4], R1
    RET
desenhar_sonda3:
    ;********************* FAZ DEPOIS ROTINA
    MOV R6, R1 
    SUB R6, 1
    MOV  [DEFINE_LINHA], R6	    ; seleciona a linha
    MOV R5, [OBTEM_COR]
    CMP R5, 0
    JNZ impacto3
    MOV R3, VERDE
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
    RET
apagar_sonda3:
    MOV R3, 0
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas

    SUB R1, 1
    ADD R2, 1
    MOV [R4 + 8], R1
    MOV [R4 + 10], R2
    RET

impacto3:
    MOV R4, impacto_flags
    MOV R5, 1
    MOV [R4 + 4], R5
    MOV [asteroide], R1
    RET
;*********************************************************************************
;Processo Energia
;*********************************************************************************

PROCESS SP_energia
energia_inicio:
    MOV R4, energia_nave
    MOV R9, [R4]
energia_purpolsores:
    MOV R10, descontar
    MOV R11, [R10]

    CMP R11, 1
    JZ sub_5
    CMP R11, 2
    JZ energia_as_mineravel
    JMP sub_3
energia_ciclo:
    CMP R9, 1
    JLT termina_puta ;TERMINA ESTE JOGO DE MERDA AHGASDGHJKSABGKAJSB
    CALL converte
    MOV R1, [energia]
    JMP energia_purpolsores
termina_energia:
    RET
sub_3:
    SUB R9, 3
    JMP energia_ciclo
sub_5:
    SUB R9, 5

    MOV R10, descontar
    MOV R0, 0
    MOV [R10], R0 

    JMP energia_ciclo
energia_as_mineravel:
    MOV R6, 25H
    ADD R9, R6
    MOV R0, 0
    MOV [R10], R0 
    JMP energia_ciclo

termina_puta:
    MOV R6, termina_jogo ;ativa a flag para terminar o jogo
    MOV R7, 1
    MOV [R6], R7
    MOV [APAGA_AVISO], R1
    MOV [APAGA_ECRÃ], R1
    JMP termina_energia

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
; Asteroide 
;*********************************************************************************
PROCESS SP_asteroide
inicia_asteroide:
    CALL gerador_asteroide

    MOV R4, qual_asteroide
    MOV R1, [R4]
    MOV [ECRA], R1 
    CALL incrementar_asteroide

    MOV R4, tab_asteroide
    MOV R1, [R4]
    MOV R2, [R4 + 2]
    MOV R3, [R4 + 4]
    JMP tipo_asteroide
tipo_asteroide:
    CMP R1, 0
    JZ inicia_mineravel

    JMP inicia_n_mineravel
inicia_mineravel:
    MOV R1, asteroide_mineravel
    MOV R6, R1
    JMP posicao_asteroide
inicia_n_mineravel:
    MOV R1, asteroide_n_mineravel
    MOV R6, R1
    JMP posicao_asteroide
posicao_asteroide:
    MOV R5, 5 ; comprimento e largura
    MOV R7, 0 ; linha
    MOV R9, 31 ; limite
    MOV R10, 5
    CMP R2, 0FFFFH
    JZ inicia_esq

    CMP R2, 0
    JZ inicia_meio

    CMP R2, 1
    JZ inicia_dir
inicia_esq:
    MOV R2, ASTEROIDE_ESQ ; coluna inicial
    JMP ciclo_esq
inicia_meio:
    MOV R2, ASTEROIDE_MEIO

    MOV R11, 0FFFFH
    CMP R3, R11
    JZ ciclo_esq

    MOV R11, 1
    CMP R3, R11
    JZ ciclo_dir

    JMP ciclo_meio

inicia_dir:
    MOV R2, ASTEROIDE_DIR
    JMP ciclo_dir
asteroide_destruido_esq:
    MOV R1, explosao_sprite
    MOV R8, impacto_flags
    MOV R11, 0
    MOV [R8], R11
    MOV R6, [R4]

    CMP R6, 0
    JZ aumenta_energia
termina_asteroide_esq:
    CALL inicia_asteroide
    CALL desenha_pixels_as
    MOV R1, [asteroide]
    MOV R1, [asteroide]
    CALL apaga_as_esq
termina_defenitivamente_esq:
    RET
asteroide_destruido_meio:
    MOV R1, explosao_sprite
    MOV R8, impacto_flags
    MOV R11, 0
    MOV [R8 + 2], R11
    MOV R6, [R4]
    ;aumenta energia 25
    CMP R6, 0
    JZ aumenta_energia
termina_asteroide_meio:
    CALL inicia_asteroide
    CALL desenha_pixels_as
    MOV R1, [asteroide]
    MOV R1, [asteroide]
    CALL apaga_as_meio
termina_defenitivamente_meio:
    RET
asteroide_destruido_dir:
    MOV R1, explosao_sprite
    MOV R8, impacto_flags
    MOV R11, 0
    MOV [R8 + 4], R11
    MOV R6, [R4]

    CMP R6, 0
    JZ aumenta_energia
termina_asteroide_dir:
    CALL inicia_asteroide
    CALL desenha_pixels_as
    MOV R1, [asteroide]
    MOV R1, [asteroide]
    CALL apaga_as_dir
termina_defenitivamente_dir:
    RET
aumenta_energia:
    MOV [energia], R1
    PUSH R3
    MOV R3, 2
    MOV R6, descontar
    MOV [R6], R3
    POP R3
    CMP R3, 0FFFFH
    JZ termina_asteroide_esq
    CMP R3, 0
    JZ termina_asteroide_meio
    CMP R3, 1
    JZ termina_asteroide_dir
ciclo_esq:
    PUSH R1
    PUSH R2
    MOV R2, termina_jogo
    MOV R1, [R2]
    CMP R1, 1
    JZ termina_defenitivamente_esq
    POP R2
    POP R1
    CALL desenha_pixels_as

    MOV R8, impacto_flags
    MOV R11, [R8]
    CMP R11, 0
    JNZ  asteroide_destruido_esq

    MOV R1, [asteroide]
    CALL apaga_as_esq
    ADD R7, 1
    ADD R10, 1
    MOV R1, R6
    CMP R7, R9
    JNZ ciclo_esq
ciclo_meio:
    PUSH R1
    PUSH R2
    MOV R2, termina_jogo
    MOV R1, [R2]
    CMP R1, 1
    JZ termina_asteroide_meio
    POP R2
    POP R1
    CALL desenha_pixels_as

    MOV R8, impacto_flags
    MOV R11, [R8 + 2]
    CMP R11, 1
    JZ  asteroide_destruido_meio

    MOV R1, [asteroide]
    CALL apaga_as_meio
    ADD R7, 1
    ADD R10, 1
    MOV R1, R6
    CMP R7, R9
    JNZ ciclo_meio

ciclo_dir:
    PUSH R1
    PUSH R2
    MOV R2, termina_jogo
    MOV R1, [R2]
    CMP R1, 1
    JZ termina_asteroide_dir
    POP R2
    POP R1
    CALL desenha_pixels_as

    MOV R8, impacto_flags
    MOV R11, [R8 + 4]
    CMP R11, 0
    JNZ  asteroide_destruido_dir

    MOV R1, [asteroide]
    CALL apaga_as_dir
    ADD R7, 1
    ADD R10, 1
    MOV R1, R6
    CMP R7, R9
    JNZ ciclo_dir

desenha_pixels_as:
    MOV R8, [R1]
    MOV [DEFINE_LINHA], R7
    MOV [DEFINE_COLUNA], R2
    MOV [DEFINE_PIXEL], R8
    ADD R1, 2 ;proxima cor
    ADD R2, 1 ;proxima coluna
    SUB R5, 1 ; 0 chegou ao fim do comprimento
    JNZ desenha_pixels_as
linha_pixel_seg_as:
    MOV R5, 5 ;reset comprimento
    ADD R7, 1 ;proxima linha
    SUB R2, 5 ;reset coluna
    CMP R7, R10
    JNZ desenha_pixels_as
    SUB R7, 5
    RET
apaga_as_esq:
    CALL apaga_pixeis_as
    ADD R2, 1
    RET
apaga_as_meio:
    CALL apaga_pixeis_as
    RET
apaga_as_dir:
    CALL apaga_pixeis_as
    SUB R2, 1
    RET
apaga_pixeis_as:
    MOV R8, 0
    MOV [DEFINE_LINHA], R7
    MOV [DEFINE_COLUNA], R2
    MOV [DEFINE_PIXEL], R8
    ADD R1, 2
    ADD R2, 1
    SUB R5, 1
    JNZ apaga_pixeis_as
apaga_linha_seg:
    MOV R5, 5
    ADD R7, 1
    SUB R2, 5
    CMP R7, R10
    JNZ apaga_pixeis_as
    SUB R7, 5
    RET
gerador_asteroide:
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R1, PIN 			; move o endereço do PIN para R1
	MOVB R2, [R1] 			; move os bits 0-7 do PIN para R2
	SHR R2, 4 				; remove os 4 bits mais à direita
	MOV R3, tab_asteroide	; coloca a tabela do asteróide no R3
	CALL determina_tipo
	CALL determina_pos
	POP R3
	POP R2
	POP R1
	RET

determina_tipo:
	PUSH R4
	MOV R4, R2 		; coloca o número aleatório no R4
	SHR R4, 2 		; remove os 2 bits mais à direita
	MOV [R3], R4 	; coloca o número aleatório na tabela
	POP R4
	RET
	
determina_pos:
	PUSH R4
	PUSH R5
	MOV R5, R2 			; coloca o número aleatório no R5
	MOV R4, 5 			; coloca um 5 no R4 para efetuar o MOD
	MOD R5, R4 			; resto da divisão por 5
	MOV R2, R5 			; o número aleatório passa para o R2
	ADD R3, 2 			; avança para a WORD coluna
	MOV [R3], R5 		; coloca o número na tabela
	CALL determina_col
	CALL determina_dir
	POP R5
	POP R4
	RET

determina_col:
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R5, R2 		; vai buscar o número aleatório [0, 4]
	MOV R6, tab_col ; coloca a tabela das colunas no R6
	SHL R5, 1 		; multiplica o número por 2 (para incrementar tab_ast)
	ADD R6, R5 		; encontra o endereço da tabela de colunas correspondente ao número gerado
	MOV R7, [R6] 	; move a coluna correspondente para R7
	MOV [R3], R7 	; coloca na tabela a coluna correspondente
	POP R7
	POP R6
	POP R5
	RET

determina_dir:
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R5, R2		; vai buscar o número aleatório [0, 4]
	MOV R6, tab_dir	; coloca a tabela das direções no R6
	SHL R5, 1 		; multiplica o número por 2
	ADD R6, R5 		; encontra o endereço da tabela de direções correspondente ao número gerado
	MOV R7, [R6] 	; move a direção correspondente para R7
	ADD R3, 2 		; passa a apontar para a WORD direção
	MOV [R3], R7 	; coloca na tabela a direção correspondente
	POP R7
	POP R6
	POP R5
	RET
    
incrementar_asteroide: ;funcao que avanca qual o ecra do asteroide
    PUSH R1
    PUSH R2 
    PUSH R3
aux:
    MOV R3, 1       ;Mov por causa dos erros de passar so uma variavel
    MOV R1, qual_asteroide
    MOV R2, [R1]
    ADD R2, 1
    CMP R2, 6
    JZ resetar_qual
fim_incrementa:
    POP R3
    POP R2
    POP R1
    RET
resetar_qual:

    MOV [R1], R3
    JMP aux
;*********************************************************************************
;Processo Cores
;*********************************************************************************
PROCESS SP_cores
inicio_cor:
    MOV R0, 1
    MOV [ECRA], R0
    MOV R0, 4
    MOV R1, [cores]
ciclo_cor:
    MOV R4, termina_jogo
    MOV R5, [R4]
    CMP R5, 1
    JZ termina_cor
    MOV R3, 0
    CALL gerador_cor
    SUB R0, 1
    CALL pinta
    CMP R0, 0
    JNZ ciclo_cor
    JMP inicio_cor
termina_cor:
    RET
gerador_cor:
    PUSH R1
    PUSH R2
    PUSH R0 
    
    MOV R0, 2
    MOV R1, PIN ; move o endereço do PIN para R1
    MOVB R2, [R1] ; move os bits 0-7 do PIN para R2
    SHR R2, 5 ; remove os 5 bits mais à direita (para chegar a um número de 0 a 7)
    MOV R4, cores_possiveis
    MUL R2, R0
    MOV R3, [R4 + R2]

    POP R0 
    POP R2
    POP R1 
    RET
pinta:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R0

    MOV R4, coordenadas_cor
    MOV R2, 4
    MUL R0, R2
    MOV R1, [R4 + R0]
    MOV [DEFINE_LINHA], R1
    ADD R0, 2
    MOV R2, [R4 + R0]
    MOV [DEFINE_COLUNA], R2 
    MOV [DEFINE_PIXEL], R3

    POP R0 
    POP R4 
    POP R3 
    POP R2
    POP R1
    RET
;*********************************************************************************
; Interrupcoes
;*********************************************************************************
interrupcao_asteroide:
    MOV [asteroide], R1
    RFE
interrupcao_sonda:

    MOV [sonda1], R1
    MOV [sonda3], R1
    MOV [sonda2], R1

    RFE

interrupcao_energia:
    MOV  [energia], R1
    RFE

interrupcao_cores:
    MOV  [cores], R1
    RFE