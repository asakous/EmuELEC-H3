From c1715f7de4f2b7c42f432d4a7eb02f3f954d34ca Mon Sep 17 00:00:00 2001
From: Kevin Mihelich <kevin@archlinuxarm.org>
Date: Sat, 6 Dec 2014 10:44:46 -0700
Subject: [PATCH] Backport firmware loader

commit 390ac45ceb37d70308194820e25b1cb885b67260
Author: Ming Lei <ming.lei@canonical.com>
Date:   Fri Aug 17 22:06:59 2012 +0800

    PM / Sleep: introduce dpm_for_each_dev

    dpm_list and its pm lock provide a good way to iterate all
    devices in system. Except this way, there is no other easy
    way to iterate devices in system.

    firmware loader need to cache firmware images for devices
    before system sleep, so introduce the function to meet its
    demand.

    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1dc17a9704a49c008a8d4cd8bdf03eccc54bcf84
Author: Kevin Mihelich <kevin@archlinuxarm.org>
Date:   Wed Nov 26 13:03:08 2014 -0700

    Revert "firmware loader: sync firmware cache by async_synchronize_full_domain"

    This reverts commit d28d3882bd1fdb88ae4e02f11b091a92b0e5068b.

commit 6cf1b1b3016fb279d6a866151e75c94986be032b
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:26 2012 +0800

    driver core: devres: introduce devres_for_each_res

    This patch introduces one devres API of devres_for_each_res
    so that the device's driver can iterate each resource it has
    interest in.

    The firmware loader will use the API to get each firmware name
    from the device instance.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 6183261d20682701b6ddd189060da4f8325e775c
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Thu May 3 18:15:12 2012 +0100

    devres: Clarify documentation for devres_destroy()

    It's not massively obvious (at least to me) that removing and freeing a
    resource does not involve calling the release function for the resource
    but rather only removes the management of it. Make the documentation more
    explicit.

    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bf4725b4926af17c246faf3b6dda250890b3e1ae
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Jan 31 11:13:57 2013 +0100

    firmware: Ignore abort check when no user-helper is used

    FW_STATUS_ABORT can be set only during the user-helper invocation,
    thus we can ignore the check when CONFIG_HW_LOADER_USER_HELPER is
    disabled.

    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 5d5c8b23919037f575fb6370d87b875c86793834
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Jan 31 11:13:56 2013 +0100

    firmware: Reduce ifdef CONFIG_FW_LOADER_USER_HELPER

    By shuffling the code, reduce a few ifdefs in firmware_class.c.
    Also, firmware_buf fmt field is changed to is_pages_buf boolean for
    simplification.

    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 861d2fc3539af167b5c4c9e81b5bf67300465cef
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Jan 31 11:13:55 2013 +0100

    firmware: Make user-mode helper optional

    This patch adds a new kconfig, CONFIG_FW_LOADER_USER_HELPER, and
    guards the user-helper codes in firmware_class.c with ifdefs.

    Yeah, yeah, there are lots of ifdefs in this patch.  The further
    clean-up with code shuffling follows in the next.

    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit eb2e7c184b7e7bf2ae1968bd32c4354d28c75e69
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Jan 31 11:13:54 2013 +0100

    firmware: Refactoring for splitting user-mode helper code

    Since 3.7 kernel, the firmware loader can read the firmware files
    directly, and the traditional user-mode helper is invoked only as a
    fallback.  This seems working pretty well, and the next step would be
    to reduce the redundant user-mode helper stuff in future.

    This patch is a preparation for that: refactor the code for splitting
    user-mode helper stuff more easily.  No functional change.

    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 542061e36122107363fcf7c9aeffa957dee8bffc
