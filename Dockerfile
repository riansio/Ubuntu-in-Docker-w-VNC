# Menggunakan base image Ubuntu yang sudah mendukung systemd
FROM jrei/systemd-ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Update sistem dan instal XFCE, TigerVNC, serta dependensi dasar
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    wget \
    curl \
    net-tools \
    sudo \
    dbus-x11 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Konfigurasi VNC Passwordless untuk user root
RUN mkdir -p /root/.vnc && \
    echo -ne "\n\n" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# 3. Buat startup script untuk menjalankan VNC server otomatis di background saat container menyala via systemd/service
RUN echo '#!/bin/bash\n\
vncserver :1 -geometry 1280x720 -depth 24 -localhost no\n\
tail -f /dev/null\n' > /usr/local/bin/start-vnc.sh && \
    chmod +x /usr/local/bin/start-vnc.sh

# Port VNC standar untuk display :1 adalah 5901
EXPOSE 5901

# Tetapkan systemd sebagai PID 1 utama
CMD ["/lib/systemd/systemd"]
