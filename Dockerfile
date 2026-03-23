FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Dubai

RUN apt-get update && apt-get install -y \
    tzdata \
    wget \
    curl \
    git \
    vim \
    zip \
    unzip \
    sudo \
    net-tools \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    openssl \
    nodejs \
    npm \
    firefox \
    xterm \
    python3 \
    python3-pip \
    build-essential \
    xfce4 \
    xfce4-terminal \
    xfce4-taskmanager \
    mousepad \
    thunar \
    xdotool \
    xclip \
    xsel \
    autocutsel && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
