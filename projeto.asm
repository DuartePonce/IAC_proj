;*********************************************************************************
;Constantes principais a declarar:
;*********************************************************************************

DISPLAYS   EQU 0A000H  ; POUT-1
TEC_LIN    EQU 0C000H  ; POUT-2
TEC_COL    EQU 0E000H  ; PIN
LINHA      EQU 1       ; Variável de linha 
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
N_LINHAS   EQU  32	   ; número de linhas do ecrã (altura)
N_COLUNAS  EQU  64	   ; número de colunas do ecrã (largura)
LARGURA    EQU 16
ALTURA     EQU 6
LARGURA_ASTEROIDE    EQU 5
ALTURA_ASTEROIDE     EQU 5
LIN        EQU 26
COL        EQU 24
IMAGEM1    EQU 0
IMAGEM2    EQU 1
ATRASO			EQU	400H		; atraso para limitar a velocidade de movimento do boneco
COLUNA_SONDA    EQU 32

;*********************************************************************************
;Cores
;*********************************************************************************
VERMELHO        EQU 0FF00H  
ROXO_ESCURO     EQU 0F829H
ROXO_CLARO      EQU 0F62AH
PRETO           EQU 0F000H
CINZENTO        EQU 0FBBBH
CASTANHO        EQU 0F642H
;definir variaveis para cada imagem maybe fixe e tecla carregada


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
PLACE 0100H
painel_lista:
    WORD LARGURA
    WORD ALTURA
    WORD 0,0,0, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, ROXO_ESCURO, 0,0,0
    WORD 0, ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO, 0
    WORD 0, ROXO_ESCURO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_ESCURO, 0
    WORD ROXO_ESCURO, ROXO_ESCURO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_ESCURO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, CINZENTO, PRETO, CINZENTO, PRETO, CINZENTO, CINZENTO, PRETO, PRETO, PRETO, CINZENTO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO
    WORD ROXO_ESCURO, ROXO_CLARO, ROXO_CLARO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, PRETO, CINZENTO, CINZENTO, ROXO_CLARO, ROXO_CLARO, ROXO_ESCURO

asteroide_n_mineravel:
    WORD LARGURA_ASTEROIDE
    WORD ALTURA_ASTEROIDE
    WORD VERMELHO, 0,0,0, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, VERMELHO, PRETO, VERMELHO, VERMELHO
    WORD VERMELHO, 0, VERMELHO, 0, VERMELHO
    WORD VERMELHO, 0,0,0, VERMELHO

sonda:
    WORD CASTANHO

;*********************************************************************************
;Codigo principal
;*********************************************************************************
PLACE      0

apaga_imagem:
    MOV  [APAGA_AVISO], R1	                ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	                ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

menu_principal:
    MOV	 R1, IMAGEM1			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    JMP  fundo_jogo

teclado_var:                                ; inicializacao dos registos referentes ao teclado
    MOV  R2, TEC_LIN                        ; endereco do periferico das linhas
    MOV  R3, TEC_COL                        ; endereco do periferico das colunas
    MOV  R4, DISPLAYS                       ; endereco do periferico dos displays
    MOV  R5, MASCARA                        ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R7, 2                              ; multiplicador
    MOV  R8, 8                              ; constante de comparacao

reset_linha:
    MOV R6, LINHA
espera_tecla: 

    MOV  R1, R6   
    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JZ linha_seguinte

    SHL  R1, 4         ; coloca linha no nibble high 
    OR   R1, R0        ; junta coluna (nibble low)
    JMP ver_tecla            

linha_seguinte:
    CMP R6, R8
    JZ reset_linha
    MUL  R6, R7
    JMP   espera_tecla 
                    
ha_tecla:              
    MOV  R1, LINHA     ; testar a linha base ( 1 )
    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R0, 0         ; h� tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera at� n�o haver
    
    JMP  teclado_var   ; repete ciclo

ver_tecla:
    MOV R8, 0011H         ; uso o regidtro 8 e tenho que redefenir sempre as merdas mas a partida esta chill
    CMP R1, R8
    JZ tecla_1

    MOV R8, 0012H         ; uso o regidtro 8 e tenho que redefenir sempre as merdas mas a partida esta chill
    CMP R1, R8
    JZ tecla_2
    ;adicionar casos das outras teclas
    JMP teclado_var    ; jump feito para resetar o valor dos registros tipo o 8

