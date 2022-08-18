SUMMARY = "VU+ DLNA Server plugin"
DESCRIPTION = "VU+ DLNA Server plugin"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c9e255efa454e0155c1fd758df7dcaf3"

S = "${WORKDIR}/git"
GIT_SITE = "${@ 'git://gitlab.com/jack2015' if d.getVar('CODEWEBSITE') else 'git://gitee.com/jackgee2021'}"
SRC_URI = "${GIT_SITE}/dvbapp;branch=vuplus_experimental;protocol=https \
	file://01-minidlna.patch;striplevel=1;apply=yes \
	file://02-readymedia.patch;striplevel=1;apply=yes \
"

inherit gitpkgv
PV = "git${SRCPV}"
PKGV = "git${GITPKGV}"

RDEPENDS_${PN} = "readymedia"
FILES_${PN} = "${libdir}/enigma2/python/Plugins/Extensions/DLNAServer/*"
PACKAGES = "${PN}"

do_install() {
	install -d ${D}${libdir}/enigma2/python/Plugins/Extensions/DLNAServer
	install -m 0644 ${S}/lib/python/Plugins/Extensions/DLNAServer/*.py ${D}${libdir}/enigma2/python/Plugins/Extensions/DLNAServer
	python2 -O -m compileall ${D}${libdir}/enigma2/python/Plugins/
}
