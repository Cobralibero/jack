IMAGE_INSTALL_remove = "distro-feed-configs"
IMAGE_INSTALL_remove = "hdparm"
IMAGE_INSTALL_remove = "3rd-party-feed-configs"

#dm800se-cn

IMAGE_INSTALL_append += " \
	bitratecalc \
	libcrypto-compat \
	busybox-cron \
	"

KERNEL_WIFI_DRIVERS = ""

EXTERNAL_WIFI_DRIVERS = ""

ENIGMA2_PLUGINS = " \
	enigma2-plugin-language-en \
	enigma2-plugin-language-zh-cn \
	enigma2-plugin-font-wqy-microhei \
	enigma2-plugin-skins-pli-fullnighthd \
	enigma2-plugin-extensions-fancontrol2 \
	enigma2-plugin-extensions-audiosync \
	enigma2-plugin-extensions-autobackup \
	enigma2-plugin-extensions-cutlisteditor \
	enigma2-plugin-extensions-cacheflush \
	enigma2-plugin-extensions-graphmultiepg \
	enigma2-plugin-extensions-mediaplayer \
	enigma2-plugin-extensions-mediascanner \
	enigma2-plugin-extensions-openwebif \
	enigma2-plugin-extensions-moviecut \
	enigma2-plugin-extensions-oscamstatus \
	enigma2-plugin-extensions-pictureplayer \
	enigma2-plugin-extensions-ppanel \
	enigma2-plugin-softcams-oscam \
	enigma2-plugin-systemplugins-cablescan \
	enigma2-plugin-systemplugins-fastscan \
	enigma2-plugin-systemplugins-mphelp \
	enigma2-plugin-systemplugins-hdmicec \
	enigma2-plugin-systemplugins-hotplug \
	enigma2-plugin-systemplugins-networkbrowser \
	enigma2-plugin-systemplugins-osd3dsetup \
	enigma2-plugin-systemplugins-osdpositionsetup \
	enigma2-plugin-systemplugins-positionersetup \
	enigma2-plugin-systemplugins-satfinder \
	enigma2-plugin-systemplugins-softwaremanager \
	enigma2-plugin-systemplugins-videomode \
	enigma2-plugin-systemplugins-videotune \
	enigma2-plugin-systemplugins-wirelesslan \
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

upxall() {
	upx --best --ultra-brute ${IMAGE_ROOTFS}/sbin/ldconfig || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/blindscan || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/bsdcat || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/dbus-daemon || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/enigma2 || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/mpg123 || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/ntfs-3g || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/openssl || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/vpxdec || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/vpxenc || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/wget.wget || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/sdparm || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/bin/sftp || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/alsactl || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/avahi-daemon || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/exportfs || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupadd || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupdel || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/groupmod || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/newusers || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/parted || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/rpc.mountd || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/rpc.statd || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/wpa_supplicant || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/ethtool || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/dropbearmulti || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/ubiformat || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/useradd || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/userdel || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/usermod || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/vsftpd || true
	upx --best --ultra-brute ${IMAGE_ROOTFS}/usr/sbin/ntpdate || true
}

rootfs_myworks() {
	rm -rf ${IMAGE_ROOTFS}/var/lib/opkg/lists
	rm -rf ${IMAGE_ROOTFS}/usr/lib/python2.7/site-packages/*egg-info*
	rmpy ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins
	rmpy ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Components
	rm -rf ${IMAGE_ROOTFS}/usr/share/locale/*
	rm -rf ${IMAGE_ROOTFS}/usr/share/enigma2/countries/*
	rm -rf ${IMAGE_ROOTFS}/usr/lib/locale/*
	rm -rf ${IMAGE_ROOTFS}/usr/share/mime/*
	rm -f ${IMAGE_ROOTFS}/bin/bash.bash
	ln -sf busybox.nosuid ${IMAGE_ROOTFS}/bin/bash
	ln -sf busybox.nosuid ${IMAGE_ROOTFS}/bin/sh
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/AudioSync/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/AutoBackup/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/BackupSuite/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/CacheFlush/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/FanControl2/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OpenMultiboot/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/OscamStatus/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/MovieCut/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/EPGImport/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/Extensions/PluginSkinMover/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/ServiceApp/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/SystemTime/locale
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/MountManager/locale/ru
	rm -rf ${IMAGE_ROOTFS}/usr/lib/enigma2/python/Plugins/SystemPlugins/MountManager/locale/fr
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-HD/picon_default.png
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-FullHD/picon_default.png
	rm -f ${IMAGE_ROOTFS}/usr/share/enigma2/PLi-FullNightHD/picon_default.png
	cp -rf ${THISDIR}/files/dm800se-cn/usr ${IMAGE_ROOTFS}/
	cp -rf ${THISDIR}/files/dm800se-cn/etc ${IMAGE_ROOTFS}/
	upxall
}

ROOTFS_POSTPROCESS_COMMAND += "rootfs_myworks; "
