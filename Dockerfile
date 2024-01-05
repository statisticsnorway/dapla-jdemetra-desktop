# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory
WORKDIR /apps

# Install dependencies, including net-tools
RUN apt-get update && \
    apt-get install -y default-jre maven \
    x11vnc xvfb unzip wget novnc net-tools fluxbox fontconfig fonts-dejavu fonts-liberation && \
    fc-cache -fv && \
    rm -rf /var/lib/apt/lists/*

# Copy the nbdemetra app
COPY ./binaries/jdemetra*.zip /apps

# Copy startupt script
COPY ./scripts/startup.sh /apps

# Unzip the nbdemetra app
RUN unzip /apps/jdemetra*.zip && \
    rm /apps/jdemetra*.zip

# Set up VNC
RUN mkdir ~/.vnc && \
    x11vnc -storepasswd "jdemetra" ~/.vnc/passwd

# Start Fluxbox, the application, Xvfb, and x11vnc in the right order
CMD ["/apps/startup.sh"]
