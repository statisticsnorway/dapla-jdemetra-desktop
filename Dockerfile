# Dapla lab version
ARG VERSION=v0.6.0
# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3-xdg maven x11-xserver-utils \
    x11vnc xvfb unzip wget novnc net-tools openbox && \
    rm -rf /var/lib/apt/lists/*

COPY ./resources/favicons/*.png /usr/share/novnc/app/images/icons/

# Create a user and group for JDemetra+
RUN groupadd -r dapla && useradd -r -g dapla -d /home/dapla -m -s /bin/bash dapla

# Set the home directory as an environment variable
ENV HOME=/home/dapla

# Create the directories
RUN chown -R dapla:dapla /home/dapla /usr/share/novnc

# Switch to the new user
USER dapla

# Set the working directory to the home directory
WORKDIR /home/dapla

# Copy the JDemetra+ app and startup script into the container
COPY --chown=dapla:dapla ./resources/binaries/jdemetra*.zip ./
COPY --chown=dapla:dapla ./resources/scripts/startup.sh ./

# Example data for the JDemetra+ app.
COPY --chown=dapla:dapla ./resources/examples/* ./Documents/

# Unzip the JDemetra+ app and remove the archive
RUN unzip jdemetra*.zip && \
    rm jdemetra*.zip

# Set the DISPLAY environment variable
ENV DISPLAY=:1

# Expose the noVNC port
EXPOSE 6080

# Start the application using the startup script
CMD ["./startup.sh"]
