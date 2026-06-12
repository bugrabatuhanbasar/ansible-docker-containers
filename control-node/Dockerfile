# =============================================================================
# CONTROL NODE DOCKERFILE
# =============================================================================
# CentOS 7 + Ansible Control Node
# NOT: CentOS 7 EOL oldu, vault.centos.org mirror'larını kullanıyoruz
# =============================================================================

FROM centos:7

LABEL maintainer="Bugra Batuhan Basar"
LABEL description="Ansible Control Node - CentOS 7"

ENV container=docker
ENV LANG=en_US.UTF-8

# -----------------------------------------------------------------------------
# MIRROR DÜZELTME (CentOS 7 EOL olduğu için vault kullanıyoruz)
# -----------------------------------------------------------------------------
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo

# -----------------------------------------------------------------------------
# SYSTEM UPDATE & TEMEL PAKETLER
# -----------------------------------------------------------------------------
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        net-tools \
        which \
        sudo \
        vim \
        openssh-clients \
        sshpass \
    && yum clean all

# -----------------------------------------------------------------------------
# OPENSSH SERVER KURULUMU
# -----------------------------------------------------------------------------
RUN yum install -y openssh-server && \
    yum clean all && \
    ssh-keygen -A && \
    echo "root:ansible" | chpasswd && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# -----------------------------------------------------------------------------
# ANSIBLE KURULUMU
# -----------------------------------------------------------------------------
RUN yum install -y ansible && \
    yum clean all

# -----------------------------------------------------------------------------
# SSH KEY OLUŞTURMA (şifresiz)
# -----------------------------------------------------------------------------
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# -----------------------------------------------------------------------------
# ANSIBLE INVENTORY
# -----------------------------------------------------------------------------
RUN echo "[managed_nodes]" >> /etc/ansible/hosts && \
    echo "managed-node1" >> /etc/ansible/hosts && \
    echo "managed-node2" >> /etc/ansible/hosts && \
    echo "" >> /etc/ansible/hosts && \
    echo "[all:vars]" >> /etc/ansible/hosts && \
    echo "ansible_user=root" >> /etc/ansible/hosts && \
    echo "ansible_password=ansible" >> /etc/ansible/hosts && \
    echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> /etc/ansible/hosts

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
