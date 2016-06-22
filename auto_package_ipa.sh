#!/bin/bash

#original credit for the SwiftSupport and Getting the Developer Directory goes to @bq
#https://github.com/bq/ipa-packager

#To debug or troubleshoot, remove the >/dev/null or 2>/dev/null from the file

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
echo "Unzipping the IPA archive..."
unzip "${IPA}" -d "${TEMPDIR}" >/dev/null

#rename the original IPA
mv "${IPA}" "${IPA/.ipa/-original.ipa}"
echo "Backed up original IPA to ${IPA/.ipa/-original.ipa}"

APPFILE=$(ls "${TEMPDIR}/Payload/")
APP="${TEMPDIR}/Payload/${APPFILE}"
APPFRAMEWORKS="${APP}/Frameworks"

#add the SwiftSupport requirement
if [ -d "${APPFRAMEWORKS}" ]; then

	echo "Copying Swift Support Requirements..."
	SWIFTSUPPORT="${TEMPDIR}/SwiftSupport"

    mkdir -p "${SWIFTSUPPORT}"
    for SWIFT_LIB in $(ls -1 "${APPFRAMEWORKS}"); do
    	#may throw an error, saying it can't find a *.framework, this is normal
        cp "${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/${SWIFT_LIB}" "${SWIFTSUPPORT}" >/dev/null 2>/dev/null
    done
fi

#zip the files, save the ipa and cleanup
echo "Zipping updated IPA archive..."
cd "${TEMPDIR}"
zip --symlinks --recurse-paths "${IPA}" . >/dev/null
cd "${IPADIR}"
rm -d -r "${TEMPDIR}"

echo "Completed! Saved as ${IPA}"