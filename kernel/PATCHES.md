# Patches

Patches applied on top of BASE.env. Each entry's `source` is a URL pinned to a
commit, or `armada` for original work; a URL source with no `notes` is verbatim.
`notes` explain modifications or important differences from linked upstream work.
A patch entry's `upstream` is `local` for an Armada-authored change, `unknown` when
no equivalent submission was found, or a permanent URL to the upstream submission.

## SM8550_SLEEP patch set

Kernel members carry an inline `#SM8550_SLEEP` tag in `patches/series`; run
`rg '#SM8550_SLEEP' kernel/patches/series` from the repository root to list the
complete ordered set. The separately applied board deltas are
`dts/qcs8550-ayn-common.dtsi.patch` and `dts/qcs8550-ayn-thor.dts.patch`.
Patch `1009` follows `1029` because it consumes the gated UFS state. Patches
`1023` and `0520` are compatible-scoped and independent of the boot gate.

- `patches/0002-qcom-dispcc-sm8550-Fix-disp_cc_mdss_mdp_clk_src.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0002-qcom-dispcc-sm8550-Fix-disp_cc_mdss_mdp_clk_src.patch
  upstream: unknown
- `patches/0004-drm-msm-a6xx-Enable-IFPC-on-Adreno-740.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0004-drm-msm-a6xx-Enable-IFPC-on-Adreno-740.patch
  upstream: unknown
- `patches/0010-msm-resource-cleanup.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/packages/linux/patches/7.0/0010-msm-resource-cleanup.patch
  upstream: unknown
- `patches/0048-drm-msm-dsi-reparent-byte-pixel-src-to-xo-on-disable.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0048-drm-msm-dsi-reparent-byte-pixel-src-to-xo-on-disable.patch
  upstream: unknown
- `patches/0049-drm-msm-dpu-panel-opt-in-8bpc-dither.patch`
  source: armada
  upstream: local
  notes: Armada wrote this patch; it has not been submitted upstream.
- `patches/0016-rp5-smooth-brightness-adjustment.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0016-rp5-smooth-brightness-adjustment.patch
  upstream: unknown
  notes: Armada limited the ROCKNIX brightness change to SM8250 panels. A [related upstream proposal](https://lore.kernel.org/r/20260706180753.408753-1-kavansmith82@gmail.com) uses a different implementation.
- `patches/0028-drm-panel-Add-panel-driver-for-Chipone-ICNA35XX-base.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0028-drm-panel-Add-panel-driver-for-Chipone-ICNA35XX-base.patch
  upstream: https://lore.kernel.org/r/20260607-icna35xx-v4-2-64de514add34@gmail.com
  notes: The ROCKNIX implementation is ported to Linux 7.2's managed DRM panel allocator.
- `patches/0051-gpu-panel-add-Pocket-ACE-panel-driver.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0051-gpu-panel-add-Pocket-ACE-panel-driver.patch
  upstream: unknown
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0052-gpu-panel-add-Pocket-DMG-panel-driver.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0052-gpu-panel-add-Pocket-DMG-panel-driver.patch
  upstream: unknown
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0053-gpu-panel-st7703-add-Pocket-DS-lower-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/7651a1b97d762d2c7dc335fa82a7a254c3a12927/projects/ROCKNIX/devices/SM8550/patches/linux/0053-gpu-panel-st7703-add-Pocket-DS-lower-panel.patch
  upstream: https://lore.kernel.org/r/20260723-b4-st7703-pocketds-lower-v1-2-e3db246589f4@gmail.com
- `patches/0055_Synaptics-TD4328-LCD-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0055_Synaptics-TD4328-LCD-panel.patch
  upstream: https://lore.kernel.org/r/20240424-ayn-odin2-initial-v1-4-e0aa05c991fd@gmail.com
  notes: The earlier ROCKNIX implementation is ported to Linux 7.2's managed DRM panel allocator.
- `patches/0056_Xm-Plus-XM91080G-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0056_Xm-Plus-XM91080G-panel.patch
  upstream: unknown
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0057_DDIC-CH13726A-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0057_DDIC-CH13726A-panel.patch
  upstream: unknown
  notes: Retains additional compatibles and the 120 ms sleep-out delay, using Linux 7.2's managed DRM panel allocator.
- `patches/0062-gpu-drm-panel-add-wt0630-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0062-gpu-drm-panel-add-wt0630-panel.patch
  upstream: https://lore.kernel.org/r/20260625-topic-sm8650-ayaneo-pocket-s2-r63419-v8-2-8570e692143e@linaro.org
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0104-drm-panel-Add-Retroid-Pocket-6-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0104-drm-panel-Add-Retroid-Pocket-6-panel.patch
  upstream: unknown
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0105-drm-panel-Add-Retroid-Pocket-Nova-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0105-drm-panel-Add-Retroid-Pocket-Nova-panel.patch
  upstream: unknown
  notes: Ported to Linux 7.2's managed DRM panel allocator.
- `patches/0058_AYN-Odin2-Mini--backlight.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0058_AYN-Odin2-Mini--backlight.patch
  upstream: unknown
  notes: Armada refreshed only the Makefile context for Linux 7.1's backlight object list; driver behavior is unchanged.
- `patches/0060-backlight-Add-SY7758-LED-driver.patch`
  source: https://patchwork.kernel.org/project/dri-devel/patch/20260529-topic-sm8650-ayaneo-pocket-s2-sy7758-v5-2-03aacd49747c@linaro.org/
  upstream: https://lore.kernel.org/r/178300990349.2239788.13080024963462152507.b4-ty@b4
  notes: Armada made the enable GPIO optional (`devm_gpiod_get_optional`). The AYANEO Pocket DS wires no discrete enable line to its SY7758, and requiring one left the whole lower DSI chain deferred; boards that do have one are unaffected. The binding patch carries the matching change.
- `patches/0060-dt-bindings-silergy-sy7758.patch`
  source: https://patchwork.kernel.org/project/dri-devel/patch/20260529-topic-sm8650-ayaneo-pocket-s2-sy7758-v5-1-03aacd49747c@linaro.org/
  upstream: https://lore.kernel.org/r/178300990349.2239788.13080024963462152507.b4-ty@b4
  notes: Armada dropped `enable-gpios` from the required list to match the driver change above; the AYANEO Pocket DS reaches its SY7758 without a separately described enable pin.
- `patches/0054-regulator-add-sgm3804-i2c-regulator-for-panel-power-.patch`
  source: armada
  upstream: local
  notes: Armada adds compatibility for existing flat fixed-5-V nodes; child-regulator nodes use the Linux 7.2 upstream behavior unchanged.
- `patches/0056-backlight-aw99706-enable-hwen-before-chip-id-read.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0056-backlight-aw99706-enable-hwen-before-chip-id-read.patch
  upstream: unknown
