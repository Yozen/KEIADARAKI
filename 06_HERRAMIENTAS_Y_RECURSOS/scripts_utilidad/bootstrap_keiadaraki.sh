#!/usr/bin/env bash
# ==============================================================================
# PROYECTO:     KEIADARAKI
# MÓDULO:       06_HERRAMIENTAS_Y_RECURSOS/scripts_utilidad
# SCRIPT:       bootstrap_keiadaraki.sh
#
# ------------------------------------------------------------------------------
# ¿QUÉ HACE ESTE SCRIPT?
# ------------------------------------------------------------------------------
# Este script inicializa de forma automatizada la estructura ontológica de
# directorios del repositorio KEIADARAKI. Sus funciones principales son:
#
#   1. Crear la arboleda completa de 16 subcarpetas especializadas (física,
#      formalizaciones matemáticas, especificaciones RFC, PoCs y herramientas).
#   2. Depositar un marcador '.gitkeep' en cada directorio vacío para forzar
#      a Git a rastrear e incluir la estructura en los commits y en GitHub.
#   3. Generar los documentos raíz ('README.md' y 'GLOSARIO.md') y plantillas
#      normativas de especificación si no existen previamente.
#   4. Moverse a sí mismo de forma automática desde la raíz del proyecto hacia
#      '06_HERRAMIENTAS_Y_RECURSOS/scripts_utilidad/' para dejar la raíz limpia.
#
# ------------------------------------------------------------------------------
# ¿CÓMO SE INVOCA? (INSTRUCCIONES DE USO)
# ------------------------------------------------------------------------------
# Caso 1: Si ya estás DENTRO del repositorio KEIADARAKI en tu terminal:
#   $ chmod +x bootstrap_keiadaraki.sh
#   $ ./bootstrap_keiadaraki.sh .
#
# Caso 2: Si estás FUERA del repositorio (en la carpeta padre):
#   $ chmod +x bootstrap_keiadaraki.sh
#   $ ./bootstrap_keiadaraki.sh KEIADARAKI
#
# CARACTERÍSTICAS:
#   - Idempotente: Es seguro ejecutarlo múltiples veces; no destruye ni
#     sobrescribe archivos creados o modificados previamente.
# ==============================================================================

set -euo pipefail

# Ámbito de ejecución (por defecto toma el directorio actual)
TARGET_DIR="${1:-.}"

echo "[*] Desplegando estructura ontológica en: ${TARGET_DIR}"

# 1. Definición de la arboleda de directorios
directories=(
    "${TARGET_DIR}/00_FUNDAMENTOS_Y_DOMINIOS/neurociencia"
    "${TARGET_DIR}/00_FUNDAMENTOS_Y_DOMINIOS/fisica"
    "${TARGET_DIR}/00_FUNDAMENTOS_Y_DOMINIOS/biologia_sistemas"
    "${TARGET_DIR}/01_FORMALIZACION_MATEMATICA/topologia_y_geometria"
    "${TARGET_DIR}/01_FORMALIZACION_MATEMATICA/algebra_y_logica"
    "${TARGET_DIR}/01_FORMALIZACION_MATEMATICA/dinamica_no_lineal"
    "${TARGET_DIR}/02_ARQUITECTURAS_NN_ALTERNATIVAS/drafts"
    "${TARGET_DIR}/02_ARQUITECTURAS_NN_ALTERNATIVAS/mecanismos_atencion_memoria"
    "${TARGET_DIR}/03_ESPECIFICACIONES_FORMALES"
    "${TARGET_DIR}/04_PLANOS_DE_SISTEMA/diagramas_componentes"
    "${TARGET_DIR}/04_PLANOS_DE_SISTEMA/flujos_datos"
    "${TARGET_DIR}/04_PLANOS_DE_SISTEMA/despliegue_y_sustrato"
    "${TARGET_DIR}/05_VALIDACION_Y_POC/poc_01_vector_activacion"
    "${TARGET_DIR}/05_VALIDACION_Y_POC/resultados"
    "${TARGET_DIR}/06_HERRAMIENTAS_Y_RECURSOS/scripts_utilidad"
    "${TARGET_DIR}/06_HERRAMIENTAS_Y_RECURSOS/plantillas"
)

for dir in "${directories[@]}"; do
    mkdir -p "${dir}"
    touch "${dir}/.gitkeep"
done

# 2. Inicialización de documentos raíz y normativos
[[ -f "${TARGET_DIR}/README.md" ]] || echo "# KEIADARAKI" > "${TARGET_DIR}/README.md"
[[ -f "${TARGET_DIR}/GLOSARIO.md" ]] || echo "# GLOSARIO SEMÁNTICO" > "${TARGET_DIR}/GLOSARIO.md"

touch "${TARGET_DIR}/03_ESPECIFICACIONES_FORMALES/formatos_intercambio.md"
touch "${TARGET_DIR}/03_ESPECIFICACIONES_FORMALES/invariantes_sistema.md"
touch "${TARGET_DIR}/06_HERRAMIENTAS_Y_RECURSOS/referencias_externas.md"

# 3. Auto-relocalización al taller de herramientas
SCRIPT_SRC="$(readlink -f "$0")"
DEST_DIR="${TARGET_DIR}/06_HERRAMIENTAS_Y_RECURSOS/scripts_utilidad"
DEST_FILE="${DEST_DIR}/bootstrap_keiadaraki.sh"

if [[ "${SCRIPT_SRC}" != "$(readlink -f "${DEST_FILE}" 2>/dev/null)" ]]; then
    echo "[*] Auto-almacenando script en: ${DEST_FILE}"
    mv "${SCRIPT_SRC}" "${DEST_FILE}"
    chmod +x "${DEST_FILE}"
fi

echo "[+] Despliegue finalizado. Estructura creada y script ubicado en su sitio."
