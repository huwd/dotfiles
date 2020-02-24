FROM ubuntu:18.04
LABEL maintainer="Huw Diprose <mail+dotfilesdocker@huwdiprose.co.uk>"

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
  apt-get update && \
  apt-get install -yqq \
  apt-utils \
  locales \
  lsb-release \
  software-properties-common && \
  apt-get clean

# Set locale to UTF-8
ENV LANGUAGE en_GB.UTF-8
ENV LANG en_GB.UTF-8
RUN localedef -i en_GB -f UTF-8 en_GB.UTF-8 && \
  /usr/sbin/update-locale LANG=$LANG

# Install dependencies
# `universe` is needed for ruby
# `security` is needed for fontconfig and fc-cache
RUN \
  apt-get update && \
  apt-get -yqq install \
  ruby-full \
  git \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# autoconf \
# build-essential \
# fasd \
# python \
# python-setuptools \
# python-dev \

# Install dotfiles
COPY . /root/.dotfiles
RUN cd /root/.dotfiles && rake install

# Run a zsh session
CMD [ "/bin/zsh" ]
