FROM python:3 AS base

ARG TERRAFORM_VERSION
WORKDIR /opt/ct

RUN apt install wget curl unzip -y && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip && \
    rm -rf aws
COPY --from=cytopia/terraform-docs /usr/local/bin/terraform-docs /bin/
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN python3 --version && terraform --version && tflint --version && terraform-docs --version && aws --version


FROM golang AS workhorse

COPY --from=base /bin/terraform /bin/terraform-docs /usr/local/bin/tflint /bin/
RUN terraform --version && tflint --version && terraform-docs --version
