# Patches

Patches applied on top of BASE.env. Each entry's `source` is an upstream URL pinned
to a commit, or `armada` if it's original; a URL source with no `notes` is verbatim.
`notes` mean the file was modified.

- `patches/0001-cstdint.patch`
  source: https://src.fedoraproject.org/rpms/gamescope/blob/cc1a9bd6aad3992a1bdaff27219efc1744478d8c/f/0001-cstdint.patch
- `patches/Allow-to-use-system-wlroots.patch`
  source: https://src.fedoraproject.org/rpms/gamescope/blob/5566fcac324cb909fd49a2323816deefc445a5fa/f/Allow-to-use-system-wlroots.patch
- `patches/Use-system-stb-glm.patch`
  source: https://src.fedoraproject.org/rpms/gamescope/blob/b5a75d544d1f314ef0d86c4dc9142b1de62e1b8e/f/Use-system-stb-glm.patch
- `patches/0004-DRMBackend-Add-GAMESCOPE_FAKE_OUTPUT_MM-env-to-set-c.patch`
  source: https://github.com/ROCKNIX/distribution/blob/ff40ff1897fa5687bc0e50103e50acc9cd90d7d3/projects/ROCKNIX/packages/apps/gamescope/patches/0004-DRMBackend-Add-GAMESCOPE_FAKE_OUTPUT_MM-env-to-set-c.patch
- `patches/0005-feature-add-rotation-shader-for-rotating-output.patch`
  source: https://github.com/ROCKNIX/distribution/blob/d5991e155a1941c248c8bcb9b364723eec75fc61/projects/ROCKNIX/packages/apps/gamescope/patches/0005-feature-add-rotation-shader-for-rotating-output.patch
- `patches/0006-steamcompmgr-fix-gamepad-cursor-sprite-frozen-via-XTest.patch`
  source: https://github.com/ROCKNIX/distribution/blob/e108ad2b8971b4e332d7457b75dd21dadb666d19/projects/ROCKNIX/packages/apps/gamescope/patches/0006-steamcompmgr-fix-gamepad-cursor-sprite-frozen-via-XTest.patch
- `patches/0007-steamcompmgr-fallback-appid-focus.patch`
  source: armada
- `patches/0008-drm-allow-explicit-edidless-internal-panel-profiles.patch`
  source: armada
  notes: Requires an internal DSI connector, `GAMESCOPE_INTERNAL_DISPLAY_ID`, a matching Lua profile with `allow_no_edid=true`, and complete validated physical size plus Gamma 2.2 HDR calibration before exposing support. Qualified whole-millimetre geometry overrides unreliable connector dimensions only in the generated client EDID.
- `patches/0009-drm-compose-gamma22-hdr-without-hardware-color-management.patch`
  source: armada
  notes: Prevents a single PQ layer from bypassing the Vulkan PQ-to-Gamma-2.2 transform on DRM drivers without hardware color management, with a Catch2 regression test.
- `patches/0010-wsi-filter-hdr-formats-by-underlying-support.patch`
  source: armada
  notes: Filters synthetic PQ/scRGB WSI entries by the VkFormats reported for the selected underlying surface, so Turnip clients cannot select an A2B10G10R10 format the driver will reject while AMD retains every format it actually supports. Covers both surface-format entry points, Vulkan count/VK_INCOMPLETE behavior, and preservation of application-owned VkSurfaceFormat2KHR output headers with Catch2 tests.
- `patches/0011-color-scale-sdr-white-on-gamma22-hdr-output.patch`
  source: armada
  notes: Applies the compositor's SDR-on-HDR white level to traditional Gamma 2.2 HDR outputs by scaling SDR input against the qualified panel peak. Ordinary SDR and external PQ output retain their existing paths; Catch2 covers the guarded gain calculation.
- `patches/0012-expose-client-sampleable-formats.patch`
  source: armada
  notes: Adds the opt-in `--expose-client-sampleable-formats` switch so the inner Wayland server can advertise DMA-BUF formats and modifiers that Vulkan can import and sample even when KMS planes cannot scan them out. The default backend intersection is unchanged. Direct scanout remains protected by the DRM backend framebuffer-import check, so a client buffer outside the KMS plane set falls back to Vulkan composition into a scanout-capable output buffer. Catch2 covers both the default policy and the opt-in bypass.
