#!/bin/bash

##################################################################################
#
#    build-zlib.sh usage:
#
#	$ ./build-zlib.sh path/to/ndk [api=21 [arch=arm]]
#
#	- path/to/ndk:	the absolute path to the android NDK folder (obligatory)
#	- api=21:	specify the version number of android API 9, 12, ...
#	- arch=arm:	specify the target arch that zlib is going to 
#			run on. It should be one of:
#			{arm, arm64, mips, mips64, x86, x86_64}
#	Note: Arguments order should stictly be followed
#
#
#		by: Majdi.Sobain@gmail.com 2018
#
###################################################################################


oldPWD=$PWD
cd ../zlib
currPWD=$PWD
outputDir=$currPWD/../prebuilt-libs/zlib
orgPATH=$PATH
if [[ -n "$1" ]]; then
	ANDROID_NDK=$1;
	export ANDROID_NDK=$ANDROID_NDK;
else
	echo "Error: ANDROID_NDK not set";
	exit 0;
fi
APIn=21
if [[ -n "$2" ]]; then 
	APIn=${2#*=};
fi
if [[ -n "$3" ]]; then
	archlist=arch-${3#*=};
else
	archlist=$(ls $ANDROID_NDK/platforms/android-$APIn);
fi

for andrarch in $archlist
do
	case $andrarch in
		arch-arm)
			ARCH=arm
			ARCHTOOLCHAIN=arm-linux-androideabi-4.9
			CROSSCOMPILER=arm-linux-androideabi
			;;
		arch-arm64)
			ARCH=arm64
			ARCHTOOLCHAIN=aarch64-linux-android-4.9
			CROSSCOMPILER=aarch64-linux-android
			;;
		arch-x86)
			ARCH=x86
			ARCHTOOLCHAIN=x86-4.9
			CROSSCOMPILER=i686-linux-android
			;;
		arch-x86_64)
			ARCH=x86_64
			ARCHTOOLCHAIN=x86_64-4.9
			CROSSCOMPILER=x86_64-linux-android
			;;
		arch-mips)
			ARCH=mips
			ARCHTOOLCHAIN=mipsel-linux-android-4.9
			CROSSCOMPILER=mipsel-linux-android
			;;
		arch-mips64)
			ARCH=mips64
			ARCHTOOLCHAIN=mips64el-linux-android-4.9
			CROSSCOMPILER=mips64el-linux-android
			;;
	esac
	echo "###################################################"
	echo "#"
	echo "# Build zlib for android-$APIn arch $ARCH"
	echo "#"
	echo "###################################################"
	make clean
	PATH=$ANDROID_NDK/toolchains/$ARCHTOOLCHAIN/prebuilt/linux-x86_64/bin:$orgPATH
	CC=${CROSSCOMPILER}-gcc
	AR=${CROSSCOMPILER}-ar
	AS=${CROSSCOMPILER}-as
	LD=${CROSSCOMPILER}-ld
	RANLIB=${CROSSCOMPILER}-ranlib
	NM=${CROSSCOMPILER}-nm
	CFLAGS="--sysroot=${ANDROID_NDK}/platforms/android-${APIn}/${andrarch}"
	./configure --prefix=$outputDir/android-$APIn/$ARCH
	make
	make install
done


cd $oldPWD
