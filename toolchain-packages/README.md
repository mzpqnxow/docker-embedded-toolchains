# Table of Contents

## Toolchains for RTL819X chips (Lexra branded)

The following toolchains are prebuilt from Realtek and produce MIPS-I MSB executables compatible with Lexra MIPS chips which do not support unaligned load and store operations for obscure patent reasons

* rsdk-1.3.6-4181-EB-2.6.30-0.9.30
* rsdk-1.3.6-5281-EB-2.6.30-0.9.30
* rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714

### Boards supported by RSDK toolchains

* RTL8196C
* RTL8196E
* RTL8196EU
* ERL8198
* RTL819xD

### CPU Models / Versions Supported by RSDK 1.3.6

The following chips are explicitly supported by the 1.3.6 releases

* LX4180 up to RTL release 4.0.2
* RLX4181 up to RTL release 1.0
* LX5280 up to RTL release 1.9.3
* RLX5181 up to RTL release 1.1

### CPU Models / Versions Supported by RSDK 1.5.5

The following are explicitly supported by the 1.5.5 release

* LX4180 all versions 
* RLX4181 all versions
* LX5280 all versions
* RLX5181 all versions
* RLX4281 all versions
* RLX5281 all versions


## Toolchains from Broadcom for ARM and MIPSEL chips (HNDTOOLS)

The following toolchains are prebuilt by Broadcom and can be used to built MIPSEL and ARM executables for several different chipsets

* hndtools-arm-linux-2.6.36-uclibc-4.5.3
* hndtools-mipsel-3.2.3
* hndtools-mipsel-linux-uclibc-4.2.3

## Toolchain for ARM "old" ABI

The following toolchain will produce ELF executables with the "old" ARM ABI which is no longer supported. It is useful on rare (old) embedded Linux devices

* arm-linux-oabi-gcc-glibc.tar.xz
