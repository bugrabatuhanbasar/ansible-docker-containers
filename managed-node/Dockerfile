# =============================================================================
# MANAGED NODE DOCKERFILE
# =============================================================================
# Bu Dockerfile Ansible ile yönetilecek Managed Node'ları oluşturur
# Her iki managed node da bu Dockerfile'ı kullanır
# Hostname docker-compose.yml'de belirlenir (managed-node1, managed-node2)
# =============================================================================

# -----------------------------------------------------------------------------
# BASE IMAGE
# -----------------------------------------------------------------------------
FROM centos:7

# -----------------------------------------------------------------------------
# LABEL (Metadata)
# -----------------------------------------------------------------------------
LABEL maintainer="Bugra Batuhan Basar"
LABEL description="Ansible Managed Node - CentOS 7"
LABEL version="1.0"

# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------
ENV container=docker
ENV LANG=en_US.UTF-8

# -----------------------------------------------------------------------------
# SYSTEM UPDATE & TEMEL PAKETLER
# -----------------------------------------------------------------------------
# NOT: Senin komutların:
#   - hostnamectl set-hostname: Docker-compose'da hostname ile yapılır
#   - dhclient: Docker otomatik IP atar (gereksiz)
#   - onboot=yes: restart policy ile yapılır
#   - yum update -y: Yapıyoruz
#   - systemctl disable/stop firewalld: Docker'da firewall yok
#   - reboot: Docker'da gereksiz (image build sırasında anlamsız)
#   - yum install net-tools -y: Yapıyoruz

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        # net-tools: ifconfig, netstat gibi ağ araçları
        net-tools \
        # sudo: root dışı kullanıcılar için
        sudo \
        # vim: dosya düzenleme
        vim \
        # Python: Ansible modülleri Python gerektirir!
        # NOT: Ansible agent'sız çalışır AMA Python lazım
        python \
    && yum clean all

# -----------------------------------------------------------------------------
# OPENSSH SERVER KURULUMU
# -----------------------------------------------------------------------------
# Managed Node'larda SSH server şart!
# Control Node buraya SSH ile bağlanacak

RUN yum install -y openssh-server openssh-clients && \
    yum clean all && \
    # SSH host key'leri oluştur
    ssh-keygen -A && \
    # Root şifresi (tüm node'larda aynı, lab ortamı için)
    echo "root:ansible" | chpasswd && \
    # Root SSH girişine izin ver
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    # Şifreli girişe izin ver
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# -----------------------------------------------------------------------------
# SSH KEY OLUŞTURMA (Opsiyonel)
# -----------------------------------------------------------------------------
# Managed node'ların da key'i olsun (birbirlerine bağlanabilsinler)
# NOT: Senin komutun: ssh-keygen

RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa && \
    chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# -----------------------------------------------------------------------------
# STARTUP SCRIPT
# -----------------------------------------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -----------------------------------------------------------------------------
# PORT EXPOSE
# -----------------------------------------------------------------------------
EXPOSE 22

# -----------------------------------------------------------------------------
# ENTRYPOINT
# -----------------------------------------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]
