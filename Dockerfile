FROM ubuntu:16.04

EXPOSE 8080

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_USER_HOME /home/developer/

RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common python-software-properties && \
    apt-add-repository ppa:cwchien/gradle && \
    apt-key update && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        busybox \
        gradle-2.10 \
        lib32z1 \
        libstdc++6:i386 \
        lib32stdc++6 \
        lib32z1 \
        libc6:i386 \
        libncurses5:i386 \
        openjdk-8-jdk \
        apt-utils \
        curl \
        vim && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    useradd -m developer

ADD . /home/developer/
RUN chown -R developer.developer /home/developer

USER developer
WORKDIR /home/developer

# run a first compilation to download dependencies
RUN gradle generateJavaFile && \
    rm /home/developer/com.zenika.aicdsl/DslFiles/* && \
    chmod g+rsx /home/developer/com.zenika.aicdsl/DslFiles

# By default, run the web editor
CMD gradle jettyRun

