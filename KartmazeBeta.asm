.ORIG x3000 ;Establece la dirección de origen del programa


LD R0, primer_pixel	; Cargar la dirección del primer píxel en el registro R0
LD R1, color_pasto	; Cargar el color del pasto en el registro R1
LD R2, grosor_pasto 	; Cargar el grosor del pasto en el registro R2
LD R4, altura 		; Cargar la altura de la representación gráfica en el registro R4
LD R5, color_gris	; Cargar el color gris en el registro R5
LD R6, color_white	; Cargar el color blanco en el registro R6



BRnzp SALTO2 	; Salta a la etiqueta SALTO2 si el resultado de la operación anterior no es cero

; Definiciones de variables y constantes
primer_pixel .FILL xC000	; Dirección del primer píxel (en memoria)
grosor_pasto .FILL #31		; Grosor del pasto (valor numérico)
color_pasto .FILL x1EE0 	; Color del pasto, 0 00111 10111 00000 (código de color en binario)
grosor_pav .FILL #20		; Grosor del pavimento (valor numérico)
grosor_nopasto .FILL #66 	; Grosor de áreas sin pasto (valor numérico)

altura .FILL #124 		; Altura de la representación gráfica
color_white .FILL x7FFF 	; Color blanco (código de color)
largo_rect_blanco .FILL	#25 	; Largo de rectángulo blanco (valor numérico)
largo_loop .FILL #31		; Largo de un bucle (valor numérico)
inicio_rect .FILL xB33F		; Dirección de inicio de un rectángulo (en memoria)
seis .FILL	#6 		; Valor constante seis
zeros .FILL xC000 		; Dirección para ceros (en memoria)
cero .FILL #1

SALTO2		; Etiqueta para el salto



;Generación del fondo
FILA_FONDO  ;Genera el fondo, hace una linea y se repite 128 veces.

LD R2, grosor_pasto 	; Cargar grosor del pasto en R2
LOOP_PASTO 		; Bucle que pinta el pasto en la pantalla, almacenando el color cargado en R1 en direcciones de memoria consecutivas.
STR R1, R0, #0 		; Almacenar el color del pasto en la dirección de R0
ADD R0, R0, #1		; Incrementar R0 para el siguiente píxel
ADD R2, R2, #-1		; Decrementar el grosor
BRp LOOP_PASTO 		; Repetir hasta que R2 llegue a cero, completandose la linea de pasto


;Generación del pavimento
STR R6, R0, #0 		; Almacenar color blanco en la dirección de R0
LD R3, grosor_pav
LOOP_PAV1
ADD R0, R0, #1		; Incrementar R0
STR R5, R0, #0		; Almacenar color gris
ADD R3, R3, #-1		; Decrementar grosor del pavimento
BRp LOOP_PAV1		; Repetir hasta que R3 llegue a cero


ADD R0, R0, #1
STR R6, R0, #0 		; Almacenar blanco para separar en la pantalla

LD R3, grosor_pav
ADD R3, R3, #2 		; Ajustar grosor
LOOP_PAV2
ADD R0, R0, #1
STR R5, R0, #0		; Almacenar gris nuevamente
ADD R3, R3, #-1
BRp LOOP_PAV2

ADD R0, R0, #1
STR R6, R0, #0		; Almacenar blanco

LD R3, grosor_pav
LOOP_PAV3
ADD R0, R0, #1
STR R5, R0, #0		; Almacenar gris
ADD R3, R3, #-1
BRp LOOP_PAV3		; Repetir hasta que R3 llegue a cero

ADD R0, R0, #1
STR R6, R0, #0		; Almacenar blanco

LD R2, grosor_pasto
LOOP_PASTO1
ADD R0, R0, #1
STR R1, R0, #0		; Almacenar el color del pasto
ADD R2, R2, #-1
BRp LOOP_PASTO1

ADD R0, R0, #1		; Incrementar para la siguiente fila
ADD R4,R4,#-1		; Decrementar altura
BRp FILA_FONDO		; Repetir hasta que la altura llegue a cero
BRnzp SALTOO

; Reservas de memoria para guardar registros
GUARDARR_R0      .BLKW 1
GUARDARR_R1      .BLKW 1
GUARDARR_R2      .BLKW 1
GUARDARR_R3      .BLKW 1
GUARDARR_R7      .BLKW 1

;Las lineas blancas que separan las filas se recargan cada vez que el auto se mueve
RECARGAR_CARRILES
;Guardar los valores de los registros en memoria temporal
ST R0,GUARDARR_R0
ST R1,GUARDARR_R1
ST R2,GUARDARR_R2
; Carga de valores iniciales para comenzar el proceso de recarga de los carriles
LD R0, zeros
LD R1, color_pasto
LD R2, grosor_pasto
LD R3, grosor_pav
LD R4, altura
LD R5, color_gris
LD R6, color_white


