# minimal-apk
This shows how to create an APK as small as possible using only command line. 
To build without signing the APK : 
```bash
bash build.sh -a "/home/foo/Android/Sdk" -p "android-24" -b "26.0.0"
```
To build with signing :
```bash
bash build.sh -a "/home/foo/Android/Sdk" -p "android-24" -b "26.0.0" -s
```
