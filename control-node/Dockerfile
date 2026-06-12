# =============================================================================
# CONTROL NODE DOCKERFILE
# =============================================================================
# Bu Dockerfile Ansible'ın kurulu olduğu Control Node'u oluşturur
# CentOS 7 base image kullanıyoruz (senin istediğin gibi)
# =============================================================================

# -----------------------------------------------------------------------------
# BASE IMAGE
# -----------------------------------------------------------------------------
# CentOS 7 official image'ı kullan
# NOT: Docker'da "Red Hat 64-bit" yerine CentOS kullanıyoruz (ücretsiz ve uyumlu)
FROM centos:7

# -----------------------------------------------------------------------------
# LABEL (Metadata)
# -----------------------------------------------------------------------------
# Image hakkında bilgi (docker inspect ile görülebilir)
LABEL maintainer="Bugra Batuhan Basar"
LABEL description="Ansible Control Node - CentOS 7"
LABEL version="1.0"

# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------
# Container içinde kullanılacak ortam değişkenleri
ENV container=docker
ENV LANG=en_US.UTF-8

# -----------------------------------------------------------------------------
# SYSTEM UPDATE & TEMEL PAKETLER
# -----------------------------------------------------------------------------
# NOT: Senin komutların:
#   - dhclient: Docker'da gereksiz (Docker otomatik IP atar)
#   - onboot=yes: Docker'da restart policy ile yapılır (docker-compose.yml'de)
#   - yum update -y: Bunu yapıyoruz
#   - yum install epel-release: Ansible için gerekli
#   - yum install net-tools: ifconfig vs. için gerekli

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        # net-tools: ifconfig, netstat gibi ağ araçları
        net-tools \
        # which: komut yolunu bulmak için (ansible kurulumunda lazım)
        which \
        # sudo: root dışı kullanıcılar için
        sudo \
        # vim: dosya düzenleme (nano da ekleyebilirsin)
        vim \
        # SSH istemcisi (başka node'lara bağlanmak için)
        openssh-clients \
        # sshpass: şifreli SSH bağlantıları için (ansible'da lazım olabilir)
        sshpass \
    && yum clean all

# -----------------------------------------------------------------------------
# OPENSSH SERVER KURULUMU
# -----------------------------------------------------------------------------
# NOT: Senin komutların:
#   - yum install openssh-server: Bunu yapıyoruz
#   - systemctl stop/disable firewalld: Docker'da firewall YOK (host firewall kullanır)
#
# Docker'da systemctl ÇALIŞMAZ çünkü:
#   - Container'lar tek process çalıştırmak için tasarlanmış (init system yok)
#   - Biz SSH daemon'ı doğrudan başlatacağız

RUN yum install -y openssh-server && \
    yum clean all && \
    # SSH için gerekli host key'leri oluştur
    ssh-keygen -A && \
    # Root şifresi belirle (lab ortamı için basit şifre)
    echo "root:ansible" | chpasswd && \
    # SSH ile root girişine izin ver
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    # Şifreli girişe izin ver
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# -----------------------------------------------------------------------------
# ANSIBLE KURULUMU
# -----------------------------------------------------------------------------
# Control Node'da Ansible olmalı (Managed Node'larda gerekmez)
RUN yum install -y ansible && \
    yum clean all

# -----------------------------------------------------------------------------
# SSH KEY OLUŞTURMA
# -----------------------------------------------------------------------------
# NOT: Senin komutun: ssh-keygen (şifresiz)
# -t rsa: RSA algoritması
# -b 4096: 4096 bit key (güvenli)
# -N "": Boş passphrase (şifresiz, senin istediğin gibi)
# -f: Key dosyasının yolu

RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa && \
    # SSH dizin izinlerini ayarla (güvenlik için şart)
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# -----------------------------------------------------------------------------
# ANSIBLE INVENTORY DOSYASI
# -----------------------------------------------------------------------------
# Ansible'ın yöneteceği sunucuları tanımla
# /etc/ansible/hosts varsayılan inventory dosyası

RUN echo "[managed_nodes]" >> /etc/ansible/hosts && \
    echo "managed-node1" >> /etc/ansible/hosts && \
    echo "managed-node2" >> /etc/ansible/hosts && \
    echo "" >> /etc/ansible/hosts && \
    echo "[all:vars]" >> /etc/ansible/hosts && \
    echo "ansible_user=root" >> /etc/ansible/hosts && \
    echo "ansible_password=ansible" >> /etc/ansible/hosts && \
    echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> /etc/ansible/hosts

# -----------------------------------------------------------------------------
# STARTUP SCRIPT
# -----------------------------------------------------------------------------
# Container başladığında çalışacak script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -----------------------------------------------------------------------------
# PORT EXPOSE
# -----------------------------------------------------------------------------
# Container'ın 22 portunu dışarı aç (SSH için)
# NOT: Bu sadece dokümantasyon, asıl mapping docker-compose.yml'de

EXPOSE 22

# -----------------------------------------------------------------------------
# ENTRYPOINT
# -----------------------------------------------------------------------------
# Container başladığında bu script çalışır
ENTRYPOINT ["/entrypoint.sh"]
