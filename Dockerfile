FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV DEBIAN_FRONTEND=noninteractive \
	VNC_PASS="samplepass" \
	VNC_TITLE="MyDesktop" \
	VNC_RESOLUTION="1280x720" \
	DISPLAY=:0 \
	NOVNC_PORT=$PORT \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Dubai"

COPY . /app

RUN rm -rf /etc/apt/sources.list && \
	bash -c 'echo -e "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse" >/etc/apt/sources.list' && \
	rm /bin/sh && ln -s /bin/bash /bin/sh && \
	apt-get update && \
	apt-get install -y \
	tzdata \
	wget \
	curl \
	git \
	vim \
	zip \
	unzip \
	sudo \
	net-tools \
	supervisor \
	x11vnc \
	xvfb \
	novnc \
	openssl \
	nodejs \
	npm \
	firefox \
	xterm \
	fluxbox \
	python3 \
	python3-pip \
	build-essential && \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
	openssl req -new -newkey rsa:2048 -days 36500 -nodes -x509 \
	-subj "/C=US/ST=State/L=City/O=Org/CN=localhost" \
	-keyout /etc/ssl/novnc.key -out /etc/ssl/novnc.cert && \
	npm i -g websockify

ENTRYPOINT ["supervisord", "-l", "/app/supervisord.log", "-c"]
CMD ["/app/supervisord.conf"]