;vuelta dibuja un conjunto de rectángulos blancos y ajusta la posición y grosor de los carriles en un bucle,
;              reduciendo la altura en cada iteración hasta que la condición del bucle ya no se cumpla
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
esp_entre_rect .FILL #642	; Espacio entre los rectángulos blancos en los carriles
;GUARDAR_R0      .BLKW 1
GUARDAR_R7      .BLKW 1
GUARDAR_CONO 	.BLKW 1
QUECARRIL		.BLKW 1

SALTOO
LD R0, inicio_auto
LD R3,carril_izquierdo
ST R3,GUARDAR_CONO
LD R5,altura
ADD R5,R5,#14
ST R5,GUARDAR_CONTADOR
LD R6, cero ;ES 1
ST R6, QUECARRIL
BRnzp ESPERALETRA

;carril_medio genera los rectangulos de carril del medio 
CARRIL_MEDIO
ST R0,GUARDARR_R0
ST R1,GUARDARR_R1
ST R2,GUARDARR_R2
ST R3,GUARDARR_R3
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
; Bucle para crear los rectángulos blancos
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
JSR MOVER_AUTO 			; Llama a la función para mover el auto
ST R0, GUARDARR_R0
LD R7,GUARDARR_R7
ADD R1, R1,R4
ADD R7,R7,#-1
BRp LOOP_RECT3
LD R0, GUARDARR_R0
LD R2, GUARDARR_R2
LD R1, GUARDARR_R1
LD R3,GUARDARR_R3
LD R7, GUARDAR_R7
RET

carril_derecha .FILL xBBD2
carril_centro .FILL xBBBB
carril_izquierdo .FILL xBBA6

GUARDAR_CONTADOR .BLKW 1

CADA128FRAMES

LD R6, QUECARRIL
ADD R6,R6,#-1
BRz derecha
ADD R6,R6,#-1
BRz centro
ADD R6,R6,#-1
BRz izquierda

derecha
LD R3, carril_derecha
ADD R6,R6,#2
ST R6, QUECARRIL
BRnzp PORACA

centro
LD R3, carril_centro
ADD R6,R6,#3
ST R6, QUECARRIL
BRnzp PORACA

izquierda
LD R3, carril_izquierdo
ADD R6,R6,#1
ST R6, QUECARRIL

PORACA
ST R3, GUARDAR_CONO
LD R5, grosor_pantalla
ADD R5,R5, #10
ST R5, GUARDAR_CONTADOR
RET

; esperaletra controla el bucle principal del juego, llamando a las subrutinas de movimiento del auto y de los carriles,
;              y esperando la entrada del teclado para continuar.
ESPERALETRA
	LD R1, inicio_rect
	LD R2, largo_loop

	PIXEL ;Loop principal, cada vuelta es un frame del juego
	JSR CARRIL_MEDIO
	JSR MOVER_AUTO
	LD R3,GUARDAR_CONO
	JSR DIBUJAR_CONO
	ST R3, GUARDAR_CONO

	LD R3,GUARDAR_CONO
	JSR BORRAR_CONO
	LD R4, grosor_pantalla
	ADD R3,R3,R4
	JSR DIBUJAR_CONO
	ST R3, GUARDAR_CONO
	JSR VERIFICAR_CONO
	LD R5, GUARDAR_CONTADOR 
	ADD R5,R5,#-1
	BRnp SIGUE
	JSR CADA128FRAMES
	SIGUE
	ST R5, GUARDAR_CONTADOR


	LDI R5,WAITKB  ;WAITKB es la direccion del registro que cuando se presiona una tecla, se cambia a 1 el bit 15
	BRn MOVER

	MOVER2          ;este loop realentiza cada frame restando 5 a R4(x4000) llegue a 0
	LD R4, color_rojo_osc
	espera
	ADD R4,R4,#-9
	BRp espera

	JSR MOVER_AUTO
	LD R3, grosor_pantalla
	ADD R1,R1,R3
	ADD R2,R2,#-1
	BRp PIXEL
	BRnzp ESPERALETRA

