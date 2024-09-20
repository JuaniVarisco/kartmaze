.ORIG x3000

LD R0, primer_pixel
LD R1, color_pasto
LD R2, grosor_pasto
LD R4, altura
LD R5, color_gris
LD R6, color_white

BRnzp SALTO2 
primer_pixel .FILL xC000
grosor_pasto .FILL #31
color_pasto .FILL x1EE0 ;0 00111 10111 00000
grosor_pav .FILL #20
grosor_nopasto .FILL #66
color_gris .FILL x4210
altura .FILL #124
color_white .FILL x7FFF
largo_rect_blanco .FILL	#25
largo_loop .FILL #31
inicio_rect .FILL xB33F
seis .FILL	#6
zeros .FILL xC000
SALTO2

FILA_FONDO  ;Genera del fondo, hace una linea y se repite 128 veces.

LD R2, grosor_pasto
LOOP_PASTO
STR R1, R0, #0
ADD R0, R0, #1
ADD R2, R2, #-1
BRp LOOP_PASTO

STR R6, R0, #0
LD R3, grosor_pav
LOOP_PAV1
ADD R0, R0, #1
STR R5, R0, #0
ADD R3, R3, #-1
BRp LOOP_PAV1

ADD R0, R0, #1
STR R6, R0, #0

LD R3, grosor_pav
ADD R3, R3, #2 
LOOP_PAV2
ADD R0, R0, #1
STR R5, R0, #0
ADD R3, R3, #-1
BRp LOOP_PAV2

ADD R0, R0, #1
STR R6, R0, #0

LD R3, grosor_pav
LOOP_PAV3
ADD R0, R0, #1
STR R5, R0, #0
ADD R3, R3, #-1
BRp LOOP_PAV3

ADD R0, R0, #1
STR R6, R0, #0

LD R2, grosor_pasto
LOOP_PASTO1
ADD R0, R0, #1
STR R1, R0, #0
ADD R2, R2, #-1
BRp LOOP_PASTO1

ADD R0, R0, #1
ADD R4,R4,#-1
BRp FILA_FONDO
BRnzp SALTOO


GUARDARR_R0      .BLKW 1
GUARDARR_R1      .BLKW 1
GUARDARR_R2      .BLKW 1
GUARDARR_R7      .BLKW 1

;Las lineas blancas que separan las filas se recargan cada vez que el auto se mueve
RECARGAR_CARRILES
ST R0,GUARDARR_R0
ST R1,GUARDARR_R1
ST R2,GUARDARR_R2
LD R0, zeros
LD R1, color_pasto
LD R2, grosor_pasto
LD R3, grosor_pav
LD R4, altura
LD R5, color_gris
LD R6, color_white

VUELTA
ADD R0,R0,R2
STR R6, R0, #0
ADD R0, R0, #1
ADD R0,R0,R3
STR R6, R0, #0
ADD R0, R0, #1
ADD R3,R3, #2
ADD R0,R0,R3
STR R6, R0, #0
ADD R0, R0, #1
ADD R3,R3, #-2
ADD R0, R0,R3
STR R6, R0, #0
ADD R0, R0, #1
ADD R0,R0,R2
ADD R4,R4,#-1
BRp VUELTA
LD R0,GUARDARR_R0
LD R1,GUARDARR_R1
LD R2,GUARDARR_R2
RET
esp_entre_rect .FILL #642
;GUARDAR_R0      .BLKW 1
GUARDAR_R7      .BLKW 1
SALTOO
LD R0, inicio_auto
BRnzp ESPERALETRA

;Esta función genera los rectangulos de carril del medio 
CARRIL_MEDIO
ST R0,GUARDARR_R0
ST R1,GUARDARR_R1
ST R2,GUARDARR_R2
ST R7,GUARDAR_R7
LD R3, altura
LD R4, esp_entre_rect
LD R5, color_gris
LD R6, color_white
ADD R3,R3,#-2
LD R7, seis
ADD R7,R7,#-1 ;R7=5
LOOP_RECT3
LD R0, largo_rect_blanco
STR R5, R1,#0
STR R5, R1,#1
STR R5, R1,#2
STR R5, R1,#3
STR R5, R1,#-1
STR R5, R1,#-2
ADD R1,R1,R3
ADD R1,R1,#4
LOOP_RECT2
LD R2, seis
LOOP_RECT
STR R6, R1,#0
ADD R1,R1,#1
ADD R2,R2,#-1
BRp LOOP_RECT
ADD	R1,R1,R3
ADD R0,R0,#-1 ;a
BRp LOOP_RECT2
ST R7,GUARDARR_R7
LD R0, GUARDARR_R0
JSR MOVER_AUTO
ST R0, GUARDARR_R0
LD R7,GUARDARR_R7
ADD R1, R1,R4
ADD R7,R7,#-1
BRp LOOP_RECT3
LD R0, GUARDARR_R0
LD R2, GUARDARR_R2
LD R1, GUARDARR_R1
LD R7, GUARDAR_R7
RET

ESPERALETRA
	LD R1, inicio_rect
	LD R2, largo_loop
	PIXEL ;Loop principal, cada vuelta es un frame del juego
	JSR CARRIL_MEDIO
	JSR MOVER_AUTO
	LDI R5,WAITKB  ;WAITKB es la direccion del registro que cuando se presiona una tecla, se cambia a 1 el bit 15
	BRn MOVER
	MOVER2          ;este loop realentiza cada frame restando 5 a R4(x4000) llegue a 0
	LD R4, color_rojo_osc
	espera
	ADD R4,R4,#-5
	BRp espera
	JSR MOVER_AUTO
	LD R3, grosor_pantalla
	ADD R1,R1,R3
	ADD R2,R2,#-1
	BRp PIXEL
	BRnzp ESPERALETRA

