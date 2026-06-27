# Инвентаризация стендов для нагрузочного тестирования

**Дата:** 27 июня 2026

## Сводка

| Стенд | Хосты | СХД | CPU | RAM |
|-------|-------|-----|-----|-----|
| micropak (DRBD 8.4) | hv-01 (.51), hv-02 (.52) | DRBD 8.4 + LVM | Xeon 6254/6248 | 376 GB |
| vapak (DRBD 9.2) | hv-01 (.151), hv-02 (.152) | DRBD 9.2 + LVM | Xeon | 376 GB |
| microstand (HP P2000 FC) | n1-n3 (.249-.251) | HP P2000 FC | Xeon | 188 GB |
| tssd (Ceph RBD) | n01-n03 (.21-.23) | Ceph RBD | Xeon 64C | 251 GB |

## micropak (DRBD 8.4)

| Хост | Hostname | RAM |
|------|----------|-----|
| 172.30.20.51 | hv-01.micropak.local | 376 GB (8.5G used) |
| 172.30.20.52 | hv-02.micropak.local | 376 GB (8.1G used) |

## vapak (DRBD 9.2)

| Хост | Hostname | RAM |
|------|----------|-----|
| 172.30.20.151 | hv-01.vapak.local | 376 GB (24G used) |
| 172.30.20.152 | hv-02.vapak.local | 376 GB (19G used) |

## microstand (HP P2000 FC)

| Хост | Hostname | RAM |
|------|----------|-----|
| 172.30.20.249 | micro-s-bkvm1n2.microstand.local | 188 GB (23G used) |
| 172.30.20.250 | micro-s-bkvm1n1.microstand.local | 188 GB (10G used) |
| 172.30.20.251 | micro-s-bkvm1n2.microstand.local | 188 GB (23G used) |

## tssd (Ceph RBD)

| Хост | Hostname | RAM |
|------|----------|-----|
| 10.129.11.21 | core3-s-tssd02n01.bstand.local | 251 GB (159G used) |
| 10.129.11.22 | core3-s-tssd02n02.bstand.local | 251 GB (137G used) |
| 10.129.11.23 | core3-s-tssd02n03.bstand.local | 251 GB (122G used) |
