package com.myrnframework

import android.app.Application
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared
import com.facebook.react.PackageList
import com.facebook.react.ReactPackage
import com.facebook.soloader.SoLoader

/**
 * Application class for MyRNFramework.
 * Initializes React Native using the ReactNativeBrownfieldShared library
 * for embedding React Native as a framework in native Android applications.
 *
 * This follows the brownfield integration pattern recommended by:
 * - https://www.rockjs.dev/docs/brownfield/intro
 * - https://github.com/callstack/react-native-brownfield
 *
 * Usage:
 * 1. Add this class to your AndroidManifest.xml as the application class
 * 2. The React Native runtime will be initialized on app startup
 * 3. Use ReactNativeBrownfieldShared.getReactInstanceManager() to create views
 */
class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        
        // Initialize SoLoader for native libraries (required for Hermes)
        SoLoader.init(this, false)
        
        // Initialize React Native using the brownfield shared library
        // This handles all the initialization including SoLoader and Hermes
        ReactNativeBrownfieldShared.startReactNative(
            application = this,
            bundleName = "index.android.bundle",
            packages = getPackages()
        )
    }
    
    /**
     * Returns the list of ReactPackage used by this app.
     * Includes auto-linked packages from PackageList and custom native modules.
     */
    private fun getPackages(): List<ReactPackage> {
        // Packages that cannot be autolinked yet can be added manually here
        val packages = mutableListOf<ReactPackage>()
        
        // Add packages from @react-native-community/cli autolinking
        try {
            packages.addAll(PackageList(this).packages)
        } catch (e: Exception) {
            // PackageList may not be available in framework distribution mode
        }
        
        // Add custom native module package
        packages.add(NativeModulePackage())
        
        return packages
    }
    
    override fun onTerminate() {
        super.onTerminate()
        // Clean up React Native resources if needed
        // Note: onTerminate() is not called in production on real devices
    }
}
