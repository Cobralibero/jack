SUMMARY = "Enigma2 Skin MX black"
MAINTAINER = "OBH"
require conf/license/openpli-gplv2.inc

RDEPENDS_${PN} = "enigma2-plugin-systemplugins-bh-skin-support enigma2-plugin-extensions-weatherplugin"

inherit gitpkgv allarch

PV = "1.0+git${SRCPV}"
PKGV = "1.0+git${GITPKGV}"
SRCREV = "${AUTOREV}"

GIT_SITE = "${@ 'git://gitlab.com/jack2015' if d.getVar('CODEWEBSITE') else 'git://gitee.com/jackgee2021'}"
SRC_URI= "${GIT_SITE}/skin-BH-PLI;branch=master;protocol=https"

S = "${WORKDIR}/git"

FILES_${PN} = "/usr/"

do_compile[noexec] = "1"

do_install() {
    install -d ${D}${datadir}/enigma2/MX_black
    cp -r ${S}${datadir}/enigma2/MX_black/* ${D}${datadir}/enigma2/MX_black
    chmod -R a+rX ${D}${datadir}/enigma2
}
