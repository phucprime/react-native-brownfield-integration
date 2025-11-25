package com.example.nativeapp

import android.app.Application
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

/**
 * Native Android Application demonstrating React Native Brownfield Integration.
 * 
 * This is a PURE native Android app that consumes the pre-built MyRNFramework AAR.
 * No React Native node_modules are needed at build time!
 * 
 * Prerequisites:
 * 1. Build the framework: cd MyRNFramework && npm run package:android
 * 2. Copy myrnframework.aar to app/libs/
 * 
 * Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/KOTLIN.md
 */
class MainApplication : Application() {
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize React Native using @callstack/react-native-brownfield
        // The AAR contains all RN packages pre-bundled, so we pass an empty list
        ReactNativeBrownfield.initialize(
            application = this,
            packages = emptyList()  // Packages are bundled in the AAR
        ) { initialized ->
            if (initialized) {
                println("[NativeApp] React Native framework loaded successfully from AAR")
            } else {
                println("[NativeApp] Failed to initialize React Native framework")
            }
        }
    }
}
