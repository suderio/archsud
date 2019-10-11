FROM archlinux/base

LABEL MAINTAINER="Paulo Suderio <paulo.suderio@gmail.com>"
LABEL DESCRIPTION="Ambiente de desenvolvimento CLI usando nvim"

# Locale
RUN echo -e 'en_US.UTF-8 UTF-8\npt_BR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'LANG=pt_BR.UTF-8' >> /etc/locale.conf
RUN echo 'KEYMAP=br-abnt2' >> /etc/vconsole.conf
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt:en_US:en
ENV LC_ALL pt_BR.UTF-8

# Configure proxy
ARG proxy
ENV HTTP_PROXY=$proxy HTTPS_PROXY=$proxy NO_PROXY=$no_proxy http_proxy=$proxy https_proxy=$proxy no_proxy=localhost,127.0.0.1

# Update base system
RUN pacman -Syyuu --noconfirm --noprogressbar
RUN pacman -Syu --noconfirm --noprogressbar base-devel sudo git wget zip neovim colordiff ghostscript pandoc pkgfile texlive-core pandoc-citeproc pandoc-crossref 

# SSH (move pkgfile to previous line)
RUN pacman -Syu --noconfirm --noprogressbar openssh
RUN echo -e "AllowUsers hoot\nAllowGroups hoot\n" >> /etc/ssh/sshd_config
RUN ssh-keygen -A
EXPOSE 22

# Add devel user to build aur packages
RUN useradd -m -d /home/devel -u 1000 -U -G users,tty -s /bin/bash devel
RUN echo 'devel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER devel
ENV TERM dumb
ENV MAKEFLAGS "-j8"
ENV HTTP_PROXY=$proxy HTTPS_PROXY=$proxy NO_PROXY=$no_proxy http_proxy=$proxy https_proxy=$proxy no_proxy=localhost,127.0.0.1

# Install yadm
RUN git clone https://aur.archlinux.org/yadm-git.git /tmp/yadm \
  && cd /tmp/yadm \
  && makepkg -sfi --skippgpcheck --noconfirm 
# Install neovim

USER root

# Add hoot user
ARG hootpwd=hoot
ARG hootuid=1001
RUN useradd -m -d /home/hoot -u $hootuid -U -G users,tty -s /bin/bash hoot
RUN echo 'hoot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo "hoot:"$hootpwd | chpasswd
USER hoot
WORKDIR /home/hoot
RUN rm .bashrc
ENV USER hoot
RUN yadm clone http://github.com/suderio/dotfiles.git
ENV TERM screen-256color
RUN sed -i '$ d' .bashrc
CMD sudo /usr/sbin/sshd -D