- `patches/0057-backlight-aw99706-konkr-cfg7.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0057-backlight-aw99706-konkr-cfg7.patch
  upstream: unknown
- `patches/0062-backlight-aw99706-honor-blank-power-state.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0062-backlight-aw99706-honor-blank-power-state.patch
  upstream: unknown
- `patches/0015-touchscreen-edt-ft5x06-allow-to-override-input-name.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0015-touchscreen-edt-ft5x06-allow-to-override-input-name.patch
  upstream: https://lore.kernel.org/r/20260409-ft5x06-label-v1-1-21e8a9ae9a60@gmail.com
- `patches/0030-input-rmi4-add-reset-gpio.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0030-input-rmi4-add-reset-gpio.patch
  upstream: https://lore.kernel.org/r/20250210050220.634497-2-felix@kaechele.ca
- `patches/0032-rmi4-silence-spam-irq-errors.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0032-rmi4-silence-spam-irq-errors.patch
  upstream: unknown
- `patches/0053-add-hynitron-touchscreen.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0053-add-hynitron-touchscreen.patch.disabled
  upstream: unknown
  notes: Armada retains this disabled ROCKNIX driver for the Pocket DMG and refreshed only its Makefile context for Linux 7.1's Himax entry; driver behavior is unchanged.
- `patches/0053a-input-hynitron-port-to-gpiod.patch`
  source: armada
  upstream: local
  notes: Armada added this follow-up because Linux 7.1 removed the legacy OF GPIO-number API; it ports the retained Hynitron driver to GPIO descriptors.
- `patches/0053b-input-hynitron-restore-gpio-init-order.patch`
  source: armada
  upstream: local
  notes: Armada added this follow-up to preserve the vendor driver's pinctrl, GPIO-direction, power, and reset ordering after the GPIO-descriptor port.
- `patches/0054-input-goodix-override-resolution-from-dt.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0054-input-goodix-override-resolution-from-dt.patch
  upstream: unknown
  notes: Armada replaced ROCKNIX's automatic resolution-mismatch heuristic and hardcoded fallback with explicit `goodix,native-size-x` and `goodix,native-size-y` properties. Scaling is dormant unless a device opts in with both native and standard touchscreen dimensions.
- `patches/0029-Input-edt-ft5x06-add-no_regmap_bulk_read-option.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0029-Input-edt-ft5x06-add-no_regmap_bulk_read-option.patch
  upstream: https://lore.kernel.org/r/20260723-b4-ft5426-v1-3-d4b4e32be042@gmail.com
- `patches/0059_AYN-Odin2-Mini--hynitron--cstxxx.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0059_AYN-Odin2-Mini--hynitron--cstxxx.patch
  upstream: unknown
- `patches/0060-input-touchscreen-add-synaptics-dsx-kconfig.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0060-input-touchscreen-add-synaptics-dsx-kconfig.patch
  upstream: unknown
- `patches/0060-input-touchscreen-add-synaptics-dsx-driver.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0060-input-touchscreen-add-synaptics-dsx-driver.patch
  upstream: unknown
- `patches/0058-input-joystick-add-ayaneo-mcu-joystick.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0058-input-joystick-add-ayaneo-mcu-joystick.patch
  upstream: unknown
- `patches/0069-input-misc-add-konkr-sysbtn-MCU-system-buttons.patch`
  source: https://github.com/ROCKNIX/distribution/blob/024028b4f3fdd139ae1e575efb25914b8f76595d/projects/ROCKNIX/devices/SM8750/patches/linux/0069-input-misc-add-konkr-sysbtn-MCU-system-buttons.patch
  upstream: unknown
  notes: Updated to ROCKNIX #3089, which adds the MCU-rendered stick lighting effects (sysfs "effect": static/breath/rainbow) and fixes the PM notifier to replay the active lighting mode after resume instead of only the last static colour.
- `patches/0031_input--Add-driver-for-RSInput-Gamepad.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0031_input--Add-driver-for-RSInput-Gamepad.patch
  upstream: unknown
- `patches/1004-input-rsinput-suspend-resume-gamepad-mcu.patch`
  source: https://github.com/ROCKNIX/distribution/blob/d9b27e08df7c3c35635a7ff405efeab22207df5a/projects/ROCKNIX/devices/SM8550/patches/linux/1004-input-rsinput-suspend-resume-gamepad-mcu.patch
  upstream: unknown
  notes: Replaces the resume-only SM8750 patch with ROCKNIX's combined SM8550 suspend/resume implementation. `1028` limits MCU power-down to board nodes that opt in; resume reinitialization remains shared. #SM8550_SLEEP
- `patches/0504-Enable-64-bit-processes-to-use-compat-input-syscalls.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0504-Enable-64-bit-processes-to-use-compat-input-syscalls.patch
  upstream: unknown
  notes: Armada rebased the unchanged compat-input prctl behavior onto Linux 7.1's current task-structure, UAPI, and prctl switch layout.
- `patches/0506-usbcore-add-interrupt-interval-override.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0506-usbcore-add-interrupt-interval-override.patch
  upstream: unknown
- `patches/0071-HACK-fix-usb-boot-hang.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0071-HACK-fix-usb-boot-hang.patch
  upstream: unknown
  notes: ROCKNIX carries this workaround in its SM8550 and SM8650 kernels. Armada preserves the normal xHCI readiness handshake on every other SoC.
- `patches/1000-input-misc-qcom-hv-haptics-sm8750.patch`
  source: https://github.com/ROCKNIX/distribution/blob/47e077d0bbc714abb05afea6b68144b6f28ee19a/projects/ROCKNIX/devices/SM8750/patches/linux/1000-input-misc-qcom-hv-haptics-sm8750.patch
  upstream: unknown
- `patches/1001-input-qcom-haptics-update-assign-str.patch`
  source: armada
  upstream: local
  notes: Armada updates the vendored driver for Linux 7.1's one-argument `__assign_str()` API.
- `patches/1001-haptics-driver-support-periodic-sine-and-fixes.patch`
  source: https://github.com/ROCKNIX/distribution/blob/47e077d0bbc714abb05afea6b68144b6f28ee19a/projects/ROCKNIX/devices/SM8750/patches/linux/1001-haptics-driver-support-periodic-sine-and-fixes.patch
  upstream: unknown
