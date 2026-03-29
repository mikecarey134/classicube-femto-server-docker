FROM ubuntu:22.04

RUN mkdir -p /opt/server
WORKDIR /opt/server

COPY FemtoCraft.exe .
COPY FemtoCraft.exe.config .
COPY server.properties .

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y wine wine32 wget winetricks xvfb\
 && wineboot --init \
 && xvfb-run winetricks -q dotnet40

ENTRYPOINT ["wine","FemtoCraft.exe"]
