#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.
 set -x
set -e
set -u
OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.1.10
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

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
    make -j 56 ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- all
    make -j 56 ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- modules
    make -j 56 ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE dtbs
fi

echo "Adding the Image in outdir"
cd "$OUTDIR"
cp  ${OUTDIR}/linux-stable/arch/arm64/boot/Image ${OUTDIR}/
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
    make defconfig
else
    cd busybox
fi

# TODO: Make and install busybox
make -j 56 ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
make -j 56 CONFIG_PREFIX=${OUTDIR}/rootfs ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} install

# TODO: Add library dependencies to rootfs
echo "Library dependencies"
cd "$OUTDIR/rootfs"
SYSROOT=$(${CROSS_COMPILE}gcc -print-sysroot)
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libm.so.6 lib
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libc.so.6 lib
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/libresolv-2.31.so lib
cp -a /usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/../aarch64-none-linux-gnu/libc/lib64/ld-2.31.so lib
cp -a $SYSROOT/lib/ld-linux-aarch64.so.1 lib
cp -a $SYSROOT/lib64/ld-2.31.so lib64
cp -a $SYSROOT/lib64/libm.so.6 lib64
cp -a $SYSROOT/lib64/libm-2.31.so lib64
cp -a $SYSROOT/lib64/libresolv.so.2 lib64
cp -a $SYSROOT/lib64/libresolv-2.31.so lib64
cp -a $SYSROOT/lib64/libc.so.6 lib64
cp -a $SYSROOT/lib64/libc-2.31.so lib64
cd "$OUTDIR/rootfs"

sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 600 dev/console c 5 1
# sudo mknod -m 666 dev/Console c 1 5
sudo mknod -m 600 dev/tty c 5 1
# # TODO: Clean and build the writer utility
cd $FINDER_APP_DIR
make clean
make -j ARCH=${ARCH} CROSS_COMPILE=$CROSS_COMPILE all
# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs

mkdir -p $OUTDIR/rootfs/home
 cp finder $OUTDIR/rootfs/home
 cp writer $OUTDIR/rootfs/home
  cp writer.sh $OUTDIR/rootfs/home
 cp finder.sh $OUTDIR/rootfs/home
 cp finder-test.sh $OUTDIR/rootfs/home
 cp -r conf/ $OUTDIR/rootfs/home
 cp ../conf/username.txt $OUTDIR/rootfs/home
 cp autorun-qemu.sh $OUTDIR/rootfs/home
 cp -f autorun-qemu.sh $OUTDIR/rootfs/
cp -f ${FINDER_APP_DIR}/autorun-qemu.sh ${OUTDIR}/rootfs/home

# TODO: Chown the root directory
cd "$OUTDIR/rootfs"

sudo chown -R root:root *
# TODO: Create initramfs.cpio.gz
find . |cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
cd "$OUTDIR"
gzip -f initramfs.cpio
# sleep 900