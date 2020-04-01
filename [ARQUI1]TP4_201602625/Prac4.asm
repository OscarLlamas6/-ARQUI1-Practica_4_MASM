;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%       SINTAXIS MASM     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
include macros.asm	;Archivo con los macros a utilizar

.model small 
;********************** SEGMENTO DE PILA ***********************
.286
.stack
;********************** SEGMENTO DE DATO ***********************
.data
;-----------------------------------------------------------------
bufferEntrada db 50 dup('$'),00
handlerEntrada dw ?
bufferReporte db "eTablero.html",00h
handlerReporte dw ?
bufferInformacion db 100 dup('$')
;------------------------------------------------------------------

PassNEGRO db 1 dup('N')
PassBLANCO db 1 dup('N')


;---------ETIQUETAS HTML---------------------------------------------
BloquePrincipal db "<!DOCTYPE html>",0ah,0dh,
						"<html>",0ah,0dh,
						"<head></head>",0ah,0dh,
						"<body><center>",0ah,0dh,
						"<h1>201602625</h1>",0ah,0dh

BloqueTabla db "<table border=1>",0ah,0dh,
				"<tr>",0ah,0dh,
				"<th>Jugador</th>",0ah,0dh,
				"<th>Puntuacion</th>",0ah,0dh,
				"</tr>",0ah,0dh

BloqueFichas1 db "<tr>",0ah,0dh,
				"<td align=center>Fichas Negras</td>",0ah,0dh,
				"<td align=center>",0ah,0dh


BloqueFichas2 db "</td>",0ah,0dh,
				"</tr>",0ah,0dh,
				"<tr>",0ah,0dh,
				"<td align=center>Fichas Blancas</td>",0ah,0dh,
				"<td align=center>",0ah,0dh

BloqueFichas3 db "</td>",0ah,0dh,
				"</tr>",0ah,0dh,
				"</table>",0ah,0dh,
				"<h1>",0ah,0dh

BloqueFinal db "</h1></center>",0ah,0dh,
				"</body>",0ah,0dh,
				"</html>",0ah,0dh

NoFB db 30h
NoFN db 30h			
;----------------------------------------------
punteoNEGRO WORD 0
punteoBLANCO WORD 0
libertadesV WORD 0
libertadesVN WORD 0
confirmar WORD 0
Num db 100 dup(00h)
NumPrint db 100 dup('$')
bufferFechaHora db 15 dup('$')
arreglo_numeros db 8 dup('$'),'$'
arreglo_posiciones db 64 dup('$'),'$'
arreglo db 4 dup('$')
arregloaux db 4 dup('$'),'$'
salto db " ",0ah,0dh,"$"
varSAVE db "SAVE"
varSHOW db "SHOW"
varPASS db "PASS"
varEXIT db "EXIT"
varA1 db "A1$$"
varA2 db "A2$$"
varA3 db "A3$$"
varA4 db "A4$$"
varA5 db "A5$$"
varA6 db "A6$$"
varA7 db "A7$$"
varA8 db "A8$$"
varB1 db "B1$$"
varB2 db "B2$$"
varB3 db "B3$$"
varB4 db "B4$$"
varB5 db "B5$$"
varB6 db "B6$$"
varB7 db "B7$$"
varB8 db "B8$$"
varC1 db "C1$$"
varC2 db "C2$$"
varC3 db "C3$$"
varC4 db "C4$$"
varC5 db "C5$$"
varC6 db "C6$$"
varC7 db "C7$$"
varC8 db "C8$$"
varD1 db "D1$$"
varD2 db "D2$$"
varD3 db "D3$$"
varD4 db "D4$$"
varD5 db "D5$$"
varD6 db "D6$$"
varD7 db "D7$$"
varD8 db "D8$$"
varE1 db "E1$$"
varE2 db "E2$$"
varE3 db "E3$$"
varE4 db "E4$$"
varE5 db "E5$$"
varE6 db "E6$$"
varE7 db "E7$$"
varE8 db "E8$$"
varF1 db "F1$$"
varF2 db "F2$$"
varF3 db "F3$$"
varF4 db "F4$$"
varF5 db "F5$$"
varF6 db "F6$$"
varF7 db "F7$$"
varF8 db "F8$$"
varG1 db "G1$$"
varG2 db "G2$$"
varG3 db "G3$$"
varG4 db "G4$$"
varG5 db "G5$$"
varG6 db "G6$$"
varG7 db "G7$$"
varG8 db "G8$$"
varH1 db "H1$$"
varH2 db "H2$$"
varH3 db "H3$$"
varH4 db "H4$$"
varH5 db "H5$$"
varH6 db "H6$$"
varH7 db "H7$$"
varH8 db "H8$$"
titulo db "++++++++++++++++ GO: By Oscar Llamas ++++++++++++++++",0ah,0dh,"$"
turno_negras db "Turno Negras: ","$"
turno_blancas db "Turno Blancas: ","$"
letras db "   A    B    C    D    E    F    G    H",0ah,0dh,"$"
guiones db "---","$"
ingrese_cargar db "INGRESE RUTA DEL ARCHIVO QUE DESEA CARGAR (EJ: C:\Juego.arq)",0ah,0dh,"$"
ingrese_guardar db "INGRESE RUTA DEL ARCHIVO A GUARDAR (EJ: C:\Juego.arq)",0ah,0dh,"$"
flecha db "	>>","$"
fb db "FB","$"
fn db "FN","$"
igual db "es igual","$"
no_igual db "no es igual","$"
barras db "   |    |    |    |    |    |    |    |","$"
espacio db "  ","$"
exitoAbrir db "ARCHIVO CARGADO EXITOSAMENTE!",0ah,0dh,"$"
exitoGuardar db "ARCHIVO GUARDADO EXITOSAMENTE!",0ah,0dh,"$"
errorCrear db "ERROR AL CREAR EL ARCHIVO!",0ah,0dh,"$"
errorAbrir db "ERROR AL CARGAR EL ARCHIVO!",0ah,0dh,"$"
errorCerrar db "ERROR AL CERRAR EL ARCHIVO!",0ah,0dh,"$"
errorLeer db "ERROR AL LEER EL ARCHIVO!",0ah,0dh,"$"
errorEscritura db "ERROR AL ESCRIBIR EL ARCHIVO!",0ah,0dh,"$"
encabezado db "	UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",0ah,0dh,"	FACULTAD DE INGENIERIA",0ah,0dh,
				09h,"CIENCIAS Y SISTEMAS",0ah,0dh,"	ARQUITECTURAS DE COMPUTADORES Y ENSAMBLADORES 1",0ah,0dh,
				09h,"SECCION A",0ah,0dh,"	NOMBRE: OSCAR ALFREDO LLAMAS LEMUS",0ah,0dh,
				09h,"CARNET: 201602625",0ah,0dh,0ah,0dh,"$"
