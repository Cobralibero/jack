#!/bin/sh

##############################
# Packages required:  dialog #
##############################

CHECK=`which dialog`
[ ! $CHECK = /usr/bin/dialog ] && sudo apt install -y dialog
echo -e "" 
rm -f build/bitbake.lock
rm -f build/bitbake.sock
clear

python --version 2>&1 | awk '{print $2}' > /tmp/python-version

if grep -qs -i '2.7' cat /tmp/python-version ; then
    echo 'Your python version is ok'
else
    echo -e "${RED}Python version is wrong!"
    echo -e "It means you need to choose Python2!"
    sudo update-alternatives --config python
    exit 0
fi

gcc --version | sed -nr '/Ubuntu [0-9]+/ s/.*Ubuntu +([0-9]+).*/\1/p' > /tmp/vision-gcc-version
VISIONGCCVERSION=`cat /tmp/vision-gcc-version`
if [ "${VISIONGCCVERSION}" != '11' ]; then
    echo -e "${RED}GCC version is wrong!"
    echo -e "It means you need to choose version 11 of GCC!"
    sudo update-alternatives --config gcc
    gcc --version | sed -nr '/Ubuntu [0-9]+/ s/.*Ubuntu +([0-9]+).*/\1/p' > /tmp/vision-gcc-version
    VISIONGCCVERSION=`cat /tmp/vision-gcc-version`
    echo -e "Done, now GCC version is: ${VISIONGCCVERSION} ${NC}"
    echo -e ""
    exit 0
fi

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"

rm -f build/bitbake.lock

def_path="${SCRIPTPATH}/meta-dream/recipes-bsp/linux/linux-dreambox-3.2"
def_path2="${SCRIPTPATH}/meta-dream/recipes-bsp/linux/linux-dreambox-3.14"
def_path3="${SCRIPTPATH}/meta-dream/recipes-bsp/linux/linux-dreambox-3.4"

clear
## Menu Select Boxes ##
BOX_1="dm800se-cn"
BOX_2="dm800se-en-clone"
BOX_3="dm800se-en-original"
BOX_4="dm800sev2-en-clone"
BOX_5="dm800sev2-en-original"
BOX_6="dm900-clone"
BOX_7="dm900-original"
BOX_8="dm920"
BOX_9="dm820"
BOX_10="dm520-original"
BOX_11="dm520-clone"
BOX_12="dm500hd-original"
BOX_13="dm500hd-clone"
BOX_14="dm8000-original"
BOX_15="dm500hdv2-original"
BOX_16="dm7080"
BOX_17="dm7020hd"
BOX_18="dm7020hdv2"

list=
for i in $(seq 1 18); do
    p="BOX_$i"
    list="$list $i ${!p} "
done
list=($list) #00ff2525
box=$(dialog --stdout --clear --colors --menu "Build Dreambox Image" 22 70 10 ${list[@]})
    case $box in
    1)
    machinespecific="dm800se-cn"
    boxsim="clone"
    ;;
    2)
    machinespecific="dm800se-en-clone"
    boxsim="clone"
    ;;
    3)
    machinespecific="dm800se-en-original"
    boxsim="original"
    ;;
    4)
    machinespecific="dm800sev2-en-clone"
    boxsim="clone"
    ;;
    5)
    machinespecific="dm800sev2-en-original"
    boxsim="original"
    ;;
    6)
    machinespecific="dm900-clone"
    boxsim="clone"
    ;;
    7)
    machinespecific="dm900-original"
    boxsim="original"
    ;;
    8)
    machinespecific="dm920"
    boxsim="original"
    ;;
    9)
    machinespecific="dm820"
    boxsim="original"
    ;;
    10)
    machinespecific="dm520-original"
    boxsim="original"
    ;;
    11)
    machinespecific="dm520-clone"
    boxsim="clone"
    ;;
    12)
    machinespecific="dm500hd-original"
    boxsim="original"
    ;;
    13)
    machinespecific="dm500hd-clone"
    boxsim="clone"
    ;;
    14)
    machinespecific="dm8000-original"
    boxsim="original"
    ;;
    15)
    machinespecific="dm500hdv2-original"
    boxsim="original"
    ;;
    16)
    machinespecific="dm7080"
    boxsim="original"
    ;;
    17)
    machinespecific="dm7020hd"
    boxsim="original"
    ;;
    18)
    machinespecific="dm7020hdv2"
    boxsim="original"
    ;;
    *) clear && exit ;;
    esac

