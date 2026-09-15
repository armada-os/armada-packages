#!/usr/bin/env python3
"""Apply the repository patches and test their resulting DSX sources."""
import os
import pathlib
import subprocess
import sys
import tempfile

KERNEL = pathlib.Path(__file__).resolve().parents[1]
PATCHES = KERNEL / "patches"
DSX = pathlib.Path("drivers/input/touchscreen/synaptics_dsx")

with tempfile.TemporaryDirectory(prefix="synaptics-dsx-patches-") as directory:
    tree = pathlib.Path(directory)
    for name in (
        "0060-input-touchscreen-add-synaptics-dsx-driver.patch",
        "0060a-input-synaptics-dsx-follow-display-panel-power-lifecycle.patch",
    ):
        subprocess.run(
            ["patch", "-p1", "--batch", "--forward", "-i", str(PATCHES / name)],
            cwd=tree,
            check=True,
        )

    env = os.environ.copy()
    env["SYNAPTICS_DSX_SOURCE_DIR"] = str(tree / DSX)
    subprocess.run(
        [sys.executable, str(KERNEL / "tests/test_synaptics_dsx_source.py")],
        env=env,
        check=True,
    )
    subprocess.run(
        [sys.executable, str(KERNEL / "tests/run_synaptics_dsx_recovery_harness.py")],
        env=env,
        check=True,
    )