- `patches/1002-input-rsinput-sm8750-ff.patch`
  source: https://github.com/ROCKNIX/distribution/blob/47e077d0bbc714abb05afea6b68144b6f28ee19a/projects/ROCKNIX/devices/SM8750/patches/linux/1002-input-rsinput-sm8750-ff.patch
  upstream: unknown
  notes: Armada rebased ROCKNIX's force-feedback bridge because its final hunk is malformed and it targets a different RSInput revision. ROCKNIX enables rumble for every RSInput device; Armada gates it with a DT property set only by the supported SM8550 and SM8750 trees that also instantiate the Qualcomm haptics device. The SM8550 common tree intentionally covers both AYN and Retroid products.
- `patches/1003-input-haptics-fix-rumble-bridge-atomic-sleep.patch`
  source: armada
  upstream: local
  notes: The imported bridge called the haptics driver's sleeping upload, playback, and erase callbacks under spin_lock_irq, which emitted "BUG: scheduling while atomic" on every rumble stop and intermittently hard-locked the Odin 3 (reproduced on hardware). The bridge now serializes with a mutex and is process-context only, RSInput defers its atomic playback callback to a work item, and the haptics suspend path cancels the pending stop and set-gain workers so they cannot fire into resume. This generic patch owns RSInput's PM callbacks: pending rumble work is always canceled on suspend and MCU initialization remains unconditional on resume. The tagged SM8550 patch only extends suspend with the opt-in MCU power-down, so removing the sleep stack does not break patch application or regress Odin 3 PM behavior. ROCKNIX carries the identical bug as of 2026-08-04; worth upstreaming once soak-tested.
- `patches/1004-input-haptics-stop-zero-amplitude-immediately.patch`
  source: armada
  upstream: local
  notes: The imported periodic-sine compatibility patch changed zero-amplitude updates to gain 1, then stopped the motor five seconds later. The configured brake pattern made that stop a distinct delayed tap. Zero-amplitude updates now erase immediately, a following playback request cannot restart stale motor state when no effect is loaded, and in-place gain updates balance their transient runtime-PM reference.
- `patches/1300-input-rsinput-axis-deadzone.patch`
  source: armada
  upstream: local
  notes: Armada replaced ROCKNIX's global experimental Odin 3 range and deadzone defaults with a per-device `axis-deadzone` property. The Odin 3 DTS supplies its range and deadzone explicitly.
- `patches/0059-ASoC-aw88395-lib-skip-monitor-sections-in-V1-ACF-parse.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0059-ASoC-aw88395-lib-skip-monitor-sections-in-V1-ACF-parse.patch
  upstream: unknown
- `patches/0063-ASoC-wcd939x-route-usbss-on-integrated-jack-insert.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0063-ASoC-wcd939x-route-usbss-on-integrated-jack-insert.patch
  upstream: unknown
- `patches/0064-ASoC-wcd-mbhc-clear-stale-jack-report-on-mechanical-removal.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0064-ASoC-wcd-mbhc-clear-stale-jack-report-on-mechanical-removal.patch
  upstream: unknown
- `patches/0036_ASoC--qcom--sc8280xp-Add-support-for-Primary-I2S.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0036_ASoC--qcom--sc8280xp-Add-support-for-Primary-I2S.patch
  upstream: https://lore.kernel.org/r/20251008-topic-sm8x50-next-hdk-i2s-v2-3-6b7d38d4ad5e@linaro.org
- `patches/0032-ASoC-codecs-aw88166-AYN-Products-Specific-modificati.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0032-ASoC-codecs-aw88166-AYN-Products-Specific-modificati.patch
  upstream: unknown
- `patches/0030-leds-Add-driver-for-HEROIC-HTR3212.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0030-leds-Add-driver-for-HEROIC-HTR3212.patch
  upstream: unknown
- `patches/0054_sn3112-pwm-driver.patch`
  source: https://github.com/ROCKNIX/distribution/blob/4609c5017f350e6e2307ec909e328454d5bec062/projects/ROCKNIX/devices/SM8550/patches/linux/0054_sn3112-pwm-driver.patch
  upstream: https://lore.kernel.org/r/20240424-ayn-odin2-initial-v1-2-e0aa05c991fd@gmail.com
  notes: Includes ROCKNIX #3110's fix for the arm64 probe crash: set_bit()/clear_bit() on a cast uint8_t[3] alignment-faults under LSE atomics, replaced with plain bitwise ops under priv->lock. The matching Odin 2 DTS change re-enables the sn3112 nodes that were disabled to dodge the crash.
- `patches/20260424_neil_armstrong_arm64_dts_qcom_sm8_456_50_add_missing_cx_power_domain_to_gcc.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/20260424_neil_armstrong_arm64_dts_qcom_sm8_456_50_add_missing_cx_power_domain_to_gcc.patch
  upstream: https://lore.kernel.org/r/20260615-topic-sm8x50-tie-gcc-to-cx-v2-0-6b5752dd4747@linaro.org
- `patches/v9_20260729_qualcomm_crypto_qce_runtime_pm_interconnect.patch`
  source: https://lore.kernel.org/r/20260729110455.641256-1-kuldeep.singh@oss.qualcomm.com
  upstream: https://lore.kernel.org/r/20260729110455.641256-1-kuldeep.singh@oss.qualcomm.com
  notes: Armada replaced ROCKNIX's defective older import with the proposed v9 patch and refreshed only its include context for Linux 7.2; runtime-PM and interconnect behavior is unchanged.
- `patches/0504-wakeup-qcom-ipcc-remove-IRQF-NO-SUSPEND.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0504-wakeup-qcom-ipcc-remove-IRQF-NO-SUSPEND.patch
  upstream: unknown
  notes: Armada limits ROCKNIX's suspend IRQ change to SM8550 and SM8750, preserving the original flags on other SoCs.
