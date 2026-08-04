#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ./BASE.env
source ../toolchain.env

rm -rf out
mkdir -p out

CCACHE_DIR="${CCACHE_DIR:-${PACKAGE_DIR}/.ccache}"
mkdir -p "${CCACHE_DIR}"

podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --volume "${CCACHE_DIR}:/ccache:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  --env KERNEL_VERSION="${VERSION}" \
  --env CCACHE_DIR=/ccache -e CCACHE_MAXSIZE=4G \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
      dnf -y install gcc binutils make bc bison flex openssl-devel \
          elfutils-libelf-devel dwarves zstd xz cpio patch curl perl-interpreter python3 \
          findutils diffutils gawk grep sed coreutils hostname gzip tar ccache kmod
      WORK_DIR=/tmp/armada-kernel-build OUT_DIR=/work/out \
          bash scripts/build-kernel.sh
  '

echo "built: ${PACKAGE_DIR}/out"
