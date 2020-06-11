#Download base image for jdk8
FROM openjdk:8

#Set environment variables
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=26 \
    ANDROID_BUILD_TOOLS_VERSION=26.0.2

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

#Set working dir
RUN mkdir /app
WORKDIR /app

#Copy build inside app
COPY . .

#Set environment variables
ENV CI=true

#Run commands on container start
RUN ./gradlew clean assembleDebug; \
    cd app/build/outputs/apk/debug; \
    ls -l

#Copy final archive to host machine
COPY app/build/outputs/apk/debug/*.apk .