- `patches/0505-msm_gem-lock-before-put_iova_spaces.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0505-msm_gem-lock-before-put_iova_spaces.patch
  upstream: unknown
- `patches/0203-thermal-qcom-tsens-skip-sm8550-uplow-wake-irq.patch`
  source: https://github.com/ROCKNIX/distribution/blob/21e1c0be7c9d4a1fba300ce5a81c06a4f91d537f/projects/ROCKNIX/devices/SM8550/patches/linux/0203-thermal-qcom-tsens-skip-sm8550-uplow-wake-irq.patch
  upstream: unknown
  notes: Ported to Linux 7.2's paired suspend/resume wake-IRQ handling. #SM8550_SLEEP
- `patches/0207-scsi-ufs-qcom-balance-irq-on-host-reset-error.patch`
  source: https://github.com/ROCKNIX/distribution/blob/9fb3c21c3d37345b8741a6d86da7471b6041b024/projects/ROCKNIX/devices/SM8550/patches/linux/0207-scsi-ufs-qcom-balance-irq-on-host-reset-error.patch
  upstream: unknown
  notes: #SM8550_SLEEP
- `patches/1006-tty-serial-qcom-geni-mask-non-console-irq-on-suspend.patch`
  source: https://github.com/ROCKNIX/distribution/blob/aa7d8320421bd44ec5b46b2d852b544fec237c54/projects/ROCKNIX/devices/SM8550/patches/linux/1006-tty-serial-qcom-geni-mask-non-console-irq-on-suspend.patch
  upstream: unknown
  notes: `1028` requires a per-controller DT opt-in and refuses console or wake-capable UARTs; only the SM8550 AYN/Retroid gamepad UART opts in. #SM8550_SLEEP
- `patches/1007-scsi-ufs-qcom-propagate-hibern8-exit-failure-clk-scale.patch`
  source: https://github.com/ROCKNIX/distribution/blob/9fb3c21c3d37345b8741a6d86da7471b6041b024/projects/ROCKNIX/devices/SM8550/patches/linux/1007-scsi-ufs-qcom-propagate-hibern8-exit-failure-clk-scale.patch
  upstream: unknown
  notes: #SM8550_SLEEP
- `patches/1008-scsi-ufs-qcom-auto-hibern8-clk-gating-collision.patch`
  source: https://github.com/ROCKNIX/distribution/blob/9fb3c21c3d37345b8741a6d86da7471b6041b024/projects/ROCKNIX/devices/SM8550/patches/linux/1008-scsi-ufs-qcom-auto-hibern8-clk-gating-collision.patch
  upstream: unknown
  notes: #SM8550_SLEEP
- `patches/1010-scsi-ufs-qcom-keep-mphy-powered-on-hibern8-park.patch`
  source: https://github.com/ROCKNIX/distribution/blob/9fb3c21c3d37345b8741a6d86da7471b6041b024/projects/ROCKNIX/devices/SM8550/patches/linux/1010-scsi-ufs-qcom-keep-mphy-powered-on-hibern8-park.patch
  upstream: unknown
  notes: #SM8550_SLEEP
- `patches/1011-scsi-ufs-hold-clk-gating-across-system-pm.patch`
  source: https://github.com/gh123man/armada-packages/blob/b097724ec20b3f20d31dd4cc291e0d5d9238c491/kernel/patches/1011-scsi-ufs-hold-clk-gating-across-system-pm.patch
  upstream: unknown
  notes: Armada retains the small, balanced fix for a hardware-captured gate-worker/system-PM race and gates both the hold and release to `qcom,sm8550-ufshc`. #SM8550_SLEEP
- `patches/1012-input-edt-ft5x06-retain-power-in-suspend.patch`
  source: https://github.com/thorch-os/thorch/blob/893d10bdae1523612126f051399e9b525ff51286/packages/linux-thorch/patches/0016-input-edt-ft5x06-retain-power-in-suspend.patch
  upstream: unknown
  notes: Adds a board opt-in that keeps a touchscreen powered through system suspend without incorrectly arming its touch IRQ as a wake source. Only AYN Thor's lower FT5452 node opts in, and `1029` ignores that property unless the global native-sleep gate is active. #SM8550_SLEEP
- `patches/1013-soc-qcom-ice-unwind-core-clk-on-iface-clk-fail.patch`
  source: https://github.com/thorch-os/thorch/blob/893d10bdae1523612126f051399e9b525ff51286/packages/linux-thorch/patches/0006-soc-qcom-ice-unwind-core-clk-on-iface-clk-fail.patch
  upstream: unknown
  notes: Error-path fix for Linux 7.1.5's existing SM8550 ICE iface clock and power-domain support. It retains the source patch's core-clock unwind when iface-clock enable fails and adds an Armada follow-up that unwinds both clocks if the subsequent BIST poll times out. #SM8550_SLEEP
- `patches/1015-ufs-qcom-disable-rx-linecfg-after-link-startup.patch`
  source: https://github.com/ROCKNIX/distribution/blob/9fb3c21c3d37345b8741a6d86da7471b6041b024/projects/ROCKNIX/devices/SM8550/patches/linux/1015-ufs-qcom-disable-rx-linecfg-after-link-startup.patch
  upstream: unknown
  notes: Runs Linux 7.2's post-startup helper before disabling RX LineCfg; `1028` scopes the change to SM8550. #SM8550_SLEEP
- `patches/1023-pci-qcom-skip-l23-ready-after-pme-sm8550.patch`
  source: https://github.com/thorch-os/thorch/blob/bf390e3d3be4bbdf6eb22f0a78be009ad07673c3/packages/linux-thorch/patches/0215-PCI-qcom-skip-l23-ready-after-pme-sm8550.patch
  upstream: unknown
  notes: Compatible-scoped and gate-independent because Linux 7.2 uses D3cold by default. #SM8550_SLEEP
- `patches/1026-pci-qcom-use-suspend-opp-for-non-s2ram.patch`
  source: https://github.com/thorch-os/thorch/blob/bf390e3d3be4bbdf6eb22f0a78be009ad07673c3/packages/linux-thorch/patches/0220-PCI-qcom-use-suspend-opp-for-non-s2ram.patch
  upstream: unknown
  notes: Armada preserves the original NULL OPP behavior outside `qcom,pcie-sm8550`. #SM8550_SLEEP
- `patches/1027-arm64-dts-qcom-sm8550-mark-pcie-suspend-opp.patch`
  source: https://github.com/thorch-os/thorch/blob/bf390e3d3be4bbdf6eb22f0a78be009ad07673c3/packages/linux-thorch/patches/0221-arm64-dts-qcom-sm8550-mark-pcie-suspend-opp.patch
  upstream: unknown
  notes: #SM8550_SLEEP
- `patches/1028-armada-scope-sm8550-suspend-workarounds.patch`
  source: armada
  upstream: local
  notes: Scopes downstream UFS, RSInput, and GENI suspend changes to SM8550. #SM8550_SLEEP
- `patches/1029-armada-gate-sm8550-native-sleep-workarounds.patch`
  source: armada
  upstream: local
  notes: Requires `sm8550.ns=1` before enabling the remaining SM8550 workarounds; Linux 7.2's upstream PCI D3cold and UFS core behavior remain unchanged. #SM8550_SLEEP
- `patches/1009-scsi-ufs-recover-hibern8-enter-clk-gating.patch`
  source: https://github.com/gh123man/armada-packages/commit/2275305ddea13abb59f9e428299f8c84dfafc79a
  upstream: unknown
  notes: Ported to Linux 7.2 without the obsolete relink poller; recovery remains limited to the gated SM8550 UFS path. #SM8550_SLEEP
- `patches/1031-revert-clk-regmap-phy-mux-rate-based-rework.patch`
  source: armada
  upstream: revert of https://github.com/torvalds/linux/commit/e108373c54fbc844b7f541c6fd7ecb31772afd3c
  notes: Root-cause carry for the SM8550 Portal wifi regression. The reverted commit (patch 1 of the "phy_fastclk" series) switched the PCIe pipe-clock mux from enable/disable ops to rate-based ops, but the series' consumer patches never merged, so nothing in 7.2-rc7 can switch the mux to the PHY source. Boards handed over with the mux parked on XO (Portal: GCC_PCIE_0_PIPE_CLK_SRC = 0x2 at boot, hardware-read) then run the QMP PHY bring-up on the wrong pipe clock and the WCN7850 link never leaves Detect. Restoring the enable-op contract restores the working 7.1 behavior. Drop when upstream lands the consumer side or reverts the rework.
- `patches/0001-pcie-update-sm8550-dtsi.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0001-pcie-update-sm8550-dtsi.patch
  upstream: https://lore.kernel.org/r/20260611-wake-v2-33-2744251b1181@oss.qualcomm.com
