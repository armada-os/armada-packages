#!/usr/bin/env bash
# Static checks for the AYANEO Pocket DS lower-panel backlight/power path.
# The lower panel must be handled by the ST7703 panel driver with the TCA6408
# GPIO0 rail modeled as iovcc-supply; userspace DRM disable/DPMS alone does not
# prove the physical lower backlight is dark.
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DTS="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts"
DTS_PATCH="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts.patch"
PANEL_PATCH="$ROOT/kernel/patches/0053-gpu-panel-add-Pocket-DS-lower-panel-driver.patch"
SY7758_PATCH="$ROOT/kernel/patches/0060-backlight-Add-SY7758-LED-driver.patch"
SY7758_BINDING="$ROOT/kernel/patches/0060-dt-bindings-silergy-sy7758.patch"
CONFIG="$ROOT/kernel/config/armada-kernel.config.overrides"

fail() { echo "FAIL: $*" >&2; exit 1; }

patched_dts() {
  local tmpdir="$1"
  local target="$tmpdir/arch/arm64/boot/dts/qcom/qcs8550-ayaneo-pocketds.dts"

  mkdir -p "$(dirname "$target")"
  cp "$DTS" "$target"
  patch -p1 -d "$tmpdir" --no-backup-if-mismatch -s < "$DTS_PATCH" \
    || fail 'Pocket DS DTS edit patch does not apply'
  printf '%s\n' "$target"
}

static_checks() {
  local tmpdir dts_under_test
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  dts_under_test="$(patched_dts "$tmpdir")"

  grep -q 'compatible = "ayaneo,pocket-ds-lower-panel";' "$dts_under_test" \
    || fail 'Pocket DS lower panel is not bound to the ST7703-compatible panel'
  grep -A10 'regulator-panel1-iovcc' "$dts_under_test" | grep -q 'compatible = "regulator-fixed";' \
    || fail 'lower-panel IOVCC must be modeled as a fixed regulator'
  grep -A10 'regulator-panel1-iovcc' "$dts_under_test" | grep -q 'gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;' \
    || fail 'lower-panel IOVCC regulator must own TCA6408 GPIO0'
  grep -A18 'panel@0' "$dts_under_test" | grep -q 'iovcc-supply = <&vreg_panel1_iovcc>;' \
    || fail 'lower panel must consume vreg_panel1_iovcc as iovcc-supply'
  grep -A18 'panel@0' "$dts_under_test" | grep -q 'backlight = <&backlight>;' \
    || fail 'lower panel must be wired to the SY7758 backlight provider'
  ! grep -A18 'panel@0' "$dts_under_test" | grep -q 'enable-gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;' \
    || fail 'old bespoke enable-gpio path would bypass regulator/panel power sequencing'

  grep -q 'CONFIG_DRM_PANEL_SITRONIX_ST7703=y' "$CONFIG" \
    || fail 'ST7703 panel driver must be built in for the boot DTB lower panel'
  grep -q 'ayaneo,pocket-ds-lower-panel' "$PANEL_PATCH" \
    || fail 'ST7703 panel patch must register AYANEO Pocket DS lower compatible'
  grep -q 'ayaneo_pocket_ds_lower_init_sequence' "$PANEL_PATCH" \
    || fail 'ST7703 patch must carry the Pocket DS lower panel init sequence'
  grep -q 'devm_gpiod_get_optional(dev, "enable", GPIOD_OUT_HIGH)' "$SY7758_PATCH" \
    || fail 'SY7758 driver must tolerate Pocket DS boards without a separate enable GPIO'
  ! grep -A5 '^+required:' "$SY7758_BINDING" | grep -q 'enable-gpios' \
    || fail 'SY7758 binding must not require enable-gpios for Pocket DS-compatible wiring'

  printf 'Pocket DS bottom-backlight static checks passed\n'
}

case "${1:-static}" in
  static) static_checks ;;
  *) echo "usage: $0 [static]" >&2; exit 2 ;;
esac
