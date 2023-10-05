FROM zeelakscontainer.azurecr.io/bms-web-va:1.4 AS build-env
ARG Environment_name

# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash
RUN apt install nodejs -y
RUN npm i -g pm2@5.2.2

# Prepare Android directories and system variables
RUN mkdir -p /Android/sdk
ENV ANDROID_SDK_ROOT /Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
WORKDIR /Android
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools /Android/sdk/tools
RUN cd /Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd /Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/Android/sdk/platform-tools"

# Download Flutter SDK
RUN mkdir /flutter-home
WORKDIR /flutter-home
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.7.10-stable.tar.xz
RUN tar xvf flutter_linux_3.7.10-stable.tar.xz
RUN git config --global --add safe.directory /flutter-home/flutter
ENV PATH "$PATH:/flutter-home/flutter/bin"

# Copy files to container and build
RUN useradd -u 8877 developer
RUN mkdir -p /app/
RUN chown developer /app/
COPY . /app/
WORKDIR /app/
#RUN flutter build web
RUN flutter build web  --dart-define=ENV=${Environment_name} 
#RUN flutter run

FROM zeelakscontainer.azurecr.io/bms-web-va:1.4
RUN apt-get update
RUN apt-get install curl -y
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash
RUN apt-get install nodejs -y
RUN npm i -g pm2@5.2.2
WORKDIR /app
COPY --from=build-env /app/build/web /app/public-flutter
COPY ./server/app.js /app/app.js
COPY ./server/package.json /app/package.json
COPY startup.sh /app/
RUN chmod 777 startup.sh
RUN npm install
ENV NODE_ENV production
ENV ENVIRONMENT production
EXPOSE 3000
CMD ./startup.sh && pm2-docker app.js
#CMD pm2-docker app.js
