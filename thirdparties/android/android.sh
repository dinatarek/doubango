#!/bin/bash

export NDK=/home/android-ndk-r10e
export PREFIX_BASE=/home/openssl-1.0.1t/android
export HOST=arm-linux-androideabi
export CPU=ARM

if [ w$1 = "wx86" ]
then
	echo "************************"
	echo "           X86          "
	echo "************************"
	export HOST=i686-linux-android
	export CPU=x86
	export SYSROOT=$NDK/platforms/android-9/arch-x86
	export ANDROID_TOOLCHAIN=$(pwd)/my-android-toolchain-android-x86
	$NDK/build/tools/make-standalone-toolchain.sh --arch=x86 --platform=android-9 --arch=x86 --install-dir=$ANDROID_TOOLCHAIN
	export CFLAGS='-fPIC' # For FFmpeg: '-fno-PIC'
	export LDFLAGS=''
	export OS=android-x86
elif [ w$1 = "warmv7a" ]
then
	echo "************************"
	echo "           ARMv7-a      "
	echo "************************"
	export HOST=arm-linux-androideabi
	export CPU=armv7-a
	export SYSROOT=$NDK/platforms/android-3/arch-arm
	export ANDROID_TOOLCHAIN=$(pwd)/my-android-toolchain-android-armv7-a
    	$NDK/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-3 --install-dir=$ANDROID_TOOLCHAIN
    	export CFLAGS='-march=armv7-a -mfloat-abi=softfp -fPIC'
    	export LDFLAGS='-Wl,--fix-cortex-a8'
	export OS=android-armv7
elif [ w$1 = "wneon" ]
then
	echo "************************"
	echo "           NEON         "
	echo "************************"
	export HOST=arm-linux-androideabi
	export CPU=armv7-a-neon
	export SYSROOT=$NDK/platforms/android-3/arch-arm
    	export ANDROID_TOOLCHAIN=$(pwd)/my-android-toolchain-android-armv7-a-neon
    	$NDK/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-3 --install-dir=$ANDROID_TOOLCHAIN
    	export CFLAGS='-march=armv7-a -mfloat-abi=softfp -mfpu=neon -fPIC'
    	export LDFLAGS='-Wl,--fix-cortex-a8'
	export OS=android-armv7
else
	echo "************************"
	echo "           ARMv5TE      "
	echo "************************"
	export HOST=arm-linux-androideabi
	export CPU=armv5te
	export SYSROOT=$NDK/platforms/android-3/arch-arm
	export ANDROID_TOOLCHAIN=$(pwd)/my-android-toolchain-armv5te
    	$NDK/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-3 --install-dir=$ANDROID_TOOLCHAIN
	export CFLAGS='-fPIC'
	export LDFLAGS=''
	export OS=android
fi


### COMMON ###
export PATH=$ANDROID_TOOLCHAIN/bin:$PATH
export CC=$ANDROID_TOOLCHAIN/bin/$HOST-gcc
export AR=$ANDROID_TOOLCHAIN/bin/$HOST-ar
export CXX=$ANDROID_TOOLCHAIN/bin/$HOST-g++
#export AS=$ANDROID_TOOLCHAIN/bin/$HOST-as
export AS=$ANDROID_TOOLCHAIN/bin/$HOST-gcc
export RANLIB=$ANDROID_TOOLCHAIN/bin/$HOST-ranlib

./Configure --prefix=$PREFIX_BASE/$CPU --openssldir=$PREFIX_BASE/$CPU/openssl $OS
make clean
make

