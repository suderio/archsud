
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
  --privileged \
  --entrypoint=/usr/lib/systemd/systemd \
  --env container=docker \
  --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup \
  --mount type=bind,source=/sys/fs/fuse,target=/sys/fs/fuse \
  --mount type=tmpfs,destination=/tmp \
  --mount type=tmpfs,destination=/run \
  --mount type=tmpfs,destination=/run/lock \
  --log-level=info \
  --unit=sysinit.target \
  archwsl

  # docker export --output="./archwsl.tar" archwsl
