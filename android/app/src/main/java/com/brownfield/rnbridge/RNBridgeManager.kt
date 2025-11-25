package com.brownfield.rnbridge

import android.app.Application
import android.content.Context
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.common.LifecycleState
import com.facebook.soloader.SoLoader

/**
 * RNBridgeManager manages the React Native instance for brownfield integration.
 * 
 * This singleton class handles initialization and lifecycle management of
 * React Native within an existing Android application.
 * 
 * Usage:
 * 1. Initialize in Application.onCreate(): RNBridgeManager.initialize(this)
 * 2. Create views: RNBridgeManager.getInstance().createReactView(activity, "ComponentName")
 */
object RNBridgeManager {
    
    private var application: Application? = null
    private var reactInstanceManager: ReactInstanceManager? = null
    private var isInitialized = false
    
    /**
     * Listener interface for React Native bridge events
     */
    interface BridgeListener {
        fun onBridgeReady()
        fun onBridgeError(error: Exception)
    }
    
    private var bridgeListener: BridgeListener? = null
    
    /**
     * Configuration options for the React Native bridge
     */
    data class BridgeConfig(
        val useDeveloperSupport: Boolean = false,
        val jsBundleAsset: String = "index.android.bundle",
        val jsMainModulePath: String = "index",
        val packages: List<ReactPackage> = emptyList()
    )
    
    private var config: BridgeConfig = BridgeConfig()
    
    /**
     * Initializes the React Native bridge with default configuration.
     * Call this from Application.onCreate()
     * 
     * @param application The Android Application instance
     */
    @JvmStatic
    fun initialize(application: Application) {
        initialize(application, BridgeConfig())
    }
    
    /**
     * Initializes the React Native bridge with custom configuration.
     * Call this from Application.onCreate()
     * 
     * @param application The Android Application instance
     * @param config Configuration options for the bridge
     */
    @JvmStatic
    fun initialize(application: Application, config: BridgeConfig) {
        if (isInitialized) {
            return
        }
        
        this.application = application
        this.config = config
        
        // Initialize SoLoader for native libraries
        SoLoader.init(application, false)
        
        // Create the ReactInstanceManager
        createReactInstanceManager()
        
        isInitialized = true
    }
    
    /**
     * Sets a listener for bridge events
     */
    @JvmStatic
    fun setBridgeListener(listener: BridgeListener?) {
        bridgeListener = listener
    }
    
    /**
     * Returns the ReactInstanceManager for advanced usage
     */
    @JvmStatic
    fun getReactInstanceManager(): ReactInstanceManager? {
        return reactInstanceManager
    }
    
    /**
     * Checks if the bridge is initialized and ready
     */
    @JvmStatic
    fun isReady(): Boolean {
        return isInitialized && reactInstanceManager != null
    }
    
    /**
     * Creates the ReactInstanceManager
     */
    private fun createReactInstanceManager() {
        val app = application ?: return
        
        val builder = ReactInstanceManager.builder()
            .setApplication(app)
            .setCurrentActivity(null)
            .setBundleAssetName(config.jsBundleAsset)
            .setJSMainModulePath(config.jsMainModulePath)
            .setUseDeveloperSupport(config.useDeveloperSupport)
            .setInitialLifecycleState(LifecycleState.BEFORE_CREATE)
        
        // Add default packages
        try {
            val packages = PackageList(app).packages
            for (pkg in packages) {
                builder.addPackage(pkg)
            }
        } catch (e: Exception) {
            // PackageList may not be available in all configurations
        }
        
        // Add the brownfield bridge package
        builder.addPackage(BrownfieldBridgePackage())
        
        // Add custom packages from config
        for (pkg in config.packages) {
            builder.addPackage(pkg)
        }
        
        reactInstanceManager = builder.build()
        
        bridgeListener?.onBridgeReady()
    }
    
    /**
     * Cleans up the React Native instance.
     * Call this when React Native is no longer needed.
     */
    @JvmStatic
    fun destroy() {
        reactInstanceManager?.destroy()
        reactInstanceManager = null
        isInitialized = false
        application = null
    }
    
    /**
     * Gets the application context
     */
    @JvmStatic
    fun getContext(): Context? {
        return application?.applicationContext
    }
}
