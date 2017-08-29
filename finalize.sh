# sign apk using platform key
BASEDIR=$(dirname $0)
PRODUCT_PATH=$1
APK_PATH=$BASEDIR/android/build/outputs/apk
APK_NAME=$(ls $APK_PATH/android-web-arm64-v8a-release-*)
APK_NAME=`basename $APK_NAME`
APK_NAME_ALIGNED=aligned-$APK_NAME
echo Product path:$PRODUCT_PATH
echo Android path:$ANDROID_SRC_PATH
echo APK :$APK_PATH/$APK_NAME
echo APK Aligned:$APK_NAME_ALIGNED

# zipalign
zipalign -v -p 4 $APK_PATH/$APK_NAME $APK_PATH/$APK_NAME_ALIGNED

if [ -z "$ANDROID_SRC_PATH" ] ; then
    echo "Android source path is not set. Sign apk manually"
    return 0
fi

# sign apk with platform key
java -Xmx1024m -Djava.library.path="$ANDROID_SRC_PATH/out/host/linux-x86/lib64" -jar $ANDROID_SRC_PATH/out/host/linux-x86/framework/signapk.jar $ANDROID_SRC_PATH/build/target/product/security/platform.x509.pem $ANDROID_SRC_PATH/build/target/product/security/platform.pk8 $APK_PATH/$APK_NAME_ALIGNED $PRODUCT_PATH/omim.apk
