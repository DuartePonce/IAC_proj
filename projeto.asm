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
Vermelho  EQU 0FF00H  

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
;Codigo principal
;*********************************************************************************
PLACE      0

apaga_imagem:
    MOV  [APAGA_AVISO], R1	                ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	                ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

menu_principal:
    MOV	 R1, 0			                    ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	    ; seleciona o cenário de fundo

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
    AND  R0, R5        ; elimina bits para alem dos bits 0-3
    CMP  R0, 0         ; ha tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera ate nao haver
    
    JMP  teclado_var   ; repete ciclo

ver_tecla:
    MOV R8, 11         ; uso o regidtro 8 e tenho que redefenir sempre as merdas mas a partida esta chill
    CMP R1, R8
    JZ tecla_1
    ;adicionar casos das outras teclas
    JMP teclado_var    ; jump feito para resetar o valor dos registros tipo o 8

tecla_1:
    
    JMP ha_tecla 