- `patches/0013-auto-hdr-per-layer-composition.patch`
  source: armada
  notes: Carries Armada Gamescope commit `ac49fbf36cb77aa98a41818fcfaec40ea41b4861`. Adds a disabled-by-default, per-layer SDR inverse-tone-mapping path using the existing BSD-licensed Gamescope compositor. Efficient mode preserves shadows and mid-tones, then applies a smooth, conservative highlight expansion independently derived from the guidance in ITU-R BT.2446-1 Method B. New color reference, policy, and runtime-property code is BSD-2-Clause; equations and matrices are independently expressed from IEC sRGB, ITU-R BT.709, ITU-R BT.2020, ITU-R BT.2446-1, and SMPTE ST 2084. Native HDR, unknown color states, system UI, overlays, cursor, screenshot reprocessing, and unqualified outputs bypass the transform. The compositor publishes support and effective-activation feedback for a verified runtime control and contextual HDR badge. Standalone color, activation-policy, and property tests cover strict math and the production policy flags.
- `patches/0014-auto-hdr-gamut-continuity.patch`
  source: armada
  notes: Carries Armada Gamescope commit `5e1ba40b7ae307ddc33c606b517e34188abbc159`, following `ac49fbf36cb77aa98a41818fcfaec40ea41b4861`. Derives the Auto HDR source-to-BT.2020 transform from the same effective SDR gamut policy used by the normal Gamescope LUT path, preserving the selected SDR presentation instead of forcing a separate Rec.709 interpretation. The matrix is a runtime uniform shared by eligible layers, remains separate from per-layer CTMs, is finite-validated before activation, and is carried across blit, scaling, blur, and capture shader interfaces. It also makes compositor-generated HDR presentation visible to Steam's existing HDR feedback. New code and tests are BSD-2-Clause and independently implemented from the cited color standards; no Special K source, shader, constants, or control flow were used.
- `patches/0015-auto-hdr-selective-highlight-curve.patch`
  source: armada
  notes: Carries Armada Gamescope commit `fc152fa9bde957690226fcec0d28ebccd5f9057d`, following `5e1ba40b7ae307ddc33c606b517e34188abbc159`. Preserves the SDR display-light baseline through 85 percent BT.2020 luminance, then uses an independently derived C2 quintic shoulder to concentrate the available HDR headroom in highlights and reach the configured target at nominal white. The CPU reference and production shader use the same curve, retain common-scale chromatic handling and proportional peak capping, and add regression coverage for the knee, target endpoint, and peak-cap chromatic ratios. New code and tests are BSD-2-Clause; no Special K source, shader, constants, or control flow were used.
- `patches/0016-auto-hdr-bounded-soft-shoulder.patch`
  source: armada
  notes: Carries Armada Gamescope commit `505730d365342c067086e470c7a77d2da3dde75b`. Replaces the narrow 85-percent shoulder with an independently derived C2 derivative ramp whose maximum output slope is bounded to ten times the SDR reference. Adds a converted-SDR content ceiling that is separate from the output-profile safety peak and defaults to the existing target when unset. The generic compositor contains no Odin-specific ceiling. CPU and GLSL paths share the same equations, finite guards, common-scale chromatic handling, and target safety clamp. Tests cover both joins, dense monotonicity, local-gain and oscillation bounds, hostile inputs, and chromatic luminance bounds. The curve, tests, CLI plumbing, and shader integration are BSD-2-Clause; no Special K source, shader, constants, or control flow were used.
- `patches/0017-auto-hdr-adaptive-scene-control.patch`
  source: armada
  notes: Carries Armada Gamescope commit `d9d3ff0e3036926f463fdcadb417cbad66704496`, following `505730d365342c067086e470c7a77d2da3dde75b`. Adds an opt-in experimental High Quality mode that samples one eligible SDR base scene on a sparse output-space grid, computes coverage-weighted soft luminance statistics, limits extra highlight headroom for broad bright fields, and stabilizes the resulting ceiling with deadband, hysteresis, dwell, asymmetric elapsed-time adaptation, reduction-only scene-cut acceleration, and long-gap reset. Efficient mode remains the default and is the fallback for unsupported sampling, capability, allocation, state, or pipeline conditions. Native HDR bypass and the disabled SDR path are unchanged. New code and tests are BSD-2-Clause and independently implemented from the standards and compatible Gamescope sources recorded in the Armada Auto HDR provenance document. No Special K source, shader, constants, tables, identifiers, or control flow were used.
