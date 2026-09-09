#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ./BASE.env
source ../toolchain.env

REST="${SRPM#plasma-mobile-}"
PLASMA_MOBILE_VER="${REST%%-*}"
PLASMA_MOBILE_REL="${REST#*-}"
PLASMA_MOBILE_REL="${PLASMA_MOBILE_REL%.fc*}"
DIST=".fc44.armada"
PATCH="0001-mobileshell-shellutil-Simplify-the-Set-Input-Region-.patch"

rm -rf out
mkdir -p out

podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  --env SRPM="${SRPM}" \
  --env PLASMA_MOBILE_VER="${PLASMA_MOBILE_VER}" \
  --env PLASMA_MOBILE_REL="${PLASMA_MOBILE_REL}" \
  --env DIST="${DIST}" \
  --env PATCH="${PATCH}" \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
    export HOME=/tmp
    dnf -y install rpm-build rpmdevtools koji "dnf-command(builddep)"
    rpmdev-setuptree
    cat >/etc/rpm/macros.armada <<EOF
%_buildhost armada-builder
%packager Armada
%vendor Armada
EOF

    cd /tmp
    koji download-build --arch=src "${SRPM}"
    rpm -i "${SRPM}.src.rpm"
    SPEC="$HOME/rpmbuild/SPECS/plasma-mobile.spec"

    sed -i "s/^Release:.*/Release: ${PLASMA_MOBILE_REL}%{?dist}/" "$SPEC"

    cp "/work/patches/${PATCH}" "$HOME/rpmbuild/SOURCES/"
    LAST=$(grep -nE "^(Patch|Source)[0-9]*:" "$SPEC" | tail -1 | cut -d: -f1)
    [ -n "$LAST" ] || { echo "ERROR: no Source/Patch line to anchor on"; exit 1; }
    sed -i "${LAST}a Patch9001: ${PATCH}" "$SPEC"

    grep -qE "^[[:space:]]*%autosetup" "$SPEC" \
        || { echo "ERROR: plasma-mobile.spec does not auto-apply patches; adjust build.sh"; exit 1; }

    dnf -y builddep "$SPEC"
    rpmbuild -bb --define "dist ${DIST}" "$SPEC"

    cp "$HOME"/rpmbuild/RPMS/*/plasma-mobile-"${PLASMA_MOBILE_VER}-${PLASMA_MOBILE_REL}${DIST}".*.rpm /work/out/
    cp "$HOME"/rpmbuild/RPMS/*/plasma-lookandfeel-fedora-mobile-"${PLASMA_MOBILE_VER}-${PLASMA_MOBILE_REL}${DIST}".*.rpm /work/out/
  '

echo "built: ${PACKAGE_DIR}/out"
