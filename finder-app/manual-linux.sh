#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.
 
set -e
set -u
set -x
OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.1.10
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
# ARCH=aarch64-none-linux-gnu-
CROSS_COMPILE=aarch64-none-linux-gnu-
CROSS_COMPILE2=aarch64-linux-gnu-
# FINDER_APP_DIR
if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}
    #sed -i '41d' $OUTDIR/linux-stable/scripts/dtc/dtc-lexer.l
    # TODO: Add your kernel build steps here
    # make defconfig ARCH=$ARCH
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE defconfig
    make -j 56 ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE
    # make -j 56 CROSS_COMPILE=$CROSS_COMPILE
    # make -j 56 ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-defconfig-
    # make -j ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
    # make qemu_virt_defconfig; 
    # make -j ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
    # make -j ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- all
    # make -j ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- modules
    make -j ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE dtbs
fi

echo "Adding the Image in outdir"
cd "$OUTDIR"
cp  $OUTDIR/linux-stable/arch/arm64/boot/Image $OUTDIR/Image
echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm  -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories
mkdir rootfs
cd ${OUTDIR}/rootfs
mkdir -p bin dev etc home lib lib64 proc sbin sys tmp usr var
mkdir -p usr/bin usr/lib usr/sbin
mkdir -p var/log

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
    make -j distclean
    make defconfig ARCH=arm64
    sudo make -j CONFIG_PREFIX=${OUTDIR}/rootfs ARCH=${ARCH} install
else
    cd busybox
fi

# TODO: Make and install busybox
# sudo make -j ARCH=${ARCH} CROSS_COMPILE=arm-unknown-linux-gnueabi- install
# sudo make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
sudo make -j CONFIG_PREFIX=${OUTDIR}/rootfs ARCH=${ARCH} install

# TODO: Add library dependencies to rootfs
echo "Library dependencies"
#  ls -l ${OUTDIR}/rootfs
#  sleep 3
#  ls -l ${OUTDIR}/rootfs/bin
#  sleep 3
#  ${CROSS_COMPILE}readelf -a $OUTDIR/rootfs/bin/busybox | grep "program interpreter"
#  sleep 3
#  ${CROSS_COMPILE}readelf -a $OUTDIR/rootfs/bin/busybox | grep "Shared library"
#  sleep 3
 cd "$OUTDIR/rootfs"
#  grep -ir \.so $OUTDIR
# ls -l $OUTDIR/lib
# sleep 3
# ls -l /
# sleep 3
# ls -l /home
# sleep 3
# ls -l /home/autotest-admin
# sleep 3
# ls -l /lib
# sleep 3
# ls -l /usr/lib
# sleep 3
# echo looking for libm.so.6, libresolv.so.2 libc.so.6
# which ${CROSS_COMPILE}gcc
# ls -l /usr/lib64
# sleep 3
# cp -a $OUTDIR/lib/ld-linux-armf.so.3 lib
# cp -a $OUTDIR/lib/ld-2.22.so lib



# ls -l /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/
# sleep 20
# ls -l /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/lib
# sleep 20
# ls -l /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/lib64
# sleep 20
# ls -l /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/libexec
# sleep 20
# ls -l /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/include



# sleep 200000
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libm.so.6 lib
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libc.so.6 lib
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libresolv-2.31.so lib
# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/aarch64-none-linux-gnu/libc/lib64/libresolv-2.31.so lib
# cp -a /usr/lib/x86_64-linux-gnu/libm.so lib
# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/aarch64-none-linux-gnu/libc/usr/lib64/libc.so lib
# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/lib64/libcc1.so.0.0.0 lib

# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/lib64/libm.so lib
# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/lib64/libc.so lib
# cp -a $CROSS_COMPILE/lib/libc-2.22.so lib
# cp -a $OUTDIR/lib/libm.so.6 lib
# cp -a $OUTDIR/lib/libm-2.22.so lib
# cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/libc/lib64/libresolv-2.31.so lib
# cp -a $OUTDIR/lib/libc

# arm-unknown-linux-gnueabi- readelf -a /bin/busybox | grep "Shared library"
# TODO: Make device nodes
cd "$OUTDIR/rootfs"
# mkdir bin dev etc home lib proc sbin sys tmp usr var
# mkdir usr/bin usr/lib usr/sbin
# mkir -p var/log
# rm dev/*
sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 666 dev/console c 5 1
sudo mknod -m 666 dev/Console c 1 5
sudo mknod -m 666 dev/tty c 1 5
# # TODO: Clean and build the writer utility
cd $FINDER_APP_DIR
# make clean e modules_install step discus
make -j ARCH=${ARCH} CROSS_COMPILE=$CROSS_COMPILE
# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs
sudo mkdir -p $OUTDIR/rootfs/home
sudo  cp finder $OUTDIR/rootfs/home
sudo cp writer $OUTDIR/rootfs/home
sudo cp finder.sh $OUTDIR/rootfs/home
sudo cp ../conf/username.txt $OUTDIR/rootfs/home 
sudo cp autorun-qemu.sh $OUTDIR/rootfs/home
# TODO: Chown the root directory
cd "$OUTDIR/rootfs"

sudo chown -R root:root *
# TODO: Create initramfs.cpio.gz
# cd rootfs
find . |cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
cd "$OUTDIR"
gzip -f initramfs.cpio
# mkdir -p Image
# cp initramfs.cpio.gz Image 
cd $FINDER_APP_DIR
./start-qemu-terminal.sh $OUTDIR
