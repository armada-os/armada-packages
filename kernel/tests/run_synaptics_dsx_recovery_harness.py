#!/usr/bin/env python3
"""Compile and run the actual DSX resume helper/worker bodies with kernel stubs."""
import os, pathlib, re, subprocess, tempfile

root = pathlib.Path(os.environ["SYNAPTICS_DSX_SOURCE_DIR"])
source = (root / "synaptics_dsx_core.c").read_text()
build = pathlib.Path(tempfile.mkdtemp(prefix="synaptics-dsx-harness-"))


def definition(name):
    m = re.search(r"static\s+[\w\s*]+\b" + re.escape(name) + r"\s*\([^;]*?\)\s*\{", source, re.S)
    if not m: raise RuntimeError(name)
    brace = source.index("{", m.start()); depth = 0
    for i in range(brace, len(source)):
        depth += source[i] == "{"
        depth -= source[i] == "}"
        if depth == 0:
            return source[m.start():i + 1]
    raise RuntimeError("unterminated " + name)

functions = "\n\n".join(definition(n) for n in (
    "synaptics_rmi4_sensor_sleep", "synaptics_rmi4_sensor_wake",
    "synaptics_rmi4_irq_enable", "synaptics_rmi4_finish_resume",
    "synaptics_rmi4_resume_work", "synaptics_rmi4_do_suspend",
    "synaptics_rmi4_do_panel_unprepare",
    "synaptics_rmi4_do_resume", "synaptics_rmi4_panel_prepared",
    "synaptics_rmi4_panel_unpreparing", "synaptics_rmi4_suspend",
    "synaptics_rmi4_resume"))

preamble = r'''
#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#define EIO 5
#define MASK_8BIT 255
#define MASK_3BIT 7
#define NO_SLEEP_OFF 0
#define SENSOR_SLEEP 1
#define NORMAL_OPERATION 0
#define SYNAPTICS_RMI4_RESUME_RETRY_MS 250
#define SYNAPTICS_RMI4_RESUME_MAX_RETRIES 5
#define READ_ONCE(x) (x)
#define WRITE_ONCE(x,v) ((x)=(v))
#define msecs_to_jiffies(x) (x)
struct work_struct { int unused; };
struct delayed_work { struct work_struct work; bool queued; };
struct mutex { bool locked; };
struct device { void *data; };
struct platform_device { struct { struct device *parent; } dev; };
struct drm_panel_follower { int unused; };
struct synaptics_rmi4_data {
 struct platform_device *pdev; struct mutex rmi4_state_mutex, rmi4_reset_mutex;
 unsigned short f01_ctrl_base_addr; unsigned char no_sleep_setting, current_page;
 bool irq_enabled, suspend, sensor_sleep, resume_pending, follows_panel;
 unsigned int resume_retries; struct delayed_work polling_work, resume_work;
 struct drm_panel_follower panel_follower;
};
static int read_results[16], read_count, read_pos, write_result, int_enable_result;
static int read_calls, irq_calls, warn_count, err_count, report_calls, reinit_calls;
static bool induce_reset, simulate_recovery_completion;
static int synaptics_rmi4_reg_read(struct synaptics_rmi4_data *d, unsigned short a, unsigned char *v, unsigned short n) {
 int r = read_pos < read_count ? read_results[read_pos++] : 1; read_calls++; *v = 1; return r;
}
static int synaptics_rmi4_reg_write(struct synaptics_rmi4_data *d, unsigned short a, unsigned char *v, unsigned short n) { return write_result; }
static int schedule_delayed_work(struct delayed_work *w, unsigned long delay) { w->queued = true; return 1; }
static void mutex_lock(struct mutex *m) { assert(!m->locked); m->locked=true; }
static void mutex_unlock(struct mutex *m) { assert(m->locked); m->locked=false; }
static int synaptics_rmi4_int_enable(struct synaptics_rmi4_data *d, bool enable) { irq_calls++; return int_enable_result; }
static int synaptics_rmi4_reinit_device(struct synaptics_rmi4_data *d) { reinit_calls++; mutex_lock(&d->rmi4_reset_mutex); mutex_unlock(&d->rmi4_reset_mutex); return 0; }
static void synaptics_rmi4_sensor_report(struct synaptics_rmi4_data *d, bool report) { report_calls++; if(induce_reset) synaptics_rmi4_reinit_device(d); }
static void cancel_delayed_work_sync(struct delayed_work *w) { w->queued=false; if(simulate_recovery_completion) { struct synaptics_rmi4_data *d=(struct synaptics_rmi4_data *)((char *)w-__builtin_offsetof(struct synaptics_rmi4_data,resume_work)); d->suspend=false; simulate_recovery_completion=false; } }
static void *dev_get_drvdata(struct device *d) { return d->data; }
static int synaptics_rmi4_free_fingers(struct synaptics_rmi4_data *d) { return 0; }
#define to_delayed_work(w) ((struct delayed_work *)(w))
#define container_of(ptr,type,member) ((type *)((char *)(ptr)-offsetof(type,member)))
#define dev_warn(dev,fmt,...) (warn_count++)
#define dev_err(dev,fmt,...) (err_count++)
'''