MOVER
LDI R4,TECLADO ;TECALDO es la direccion del registro que guarda el valor ASCII de la tecla que se presionó
LD R3, letraDneg
ADD R4 ,R4, R3
BRz DERECHA
LD R3, letraDpos
ADD R4 ,R4, R3
LD R3, letraAneg
ADD R4 ,R4, R3
BRz IZQUIERDA
LD R3, letraApos
ADD R4 ,R4, R3
LD R3, letraSneg
ADD R4 ,R4, R3
BRz ABAJO
LD R3, letraSpos
ADD R4 ,R4, R3
LD R3, letraWneg
ADD R4 ,R4, R3
BRz ARRIBA
BRnzp MOVER2

inicio_auto .FILL xF23A

DERECHA
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
ADD R0,R0,#2
JSR MOVER_AUTO
BRnzp VERIFICAR_COL
BRnzp MOVER2
IZQUIERDA
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
ADD R0,R0,#-2
JSR MOVER_AUTO
BRnzp VERIFICAR_COL
BRnzp MOVER2
ABAJO
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
LD R4, abajo
ADD R0,R0,R4
JSR MOVER_AUTO
BRnzp MOVER2
ARRIBA
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
LD R4, subir
ADD R0,R0,R4
JSR MOVER_AUTO
BRnzp MOVER2

;la función verifica si el auto pisa el pasto
VERIFICAR_COL
ST R1, GUARDAR_R1
LD R1,columna
LD R3,columna_izq_neg
LD R4,columna_der_neg
AND R5,R0,R1
ADD R5,R5,R3
BRz GAME_OVER
AND R5,R0,R1
ADD R5,R5,R4
BRz GAME_OVER
LD R1, GUARDAR_R1
BRnzp MOVER2
GAME_OVER
HALT

;BORRAR_AUTO "pinta" el auto pero del color de la calle 
BORRAR_AUTO
ST R1,GUARDAR_R1
ST R2,GUARDAR_R2
LD R1, color_gris
LD R2, color_gris
LD R3, color_gris
BRnzp SALTO
MOVER_AUTO ;Pinta el auto desde la direccion guardada en R0
ST R0,GUARDAR_R0
ST R1,GUARDAR_R1
ST R2,GUARDAR_R2
ST R3,GUARDAR_R3
ST R4,GUARDAR_R4
LD R1,color_rojo_osc
LD R2,color_rojo_cla
LD R3,color_negro
SALTO
ST R0,GUARDAR_R0
LD R4,grosor_pantalla

STR R1, R0, #2
STR R1, R0, #3
STR R1, R0, #4
STR R1, R0, #5
STR R1, R0, #6
STR R1, R0, #7
ADD R0, R0, R4
STR R1, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R1, R0, #7
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R3, R0, #3
STR R3, R0, #4
STR R3, R0, #5
STR R3, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R3, R0, #0
STR R2, R0, #1
STR R3, R0, #2
STR R3, R0, #3
STR R3, R0, #4
STR R3, R0, #5
STR R3, R0, #6
STR R3, R0, #7
STR R2, R0, #8
STR R3, R0, #9
ADD R0, R0, R4
STR R3, R0, #0
STR R2, R0, #1
STR R1, R0, #2
STR R1, R0, #3
STR R1, R0, #4
STR R1, R0, #5
STR R1, R0, #6
STR R1, R0, #7
STR R2, R0, #8
STR R3, R0, #9
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R3, R0, #0
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
STR R3, R0, #9
ADD R0, R0, R4
STR R3, R0, #0
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
STR R3, R0, #9
ADD R0, R0, R4
STR R2, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R2, R0, #8
ADD R0, R0, R4
STR R1, R0, #1
STR R2, R0, #2
STR R2, R0, #3
STR R2, R0, #4
STR R2, R0, #5
STR R2, R0, #6
STR R2, R0, #7
STR R1, R0, #8
ADD R0, R0, R4
STR R1, R0, #2
STR R1, R0, #3
STR R1, R0, #4
STR R1, R0, #5
STR R1, R0, #6
STR R1, R0, #7
LD R0,GUARDAR_R0
LD R1,GUARDAR_R1
LD R2,GUARDAR_R2
LD R3,GUARDAR_R3
LD R4,GUARDAR_R4
RET
GUARDAR_R0      .BLKW 1
GUARDAR_R1      .BLKW 1
GUARDAR_R2      .BLKW 1
GUARDAR_R3      .BLKW 1
GUARDAR_R4      .BLKW 1
GUARDAR_R5      .BLKW 1
GUARDAR_R6      .BLKW 1


TECLADO .FILL xFE02
letraDneg .FILL #-100
letraDpos .FILL #100
letraAneg .FILL #-97
letraApos .FILL #97
letraSneg .FILL #-115
letraSpos .FILL #115
letraWneg .FILL #-119
letraWpos .FILL #119
WAITKB	.FILL xFE00	
color_negro .FILL x0000
color_rojo_osc .FILL x4000
color_rojo_cla .FILL x7C00

grosor_pantalla.FILL #128
abajo.FILL #256
subir.FILL #-256
columna.FILL x00FF
columna_der_neg .FILL #-88
columna_izq_neg .FILL #-30
