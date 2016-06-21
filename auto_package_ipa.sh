#!/bin/bash

#original credit for the SwiftSupport and Getting the Developer Directory goes to @bq
#https://github.com/bq/ipa-packager

IPA="$1"
IPADIR=$(dirname "${IPA}")
TEMPDIR="${IPADIR}/$(cat /dev/urandom | env LC_CTYPE=C tr -cd 'a-z0-9' | head -c 5)"

cd "${IPADIR}"

#check the IPA to make sure it exists
if [ ! -f "${IPA}" ]; then
	echo "Usage: sh auto_package_ipa.sh PATH_TO_SIGNED_IPA"
	exit 1
fi

#get xcode directory
DEVELOPER_DIR=`xcode-select --print-path`
if [ ! -d "${DEVELOPER_DIR}" ]; then
	echo "No developer directory found!"
	exit 1
fi

#unzip the IPA so we can re-build the .app
unzip "${IPA}" -d "${TEMPDIR}"

#delete the original IPA, so we can rewrite it later
mv "${IPA}" "${IPA/.ipa/-original.ipa}"

APP="${TEMPDIR}/Payload/$(ls ${TEMPDIR}/Payload/)"
echo ${APP}

#add the SwiftSupport requirement
if [ -d "${APP}/Frameworks" ];
then
    mkdir -p "${TEMPDIR}/SwiftSupport"

    for SWIFT_LIB in $(ls -1 "${APP}/Frameworks/"); do
        echo "Copying ${SWIFT_LIB}"
        cp "${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/${SWIFT_LIB}" "${TEMPDIR}/SwiftSupport"
    done
fi

#zip the files, save the ipa and cleanup
cd "${TEMPDIR}"
zip --recurse-paths "${IPA}" .
cd "${IPADIR}"
rm -d -r "${TEMPDIR}"