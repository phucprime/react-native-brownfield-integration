package com.brownfield.rnbridge.demo

import android.app.Application
import com.brownfield.rnbridge.BrownfieldBridgePackage
import com.brownfield.rnbridge.RNBridgeManager
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.soloader.SoLoader

/**
 * Main Application class for the RNBridge Demo app.
 * 
 * This demonstrates how to initialize React Native in an existing Android application
 * for brownfield integration.
 */
class MainApplication : Application(), ReactApplication {
    
    override val reactNativeHost: ReactNativeHost = object : DefaultReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> {
            // Get auto-linked packages
            val packages = PackageList(this).packages.toMutableList()
            // Add the brownfield bridge package
            packages.add(BrownfieldBridgePackage())
            return packages
        }

        override fun getJSMainModuleName(): String = "index"

        override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

        override val isNewArchEnabled: Boolean = false
        override val isHermesEnabled: Boolean = true
    }
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize SoLoader for React Native
        SoLoader.init(this, false)
        
        // Initialize the RNBridgeManager with custom configuration
        RNBridgeManager.initialize(
            this,
            RNBridgeManager.BridgeConfig(
                useDeveloperSupport = BuildConfig.DEBUG,
                jsBundleAsset = "index.android.bundle",
                jsMainModulePath = "index",
                packages = listOf(BrownfieldBridgePackage())
            )
        )
    }
}
