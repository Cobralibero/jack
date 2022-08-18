SUMMARY = "PluginSkinMover"
DESCRIPTION = "PluginSkinMover"
LICENSE = "GPLv3"
MAINTAINER = "Openpli Developers"
AUTHOR = "mfaraj and schomi"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

GIT_SITE = "${@ 'git://gitlab.com/jack2015' if d.getVar('CODEWEBSITE') else 'git://gitee.com/jackgee2021'}"
SRC_URI = "${GIT_SITE}/PluginSkinMover;protocol=https;branch=master"

# don't inherit allarch, it can't work with arch-dependent RDEPENDS
inherit gitpkgv distutils-openplugins gettext

S = "${WORKDIR}/git"

PV = "0.6+git${SRCPV}"
PKGV = "0.6+git${GITPKGV}"
SRCREV = "${AUTOREV}"

FILES_${PN}-src = "\
    /usr/lib/enigma2/python/*/*.py \
    /usr/lib/enigma2/python/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*/*/*/*/*.py \
    /usr/lib/enigma2/python/*/*/*/*/*/*/*/*/*/*/*.py \
    "

python populate_packages_prepend() {
    enigma2_plugindir = bb.data.expand('${libdir}/enigma2/python/Plugins', d)
    do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/[a-zA-Z0-9_]+.*$', 'enigma2-plugin-%s', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True)
    do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.py$', 'enigma2-plugin-%s-src', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True)
}
