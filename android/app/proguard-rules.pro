# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# React Native

# Keep React Native classes
-keep class com.facebook.react.** { *; }
-keep class com.facebook.hermes.** { *; }
-keep class com.facebook.jni.** { *; }

# Hermes
-keep class com.facebook.hermes.unicode.** { *; }
-keep class com.facebook.jni.** { *; }

# Okhttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# React Native Brownfield Bridge
-keep class com.brownfield.rnbridge.** { *; }
-keepclassmembers class com.brownfield.rnbridge.** { *; }

# Keep native methods
-keepclassmembers class * {
    @com.facebook.react.bridge.ReactMethod *;
}

# Don't warn about React Native
-dontwarn com.facebook.react.**

# Keep Fresco
-keep class com.facebook.imagepipeline.** { *; }

# Keep SoLoader
-keep class com.facebook.soloader.** { *; }
