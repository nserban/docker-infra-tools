# Dockerfile for building Ansible and Packer image for Alpine 3
FROM alpine:3.6

MAINTAINER Nicolae Serban <nserban@gmail.com>

ENV PACKER_VERSION=1.3.2
ENV TERRAFORM_VERSION=0.11.10

# Install Ansible
RUN apk --update add sudo && \
    echo "--- Install Python" && \
    apk --update add python py-pip openssl ca-certificates && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi && \
    echo "--- Installing Ansible"  && \
    pip install ansible && \
    pip install --upgrade pywinrm && \
    apk --update add sshpass openssh-client rsync && \
    echo "--- Cleanup"  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    echo "--- Adding Hosts" && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

# Install Packer
RUN apk add --update git curl openssh make && \
    curl --silent https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip > packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip && \
    adduser -D -u 1000 packer

# Install Terraform
RUN apk add --update git curl openssh make && \
    curl --silent https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

USER tools
ENV USER=tools

# Default command
CMD [ "ansible-playbook", "--version" ]