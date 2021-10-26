#!/bin/sh

gcc --version | sed -nr '/Ubuntu [0-9]+/ s/.*Ubuntu +([0-9]+).*/\1/p' > /tmp/vision-gcc-version
VISIONGCCVERSION=`cat /tmp/vision-gcc-version`
if [ "${VISIONGCCVERSION}" != '9' ]; then
	echo -e "${RED}GCC version is wrong!"
	echo -e "It means you need to choose version 9 of GCC!"
	sudo update-alternatives --config gcc
	gcc --version | sed -nr '/Ubuntu [0-9]+/ s/.*Ubuntu +([0-9]+).*/\1/p' > /tmp/vision-gcc-version
	VISIONGCCVERSION=`cat /tmp/vision-gcc-version`
	echo -e "Done, now GCC version is: ${VISIONGCCVERSION} ${NC}"
	echo -e ""
	exit 0
fi

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"

def_path="${SCRIPTPATH}/meta-dream/recipes-bsp/linux/linux-dreambox-3.2"

cp -pf $def_path/dm800se/defconfig $def_path/defconfig
cp -pf backup/dm800se-en/* meta-dream/recipes-local/images/
cp -pf backup/image-size/64m/* meta-dream/conf/machine/include/
cp -pf backup/serviceapp/normal/enigma2.bbappend meta-dream/recipes-local/enigma2/
cp -pf backup/serviceapp/normal/enigma2-plugin-systemplugins-serviceapp_0.5.bbappend meta-dream/recipes-local/enigma2-plugins/
echo "Compiling dm800se english image & feed, please wait ..."

MACHINE=dm800se make feed

