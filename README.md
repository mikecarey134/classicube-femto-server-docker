# classicube-femto-server-docker
Dockerized Classicube server instance using Docker and Wine
Here’s the full README.md in a single file format for your FemtoCraft Docker server:

# FemtoCraft Dockerized Server

This repository provides a Dockerized setup for running a **FemtoCraft / ClassiCube server** on Linux using **Wine**. This allows you to run the Windows server executable inside a container for easy deployment, service management, and isolation.

## Table of Contents

- [Overview](#overview)  
- [Requirements](#requirements)  
- [Setup](#setup)  
- [Dockerfile](#dockerfile)  
- [Docker Compose](#docker-compose)  
- [Server Properties](#server-properties)  
- [Running the Server](#running-the-server)  
- [Notes](#notes)  

## Overview

This setup allows you to run **FemtoCraft 1.28 / ClassiCube** inside a Docker container with Wine.  

- Containerized environment ensures reproducibility.  
- Runs as a service via Docker Compose.  
- Wine + Winetricks provides the required .NET 4.0 environment.  
- Uses Xvfb to support GUI-based Windows operations in a headless container.  

## Requirements

- Docker (version 20+ recommended)  
- Docker Compose (version 1.29+ recommended)  
- Linux host (Ubuntu 22.04 used in this setup)  

## Setup

1. Clone this repository.  
2. Ensure you have `FemtoCraft.exe`, `FemtoCraft.exe.config`, and `server.properties` in the project root.  
3. Build the Docker image:

```bash
docker compose build
````

## Dockerfile

```dockerfile
FROM ubuntu:22.04

RUN mkdir -p /opt/server
WORKDIR /opt/server

COPY FemtoCraft.exe .
COPY FemtoCraft.exe.config .
COPY server.properties .

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y wine wine32 wget winetricks xvfb \
 && wineboot --init \
 && xvfb-run winetricks -q dotnet40

ENTRYPOINT ["wine","FemtoCraft.exe"]
```

**Key points:**

* Installs Wine + Winetricks to support .NET 4.0
* Copies server executable and configuration into `/opt/server`
* Uses Xvfb to allow GUI operations in a headless container

## Docker Compose

```yaml
version: "3.9"

services:
  classicube:
    build: .
    container_name: classicube_server
    restart: unless-stopped
    working_dir: /opt/server
    stdin_open: true
    tty: true
    ports:
      - "25572:25572"
```

**Notes:**

* `restart: unless-stopped` ensures the server auto-restarts if the container crashes.
* Maps host port `25572` to container port `25572`.

## Server Properties

Example `server.properties`:

```properties
server-name=Docker Wine ClassiCube Server
motd=Welcome to the ClassiCube Server!
port=25572
ip=0.0.0.0
max-players=20
public=False
verify-names=False
use-whitelist=False
admin-slot=True
reveal-ops=False
heartbeat-url=http://www.classicube.net/server/heartbeat

max-connections=3
limit-click-rate=True
limit-click-distance=True
limit-chat-rate=True
allow-speed-hack=True

op-max-connections=3
op-limit-click-rate=True
op-limit-click-distance=True
op-limit-chat-rate=True
op-allow-speed-hack=True

physics=True
physics-tick=50
physics-flood-protection=False
physics-grass=True
physics-lava=True
physics-plants=True
physics-sand=True
physics-snow=True
physics-trees=True
physics-water=True

allow-water-blocks=False
allow-lava-blocks=False
allow-grass-blocks=True
allow-solid-blocks=True
op-allow-water-blocks=True
op-allow-lava-blocks=True
op-allow-grass-blocks=True
op-allow-solid-blocks=True

protocol-extension=True
```

## Running the Server

Start the server:

```bash
docker compose up -d
```

Stop the server:

```bash
docker compose down
```

Check logs:

```bash
docker compose logs -f
```

## Notes

* Make sure `FemtoCraft.exe`, `FemtoCraft.exe.config`, and `server.properties` are present in the build context.
* The container uses Wine + Xvfb for headless operation, so no GUI is required.
* Ports must be correctly mapped in Docker Compose to allow client connections.
* Adjust `server.properties` as needed for your server rules, physics, and player limits.

This setup provides a fully containerized FemtoCraft server that can be managed like any other Docker service.