tests = r'''
static struct synaptics_rmi4_data fresh(void) { static struct platform_device p; struct synaptics_rmi4_data d = {0}; d.pdev=&p; d.suspend=true; d.sensor_sleep=true; return d; }
static void reset_stubs(void) { read_count=read_pos=read_calls=irq_calls=warn_count=err_count=report_calls=reinit_calls=0; write_result=1; int_enable_result=0; induce_reset=simulate_recovery_completion=false; }
int main(void) {
 struct synaptics_rmi4_data d; int ret, i;
 /* sleep reports transport errors instead of silently succeeding */
 reset_stubs(); d=fresh(); d.sensor_sleep=false; read_results[0]=-EIO; read_count=1;
 ret=synaptics_rmi4_sensor_sleep(&d); assert(ret==-EIO && !d.sensor_sleep);
 /* successful resume */
 reset_stubs(); d=fresh(); d.resume_pending=true; ret=synaptics_rmi4_finish_resume(&d);
 assert(ret==0 && !d.suspend && !d.sensor_sleep && d.irq_enabled && d.polling_work.queued && !d.resume_pending);
 /* transient transport failure recovers on delayed retry */
 reset_stubs(); d=fresh(); d.resume_pending=true; read_results[0]=-EIO; read_results[1]=1; read_count=2;
 synaptics_rmi4_resume_work(&d.resume_work.work); assert(d.resume_work.queued && d.resume_pending && d.suspend);
 d.resume_work.queued=false; synaptics_rmi4_resume_work(&d.resume_work.work);
 assert(!d.resume_pending && !d.suspend && d.polling_work.queued && d.resume_retries==2);
 /* permanent failure is bounded and visibly exhausted */
 reset_stubs(); d=fresh(); d.resume_pending=true; for(i=0;i<8;i++) read_results[i]=-EIO; read_count=8;
 for(i=0;i<SYNAPTICS_RMI4_RESUME_MAX_RETRIES;i++){ d.resume_work.queued=false; synaptics_rmi4_resume_work(&d.resume_work.work); }
 assert(!d.resume_pending && !d.resume_work.queued && d.suspend && err_count==SYNAPTICS_RMI4_RESUME_MAX_RETRIES+1 && d.resume_retries==SYNAPTICS_RMI4_RESUME_MAX_RETRIES);
 /* cancellation prevents hardware access and requeue */
 reset_stubs(); d=fresh(); d.resume_pending=false; synaptics_rmi4_resume_work(&d.resume_work.work);
 assert(read_calls==0 && irq_calls==0 && !d.resume_work.queued);
 /* failed irq enable leaves no polling worker queued */
 reset_stubs(); d=fresh(); d.resume_pending=true; int_enable_result=-EIO; ret=synaptics_rmi4_finish_resume(&d);
 assert(ret==-EIO && !d.polling_work.queued && d.suspend && d.resume_pending);
 /* actual irq-enable body can report a spontaneous reset without recursive mutex locking */
 reset_stubs(); d=fresh(); d.resume_pending=true; induce_reset=true; ret=synaptics_rmi4_finish_resume(&d);
 assert(ret==0 && report_calls==1 && reinit_calls==1 && !d.rmi4_reset_mutex.locked);
 /* a failed suspend restores the active state because PM need not call resume */
 reset_stubs(); d=fresh(); d.suspend=false; d.sensor_sleep=false; d.irq_enabled=true; read_results[0]=-EIO; read_count=1; { struct device dev={.data=&d}; ret=synaptics_rmi4_suspend(&dev); }
 assert(ret==-EIO && !d.suspend && d.irq_enabled && d.polling_work.queued && !d.resume_pending);
 /* a completing recovery cannot clear suspend after cancellation drains it */
 reset_stubs(); d=fresh(); d.suspend=false; d.sensor_sleep=false; d.irq_enabled=true; d.resume_work.queued=true; simulate_recovery_completion=true; { struct device dev={.data=&d}; ret=synaptics_rmi4_suspend(&dev); }
 assert(ret==0 && d.suspend && !d.irq_enabled && !d.polling_work.queued);
 /* device PM is bus-silent when panel callbacks own the power lifecycle */
 reset_stubs(); d=fresh(); d.suspend=false; d.sensor_sleep=false; d.irq_enabled=true; d.follows_panel=true;
 { struct device dev={.data=&d}; ret=synaptics_rmi4_suspend(&dev); assert(ret==0); ret=synaptics_rmi4_resume(&dev); }
 assert(ret==0 && read_calls==0 && irq_calls==0 && !d.suspend);
 /* panel unprepare sleeps before power loss; panel prepare wakes after power restore */
 ret=synaptics_rmi4_panel_unpreparing(&d.panel_follower);
 assert(ret==0 && d.suspend && d.sensor_sleep && !d.irq_enabled);
 ret=synaptics_rmi4_panel_prepared(&d.panel_follower);
 assert(ret==0 && !d.suspend && !d.sensor_sleep && d.irq_enabled);
 /* failed panel sleep remains quiescent while DRM continues power-off; the next prepare restores it */
 reset_stubs(); d=fresh(); d.suspend=false; d.sensor_sleep=false; d.irq_enabled=true;
 read_results[0]=-EIO; read_results[1]=1; read_count=2;
 ret=synaptics_rmi4_panel_unpreparing(&d.panel_follower);
 assert(ret==-EIO && d.suspend && !d.sensor_sleep && !d.irq_enabled && !d.polling_work.queued && !d.resume_work.queued && !d.resume_pending);
 ret=synaptics_rmi4_panel_prepared(&d.panel_follower);
 assert(ret==0 && !d.suspend && !d.sensor_sleep && d.irq_enabled && d.polling_work.queued && !d.resume_work.queued);
 /* if restoration fails after power returns, only prepare may start bounded recovery */
 reset_stubs(); d=fresh(); d.suspend=false; d.sensor_sleep=false; d.irq_enabled=true;
 read_results[0]=-EIO; read_results[1]=-EIO; read_results[2]=1; read_count=3;
 ret=synaptics_rmi4_panel_unpreparing(&d.panel_follower);
 assert(ret==-EIO && d.suspend && !d.irq_enabled && !d.polling_work.queued && !d.resume_work.queued && !d.resume_pending);
 ret=synaptics_rmi4_panel_prepared(&d.panel_follower);
 assert(ret==-EIO && d.suspend && !d.irq_enabled && !d.polling_work.queued && d.resume_work.queued && d.resume_pending);
 d.resume_work.queued=false; synaptics_rmi4_resume_work(&d.resume_work.work);
 assert(!d.suspend && d.irq_enabled && d.polling_work.queued && !d.resume_work.queued && !d.resume_pending);
 puts("recovery harness: 13 scenarios passed"); return 0;
}
'''

harness = build / "recovery_harness.c"
harness.write_text(preamble + functions + tests)
binary = build / "recovery_harness"
subprocess.run(["gcc", "-std=c11", "-Wall", "-Wextra", "-Werror", "-Wno-unused-parameter", str(harness), "-o", str(binary)], check=True)
subprocess.run([str(binary)], check=True)
