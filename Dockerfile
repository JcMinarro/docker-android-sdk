FROM java:openjdk-8-jdk
MAINTAINER Jc Miñarro <josecarlos.minarro@gmail.com>

ENV ANDROID_SDK_VERSION 24.4.1
ENV ANDROID_SDK_PATH /usr/local/etc/android
ENV ANDROID_HOME /usr/local/etc/android
ENV USR_BIN_PATH /usr/local/bin

# Update certificates
RUN update-ca-certificates -f

# Install 32 bit version of the shared library
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y lib32z1 libc6:i386 libncurses5:i386 libstdc++6:i386

# Install Android SDK
RUN wget http://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz && \
    tar zxvf android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz && \
    mv android-sdk-linux ${ANDROID_SDK_PATH} && \
    rm android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz

# Add symbolic to Android bin
RUN ln -s ${ANDROID_SDK_PATH}/tools/android ${USR_BIN_PATH}/android