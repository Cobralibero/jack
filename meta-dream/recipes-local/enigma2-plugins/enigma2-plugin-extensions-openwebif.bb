SUMMARY = "Control your receiver with a browser"
DESCRIPTION = "Control your receiver with a browser"
MAINTAINER = "Openpli Developers"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://README;md5=26abba37d1c2fcbf96a087ceb8e1db86"

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = "python-cheetah-native"

RDEPENDS:${PN} = "\
	aio-grab \
	python-cheetah \
	python-compression\
	python-ipaddress\
	python-json \
	python-misc \
	python-numbers \
	python-pprint \
	python-pyopenssl \
	python-shell \
	python-six \
	python-twisted-web \
	python-unixadmin \
	"

inherit gitpkgv distutils-openplugins gettext

PV = "git${SRCPV}"
PKGV = "git${GITPKGV}"

SRC_URI = "git://github.com/E2OpenPlugins/e2openplugin-OpenWebif.git;protocol=git;branch=master"

S="${WORKDIR}/git"

PLUGINPATH = "${libdir}/enigma2/python/Plugins/Extensions/OpenWebif"

# Just a quick hack to "compile" it
# cheetah-compile -R --nobackup --iext=.tmpl ${S}/plugin
do_compile() {
	cheetah-compile -R --nobackup ${S}/plugin
	python -O -m compileall -d ${PLUGINPATH} ${S}/plugin
}

do_install:append() {
	install -d ${D}${PLUGINPATH}
	cp -r ${S}/plugin/* ${D}${PLUGINPATH}
	chmod a+rX ${D}${PLUGINPATH}
}

python do_cleanup () {

    import os

    pluginpath = "%s%s" % (d.getVar('D', True), d.getVar('PLUGINPATH', True))
    images = "%s/public/images/" % pluginpath
    keymaps = "%s/public/static/" % pluginpath

    mybox_name = d.getVar('MACHINE', True)

    if mybox_name == 'dm800se':
        target_box = 'dm800se.png'
        target_remote = 'dmm1.png'
        target_keymap = 'dmm1.html'
    if mybox_name == 'dm800sev2':
        target_box = 'dm800se.png'
        target_remote = 'dmm1.png'
        target_keymap = 'dmm1.html'
    if mybox_name == 'dm900':
        target_box = 'dm900.png'
        target_remote = 'dmm2.png'
        target_keymap = 'dmm2.html'
    if mybox_name == 'dm920':
        target_box = 'dm920.png'
        target_remote = 'dmm2.png'
        target_keymap = 'dmm2.html'

    exception = ''

    for root, dirs, files in os.walk(images + 'boxes', topdown=False):
        for name in files:
            if target_box != name and name != 'unknown.png' and exception != name:
                os.remove(os.path.join(root, name))
        if mybox_name == 'dm800sev2':
            os.system('cd '+ root +' ; cp -pf dm800se.png dm800sev2.png ; chmod -R a+rX dm800sev2.png')

    for root, dirs, files in os.walk(images + 'remotes', topdown=False):
        for name in files:
            if target_remote != name and name != 'ow_remote.png' and exception != name:
                os.remove(os.path.join(root, name))

    for root, dirs, files in os.walk(keymaps + 'remotes', topdown=False):
        for name in files:
            if target_keymap != name:
                os.remove(os.path.join(root, name))
}

addtask do_cleanup after do_populate_sysroot before do_package

FILES:${PN} = "${PLUGINPATH}"
PACKAGES =+ "${PN}-themes ${PN}-webtv ${PN}-vxg"
FILES:${PN}-themes = "${libdir}/enigma2/python/Plugins/Extensions/OpenWebif/public/themes"
FILES:${PN}-webtv = "${libdir}/enigma2/python/Plugins/Extensions/OpenWebif/public/webtv"
FILES:${PN}-vxg = "${libdir}/enigma2/python/Plugins/Extensions/OpenWebif/public/vxg"
RDEPENDS:${PN}-themes = "${PN}"
RDEPENDS:${PN}-webtv = "${PN}"
RDEPENDS:${PN}-vxg = "${PN}"
ALLOW_EMPTY:${PN}-themes = "1"
ALLOW_EMPTY:${PN}-webtv = "1"
ALLOW_EMPTY:${PN}-vxg = "1"

FILES:${PN}-dbg += "\
    /usr/lib/enigma2/python/Plugins/*/*/.debug \
    /usr/lib/enigma2/python/Plugins/*/*/*/.debug \
    /usr/lib/enigma2/python/Plugins/*/*/*/*/.debug \
    /usr/lib/enigma2/python/Plugins/*/*/*/*/*/.debug \
    /usr/lib/enigma2/python/Plugins/*/*/*/*/*/*/.debug \
    "

FILES:${PN}-src = "\
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

FILES:${PN}-src += "${PLUGINPATH}/controllers/views/*.tmpl ${PLUGINPATH}/controllers/views/*/*.tmpl ${PLUGINPATH}/controllers/views/*/*/*.tmpl"

python populate_packages:prepend() {
    enigma2_plugindir = bb.data.expand('${libdir}/enigma2/python/Plugins', d)
    do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/.*\.py$', 'enigma2-plugin-%s-src', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True)
    do_split_packages(d, enigma2_plugindir, '^(\w+/\w+)/(.*/)?\.debug/.*$', 'enigma2-plugin-%s-dbg', 'Enigma2 Plugin: %s', recursive=True, match_path=True, prepend=True)
}