clear
## Menu Select build code source ##
TYPE_1="gitlab"
TYPE_2="gitee"
list=
for i in $(seq 1 2); do
    p="TYPE_$i"
    list="$list $i ${!p} "
done
list=($list)
codes=$(dialog --stdout --clear --colors --menu "Select build code source" 12 60 10 ${list[@]})
    case $codes in
    1)
    codesource="gitlab"
    codesource2="gitlab"
    ;;
    2)
    codesource=""
    codesource2="gitee"
    ;;
    *) clear && exit ;;
    esac

clear
## Menu Select build type ##
TYPE_1="image"
TYPE_2="feed"
TYPE_3="image_with_good_network"
TYPE_4="feed_with_good_network"
list=
for i in $(seq 1 4); do
    p="TYPE_$i"
    list="$list $i ${!p} "
done
list=($list)
build=$(dialog --stdout --clear --colors --menu "Select build type" 12 60 10 ${list[@]})
    case $build in
    1)
    echostr="Compiling $machinespecific image with $codesource2, please wait ..."
    MAKETYPE="image"
    DISTROSTR="local"
    ;;
    2)
    echostr="Compiling $machinespecific image and feed with $codesource2, please wait ..."
    MAKETYPE="feed"
    DISTROSTR="local"
    ;;
    3)
    echostr="Compiling $machinespecific image with good network with $codesource2, please wait ..."
    MAKETYPE="image"
    DISTROSTR="network"
    ;;
    4)
    echostr="Compiling $machinespecific image and feed with good network with $codesource2, please wait ..."
    MAKETYPE="feed"
    DISTROSTR="network"
    ;;
    *) clear && exit ;;
    esac

clear

########## HACK ###########
rm -f $def_path/defconfig
rm -f $def_path2/defconfig
rm -f $def_path3/defconfig

if [ ! -d meta-dream/recipes-local/images/ ]
then
    mkdir meta-dream/recipes-local/images/
fi

if [ ! -d meta-dream/recipes-local/drivers/ ]
then
    mkdir meta-dream/recipes-local/drivers/
fi
###########################
if [ "$machinespecific" = "dm800se-cn" ]; then
    cp -f backup/dm800se-cn/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm800se-en/clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm800se DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm800se-en-clone" ]; then
    cp -f backup/dm800se-en/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm800se-en/clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm800se DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm800se-en-original" ]; then
    cp -f backup/dm800se-en/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm800se-en/original/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm800se DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm8000-original" ]; then
    cp -f backup/dm8000/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm8000 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm900-clone" ]; then
    cp -f backup/dm9x0/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm900-clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm900 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm900-original" ]; then
    cp -f backup/dm9x0/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm900-original/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm900 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm920" ]; then
    cp -f backup/dm9x0/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm920 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm800sev2-en-clone" ]; then
    cp -f backup/dm800sev2-en/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm800sev2-en/clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm800sev2 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm800sev2-en-original" ]; then
    cp -f backup/dm800sev2-en/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm800sev2-en/original/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm800sev2 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm820" ]; then
    cp -f backup/dm820/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm820 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm520-original" ]; then
    cp -f backup/dm520/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm520/original/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm520 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm520-clone" ]; then
    cp -f backup/dm520/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm520/clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm520 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm500hd-original" ]; then
    cp -f backup/dm500hd/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm500hd/original/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm500hd DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm500hd-clone" ]; then
    cp -f backup/dm500hd/*.bbappend meta-dream/recipes-local/images/
    cp -f backup/dm500hd/clone/* meta-dream/recipes-local/drivers/
    echo "$echostr"
    MACHINE=dm500hd DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm500hdv2-original" ]; then
    cp -f backup/dm500hdv2/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm500hdv2 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm7080" ]; then
    cp -f backup/dm7080/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm7080 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm7020hd" ]; then
    cp -f backup/dm7020hd/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm7020hd DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
elif [ "$machinespecific" = "dm7020hdv2" ]; then
    cp -f backup/dm7020hd/*.bbappend meta-dream/recipes-local/images/
    echo "$echostr"
    MACHINE=dm7020hdv2 DISTRONETS=${DISTROSTR} MACHINESIM=${boxsim} CODEWEB=${codesource} make ${MAKETYPE}
else
    echo "Please enter a correct choice"
fi
