# This software is released by copyright@mzpqnxow.com under the terms of the
# BSD 3-clause license. Please see LICENSE for more information.

# Portions of this repository contain GPL code released by Broadcom

#
# This is really ugly, it creates a docker container with Broadcom HND tools
# toolchains for MIPSEL architecture. Because the fine engineers at BRCM built
# hardcoded path dependencies into their toolchain, some hoops have to be jumped
# through with symlinks and such
#
# Once the container is built, the user logs in as toolchain-user in ~/toolchains
# where they have various `activate` scripts that they can source. Once sourced,
# the environment is set to use that specific HND tools toolchain meaning that
# basic commands like gcc, ld, as, etc. will work as well as the special alias
# named `cross_configure`:
#
# alias cross_configure='./configure --host=mipsel-linux \
#		--prefix=/projects/hnd/tools/linux/3.2.3/hndtools-mipsel-linux-3.2.3'
#
# This makes it a breeze to compile things by hand or to build packages that use configure
#
#
FROM ubuntu:xenial
MAINTAINER copyright@mzpqnxow.com
USER root
# Most old toolchains are 32-bit ELF so a 32-bit linker/loader and some 32-bit libs are required
RUN dpkg --add-architecture i386 && \
	apt-get update && \
  apt-get install -y \
  	net-tools \
  	file \
  	libpcap0.8 \
  	libc6:i386 \
  	libgcc1:i386 \
  	libelf1:i386 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ADD files/bashrc /root/.bashrc
RUN useradd -m -d /home/toolchain-user -s /bin/bash toolchain-user

# Prepare entry-point for a user
USER toolchain-user
ADD files/bashrc /home/toolchain-user/.bashrc

USER root

# Create the hardcoded paths that Broadcom has embedded into their toolchains
RUN mkdir -p /projects/hnd/tools/linux && mkdir -p /opt/brcm
ADD hndtools-packages/hndtools-mipsel-linux-uclibc-4.2.3.tar.xz /projects/hnd/tools/linux/
ADD hndtools-packages/hndtools-mipsel-linux-3.2.3.tar.xz /projects/hnd/tools/linux/
ADD hndtools-packages/hndtools-arm-linux-2.6.36-uclibc-4.5.3.tar.xz /projects/hnd/tools/linux


# --- 3.2.3 toolchain workaround ---
# The 3.2.3 toolchain actually consists of two directories, not the usual single directory
# To deal with it, extract the tarball and essentially remove/collapse the top level directory
# to leave the two children directories where the parent was
RUN mv /projects/hnd/tools/linux/hndtools-mipsel-linux-3.2.3/ \
	/projects/hnd/tools/linux/hndtools-mipsel-uclibc-3.2.3.tmp
RUN mv /projects/hnd/tools/linux/hndtools-mipsel-uclibc-3.2.3.tmp/hndtools-mipsel-linux-3.2.3 \
	/projects/hnd/tools/linux/
RUN mv /projects/hnd/tools/linux/hndtools-mipsel-uclibc-3.2.3.tmp/hndtools-mipsel-uclibc-3.2.3 \
	/projects/hnd/tools/linux/
# Delete empty (old) parent directory
RUN rm -rf /projects/hnd/tools/linux/hndtools-mipsel-uclibc-3.2.3.tmp/
# Final symlink required because Broadcom hard-coded /opt/brcm into this toolchain
RUN ln -sf /projects/hnd/tools/linux/hndtools-mipsel-linux-3.2.3/ /opt/brcm/

# Clean up permissions and add some symlinks
ADD files/activate-generic-toolchain.env /projects/hnd/tools/linux/hndtools-mipsel-linux-3.2.3/activate
ADD files/activate-generic-toolchain.env /projects/hnd/tools/linux/hndtools-mipsel-linux-uclibc-4.2.3/activate
ADD files/activate-generic-toolchain.env /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3/activate
ADD files/test-toolchains.sh /home/toolchain-user/
WORKDIR /home/toolchain-user/toolchains
RUN ln -sf /projects/hnd/tools/linux/hndtools-mipsel-linux-3.2.3/activate \
	hndtools-mipsel-3.2.3.activate 
RUN ln -sf /projects/hnd/tools/linux/hndtools-mipsel-linux-uclibc-4.2.3/activate \
	hndtools-mipsel-4.2.3.activate
RUN ln -sf /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3/activate \
	hndtools-arm-4.5.3.activate
RUN chown -R toolchain-user.toolchain-user \
	/home/toolchain-user \
	/projects/hnd/ \
	/opt/brcm

USER toolchain-user
CMD ["/bin/bash", "--login"]