- `patches/0120-20250728_konradybcio_gpu_cc_power_requirements_reality_check.patch`
  source: https://github.com/ROCKNIX/distribution/blob/ef264a238d5e2ba960145e3fda663dc27de49a80/projects/ROCKNIX/devices/SM8550/patches/linux/0120-20250728_konradybcio_gpu_cc_power_requirements_reality_check.patch
  upstream: https://lore.kernel.org/r/20250728-topic-gpucc_power_plumbing-v1-22-09c2480fe3e6@oss.qualcomm.com
- `patches/0121-pmdomain-qcom-rpmhpd-presync-floor-gmu-rails.patch`
  source: https://github.com/ROCKNIX/distribution/blob/ef264a238d5e2ba960145e3fda663dc27de49a80/projects/ROCKNIX/devices/SM8550/patches/linux/0121-pmdomain-qcom-rpmhpd-presync-floor-gmu-rails.patch
  source: https://github.com/ROCKNIX/distribution/blob/ef264a238d5e2ba960145e3fda663dc27de49a80/projects/ROCKNIX/devices/SM8750/patches/linux/0052-pmdomain-qcom-rpmhpd-presync-floor-gmu-rails.patch
  upstream: unknown
  notes: Armada applies the presync_floor and skip_retention_level flags via private descriptors (gfx_gmu for SM8550+SM8750, gmxc_sm8750) so GMU rail pre-sync behavior cannot change on other SoCs; ROCKNIX instead flags the shared gfx/gmxc structs, which would leak onto every SoC sharing them in a combined kernel. SM8250 and SM8650 have no Linux-side voter on these rails (their gpucc/gmu nodes reference only gpucc GDSCs), so the flags would be inert there today; revisit the scoping if the upstream gpucc power plumbing series lands and adds voters on more SoCs.
- `patches/0122-interconnect__qcom__sm8550__Enable_QoS_configuration.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0122-interconnect__qcom__sm8550__Enable_QoS_configuration.patch
  upstream: unknown
- `patches/0200-ASoC-wcd938x-add-DMIC-DAPM-inputs.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0200-ASoC-wcd938x-add-DMIC-DAPM-inputs.patch
  upstream: unknown
- `patches/0500-ROCKNIX-set-boot-fanspeed.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0500-ROCKNIX-set-boot-fanspeed.patch
  upstream: unknown
- `patches/0501-ROCKNIX-fix-wifi-and-bt-mac.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0501-ROCKNIX-fix-wifi-and-bt-mac.patch
  upstream: unknown
  notes: Armada refreshed only the ath12k insertion context for Linux 7.1's rate-table macros; MAC derivation behavior is unchanged.
- `patches/0503-ROCKNIX-battery-name.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0503-ROCKNIX-battery-name.patch
  upstream: unknown
- `patches/0900-power-supply-qcom-battmgr-log-usb-adapter-type.patch`
  source: armada
  upstream: local
  notes: Armada wrote this diagnostic patch to log the USB type and Qualcomm firmware's adapter type when either value changes.
- `patches/0001-pcie-update-sm8650-dtsi.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8650/patches/linux/0001-pcie-update-sm8650-dtsi.patch
  upstream: https://lore.kernel.org/r/20260611-wake-v2-35-2744251b1181@oss.qualcomm.com
- `patches/0006-add-hw_params-callback-function-to-drm_connector_hdmi_audio_ops.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0006-add-hw_params-callback-function-to-drm_connector_hdmi_audio_ops.patch
  upstream: https://lore.kernel.org/r/20250925040530.20731-1-liujianfeng1994@gmail.com
- `patches/0007-ASoC-qcom-audioreach-compute-active-channel-maps.patch`
  source: https://lore.kernel.org/r/20260728-topic-sm8650-ayaneo-pocket-s2-wsa2-fix-v3-1-b29f44720178@linaro.org
  upstream: https://lore.kernel.org/r/178550094533.136247.8108653420741029312.b4-ty@b4
- `patches/0008-ASoC-dt-bindings-qcom-sm8250-Add-Ayaneo-Pocket-S2.patch`
  source: https://lore.kernel.org/r/20260728-topic-sm8650-ayaneo-pocket-s2-wsa2-fix-v3-2-b29f44720178@linaro.org
  upstream: https://lore.kernel.org/r/178550094533.136247.8108653420741029312.b4-ty@b4
- `patches/0009-ASoC-qcom-sc8280xp-add-Ayaneo-Pocket-S2-card.patch`
  source: https://lore.kernel.org/r/20260728-topic-sm8650-ayaneo-pocket-s2-wsa2-fix-v3-3-b29f44720178@linaro.org
  upstream: https://lore.kernel.org/r/178550094533.136247.8108653420741029312.b4-ty@b4
  notes: Backported to Armada's Linux 7.2 machine-driver layout; the accepted WSA2 channel map and constraints are unchanged.
- `patches/0010-ASoC-qcom-add-KONKR-Pocket-FIT-WSA2-card.patch`
  source: armada
  upstream: local
  notes: Pocket FIT uses the same WSA2-only speaker wiring as Pocket S2. Armada adds a board-specific compatible backed by the accepted Pocket S2 channel mapping.
- `patches/0011-ASoC-qcom-audioreach-use-wsa-interface-for-sm8650-wsa2.patch`
  source: armada
  upstream: local
  notes: Restores the WSA2-to-WSA interface rewrite that ROCKNIX bundled inside its replaced channel-map workaround; the SM8650 topology declares the speaker backend as WSA2, which the shipped ADSP firmware rejects. Gated to `qcom,sm8650`; remove once a corrected topology stops declaring WSA2.
- `patches/v2_20260420_neil_armstrong_arm64_qcom_sm8650_misc_enhancements.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8650/patches/linux/v2_20260420_neil_armstrong_arm64_qcom_sm8650_misc_enhancements.patch
  upstream: https://lore.kernel.org/r/20260615-topic-sm8650-upstream-cpu-props-v3-0-eeb6e9fa7581@linaro.org
