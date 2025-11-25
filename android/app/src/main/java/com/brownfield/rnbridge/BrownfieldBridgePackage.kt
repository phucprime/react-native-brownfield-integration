package com.brownfield.rnbridge

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

/**
 * React Native package that provides the BrownfieldBridge native module.
 * 
 * This package is automatically registered by RNBridgeManager.
 * If you're managing packages manually, add this to your package list:
 * 
 * ```kotlin
 * override fun getPackages(): List<ReactPackage> {
 *     return listOf(
 *         MainReactPackage(),
 *         BrownfieldBridgePackage()
 *     )
 * }
 * ```
 */
class BrownfieldBridgePackage : ReactPackage {
    
    override fun createNativeModules(
        reactContext: ReactApplicationContext
    ): List<NativeModule> {
        return listOf(BrownfieldBridgeModule(reactContext))
    }
    
    override fun createViewManagers(
        reactContext: ReactApplicationContext
    ): List<ViewManager<*, *>> {
        return emptyList()
    }
}