tecla_1:
    JMP apaga_asteroide 

tecla_2:
    JMP apaga_sonda
;*********************************************************************************
;Codigo painel
;*********************************************************************************

fundo_jogo:
    MOV	 R1, IMAGEM2			                    ; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    MOV  R11, 0                                     ; Registo reservado para o asteroide
    MOV  R10, 0                                     ; Registo reservado para a sonda

posicao_boneco:
    MOV  R1, LIN
    MOV  R2, COL 
	MOV	 R4, painel_lista		; endereço da tabela que define o boneco
    MOV  R5, [R4]			    ; linha do boneco
    MOV  R7, [R4]               ; 
    ADD  R7, R2                 ;
    MOV  R8, [R4]               ;   
    ADD	 R4, 2                  ;
    MOV  R6, [R4]	            ; coluna do boneco
    ADD	 R4, 2                  ;

desenha_pixels:       		    ; desenha os pixels do boneco a partir da tabela
	MOV	 R3, [R4]			    ; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	    ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	    ; altera a cor do pixel na linha e coluna selecionadas
	ADD	 R4, 2			        ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1                  ; próxima coluna
    SUB  R5, 1			        ; menos uma coluna para tratar
    JNZ  desenha_pixels         ; continua até percorrer toda a largura do objeto

linha_pixel_seg:
    MOV  R5, R8
    MOV  R2, COL
    ADD  R1, 1
    CMP  R1, R7
    JNZ  desenha_pixels


;*********************************************************************************
;Asteroide
;*********************************************************************************

posicao_asteroide:
    MOV  R1, R11                          ; defenir linha
    MOV  R2, R11                          ; defenir coluna
	MOV	 R4, asteroide_n_mineravel	    ; endereço da tabela que define o boneco
    MOV  R5, [R4]			            ; comprimento do asteroide
    MOV  R8, [R4]                       ; altura do asteroide
    ADD	 R4, 2
    MOV  R6, [R4]	                    ; coluna do asteroide
    MOV  R9, [R4]                       ; isto serve para a comparacao que para de o desenhar tipo isso
    ADD  R9, R1                         ; serve para a comparacao tb
    ADD	 R4, 2
    
desenha_pixels_as:       		        ; desenha os pixels do boneco a partir da tabela
	MOV	 R3, [R4]			            ; obtém a cor do próximo pixel do boneco
	MOV  [DEFINE_LINHA], R1	            ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	        ; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	            ; altera a cor do pixel na linha e coluna selecionadas
	ADD	 R4, 2			                ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1                          ; próxima coluna
    SUB  R5, 1			                ; menos uma coluna para tratar
    JNZ  desenha_pixels_as              ; continua até percorrer toda a largura do objeto
    
linha_pixel_seg_as:
    MOV  R5, R8
    MOV  R2, R11
    ADD  R1, 1
    CMP  R9, R1
    JNZ  desenha_pixels_as
    JMP  teclado_var

;*********************************************************************************
;Apagar asteroide
;*********************************************************************************

apaga_asteroide:                            ; desenha o boneco a partir da tabela
    MOV    R1, R11                            ; defenir linha
    MOV    R2, R11                            ; defenir coluna
    MOV    R4, asteroide_n_mineravel        ; endereço da tabela que define o boneco
    MOV    R5, [R4]                         ; obtém a largura do boneco
    MOV    R8, [R4]
    ADD    R8, R1

apaga_pixels:                               ; desenha os pixels do boneco a partir da tabela
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_pixels                       ; continua até percorrer toda a largura do objeto

apaga_proxima_linha:
    MOV  R5, R8
    MOV  R2, R11
    ADD  R1, 1
    CMP  R1, R5
    JNZ  apaga_pixels
    ADD  R11, 1                             ; Avanca o asteroide
    JMP  posicao_asteroide

;*********************************************************************************
;Sonda
;*********************************************************************************

cria_sonda:
    MOV  R1, R10                          ; defenir linha
    MOV  R2, COLUNA_SONDA                          ; defenir coluna
	MOV	 R4, asteroide_n_mineravel	    ; endereço da tabela que define o boneco  
    

fim:
    JMP  fim 