- `patches/0063-gpu-drm-panel-add-pocket-fit-panel.patch`
  source: https://github.com/ROCKNIX/distribution/blob/5cff2f7918ca6bd56d8a884f0837309529a058bc/projects/ROCKNIX/devices/SM8750/patches/linux/0055-gpu-drm-panel-add-pocket-fit-panel.patch
  upstream: unknown
  notes: Uses the four-mode SM8750 variant and Linux 7.2's managed DRM panel allocator.
- `patches/0064-input-touchscreen-add-rocknix-chipone-tddi.patch`
  source: https://github.com/ROCKNIX/chipone_tddi/commit/af27029fa2b27c4a77d16809298ed5d03c9da5a6
  upstream: unknown
  notes: ROCKNIX ships this full driver as an out-of-tree module for the SM8650 KONKR Pocket FIT. Armada converts the pinned fork to an in-tree patch; its C and header files are unchanged, while Kconfig and Kbuild are adapted for the combined kernel. The fork includes ROCKNIX's Linux 7.1 GPIO compatibility update.
- `patches/0014-sm8250-ath11k-fix-wifi-mac.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0014-fix-wifi-and-bt-mac.patch
  upstream: unknown
  notes: Armada carries only the ath11k portion of the shared ROCKNIX patch; the Bluetooth and SoC-serial changes are supplied by `0501-ROCKNIX-fix-wifi-and-bt-mac.patch`.
- `patches/0004-pm8150b.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0004-pm8150b.patch
  upstream: unknown
- `patches/0009-qcom-spmi-haptics.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0009-qcom-spmi-haptics.patch
  upstream: unknown
  notes: Armada refreshed only the Kconfig insertion context so the SM8250 haptics driver follows Linux 7.1's high-voltage haptics entry; driver behavior is unchanged.
- `patches/0008-retroid-gamepad.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0008-retroid-gamepad.patch
  upstream: unknown
- `patches/0013-add-force-feedback.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0013-add-force-feedback.patch
  upstream: unknown
- `patches/0011-qcom-pm8150b-charger.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0011-qcom-pm8150b-charger.patch
  upstream: unknown
  notes: Armada refreshed only the Makefile context for Linux 7.2's expanded Surface power-supply entries; charger and fuel-gauge behavior is unchanged.
- `patches/0005-sm8250-uart.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0005-sm8250-uart.patch
  upstream: unknown
- `patches/9998-sm8250-gpu-tuning.patch`
  source: https://github.com/ROCKNIX/distribution/blob/f3e2b6187cd2ae2dc5122edfebe84228a314f2c5/projects/ROCKNIX/devices/SM8250/patches/linux/9998-gpu-tuning.patch
  upstream: unknown
  notes: Contents are verbatim; Armada renamed the file from the ROCKNIX `9998-gpu-tuning.patch`.
- `patches/0001-msm-dsi-restore-wide_bus-bpp-calculation.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0001-msm-dsi-restore-wide_bus-bpp-calculation.patch
  upstream: unknown
  notes: Armada limited the ROCKNIX change to SM8250 so it does not alter the shared DSI path on other supported SoCs.
- `patches/0012-ASoC-qcom-q6asm-dai-Change-some-default-periods.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0012-ASoC-qcom-q6asm-dai-Change-some-default-periods.patch
  upstream: unknown
- `patches/0062_wsa881x-shared-powerdown-gpio.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0062_wsa881x-shared-powerdown-gpio.patch
  upstream: unknown
  notes: Ported to Linux 7.2's `GPIOD_OUT_LOW` initialization while retaining the non-exclusive request needed by boards whose two amplifiers share one powerdown GPIO.
- `patches/0100-revert-force-16bit-audio.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0100-revert-force-16bit-audio.patch
  upstream: unknown
- `patches/0300-batocera-fix-headphone-jack-detection.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0300-batocera-fix-headphone-jack-detection.patch
  upstream: unknown
  notes: Armada limited the ROCKNIX headphone-jack workaround to SM8250 so it does not alter shared codec behavior on other supported SoCs.
- `patches/0102-arm64-dts-qcom-pm8150-Add-nvmem-support-for-PM8150-R.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/0102-arm64-dts-qcom-pm8150-Add-nvmem-support-for-PM8150-R.patch
  upstream: unknown
- `patches/9999-sm8250-disable-coresight-stm.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/patches/linux/9999-remove-log-spam.patch
  upstream: unknown
  notes: Armada carries only the ROCKNIX device-tree change that disables CoreSight STM and omits the broader log-suppression changes from the source patch.
- `patches/0026-dt-bindings-arm-qcom-ids-Add-SoC-ID-for-CQ8725S.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0026-dt-bindings-arm-qcom-ids-Add-SoC-ID-for-CQ8725S.patch
  upstream: https://lore.kernel.org/r/20260605-cq8725s-soc-id-v1-1-bb1ef93de649@gmail.com
- `patches/0027-soc-qcom-socinfo-Add-CQ8725S-SoC-ID.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0027-soc-qcom-socinfo-Add-CQ8725S-SoC-ID.patch
  upstream: https://lore.kernel.org/r/20260605-cq8725s-soc-id-v1-2-bb1ef93de649@gmail.com
- `patches/0034-arm64-dts-qcom-sm8750-Add-UART15.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0034-arm64-dts-qcom-sm8750-Add-UART15.patch
  upstream: https://lore.kernel.org/r/20260605-sm8750-uart15-v1-1-93e660722e61@gmail.com
- `patches/0033-arm64-dts-qcom-sm8750-gpu-clock-controllers.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0033-arm64-dts-qcom-sm8750-gpu-clock-controllers.patch
  upstream: https://lore.kernel.org/r/20260714-gpucc_dt_v6-v6-1-16bf5289572d@oss.qualcomm.com
