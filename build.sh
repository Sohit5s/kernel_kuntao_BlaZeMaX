#!/bin/bash
#
# Copyright © 2018, "Vipul Jha" aka "LordArcadius" <vipuljha08@gmail.com>
# Copyright © 2018, "penglezos" <panagiotisegl@gmail.com>
# Copyright © 2018, "reza adi pangestu" <rezaadipangestu385@gmail.com>
# Copyright © 2018, "beamguide" <beamguide@gmail.com>

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
green='\e[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
purple='\e[0;35m'
white='\e[0;37m'

KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/zip
OUT=$KERNEL_DIR/out
ZIP_NAME="$VERSION"-"$DATE"
VERSION="kuntao-2.7"
DATE=$(date +%Y%m%d-%H%M)

export KBUILD_BUILD_USER=Abhat27
export KBUILD_BUILD_HOST=server
export ARCH=arm64
export SUBARCH=arm64
export USE_CCACHE=1
export CLANG_PATH=/home/Abhat27/kernel/clang-kernel-build
export PATH=${CLANG_PATH}:${PATH}
export CROSS_COMPILE=/home/darkx27/kernel/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_TCHAIN="/home/darkx27/kernel/clang-kernel-build"
export KBUILD_COMPILER_STRING="$(${CLANG_TCHAIN} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"

make_zip()
{
		cd $REPACK_DIR
		cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR/
		FINAL_ZIP="WolFx_Kernel-r6-${VERSION}-${DATE}.zip"
        zip -r9 "${FINAL_ZIP}" *
		cp *.zip $OUT
		rm *.zip
		cd $KERNEL_DIR
		rm out/arch/arm64/boot/Image.gz-dtb
}

rm -rf out
mkdir -p out
make clean O=out/
make mrproper O=out/
make kuntao_defconfig O=out/
make -j$(nproc --all) O=out/
make_zip

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
rm zip/Image.gz-dtb
echo -e ""
echo -e ""
echo -e "${red}/**      /**           /**       /********        "
echo -e "${green}| **  /* | **          | **      | **_____/       "
echo -e "${blue}| ** /***| **  /****** | **      | **    /**        "
echo -e "${yellow}| **/** ** ** /**__  **| **      | *****|  ** /**/        "
echo -e "${green}| ****_  ****| **  \ **| **      | **__/ \  ****/         "
echo -e "${red}| ***/ \  ***| **  | **| **      | **     >**  **    "
echo -e "${purple}| **/   \  **|  ******/| ********| **    /**/\  **        "
echo -e "${cyan}|__/     \__/ \______/ |________/|__/   |__/  \__/    "
echo -e "${red}                                                               ${nocol}"
echo -e ""                                                                                              
echo -e ""
echo -e "${cyan} wolfX_Kernel Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

# Upload Kernel-zip

  echo -e "\n$blue#######################################################################$nc"
  cd $KERNEL_DIR/out
  gdrive upload WolFx_Kernel*.zip
  cd ..
  echo -e "$purple(i) Zip uploaded Sucessfully!"
  echo -e "$red#######################################################################$nc" 
