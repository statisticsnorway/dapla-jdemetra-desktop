# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive installation mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk python3-xdg maven x11-xserver-utils \
    x11vnc xvfb unzip wget novnc net-tools openbox && \
    rm -rf /var/lib/apt/lists/*

COPY ./favicons/*.png /usr/share/novnc/app/images/icons/

# Create a user and group for JDemetra+
RUN groupadd -r jdemetra && useradd -r -g jdemetra -d /home/jdemetra -m -s /bin/bash jdemetra

# Set the home directory as an environment variable
ENV HOME=/home/jdemetra

# Create the directories
RUN mkdir -p /home/jdemetra/examples \
    && chown -R jdemetra:jdemetra /home/jdemetra /usr/share/novnc

# Switch to the new user
USER jdemetra

# Set the working directory to the home directory
WORKDIR /home/jdemetra

# Copy the JDemetra+ app and startup script into the container
COPY --chown=jdemetra:jdemetra ./binaries/jdemetra*.zip ./
COPY --chown=jdemetra:jdemetra ./scripts/startup.sh ./

# Example data for the JDemetra+ app.
COPY --chown=jdemetra:jdemetra ./examples/* ./examples


# Unzip the JDemetra+ app and remove the archive
RUN unzip jdemetra*.zip && \
    rm jdemetra*.zip

# Set the DISPLAY environment variable
ENV DISPLAY=:1

# Expose the noVNC port
EXPOSE 6080

# Start the application using the startup script
CMD ["./startup.sh"]
