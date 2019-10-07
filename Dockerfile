FROM archlinux:base

LABEL MAINTAINER="Paulo Suderio <paulo.suderio@gmail.com>"
LABEL DESCRIPTION="Ambiente de desenvolvimento CLI usando nvim"

# Locale
RUN echo 'pt_BR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt:en_US:en
ENV LC_ALL pt_BR.UTF-8

# Configure proxy
ARG proxy=http://proxy01.bndes.net:8080
ENV HTTP_PROXY=$proxy HTTPS_PROXY=$proxy NO_PROXY=$no_proxy http_proxy=$proxy https_proxy=$proxy no_proxy=localhost,127.0.0.1

# Update base system
RUN pacman -Syu --noconfirm --noprogressbar

RUN pacman -Syu --noconfirm --noprogressbar base-devel sudo git wget zip neovim htop

# Add devel user to build packages
RUN useradd -m -d /home/devel -u 1000 -U -G users,tty -s /bin/bash devel
RUN echo 'devel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER devel
ENV TERM dumb
ENV MAKEFLAGS "-j8"

# Install AUR helper
RUN git clone https://aur.archlinux.org/aurman.git /tmp/aurman \
  && cd /tmp/aurman \
  && makepkg -sfi --skippgpcheck --noconfirm \
  && mkdir -p ~/.config/aurman/ \
  && echo -e "[miscellaneous]\nskip_news" > ~/.config/aurman/aurman_config

RUN aurman -S yadm-git

USER root

# Add hoot user
RUN useradd -m -d /home/hoot -u ${uid:1001} -U -G users,tty -s /bin/bash hoot
RUN echo 'hoot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER devel

CMD /bin/bash