; MOVER: Controla el movimiento del auto basado en la entrada del teclado.
; Input: R0 - Posición actual del auto
; Output: R0 - Nueva posición del auto después del movimiento
MOVER		
LDI R4,TECLADO			 ;TECALDO es la direccion del registro que guarda el valor ASCII de la tecla que se presionó
LD R3, letraDneg		 ;Carga un valor asociado a la tecla de movimiento negativo hacia la derecha
ADD R4 ,R4, R3			 ;Si el resultado es cero (BRz DERECHA), significa que se ha presionado la tecla para mover el auto a la derecha
BRz DERECHA			 
LD R3, letraDpos
ADD R4 ,R4, R3
LD R3, letraAneg		;Carga un valor asociado a la tecla de movimiento negativo hacia la izquierda.
ADD R4 ,R4, R3			;Suma este valor a R4. Si el resultado es cero (BRz IZQUIERDA), salta a la etiqueta IZQUIERDA
BRz IZQUIERDA
LD R3, letraApos
ADD R4 ,R4, R3
LD R3, letraSneg		;Carga un valor para movimiento negativo hacia abajo.
ADD R4 ,R4, R3			;Suma este valor a R4. Si es cero (BRz ABAJO), salta a la etiqueta ABAJO
BRz ABAJO
LD R3, letraSpos
ADD R4 ,R4, R3
LD R3, letraWneg
ADD R4 ,R4, R3
BRz ARRIBA
BRnzp MOVER2			;Si R4 no es cero, se regresa al bucle MOVER2, que controla el tiempo de espera entre cada acción

inicio_auto .FILL xF23A		; Se reserva un espacio en memoria para almacenar la dirección de inicio del auto
grosor_pantalla.FILL #128
color_gris .FILL x4210 		; Color gris (código de color)
;Lógica para mover el auto hacia la derecha.
; Input: R0: Posición actual del auto.
; Output: R0: Posición actualizada del auto después de moverse hacia la derecha.
DERECHA				
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
ADD R0,R0,#2
JSR MOVER_AUTO
BRnzp VERIFICAR_COL
BRnzp MOVER2

;Lógica para mover el auto hacia la izquierda.
; Input: R0: Posición actual del auto.
; Output: R0: Posición actualizada del auto después de moverse hacia la izquierda.
IZQUIERDA			
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
ADD R0,R0,#-2
JSR MOVER_AUTO
BRnzp VERIFICAR_COL
BRnzp MOVER2

;Lógica para mover el auto hacia abajo.
; Input: R0: Posición actual del auto.
; Output: R0: Posición actualizada del auto después de moverse hacia abajo.
ABAJO				
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
LD R4, abajo
ADD R0,R0,R4
JSR MOVER_AUTO
BRnzp MOVER2

;Lógica para mover el auto hacia arriba.
; Input: R0: Posición actual del auto.
; Output: R0: Posición actualizada del auto después de moverse hacia arriba.
ARRIBA				
JSR RECARGAR_CARRILES
JSR BORRAR_AUTO
LD R4, subir
ADD R0,R0,R4
JSR MOVER_AUTO
BRnzp MOVER2


; VERIFICAR_COL: Verifica si el auto ha colisionado con un obstáculo.
; Input: R0 - Posición del auto, R1 - Posición del obstáculo
; Output: R0 - 1 si hay colisión, 0 si no
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

; BORRAR_AUTO: "Pinta" el auto pero del color de la calle.
; Input: 
;   R0 - Posición actual del auto (coordenadas en pantalla)
;   R1 - Color actual (se almacena el color de la calle)
;   R2 - Color actual (se almacena el color de la calle)
;   R3 - Color actual (se almacena el color de la calle)
; Output:
;   R0 - Posición del auto (sin cambios)
;   R1 - Color gris (color de la calle)
;   R2 - Color gris (color de la calle)
;   R3 - Color gris (color de la calle)
;   R4 - Grosor de la pantalla (se carga desde grosor_pantalla)
BORRAR_AUTO
ST R1,GUARDAR_R1
ST R2,GUARDAR_R2
ST R3,GUARDAR_R3
ST R4,GUARDAR_R4
LD R1, color_gris
LD R2, color_gris
LD R3, color_gris
BRnzp SALTO

; MOVER_AUTO: Pinta el auto desde la dirección guardada en R0.
; Input: 
;   R0 - Posición actual del auto (coordenadas en pantalla)
;   R1 - Color a utilizar (se guarda antes de actualizar)
;   R2 - Color a utilizar (se guarda antes de actualizar)
;   R3 - Color a utilizar (se guarda antes de actualizar)
; Output:
;   R0 - Posición del auto (sin cambios)
;   R1 - Color rojo oscuro (se carga desde color_rojo_osc)
;   R2 - Color rojo claro (se carga desde color_rojo_cla)
;   R3 - Color negro (se carga desde color_negro)
;   R4 - Grosor de la pantalla (se carga desde grosor_pantalla)
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
color_naranja .FILL x7A00   
color_naranja_osc .FILL x5100
color_white2 .FILL x7FFF
color_gris2 .FILL x4210
abajo.FILL #256
subir.FILL #-256
columna.FILL x00FF
columna_der_neg .FILL #-88
columna_izq_neg .FILL #-30



