FROM ubuntu:20.04
RUN apt-get update && \
apt-get install -y ansible wget unzip git && \
wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip -O /tmp/terraform_0.14.7_linux_amd64.zip && \
unzip /tmp/terraform_0.14.7_linux_amd64.zip -d /usr/bin && \
wget https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz -O /tmp/helm-v3.5.2-linux-amd64.tar.gz && \
tar -zxvf /tmp/helm-v3.5.2-linux-amd64.tar.gz --directory /tmp/ && \
cp /tmp/linux-amd64/helm /usr/bin && \
wget https://github.com/rancher/rke/releases/download/v1.1.15/rke_linux-amd64 -O /usr/bin/rke && \
chmod +x /usr/bin/rke && \
chmod +x /usr/bin/helm
