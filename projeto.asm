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
COR_PIXEL  EQU 0FF00H  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

;definir variaveis para cada imagem maybe fixe

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
;Codigo principal
;*********************************************************************************

apaga_imagem:
    MOV  [APAGA_AVISO], R1	                ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	                ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

menu_principal
    MOV	 R1, 0			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	    ; seleciona o cenário de fundo

