cmd_libbb/perror_nomsg_and_die.o := mips-openwrt-linux-uclibc-gcc -Wp,-MD,libbb/.perror_nomsg_and_die.o.d  -std=gnu99 -Iinclude -Ilibbb  -include include/autoconf.h -D_GNU_SOURCE -DNDEBUG -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DBB_VER='"1.36.1"' -Wall -Wshadow -Wwrite-strings -Wundef -Wstrict-prototypes -Wunused -Wunused-parameter -Wunused-function -Wunused-value -Wmissing-prototypes -Wmissing-declarations -Wno-format-security -Wdeclaration-after-statement -Wold-style-definition -finline-limit=0 -fno-builtin-strlen -fomit-frame-pointer -ffunction-sections -fdata-sections -fno-guess-branch-probability -funsigned-char -static-libgcc -falign-functions=1 -falign-jumps=1 -falign-labels=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-builtin-printf -Os -march=mips32r2 -msoft-float    -DKBUILD_BASENAME='"perror_nomsg_and_die"'  -DKBUILD_MODNAME='"perror_nomsg_and_die"' -c -o libbb/perror_nomsg_and_die.o libbb/perror_nomsg_and_die.c

deps_libbb/perror_nomsg_and_die.o := \
  libbb/perror_nomsg_and_die.c \
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

libbb/perror_nomsg_and_die.o: $(deps_libbb/perror_nomsg_and_die.o)

$(deps_libbb/perror_nomsg_and_die.o):
