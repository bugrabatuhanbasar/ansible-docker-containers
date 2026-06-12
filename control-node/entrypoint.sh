#!/bin/bash
# =============================================================================
# CONTROL NODE ENTRYPOINT SCRIPT
# =============================================================================
# Bu script container her başladığında çalışır
# VM'deki "systemctl start" komutlarının yerine geçer
# =============================================================================

# -----------------------------------------------------------------------------
# SSH DAEMON BAŞLAT
# -----------------------------------------------------------------------------
# NOT: VM'de "systemctl start sshd" yapardık
# Docker'da systemctl yok, bu yüzden doğrudan daemon başlatıyoruz
# -D: Foreground'da çalış (debug için)
# Ama biz background'da çalıştırıp shell açık tutacağız

echo "============================================"
echo "Control Node başlatılıyor..."
echo "============================================"

# SSH servisini başlat
echo "[1/3] SSH daemon başlatılıyor..."
/usr/sbin/sshd

# IP adresini göster
echo "[2/3] Network bilgisi:"
echo "  Hostname: $(hostname)"
echo "  IP: $(hostname -I | awk '{print $1}')"

# Ansible versiyonunu göster
echo "[3/3] Ansible bilgisi:"
echo "  $(ansible --version | head -1)"

echo "============================================"
echo "Control Node hazır!"
echo "============================================"
echo ""
echo "Kullanım:"
echo "  - Mac'ten SSH: ssh root@localhost -p 2222"
echo "  - Şifre: ansible"
echo ""
echo "Ansible komutları:"
echo "  - ansible all -m ping"
echo "  - ansible-playbook playbook.yml"
echo ""

# Container'ı açık tut (aksi halde kapanır)
# NOT: Docker container'ları ana process bitince kapanır
# "tail -f /dev/null" sonsuz bekler, container açık kalır
exec tail -f /dev/null
