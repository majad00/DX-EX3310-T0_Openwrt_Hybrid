cmd_util-linux/volume_id/reiserfs.o := mips-openwrt-linux-uclibc-gcc -Wp,-MD,util-linux/volume_id/.reiserfs.o.d  -std=gnu99 -Iinclude -Ilibbb  -include include/autoconf.h -D_GNU_SOURCE -DNDEBUG -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DBB_VER='"1.36.1"' -Wall -Wshadow -Wwrite-strings -Wundef -Wstrict-prototypes -Wunused -Wunused-parameter -Wunused-function -Wunused-value -Wmissing-prototypes -Wmissing-declarations -Wno-format-security -Wdeclaration-after-statement -Wold-style-definition -finline-limit=0 -fno-builtin-strlen -fomit-frame-pointer -ffunction-sections -fdata-sections -fno-guess-branch-probability -funsigned-char -static-libgcc -falign-functions=1 -falign-jumps=1 -falign-labels=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-builtin-printf -Os -march=mips32r2 -msoft-float    -DKBUILD_BASENAME='"reiserfs"'  -DKBUILD_MODNAME='"reiserfs"' -c -o util-linux/volume_id/reiserfs.o util-linux/volume_id/reiserfs.c

deps_util-linux/volume_id/reiserfs.o := \
  util-linux/volume_id/reiserfs.c \
    $(wildcard include/config/feature/volumeid/reiserfs.h) \
    $(wildcard include/config/feature/blkid/type.h) \
  util-linux/volume_id/volume_id_internal.h \
  include/libbb.h \
    $(wildcard include/config/feature/shadowpasswds.h) \
    $(wildcard include/config/use/bb/shadow.h) \
    $(wildcard include/config/selinux.h) \
    $(wildcard include/config/feature/utmp.h) \
    $(wildcard include/config/locale/support.h) \
    $(wildcard include/config/use/bb/pwd/grp.h) \
    $(wildcard include/config/lfs.h) \
    $(wildcard include/config/feature/buffers/go/on/stack.h) \
    $(wildcard include/config/feature/buffers/go/in/bss.h) \
    $(wildcard include/config/extra/cflags.h) \
    $(wildcard include/config/variable/arch/pagesize.h) \
    $(wildcard include/config/feature/verbose.h) \
    $(wildcard include/config/feature/etc/services.h) \
    $(wildcard include/config/feature/ipv6.h) \
    $(wildcard include/config/feature/seamless/xz.h) \
    $(wildcard include/config/feature/seamless/lzma.h) \
    $(wildcard include/config/feature/seamless/bz2.h) \
    $(wildcard include/config/feature/seamless/gz.h) \
    $(wildcard include/config/feature/seamless/z.h) \
    $(wildcard include/config/float/duration.h) \
    $(wildcard include/config/feature/check/names.h) \
    $(wildcard include/config/feature/prefer/applets.h) \
    $(wildcard include/config/long/opts.h) \
    $(wildcard include/config/feature/pidfile.h) \
    $(wildcard include/config/feature/syslog.h) \
    $(wildcard include/config/feature/syslog/info.h) \
    $(wildcard include/config/warn/simple/msg.h) \
    $(wildcard include/config/feature/individual.h) \
    $(wildcard include/config/shell/ash.h) \
    $(wildcard include/config/shell/hush.h) \
    $(wildcard include/config/echo.h) \
    $(wildcard include/config/sleep.h) \
    $(wildcard include/config/printf.h) \
    $(wildcard include/config/test.h) \
    $(wildcard include/config/test1.h) \
    $(wildcard include/config/test2.h) \
    $(wildcard include/config/kill.h) \
    $(wildcard include/config/killall.h) \
    $(wildcard include/config/killall5.h) \
    $(wildcard include/config/chown.h) \
    $(wildcard include/config/ls.h) \
    $(wildcard include/config/xxx.h) \
    $(wildcard include/config/route.h) \
    $(wildcard include/config/feature/hwib.h) \
    $(wildcard include/config/desktop.h) \
    $(wildcard include/config/feature/crond/d.h) \
    $(wildcard include/config/feature/setpriv/capabilities.h) \
    $(wildcard include/config/run/init.h) \
    $(wildcard include/config/feature/securetty.h) \
    $(wildcard include/config/pam.h) \
    $(wildcard include/config/use/bb/crypt.h) \
    $(wildcard include/config/feature/adduser/to/group.h) \
    $(wildcard include/config/feature/del/user/from/group.h) \
    $(wildcard include/config/ioctl/hex2str/error.h) \
    $(wildcard include/config/feature/editing.h) \
    $(wildcard include/config/feature/editing/history.h) \
    $(wildcard include/config/feature/tab/completion.h) \
    $(wildcard include/config/feature/username/completion.h) \
    $(wildcard include/config/feature/editing/fancy/prompt.h) \
    $(wildcard include/config/feature/editing/savehistory.h) \
    $(wildcard include/config/feature/editing/vi.h) \
    $(wildcard include/config/feature/editing/save/on/exit.h) \
    $(wildcard include/config/pmap.h) \
    $(wildcard include/config/feature/show/threads.h) \
    $(wildcard include/config/feature/ps/additional/columns.h) \
    $(wildcard include/config/feature/topmem.h) \
    $(wildcard include/config/feature/top/smp/process.h) \
    $(wildcard include/config/pgrep.h) \
    $(wildcard include/config/pkill.h) \
    $(wildcard include/config/pidof.h) \
    $(wildcard include/config/sestatus.h) \
    $(wildcard include/config/unicode/support.h) \
    $(wildcard include/config/feature/mtab/support.h) \
    $(wildcard include/config/feature/clean/up.h) \
    $(wildcard include/config/feature/devfs.h) \
  include/platform.h \
    $(wildcard include/config/werror.h) \
    $(wildcard include/config/big/endian.h) \
    $(wildcard include/config/little/endian.h) \
    $(wildcard include/config/nommu.h) \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include-fixed/limits.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include-fixed/syslimits.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/limits.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/features.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_config.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/cdefs.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/posix1_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/local_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/linux/limits.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_local_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/posix2_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/xopen_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/stdio_lim.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/byteswap.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/byteswap.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/byteswap-common.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/endian.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/endian.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include/stdint.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/stdint.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/wchar.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/wordsize.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include/stdbool.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/unistd.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/posix_opt.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/environments.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/types.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include/stddef.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/typesizes.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/pthreadtypes.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sgidefs.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/confname.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/getopt.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/ctype.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_touplow.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/dirent.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/dirent.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/linux/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm-generic/errno-base.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/syscall.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sysnum.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/fcntl.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/fcntl.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/types.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/time.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/select.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/select.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sigset.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/time.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/sysmacros.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uio.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/stat.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/stat.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/inttypes.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/netdb.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/netinet/in.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/socket.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/uio.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/socket.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sockaddr.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/socket.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/sockios.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/ioctl.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm-generic/ioctl.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/in.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/siginfo.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/netdb.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/setjmp.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/setjmp.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/signal.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/signum.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sigaction.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sigcontext.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sigstack.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/ucontext.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sigthread.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/paths.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/stdio.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_stdio.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/wchar.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_mutex.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/pthread.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sched.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/sched.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_clk_tck.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_pthread.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/lib/gcc/mips-openwrt-linux-uclibc/4.8.3/include/stdarg.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/stdlib.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/waitflags.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/waitstatus.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/alloca.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/string.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/libgen.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/poll.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/poll.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/poll.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/ioctl.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/ioctls.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/ioctls.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/ioctl-types.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/ttydefaults.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/mman.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/mman.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/resource.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/resource.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/time.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/wait.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/termios.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/termios.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/param.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/linux/param.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/param.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm-generic/param.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/pwd.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/grp.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/mntent.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/statfs.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/statfs.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/utmp.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/utmp.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/arpa/inet.h \
  include/pwd_.h \
  include/grp_.h \
  include/shadow_.h \
  include/xatonum.h \
  include/volume_id.h \

util-linux/volume_id/reiserfs.o: $(deps_util-linux/volume_id/reiserfs.o)

$(deps_util-linux/volume_id/reiserfs.o):
