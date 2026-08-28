#!/usr/bin/bash

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"

source ../TERRA.env
source ../toolchain.env

rm -rf out
mkdir -p out
podman run --rm \
  --volume "${PACKAGE_DIR}:/work:Z" \
  --workdir /work \
  --platform linux/aarch64 \
  --env TERRA_COMMIT="${TERRA_COMMIT}" \
  --env ARMADA_MARCH="${ARMADA_MARCH}" \
  "${BUILDER_IMAGE}" \
  bash -euxo pipefail -c '
    source /etc/os-release

    dnf install -y --nogpgcheck --repofrompath "terra,https://repos.fyralabs.com/terra${VERSION_ID}" terra-release
    dnf -y install --skip-unavailable \
        anda anda-srpm-macros

    cat >/etc/rpm/macros.armada <<EOF
%_buildhost armada-builder
%packager Armada
%vendor Armada
EOF

    git clone https://github.com/terrapkg/packages.git /tmp/packages

    cd /tmp/packages

    git checkout ${TERRA_COMMIT}

    PKG=anda/games/terra-gamescope
    SPEC="${PKG}/terra-gamescope.spec"

    mapfile -t PATCHES < <(
      find /work/patches \
        -maxdepth 1 \
        -type f \
        -name "[0-9][0-9][0-9][0-9]-*.patch" \
        -printf "%f\n" |
        sort -V
    )

    INSERT_LINE="$(
      grep -n -m1 "^BuildRequires:" "${SPEC}" |
        cut -d: -f1
    )"

    {
      head -n "$((INSERT_LINE - 1))" "${SPEC}"

      if (( ${#PATCHES[@]} > 0 )); then
        printf "Patch:         %s\n" "${PATCHES[@]}"
        printf "\n"
      fi

      tail -n "+${INSERT_LINE}" "${SPEC}"
    } >"${SPEC}.tmp"

    mv "${SPEC}.tmp" "${SPEC}"

    for patch in "${PATCHES[@]}"; do
      install -m0644 "/work/patches/${patch}" "${PKG}/${patch}"
    done

    TIMESTAMP=$(TZ=UTC date +%m%d%H)

    sed -i \
      -e "/^Release:/s/%?dist/.${TIMESTAMP}%{?dist}.armada/" \
      -e "/^%build$/i %global build_cflags %{build_cflags} ${ARMADA_MARCH}" \
      -e "/^%build$/i %global build_cxxflags %{build_cxxflags} ${ARMADA_MARCH}" \
      -e "s/^%autosetup\>/%autosetup -p1/" \
      -e "s/^%caps(cap_sys_nice=eip) %{_bindir}\/gamescope$/%{_bindir}\/gamescope/" \
      "${SPEC}"

    # Fail in case spec is invalid
    rpmspec -P "${SPEC}" >/dev/null

    dnf -y builddep "${SPEC}"
    anda build --rpm-builder=rpmbuild "${PKG}/pkg"

    cp /tmp/packages/anda-build/rpm/rpms/*.rpm /work/out/
'

echo "BUILT: ${PACKAGE_DIR}/OUT"
