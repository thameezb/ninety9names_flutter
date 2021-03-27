#!/bin/bash

set -e 

if [ -z $1 ]; then exit 1; fi

version=$1

git tag $version
git push --tags

flutter build apk
mv build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/ninety9names.apk

flutter build web
cp -r build/web/* /projects/app-ninety9names-web 
cd /projects/app-ninety9names-web 
git checkout -b feature/$version
git add .
git commit -m "feature: new version - $version"
git push --set-upstream origin feature/$version