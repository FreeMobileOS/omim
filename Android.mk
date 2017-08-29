LOCAL_PATH := $(call my-dir)

MAPS_URL_JSON := "\#define DEFAULT_URLS_JSON \"\"[\"http://direct.mapswithme.com/\" ]\"\""
DFT_URL_JSON := "\#define DEFAULT_URLS_JSON \"\""

# run configure script
$(info $(shell (echo -n '\n' | $(LOCAL_PATH)/configure.sh )))

# run android setup script
$(info $(shell ($(LOCAL_PATH)/tools/android/set_up_android.py --sdk \
                $(ANDROID_SDK_PATH) --ndk $(ANDROID_NDK_PATH))))
    
#edit private.h file
$(info $(shell (sed -i '/DEFAULT_URLS_JSON/c\#define DEFAULT_URLS_JSON \"[ \\\"http://direct.mapswithme.com/\\\" ]\"' $(LOCAL_PATH)/private.h)))

# initiate build
$(info $(shell ($(LOCAL_PATH)/android/gradlew clean assembleWebRelease -p $(LOCAL_PATH)/android)) )

# sign apk and copy to out path
$(info $(shell ($(LOCAL_PATH)/finalize.sh $(PRODUCT_OUT_PATH))))
