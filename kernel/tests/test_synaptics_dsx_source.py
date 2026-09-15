#!/usr/bin/env python3
import pathlib
import re
import os
import unittest

ROOT = pathlib.Path(os.environ["SYNAPTICS_DSX_SOURCE_DIR"])
CORE = (ROOT / "synaptics_dsx_core.c").read_text()
HEADER = (ROOT / "synaptics_dsx_core.h").read_text()
I2C = (ROOT / "synaptics_dsx_i2c.c").read_text()


def body(name, source=CORE):
    match = re.search(r"static\s+[\w\s*]+\b" + re.escape(name) + r"\s*\([^;]*?\)\s*\{", source, re.S)
    if not match:
        raise AssertionError(f"definition not found: {name}")
    brace = source.index("{", match.start())
    depth = 0
    for pos in range(brace, len(source)):
        if source[pos] == "{": depth += 1
        elif source[pos] == "}":
            depth -= 1
            if depth == 0:
                return source[brace + 1:pos]
    raise AssertionError(f"unterminated {name}")


class RecoverySourceTests(unittest.TestCase):
    def test_panel_follower_owns_bus_power_lifecycle(self):
        self.assertIn("struct drm_panel_follower panel_follower", HEADER)
        self.assertIn("drm_is_panel_follower", CORE)
        self.assertIn("drm_panel_add_follower", CORE)
        funcs = body("synaptics_rmi4_panel_prepared")
        self.assertIn("synaptics_rmi4_do_resume", funcs)
        funcs = body("synaptics_rmi4_panel_unpreparing")
        self.assertIn("synaptics_rmi4_do_panel_unprepare", funcs)

    def test_panel_unprepare_failure_stays_quiescent(self):
        text = body("synaptics_rmi4_do_panel_unprepare")
        self.assertIn("rmi4_data->suspend = true", text)
        self.assertIn("synaptics_rmi4_irq_enable(rmi4_data, false", text)
        self.assertIn("synaptics_rmi4_sensor_sleep", text)
        self.assertNotIn("synaptics_rmi4_finish_resume", text)
        self.assertNotIn("schedule_delayed_work", text)

    def test_ordinary_pm_suspend_failure_keeps_rollback_and_recovery(self):
        text = body("synaptics_rmi4_do_suspend")
        self.assertIn("synaptics_rmi4_finish_resume", text)
        self.assertIn("schedule_delayed_work(&rmi4_data->resume_work", text)

    def test_device_pm_does_not_touch_bus_when_panel_follower(self):
        suspend = body("synaptics_rmi4_suspend")
        resume = body("synaptics_rmi4_resume")
        for text in (suspend, resume):
            self.assertIn("follows_panel", text)
            self.assertIn("return 0", text)
        self.assertNotIn("sensor_sleep", suspend)
        self.assertNotIn("finish_resume", resume)

    def test_panel_follower_is_removed_before_state_is_freed(self):
        remove = body("synaptics_rmi4_remove")
        self.assertIn("drm_panel_remove_follower", remove)
        self.assertLess(remove.index("drm_panel_remove_follower"),
                        remove.index("kfree(rmi4_data)"))

    def test_sleep_and_wake_return_transport_status(self):
        self.assertRegex(CORE, r"static int synaptics_rmi4_sensor_sleep")
        self.assertRegex(CORE, r"static int synaptics_rmi4_sensor_wake")
        self.assertIn("return retval;", body("synaptics_rmi4_sensor_wake"))

    def test_failed_irq_enable_never_queues_polling(self):
        text = body("synaptics_rmi4_irq_enable")
        schedule = text.index("schedule_delayed_work")
        final_enable = text.index("synaptics_rmi4_int_enable(rmi4_data, true)")
        self.assertGreater(schedule, final_enable)
        self.assertLess(text.index("irq_enabled = true"), schedule)

    def test_polling_requires_fully_active_sensor(self):
        text = body("synaptics_rmi4_polling_work")
        self.assertIn("irq_enabled", text)
        self.assertIn("sensor_sleep", text)

    def test_resume_has_bounded_delayed_recovery_and_visible_exhaustion(self):
        self.assertIn("resume_work", HEADER)
        self.assertIn("SYNAPTICS_RMI4_RESUME_MAX_RETRIES", CORE)
        worker = body("synaptics_rmi4_resume_work")
        self.assertIn("dev_err", worker)
        self.assertIn("schedule_delayed_work", worker)

    def test_suspend_remove_and_probe_failure_cancel_recovery(self):
        for name in ("synaptics_rmi4_do_suspend", "synaptics_rmi4_remove"):
            self.assertIn("cancel_delayed_work_sync(&rmi4_data->resume_work)", body(name))
        failure_tail = CORE[CORE.index("err_enable_irq:"):CORE.index("static void synaptics_rmi4_remove")]
        self.assertIn("cancel_delayed_work_sync(&rmi4_data->resume_work)", failure_tail)

    def test_reset_does_not_cancel_work_while_holding_reset_mutex(self):
        text = body("synaptics_rmi4_reset_device")
        self.assertLess(text.index("synaptics_rmi4_irq_enable(rmi4_data, false"),
                        text.index("mutex_lock(&(rmi4_data->rmi4_reset_mutex))"))

    def test_resume_does_not_enable_irq_while_holding_reset_mutex(self):
        text = body("synaptics_rmi4_finish_resume")
        unlock = text.index("mutex_unlock(&rmi4_data->rmi4_reset_mutex)")
        enable = text.index("synaptics_rmi4_irq_enable(rmi4_data, true")
        self.assertLess(unlock, enable)

    def test_reset_and_recovery_share_lifecycle_serialization(self):
        self.assertIn("rmi4_state_mutex", HEADER)
        for name in ("synaptics_rmi4_reset_device",
                     "synaptics_rmi4_resume_work",
                     "synaptics_rmi4_do_suspend",
                     "synaptics_rmi4_do_resume"):
            self.assertIn("rmi4_state_mutex", body(name))

    def test_suspend_drains_recovery_before_marking_suspended(self):
        text = body("synaptics_rmi4_do_suspend")
        cancel = text.index("cancel_delayed_work_sync(&rmi4_data->resume_work)")
        suspended = text.index("rmi4_data->suspend = true")
        polling = text.index("synaptics_rmi4_irq_enable(rmi4_data, false")
        self.assertLess(cancel, suspended)
        self.assertLess(suspended, polling)


    def test_i2c_set_page_is_initialized_and_preserves_errno(self):
        text = body("synaptics_rmi4_i2c_set_page", I2C)
        self.assertRegex(text, r"int transfer_ret\s*=")
        self.assertIn("return transfer_ret < 0 ? transfer_ret : -EIO", text)
        for name in ("synaptics_rmi4_i2c_read", "synaptics_rmi4_i2c_write"):
            self.assertIn("retval < 0 ? retval : -EIO", body(name, I2C))


if __name__ == "__main__":
    unittest.main(verbosity=2)