- `patches/0038-arm64-dts-qcom-sm8750-add-GPU-nodes.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0038-arm64-dts-qcom-sm8750-add-GPU-nodes.patch
  upstream: unknown
- `patches/0038a-arm64-dts-qcom-sm8750-map-A8xx-RSCC-registers.patch`
  source: armada
  upstream: local
  notes: Armada expands the SM8750 GPU register mapping to `0x6c000` so Linux 7.1's A8xx recovery path can access RSCC at GPU offset `0x50000` without faulting.
- `patches/0035-arm64-dts-qcom-sm8750-set-CPU-capacity-dmips-mhz.patch`
  source: https://github.com/ROCKNIX/distribution/blob/f3e2b6187cd2ae2dc5122edfebe84228a314f2c5/projects/ROCKNIX/devices/SM8750/patches/linux/0076-arm64-dts-qcom-sm8750-set-CPU-capacity-dmips-mhz.patch
  upstream: unknown
- `patches/0037-arm64-dts-qcom-sm8750-add-CPU-thermal-cooling.patch`
  source: https://github.com/ROCKNIX/distribution/blob/b1e9d07b251c5a013d303a518106c547db001b74/projects/ROCKNIX/devices/SM8750/patches/linux/0075-arm64-dts-qcom-sm8750-add-CPU-thermal-cooling.patch
  upstream: unknown
  notes: Linux 7.2 supplies the CPU cooling-cell properties; Armada retains the missing passive trips and cooling maps.
- `patches/0049-drm-msm-a8xx-add-adreno-830-catalog.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0049-drm-msm-a8xx-add-adreno-830-catalog.patch
  upstream: unknown
- `patches/0050-clk-qcom-gxclkctl-kaanapali-fix-gx-gdsc-collapse.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0050-clk-qcom-gxclkctl-kaanapali-fix-gx-gdsc-collapse.patch
  upstream: https://lore.kernel.org/r/20260427-gfx-clk-fixes-v2-2-797e54b3d464@oss.qualcomm.com
- `patches/0039-wifi-ath12k-add-initial-hardware-definition-for-WCN7.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0039-wifi-ath12k-add-initial-hardware-definition-for-WCN7.patch
  upstream: unknown
  notes: Armada refreshed only the hardware-parameter insertion context for Linux 7.2's expanded IPQ5332 entry; WCN7860 behavior is unchanged.
- `patches/0040-wifi-ath12k-send-QDSS-config-when-CNSS_QDSS_CFG_MISS.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0040-wifi-ath12k-send-QDSS-config-when-CNSS_QDSS_CFG_MISS.patch
  upstream: unknown
- `patches/0041-wifi-ath12k-disable-CNSS_QDSS_CFG_MISS_V01-for-the-W.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0041-wifi-ath12k-disable-CNSS_QDSS_CFG_MISS_V01-for-the-W.patch
  upstream: unknown
- `patches/0042-PCI-pwrctrl-pwrseq-add-support-for-WCN7860.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0042-PCI-pwrctrl-pwrseq-add-support-for-WCN7860.patch
  upstream: unknown
- `patches/0043-power-sequencing-qcom-wcn-add-support-for-WCN7860.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0043-power-sequencing-qcom-wcn-add-support-for-WCN7860.patch
  upstream: unknown
- `patches/0044-clk-qcom-gcc-sm8750-Do-not-turn-off-PCIe-GDSCs-durin.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0044-clk-qcom-gcc-sm8750-Do-not-turn-off-PCIe-GDSCs-durin.patch
  upstream: https://lore.kernel.org/r/20260102-pci_gdsc_fix-v1-3-b17ed3d175bc@oss.qualcomm.com
- `patches/0045-Bluetooth-qca-add-WCN7860-support.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0045-Bluetooth-qca-add-WCN7860-support.patch
  upstream: unknown
  notes: Armada rebased ROCKNIX's WCN7860 additions onto Linux 7.1 after upstream restructured the QCA Bluetooth switch cases and renamed the power-off helper.
- `patches/0066-scsi-ufs-ufs-qcom-add-sm8750-compatible.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0066-scsi-ufs-ufs-qcom-add-sm8750-compatible.patch
  upstream: unknown
- `patches/0509-soc-qcom-pmic_glink_altmode-defer-until-mux-switch-ready.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0509-soc-qcom-pmic_glink_altmode-defer-until-mux-switch-ready.patch
  upstream: unknown
  notes: Armada gates both deferrals on `qcom,sm8750`. ROCKNIX runs this only in its SM8750 kernel, where the mode-switch supplier registers late. Boards that declare no mode-switch at all (the AYANEO SM8550 family) would defer forever, which blocks the DP aux bridges, keeps the msm DRM aggregate from binding, and leaves the internal panel dark. Hardware-confirmed on the Pocket EVO. With `0517`, a declared-but-late provider already returns `-EPROBE_DEFER` through the `IS_ERR()` path ahead of these NULL checks, so the gated checks are ROCKNIX's SM8750 fallback on top of that distinction rather than the primary defer mechanism.
- `patches/0519-usb-typec-ucsi-clear-USB-role.patch`
  source: https://github.com/ROCKNIX/distribution/commit/c9629c95a5655dcfb68e8f3aaf75f9967a9e9656
  upstream: unknown
  notes: ROCKNIX's charger-only regression fix is hardware-validated on Armada's SM8750 Odin 3. Armada corrects its condition so non-quirk platforms restore the pre-regression behavior while X1E80100 still treats reported USB4 Gen 3/4 as implying USB data support.
- `patches/0520-usb-typec-ucsi-quiesce-sm8550-role-on-suspend.patch`
  source: https://github.com/ROCKNIX/distribution/pull/3049
  upstream: unknown
  notes: Armada adds failure handling and notifier/connector lifecycle serialization; the SM8550 quirk is intentionally active independently of `sm8550.ns`. #SM8550_SLEEP
- `patches/0517-usb-typec-mux-dont-swallow-EPROBE_DEFER.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0517-usb-typec-mux-dont-swallow-EPROBE_DEFER.patch
  upstream: unknown
  notes: Armada rebased the ROCKNIX fix onto Linux 7.1.5, preserving its `-EPROBE_DEFER` handling and adapting it to the new duplicate-filter arrays.
- `patches/0603-ASoC-codecs-wcd939x-keep-the-codec-resumed-while-a-ja.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0603-ASoC-codecs-wcd939x-keep-the-codec-resumed-while-a-ja.patch
  upstream: unknown
- `patches/0060-ASoC-qcom-sc8280xp-enable-MI2S-bit-clock-on-BE-startup.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0060-ASoC-qcom-sc8280xp-enable-MI2S-bit-clock-on-BE-startup.patch
  upstream: unknown
  notes: Armada combined ROCKNIX's SM8750 clock-reference fix with Armada's Primary-MI2S clock handling while rebasing the shared driver onto Linux 7.1.
- `patches/0072-ASoC-lpass-rx-macro-add-HPH-PCM-mode.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0072-ASoC-lpass-rx-macro-add-HPH-PCM-mode.patch
  upstream: unknown
- `patches/0073-ASoC-wcd939x-add-HPH-PCM-HiFi-mode.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0073-ASoC-wcd939x-add-HPH-PCM-HiFi-mode.patch
  upstream: unknown
- `patches/0074-soundwire-qcom-PCM-data-port-format-enable.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0074-soundwire-qcom-PCM-data-port-format-enable.patch
  upstream: unknown
