SUMMARY = "Actualize services in bouquets."
DESCRIPTION = "Actualize services in bouquets."
MAINTAINER = "ims(ims21)"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9432c1f3d564948269193fd19a0ad0fd"

inherit gitpkgv
PV = "2.0+git${SRCPV}"
PKGV = "2.0+git${GITPKGV}"

GIT_SITE = "${@ 'git://gitlab.com/jack2015' if d.getVar('CODEWEBSITE') else 'git://gitee.com/jackgee2021'}"
SRC_URI = "${GIT_SITE}/RefreshBouquet;protocol=https;branch=master"

S="${WORKDIR}/git"

inherit distutils-openplugins
