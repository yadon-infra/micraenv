FROM openjdk:8-jre-slim
WORKDIR /minecraft
ARG MINECRAFT_VERSION
RUN wget https://launcher.mojang.com/v1/objects/$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r --arg ver "$MINECRAFT_VERSION" '.versions[] | select(.id==$ver) | .url' | xargs curl -s | jq -r '.downloads.server.url') -O minecraft_server.jar
EXPOSE 25565
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "minecraft_server.jar", "nogui"]
