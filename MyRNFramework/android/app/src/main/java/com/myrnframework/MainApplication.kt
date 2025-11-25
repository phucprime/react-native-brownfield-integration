package com.myrnframework

import android.app.Application
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared

/**
 * Application class for MyRNFramework.
 * Initializes React Native using the ReactNativeBrownfieldShared library.
 *
 * Usage:
 * 1. Add this class to your AndroidManifest.xml as the application class
 * 2. The React Native runtime will be initialized on app startup
 */
class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        
        // Initialize React Native using the brownfield shared library
        // This handles all the initialization including SoLoader and Hermes
        ReactNativeBrownfieldShared.startReactNative(
            application = this,
            bundleName = "index.android.bundle"
        )
    }
    
    override fun onTerminate() {
        super.onTerminate()
        // Clean up React Native resources if needed
    }
}
