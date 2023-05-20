DISPLAYS   EQU 0A000H  ; POUT-1
TEC_LIN    EQU 0C000H  ; POUT-2
TEC_COL    EQU 0E000H  ; PIN
LINHA      EQU 1       ; linha a testar (4� linha, 1000b)

MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

;*********************************************************************

PLACE      0
inicio:		
; inicializa��es
    MOV  R2, TEC_LIN   ; endere�o do perif�rico das linhas
    MOV  R3, TEC_COL   ; endere�o do perif�rico das colunas
    MOV  R4, DISPLAYS  ; endere�o do perif�rico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
    MOV  R7, 2

; corpo principal do programa
ciclo:
    MOV  R1, 0 
    MOVB [R4], R1      ; escreve linha e coluna a zero nos displays
reset_linha:
    MOV R6, LINHA
espera_tecla: 

    MOV  R1, R6   
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R0, 0         ; h� tecla premida?
    JZ linha_seguinte

    SHL  R1, 4      
    OR   R1, R0      
    MOVB [R4], R1  
    JMP ha_tecla

linha_seguinte:
    CMP R6, -8
    JZ reset_linha
    MUL  R6, R7
    JMP   espera_tecla 
                    
ha_tecla:              ; neste ciclo espera-se at� NENHUMA tecla estar premida
    MOV  R1, LINHA     ; testar a linha 4  (R1 tinha sido alterado)
    MOVB [R2], R1      ; escrever no perif�rico de sa�da (linhas)
    MOVB R0, [R3]      ; ler do perif�rico de entrada (colunas)
    AND  R0, R5        ; elimina bits para al�m dos bits 0-3
    CMP  R0, 0         ; h� tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera at� n�o haver
    
    JMP  ciclo         ; repete ciclo