- `patches/0018-auto-hdr-scaled-srgb-linear-analysis.patch`
  source: armada
  notes: Fixes adaptive analysis for scaled sRGB LINEAR content by matching the compositor's decode-before-bilinear reconstruction and pixel-center transform. Follows Armada Gamescope commit `d9d3ff0e3036926f463fdcadb417cbad66704496`. No Special K input was used.
- `patches/0020-auto-hdr-histogram-hud-quality.patch`
  source: armada
  notes: Carries Armada Gamescope commit `6f102dd7e9d7cf96e63a8efe5e2cd2684f08dde4`. Adds a 64-bin coverage-weighted luminance histogram, percentile-based highlight demand, distribution-aware broad-field protection, cumulative-histogram scene-cut detection, and conservative persistent-bright-cell statistics. The controller preserves the existing Efficient floor, reduction-only cut response, dwell, hysteresis, asymmetric temporal adaptation, and fail-closed fallback. Persistent cells can only discount scene statistics and never alter pixels directly. A developer-only heatmap visualizes the effective discount mask. New code and tests are BSD-2-Clause and independently designed from standard histogram, percentile, exponential-smoothing, and cumulative-distribution definitions. No Special K source, shader, constants, tables, identifiers, or control flow were used.
- `patches/0021-auto-hdr-gamut-near-black.patch`
  source: armada
  notes: Carries Armada Gamescope commit `aa4f2a1378c1bb77d8d75c47e7cde03d0635f6ab`, following `6f102dd7e9d7cf96e63a8efe5e2cd2684f08dde4`. Replaces proportional peak clipping with luminance-preserving neutral-axis chroma compression inside the validated linear BT.2020 channel box, while leaving physical-panel mapping to the existing output LUT. Adds dense black, neutral, saturated-boundary, hostile-input, and near-black monotonicity tests. New code and tests are BSD-2-Clause and independently derived from the existing Gamescope BT.2020 luminance model. No Special K implementation input was used.
- `patches/0022-auto-hdr-input-output-contract.patch`
  source: armada
  notes: Carries Armada Gamescope commit `3a639cff47cf6f5648c110298e0fdee1c760f390`, following `aa4f2a1378c1bb77d8d75c47e7cde03d0635f6ab`. Makes the Auto HDR eligibility decision explicit for represented full-range sRGB input, preserves Gamescope's established implicit sRGB default for feedback-free RGB clients, bypasses native scRGB and PQ, and fails closed for unknown colorspaces or YCbCr with unspecified range. Adds one-time KMS primary and overlay format-depth diagnostics without changing the existing kernel or display-engine dithering authority. New code and tests are BSD-2-Clause. No Special K implementation input was used.
- `patches/0023-autohdr-use-quality-mode-when-available.patch`
  source: armada
  notes: Carries Armada Gamescope commit `212ffb91e06d39be6e0e04d34de98327ece12132`, following `3a639cff47cf6f5648c110298e0fdee1c760f390`. Makes Quality the only selectable Auto HDR engine when adaptive analysis is available, removes the command-line engine selector, and retains Efficient only as the internal fallback when Quality capability, setup, or execution is unavailable. It adds no Eco engine or profile-selection protocol. The change follows the existing Gamescope BSD-2-Clause lineage; all new code and tests in this commit are BSD-2-Clause. It was independently implemented without Special K source, shaders, constants, tables, identifiers, or control flow.
- `patches/0024-autohdr-report-only-rendered-conversion-as-active.patch`
  source: armada
  notes: Carries Armada Gamescope commit `a1106e8eed7d57fe33f2e69eeebeb6de8a29b44b`, following `212ffb91e06d39be6e0e04d34de98327ece12132`. Separates policy eligibility from actual render feedback so a successful Quality or Efficient pipeline reports active conversion while a zero-mask safety fallback reports inactive, Effective Off, and no compositor-generated HDR badge. The change follows the existing Gamescope BSD-2-Clause lineage; all new code and tests are BSD-2-Clause. It was independently implemented without Special K source, shaders, constants, tables, identifiers, or control flow.
- `patches/0025-autohdr-include-rendered-feedback-helper.patch`
  source: armada
  notes: Carries Armada Gamescope commit `9bcedecacf96375af6b010bd28494ec94c9ac846`, following `a1106e8eed7d57fe33f2e69eeebeb6de8a29b44b`. Includes the existing Auto HDR root-property helper declaration at the Vulkan compositor call site so rendered-activation feedback builds cleanly. The change follows the existing Gamescope BSD-2-Clause lineage and adds no new algorithm, constant, or external implementation input.
