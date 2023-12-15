FROM archlinux

# sudo docker build -t archwsl .
#
# sudo docker run -it \
#   -v /tmp/.X11-unix:/tmp/.X11-unix \
#   -v /mnt/wslg:/mnt/wslg \
#   -v /usr/lib/wsl:/usr/lib/wsl \
#   --device=/dev/dxg \
#   -e DISPLAY=$DISPLAY \
#   --device /dev/dri/card0 \
#   --device /dev/dri/renderD128 \
#   -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
#   -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
#   -e PULSE_SERVER=$PULSE_SERVER \
#   --gpus all 
#   archwsl

LABEL MAINTAINER="Paulo Suderio <paulo.suderio@gmail.com>"
LABEL DESCRIPTION="Ambiente de desenvolvimento WSL"

# Locale
RUN echo -e 'en_US.UTF-8 UTF-8\n' >> /etc/locale.gen && locale-gen
RUN echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
RUN echo 'KEYMAP=br-abnt2' >> /etc/vconsole.conf
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:pt:en_US:en
ENV LC_ALL en_US.UTF-8

# Update base system
RUN pacman-key --init
RUN pacman-key --populate
RUN pacman -Syyuu --noconfirm --noprogressbar
RUN pacman -S --noconfirm --noprogressbar reflector
RUN reflector --latest 200 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# basic stuff
RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout base-devel 
RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout git wget zip unzip colordiff pkgfile openssh chezmoi man

# neovim
RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout neovim python-pynvim wl-clipboard ruby nodejs yarn
#RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout neovim-qt
RUN yarn global add neovim
RUN gem install neovim

# emacs
#RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout emacs-wayland ripgrep fd shellcheck

# tex etc
#RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout ghostscript pandoc texlive okular

# wslg
RUN pacman -S --noconfirm --noprogressbar --disable-download-timeout xorg-apps xorg-server mesa-utils libva-mesa-driver libva-utils
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
# gnome

# User
ENV NEWUSER=suderio

# WSL
RUN echo "[boot]\nsystemd=true\n\n[user]\ndefault=${NEWUSER}\n" >> /etc/wsl.conf

RUN echo -e "AllowUsers ${NEWUSER}\nAllowGroups ${NEWUSER}\n" >> /etc/ssh/sshd_config
RUN ssh-keygen -A
EXPOSE 22

RUN useradd -m -d /home/${NEWUSER} -u 1001 -U -G wheel,users,tty -s /bin/bash ${NEWUSER}
RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
RUN echo "${NEWUSER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "${NEWUSER}:pass1234" | chpasswd
USER ${NEWUSER}
WORKDIR /home/${NEWUSER}
ENV USER ${NEWUSER}
ENV TERM screen-256color

#RUN git clone --depth 1 https://github.com/doomemacs/doomemacs /home/${NEWUSER}/.config/emacs
#RUN /home/${NEWUSER}/.config/emacs/bin/doom install --install --env --fonts --config --force

# yay
#RUN git clone --depth 1 https://aur.archlinux.org/yay.git /tmp/yay
#RUN cd /tmp/yay
#RUN makepkg -si --noconfirm --noprogressbar

# dotfiles
RUN chezmoi init --apply ${NEWUSER}

