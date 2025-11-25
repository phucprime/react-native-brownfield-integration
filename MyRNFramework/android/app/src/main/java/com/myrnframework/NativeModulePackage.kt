package com.myrnframework

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

/**
 * React Native package that provides the NativeModule.
 *
 * This package should be added to the package list in your React Native setup:
 *
 * ```kotlin
 * override fun getPackages(): List<ReactPackage> {
 *     return listOf(
 *         MainReactPackage(),
 *         NativeModulePackage()
 *     )
 * }
 * ```
 */
class NativeModulePackage : ReactPackage {

    override fun createNativeModules(
        reactContext: ReactApplicationContext
    ): List<NativeModule> {
        return listOf(NativeModule(reactContext))
    }

    override fun createViewManagers(
        reactContext: ReactApplicationContext
    ): List<ViewManager<*, *>> {
        return emptyList()
    }
}
