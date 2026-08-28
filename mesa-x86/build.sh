#!/usr/bin/bash
# x86_64 + i686 Turnip for the FEX guest rootfs.

set -euxo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
PACKAGE_DIR="${PWD}"
REPO_DIR="${PWD}/.."

source ./BASE.env

# Source and patches come from the host mesa package; the two must not drift.
source ../mesa/BASE.env

SOURCE_URL="${SOURCE_URL:-}"
SOURCE_SHA256="${SOURCE_SHA256:-}"
SOURCE_TARBALL="${SOURCE_URL##*/}"
if [ -z "${SOURCE_URL}" ] || [ -z "${SOURCE_SHA256}" ]; then
    echo "ERROR: mesa-x86 needs SOURCE_URL+SOURCE_SHA256 in mesa/BASE.env (the Arch builder has no koji for the SRPM fallback)." >&2
    exit 1
fi

rm -rf out
mkdir -p out/rootfs/usr/lib out/rootfs/usr/lib32 out/rootfs/usr/share/vulkan/icd.d
cleanup() { rm -rf out/rootfs; }
trap cleanup EXIT

podman run --rm \
  --volume "${REPO_DIR}:/repo:Z" \
  --workdir /repo/mesa-x86 \
  --platform linux/amd64 \
  "${GUEST_BUILDER_IMAGE}" \
  bash -euxo pipefail -c "
        # Pin the whole container to the guest rootfs snapshot: the driver must
        # not reference glibc symbols newer than the rootfs ships.
        echo 'Server=https://archive.archlinux.org/repos/${GUEST_SNAPSHOT}/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist
        printf '[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
        pacman -Syyuu --noconfirm
        pacman -S --noconfirm --needed \
            meson ninja python-mako python-yaml python-packaging python-ply \
            bison flex cmake glslang squashfs-tools \
            libdrm libxcb libx11 libxshmfence libxrandr xcb-util-keysyms wayland wayland-protocols \
            lib32-glibc lib32-gcc-libs lib32-libdrm lib32-libxcb lib32-libx11 \
            lib32-libxshmfence lib32-libxrandr lib32-xcb-util-keysyms \
            lib32-wayland lib32-zlib lib32-expat lib32-zstd

        cd /tmp
        curl --fail --location --retry 3 --remote-name '${SOURCE_URL}'
        printf '%s  %s\n' '${SOURCE_SHA256}' '${SOURCE_TARBALL}' | sha256sum --check --strict
        tar xf '${SOURCE_TARBALL}'
        cd \"\$(tar tf '${SOURCE_TARBALL}' | head -1 | cut -d/ -f1)\"
        for patch in /repo/mesa/patches/*.patch; do
            patch -p1 <\"\$patch\"
        done

        cat >/tmp/cross32 <<EOF
[binaries]
c = ['gcc', '-m32']
cpp = ['g++', '-m32']
ar = 'ar'
strip = 'strip'
pkg-config = 'pkg-config'

[properties]
pkg_config_libdir = '/usr/lib32/pkgconfig:/usr/share/pkgconfig'

[host_machine]
system = 'linux'
cpu_family = 'x86'
cpu = 'i686'
endian = 'little'
EOF

        # baseline -march like the rootfs userspace; FEX emulates AVX in slower 128-bit halves
        common='--buildtype release --prefix /usr
            -Dgallium-drivers= -Dvulkan-drivers=freedreno -Dfreedreno-kmds=msm
            -Dplatforms=x11,wayland -Dglx=disabled -Degl=disabled -Dgbm=disabled
            -Dopengl=false -Dllvm=disabled -Dallow-fallback-for=libdrm'
        CFLAGS='-march=x86-64' CXXFLAGS='-march=x86-64' \
            meson setup build-x86_64 --libdir lib \$common
        ninja -C build-x86_64
        CFLAGS='-march=x86-64' CXXFLAGS='-march=x86-64' \
            meson setup build-i686 --libdir lib32 --cross-file /tmp/cross32 \$common
        ninja -C build-i686

        install -m 0644 build-x86_64/src/freedreno/vulkan/libvulkan_freedreno.so   /repo/mesa-x86/out/rootfs/usr/lib/
        install -m 0644 build-x86_64/src/freedreno/vulkan/freedreno_icd.x86_64.json /repo/mesa-x86/out/rootfs/usr/share/vulkan/icd.d/
        install -m 0644 build-i686/src/freedreno/vulkan/libvulkan_freedreno.so     /repo/mesa-x86/out/rootfs/usr/lib32/
        install -m 0644 build-i686/src/freedreno/vulkan/freedreno_icd.i686.json     /repo/mesa-x86/out/rootfs/usr/share/vulkan/icd.d/

        # The FEX rootfs ships no xcb-keysyms; pressure-vessel dlopen-inspects
        # each provider ICD and silently drops one with an unresolvable dep.
        install -m 0644 /usr/lib/libxcb-keysyms.so.1   /repo/mesa-x86/out/rootfs/usr/lib/
        install -m 0644 /usr/lib32/libxcb-keysyms.so.1 /repo/mesa-x86/out/rootfs/usr/lib32/

        # container glibc == rootfs glibc (snapshot pin above), so newer symbol refs cannot load
        glibc_max=\$(ldd --version | sed -n '1s/.* //p')
        for so in /repo/mesa-x86/out/rootfs/usr/lib/libvulkan_freedreno.so /repo/mesa-x86/out/rootfs/usr/lib32/libvulkan_freedreno.so; do
            ceiling=\$(objdump -T \"\$so\" | grep -o 'GLIBC_[0-9.]*' | sed 's/GLIBC_//' | sort -uV | tail -1)
            if [ \"\$(printf '%s\n%s\n' \"\$ceiling\" \"\$glibc_max\" | sort -V | tail -1)\" != \"\$glibc_max\" ]; then
                echo \"ERROR: \$so references GLIBC_\$ceiling, newer than the rootfs glibc \$glibc_max\" >&2
                exit 1
            fi
        done

        mksquashfs /repo/mesa-x86/out/rootfs /repo/mesa-x86/out/ArmadaMesa.sqsh \
            -comp zstd -b 131072 -all-root -no-xattrs \
            -noappend -no-progress

        unsquashfs -cat /repo/mesa-x86/out/ArmadaMesa.sqsh \
            usr/share/vulkan/icd.d/freedreno_icd.x86_64.json | python3 -m json.tool >/dev/null
        unsquashfs -cat /repo/mesa-x86/out/ArmadaMesa.sqsh \
            usr/share/vulkan/icd.d/freedreno_icd.i686.json | python3 -m json.tool >/dev/null
        unsquashfs -cat /repo/mesa-x86/out/ArmadaMesa.sqsh usr/lib/libvulkan_freedreno.so >/dev/null
        unsquashfs -cat /repo/mesa-x86/out/ArmadaMesa.sqsh usr/lib32/libvulkan_freedreno.so >/dev/null
    "

echo "built: ${PACKAGE_DIR}/out"