Author: Luciano Coelho <coelho@ti.com>
Date:   Tue Jan 15 10:43:43 2013 +0200

    firmware: make sure the fw file size is not 0

    If the requested firmware file size is 0 bytes in the filesytem, we
    will try to vmalloc(0), which causes a warning:

      vmalloc: allocation failure: 0 bytes
      kworker/1:1: page allocation failure: order:0, mode:0xd2
        __vmalloc_node_range+0x164/0x208
        __vmalloc_node+0x4c/0x58
        vmalloc+0x38/0x44
        _request_firmware_load+0x220/0x6b0
        request_firmware+0x64/0xc8
        wl18xx_setup+0xb4/0x570 [wl18xx]
        wlcore_nvs_cb+0x64/0x9f8 [wlcore]
        request_firmware_work_func+0x94/0x100
        process_one_work+0x1d0/0x750
        worker_thread+0x184/0x4ac
        kthread+0xb4/0xc0

    To fix this, check whether the file size is less than or equal to zero
    in fw_read_file_contents().

    Cc: stable <stable@vger.kernel.org> [3.7]
    Signed-off-by: Luciano Coelho <coelho@ti.com>
    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 906aa734d888dfeb855d50ebdaa1abafb4e16880
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Sat Nov 3 17:48:16 2012 +0800

    firmware loader: document firmware cache mechanism

    This patch documents the firmware cache mechanism so that
    users of request_firmware() know that it can be called
    safely inside device's suspend and resume callback, and
    the device's firmware needn't be cached any more by individual
    driver itself to deal with firmware loss during system resume.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 2a2f0be2bb74403c0079a823271e6ff7c2434735
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Nov 3 17:47:58 2012 +0800

    firmware loader: introduce module parameter to customize(v4) fw search path

    This patch introduces one module parameter of 'path' in firmware_class
    to support customizing firmware image search path, so that people can
    use its own firmware path if the default built-in paths can't meet their
    demand[1], and the typical usage is passing the below from kernel command
    parameter when 'firmware_class' is built in kernel:

    	firmware_class.path=$CUSTOMIZED_PATH

    [1], https://lkml.org/lkml/2012/10/11/337

    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

    Conflicts:
    	Documentation/firmware_class/README

commit d6c6925a1c5091163df48d68ba38d2ec2003302e
Author: Cesar Eduardo Barros <cesarb@cesarb.net>
Date:   Sat Oct 27 20:37:10 2012 -0200

    firmware: use noinline_for_stack

    The comment above fw_file_size() suggests it is noinline for stack size
    reasons. Use noinline_for_stack to make this more clear.

    Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f0d798c22f43f008b0b86ff58f2c68b522f1be90
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Sat Nov 10 01:27:22 2012 +0800

    firmware loader: Fix the concurrent request_firmware() race for kref_get/put

    There is one race that both request_firmware() with the same
    firmware name.

    The race scenerio is as below:
    CPU1                                                  CPU2
    request_firmware() -->
    _request_firmware_load() return err                   another request_firmware() is coming -->
    _request_firmware_cleanup is called -->               _request_firmware_prepare -->
    release_firmware --->                                 fw_lookup_and_allocate_buf -->
                                                          spin_lock(&fwc->lock)
    ...                                                   __fw_lookup_buf() return true
    fw_free_buf() will be called -->                      ...
    kref_put -->
    decrease the refcount to 0
                                                          kref_get(&tmp->ref) ==> it will trigger warning
                                                                                  due to refcount == 0
    __fw_free_buf() -->
    ...                                                   spin_unlock(&fwc->lock)
    spin_lock(&fwc->lock)
    list_del(&buf->list)
    spin_unlock(&fwc->lock)
    kfree(buf)
                                                          After that, the freed buf will be used.

    The key race is decreasing refcount to 0 and list_del is not protected together by
    fwc->lock, and it is possible another thread try to get it between refcount==0
    and list_del.

    Fix it here to protect it together.

    Acked-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 58af61921c9d1f6a8ffa097043bf78a2ff0bc44e
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Thu Nov 8 19:14:40 2012 +0800

    firmware loader: Fix the race FW_STATUS_DONE is followed by class_timeout

    There is a race as below when calling request_firmware():
    CPU1                                   CPU2
    write 0 > loading
    mutex_lock(&fw_lock)
    ...
    set_bit FW_STATUS_DONE                 class_timeout is coming
                                           set_bit FW_STATUS_ABORT
    complete_all &completion
    ...
    mutex_unlock(&fw_lock)

    In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
    and request_firmware() will return failure due to condition in
    _request_firmware_load():
    	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
    		retval = -ENOENT;

    But from the above scenerio, it should be a successful requesting.
    So we need judge if the bit FW_STATUS_DONE is already set before
    calling fw_load_abort() in timeout function.

    As Ming's proposal, we need change the timer into sched_work to
    benefit from using &fw_lock mutex also.

    Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
    Acked-by: Ming Lei <ming.lei@canonical.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c6a3b74d6c42ca8aead23788768cdd358f672ed3
