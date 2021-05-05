#!/bin/bash
BUILD_DIR=build/$BITBUCKET_REPO_SLUG
BUILD_NUMBER=${BITBUCKET_BUILD_NUMBER}
PADDED_BUILD_NUMBER=`printf %05d $BUILD_NUMBER`

if [[ $BITBUCKET_TAG == v* ]] ; then
	GIT_NAME=$BITBUCKET_TAG
	VERSION_NUMBER="${BITBUCKET_TAG//v}"
elif [[ $BITBUCKET_BRANCH == release-* ]] ; then
	GIT_NAME=$BITBUCKET_BRANCH
	VERSION_NUMBER="${BITBUCKET_BRANCH//release-}-SNAPSHOT$PADDED_BUILD_NUMBER"
else
	echo "Invalid tag/branch"
	exit 1
fi

ZIP_FILE=$BITBUCKET_REPO_SLUG-$VERSION_NUMBER.zip

echo "Building Preside Extension"
echo "=========================="
echo "Extension name  : $BITBUCKET_REPO_SLUG"
echo "Git tag/branch  : $GIT_NAME"
echo "Build directory : $BUILD_DIR"
echo "Version number  : $VERSION_NUMBER"
echo

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

echo "Compiling static files..."
cd assets
npm install || exit 1
grunt || exit 1
echo "Done."
cd ..

echo "Copying files to $BUILD_DIR..."
rsync -a ./ --exclude=".*" --exclude="bitbucket-pipelines.yml" --exclude="*.sh" --exclude="**/node_modules" --exclude="*.log" --exclude="tests" --exclude="build" "$BUILD_DIR" || exit 1
echo "Done."

cd "$BUILD_DIR"
echo "Installing dependencies..."
box install --production save=false || exit 1
echo "Done."

echo "Inserting version number..."
sed -i "s/VERSION_NUMBER/$VERSION_NUMBER/g" manifest.json
sed -i "s/VERSION_NUMBER/$VERSION_NUMBER/g" box.json
sed -i "s%REPO_FULL_NAME%$BITBUCKET_REPO_FULL_NAME%g" box.json
sed -i "s/ZIP_FILE/$ZIP_FILE/g" box.json
echo "Done."

echo "Zipping up to $ZIP_FILE..."
cd ..
zip -rq $ZIP_FILE $BITBUCKET_REPO_SLUG -x jmimemagic.log || exit 1
echo "Done."

echo "Push zip file to downloads..."
curl -X POST "https://${BB_AUTH_STRING}@api.bitbucket.org/2.0/repositories/${BITBUCKET_REPO_OWNER}/${BITBUCKET_REPO_SLUG}/downloads" --form files=@"${ZIP_FILE}" || exit 1
echo "Done."

echo "Publish to Forgebox..."
cd ../$BUILD_DIR
box forgebox login $FORGEBOX_USERNAME $FORGEBOX_PASSWORD || exit 1
box publish || exit 1
echo "Done."

echo "BUILD COMPLETE!"