#!/bin/bash
# ============================================================
# Универсальный скрипт нагрузочного тестирования СХД
# Методика YADRO v2: P1-P7, USL, гистограммы
# Аргументы: BACKEND_NAME DEVICE_PATH [OUTPUT_DIR]
# ============================================================
# ВАЖНО: без set -e! fio с multi-job профилями (P2/P3) 
# может вернуть ненулевой код, но данные записываются.
# ============================================================

BACKEND="${1:?Usage: $0 BACKEND_NAME DEVICE_PATH [OUTPUT_DIR]}"
DEV="${2:?Device path required}"
OUTDIR="${3:-/tmp/fio-results/$BACKEND}"

mkdir -p "$OUTDIR"
echo "=== $BACKEND: fio тест ==="
echo "Device: $DEV"
echo "Output: $OUTDIR"
echo "Started: $(date +%H:%M:%S)"

# P7: USL Scalability — 9 прогонов qd=1-256
for qd in 1 2 4 8 16 32 64 128 256; do
    echo -n "  qd=$qd..."
    fio --name=P7_qd${qd} --rw=randrw --bs=8k --rwmixread=70 \
        --filename="$DEV" --size=2G --time_based --runtime=120 \
        --ioengine=libaio --direct=1 --iodepth=$qd --numjobs=1 \
        --group_reporting --output-format=json \
        --write_hist_log="$OUTDIR/P7_qd${qd}" --log_hist_msec=1000 \
        > "$OUTDIR/P7_qd${qd}.json" 2>/dev/null || echo "FAILED"
    iops=$(python3 -c "import json; d=json.load(open('$OUTDIR/P7_qd${qd}.json')); print(int(d['jobs'][0]['read']['iops']+d['jobs'][0]['write']['iops']))" 2>/dev/null || echo "?")
    echo " IOPS=$iops"
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
done

# P1-P6: 3 повтора каждый
for profile in P1_oltp P2_olap P3_stream P4_mixed P5_metadata P6_fsync; do
    for run in 1 2 3; do
        echo -n "  ${profile}_run${run}..."
        case $profile in
            P1_oltp)   fio --name=${profile}_run${run} --rw=randrw --bs=8k --rwmixread=70 --filename="$DEV" --size=2G --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=32 --numjobs=1 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
            P2_olap)   fio --name=${profile}_run${run} --rw=rw --bs=1M --rwmixread=90 --filename="$DEV" --size=15% --offset_increment=15% --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=8 --numjobs=5 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
            P3_stream) fio --name=${profile}_run${run} --rw=write --bs=1M --filename="$DEV" --size=15% --offset_increment=15% --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=8 --numjobs=5 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
            P4_mixed)  fio --name=${profile}_run${run} --rw=randrw --bs=4k-64k --rwmixread=50 --filename="$DEV" --size=2G --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=32 --numjobs=1 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
            P5_metadata) fio --name=${profile}_run${run} --rw=randread --bs=4k --filename="$DEV" --size=2G --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=64 --numjobs=1 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
            P6_fsync)  fio --name=${profile}_run${run} --rw=randwrite --bs=4k --fsync=1 --filename="$DEV" --size=2G --time_based --runtime=300 --ioengine=libaio --direct=1 --iodepth=1 --numjobs=1 --group_reporting --output-format=json --write_hist_log="$OUTDIR/${profile}_run${run}" --log_hist_msec=1000 > "$OUTDIR/${profile}_run${run}.json" 2>/dev/null || echo "FAILED" ;;
        esac
        iops=$(python3 -c "import json; d=json.load(open('$OUTDIR/${profile}_run${run}.json')); print(int(d['jobs'][0]['read']['iops']+d['jobs'][0]['write']['iops']))" 2>/dev/null || echo "?")
        echo " IOPS=$iops"
        echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
    done
done
echo "=== $BACKEND: DONE $(date +%H:%M:%S) ==="
