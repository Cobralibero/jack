IMAGE_INSTALL_remove = "distro-feed-configs"
IMAGE_INSTALL_remove = "hdparm"
IMAGE_INSTALL_remove = "3rd-party-feed-configs"

#dm800se-en

IMAGE_INSTALL_append += " \
	bitratecalc \
	libcrypto-compat \
	"

KERNEL_WIFI_DRIVERS = ""

EXTERNAL_WIFI_DRIVERS = ""

ENIGMA2_PLUGINS = " \
	enigma2-plugin-language-en \
	enigma2-plugin-language-ru \
	enigma2-plugin-drivers-network-usb-r8712u \
	\
	enigma2-plugin-extensions-audiosync \
	enigma2-plugin-extensions-autobackup \
	enigma2-plugin-extensions-backupsuite \
	enigma2-plugin-extensions-cutlisteditor \
	enigma2-plugin-extensions-cacheflush \
	enigma2-plugin-extensions-epgimport \
	enigma2-plugin-extensions-graphmultiepg \
	enigma2-plugin-extensions-mediaplayer \
	enigma2-plugin-extensions-mediascanner \
	enigma2-plugin-extensions-openwebif \
	enigma2-plugin-extensions-moviecut \
	enigma2-plugin-extensions-oscamstatus \
	enigma2-plugin-extensions-pictureplayer \
	enigma2-plugin-extensions-ppanel \
	enigma2-plugin-softcams-oscam-dm800se \
	enigma2-plugin-extensions-openmultiboot \
	openmultiboot \
	\
	enigma2-plugin-systemplugins-cablescan \
	enigma2-plugin-systemplugins-fastscan \
	enigma2-plugin-systemplugins-mphelp \
	enigma2-plugin-systemplugins-hdmicec \
	enigma2-plugin-systemplugins-hotplug \
	enigma2-plugin-systemplugins-mountmanager \
	enigma2-plugin-systemplugins-networkbrowser \
	enigma2-plugin-systemplugins-osd3dsetup \
	enigma2-plugin-systemplugins-osdpositionsetup \
	enigma2-plugin-systemplugins-positionersetup \
	enigma2-plugin-systemplugins-satfinder \
	enigma2-plugin-systemplugins-systemtime \
	enigma2-plugin-systemplugins-softwaremanager \
	enigma2-plugin-systemplugins-videomode \
	enigma2-plugin-systemplugins-videotune \
	enigma2-plugin-systemplugins-wirelesslan \
	enigma2-plugin-systemplugins-serviceapp \
	"

rmpy() {
	rm -f $1/*.py
	rm -f $1/*.pyc
	for file2 in `ls -A $1`
	do
		if [ -d "$1/$file2" ];then
			if [ $file2 != "OpenMultiboot" ];then
				rmpy "$1/$file2"
			fi
		fi
	done
}

rmpo() {
	for file2 in `ls -A $1`
	do
		if [ $file2 = "en" ]; then
			echo "do nothing"
		elif [ $file2 = "ru" ]; then
			echo "do nothing"
		elif [ $file2 = "it" ]; then
			echo "do nothing"
		else
			rm -rf $1/$file2
		fi
	done
}

upxall() {
	upx --best --ultra-brute ${IMAGE_ROOTFS}/sbin/ldconfig
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/blindscan
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/bsdcat
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/dbus-daemon
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/enigma2
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/mpg123
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/ntfs-3g
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/openssl
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/vpxdec
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/vpxenc
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/sdparm
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/alsactl
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/avahi-daemon
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/exportfs
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupadd
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupdel
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupmod
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/newusers
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/parted
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/rpc.mountd
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/rpc.statd
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/wpa_supplicant
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/ethtool
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/dropbearmulti
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/ubiformat
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/useradd
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/userdel
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/usermod
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/vsftpd
}

rootfs_myworks() {
	rm -rf ${IMAGE_ROOTFS}/var/lib/opkg/lists
	rm -rf ${IMAGE_ROOTFS}/usr/lib/python2.7/site-packages/*egg-info*
	rmpy ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins
	rmpy ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Components
	rm -rf ${IMAGE_ROOTFS}/usr/share/locale/*
	rm -rf ${IMAGE_ROOTFS}/usr/share/mime/*
	rm -f ${IMAGE_ROOTFS}/bin/bash.bash
	ln -sf busybox.nosuid ${IMAGE_ROOTFS}/bin/bash
	ln -sf busybox.nosuid ${IMAGE_ROOTFS}/bin/sh
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/AudioSync/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/AutoBackup/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/BackupSuite/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/CacheFlush/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OscamStatus/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/MovieCut/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/EPGImport/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/ServiceApp/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/SystemTime/locale
	rmpo ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/MountManager/locale
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-HD/picon_default.png
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-FullHD/picon_default.png
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-FullNightHD/picon_default.png
	rm -f ${IMAGE_ROOTFS}/usr/lib/locale/locale-archive
	cp -rf ${THISDIR}/files/dm800se-en/usr ${IMAGE_ROOTFS}/
	cp -rf ${THISDIR}/files/dm800se-en/etc ${IMAGE_ROOTFS}/
	upxall
}

ROOTFS_POSTPROCESS_COMMAND += "rootfs_myworks; "
