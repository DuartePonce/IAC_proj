; *********************************************************************************
; * Constantes
; *********************************************************************************
COMANDOS			EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    	EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     	EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 	EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
SOM EQU COMANDOS + 48H   ;som selector
REPRODUCAO EQU COMANDOS + 5AH  ; REPRODUZ   

N_LINHAS        	EQU  32				; número de linhas do ecrã (altura)
N_COLUNAS       	EQU  64				; número de colunas do ecrã (largura)

COR_PIXEL       	EQU 0FF00H			; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)

; *********************************************************************************
; * Código
; *********************************************************************************

inicio:
    MOV  [APAGA_AVISO], R1	 ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	 ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV	R1, 0			; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    MOV [SOM], R1

    MOV [REPRODUCAO], R1
fim:
     JMP  inicio                ; termina programa