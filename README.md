# Building curl, openssl, and zlib for android

This repo has been made to help building curl, openssl, and zlib libraries for android.

## Prerequisites

- automake tools
- android ndk

## Steps

- Clone this repo

		git clone https://github.com/MajdiSobain/build-curl-openssl-zlib-android.git

- cd into repo folder

		cd build-curl-openssl-zlib-android

- Update submodules of this repo

		git submodule update --init --recursive

- cd into building scripts folder

		cd building-scripts

- If you want to build just one library you can run its builing script. But if you want to build libcurl with zlib and ssl feature enbaled you must build zlib and openssl before curl. Next are script usage prototypes:

		$ ./build-zlib.sh path/to/ndk [api=21 [arch=arm]]
		
		$ ./build-openssl.sh path/to/ndk [api=21 [arch=arm]]
		
		$ ./build-curl.sh path/to/ndk [api=21] [arch=arm] [no-ssl] [no-zlib]


## Scripts Usage notes

### zlib

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
	###################################################################################

### openssl

	#################################################################################
	#
	#    build-openssl.sh usage:
	#
	#	$ ./build-openssl.sh path/to/ndk [api=21 [arch=arm]]
	#
	#	- path/to/ndk:	the absolute path to the android NDK folder (obligatory)
	#	- api=21:	specify the version number of android API 9, 12, ...
	#	- arch=arm:	specify the target arch that openssl is going to 
	#			run on. It should be one of:
	#			{arm, arm64, mips, mips64, x86, x86_64}
	#	Note: Arguments order should stictly be followed
	#
	##################################################################################

### curl

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
	##################################################################################


Enjoy :)
