#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DTS="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts"
DTS_PATCH="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts.patch"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
patched_dts="$tmpdir/arch/arm64/boot/dts/qcom/qcs8550-ayaneo-pocketds.dts"
mkdir -p "$(dirname "$patched_dts")"
cp "$DTS" "$patched_dts"
patch -p1 -d "$tmpdir" --no-backup-if-mismatch -s < "$DTS_PATCH"

grep -A4 '&mdss_dsi1 {' "$patched_dts" | grep -q 'status = "okay";'
grep -A3 '&mdss_dsi1_phy {' "$patched_dts" | grep -q 'status = "okay";'
grep -q 'ayaneo,pocket-ds-lower-panel' "$patched_dts"
grep -q 'regulator-panel1-iovcc' "$patched_dts"
grep -A10 'regulator-panel1-iovcc' "$patched_dts" | grep -q 'gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;'
grep -A14 'panel@0' "$patched_dts" | grep -q 'vcc-supply = <&sgm3804>;'
grep -A14 'panel@0' "$patched_dts" | grep -q 'iovcc-supply = <&vreg_panel1_iovcc>;'
if grep -A14 'panel@0' "$patched_dts" | grep -q 'enable-gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;'; then
  echo 'secondary panel still uses bespoke enable-gpio instead of ST7703 iovcc-supply' >&2
  exit 1
fi
printf 'Pocket DS ST7703 lower-panel DTS checks passed\n'
