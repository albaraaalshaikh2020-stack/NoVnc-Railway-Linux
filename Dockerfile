FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Dubai \
    DISPLAY=:1 \
    VNC_PASS=samplepass

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    xfce4 \
    xfce4-terminal \
    xfce4-taskmanager \
    mousepad \
    thunar \
    firefox \
    novnc \
    websockify \
    openssl \
    supervisor \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    nodejs \
    npm \
    net-tools \
    tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
    openssl req -new -newkey rsa:2048 -days 36500 -nodes -x509 \
        -subj "/C=US/ST=State/L=City/O=Org/CN=localhost" \
        -keyout /etc/ssl/novnc.key -out /etc/ssl/novnc.cert && \
    mkdir -p /root/.vnc && \
    echo "samplepass" | x11vnc -storepasswd - /root/.vnc/passwd && \
    mkdir -p /var/log/supervisor

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
