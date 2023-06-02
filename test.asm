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
LARGURA_ASTEROIDE    EQU 5  ; Largura do asteroide
ALTURA_ASTEROIDE     EQU 5  ; Altura do asteroide
LIN        EQU 26           ; Linha inicial de desenho do painel
COL        EQU 24           ; Coluna inicial do desenho do painel
IMAGEM1    EQU 0            
IMAGEM2    EQU 1
COLUNA_SONDA    EQU 32      ; Posicao inical da sona
LINHA_SONDA     EQU 25      ; Posicao inicial da sonda
SOM1            EQU 0

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
PLACE 1000H

pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 

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
    WORD VERDE

;*********************************************************************************
;Codigo principal
;*********************************************************************************
PLACE      0

inicio:
	MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
						
apaga_imagem:
    MOV  [APAGA_AVISO], R1          ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	        ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
display:
    MOV  R9, 64H
    CALL converte1                      

menu_principal:
    MOV	 R1, IMAGEM1			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    MOV R6, LINHA                                   ; instrucao necessaria ao comeco do codigo seguinte

;*********************************************************************************
; Teclado - o codigo que se segue tem como objetivo ler os inputs do teclado
;           e avaliar o seu conteudo
;*********************************************************************************

teclado_var:           ; inicializacao dos registos referentes ao teclado
    MOV  R2, TEC_LIN   ; endereco do periferico das linhas
    MOV  R3, TEC_COL   ; endereco do periferico das colunas
    MOV  R4, DISPLAYS  ; endereco do periferico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R7, 2         ; multiplicador
    MOV  R8, 8         ; constante de comparacao
    MOV  R1, R6   
    MOVB [R2], R1      ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]      ; ler do periferico de entrada (colunas)
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JNZ teclado_var


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
    CMP R6, R8          ; caso r8 seja igual ao r6 sera necessario resetar a linha
    JZ reset_linha
    MUL  R6, R7         ; avancar a linha
    JMP   espera_tecla

ver_tecla:
    MOV R8, 0011H         ; R8 caso da tecla 0
    CMP R1, R8
    JZ tecla_1

    MOV R8, 0012H         ; R8 caso da tecla 1
    CMP R1, R8
    JZ tecla_2

    MOV R8, 0014H         ; R8 caso da tecla 2
    CMP R1, R8
    JZ tecla_3

    MOV R8, 0018H         ; R8 caso da tecla 3
    CMP R1, R8
    JZ tecla_4

    MOV R8, 0081H         ; R8 caso da tecla C
    CMP R1, R8
    JZ tecla_5

    JMP teclado_var    ; jump feito para resetar o valor dos registros caso nenhuma das teclas antecipadas seja premida

tecla_1:
    JMP apaga_asteroide 

tecla_2:
    JMP mata_sonda

tecla_3:                    ; Tecla de incrementacao ao display
    ADD  R9, 001H
    CALL converte1
    JMP  teclado_var

tecla_4:                    ; Tecla que decrementa ao display
    SUB  R9, 001H
    CALL converte1
    JMP  teclado_var

tecla_5:
    JMP  fundo_jogo

;*********************************************************************************
;Codigo painel - codigo que desenha e da setup ao painel de jogo mudando a imagem 
;                de fundo e desenhando o painel
;*********************************************************************************

fundo_jogo:
    MOV	 R1, IMAGEM2			                    ; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	            ; seleciona o cenário de fundo
    MOV  R11, 0                                     ; Registo reservado para o asteroide
    MOV  R10, 25                                    ; Registo reservado para a sonda

posicao_painel:
    MOV  R1, LIN
    MOV  R2, COL 
	MOV	 R4, painel_lista		; endereço da tabela que define o painel
    MOV  R5, [R4]			    ; linha do painel
    MOV  R7, [R4]               ; guarda a linha do painel
    ADD  R7, R2                 ; soma a coluna inicial ao tamanho da linha para saber as dimensoes maximas
    MOV  R8, [R4]               ; guarda a linha do painel
    ADD	 R4, 2                  
    MOV  R6, [R4]	            ; coluna do painel
    ADD	 R4, 2                  

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
    MOV  R5, R8             ; reseta o valor de r5 com r8
    MOV  R2, COL            ; reseta o valor da coluna para r2
    ADD  R1, 1              ; adiciona um ao r1 para avaancar a linha
    CMP  R1, R7             ; e compara o r1 com o r7 para verificar se ja chegamos a ultima linha 
    JNZ  desenha_pixels



;*********************************************************************************
;Asteroide - codigo que desenha o asteroide(Tie fighter) pixel a pixel
;*********************************************************************************


