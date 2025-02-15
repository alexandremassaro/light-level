#!/bin/bash

DEVICE="/dev/video0"

# Reativar ajustes automaticos
restore_auto() {
  echo "Restaurando ajustes automáticos de câmera"
  v4l2-ctl -d $DEVICE --set-ctrl auto_exposures=1
  v4l2-ctl -d $DEVICE --set-ctrl white_balance_automatic=1
  v4l2-ctl -d $DEVICE --set-ctrl exposure_dynamic_framerate=1
  exit 0
}

# Registrar a função para restaurar quando o script for interrompido
trap restore_auto SIGINT SIGTERM

# Desativar ajustes automáticos
echo "Desativavando ajustes automáticos de câmera"
v4l2-ctl -d $DEVICE --set-ctrl auto_exposure=1
v4l2-ctl -d $DEVICE --set-ctrl white_balance_automatic=0
v4l2-ctl -d $DEVICE --set-ctrl exposure_dynamic_framerate=0

# Define valores fixos
v4l2-ctl -d $DEVICE --set-ctrl exposure_time_absolute=157
v4l2-ctl -d $DEVICE --set-ctrl brightness=128
v4l2-ctl -d $DEVICE --set-ctrl contrast=32

while true; do
    light_level=$(ffmpeg -f v4l2 -i /dev/video0 -vframes 1 -f image2pipe - 2>/dev/null | magick - -colorspace RGB -format "%[mean]" info:)
    echo "Light Level: $light_level"
    sleep 1
done


