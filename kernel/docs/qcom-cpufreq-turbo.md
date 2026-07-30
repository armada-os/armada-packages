# Qualcomm cpufreq hardware turbo LUT rows

`qcom-cpufreq-hw` reads EPSS frequency tables from hardware LUT rows. Some
platforms expose single-core turbo rows with `LUT_TURBO_IND`.

Armada carries `patches/0901-cpufreq-qcom-expose-turbo-lut-rows.patch` to expose
non-duplicate turbo LUT rows as cpufreq boost frequencies when the row validates
against the device-tree OPP table.

## Default behavior

The patch is conservative by default:

- turbo rows are exposed only as `CPUFREQ_BOOST_FREQ` entries;
- global cpufreq boost remains disabled unless userspace enables it;
- turbo rows missing from the DT OPP table remain hidden by default;
- duplicate terminal LUT rows are ignored so the existing end-of-table detection
  still terminates the frequency table.

## Missing DT OPP opt-in

Some firmware exposes a top turbo LUT row before the matching DT OPP exists. For
validated systems only, the dynamic OPP path can be enabled with:

```text
qcom_cpufreq_hw.allow_missing_turbo_opp=1
```

When enabled, a missing turbo row is registered from the LUT-provided frequency
and voltage only after the normal OPP update fails with `-ENODEV`. The row is
still exposed only as a cpufreq boost frequency.

Use this opt-in only after validating thermals, power limits, and stability on
the target hardware. Do not enable it as a blanket policy for all systems sharing
the same SoC.

Context: https://github.com/virtudude/armada/issues/173
