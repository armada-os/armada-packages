#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ../toolchain.env

rm -rf out
mkdir -p out

podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
    cat >/etc/rpm/macros.armada <<EOF
%_buildhost armada-builder
%packager Armada
%vendor Armada
EOF

    NAME=armada-splash

    dnf -y install --skip-unavailable \
      rpm-build rpmdevtools dnf-plugins-core \
      tar gzip
    dnf -y builddep "${NAME}.spec"
    rpmdev-setuptree

    cp ${NAME}.spec ~/rpmbuild/SPECS/
    tar -cvzf ~/rpmbuild/SOURCES/${NAME}.tar.gz /work/

    spectool -g -R ~/rpmbuild/SPECS/${NAME}.spec
    rpmbuild -bb ~/rpmbuild/SPECS/${NAME}.spec

    cp ~/rpmbuild/RPMS/aarch64/*.rpm /work/out/
  '

echo "built: ${PACKAGE_DIR}/out"
