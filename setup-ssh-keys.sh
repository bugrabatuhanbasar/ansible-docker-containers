#!/bin/bash
# =============================================================================
# SSH KEY DAĞITIM SCRIPTİ
# =============================================================================
# Bu script Control Node'un SSH key'ini Managed Node'lara kopyalar
# Böylece şifresiz SSH bağlantısı yapılabilir
#
# ÇALIŞTIRMA: Container'lar ayağa kalktıktan sonra Mac'ten çalıştır
#   ./setup-ssh-keys.sh
# =============================================================================

echo "============================================"
echo "SSH Key Dağıtımı Başlıyor..."
echo "============================================"
echo ""

# -----------------------------------------------------------------------------
# ADIM 1: Control Node'un public key'ini al
# -----------------------------------------------------------------------------
echo "[1/3] Control Node'dan public key alınıyor..."

# docker exec: çalışan container'da komut çalıştır
# control-node: container adı
# cat /root/.ssh/id_rsa.pub: public key'i oku
PUBLIC_KEY=$(docker exec control-node cat /root/.ssh/id_rsa.pub)

if [ -z "$PUBLIC_KEY" ]; then
    echo "HATA: Public key alınamadı!"
    exit 1
fi

echo "  Public key alındı: ${PUBLIC_KEY:0:50}..."
echo ""

# -----------------------------------------------------------------------------
# ADIM 2: Key'i Managed Node'lara kopyala
# -----------------------------------------------------------------------------
echo "[2/3] Key Managed Node'lara kopyalanıyor..."

for NODE in managed-node1 managed-node2; do
    echo "  -> $NODE"

    # authorized_keys dosyasına public key'i ekle
    # Bu dosyadaki key'ler şifresiz bağlanabilir
    docker exec $NODE bash -c "mkdir -p /root/.ssh && echo '$PUBLIC_KEY' >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys"

    if [ $? -eq 0 ]; then
        echo "     Başarılı!"
    else
        echo "     HATA!"
    fi
done

echo ""

# -----------------------------------------------------------------------------
# ADIM 3: Bağlantıyı test et
# -----------------------------------------------------------------------------
echo "[3/3] SSH bağlantısı test ediliyor..."

for NODE in managed-node1 managed-node2; do
    echo "  -> Control Node'dan $NODE'a bağlantı:"

    # -o StrictHostKeyChecking=no: ilk bağlantıda soru sorma
    # -o BatchMode=yes: interaktif soru sorma (hata varsa fail et)
    RESULT=$(docker exec control-node ssh -o StrictHostKeyChecking=no -o BatchMode=yes $NODE hostname 2>&1)

    if [ "$RESULT" == "$NODE" ]; then
        echo "     Başarılı! (hostname: $RESULT)"
    else
        echo "     UYARI: $RESULT"
    fi
done

echo ""
echo "============================================"
echo "SSH Key Dağıtımı Tamamlandı!"
echo "============================================"
echo ""
echo "Artık Control Node'dan şifresiz bağlanabilirsin:"
echo "  docker exec -it control-node bash"
echo "  ssh managed-node1"
echo "  ssh managed-node2"
echo ""
echo "Veya Ansible ile test et:"
echo "  docker exec -it control-node ansible all -m ping"
echo ""