Author: Ming Lei <ming.lei@canonical.com>
Date:   Tue Oct 9 12:01:04 2012 +0800

    firmware loader: sync firmware cache by async_synchronize_full_domain

    async.c has provided synchronization mechanism on async_schedule_*,
    so use async_synchronize_full_domain to sync caching firmware instead
    of reinventing the wheel.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 9a27bd527d58a887a65bad24fd864122f860ef79
Author: Ming Lei <ming.lei@canonical.com>
Date:   Tue Oct 9 12:01:03 2012 +0800

    firmware loader: let direct loading back on 'firmware_buf'

    Firstly 'firmware_buf' is introduced to make all loading requests
    to share one firmware kernel buffer, so firmware_buf should
    be used in direct loading for saving memory and speedup firmware
    loading.

    Secondly, the commit below

    	abb139e75c2cdbb955e840d6331cb5863e409d0e(firmware:teach
    	the kernel to load firmware files directly from the filesystem)

    introduces direct loading for fixing udev regression, but it
    bypasses the firmware cache meachnism, so this patch enables
    caching firmware for direct loading case since it is still needed
    to solve drivers' dependency during system resume.

    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 451768e107b4bd2beb054f3ec44b666910a8f6ce
Author: Ming Lei <ming.lei@canonical.com>
Date:   Tue Oct 9 12:01:02 2012 +0800

    firmware loader: fix one reqeust_firmware race

    Several loading requests may be pending on one same
    firmware buf, and this patch moves fw_map_pages_buf()
    before complete_all(&fw_buf->completion) and let all
    requests see the mapped 'buf->data' once the loading
    is completed.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 31159a04875c46fe2f8634479f5c2c07b3ebd6aa
