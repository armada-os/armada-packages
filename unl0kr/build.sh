#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ./BASE.env
source ../toolchain.env

rm -rf out
mkdir -p out

podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  --env VERSION="${VERSION}" \
  --env LVGL_COMMIT="${LVGL_COMMIT}" \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
    export HOME=/tmp
    dnf -y install rpm-build rpmdevtools spectool "dnf-command(builddep)" git-core
    rpmdev-setuptree
    cat >/etc/rpm/macros.armada <<EOF
%_buildhost armada-builder
%packager Armada
%vendor Armada
EOF
    cp /work/unl0kr.spec ~/rpmbuild/SPECS/
    sed -i "s/^Version:.*/Version:        ${VERSION}/" ~/rpmbuild/SPECS/unl0kr.spec
    cp /work/patches/*.patch ~/rpmbuild/SOURCES/
    spectool -g -R --define "lvgl_commit ${LVGL_COMMIT}" ~/rpmbuild/SPECS/unl0kr.spec
    dnf -y builddep --define "lvgl_commit ${LVGL_COMMIT}" ~/rpmbuild/SPECS/unl0kr.spec
    rpmbuild -bb --define "lvgl_commit ${LVGL_COMMIT}" ~/rpmbuild/SPECS/unl0kr.spec
    cp ~/rpmbuild/RPMS/*/unl0kr-[0-9]*.armada.*.rpm /work/out/
  '

echo "built: ${PACKAGE_DIR}/out"
