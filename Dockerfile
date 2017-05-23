# Version 0.0.2
# Maintainer weseklund <s.wes35@gmail.com>
FROM frolvlad/alpine-glibc:alpine-3.5

RUN apk update \
    && apk add bash

ENV JAVA_VERSION=8 \
    JAVA_UPDATE=131 \
    JAVA_BUILD=11 \
    JAVA_PATH=d54c1d3a095b4ff2b6607d096fa80163 \
    JAVA_HOME="/usr/lib/jvm/default-jvm"

RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates unzip && \
    cd "/tmp" && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    tar -xzf "jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz" && \
    mkdir -p "/usr/lib/jvm" && \
    mv "/tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE}" "/usr/lib/jvm/java-${JAVA_VERSION}-oracle" && \
    ln -s "java-${JAVA_VERSION}-oracle" "$JAVA_HOME" && \
    ln -s "$JAVA_HOME/bin/"* "/usr/bin/" && \
    rm -rf "$JAVA_HOME/"*src.zip && \
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
        "http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION}/jce_policy-${JAVA_VERSION}.zip" && \
    unzip -jo -d "${JAVA_HOME}/jre/lib/security" "jce_policy-${JAVA_VERSION}.zip" && \
    rm "${JAVA_HOME}/jre/lib/security/README.txt" && \
    apk del build-dependencies && \
    rm "/tmp/"* && \
    rm -rf /usr/lib/jvm/java-8-oracle/lib/missioncontrol/plugins


# Installing sdkmanager with tools
RUN cd /usr/local \
    && wget -q http://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
    && mkdir sdk-tools \
    && unzip -o -d sdk-tools sdk-tools-linux-3859397.zip \
    && rm -rf /usr/local/sdk-tools-linux-3859397.zip


# Installing Apache ANT
RUN cd /usr/local \
    && wget -q http://apache.mirrors.hoobly.com/ant/binaries/apache-ant-1.9.9-bin.zip \
    && mkdir apache-ant-1.9.9-bin \
    && unzip -o -d apache-ant-1.9.9-bin apache-ant-1.9.9-bin.zip \
    && rm -rf /usr/local/apache-ant-1.9.9-bin.zip \
    && rm -rf /usr/local/apache-ant-1.9.9-bin/apache-ant-1.9.9/manual

# Installing Gradle
RUN cd /usr/local \
    && wget -q http://services.gradle.org/distributions/gradle-3.5-bin.zip \
    && mkdir gradle-3.5-bin \
    && unzip -o -d gradle-3.5-bin gradle-3.5-bin.zip \
    && rm -rf /usr/local/gradle-3.5-bin.zip \
    && rm -rf /usr/local/sdk-tools/tools/lib/monitor-x86_64 

ENV ANDROID_HOME /usr/local/sdk-tools
ENV ANT_HOME /usr/local/apache-ant-1.9.9-bin/apache-ant-1.9.9
ENV GRADLE_HOME /usr/local/gradle-3.5-bin/gradle-3.5

ENV PATH $PATH:$ANT_HOME/bin
ENV PATH $PATH:$MAVEN_HOME/bin
ENV PATH $PATH:$GRADLE_HOME/bin
