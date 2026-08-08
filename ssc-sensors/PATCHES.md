# Patches

Sources for the ssc-sensors package (Snapdragon Sensor Core accel+gyro bridge).

## Source files

- `src/daemon_main.c`
  source: https://github.com/ROCKNIX/distribution/pull/3005
  upstream: local
  notes: Minimal main() for adsprpcd; calls fastrpc default_listener_start for the sensorspd static PD.

- `src/snsfeed.c`
  source: https://github.com/ROCKNIX/distribution/pull/3005
  upstream: local
  notes: Reads accel+gyro over QRTR (sns_client service 5:21), writes samples to /dev/sns_iio_feed at configurable rate.

- `src/bsd_shim.c`
  source: https://github.com/ROCKNIX/distribution/pull/3005
  upstream: local
  notes: strlcpy/strlcat shim for glibc targets (fastrpc uses BSD string functions).
