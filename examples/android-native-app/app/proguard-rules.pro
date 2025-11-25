# ==============================================================================
# ProGuard Rules for Native Android App with React Native AAR
# ==============================================================================

# React Native (from AAR)
-keep class com.facebook.react.** { *; }
-keep class com.facebook.hermes.** { *; }
-keep class com.facebook.jni.** { *; }

# Hermes JS Engine
-keep class com.facebook.hermes.unicode.** { *; }

# React Native Brownfield Library
-keep class com.callstack.reactnativebrownfield.** { *; }

# Keep native methods
-keepclassmembers class * {
    @com.facebook.react.bridge.ReactMethod *;
}

# Keep SoLoader
-keep class com.facebook.soloader.** { *; }

# Don't warn about React Native internals
-dontwarn com.facebook.react.**
-dontwarn com.facebook.hermes.**