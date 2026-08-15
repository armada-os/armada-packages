# Patches

Patches applied on top of BASE.env. Each entry's `source` is an upstream URL pinned
to a commit, or `armada` if it's original; a URL source with no `notes` is verbatim.
`notes` mean the file was modified.

- `patches/0001-DRMBackend-Add-GAMESCOPE_FAKE_OUTPUT_MM-env-to-set-c.patch`
  source: https://github.com/ROCKNIX/distribution/blob/ff40ff1897fa5687bc0e50103e50acc9cd90d7d3/projects/ROCKNIX/packages/apps/gamescope/patches/0004-DRMBackend-Add-GAMESCOPE_FAKE_OUTPUT_MM-env-to-set-c.patch
- `patches/0002-steamcompmgr-fix-gamepad-cursor-sprite-frozen-via-XTest.patch`
  source: https://github.com/ROCKNIX/distribution/blob/e108ad2b8971b4e332d7457b75dd21dadb666d19/projects/ROCKNIX/packages/apps/gamescope/patches/0006-steamcompmgr-fix-gamepad-cursor-sprite-frozen-via-XTest.patch
- `patches/0003-steamcompmgr-fallback-appid-focus.patch`
  source: armada
- `patches/0004-drm-synthesize-edid-for-edidless-internal-panels.patch`
  source: armada
- `patches/0005-drm-support-known-display-profiles-for-edidless-panels.patch`
  source: armada
- `patches/0006-drm-compose-gamma22-hdr-without-hardware-color-management.patch`
  source: armada
- `patches/0007-wsi-filter-hdr-formats-by-underlying-support.patch`
  source: armada
- `patches/0008-color-scale-sdr-white-on-gamma22-hdr-output.patch`
  source: armada
- `patches/0009-expose-client-sampleable-formats.patch`
  source: armada
- `patches/0010-fix-arm64-steam-night-mode.patch`
  source: armada
- `patches/0011-main-add-opt-in-force-vulkan-realtime.patch`
  source: armada
- `patches/0012-color-scale-gamma22-sdr-white-only-with-hdr-content.patch`
  source: armada
