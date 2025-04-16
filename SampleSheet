#!/bin/bash

INPUT_DIR="/home/ubuntu/Proyecto_VGA/Fastq COVID/"
OUTPUT_FILE="samplesheet_corrected.csv"

# Encabezado del CSV
echo "sample,fastq_1,fastq_2" > "$OUTPUT_FILE"

# Procesar todas las muestras únicas
find "$INPUT_DIR" -type f -name "*_R1_*.fastq.gz" | while read r1_file; do
    sample_id=$(basename "$r1_file" | awk -F '_' '{print $1}')  # Extrae "24-0111-5" del nombre
    
    # Si la muestra ya fue procesada, saltar
    if grep -q "^$sample_id," "$OUTPUT_FILE"; then
        continue
    fi
    
    # Encontrar TODOS los R1 y R2 de la muestra (todos los lanes)
    r1_files=$(find "$INPUT_DIR" -name "${sample_id}_*_R1_*.fastq.gz" | sort | paste -sd ',')
    r2_files=$(find "$INPUT_DIR" -name "${sample_id}_*_R2_*.fastq.gz" | sort | paste -sd ',')
    
    # Validar que haya 4 pares R1/R2
    r1_count=$(echo "$r1_files" | tr ',' '\n' | wc -l)
    r2_count=$(echo "$r2_files" | tr ',' '\n' | wc -l)
    
    if [[ $r1_count -eq 4 && $r2_count -eq 4 ]]; then
        echo "$sample_id,$r1_files,$r2_files" >> "$OUTPUT_FILE"
        echo "✅ Muestra añadida: $sample_id (R1: $r1_count archivos, R2: $r2_count archivos)"
    else
        echo "⚠️  Error: $sample_id tiene R1: $r1_count archivos, R2: $r2_count archivos" >&2
    fi
done

# Resultado final
echo -e "\n📋 Resumen:"
echo "Total de muestras: $(awk -F "," 'NR>1{print $1}' "$OUTPUT_FILE" | wc -l)"
echo "Ejemplo de líneas en el CSV:"
head -n 3 "$OUTPUT_FILE"
