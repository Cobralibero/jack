DESCRIPTION = "Openpli branding lib DM820"
MAINTAINER = "Openpli Developers"
PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "python"

require conf/license/openpli-gplv2.inc

inherit autotools-brokensep gitpkgv pythonnative

SRCREV = "${AUTOREV}"
PV = "git${SRCPV}"
PKGV = "git${GITPKGV}"

PR[vardepsexclude] += "DATE"

do_configure[nostamp] = "1"

SRC_URI="git://gitee.com/jackgee2021/branding-module;protocol=https;branch=master"

S = "${WORKDIR}/git"

EXTRA_OECONF = " \
    BUILD_SYS=${BUILD_SYS} \
    HOST_SYS=${HOST_SYS} \
    STAGING_INCDIR=${STAGING_INCDIR} \
    STAGING_LIBDIR=${STAGING_LIBDIR} \
    --with-visionversion="10.3" \
    --with-visionrevision="develop" \
    --with-developername="develop" \
    --with-boxbrand="dreambox" \
    --with-oever="PLi-OE" \
    --with-distro="openpli" \
    --with-boxtype="dm820" \
    --with-machinebuild="dm820" \
    --with-imageversion="10.3" \
    --with-imagebuild="hardknott" \
    --with-imagedevbuild="000" \
    --with-imagetype="develop" \
    --with-feedsurl="http://downloads.openpli.org/feeds/openpli-7-release" \
    --with-imagedir="" \
    --with-imagefs="tar.xz" \
    --with-mtdbootfs="" \
    --with-mtdrootfs="" \
    --with-mtdkernel="mtd2" \
    --with-rootfile="rootfs.bin" \
    --with-kernelfile="kernel.bin" \
    --with-mkubifs="" \
    --with-ubinize="" \
    --with-arch="mips32el" \
    --with-tfpu="hard" \
    --with-display-type="bwlcd96" \
    --with-small-flash="False" \
    --with-kernelversion="3.4" \
    --with-transcoding="False" \
    --with-multitranscoding="False" \
    --with-middle-flash="False" \
    --with-multilib="False" \
    --with-hdmi="True" \
    --with-yuv="False" \
    --with-rca="False" \
    --with-av-jack="False" \
    --with-scart="True" \
    --with-dvi="False" \
    --with-svideo="False" \
    --with-hdmi-in-hd="False" \
    --with-hdmi-in-fhd="False" \
    --with-wol="False" \
    --with-ci="False" \
    --with-blindscanbinary="" \
    --with-socfamily="bcm7435" \
    --with-vfd-symbol="False" \
    --with-rctype="" \
    --with-rcname="" \
    --with-rcidnum="" \
    --with-fhdskin="False" \
    "

FILES_${PN} = "${libdir}/enigma2/python/*.so"
FILES_${PN}-dev += "${libdir}/enigma2/python/*.la"
FILES_${PN}-staticdev += "${libdir}/enigma2/python/*.a"
FILES_${PN}-dbg += "${libdir}/enigma2/python/.debug"