posicao_asteroide:
    MOV  R1, R11                        ; defenir linha
    MOV  R2, R11                        ; defenir coluna
	MOV	 R4, asteroide_n_mineravel	    ; endereço da tabela que define o asteroide
    MOV  R5, [R4]			            ; comprimento do asteroide
    MOV  R8, [R4]                       ; altura do asteroide
    ADD	 R4, 2
    MOV  R6, [R4]	                    ; coluna do asteroide
    MOV  R0, [R4]                       ; isto serve para a comparacao que para de o desenhar tipo isso
    ADD  R0, R1                         ; serve para a comparacao tb
    ADD	 R4, 2
    
desenha_pixels_as:       		        ; desenha os pixels do asteroide a partir da tabela
	MOV	 R3, [R4]			            ; obtém a cor do próximo pixel do asteroide
	MOV  [DEFINE_LINHA], R1	            ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	        ; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	            ; altera a cor do pixel na linha e coluna selecionadas
	ADD	 R4, 2			                ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1                          ; próxima coluna
    SUB  R5, 1			                ; menos uma coluna para tratar
    JNZ  desenha_pixels_as              ; continua até percorrer toda a largura do objeto
    
linha_pixel_seg_as:             ; segue a mesma logica do painel 
    MOV  R5, R8                 
    MOV  R2, R11                ; reseta o valor do R2 com o valor da coluna onde comeca a desenhar
    ADD  R1, 1                  ; incrmenta um ao r1 para avancar a linha
    CMP  R0, R1
    JNZ  desenha_pixels_as
    MOV  R8, LINHA_SONDA
    CMP  R10, R8                ; avanca para a sonda quando ela nao existe
    JZ   cria_sonda
    JMP  teclado_var

reset_asteroide:                ; reseta o asteroide quando ele chega a ultima linha do campo de jogo
    MOV R11, 0
    JMP posicao_painel

;*********************************************************************************
;Apagar asteroide - codigo que apaga o desenho do asteroide 
;*********************************************************************************

apaga_asteroide:                            ; desenha o asteroide a partir da tabela
    MOV    R1, R11                          ; defenir linha
    MOV    R2, R11                          ; defenir coluna
    MOV    R4, asteroide_n_mineravel        ; endereço da tabela que define o asteroide
    MOV    R5, [R4]                         ; obtém a largura do asteroide
    MOV    R8, [R4]
    ADD    R8, R1

apaga_pixels:                               ; desenha os pixels do asteroide a partir da tabela
    MOV  R3, 0                              ; para apagar, a cor do pixel é sempre 0
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    ADD  R2, 1                              ; próxima coluna
    SUB  R5, 1                              ; menos uma coluna para tratar
    JNZ  apaga_pixels                       ; continua até percorrer toda a largura do objeto

apaga_proxima_linha:
    MOV  R5, 5                  ; R5 tem o valor do tamanho do asteroide
    MOV  R2, R11                ; avanca para a coluna inicial
    ADD  R1, 1
    CMP  R1, R8                 ; comparacao para verificar se ainda ha linhas a apagar
    JNZ  apaga_pixels            
    ADD  R11, 1                 ; Avanca a posicao asteroide
    MOV R8, 31
    CMP R11, R8
    JZ  reset_asteroide         ; caso o asteroide esteja na ultima linha do painel vai reseta lo
    
    MOV R8, SOM1                ; reporducao do audio do asteroide a mover se
    MOV [REPRODUCAO], R8
    JMP  posicao_asteroide



;*********************************************************************************
;Sonda - codigo que desenha e apaga a sonda
;*********************************************************************************

cria_sonda:
    MOV  R1, R10                             ; defenir linha
    MOV  R2, COLUNA_SONDA                    ; defenir coluna
    MOV  R4, sonda
    MOV  R3, [R4]
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    JMP  teclado_var

mata_sonda:
    MOV  R1, R10                            ; defenir linha
    MOV  R2, COLUNA_SONDA                   ; defenir coluna
    MOV  R3, 0
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna selecionadas
    SUB  R10, 1
    JMP  cria_sonda 

fim:
    JMP  fim 

;*********************************************************************************
;Rotinas
;*********************************************************************************
converte1:
    MOV R0, DISPLAYS
    MOV R1, R9
    MOV R3, 0
    MOV R4, 16
    MOV R5, 10
    CALL converte2
    MOV [R0], R3
    RET
    
converte2:
    MOV R2, R1
    MOD R2, R5
    DIV R1, R5
    MUL R2, R4
    ADD R3, R2
    SHL R4, 4
    CMP R1, 0
    JNZ converte2
    SHR R3, 4
    RET