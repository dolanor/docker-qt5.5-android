FROM ubuntu:14.04

MAINTAINER Tanguy ⧓ Herrmann <dolanorgit@evereska.org>

ENV DEBIAN_FRONTEND=non-interactive

# for some android tools
RUN dpkg --add-architecture i386
RUN apt-get update -y && apt-get install -y --no-install-recommends ant openjdk-7-jdk libstdc++6:i386 git vim wget p7zip

ENV QT_VERSION=5.5.0-2

# need to figure out a way to automate the installation without the graphical installer…
RUN mkdir /tmp/qt \
    && wget -q http://files.dev.evereska.org/qt-android.tar.gz \
    && tar -xzf qt-android.tar.gz -C /opt/ \
    && rm qt-android.tar.gz

#    && wget  http://download.qt.io/official_releases/qt/${QT_VERSION:0:3}/${QT_VERSION:0:5}/qt-opensource-linux-x64-android-${QT_VERSION}.run -O /tmp/qt.run \
#   && chmod +x /tmp/qt.run && /tmp/qt.run --dump-binary-data -o /tmp/qt/data \
#   && 7zr x /tmp/qt/data/qt.55

ENV ANDROID_SDK_VERSION=r24.3.4
RUN mkdir -p /opt/android \
    && wget -q http://dl.google.com/android/android-sdk_${ANDROID_SDK_VERSION}-linux.tgz -O /tmp/android-sdk.tgz \
    && tar -xzvf /tmp/android-sdk.tgz -C /tmp/ \
    && mv /tmp/android-sdk-linux /opt/android/sdk \
    && rm -rf /tmp/android-sdk.tgz

ENV ANDROID_NDK_VERSION=r10e
RUN wget -q http://dl.google.com/android/ndk/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.bin -O /tmp/android-ndk.bin \
    && 7zr x /tmp/android-ndk.bin -o/tmp/ \
    && mv /tmp/android-ndk-${ANDROID_NDK_VERSION} /opt/android/ndk \
    && rm -rf /tmp/android-ndk.bin

ENV PATH=$PATH:/opt/android/sdk/tools:/opt/android/sdk/platform-tools:/opt/android/ndk/bin:/opt/qt/bin
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done )  | android update sdk --no-ui --filter "$(android list sdk | grep -i -e tool -e "api 24" -e "compatibility" | cut -d"-" -f1 | sed "s/[\n\r]//g" | tr "\n" ",")"

