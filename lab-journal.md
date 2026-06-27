# Лабораторная работа: нагрузочное тестирование дисковых подсистем СХД

**Дата:** 27 июня 2026
**Исполнитель:** Hermes Agent (DeepSeek v4 Pro)
**Репозиторий:** dedvmedved-dot/disk-load-testing-lab

---

## Исходное состояние стендов

См. [inventory.md](inventory.md) — полная инвентаризация 4 стендов.

### Проверяемые бэкенды

| Код | Стенд | СХД | Узлы | Статус |
|-----|-------|-----|------|--------|
| B1a | micropak | DRBD 8.4 + LVM | 172.30.20.51-52 | ✅ Выполнен 26.06 |
| B1b | vapak | DRBD 9.2 + LVM | 172.30.20.151-152 | 🔄 В процессе |
| B2 | tssd | Ceph RBD | 10.129.11.21-23 | ⏳ Ожидает |
| B3 | microstand | HP P2000 FC | 172.30.20.249-251 | ⏳ Ожидает |
| B4 | ZFS Proxmox | ZFS | 192.168.0.136 | ❌ Недоступен |

---

### Шаг 1: Сканирование исходного состояния

**Цель:** зафиксировать конфигурацию всех узлов до начала тестирования.

**Команда:**
```bash
ssh astraadm@172.30.20.151 "hostname && cat /etc/astra_version && lscpu && free -h && lsblk"
```

**Результат:** метаданные сохранены в `hosts/` для каждого узла. См. [inventory.md](inventory.md).

✅ Шаг выполнен

---

### Шаг 2: B1b — DRBD 9.2 (vapak)

**Узел:** hv-01.vapak.local (172.30.20.151)

**Устройство:** `/dev/vg_kvm/fio-test` (LV 10GB на DRBD 9.2, /dev/drbd0)

**Методика:** 7 профилей fio (P1-P7), 9 уровней глубины очереди (USL), по 3 прогона

**Команда запуска:**
```bash
sudo bash test-backend.sh B1b_DRBD_vapak /dev/vg_kvm/fio-test /tmp/fio-results/B1b_DRBD_vapak
```

**Скрипт:** [scripts/test-backend.sh](scripts/test-backend.sh)

🔄 Выполняется...
