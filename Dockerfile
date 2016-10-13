FROM openjdk:8-jdk
MAINTAINER Cangol  <wxw404@gmail.com>
# Everything will be installed in the directory but jdk.
ENV SDK_HOME /usr/local
ENV ANDROID_TARGET_SDK="23" \
    ANDROID_BUILD_TOOLS="23.0.2" \
    ANDROID_SDK_TOOLS="24.4.1"
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz && \
    tar --extract --gzip --file=android-sdk.tgz
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_TARGET_SDK} && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS}
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository
ENV ANDROID_HOME $PWD/android-sdk-linux
# Gradle
ENV GRADLE_VERSION 2.14.1
ENV GRADLE_SDK_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN curl -sSL "${GRADLE_SDK_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip -d ${SDK_HOME}  \
	&& rm -rf gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME ${SDK_HOME}/gradle-${GRADLE_VERSION}
ENV PATH ${GRADLE_HOME}/bin:$PATH
