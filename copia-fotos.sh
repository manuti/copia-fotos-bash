#!/bin/bash
#Copiar archivos nuevos de tarjeta SD a PC
# Descripción en http://blog.desdelinux.net/script-bash-copiar-imagenes-nuevas-de-sd-a-la-pc/

### --- 				VERIFICAR SI ESTA MONTADO SD 			--- ###

SD=/media/KODAK/DCIM/100Z8612

if [[ -d $SD ]]; then
	
### --- 				CREAR DIRECTORIO 				--- ###

#Leer directorio de imágenes y crear otro con el nombre de la fecha   
#actual y permisos 755 si no existe.

cd ~/Imágenes/kodak

ULTDIR=`ls -1 | tail -n1` # último directorio de la lista.

FECHA=`date +%y.%m.%d` #Fecha actual en formato AA.MM.DD

if [ "$ULTDIR" != "$FECHA" ]; then
	mkdir -vm 755 `date +%y.%m.%d` # crear directorio con fecha actual
fi

### --- 		VER ÚLTIMO ARCHIVO DE $ULTDIR					--- ###

cd $ULTDIR

ULTIMG=`ls -1 [0-9][0-9][0-9]_[0-9][0-9][0-9][0-9].[JM][PO][GV] | tail -n1 | cut -c1-3,5-8` 
# ver la última imagen con nombre xxx_XXXX.eee
#Para asegurar que es script funcione luego de que se cumpla:
# 100_9999.eee  --> 101_0000.eee y no haya errores
# .eee = extensión de archivo (JPG o MOV)
# CORTAR para que quede en formato xxxXXXX


### --- 	MOVERSE AL ÚLTIMO DIRECTORIO DE LA LISTA 			--- ###
# 			  O AL CREADO RECIENTEMENTE, SI SE CREÓ			      #

cd ..

ULTDIR=`ls -1 | tail -n1` # va de nuevo porque sino toma al ULTDIR anterior del if

cd /media/KODAK/DCIM/100Z8612


### ---  	FILTRAR los archivos en SD  					--- ###

FILTRO=`ls -1 [0-9][0-9][0-9]_[0-9][0-9][0-9][0-9].[JM][PO][GV]`

### --- 	COMPARAR NUEVOS ARCHIVOS DE NOMBRE MAYOR AL ULTIMG              --- ###

for I in $FILTRO
do
	N=`echo $I | cut -c1-3,5-8` #Cortar nombre
	
	if [[ "$ULTIMG" -lt "$N" ]]; then
			
		cp $I ~/Imágenes/kodak/$ULTDIR 
	fi
done	

thunar ~/Imágenes/kodak/$ULTDIR #Abrir el nuevo directorio con Thunar

else
      exit 0
fi

exit 0