Author: Ming Lei <ming.lei@canonical.com>
Date:   Tue Oct 9 12:01:01 2012 +0800

    firmware loader: cancel uncache work before caching firmware

    Under 'Opportunistic sleep' situation, system sleep might be
    triggered very frequently, so the uncahce work may not be completed
    before caching firmware during next suspend.

    This patch cancels the uncache work before caching firmware to
    fix the problem above.

    Also this patch optimizes the cacheing firmware mechanism a bit by
    only storing one firmware cache entry for one firmware image.

    So if the firmware is still cached during suspend, it doesn't need
    to be loaded from user space any more.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4c7559d930c34c76a33b51f413c13f27367e95ff
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Oct 4 09:19:02 2012 -0700

    firmware: use 'kernel_read()' to read firmware into kernel buffer

    Fengguang correctly points out that the firmware reading should not use
    vfs_read(), since the buffer is in kernel space.

    The vfs_read() just happened to work for kernel threads, but sparse
    warns about the incorrect address spaces, and it's definitely incorrect
    and could fail for other users of the firmware loading.

    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 2047dd6d95ac6066e518c26cb5133f4787aefb52
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Oct 3 15:58:32 2012 -0700

    firmware: teach the kernel to load firmware files directly from the filesystem

    This is a first step in allowing people to by-pass udev for loading
    device firmware.  Current versions of udev will deadlock (causing us to
    block for the 30 second timeout) under some circumstances if the
    firmware is loaded as part of the module initialization path, and this
    is causing problems for media drivers in particular.

    The current patch hardcodes the firmware path that udev uses by default,
    and will fall back to the legacy udev mode if the firmware cannot be
    found there.  We'd like to add support for both configuring the paths
    and the fallback behaviour, but in the meantime this hopefully fixes the
    immediate problem, while also giving us a way forward.

    [ v2: Some VFS layer interface cleanups suggested by Al Viro ]
    [ v3: use the default udev paths suggested by Kay Sievers ]

    Suggested-by: Ivan Kalvachev <ikalvachev@gmail.com>
    Acked-by: Greg KH <gregkh@linuxfoundation.org>
    Acked-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
    Cc: Kay Sievers <kay@redhat.com>
    Cc: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 7dc9f6ac529be96085a096c440823fe49f95f1cd
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Sep 8 17:32:30 2012 +0800

    firmware loader: fix compile warning when CONFIG_PM=n

    This patch replaces the previous macro of CONFIG_PM with
    CONFIG_PM_SLEEP becasue firmware cache is only used in
    system sleep situations.

    Also this patch fixes the below compile warning when
    CONFIG_PM=n:

    	drivers/base/firmware_class.c:1147: warning: 'device_cache_fw_images'
    	defined but not used
    	drivers/base/firmware_class.c:1212: warning:
    	'device_uncache_fw_images_delay' defined but not used

    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d4da2957c44390959fea1003188f449b3f38aba3
Author: Ming Lei <ming.lei@canonical.com>
Date:   Mon Aug 20 19:04:16 2012 +0800

    firmware loader: let caching firmware piggyback on loading firmware

    After starting caching firmware, there is still some time left
    before devices are suspended, during the period, request_firmware
    or its nowait version may still be triggered by the below situations
    to load firmware images which can't be cached during suspend/resume
    cycle.

    	- new devices added
    	- driver bind
    	- or device open kind of things

    This patch utilizes the piggyback trick to cache firmware for
    this kind of situation: just increase the firmware buf's reference
    count and add the fw name entry into cache entry list after starting
    caching firmware and before syscore_suspend() is called.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 580eb13b0fb703c49e729d42c313dc901145c278
Author: Ming Lei <ming.lei@canonical.com>
Date:   Mon Aug 20 19:04:15 2012 +0800

    firmware loader: fix firmware -ENOENT situations

    If the requested firmware image doesn't exist, firmware->priv
    should be set for the later concurrent requests, otherwise
    warning and oops will be triggered inside firmware_free_data().

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 529f2b00940c82abdf17bdc902e2b02d1904a789
Author: Ming Lei <ming.lei@canonical.com>
Date:   Fri Aug 17 22:07:00 2012 +0800

    firmware loader: fix build failure if FW_LOADER is m

    device_cache_fw_images need to iterate devices in system,
    so this patch applies the introduced dpm_for_each_dev to
    avoid link failure if CONFIG_FW_LOADER is m.

    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit e51f2ca3d0d22b9cd08b6262d6e8423888a339e6
