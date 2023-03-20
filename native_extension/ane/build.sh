#!/bin/sh

#Get the path to the script and trim to get the directory.
echo "Setting path of current directory to:"

chmod -R 777 './'

pathtome=$PWD

echo "CURRENT PATH:$pathtome"

# pathtome="${pathtome%/*}"
PROJECTNAME=AppleSignInANE
# fwSuffix="_FW"
# libSuffix="_LIB"

rm -r "$pathtome/platforms/mac" 2> /dev/null
rm "$pathtome/$PROJECTNAME.swc" 2> /dev/null
rm "$pathtome/library.swf" 2> /dev/null


AIR_SDK="/Users/ch0nk/HDP/AirSDK"

##############################################################################

echo "FRAMEWORK PATH: $pathtome/../../native_library/apple/$PROJECTNAME/Output/$PROJECTNAME/Build/Products/Release"

# if [ ! -d "$pathtome/../../native_library/apple/$PROJECTNAME/Output/$PROJECTNAME/Build/Products/Release/" ]; then
# echo "No OSX build. Build using Xcode"
# exit
# fi

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi

if [ ! -d "$pathtome/platforms/mac" ]; then
echo "Making macos directories."
mkdir "$pathtome/platforms/mac"
mkdir "$pathtome/platforms/mac/release"
fi

##############################################################################

#Copy SWC into place.
echo "Copying SWC into place."
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
echo "Extracting files from SWC."
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
echo "Copying library.swf into place."
cp "$pathtome/library.swf" "$pathtome/platforms/mac/release"

##############################################################################
# OSX
FWPATH="$pathtome/../../native_library/apple/$PROJECTNAME/Output/$PROJECTNAME/Build/Products/Release/$PROJECTNAME.framework/Versions/A/Frameworks"
if [ -f "$FWPATH/libswiftAppKit.dylib" ]; then
rm "$FWPATH/libswiftAppKit.dylib"
fi
if [ -f "$FWPATH/libswiftCore.dylib" ]; then
rm "$FWPATH/libswiftCore.dylib"
fi
if [ -f "$FWPATH/libswiftCoreData.dylib" ]; then
rm "$FWPATH/libswiftCoreData.dylib"
fi
if [ -f "$FWPATH/libswiftCoreFoundation.dylib" ]; then
rm "$FWPATH/libswiftCoreFoundation.dylib"
fi
if [ -f "$FWPATH/libswiftCoreGraphics.dylib" ]; then
rm "$FWPATH/libswiftCoreGraphics.dylib"
fi
if [ -f "$FWPATH/libswiftCoreImage.dylib" ]; then
rm "$FWPATH/libswiftCoreImage.dylib"
fi
if [ -f "$FWPATH/libswiftDarwin.dylib" ]; then
rm "$FWPATH/libswiftDarwin.dylib"
fi
if [ -f "$FWPATH/libswiftDispatch.dylib" ]; then
rm "$FWPATH/libswiftDispatch.dylib"
fi
if [ -f "$FWPATH/libswiftFoundation.dylib" ]; then
rm "$FWPATH/libswiftFoundation.dylib"
fi
if [ -f "$FWPATH/libswiftIOKit.dylib" ]; then
rm "$FWPATH/libswiftIOKit.dylib"
fi
if [ -f "$FWPATH/libswiftMetal.dylib" ]; then
rm "$FWPATH/libswiftMetal.dylib"
fi
if [ -f "$FWPATH/libswiftObjectiveC.dylib" ]; then
rm "$FWPATH/libswiftObjectiveC.dylib"
fi
if [ -f "$FWPATH/libswiftos.dylib" ]; then
rm "$FWPATH/libswiftos.dylib"
fi
if [ -f "$FWPATH/libswiftQuartzCore.dylib" ]; then
rm "$FWPATH/libswiftQuartzCore.dylib"
fi
if [ -f "$FWPATH/libswiftXPC.dylib" ]; then
rm "$FWPATH/libswiftXPC.dylib"
fi
if [ -f "$FWPATH/libswiftCloudKit.dylib" ]; then
rm "$FWPATH/libswiftCloudKit.dylib"
fi
if [ -f "$FWPATH/libswiftContacts.dylib" ]; then
rm "$FWPATH/libswiftContacts.dylib"
fi
if [ -f "$FWPATH/libswiftCoreLocation.dylib" ]; then
rm "$FWPATH/libswiftCoreLocation.dylib"
fi

#Copy native libraries into place.
echo "Copying native libraries into place."
cp -R -L "$pathtome/../../native_library/apple/$PROJECTNAME/Output/$PROJECTNAME/Build/Products/Release/$PROJECTNAME.framework" "$pathtome/platforms/mac/release"
mv "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Versions/A/Frameworks" "$pathtome/platforms/mac/release/$PROJECTNAME.framework"
rm -r "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Versions"
rm -r "$pathtome/platforms/mac/release/$PROJECTNAME.framework/Frameworks/SwiftyJSON.framework/Versions"




##############################################################################
#Run the build command.
echo "Building ANE."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME.ane" "$pathtome/extension.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform MacOS-x86-64 -C "$pathtome/platforms/mac/release" "$PROJECTNAME.framework" "library.swf"

#remove the frameworks from sim and device, as not needed any more
# rm -r "$pathtome/platforms/mac"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"

# echo "Packaging docs into ANE."
# zip "$pathtome/$PROJECTNAME.ane" -u docs/*
# zip "$pathtome/$PROJECTNAME.ane" -u "Entitlements.entitlements"
# zip "$pathtome/$PROJECTNAME.ane" -u "InfoAdditions.plist"
# zip "$pathtome/$PROJECTNAME.ane" -u "air_package.json"

cp "$pathtome/$PROJECTNAME.ane" "$pathtome/../../example-desktop/extensions/$PROJECTNAME.ane"

echo "Finished."
