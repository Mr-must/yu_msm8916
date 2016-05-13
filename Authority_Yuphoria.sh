 #
 # Copyright © 2016, Aayush Jain   "AayushJainRd7"   <aayush835@gmail.com>
 #
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/dtbToolCM
TOOLCHAIN_DIR=/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export ARCH=arm64
export CCOMPILE=$CROSS_COMPILE
export CROSS_COMPILE=aarch64-linux-android-
export PATH=$PATH:/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin
export KBUILD_BUILD_USER="AayushRd7"
export KBUILD_BUILD_HOST="Authority_Kernel"
STRIP="/home/aayushrd7/UBERTC-aarch64-linux-android-5.3-kernel-1144fd2773c1/bin/aarch64-linux-android-strip"
MODULES_DIR=$KERNEL_DIR/drivers/staging/prima
OUT_DIR=/home/aayushrd7/yu_msm8916/Lettuce

compile_kernel ()
{
rm -f $KERN_IMG
make cyanogenmod_lettuce-64_defconfig
echo -e 
make -j5
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
echo -e  
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
}

authority ()
{
case $1 in
clean)
make ARCH=arm64 -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
*)
compile_kernel
;;
esac

rm -rf $OUT_DIR/AuthorityKernel*.zip
rm -rf $OUT_DIR/tools/*
rm -rf $OUT_DIR/system/lib/modules/*
cp -r $KERNEL_DIR/Authority/tools $OUT_DIR
cp $KERNEL_DIR/arch/arm64/boot/Image  $OUT_DIR/tools
cp $KERNEL_DIR/arch/arm64/boot/dt.img  $OUT_DIR/tools
mv $OUT_DIR/tools/Image $OUT_DIR/tools/zImage
cd $OUT_DIR
}

authority
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow BUILD SUCEEDED IN $(($DIFF / 60)) MINUTE(S) and $(($DIFF % 60)) SECONDS.$nocol"
