DEPENDS_remove = "openssl10"
DEPENDS += "openssl"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fix-build-openssl110.patch"
