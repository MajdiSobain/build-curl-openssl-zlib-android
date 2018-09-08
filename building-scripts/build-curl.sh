#!/bin/bash

##################################################################################
#
#    build-curl.sh usage:
#
#	$ ./build-curl.sh path/to/ndk [api=21] [arch=arm] [no-ssl] [no-zlib]
#
#	- path/to/ndk:	the absolute path to the android NDK folder (obligatory)
#	- api=21:	specify the version number of android API 9, 12, ...
#	- arch=arm:	specify the target arch that curl is going to 
#			run on. It should be one of:
#			{arm, arm64, mips, mips64, x86, x86_64}
#	- no-ssl:	to avoid building curl with ssl
#	- no-zlib:	to avoid building curl with zlib
#
#
#		by: Majdi.Sobain@gmail.com 2018
#
##################################################################################


oldPWD=$PWD
cd ../curl
currPWD=$PWD
outputDir=$currPWD/../prebuilt-libs/curl
prebuiltLibsDir=$currPWD/../prebuilt-libs
orgPATH=$PATH
toolchainsDir=$currPWD/../toolchains
curlOptions="--disable-gopher --disable-file --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --without-gnutls --without-libidn --without-librtmp --disable-dict"

if [[ -n "$1" ]]; then
	export ANDROID_NDK=$1;
	export ANDROID_NDK=$ANDROID_NDK;
else
	echo "Error: ANDROID_NDK not set";
	exit 0;
fi

APIn=21
for arg in "$@"
do
	if [[ ${arg%=*} = "api" ]]; then
		APIn=${arg#*=};
	fi
done

archlist=$(ls $ANDROID_NDK/platforms/android-$APIn);
for arg in "$@"
do
	if [[ ${arg%=*} = "arch" ]]; then
		archlist=arch-${arg#*=};
	fi
done

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

	if [ ! -d "$toolchainsDir/android-$APIn/$ARCH" ]; then
		echo "###################################################"
		echo "#"
		echo "# Creating toolchain for android-$APIn arch $ARCH"
		echo "#"
		echo "###################################################"
		$ANDROID_NDK/build/tools/make-standalone-toolchain.sh --toolchain=$ARCHTOOLCHAIN --platform=android-$APIn --install-dir=$toolchainsDir/android-$APIn/$ARCH

	fi
	echo "###################################################"
	echo "#"
	echo "# Build curl for android-$APIn arch $ARCH"
	echo "#"
	echo "###################################################"
	make clean
	PATH=$orgPATH:$toolchainsDir/android-$APIn/$ARCH/bin
	CC=${CROSSCOMPILER}-gcc
	AR=${CROSSCOMPILER}-ar
	AS=${CROSSCOMPILER}-as
	LD=${CROSSCOMPILER}-ld
	RANLIB=${CROSSCOMPILER}-ranlib
	NM=${CROSSCOMPILER}-nm
	
	ssloption="--with-ssl=$prebuiltLibsDir/openssl/android-$APIn/$ARCH"
	zliboption="--with-zlib=$prebuiltLibsDir/zlib/android-$APIn/$ARCH"
	for opt in "$@"
	do
		if [[ $opt = "no-ssl" ]]; then
			ssloption=;
		fi
		if [[ $opt = "no-zlib" ]]; then
			zliboption=;
		fi
	done

	curlOptions="$curlOptions $ssloption $zliboption"
	./configure --host=$CROSSCOMPILER --build=x86_64-pc-linux-gnu $curlOptions --prefix=$outputDir/android-$APIn/$ARCH

	make
	make install
done


cd $oldPWD