Author: Ming Lei <ming.lei@canonical.com>
Date:   Fri Aug 17 22:06:58 2012 +0800

    firmware loader: fix compile failure if !PM

    'return 0' should be added to fw_pm_notify if !PM because
    return value of the funcion is defined as 'int'.

    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 402bbcd0a468c1388fe9fd98a6bd0d4d57f1f5e4
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:29 2012 +0800

    firmware loader: cache devices firmware during suspend/resume cycle

    This patch implements caching devices' firmware automatically
    during system syspend/resume cycle, so any device drivers can
    call request_firmware or request_firmware_nowait inside resume
    path to get the cached firmware if they have loaded firmwares
    successfully at least once before entering suspend.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 6b5ef252737d7e46cee1471de1f8f778816ed432
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:28 2012 +0800

    firmware loader: use small timeout for cache device firmware

    Because device_cache_fw_images only cache the firmware which has been
    loaded sucessfully at leat once, using a small loading timeout should
    be reasonable.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3a78247eb488608da2dbf2c0b5f312abc7fb36bf
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:27 2012 +0800

    firmware: introduce device_cache/uncache_fw_images

    This patch introduces the three helpers below:

    	void device_cache_fw_images(void)
    	void device_uncache_fw_images(void)
    	void device_uncache_fw_images_delay(unsigned long)

    so we can use device_cache_fw_images() to cache firmware for
    all devices which need firmware to work, and the device driver
    can get the firmware easily from kernel memory when system isn't
    ready for completing requests of loading firmware.

    After system is ready for completing firmware loading, driver core
    will call device_uncache_fw_images() or its delay version to free
    the cached firmware.

    The above helpers will be used to cache device firmware during
    system suspend/resume cycle in the following patches.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit fec2fa2ad35e9b5ac3b556b57f2ce0d93d88dad3
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:25 2012 +0800

    firmware loader: store firmware name into devres list

    This patch will store firmware name into devres list of the device
    which is requesting firmware loading, so that we can implement
    auto cache and uncache firmware for devices in need.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 82502e82fdb519661d280f9a2ff7888a7e11719d
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:24 2012 +0800

    firmware loader: fix comments on request_firmware_nowait

    request_firmware_nowait is allowed to be called in atomic
    context now if @gfp is GFP_ATOMIC, so fix the obsolete
    comments and states which situations are suitable for using
    it.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 885f2a4d3e79590a5ac56c600ef21c7f33edf1ff
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:23 2012 +0800

    firmware loader: fix device lifetime

    Callers of request_firmware* must hold the reference count of
    @device, otherwise it is easy to trigger oops since the firmware
    loader device is the child of @device.

    This patch adds comments about the usage. In fact, most of drivers
    call request_firmware* in its probe() or open(), so the constraint
    should be reasonable and can be satisfied.

    Also this patch holds the reference count of @device before
    schedule_work() in request_firmware_nowait() to avoid that
    the @device is released after request_firmware_nowait returns
    and before the worker function is scheduled.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f8c40c19896e07c5e24596d1c73e0004b83bf564
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:22 2012 +0800

    firmware loader: introduce cache_firmware and uncache_firmware

    This patches introduce two kernel APIs of cache_firmware and
    uncache_firmware, both of which take the firmware file name
    as the only parameter.

    So any drivers can call cache_firmware to cache the specified
    firmware file into kernel memory, and can use the cached firmware
    in situations which can't request firmware from user space.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 33f7f4606f2add663f0f055d9e22224b2ed927e6
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:21 2012 +0800

    firmware loader: always let firmware_buf own the pages buffer

    This patch always let firmware_buf own the pages buffer allocated
    inside firmware_data_write, and add all instances of firmware_buf
    into the firmware cache global list. Also introduce one private field
    in 'struct firmware', so release_firmware will see the instance of
    firmware_buf associated with the current firmware instance, then just
    'free' the instance of firmware_buf.

    The firmware_buf instance represents one pages buffer for one
    firmware image, so lots of firmware loading requests can share
    the same firmware_buf instance if they request the same firmware
    image file.

    This patch will make implementation of the following cache_firmware/
    uncache_firmware very easy and simple.

    In fact, the patch improves request_formware/release_firmware:

            - only request userspace to write firmware image once if
    	several devices share one same firmware image and its drivers
    	call request_firmware concurrently.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 23f444643c50ab3dc66e2cd699ef03d90dbdccc8
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:20 2012 +0800

    firmware loader: introduce firmware_buf

    This patch introduces struct firmware_buf to describe the buffer
    which holds the firmware data, which will make the following
    cache_firmware/uncache_firmware implemented easily.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c341f46309619686830be4b608c9db06b68bafc1
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:19 2012 +0800

    firmware loader: fix creation failure of fw loader device

    If one device driver calls request_firmware_nowait() to request
    several different firmwares' loading, device_add() will return
    failure since all firmware loader device use same name of the
    device who is requesting firmware.

    This patch always use the name of firmware image as the firmware
    loader device name to fix the problem since the following patches
    for caching firmware will make sure only one loading for same
    firmware is alllowd at the same time.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit fca2060e5dac12511c0860878e89e0e5ad8e7a3e
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:18 2012 +0800

    firmware loader: remove unnecessary wmb()

    The wmb() inside fw_load_abort is not necessary, since
    complete() and wait_on_completion() has implied one pair
    of memory barrier.

    Also wmb() isn't a correct usage, so just remove it.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 4eaaa8782ff182e0de3ac050aeb0305879dc89eb
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:17 2012 +0800

    firmware loader: fix races during loading firmware

    This patch fixes two races in loading firmware:

    1, FW_STATUS_DONE should be set before waking up the task waitting
    on _request_firmware_load, otherwise FW_STATUS_ABORT may be
    thought as DONE mistakenly.

    2, Inside _request_firmware_load(), there is a small window between
    wait_for_completion() and mutex_lock(&fw_lock), and 'echo 1 > loading'
    still may happen during the period, so this patch checks FW_STATUS_DONE
    to prevent pages' buffer completed from being freed in firmware_loading_store.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit dc3ca115481cc50a7d4aa866f607b470280b1e5e
