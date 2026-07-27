#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DTS="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts"

grep -A4 '&mdss_dsi1 {' "$DTS" | grep -q 'status = "okay";'
grep -A3 '&mdss_dsi1_phy {' "$DTS" | grep -q 'status = "okay";'
grep -q 'ayaneo,pocket-ds-lower-panel' "$DTS"
grep -q 'regulator-panel1-iovcc' "$DTS"
grep -A10 'regulator-panel1-iovcc' "$DTS" | grep -q 'gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;'
grep -A14 'panel@0' "$DTS" | grep -q 'vcc-supply = <&sgm3804>;'
grep -A14 'panel@0' "$DTS" | grep -q 'iovcc-supply = <&vreg_panel1_iovcc>;'
if grep -A14 'panel@0' "$DTS" | grep -q 'enable-gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;'; then
  echo 'secondary panel still uses bespoke enable-gpio instead of ST7703 iovcc-supply' >&2
  exit 1
fi
printf 'Pocket DS ST7703 lower-panel DTS checks passed\n'
