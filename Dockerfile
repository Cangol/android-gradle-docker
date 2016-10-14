FROM openjdk:8-jdk
MAINTAINER Cangol  <wxw404@gmail.com>
# Everything will be installed in the directory but jdk.
ENV SDK_HOME /usr/local
ENV ANDROID_TARGET_SDK="android-23,android-24" \
    ANDROID_BUILD_TOOLS="build-tools-23.0.0,build-tools-23.0.1,build-tools-23.0.2,build-tools-23.0.3,build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3" \
    ANDROID_SDK_TOOLS="24.4.1" \
    ANDROID_IMAGES="sys-img-x86-android-23,sys-img-x86-android-24"
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 git --no-install-recommends
RUN wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz && \
    tar --extract --gzip --file=android-sdk.tgz
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter "${ANDROID_TARGET_SDK}" && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter "${ANDROID_BUILD_TOOLS} && \
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
    echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository
RUN echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter "${ANDROID_IMAGES}" --force
RUN echo n | android-sdk-linux/tools/android create avd --force -n "x86" -t android-23 --abi default/x86
ENV ANDROID_HOME $PWD/android-sdk-linux
# Gradle
ENV GRADLE_VERSION 2.14.1
ENV GRADLE_SDK_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN curl -sSL "${GRADLE_SDK_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip -d ${SDK_HOME}  \
	&& rm -rf gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME ${SDK_HOME}/gradle-${GRADLE_VERSION}
ENV PATH ${GRADLE_HOME}/bin:$PATH
