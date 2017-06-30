#!/bin/bash

function usage {
	echo "Usage: bash build.sh -a <android home> -p <android platform version> -b <build tools version> [-s (sign)]"
	exit 1
}	

android_home=""
platform_version=""
build_tools=""
sign=0

while getopts ":b:a:p:s" option; do
	case $option in
		a)
			android_home=$OPTARG
			;;
		p)
			platform_version=$OPTARG
			;;
		
		b)
			build_tools=$OPTARG
			;;	
		s)
			sign=1
			;;
		\?)
			usage
			;;
		:)
			usage
			;;
	esac
done

if [ -z $android_home ] || [ -z $platform_version ] || [ -z $build_tools ]; then
	usage
fi

mkdir out
mkdir gen

java -jar ${android_home}/build-tools/$build_tools/jack.jar \
	--classpath "${android_home}/platforms/${platform_version}/android.jar" \
	--output-dex out/ \
	src/ gen/

aapt package -f \
	-M AndroidManifest.xml \
	-I "${android_home}/platforms/${platform_version}/android.jar" \
	-F out/minimal.apk

cd out
aapt add minimal.apk classes.dex
cd ..

if [ $sign -eq 1 ]; then
	jarsigner -verbose \
		-keystore ~/.android/debug.keystore \
		-storepass android \
		-keypass android \
		out/minimal.apk \
		androiddebugkey
fi

zipalign -f 4 out/minimal.apk minimal-final.apk
rm -rf out/
rm -rf gen/
