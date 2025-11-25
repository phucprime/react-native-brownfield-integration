package com.myrnframework

import android.widget.Toast
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

/**
 * Native module that exposes Android functionality to React Native.
 * Demonstrates common native bridge patterns for brownfield integration.
 *
 * Usage in React Native:
 * ```javascript
 * import { NativeModules } from 'react-native';
 *
 * NativeModules.NativeModule.showNativeAlert("Hello from RN!");
 * const info = await NativeModules.NativeModule.getDeviceInfo();
 * ```
 */
class NativeModule(
    private val reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = NAME

    /**
     * Shows a native Android toast message.
     *
     * @param message The message to display in the toast
     */
    @ReactMethod
    fun showNativeAlert(message: String) {
        reactContext.currentActivity?.runOnUiThread {
            Toast.makeText(reactContext, message, Toast.LENGTH_LONG).show()
        }
    }

    /**
     * Gets device information and returns it to React Native.
     *
     * @param promise Promise to resolve with device info
     */
    @ReactMethod
    fun getDeviceInfo(promise: Promise) {
        try {
            val deviceInfo = mapOf(
                "manufacturer" to android.os.Build.MANUFACTURER,
                "model" to android.os.Build.MODEL,
                "brand" to android.os.Build.BRAND,
                "sdkVersion" to android.os.Build.VERSION.SDK_INT,
                "release" to android.os.Build.VERSION.RELEASE,
                "device" to android.os.Build.DEVICE
            )
            
            val writableMap = com.facebook.react.bridge.Arguments.createMap()
            deviceInfo.forEach { (key, value) ->
                when (value) {
                    is String -> writableMap.putString(key, value)
                    is Int -> writableMap.putInt(key, value)
                }
            }
            
            promise.resolve(writableMap)
        } catch (e: Exception) {
            promise.reject("ERROR", "Failed to get device info", e)
        }
    }

    /**
     * Triggers vibration feedback on the device.
     *
     * @param duration Duration of vibration in milliseconds
     */
    @ReactMethod
    fun triggerVibration(duration: Int) {
        try {
            val vibrator = reactContext.getSystemService(android.content.Context.VIBRATOR_SERVICE) 
                as? android.os.Vibrator
            
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                vibrator?.vibrate(
                    android.os.VibrationEffect.createOneShot(
                        duration.toLong(),
                        android.os.VibrationEffect.DEFAULT_AMPLITUDE
                    )
                )
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(duration.toLong())
            }
        } catch (e: Exception) {
            // Vibration may not be available on all devices
        }
    }

    /**
     * Opens a URL in the default browser or appropriate app.
     *
     * @param url The URL to open
     * @param promise Promise to resolve with success/failure
     */
    @ReactMethod
    fun openURL(url: String, promise: Promise) {
        try {
            val intent = android.content.Intent(android.content.Intent.ACTION_VIEW).apply {
                data = android.net.Uri.parse(url)
                addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            
            reactContext.currentActivity?.startActivity(intent)
                ?: reactContext.startActivity(intent)
            
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("OPEN_FAILED", "Failed to open URL: ${e.message}", e)
        }
    }

    companion object {
        const val NAME = "NativeModule"
    }
}
