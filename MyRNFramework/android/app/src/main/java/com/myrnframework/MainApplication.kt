package com.myrnframework

import android.app.Application
import com.callstack.reactnativebrownfield.ReactNativeBrownfield
import com.facebook.react.PackageList
import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative

/**
 * Application class for MyRNFramework.
 * Initializes React Native using @callstack/react-native-brownfield library.
 *
 * Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/KOTLIN.md
 *
 * Usage:
 * 1. Add this class to your AndroidManifest.xml as the application class
 * 2. The React Native runtime will be initialized on app startup
 * 3. Use ReactNativeBrownfield.shared.createView() to embed React Native views
 */
class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        
        // Load React Native native libraries (required for RN >= 0.80.0)
        loadReactNative(this)
        
        // Get auto-linked packages
        val packages = PackageList(this).packages.toMutableList()
        
        // Add custom native module package
        packages.add(NativeModulePackage())
        
        // Initialize React Native using @callstack/react-native-brownfield
        ReactNativeBrownfield.initialize(this, packages) { initialized ->
            if (initialized) {
                println("[MyRNFramework] React Native bundle loaded successfully")
            }
        }
    }
}
