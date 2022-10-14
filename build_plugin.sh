#!/bin/bash

TAG=$1

WORK_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
ARTIFACT_DIR=${ARTIFACT_DIR:-"${WORK_DIR}/artifacts"}
mkdir -p "${ARTIFACT_DIR}"

JELLYFIN_REPO_URL="https://github.com/cxfksword/jellyfin-plugin-danmu/releases/download"
JELLYFIN_MANIFEST="${WORK_DIR}/manifest.json"
JELLYFIN_MANIFEST_OLD="https://github.com/cxfksword/jellyfin-plugin-danmu/releases/download/manifest/manifest.json"
JELLYFIN_MANIFEST_TEMPLATE="${WORK_DIR}/doc/manifest-template.json"
BUILD_YAML_FILE="${WORK_DIR}/build.yaml"


VERSION=$(echo "$TAG" | sed s/^v//)  # remove v prefix
VERSION="$VERSION.0"  # .NET dll need major.minor[.build[.revision]] version format

# download old manifest
wget -q -O "$JELLYFIN_MANIFEST" "$JELLYFIN_MANIFEST_OLD"
if [ $? -ne 0 ]; then
    cp -f "$JELLYFIN_MANIFEST_TEMPLATE" "$JELLYFIN_MANIFEST"
fi

# update change log from tag message

CHANGELOG=$(git tag -l --format='%(contents)' ${TAG})
sed -i "s#NA#$CHANGELOG#" $BUILD_YAML_FILE  # mac build need change to: -i '' 

# build and generate new manifest
zipfile=$(jprm --verbosity=debug plugin build "." --output="${ARTIFACT_DIR}" --version="${VERSION}" --dotnet-framework="net6.0") && {
    jprm --verbosity=debug repo add --url=${JELLYFIN_REPO_URL} "${JELLYFIN_MANIFEST}" "${zipfile}"
}

exit $?