#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/arch/arm64/boot/dts/qcom"
cp "$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts" "$TMP/arch/arm64/boot/dts/qcom/qcs8550-ayaneo-pocketds.dts"
(
  cd "$TMP"
  patch -p1 < "$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts.patch" >/dev/null
)
DTS="$TMP/arch/arm64/boot/dts/qcom/qcs8550-ayaneo-pocketds.dts"
grep -q 'secondary panel backlight disabled' "$DTS"
grep -A4 '&mdss_dsi1 {' "$DTS" | grep -q 'status = "okay";'
grep -A3 '&mdss_dsi1_phy {' "$DTS" | grep -q 'status = "okay";'
grep -A4 'backlight: backlight@2e' "$DTS" | grep -q 'status = "disabled";'
grep -A5 'touchscreen@5d' "$DTS" | grep -q 'status = "disabled";'
if grep -q 'backlight = <&backlight>;' "$DTS"; then
  echo 'secondary panel still references disabled kernel backlight' >&2
  exit 1
fi
printf 'Pocket DS DSI-2 DTS patch checks passed\n'
