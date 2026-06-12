#!/bin/bash
# =============================================================================
# MANAGED NODE ENTRYPOINT SCRIPT
# =============================================================================
# Bu script container her başladığında çalışır
# =============================================================================

echo "============================================"
echo "Managed Node başlatılıyor..."
echo "============================================"

# SSH servisini başlat
echo "[1/2] SSH daemon başlatılıyor..."
/usr/sbin/sshd

# Bilgileri göster
echo "[2/2] Network bilgisi:"
echo "  Hostname: $(hostname)"
echo "  IP: $(hostname -I | awk '{print $1}')"

echo "============================================"
echo "Managed Node hazır!"
echo "  SSH bağlantısı için hazır"
echo "  Ansible komutlarını bekliyor..."
echo "============================================"

# Container'ı açık tut
exec tail -f /dev/null