BORRAR_CONO
ST R0,GUARDAR_R0
ST R1,GUARDAR_R1
ST R2,GUARDAR_R2
ST R3,GUARDAR_R3
ST R4,GUARDAR_R4
LD R0, color_gris2
LD R1, color_gris2
LD R2,color_gris2
BRnzp SALTAR
DIBUJAR_CONO ;dibuja un cono desde R3
ST R0,GUARDAR_R0
ST R1,GUARDAR_R1
ST R2,GUARDAR_R2
ST R3,GUARDAR_R3
ST R4,GUARDAR_R4
LD R0, color_naranja
LD R1, color_naranja_osc
LD R2,color_white2
SALTAR
LD R4, grosor_pantalla
STR R0,R3,#4
ADD R3,R3,R4
STR R0,R3,#4
ADD R3,R3,R4
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
ADD R3,R3,R4
STR R2,R3,#3
STR R2,R3,#4
STR R2,R3,#5
ADD R3,R3,R4
STR R0,R3,#2
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
STR R0,R3,#6
ADD R3,R3,R4
STR R0,R3,#2
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
STR R0,R3,#6
ADD R3,R3,R4
STR R0,R3,#1
STR R2,R3,#2
STR R2,R3,#3
STR R2,R3,#4
STR R2,R3,#5
STR R2,R3,#6
STR R0,R3,#7
ADD R3,R3,R4
STR R0,R3,#0
STR R0,R3,#1
STR R0,R3,#2
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
STR R0,R3,#6
STR R0,R3,#7
STR R0,R3,#8
ADD R3,R3,R4
STR R1,R3,#0
STR R2,R3,#1
STR R0,R3,#2
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
STR R0,R3,#6
STR R2,R3,#7
STR R1,R3,#8
ADD R3,R3,R4
STR R0,R3,#0
STR R1,R3,#1
STR R2,R3,#2
STR R2,R3,#3
STR R2,R3,#4
STR R2,R3,#5
STR R2,R3,#6
STR R1,R3,#7
STR R0,R3,#8
ADD R3,R3,R4
STR R0,R3,#1
STR R1,R3,#2
STR R1,R3,#3
STR R1,R3,#4
STR R1,R3,#5
STR R1,R3,#6
STR R0,R3,#7
ADD R3,R3,R4
STR R0,R3,#2
STR R0,R3,#3
STR R0,R3,#4
STR R0,R3,#5
STR R0,R3,#6

LD R0,GUARDAR_R0
LD R1,GUARDAR_R1
LD R2,GUARDAR_R2
LD R3,GUARDAR_R3
LD R4,GUARDAR_R4
RET

;R0-posicion auto
;R3-posicion cono
VERIFICAR_CONO
ST R0,GUARDAR_R0
ST R1, GUARDAR_R1
ST R2, GUARDAR_R2
ST R3, GUARDAR_R3
ST R4, GUARDAR_R4
ST R5, GUARDAR_R5
LD R2, extraer_fila
LD R6,diez
AND R1,R0,R2  		;R1 cordenada Y del auto
AND R4,R3,R2		;r4 cordenada Y del cono
NOT R5,R1
ADD R5,R5,#1
ADD R5,R5,R4  		;cordenada X del cono - X del auto

ENTRE
ADD R5,R5,#-1
BRz VERIFICAR_EJEY
ADD R6,R6,#-1
BRp ENTRE


ADD R5,R5,#8
ADD R5,R5,#0
BRz VERIFICAR_EJEY
LD R6,diez

ENTRE2
ADD R5,R5,#1
BRz VERIFICAR_EJEY
ADD R6,R6,#-1
BRp ENTRE2
BRnzp SALIR

VERIFICAR_EJEY
LD R6,diez
ADD R6,R6,#5
LD R2, extraer_columna
AND R1,R0,R2  		;R1 cordenada Y del auto
AND R4,R3,R2		;r4 cordenada Y del cono
NOT R5,R1
ADD R5,R5,#1
ADD R5,R5,R4  		;cordenada Y del cono - Y del auto

LD R2,ancho_pantalla_neg
ENTRE3
ADD R5,R5,R2
BRz GAME_OVER1
ADD R6,R6,#-1
BRp ENTRE3

LD R2,restaurar
ADD R5,R5,R2
LD R2, ancho_pantalla

LD R6,diez


ENTRE4
ADD R5,R5,R2
BRz GAME_OVER1
ADD R6,R6,#-1
BRp ENTRE4



SALIR
LD R0,GUARDAR_R0
LD R1, GUARDAR_R1
LD R2, GUARDAR_R2
LD R3, GUARDAR_R3
LD R4, GUARDAR_R4
LD R5, GUARDAR_R5
RET

extraer_fila .FILL x007F
extraer_columna .FILL xFF80
diez .FILL	#8
ancho_pantalla_neg .FILL #-128
ancho_pantalla .FILL #128
restaurar .FILL #1536

GAME_OVER1
HALT
