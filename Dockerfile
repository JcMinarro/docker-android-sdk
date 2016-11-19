FROM java:openjdk-8-jdk
MAINTAINER Jc Miñarro <josecarlos.minarro@gmail.com>

ENV ANDROID_SDK_VERSION 24.4.1
ENV ANDROID_API_LEVELS android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25
ENV ANDROID_BUILD_TOOLS build-tools-23.0.2
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

# Copy local bins to bin path
COPY bin/* ${USR_BIN_PATH}
RUN chmod 755 ${USR_BIN_PATH}/android-sdk-install

# Install Android Tools
RUN android-sdk-install tools

# Install Android Platform-Tools and Android Platforms
RUN android-sdk-install platform-tools,${ANDROID_API_LEVELS}

# Install Android and Google extras dependencies
RUN android-sdk-install extra

# Install Build-Tools
RUN android-sdk-install ${ANDROID_BUILD_TOOLS}

# Install Android SDK Licenses
ADD licenses ${ANDROID_SDK_PATH}/licenses

# Cleaning APT
RUN apt-get clean autoclean && \
    apt-get autoremove -y  && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