Author: Ming Lei <ming.lei@canonical.com>
Date:   Sat Aug 4 12:01:16 2012 +0800

    firmware loader: simplify pages ownership transfer

    This patch doesn't transfer ownership of pages' buffer to the
    instance of firmware until the firmware loading is completed,
    which will simplify firmware_loading_store a lot, so help
    to introduce the following cache_firmware and uncache_firmware
    mechanism during system suspend-resume cycle.

    In fact, this patch fixes one bug: if writing data into
    firmware loader device is bypassed between writting 1 and 0 to
    'loading', OOPS will be triggered without the patch.

    Also handle the vmap failure case, and add some comments to make
    code more readable.

    Signed-off-by: Ming Lei <ming.lei@canonical.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit e728c819e3666bb37e08a49255b24e6933bb72e5
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Tue Jul 3 18:49:36 2012 +0200

    driver-core: Use kobj_to_dev instead of re-implementing it

    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/firmware_class/README |    7 +
 drivers/base/Kconfig                |   11 +
 drivers/base/core.c                 |   17 +-
 drivers/base/devres.c               |   77 +++
 drivers/base/firmware_class.c       | 1216 +++++++++++++++++++++++++++++------
 drivers/base/power/main.c           |   22 +
 include/linux/device.h              |    6 +
 include/linux/firmware.h            |   15 +
 include/linux/pm.h                  |    5 +
 9 files changed, 1177 insertions(+), 199 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 7c96a3a..b7af956 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -145,6 +145,17 @@ config EXTRA_FIRMWARE_DIR
 	  this option you can point it elsewhere, such as /lib/firmware/ or
 	  some other directory containing the firmware files.
 
+config FW_LOADER_USER_HELPER
+	bool "Fallback user-helper invocation for firmware loading"
+	depends on FW_LOADER
+	default y
+	help
+	  This option enables / disables the invocation of user-helper
+	  (e.g. udev) for loading firmware files as a fallback after the
+	  direct file loading in kernel fails.  The user-mode helper is
+	  no longer required unless you have a special firmware file that
+	  resides in a non-standard path.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
-- 
2.1.3

