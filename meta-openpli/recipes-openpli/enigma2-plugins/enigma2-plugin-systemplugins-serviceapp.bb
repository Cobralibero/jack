SUMMARY = "serviceapp service for enigma2"
DESCRIPTION = "serviceapp service for enigma2"
AUTHOR = "Maroš Ondrášek <mx3ldev@gmail.com>"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "enigma2 uchardet openssl python"
RDEPENDS_${PN} = "enigma2 uchardet openssl python-json"
RRECOMMENDS_${PN} = "exteplayer3 gstplayer"

SRC_URI = "git://gitlab.com/jack2015/serviceapp.git;branch=develop;protocol=https"

S = "${WORKDIR}/git"

inherit autotools gitpkgv pythonnative pkgconfig gettext

PV = "1.0+git${SRCPV}"
PKGV = "1.0+git${GITPKGV}"

EXTRA_OECONF = "\
	BUILD_SYS=${BUILD_SYS} \
	HOST_SYS=${HOST_SYS} \
	STAGING_INCDIR=${STAGING_INCDIR} \
	STAGING_LIBDIR=${STAGING_LIBDIR} \
	"

do_install_append() {
	find ${D}/ -name '*.pyc' -exec rm {} \;
	find ${D}/ -name '*.sh' -exec chmod a+x {} \;
}

FILES_${PN} = "\
	${libdir}/enigma2/python/Plugins/SystemPlugins/ServiceApp/*.pyo \
	${libdir}/enigma2/python/Plugins/SystemPlugins/ServiceApp/locale/*/LC_MESSAGES/ServiceApp.mo \
	${libdir}/enigma2/python/Plugins/SystemPlugins/ServiceApp/serviceapp.so"

FILES_${PN}-dev = "\
	${libdir}/enigma2/python/Plugins/SystemPlugins/ServiceApp/*.py \
	${libdir}/enigma2/python/Plugins/SystemPlugins/ServiceApp/serviceapp.la"

