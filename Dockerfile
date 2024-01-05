# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk maven x11-xserver-utils \
    x11vnc xvfb unzip wget novnc net-tools openbox && \
    rm -rf /var/lib/apt/lists/*

# Create a user and group for JDemetra+
RUN groupadd -r jdemetra && useradd -r -g jdemetra -d /home/jdemetra -m -s /bin/bash jdemetra

# Set the home directory as an environment variable
ENV HOME=/home/jdemetra

# Set environment variables for XDG directories. Don't really think it's needed.
ENV XDG_CONFIG_HOME=/home/jdemetra/.config
ENV XDG_DATA_HOME=/home/jdemetra/.local/share
ENV XDG_CACHE_HOME=/home/jdemetra/.cache
ENV XDG_RUNTIME_DIR=/run/user/jdemetra

# Create the directories
RUN mkdir -p $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_CACHE_HOME $XDG_RUNTIME_DIR \
    && chown -R jdemetra:jdemetra /home/jdemetra

# Switch to the new user
USER jdemetra

# Set the working directory to the home directory
WORKDIR /home/jdemetra

# Copy the JDemetra+ app and startup script into the container
COPY --chown=jdemetra:jdemetra ./binaries/jdemetra*.zip ./
COPY --chown=jdemetra:jdemetra ./scripts/startup.sh ./

# Unzip the JDemetra+ app and remove the archive
RUN unzip jdemetra*.zip && \
    rm jdemetra*.zip

# Set up VNC
RUN mkdir .vnc && \
    x11vnc -storepasswd "jdemetra" .vnc/passwd

# Set the DISPLAY environment variable
ENV DISPLAY=:1

# Expose the noVNC port
EXPOSE 6080

# Start the application using the startup script
CMD ["./startup.sh"]
