SUMMARY = "Linux kernel for ${MACHINE}"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
INC_PR = "20"

inherit kernel siteinfo machine_kernel_pr

PACKAGES_DYNAMIC = "kernel-*"

# For packages that RDEPEND on particular kernel modules, list the ones built into
# the kernel here, so that it is known that the kernel has them built in.
KERNEL_BUILTIN_MODULES = ""

KERNEL_BUILTIN_MODULES:dm8000 = "\
    kernel-module-aes-generic \
    kernel-module-crc32c \
    kernel-module-mac80211 \
    kernel-module-cfg80211 \
    kernel-module-ath \
    kernel-module-ath5k \
    kernel-module-sr-mod \
    kernel-module-isofs \
    kernel-module-udf \
    "

USB_ROOT = "/dev/sdb2"
USB_ROOT:dm8000 = "/dev/sdf2"

export OS = "Linux"
KERNEL_OBJECT_SUFFIX = "ko"
KERNEL_OUTPUT = "vmlinux"
KERNEL_IMAGETYPE = "vmlinux"
KERNEL_IMAGEDEST = "boot"
KERNEL_OUTPUT_DIR = "."

do_install:append() {
        ${STRIP} ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}
        gzip -9 ${D}/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}
        echo "/boot/bootlogo-${MACHINE}.elf.gz filename=/boot/bootlogo-${MACHINE}.jpg" > ${D}/${KERNEL_IMAGEDEST}/autoexec.bat
        echo "/boot/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}.gz ${CMDLINE}" >> ${D}/${KERNEL_IMAGEDEST}/autoexec.bat
        echo "/boot/bootlogo-${MACHINE}.elf.gz filename=/boot/bootlogo-${MACHINE}.jpg" > ${D}/${KERNEL_IMAGEDEST}/autoexec_${MACHINE}.bat
        echo "/boot/${KERNEL_IMAGETYPE}-${KERNEL_VERSION}.gz ${USB_CMDLINE}" >> ${D}/${KERNEL_IMAGEDEST}/autoexec_${MACHINE}.bat
}

# Set FILES for vmlinux package, so that kernel-image gets those files.
FILES:${KERNEL_PACKAGE_NAME}-image = "/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE}.gz"
FILES:${KERNEL_PACKAGE_NAME}-image += "/${KERNEL_IMAGEDEST}/autoexec*.bat"
FILES:${KERNEL_PACKAGE_NAME}-vmlinux = "/boot/vmlinux-${KERNEL_VERSION}*"

pkg_preinst:kernel-image() {
	if [ -z "$D" ]
	then
		if mountpoint -q /${KERNEL_IMAGEDEST}
		then
			mount -o remount,rw,compr=none /${KERNEL_IMAGEDEST}
		else
			mount -t jffs2 -o rw,compr=none mtd:boot /${KERNEL_IMAGEDEST} || mount -t jffs2 -o rw,compr=none mtd:'boot partition' /${KERNEL_IMAGEDEST}
		fi
	fi
}
pkg_prerm:kernel-image() {
	if [ -z "$D" ]
	then
		if mountpoint -q /${KERNEL_IMAGEDEST}
		then
			mount -o remount,rw,compr=none /${KERNEL_IMAGEDEST}
		else
			mount -t jffs2 -o rw,compr=none mtd:boot /${KERNEL_IMAGEDEST}
		fi
	fi
}
pkg_postinst_ontarget:kernel-image() {
        if mountpoint -q /${KERNEL_IMAGEDEST}; then
                if grep -q '\<root=/dev/mtdblock3\>' /proc/cmdline && grep -q '\<root=ubi0:rootfs\>' /boot/autoexec.bat; then
                        sed -ie 's!${CMDLINE_UBI}!${CMDLINE_JFFS2}!' /boot/autoexec.bat;
                fi
                umount /${KERNEL_IMAGEDEST};
        fi
}
pkg_postrm:kernel-image() {
	if [ -z "$D" ]
	then
		umount /${KERNEL_IMAGEDEST}
	fi
}

# Do not use update-alternatives!
pkg_postinst:kernel () {
}
pkg_postrm:kernel () {
}

CMDLINE_JFFS2 = "root=/dev/mtdblock3 rootfstype=jffs2 rw ${CMDLINE_CONSOLE}"
CMDLINE_UBI = "ubi.mtd=root root=ubi0:rootfs rootfstype=ubifs rw ${CMDLINE_CONSOLE}"
CMDLINE = "${@bb.utils.contains('IMAGE_FSTYPES', 'ubifs', '${CMDLINE_UBI}', '${CMDLINE_JFFS2}', d)}"
USB_CMDLINE = "root=${USB_ROOT} rootdelay=10 rw ${CMDLINE_CONSOLE}"

LOCALVERSION = "-${MACHINE}"


do_configure:prepend() {

        echo "" > ${S}/.config

        echo "CONFIG_CMDLINE=\"${CMDLINE}\"" >> ${S}/.config

        sed -e '/CONFIG_AEABI/d' \
            -e '/CONFIG_OABI_COMPAT=/d' \
            -e '/CONFIG_CMDLINE=/d' \
            -e '/CONFIG_CPU_BIG_ENDIAN/d' \
            -e '/CONFIG_LOGO=/d' \
            -e '/CONFIG_LOGO_LINUX_CLUT224=/d' \
            -e '/CONFIG_LOCALVERSION/d' \
            -e '/CONFIG_LOCALVERSION_AUTO/d' \
	    < '${WORKDIR}/defconfig' >>'${S}/.config'

        echo 'CONFIG_LOCALVERSION="${LOCALVERSION}"' >>${S}/.config
        echo '# CONFIG_LOCALVERSION_AUTO is not set' >>${S}/.config

}
