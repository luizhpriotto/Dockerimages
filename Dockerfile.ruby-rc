FROM ruby:2.5.1-alpine
USER root

RUN apk add -U --no-cache \
    openssh \
    wget \
    curl \
    unzip \
    openjdk8 \
    build-base \
    git \
    imagemagick \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    postgresql-dev \
    tzdata \
    yaml-dev \
    yarn \
    zlib-dev && \
    npm install -g yarn && yarn install && \
    adduser jenkins -D && \
    echo "jenkins:jenkins" | chpasswd && \
    curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip && \
        unzip sonarscanner.zip && \
        rm sonarscanner.zip && \
        mv sonar-scanner-3.0.3.778-linux /usr/lib/sonar-scanner && \
  ln -s /usr/lib/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
#   ensure Sonar uses the provided Java for musl instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/lib/sonar-scanner/bin/sonar-scanner \
    && curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl \
    && mv ./kubectl /usr/local/bin/ \
    && mkdir $HOME/.kube \
    && chmod +x /usr/local/bin/kubectl \
    && mkdir /home/jenkins/.kube \
    && chown -Rf jenkins:jenkins /home/jenkins/.kube

USER jenkins
