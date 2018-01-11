FROM openjdk:8-jdk
MAINTAINER Cangol  <wxw404@gmail.com>

ENV SDK_HOME /usr/local

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 git --no-install-recommends
# Gradle
ENV GRADLE_VERSION 3.3
ENV GRADLE_SDK_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN curl -sSL "${GRADLE_SDK_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip -d ${SDK_HOME}  \
	&& rm -rf gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME ${SDK_HOME}/gradle-${GRADLE_VERSION}
ENV PATH ${GRADLE_HOME}/bin:$PATH

# android sdk|build-tools|image
ENV ANDROID_TARGET_SDK="android-26" \
    ANDROID_BUILD_TOOLS="build-tools-26.0.3" \
    ANDROID_SDK_TOOLS="3859397" \
    ANDROID_IMAGES="sys-img-armeabi-v7a-android-25,sys-img-armeabi-v7a-android-25"   
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN curl -sSL "${ANDROID_SDK_URL}" -o android-sdk-linux.zip \
    && unzip android-sdk-linux.zip -d android-sdk-linux \
  && rm -rf android-sdk-linux.zip
# Install SDK Packages
ENV ANDROID_HOME $PWD/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$PATH
RUN mkdir -p ${ANDROID_HOME}/licenses/ && \
	echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ${ANDROID_HOME}/licenses/android-sdk-license && \
	mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
	${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"


# android ndk
ENV ANDROID_NDK_VERSION 16.1.4479499
ENV ANDROID_NDK_URL http://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN curl -L "${ANDROID_NDK_URL}" -o android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip  \
  && unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip -d ${SDK_HOME}  \
  && rm -rf android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
ENV ANDROID_NDK_HOME ${SDK_HOME}/android-ndk-${ANDROID_NDK_VERSION}
ENV PATH ${ANDROID_NDK_HOME}:$PATH
RUN chmod u+x ${ANDROID_NDK_HOME}/ -R

# Android CMake
RUN wget -q https://dl.google.com/android/repository/cmake-3.6.3155560-linux-x86_64.zip -O android-cmake.zip
RUN unzip -q android-cmake.zip -d ${ANDROID_HOME}/cmake
ENV PATH ${PATH}:${ANDROID_HOME}/cmake/bin
RUN chmod u+x ${ANDROID_HOME}/cmake/bin/ -R

#android-wait-for-emulator
RUN curl https://raw.githubusercontent.com/Cangol/android-gradle-docker/master/android-wait-for-emulator -o ${SDK_HOME}/bin/android-wait-for-emulator
RUN chmod u+x ${SDK_HOME}/bin/android-wait-for-emulator

