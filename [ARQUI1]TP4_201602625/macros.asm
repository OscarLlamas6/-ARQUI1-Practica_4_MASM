;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  IMPRIMIR TEXTO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print macro cadena
mov ah,09h
mov dx,@data
mov ds,dx
mov dx, offset cadena
int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  LLENAR TABLERO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LlenarTablero macro bufferTablero, bufferInformacion
LOCAL SeguirLlenando
xor si,si
mov cx,64
SeguirLlenando:
mov al,bufferInformacion[si]
mov bufferTablero[si],al
inc si
dec cx
jnz SeguirLlenando
call SetearPuntos
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  LLENAR ARREGLOS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

llenar_arreglos macro b1, msj
	print msj
	xor al,al
	xor si,si
	mov al,38h
	mov b1[si],al
	inc si
	mov al,37h
	mov b1[si],al
	inc si
	mov al,36h
	mov b1[si],al
	inc si
	mov al,35h
	mov b1[si],al
	inc si
	mov al,34h
	mov b1[si],al
	inc si
	mov al,33h
	mov b1[si],al
	inc si
	mov al,32h
	mov b1[si],al
	inc si
	mov al,31h
	mov b1[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA ESCRIBIR EN ARCHIVO %%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DecToAscii macro NumeroDec
    push ax     
    mov ax,NumeroDec
    call ConvertirNum
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA IMPRIMIR %%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DecToPrint macro NumeroDTA
    push ax     
    mov ax,NumeroDTA
    call ConvertirPrint
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%    OBTENER FECHA Y HORA     %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ObtenerFechaHora macro bufferFecha
PUSH ax
PUSH bx
PUSH cx
PUSH dx
PUSH si
	xor si, si
	xor bx, bx

	mov ah,2ah
	int 21h
	;REGISTRO DL = DIA 	 REGISTRO DH = MES

	Establer_Numero bufferFecha, dl  		;ESTABLECIENDO UN NUMERO PARA DIA
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	Establer_Numero bufferFecha, dh 		;ESTABLECIENDO UN NUMERO PARA MES
	mov bufferFecha[si],2fh ;HEXA DE /
	inc si
	mov bufferFecha[si],31h	; = 1
	inc si
	mov bufferFecha[si],39h	; = 9
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si
	mov bufferFecha[si],20h	; = espacio
	inc si

	mov ah,2ch
	int 21h
	;REGISTRO CH = HORA 	 REGISTRO CL = MINUTOS
	Establer_Numero bufferFecha, ch  		;ESTABLECIENDO UN NUMERO PARA HORA
	mov bufferFecha[si],3ah 				;HEXA DE :
	inc si
	Establer_Numero bufferFecha, cl 		;ESTABLECIENDO UN NUMERO PARA MINUTOS

POP si
POP dx
POP cx
POP bx
POP ax
endm

Establer_Numero macro bufferFecha, registro
PUSH ax
PUSH bx
	xor ax,ax
	xor bx,bx	;PASO MI REGISTRO PARA DIVIDIR
	mov bl,0ah
	mov al,registro
	div bl

	 Obtener_Numero bufferFecha, al 	;PRIMERO EL CONCIENTE
	 Obtener_Numero bufferFecha, ah 	;SEGUNDO EL MODULO

POP bx
POP ax
endm

Obtener_Numero macro bufferFecha, registro
LOCAL cero,uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,Salir
	cmp registro , 00h
	je cero
	cmp registro, 01h
	je uno
	cmp registro, 02h
	je dos
	cmp registro, 03h
	je tres
	cmp registro, 04h
	je cuatro
	cmp registro, 05h
	je cinco
	cmp registro, 06h
	je seis
	cmp registro, 07h
	je siete
	cmp registro, 08h
	je ocho
	cmp registro, 09h
	je nueve
	jmp Salir

	cero:
		mov bufferFecha[si],30h 	;0
		inc si
		jmp Salir
	uno:
		mov bufferFecha[si],31h 	;1
		inc si
		jmp Salir
	dos:
		mov bufferFecha[si],32h 	;2
		inc si
		jmp Salir
	tres:
		mov bufferFecha[si],33h 	;3
		inc si
		jmp Salir
	cuatro:
		mov bufferFecha[si],34h 	;4
		inc si
		jmp Salir
	cinco:
		mov bufferFecha[si],35h 	;5
		inc si
		jmp Salir
	seis:
		mov bufferFecha[si],36h 	;6
		inc si
		jmp Salir
	siete:
		mov bufferFecha[si],37h 	;7
		inc si
		jmp Salir
	ocho:
		mov bufferFecha[si],38h 	;8
		inc si
		jmp Salir
	nueve:
		mov bufferFecha[si],39h 	;9
		inc si
		jmp Salir
	Salir:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%  IMPRIMIR TABLERO  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tablero macro posiciones, numeros, auxiliar, salto, barras, espacio, letras, guiones, fb, fn
LOCAL Continuar, PintarEspacio, PintarFichaBlanca, PintarFichaNegra, Inicio, Fin, PintarGuiones, Finalizar, PintarBarras, Ultimo
print tituloPts
print PtsFN
DecToPrint punteoNEGRO
print NumPrint
print separador
print PtsFB
DecToPrint punteoBLANCO
print NumPrint
print salto
print salto
xor si, si
xor di, di
mov cx,8
Inicio:
mov al,numeros[si]
mov auxiliar,al
print auxiliar
print espacio
mov bx,cx
mov cx,8
Continuar:
mov al,posiciones[di]
cmp al,24h
je PintarEspacio
cmp al,31h
je PintarFichaBlanca
cmp al,30h
je PintarFichaNegra
PintarFichaBlanca:
print fb
jmp Fin
PintarFichaNegra:
print fn
jmp Fin
PintarEspacio:
print espacio
jmp Fin
Fin:
cmp cx,0001b
ja PintarGuiones
jmp Finalizar
PintarGuiones:
print guiones
jmp Finalizar
Finalizar:
inc di
dec cx
jnz Continuar
mov cx,bx
print salto
cmp cx,0001b
ja PintarBarras
jmp Ultimo
PintarBarras:
print barras
print salto
jmp Ultimo
Ultimo:
inc si
dec cx
jnz Inicio
print salto
print letras
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPARAR STRINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Comparar macro String1, String2
	LOCAL ContinuarLoop, InicioLoop, FinLoop, Contadores
	xor si,si
	mov cx,5
	InicioLoop:
	cmp String1[si],24h
	je FinLoop
	cmp String2[si],24h
	je FinLoop
	mov al, String1[si]
	mov dl, String2[si]
	cmp al,dl
	jne FinLoop
	cmp al,dl
	je ContinuarLoop
	jmp FinLoop
	ContinuarLoop:
	inc si
	dec cx
	cmp cx,0001b
    ja InicioLoop
	jmp FinLoop
	FinLoop:
	cmp al,dl
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% GENERAR REPORTE ACTUAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReporteActual macro arreglo
	
endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR PANTALLA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear_Screen macro
	mov ax,03h
    int 10h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LIMPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LimpiarBuffer macro buffer, NoBytes, Char
	LOCAL Repetir
	xor si,si
	xor cx,cx
	mov cx,NoBytes
	Repetir:
	mov buffer[si], Char
	inc si
	loop Repetir
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%% OBTNER UN CARACTER DEL TECLADO CON ECHO %%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getChar macro
	mov ah,01h
	int 21h
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%% OBTENER UN CARACTER DEL TECLADO SIN ECHO %%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getCharSE macro
	mov ah,08h
	int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTENER TEXTO DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerTexto macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,24h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% OBTNER RUTA DEL TECLADO %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ObtenerRuta macro buffer
LOCAL ObtenerChar, FinOT
xor si, si
ObtenerChar:
getChar
cmp al, 0dh
je FinOT
mov buffer[si],al
inc si
jmp ObtenerChar
FinOT:
mov al,00h
mov buffer[si],al
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ABRIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AbrirArchivo macro buffer, handler
mov ah,3dh
mov al,02h
lea dx,buffer
int 21h
jc Error_Abrir
mov handler,ax
jmp Exito_Abrir
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CERRAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CerrarArchivo macro handler
mov ah,3eh
mov bx, handler
int 21h
jc Error_Cerrar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% LEER ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LeerArchivo macro handler, buffer, NoBytes
mov ah,3fh
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Leer
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% CREAR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CrearArchivo macro buffer, handler
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
jc Error_Crear
mov handler,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ESCRIBIR ARCHIVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EscribirArchivo macro handler, buffer, NoBytes
mov ah,40h
mov bx,handler
mov cx,NoBytes
lea dx,buffer
int 21h
jc Error_Escritura
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% VALIDAR TURNO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ValidarTurno macro ficha, comando
LOCAL ReporteTablero, Guardar_Actual, SALIR_VALIDACION, PassTurno,FinalPASS, Gestionar
Comparar comando, varSHOW
je ReporteTablero
Comparar comando, varSAVE
je Guardar_Actual
Comparar comando, varEXIT
je Inicio
Comparar comando, varPASS
je PassTurno
Comparar comando, varA8
mov si,0
je Gestionar
Comparar comando, varB8
mov si,1
je Gestionar
Comparar comando, varC8
mov si,2
je Gestionar
Comparar comando, varD8
mov si,3
je Gestionar
Comparar comando, varE8
mov si,4
je Gestionar
Comparar comando, varF8
mov si,5
je Gestionar
Comparar comando, varG8
mov si,6
je Gestionar
Comparar comando, varH8
mov si,7
je Gestionar
Comparar comando, varA7
mov si,8
je Gestionar
Comparar comando, varB7
mov si,9
je Gestionar
Comparar comando, varC7
mov si,0ah ; 10
je Gestionar
Comparar comando, varD7
mov si,0bh ; 11
je Gestionar
Comparar comando, varE7
mov si,0ch ; 12
je Gestionar
Comparar comando, varF7
mov si,0dh ; 13
je Gestionar
Comparar comando, varG7
mov si,0eh ; 14
je Gestionar
Comparar comando, varH7
mov si,0fh ; 15
je Gestionar
Comparar comando, varA6
mov si,10h ; 16
je Gestionar
Comparar comando, varB6
mov si,11h ; 17
je Gestionar
Comparar comando, varC6
mov si,12h ; 18
je Gestionar
Comparar comando, varD6
mov si,13h ; 19
je Gestionar
Comparar comando, varE6
mov si,14h ; 20
je Gestionar
Comparar comando, varF6
mov si,15h ; 21
je Gestionar
Comparar comando, varG6
mov si,16h ; 22
je Gestionar
Comparar comando, varH6
mov si,17h ; 23
je Gestionar
Comparar comando, varA5
mov si,18h ; 24
je Gestionar
Comparar comando, varB5
mov si,19h ; 25
je Gestionar
Comparar comando, varC5
mov si,1ah ; 26
je Gestionar
Comparar comando, varD5
mov si,1bh ; 27
je Gestionar
Comparar comando, varE5
mov si,1ch ; 28
je Gestionar
Comparar comando, varF5
mov si,1dh ; 29
je Gestionar
Comparar comando, varG5
mov si,1eh ; 30
je Gestionar
Comparar comando, varH5
mov si,1fh ; 31
je Gestionar
Comparar comando, varA4
mov si,20h ; 32
je Gestionar
Comparar comando, varB4
mov si,21h ; 33
je Gestionar
Comparar comando, varC4
mov si,22h ; 34
je Gestionar
Comparar comando, varD4
mov si,23h ; 35
je Gestionar
Comparar comando, varE4
mov si,24h ; 36
je Gestionar
Comparar comando, varF4
mov si,25h ; 37
je Gestionar
Comparar comando, varG4
mov si,26h ; 38
je Gestionar
Comparar comando, varH4
mov si,27h ; 39
je Gestionar
Comparar comando, varA3
mov si,28h ; 40
je Gestionar
Comparar comando, varB3
mov si,29h ; 41
je Gestionar
Comparar comando, varC3
mov si,2ah ; 42
je Gestionar
Comparar comando, varD3
mov si,2bh ; 43
je Gestionar
Comparar comando, varE3
mov si,2ch ; 44
je Gestionar
Comparar comando, varF3
mov si,2dh ; 45
je Gestionar
Comparar comando, varG3
mov si,2eh ; 46
je Gestionar
Comparar comando, varH3
mov si,2fh ; 47
je Gestionar
Comparar comando, varA2
mov si,30h ; 48
je Gestionar
Comparar comando, varB2
mov si,31h ; 49
je Gestionar
Comparar comando, varC2
mov si,32h ; 50
je Gestionar
Comparar comando, varD2
mov si,33h ; 51
je Gestionar
Comparar comando, varE2
mov si,34h ; 52
je Gestionar
Comparar comando, varF2
mov si,35h ; 53
je Gestionar
Comparar comando, varG2
mov si,36h ; 54
je Gestionar
Comparar comando, varH2
mov si,37h ; 55
je Gestionar
Comparar comando, varA1
mov si,38h ; 56
je Gestionar
Comparar comando, varB1
mov si,39h ; 57
je Gestionar
Comparar comando, varC1
mov si,3ah ; 58
je Gestionar
Comparar comando, varD1
mov si,3bh ; 59
je Gestionar
Comparar comando, varE1
mov si,3ch ; 60
je Gestionar
Comparar comando, varF1
mov si,3dh ; 61
je Gestionar
Comparar comando, varG1
mov si,3eh ; 62
je Gestionar
Comparar comando, varH1
mov si,3fh ; 63
je Gestionar
RepetirTurno ficha

Gestionar:
	GestionarFicha ficha, si
	jmp SALIR_VALIDACION

PassTurno:
	AddPASS ficha
	xor si,si
	ValidarPASSNEGRO
	ValidarPASSBLANCO
	cmp si,2
	je FinalPASS	
	jmp SALIR_VALIDACION	
	FinalPASS:
	TerminarJuego
ReporteTablero:
	CrearArchivo bufferReporte, handlerReporte	
	ObtenerFechaHora bufferFechaHora
	EscribirArchivo handlerReporte, BloquePrincipal, SIZEOF BloquePrincipal
	EscribirArchivo handlerReporte, BloqueTabla, SIZEOF BloqueTabla
	EscribirArchivo handlerReporte, BloqueFichas1, SIZEOF BloqueFichas1
	DecToAscii punteoNEGRO
	EscribirArchivo handlerReporte, Num, SIZEOF Num
	EscribirArchivo handlerReporte, BloqueFichas2, SIZEOF BloqueFichas2
	DecToAscii punteoBLANCO
	EscribirArchivo handlerReporte, Num, SIZEOF Num
	EscribirArchivo handlerReporte, BloqueFichas3, SIZEOF BloqueFichas3
	EscribirArchivo handlerReporte, bufferFechaHora, SIZEOF bufferFechaHora
	EscribirArchivo handlerReporte, BloqueFinal, SIZEOF BloqueFinal
	CerrarArchivo handlerReporte
	RepetirTurno ficha
Guardar_Actual:
	GuardarJuego bufferEntrada, handlerEntrada, arreglo_posiciones
	RepetirTurno ficha
SALIR_VALIDACION:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% GUARDAR JUEGO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GuardarJuego macro buffer, handler, posiciones
LOCAL SeguirGuardando, EscribirBlanco, EscribirNegro, EscribirVacio, ValidarLoop
print salto
print ingrese_guardar
print flecha
ObtenerRuta buffer
CrearArchivo buffer, handler
xor si,si
SeguirGuardando:
mov al,posiciones[si]
cmp al,24h
je EscribirVacio
cmp al,31h
je EscribirBlanco
cmp al,30h
je EscribirNegro
EscribirNegro:
EscribirArchivo handler, Negro, SIZEOF Negro
jmp ValidarLoop
EscribirBlanco:
EscribirArchivo handler, Blanco, SIZEOF Blanco
jmp ValidarLoop
EscribirVacio:
EscribirArchivo handler, Vacio, SIZEOF Vacio
jmp ValidarLoop
ValidarLoop:
inc si
cmp si,40h
jb SeguirGuardando
CerrarArchivo handler
print salto
print exitoGuardar
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AÑADIR PASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AddPASS macro ficha
LOCAL AddBLANCO, AddNEGRO, SALIR_ADD
xor si,si
inc si
mov al,ficha[si]
cmp al,4eh
je AddNEGRO
cmp al,42h
je AddBLANCO
AddNEGRO:
xor si,si
mov PassNEGRO[si],59h
jmp SALIR_ADD
AddBLANCO:
xor si,si
mov PassBLANCO[si],59h
SALIR_ADD:
endm 

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUITAR PASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QuitPASS macro ficha
LOCAL QuitBLANCO, QuitNEGRO, SALIR_QUIT
xor si,si
inc si
mov al,ficha[si]
cmp al,4eh
je QuitNEGRO
cmp al,42h
je QuitBLANCO
QuitNEGRO:
xor si,si
mov PassNEGRO[si],4eh
jmp SALIR_QUIT
QuitBLANCO:
xor si,si
mov PassBLANCO[si],4eh
SALIR_QUIT:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TERMINAR JUEGO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TerminarJuego macro
LOCAL GanadorBlanco, GanadorNegro, Fin_TJ
	CrearArchivo bufferReporte, handlerReporte	
	ObtenerFechaHora bufferFechaHora
	EscribirArchivo handlerReporte, BloquePrincipal, SIZEOF BloquePrincipal
	EscribirArchivo handlerReporte, BloqueTabla, SIZEOF BloqueTabla
	EscribirArchivo handlerReporte, BloqueFichas1, SIZEOF BloqueFichas1
	DecToAscii punteoNEGRO
	EscribirArchivo handlerReporte, Num, SIZEOF Num
	EscribirArchivo handlerReporte, BloqueFichas2, SIZEOF BloqueFichas2
	DecToAscii punteoBLANCO
	EscribirArchivo handlerReporte, Num, SIZEOF Num
	EscribirArchivo handlerReporte, BloqueFichas3, SIZEOF BloqueFichas3
	EscribirArchivo handlerReporte, bufferFechaHora, SIZEOF bufferFechaHora
	EscribirArchivo handlerReporte, BloqueFinal, SIZEOF BloqueFinal
	CerrarArchivo handlerReporte
	print salto
	print FinDelJuego
	mov ax,punteoNEGRO
	mov dx,punteoBLANCO
	cmp ax,dx
	ja GanadorNegro
	cmp ax,dx
	jbe GanadorBlanco

	GanadorNegro:
	print GanadorN
	getCharSE
	jmp Fin_TJ

	GanadorBlanco:
	print GanadorB
	getCharSE
	jmp Fin_TJ


	Fin_TJ:
	jmp Inicio
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VALIDAR PASS NEGRO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ValidarPASSNEGRO macro
LOCAL IncrementarSI, SALIR_VPN
xor di,di
mov al,PassNEGRO[di]
cmp al,59h
je IncrementarSI
jmp SALIR_VPN
IncrementarSI:
inc si
SALIR_VPN:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VALIDAR PASS BLANCO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ValidarPASSBLANCO macro
LOCAL IncrementarSI, SALIR_VPB
xor di,di
mov al,PassBLANCO[di]
cmp al,59h
je IncrementarSI
jmp SALIR_VPB
IncrementarSI:
inc si
SALIR_VPB:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REPETIR TURNO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RepetirTurno macro ficha
xor si,si
inc si
mov al,ficha[si]
cmp al,4eh
je PLAY_NEGRAS
cmp al,42h
je PLAY_BLANCAS
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GESTIONAR FICHA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GestionarFicha macro ficha, posicion
LOCAL ficha, posicion,AddFicha, SALIR_GESTION, LLENAR_NEGRO, LLENAR_BLANCO, ValidacionLibertades
mov dl,arreglo_posiciones[posicion]
cmp dl,24h
je ValidacionLibertades
RepetirTurno ficha
ValidacionLibertades:
DeterminarCaso posicion
xor ax,ax
mov ax,libertadesV
cmp ax,0
ja AddFicha
RepetirTurno ficha
AddFicha:
xor al,al
xor di,di
inc di
mov al,ficha[di]
cmp al,4eh
je LLENAR_NEGRO
cmp al,42h
je LLENAR_BLANCO
LLENAR_NEGRO:
inc punteoNEGRO
mov arreglo_posiciones[posicion],30h
jmp SALIR_GESTION
LLENAR_BLANCO:
inc punteoBLANCO
mov arreglo_posiciones[posicion],31h
jmp SALIR_GESTION
SALIR_GESTION:
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DETERMINAR CASO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DeterminarCaso macro posicion
LOCAL ECaso1, ECaso2, ECaso3, ECaso4, ECaso5, ECaso6, ECaso7, ECaso8, ECaso9, Salir_DC
mov dx, posicion
cmp dx,0
je ECaso1
cmp dx,1
je ECaso6
cmp dx,2
je ECaso6
cmp dx,3
je ECaso6
cmp dx,4
je ECaso6
cmp dx,5
je ECaso6
cmp dx,6
je ECaso6
cmp dx,7
je ECaso2
cmp dx,8
je ECaso5
cmp dx,9
je ECaso9
cmp dx,0ah ;10
je ECaso9
cmp dx,0bh ;11
je ECaso9
cmp dx,0ch ;12
je ECaso9
cmp dx,0dh ;13
je ECaso9
cmp dx,0eh ;14
je ECaso9
cmp dx,0fh ;15
je ECaso7
cmp dx,10h ;16
je ECaso5
cmp dx,11h ;17
je ECaso9
cmp dx,12h ;18
je ECaso9
cmp dx,13h ;19
je ECaso9
cmp dx,14h ;20
je ECaso9
cmp dx,15h ;21
je ECaso9
cmp dx,16h ;22
je ECaso9
cmp dx,17h ;23
je ECaso7
cmp dx,18h ;24
je ECaso5
cmp dx,19h ;25
je ECaso9
cmp dx,1ah ;26
je ECaso9
cmp dx,1bh ;27
je ECaso9
cmp dx,1ch ;28
je ECaso9
cmp dx,1dh ;29
je ECaso9
cmp dx,1eh ;30
je ECaso9
cmp dx,1fh ;31
je ECaso7
cmp dx,20h ;32
je ECaso5
cmp dx,21h ;33
je ECaso9
cmp dx,22h ;34
je ECaso9
cmp dx,23h ;35
je ECaso9
cmp dx,24h ;36
je ECaso9
cmp dx,25h ;37
je ECaso9
cmp dx,26h ;38
je ECaso9
cmp dx,27h ;39
je ECaso7
cmp dx,28h ;40
je ECaso5
cmp dx,29h ;41
je ECaso9
cmp dx,2ah ;42
je ECaso9
cmp dx,2bh ;43
je ECaso9
cmp dx,2ch ;44
je ECaso9
cmp dx,2dh ;45
je ECaso9
cmp dx,2eh ;46
je ECaso9
cmp dx,2fh ;47
je ECaso7
cmp dx,30h ;48
je ECaso5
cmp dx,31h ;49
je ECaso9
cmp dx,32h ;50
je ECaso9
cmp dx,33h ;51
je ECaso9
cmp dx,34h ;52
je ECaso9
cmp dx,35h ;53
je ECaso9
cmp dx,36h ;54
je ECaso9
cmp dx,37h ;55
je ECaso7
cmp dx,38h ;56
je ECaso3
cmp dx,39h ;57
je ECaso8
cmp dx,3ah ;58
je ECaso8
cmp dx,3bh ;59
je ECaso8
cmp dx,3ch ;60
je ECaso8
cmp dx,3dh ;61
je ECaso8
cmp dx,3eh ;62
je ECaso8
cmp dx,3fh ;63
je ECaso4

ECaso1:
	Caso1
	jmp Salir_DC
ECaso2:
	Caso2
	jmp Salir_DC
ECaso3:
	Caso3
	jmp Salir_DC
ECaso4:
	Caso4
	jmp Salir_DC
ECaso5:
	Caso5 posicion
	jmp Salir_DC
ECaso6:
	Caso6 posicion
	jmp Salir_DC
ECaso7:
	Caso7 posicion
	jmp Salir_DC
ECaso8:
	Caso8 posicion
	jmp Salir_DC	
ECaso9:
	Caso9 posicion
	jmp Salir_DC
Salir_DC:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VERIFICAR LIBERTAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VerificarLibertad macro posicion
LOCAL SumarLibertadV, SalirVerificacion
XOR al,al
mov al,arreglo_posiciones[posicion]
cmp al,24h
je SumarLibertadV
jmp SalirVerificacion
SumarLibertadV:
inc libertadesV
SalirVerificacion:
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso1 macro
mov libertadesV,0
VerificarLibertad 1
VerificarLibertad 8
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso2 macro
mov libertadesV,0
VerificarLibertad 6
VerificarLibertad 0fh ;15
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso3 macro 
mov libertadesV,0
VerificarLibertad 30h ;48
VerificarLibertad 39h ;57
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso4 macro
mov libertadesV,0
VerificarLibertad 37h ;55
VerificarLibertad 3eh ;62
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso5 macro posicion
mov libertadesV,0
mov cx,posicion
sub cx,8
mov di, cx
VerificarLibertad di
mov cx,posicion
add cx,8
mov di,cx
VerificarLibertad di
mov cx,posicion
inc cx
mov di,cx
VerificarLibertad di
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso6 macro posicion
mov libertadesV,0
mov cx,posicion
dec cx
mov di, cx
VerificarLibertad di
mov cx,posicion
add cx,8
mov di,cx
VerificarLibertad di
mov cx,posicion
inc cx
mov di,cx
VerificarLibertad di
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso7 macro posicion
mov libertadesV,0
mov cx,posicion
sub cx,8
mov di, cx
VerificarLibertad di
mov cx,posicion
add cx,8
mov di,cx
VerificarLibertad di
mov cx,posicion
dec cx
mov di,cx
VerificarLibertad di
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 8 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso8 macro posicion
mov libertadesV,0
mov cx,posicion
dec cx
mov di, cx
VerificarLibertad di
mov cx,posicion
sub cx,8
mov di,cx
VerificarLibertad di
mov cx,posicion
inc cx
mov di,cx
VerificarLibertad di
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CASO 9 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Caso9 macro posicion
mov libertadesV,0
mov cx,posicion
dec cx
mov di, cx
VerificarLibertad di
mov cx,posicion
add cx,8
mov di,cx
VerificarLibertad di
mov cx,posicion
inc cx
mov di,cx
VerificarLibertad di
mov cx,posicion
dec cx
mov di,cx
VerificarLibertad di
endm