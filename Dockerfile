# We use Ubuntu 24.04 as base
FROM ubuntu:24.04

# Avoid interaction with the user
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies to compile and execute
RUN apt-get update && apt-get install -y \
    build-essential \
    meson \
    ninja-build \
    valac \
    libglib2.0-dev \
    libgtk-4-dev \
    libadwaita-1-dev \
    libgee-0.8-dev \
    libsqlite3-dev \
    libtagc0-dev \
    blueprint-compiler \
    gobject-introspection \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/*	

# Establish work directory
WORKDIR /sonus

# Copy all files to the container
COPY . .

# Configure
RUN rm -rf build 
RUN meson setup build

# Compile
RUN meson compile -C build

# Test
ENV SCHEMA_PATH=/sonus/src/db/schema.sql
CMD ["./build/testProgram"]