- `patches/0612-ROCKNIX-odin3-q6apm-start-mi2s-port-at-prepare.patch`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/patches/linux/0612-ROCKNIX-odin3-q6apm-start-mi2s-port-at-prepare.patch
  upstream: unknown
- `patches/0613-ASoC-q6apm-scope-prepare-start-to-MI2S.patch`
  source: armada
  upstream: local
  notes: Armada added this follow-up to limit `0612` to playback MI2S DAIs; without it, the ROCKNIX change would affect every playback DAI using the shared q6apm driver.

- `dts/qcs8550-ayaneo-pocketace.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pocketace.dts
- `dts/qcs8550-ayaneo-pocket-common.dtsi`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pocket-common.dtsi
- `dts/qcs8550-ayaneo-pocketdmg.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pocketdmg.dts
- `dts/qcs8550-ayaneo-pocketds.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pocketds.dts
- `dts/qcs8550-ayaneo-pocketevo.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pocketevo.dts
- `dts/qcs8550-ayaneo-pockets2k.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayaneo-pockets2k.dts
- `dts/qcs8550-ayn-common.dtsi`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayn-common.dtsi
- `dts/qcs8550-ayn-odin2.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayn-odin2.dts
- `dts/qcs8550-ayn-odin2mini.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayn-odin2mini.dts
- `dts/qcs8550-ayn-odin2portal.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayn-odin2portal.dts
- `dts/qcs8550-ayn-thor.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-ayn-thor.dts
- `dts/qcs8550-retroidpocket-rp6.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-retroidpocket-rp6.dts
- `dts/qcs8550-retroidpocket-rp6-top-dpad.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-retroidpocket-rp6-top-dpad.dts
- `dts/qcs8550-retroidpocket-rpnova.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8550/linux/dts/qcom/qcs8550-retroidpocket-rpnova.dts
- `dts/sm8650-ayaneo-common.dtsi`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8650/linux/dts/qcom/sm8650-ayaneo-common.dtsi
- `dts/sm8650-ayaneo-ps2.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8650/linux/dts/qcom/sm8650-ayaneo-ps2.dts
- `dts/sm8650-konkr-pf.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8650/linux/dts/qcom/sm8650-konkr-pf.dts
- `dts/sm8250-retroidpocket-common.dtsi`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/linux/dts/qcom/sm8250-retroidpocket-common.dtsi
- `dts/sm8250-retroidpocket-flip2.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/linux/dts/qcom/sm8250-retroidpocket-flip2.dts
- `dts/sm8250-retroidpocket-rp5.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/linux/dts/qcom/sm8250-retroidpocket-rp5.dts
- `dts/sm8250-retroidpocket-rpmini.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/linux/dts/qcom/sm8250-retroidpocket-rpmini.dts
- `dts/sm8250-retroidpocket-rpminiv2.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8250/linux/dts/qcom/sm8250-retroidpocket-rpminiv2.dts
- `dts/sm8750-konkr-pf-elite.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/linux/dts/qcom/sm8750-konkr-pf-elite.dts
- `dts/sm8750-konkr-pf-elite.dts.patch`
  source: armada
  notes: Armada adapts the Elite touchscreen node to the full ROCKNIX Chipone fork shared with the SM8650 Pocket FIT; the driver is selected only by those two device-tree nodes.
- `dts/cq8725s-ayn-common.dtsi`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0046-arm64-dts-qcom-Add-AYN-CQ8725S-Common.patch
  notes: Armada extracted this DTS from the cited ROCKNIX patch and then applied later ROCKNIX DTS updates, including the Odin 3 haptics nodes from ROCKNIX commit `81a31e3d0f`.
- `dts/cq8725s-ayn-odin3.dts`
  source: https://github.com/ROCKNIX/distribution/blob/bcf3b5bc574990b96543484575b06f912153a715/projects/ROCKNIX/devices/SM8750/patches/linux/0047-arm64-dts-qcom-Add-AYN-Odin3.patch
  notes: Armada extracted this DTS from the cited ROCKNIX patch and then applied later ROCKNIX DTS updates.
- `dts/cq8725s-ayn-odin3.dts.patch`
  source: armada
  notes: Armada enables DPU dithering after copying `dts/cq8725s-ayn-odin3.dts`.
- `dts/cq8725s-ayn-common.dtsi.patch`
  source: armada
  notes: Armada marks Odin 3's RSInput node as connected to the Qualcomm haptics device and supplies the device's 1024 range and 70-count axis deadzone.
- `dts/qcs8550-ayaneo-pocket-common.dtsi.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/qcs8550-ayaneo-pocket-common.dtsi`.
- `dts/qcs8550-ayaneo-pocketace.dts.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/qcs8550-ayaneo-pocketace.dts`.
- `dts/qcs8550-ayaneo-pocketdmg.dts.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/qcs8550-ayaneo-pocketdmg.dts`.
- `dts/qcs8550-ayaneo-pockets2k.dts.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/qcs8550-ayaneo-pockets2k.dts`.
- `dts/qcs8550-ayaneo-pocketds.dts.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/qcs8550-ayaneo-pocketds.dts`. It moves the lower panel onto the ST7703 driver contract: `vcc-supply` for the SGM3804 charge pump, and the former `enable-gpio` on TCA6408 GPIO0 re-modeled as a fixed regulator consumed as `iovcc-supply`.
- `dts/qcs8550-ayn-common.dtsi.patch`
  source: armada
  notes: Corrects PCIe WAKE# polarity, removes the SDHCI capability mask, and adds GENI/RSInput suspend properties. #SM8550_SLEEP
- `dts/qcs8550-retroidpocket-rp6.dts.patch`
  source: armada
  notes: Armada switches Pocket 6 from ROCKNIX's Odin 2 fallback to audio firmware extracted from a Pocket 6 vendor image.
- `dts/qcs8550-ayn-thor.dts.patch`
  source: armada
  notes: Armada fixes the hall-sensor pinctrl and touch orientation after copying `dts/qcs8550-ayn-thor.dts`, and opts the lower FT5452 touchscreen into retained power during system suspend. #SM8550_SLEEP
- `dts/sm8650-ayaneo-common.dtsi.patch`
  source: armada
  notes: Armada applies this local patch after copying `dts/sm8650-ayaneo-common.dtsi`.
- `dts/sm8650-ayaneo-ps2.dts.patch`
  source: armada
  notes: Armada selects the accepted Pocket S2 WSA2 sound-card mapping after copying the ROCKNIX DTS.
- `dts/sm8650-konkr-pf.dts.patch`
  source: armada
  notes: Armada selects the shared WSA2 channel mapping through a Pocket FIT-specific sound-card compatible.
