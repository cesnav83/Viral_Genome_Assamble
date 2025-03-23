#!/bin/bash

#Directorio donde estan los archivos
DIR="*./"


#Crear log de inicio
LOG_FILE="merge_log.txt"
echo "Inicio del proceso de fusion: $(date)" > "LOG_FILE"

#Obtener lista de identificadores unicos por muestra 
SAMPLES=$(ls *.fastq | awk -F '_L' '{print $1}' | sort | uniq)

#For loop (recorres  muestras 
for SAMPLE in $SAMPLES; do
echo "Procesando muestras: $SAMPLE" | tee -a "$LOG_FILE"
# Definir nombres de archivos de salida
OUTPUT_R1="${SAMPLE}_merge_R1.fastq"
OUTPUT_R2="${SAMPLE}_merge_R2.fastq"

# Obtener los archivos R1 y R2 de las muestras
FILES_R1=$(ls ${SAMPLE}_L*_R1_*.fastq 2>/dev/null)
FILES_R2=$(ls ${SAMPLE}_L*_R2_*.fastq 2>/dev/null)

# Verificacion de archivos 
if [ -z "$FILES_R1" ] || [ -z "$FILES_R2" ]; then
echo "Error: No se encontraron archivos R1 y R2 para muestra $SAMPLE" | tee -a "$LOG_FILE"
continue
fi

# Fusionar archivos R1 y R2
cat $FILES_R1 > "$OUTPUT_R1"
cat $FILES_R2 > "$OUTPUT_R2"

echo "Fusion completada para muestra: $SAMPLE" | tee -a "$LOG_FILE"
done
echo "Proceso finalizado: $(date)" | tee -a "$LOG_FILE"
