#!/usr/bin/env bash
# Ejecutar desde la raiz: bash scripts/cambiar_etapa.sh rojo|verde|refactor
set -u
cd "$(dirname "$0")/.." || exit 1
case "${1:-}" in
  rojo) archivo="etapas/rojo/reserva_rojo.txt" ;;
  verde) archivo="etapas/verde/reserva_verde.txt" ;;
  refactor) archivo="etapas/refactor/reserva_refactor.txt" ;;
  *) echo "Uso: bash scripts/cambiar_etapa.sh rojo|verde|refactor"; exit 2 ;;
esac
cp "$archivo" reserva.go || exit 1
gofmt -w reserva.go
printf '\n===== Etapa: %s =====\n' "$1"
printf 'Archivo activo: reserva.go\n\n'
go test -count=1 -v ./...
resultado=$?
if [ "$1" = "rojo" ]; then
  printf '\nEn ROJO el resultado FAIL es esperado (prueba que detecta el fallo).\n'
else
  printf '\nEn %s se espera que todas las pruebas pasen.\n' "$1"
fi
exit "$resultado"