menu db "	1) INICIAR JUEGO",0ah,0dh,"	2) CARGAR JUEGO",0ah,0dh,"	3) SALIR",0ah,0dh,"$"
Negro db "0"
Blanco db "1"
Vacio db "$"
tituloPts db "Puntuacion> ","$"
PtsFN db "Fichas Negras: ","$"
PtsFB db "Fichas Blancas: ","$"
separador db "  |  ","$"

FinDelJuego db "FIN DEL JUEGO: ","$"
GanadorN db "Ganador, Fichas Negras!","$"
GanadorB db "Ganador, Fichas Blancas!","$"

;********************** SEGMENTO DE CODIGO *********************** 
.code

main proc

	Inicio:
	Clear_Screen
	llenar_arreglos arreglo_numeros, espacio
	
    	
	Imprimir_Encabezado:
	print encabezado
	print salto

	Imprimir_Menu:
		print menu
		getCharSE
		cmp al,31h			;1
		je OPCION1
		cmp al,32h			;2
		je OPCION2
		cmp al,33h			;3
		je salir
		Clear_Screen
		jmp Imprimir_Encabezado

	OPCION1:
	mov punteoNEGRO,0
	mov punteoBLANCO,0
	LimpiarBuffer arreglo_posiciones, SIZEOF arreglo_posiciones,24h
		INICIO_JUEGO:
		QuitPASS fn
		QuitPASS fb	
		PLAY_NEGRAS:
		LimpiarBuffer arreglo, SIZEOF arreglo, 24h
		call PintarTablero	
		QuitPASS fn
		print turno_negras
		ObtenerTexto arreglo
		ValidarTurno fn,arreglo	
		PLAY_BLANCAS:
		LimpiarBuffer arreglo, SIZEOF arreglo, 24h
		call PintarTablero	
		QuitPASS fb
		print turno_blancas
		ObtenerTexto arreglo
		ValidarTurno fb,arreglo	
		jmp PLAY_NEGRAS
		SALIR_JUEGO:
		jmp salir

	

	OPCION2:
	    Clear_Screen
		print titulo
		print salto
		print ingrese_cargar
		print salto
		print flecha
		LimpiarBuffer bufferEntrada, SIZEOF bufferEntrada,24h
		ObtenerRuta bufferEntrada		
		AbrirArchivo bufferEntrada, handlerEntrada
		ContinuarLeer:
		LimpiarBuffer bufferInformacion, SIZEOF bufferInformacion,24h
		LeerArchivo handlerEntrada, bufferInformacion, SIZEOF bufferInformacion
		LlenarTablero arreglo_posiciones, bufferInformacion, SIZEOF bufferInformacion
		jmp INICIO_JUEGO

	Exito_Abrir:
		print salto
		print exitoAbrir
		getCharSE
		jmp ContinuarLeer

	Error_Crear:
		print salto
		print errorCrear
		getCharSE
		jmp Inicio

	Error_Escritura:
		print salto
		print errorEscritura
		getCharSE
		jmp Inicio

	Error_Abrir:
		print salto
		print errorAbrir
		getCharSE
		jmp Inicio

	Error_Leer:
		print salto
		print errorLeer
		getCharSE
		jmp Inicio	

    Error_Cerrar:
		print salto
		print errorCerrar
		getCharSE
		jmp Inicio

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%        SALIR        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	salir:						;Etiqueta salir
		mov ax,4c00h 			;Function (Quit with exit code (EXIT))
		xor al,al 
		int 21h 				;Interruption DOS Functions 

