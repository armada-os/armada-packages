#!/bin/bash
# Build Snapdragon Sensor Core userspace tools (adsprpcd + snsfeed).
set -euo pipefail
cd "$(dirname "$0")"

source ./BASE.env
source ../toolchain.env

PACKAGE_DIR="$(pwd)"
rm -rf out && mkdir out

FASTRPC_URL="https://github.com/qualcomm/fastrpc/archive/${COMMIT}.tar.gz"

podman run --rm \
  --platform linux/aarch64 \
  -v "${PACKAGE_DIR}:/work:Z" \
  "${BUILDER_IMAGE}" \
  bash -c '
set -euo pipefail
cd /work
dnf install -y gcc make tar gzip

mkdir -p _build && cd _build
curl -sL "'"${FASTRPC_URL}"'" | tar xz --strip-components=1
cp /work/src/bsd_shim.c /work/src/daemon_main.c /work/src/snsfeed.c src/

CFLAGS="-O2 -Iinc -Isrc -Isrc/dspqueue -DLE_ENABLE -DUSE_SYSLOG -fPIC -w"

FASTRPC_SRC="fastrpc_apps_user.c fastrpc_perf.c fastrpc_pm.c fastrpc_config.c \
  fastrpc_mem.c fastrpc_notif.c fastrpc_ioctl.c fastrpc_log.c fastrpc_procbuf.c \
  fastrpc_cap.c log_config.c dspsignal.c dspqueue/dspqueue_cpu.c \
  dspqueue/dspqueue_rpc_stub.c listener_android.c apps_std_imp.c apps_mem_imp.c \
  apps_mem_skel.c rpcmem_linux.c adspmsgd.c adspmsgd_printf.c std_path.c \
  std_dtoa.c BufBound.c platform_libs.c pl_list.c gpls.c remotectl_stub.c \
  remotectl1_stub.c adspmsgd_apps_skel.c adspmsgd_adsp_stub.c \
  adspmsgd_adsp1_stub.c apps_remotectl_skel.c adsp_current_process_stub.c \
  adsp_current_process1_stub.c adsp_listener_stub.c adsp_listener1_stub.c \
  apps_std_skel.c adsp_perf_stub.c adsp_perf1_stub.c mod_table.c \
  fastrpc_context.c adsp_default_listener.c adsp_default_listener_stub.c \
  adsp_default_listener1_stub.c bsd_shim.c daemon_main.c"

objs=""
for s in $FASTRPC_SRC; do
    o="src/$(echo $s | tr "/" "_").o"
    gcc $CFLAGS -c "src/$s" -o "$o"
    objs="$objs $o"
done
gcc -O2 -o /work/out/adsprpcd $objs -ldl -lm -lpthread
gcc -O2 -o /work/out/snsfeed src/snsfeed.c -lm
rm -rf /work/_build
'

echo "built: ${PACKAGE_DIR}/out"
ls -la out/
