FROM ubuntu:16.04
LABEL MAINTAINER Cangol  <wxw404@gmail.com>

ENV SDK_HOME /usr/local
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-openjdk-amd64
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8e

# Expect requires tzdata, which requires a timezone specified
RUN ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime


RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes --no-install-recommends bridge-utils bzip2 wget tar unzip curl git openjdk-8-jdk

# expect: Passing commands to telnet
RUN apt-get --quiet install --yes --no-install-recommends expect html2text lib32gcc1 lib32ncurses5 lib32stdc++6 lib32z1 libc6-i386 libqt5svg5 libqt5widgets5

# libvirt-bin: Virtualisation for emulator
RUN apt-get --quiet install --yes libvirt-bin

# qemu-kvm: Hardware acceleration for emulator
RUN apt-get --quiet install --yes qemu-kvm

# telnet: Communicating with emulator
RUN apt-get --quiet install --yes telnet

# ubuntu-vm-builder: Building VM for emulator
RUN apt-get --quiet install --yes ubuntu-vm-builder

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Configurating Java
#RUN rm -f /etc/ssl/certs/java/cacerts; \
#    /var/lib/dpkg/info/ca-certificates-java.postinst configure
	

# Gradle
ENV GRADLE_VERSION 4.1
ENV GRADLE_SDK_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
RUN curl -sSL "${GRADLE_SDK_URL}" -o gradle-${GRADLE_VERSION}-bin.zip  \
	&& unzip gradle-${GRADLE_VERSION}-bin.zip -d ${SDK_HOME}  \
	&& rm -rf gradle-${GRADLE_VERSION}-bin.zip
ENV GRADLE_HOME ${SDK_HOME}/gradle-${GRADLE_VERSION}
ENV PATH ${GRADLE_HOME}/bin:$PATH


# android sdk|build-tools|image
ENV ANDROID_TARGET_SDK="android-26" \
    ANDROID_BUILD_TOOLS="26.0.3" \
    ANDROID_SDK_TOOLS="3859397" \
    ANDROID_IMAGES="system-images;android-22;google_apis;armeabi-v7a"   
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN curl -sSL "${ANDROID_SDK_URL}" -o android-sdk-linux.zip \
    && unzip android-sdk-linux.zip -d android-sdk-linux \
  && rm -rf android-sdk-linux.zip
  
# Set ANDROID_HOME
ENV ANDROID_HOME $PWD/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$PATH

RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg
  
# licenses
RUN mkdir $ANDROID_HOME/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license
RUN echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license
RUN echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license

# Update and install using sdkmanager 
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager --update
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" "emulator"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;${ANDROID_TARGET_SDK}"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager ${ANDROID_IMAGES}


#RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "extras;intel;Hardware_Accelerated_Execution_Manager"
#RUN echo yes | sudo $ANDROID_HOME/extras/intel/Hardware_Accelerated_Execution_Manager/silent_install.sh

#android-wait-for-emulator
ENV PATH ${SDK_HOME}/bin:$PATH
RUN curl https://raw.githubusercontent.com/Cangol/android-gradle-docker/master/android-wait-for-emulator -o ${SDK_HOME}/bin/android-wait-for-emulator
RUN chmod u+x ${SDK_HOME}/bin/android-wait-for-emulator

VOLUME /tmp
