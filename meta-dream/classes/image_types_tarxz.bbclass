inherit image_types

IMAGEDIR = "${MACHINE}"
PDATE = "${@time.strftime('%Y%m%d',time.gmtime())}"
IMAGEVERSION := "OPENPLI-${DISTRO_VERSION}-${MACHINE}-${MACHINESIMS}-${PDATE}"

IMAGE_CMD:tar = "tar --sort=name --numeric-owner -cf ${IMGDEPLOYDIR}/${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.tar -C ${IMAGE_ROOTFS} . || [ $? -eq 1 ]"

IMAGE_CMD:tar:prepend = " \
    mkdir -p ${IMAGE_ROOTFS}/tmp; \
    "

CONVERSION_CMD:xz = " \
    rm -f ${DEPLOY_DIR_IMAGE}/*.zip; \
    xz -f -k -c ${XZ_COMPRESSION_LEVEL} ${XZ_DEFAULTS} --check=${XZ_INTEGRITY_CHECK} ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.tar > ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.tar.xz; \
    echo "${IMAGEVERSION}" > ./imageversion; \
    zip openpli-${DISTRO_VERSION}_${MACHINE}_${MACHINESIMS}_${PDATE}.zip ./imageversion ./*.xz; \
    rm -f ./*.manifest; \
    rm -f ./imageversion; \
    "
