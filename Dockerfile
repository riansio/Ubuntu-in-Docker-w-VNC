FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, XFCE desktop, dan novnc
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tightvncserver \
    novnc websockify \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080

# Tambahkan skrip startup untuk VNC dan noVNC
# Jalankan websockify yang menghubungkan port 8080 ke VNC server
