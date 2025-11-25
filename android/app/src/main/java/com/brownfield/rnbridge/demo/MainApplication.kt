package com.brownfield.rnbridge.demo

import android.app.Application
import com.callstack.reactnativebrownfield.ReactNativeBrownfield
import com.facebook.react.PackageList
import com.facebook.react.ReactNativeApplicationEntryPoint.loadReactNative

/**
 * Main Application class for the RNBridge Demo app.
 * 
 * Initializes React Native using @callstack/react-native-brownfield library.
 * Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/KOTLIN.md
 */
class MainApplication : Application() {
    
    override fun onCreate() {
        super.onCreate()
        
        // Load React Native native libraries (required for RN >= 0.80.0)
        loadReactNative(this)
        
        // Get auto-linked packages
        val packages = PackageList(this).packages
        
        // Initialize React Native using @callstack/react-native-brownfield
        ReactNativeBrownfield.initialize(this, packages) { initialized ->
            if (initialized) {
                println("[RNBridgeDemo] React Native bundle loaded successfully")
            }
        }
    }
}
