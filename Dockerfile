FROM microsoft/vsts-agent:latest

# Build-time metadata as defined at http://label-schema.org

LABEL org.label-schema.name="VSTS Agent with Infrastrucure Tools" \
    org.label-schema.url="https://github.com/danielayo/" \
    org.label-schema.vcs-url="https://github.com/danielayo/vsts-agent-infrastructure" \
    org.label-schema.schema-version="1.0"

ENV TERRAFORM_VERSION 0.11.11
ENV PACKER_VERSION 1.3.4

# Install Packer
RUN echo "===> Installing Packer ${PACKER_VERSION} ..." \
 && wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
 && unzip packer_${PACKER_VERSION}_linux_amd64.zip  \
 && mv packer /usr/local/bin/packer \
 && rm packer_${PACKER_VERSION}_linux_amd64.zip

# Install Terraform
RUN echo "===> Installing Terraform ${TERRAFORM_VERSION}..." \
 && wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 &&	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && mv terraform /usr/local/bin/terraform \
 && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Add localhost to Ansible host file
RUN  echo "===> Adding hosts for convenience..." \
 && mkdir -p /etc/ansible                       \
 && echo 'localhost' > /etc/ansible/hosts
