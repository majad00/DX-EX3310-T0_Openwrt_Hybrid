cmd_libbb/ptr_to_globals.o := mips-openwrt-linux-uclibc-gcc -Wp,-MD,libbb/.ptr_to_globals.o.d  -std=gnu99 -Iinclude -Ilibbb  -include include/autoconf.h -D_GNU_SOURCE -DNDEBUG -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DBB_VER='"1.36.1"' -Wall -Wshadow -Wwrite-strings -Wundef -Wstrict-prototypes -Wunused -Wunused-parameter -Wunused-function -Wunused-value -Wmissing-prototypes -Wmissing-declarations -Wno-format-security -Wdeclaration-after-statement -Wold-style-definition -finline-limit=0 -fno-builtin-strlen -fomit-frame-pointer -ffunction-sections -fdata-sections -fno-guess-branch-probability -funsigned-char -static-libgcc -falign-functions=1 -falign-jumps=1 -falign-labels=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-builtin-printf -Os -march=mips32r2 -msoft-float    -DKBUILD_BASENAME='"ptr_to_globals"'  -DKBUILD_MODNAME='"ptr_to_globals"' -c -o libbb/ptr_to_globals.o libbb/ptr_to_globals.c

deps_libbb/ptr_to_globals.o := \
  libbb/ptr_to_globals.c \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/features.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/uClibc_config.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/sys/cdefs.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/bits/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/linux/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm/errno.h \
  /home/majad/OpenWrt/wsr30/openwrt_rtk/rtk_openwrt_sdk/ex3301/xx3301/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/include/asm-generic/errno-base.h \

libbb/ptr_to_globals.o: $(deps_libbb/ptr_to_globals.o)

$(deps_libbb/ptr_to_globals.o):