main endp 	;Termina proceso 

PintarTablero proc
Clear_Screen
print titulo
print salto
Tablero arreglo_posiciones, arreglo_numeros, arregloaux, salto, barras, espacio, letras, guiones, fb, fn
print salto
ret
PintarTablero endp


ConvertirNum proc
            push bp                    ;almacenamos el puntero base
            mov  bp,sp                 ;ebp contiene la direccion de esp
            sub  sp,2                  ;se guarda espacio para dos variables
            mov word ptr[bp-2],0       ;var local =0 
            pusha
            LimpiarBuffer Num, SIZEOF Num, 00h
            xor si,si                          ;si=0
            cmp ax,0                           ;si ax, ya viene con un cero
            je casoMinimo           
            mov  bx,0                          ;denota el fin de la cadena
            push bx                            ;se pone en la pila el fin de cadena
            Bucle:  
                mov dx,0
                cmp ax,0                    ;¿AX= 0?
                je toNum                    ;si:enviar numero al arreglo                
                mov bx,10                   ;divisor  = 10
                div bx                      ;ax =cociente ,dx= residuo
                add dx,48d                   ;residuo +48 para  poner el numero en ascii
                push dx                     ;lo metemos en la pila 
                jmp Bucle
            toNum:
                pop bx                      ;obtenemos elemento de la pila
                mov word ptr[bp-2],bx       ; pasamos de 16 bits a 8 bits 
                mov al, byte ptr[bp-2]
                cmp al,0                    ;¿Fin de Numero?
                je FIN                      ;si: enviar al fin del procedimiento
                mov num[si],al              ;ponemos el numero en ascii en la cadena
                inc si                      ;incrementamos los valores               
                jmp toNum                   ;iteramos de nuevo            
            casoMinimo:
                add al,48d                         ;convertimos 0 ascii
                mov Num[si],al                     ;Lo pasamos a num
                jmp FIN
            FIN:
                popa
                mov sp,bp               ;esp vuelve apuntar al inicio y elimina las variables locales
                pop bp                  ;restaura el valor del puntro base listo para el ret
                ret 
    ConvertirNum endp

ConvertirPrint proc
            push bp                   
            mov  bp,sp                
            sub  sp,2                 
            mov word ptr[bp-2],0      
            pusha
            LimpiarBuffer NumPrint, SIZEOF NumPrint, 24h
            xor si,si                        
            cmp ax,0                        
            je casoMinimo2         
            mov  bx,0                       
            push bx                          
            Bucle2:  
                mov dx,0
                cmp ax,0                   
                je toNum2                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp Bucle2
            toNum2:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je FIN2                  
                mov NumPrint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov NumPrint[si],al                
                jmp FIN2
            FIN2:
                popa
                mov sp,bp           
                pop bp                
                ret 
    ConvertirPrint endp

	SetearPuntos proc
	xor si,si
	mov cx,64
	SeguirSeteando:
	mov al,arreglo_posiciones[si]
	cmp al,30h
	je SumarNegro
	cmp al,31h
	je SumarBlanco
	jmp Incremento

	SumarNegro:
	inc punteoNEGRO
	jmp Incremento
	SumarBlanco:
	inc punteoBLANCO
	jmp Incremento

	Incremento:
	inc si
	dec cx
	jnz SeguirSeteando
	ret
	SetearPuntos endp


end main

