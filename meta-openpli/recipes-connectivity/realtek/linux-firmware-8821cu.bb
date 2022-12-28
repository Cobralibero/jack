SUMMARY = "Realtek 8821CU firmware"
HOMEPAGE = "https://www.realtek.com/"
require conf/license/openpli-gplv2.inc

SRCREV = "${AUTOREV}"
SRC_URI = "git://gitlab.com/jack2015/8821cu.git;protocol=https;branch=main"

S = "${WORKDIR}/git"

inherit allarch

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/
    install -m 0644 8821CU/rtl8821cu_config ${D}${nonarch_base_libdir}/firmware/
    install -m 0644 8821CU/rtl8821cu_fw ${D}${nonarch_base_libdir}/firmware/
}

FILES:${PN} += "${nonarch_base_libdir}/firmware"