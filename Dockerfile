# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /apps

# Install dependencies, including JDK, Maven, Xvfb, x11vnc, and wget
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk maven \
    x11vnc xvfb unzip wget && \
    rm -rf /var/lib/apt/lists/*

# Copy the nbdemetra app
COPY ./binaries/jdemetra*.zip /apps

# Unzip the nbdemetra app
RUN unzip /apps/jdemetra*.zip && \
    rm /apps/jdemetra*.zip

# Set up VNC
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd "jdemetra" ~/.vnc/passwd

# Update .bashrc for nbdemetra
RUN echo "/apps/nbdemetra/bin/nbdemetra" >> ~/.bashrc

# Download and install noVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/refs/heads/main.tar.gz | tar xz --strip-components=1 -C /apps

# Expose ports for VNC and noVNC web client
EXPOSE 5900 6080

# Start Xvfb, x11vnc and noVNC in the background
CMD Xvfb :1 -screen 0 1024x768x16 & \
    x11vnc -forever -usepw -create -display :1 & \
    /apps/utils/launch.sh --vnc localhost:5900 --listen 6080
