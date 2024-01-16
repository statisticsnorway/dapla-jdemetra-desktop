# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y openjdk-8-jdk python3-xdg maven x11-xserver-utils \
    x11vnc xvfb unzip wget novnc net-tools openbox && \
    rm -rf /var/lib/apt/lists/*

COPY ./resources/favicons/*.png /usr/share/novnc/app/images/icons/

# Create a user and group for JDemetra+
RUN groupadd -r dapla && useradd -r -g dapla -d /home/dapla -m -s /bin/bash dapla

# Set the home directory as an environment variable
ENV HOME=/home/dapla

# Create the directories
RUN chown -R dapla:dapla /home/dapla /usr/share/novnc

# Install gcsfuse system dependencies
RUN set -e; \
    apt-get update -y && apt-get install -y tcl \
    gnupg2 \
    curl \
    tini \
    python3.10 \
    python3-pip \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb https://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse  \
    && apt-get clean

# Install gcsfuse-token-provider API
COPY gcsfuse-token-provider/dist ./python
RUN python3 -m pip install ./python/*.whl
RUN rm -r ./python

# Switch to the new user
USER dapla

# Set the working directory to the home directory
WORKDIR /home/dapla

# Make mount dir
RUN mkdir $HOME/mnt
# Copy init script (mounts GCS bucket and starts gcsfuse-token-provider API)
COPY --chmod=0755 ./resources/scripts/onyxia_init.sh /opt/onyxia-init.sh

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
