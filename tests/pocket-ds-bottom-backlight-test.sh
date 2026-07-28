#!/usr/bin/env bash
# Static and optional live checks for the AYANEO Pocket DS lower-panel
# backlight/power path. The lower panel must be handled by the ST7703 panel
# driver with the TCA6408 GPIO0 rail modeled as iovcc-supply; userspace DRM
# disable/DPMS alone does not prove the physical lower backlight is dark.
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DTS="$ROOT/kernel/dts/qcs8550-ayaneo-pocketds.dts"
PANEL_PATCH="$ROOT/kernel/patches/0053-gpu-panel-add-Pocket-DS-lower-panel-driver.patch"
SY7758_PATCH="$ROOT/kernel/patches/0060-backlight-Add-SY7758-LED-driver.patch"
SY7758_BINDING="$ROOT/kernel/patches/0060-dt-bindings-silergy-sy7758.patch"
CONFIG="$ROOT/kernel/config/armada-kernel.config.overrides"

fail() { echo "FAIL: $*" >&2; exit 1; }

static_checks() {
  grep -q 'compatible = "ayaneo,pocket-ds-lower-panel";' "$DTS" \
    || fail 'Pocket DS lower panel is not bound to the ST7703-compatible panel'
  grep -A10 'regulator-panel1-iovcc' "$DTS" | grep -q 'compatible = "regulator-fixed";' \
    || fail 'lower-panel IOVCC must be modeled as a fixed regulator'
  grep -A10 'regulator-panel1-iovcc' "$DTS" | grep -q 'gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;' \
    || fail 'lower-panel IOVCC regulator must own TCA6408 GPIO0'
  grep -A18 'panel@0' "$DTS" | grep -q 'iovcc-supply = <&vreg_panel1_iovcc>;' \
    || fail 'lower panel must consume vreg_panel1_iovcc as iovcc-supply'
  grep -A18 'panel@0' "$DTS" | grep -q 'backlight = <&backlight>;' \
    || fail 'lower panel must be wired to the SY7758 backlight provider'
  ! grep -A18 'panel@0' "$DTS" | grep -q 'enable-gpio = <&tca6408 0 GPIO_ACTIVE_HIGH>;' \
    || fail 'old bespoke enable-gpio path would bypass regulator/panel power sequencing'

  grep -q 'CONFIG_DRM_PANEL_SITRONIX_ST7703=y' "$CONFIG" \
    || fail 'ST7703 panel driver must be built in for the boot DTB lower panel'
  grep -q '# CONFIG_DRM_PANEL_AR11_5INCH is not set' "$CONFIG" \
    || fail 'old AR11 lower-panel driver must stay disabled'
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

runtime_checks() {
  local host="${TARGET_HOST:-armada@100.104.177.29}"
  ssh -o BatchMode=yes -o ConnectTimeout=8 "$host" 'bash -s' <<'REMOTE'
set -euo pipefail
fail() { echo "FAIL: $*" >&2; exit 1; }

model="$(tr -d "\0" </sys/firmware/devicetree/base/model 2>/dev/null || true)"
case "$model" in *"AYANEO Pocket DS"*) ;; *) fail "not a Pocket DS: $model" ;; esac

if [ -r /sys/firmware/devicetree/base/soc@0/display-subsystem@ae00000/dsi@ae96000/panel@0/compatible ]; then
  tr '\0' '\n' </sys/firmware/devicetree/base/soc@0/display-subsystem@ae00000/dsi@ae96000/panel@0/compatible \
    | grep -qx 'ayaneo,pocket-ds-lower-panel' || fail 'booted DT is not ST7703 lower-panel compatible'
else
  fail 'cannot read lower-panel compatible from live device tree'
fi

if [ -e /sys/class/drm/card0-DSI-2/enabled ]; then
  :
else
  fail 'DSI-2 connector missing; DRM did not expose lower connector'
fi

# Regulator debugfs is optional on production kernels; if present, verify the
# modeled rail is visible so a Game/Desktop mode cycle can be correlated with
# the physical lower backlight.
if [ -d /sys/kernel/debug/regulator ]; then
  grep -Rsl 'panel1-iovcc' /sys/kernel/debug/regulator >/tmp/pds-panel1-iovcc.paths 2>/dev/null || true
  [ -s /tmp/pds-panel1-iovcc.paths ] || fail 'panel1-iovcc regulator not visible in debugfs'
  echo 'panel1-iovcc debugfs paths:'
  cat /tmp/pds-panel1-iovcc.paths
fi

printf 'Pocket DS bottom-backlight runtime smoke checks passed\n'
REMOTE
}

case "${1:-static}" in
  static) static_checks ;;
  runtime) static_checks; runtime_checks ;;
  *) echo "usage: $0 [static|runtime]" >&2; exit 2 ;;
esac
