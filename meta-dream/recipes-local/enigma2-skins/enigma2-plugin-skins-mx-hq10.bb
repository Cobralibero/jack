SUMMARY = "Enigma2 Skin MX HQ10"
MAINTAINER = "OBH"
require conf/license/openpli-gplv2.inc

RDEPENDS:${PN} = "enigma2-plugin-systemplugins-bh-skin-support"

inherit gitpkgv allarch

PV = "1.0+git${SRCPV}"
PKGV = "1.0+git${GITPKGV}"
SRCREV = "${AUTOREV}"

SRC_URI= "git://github.com/jack2015/skin-BH-PLI.git;protocol=${GIT_PROTOCOL}"

S = "${WORKDIR}/git"

FILES:${PN} = "/usr/"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/enigma2/MX_HQ10
    cp -r ${S}${datadir}/enigma2/MX_HQ10/* ${D}${datadir}/enigma2/MX_HQ10
    chmod -R a+rX ${D}${datadir}/enigma2
}
