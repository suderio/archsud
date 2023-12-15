
sudo docker build -t archwsl .

sudo docker run -it \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /mnt/wslg:/mnt/wslg \
  -v /usr/lib/wsl:/usr/lib/wsl \
  --device=/dev/dxg \
  -e DISPLAY=$DISPLAY \
  --device /dev/dri/card0 \
  --device /dev/dri/renderD128 \
  -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
  -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  -e PULSE_SERVER=$PULSE_SERVER \
  --gpus all \
  archwsl

  # docker export --output="./archwsl.tar" archwsl
