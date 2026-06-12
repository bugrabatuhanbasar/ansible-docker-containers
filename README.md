# Ansible Multi-Node Lab (Docker)

Bu proje Docker Compose kullanarak Ansible öğrenme ortamı oluşturur.

## Yapı

```
ansible-containers/
├── docker-compose.yml      # Ana orkestrasyon dosyası
├── control-node/           # Ansible Control Node
│   ├── Dockerfile          # CentOS 7 + Ansible
│   └── entrypoint.sh       # Başlangıç scripti
├── managed-node/           # Managed Node'lar (her ikisi için)
│   ├── Dockerfile          # CentOS 7 + SSH
│   └── entrypoint.sh       # Başlangıç scripti
├── setup-ssh-keys.sh       # SSH key dağıtım scripti
└── README.md               # Bu dosya
```

## Hızlı Başlangıç

```bash
# 1. Container'ları oluştur ve başlat
docker-compose up -d --build

# 2. SSH key'leri dağıt (ilk seferde)
chmod +x setup-ssh-keys.sh
./setup-ssh-keys.sh

# 3. Control Node'a bağlan ve Ansible kullan
docker exec -it control-node bash
ansible all -m ping
```

## SSH Bağlantıları

| Kaynak | Hedef | Komut |
|--------|-------|-------|
| Mac | control-node | `ssh root@localhost -p 2222` |
| Mac | managed-node1 | `ssh root@localhost -p 2223` |
| Mac | managed-node2 | `ssh root@localhost -p 2224` |
| control-node | managed-node1 | `ssh managed-node1` |
| control-node | managed-node2 | `ssh managed-node2` |

**Şifre:** `ansible` (tüm node'lar için)

## Komutlar

```bash
# Container'ları başlat
docker-compose up -d

# Container'ları durdur
docker-compose down

# Logları gör
docker-compose logs -f

# Container'a bağlan
docker exec -it control-node bash
docker exec -it managed-node1 bash
docker exec -it managed-node2 bash

# Container durumlarını gör
docker-compose ps
```

## Ansible Komutları (Control Node içinde)

```bash
# Tüm node'lara ping at
ansible all -m ping

# Komut çalıştır
ansible all -a "uptime"

# Playbook çalıştır
ansible-playbook /path/to/playbook.yml

# Inventory listele
ansible-inventory --list
```

## Notlar

- **CentOS 7** kullanılıyor (stabil, Ansible uyumlu)
- Tüm node'lar aynı Docker network'te (`ansible-lab-network`)
- Container'lar birbirini hostname ile bulabilir
- `privileged: true` ayarı bazı sistem komutları için gerekli
