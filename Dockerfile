FROM gradle:6.5.0-jdk8

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
ENV ANDROID_API_LEVEL android-28
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3
ENV ANDROID_HOME /usr/local/android-sdk-linux
# ndk size big too
ENV ANDROID_NDK_VERSION 21.1.6352462
ENV ANDROID_VERSION 28
ENV ANDROID_NDK_HOME ${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"
    # "ndk;$ANDROID_NDK_VERSION"
# ENV PATH ${ANDROID_NDK_HOME}:$PATH
# ENV PATH ${ANDROID_NDK_HOME}/prebuilt/linux-x86_64/bin/:$PATH

CMD mkdir -p /home/source/ci_build \
    && cp -R /home/source/. /home/gradle \
    && cd /home/gradle \
    && gradle assembleRelease \
    && cp -R /home/gradle/app/build/outputs/apk/. /home/source/ci_build \