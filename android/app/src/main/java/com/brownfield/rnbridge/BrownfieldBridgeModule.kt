package com.brownfield.rnbridge

import android.content.Intent
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap

/**
 * Native module that provides communication between React Native and native Android code.
 * 
 * This module enables React Native components to:
 * - Navigate back to native screens
 * - Send data to native code
 * - Trigger native actions
 */
class BrownfieldBridgeModule(
    private val reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {
    
    companion object {
        const val NAME = "BrownfieldBridge"
        const val ACTION_NAVIGATE_BACK = "com.brownfield.rnbridge.NAVIGATE_BACK"
        const val ACTION_DATA_CHANGE = "com.brownfield.rnbridge.DATA_CHANGE"
        const val EXTRA_DATA = "data"
    }
    
    override fun getName(): String = NAME
    
    /**
     * Called from React Native to navigate back to the native view.
     * Sends a local broadcast that can be received by native activities.
     */
    @ReactMethod
    fun navigateBack() {
        // Send broadcast to notify native code
        val intent = Intent(ACTION_NAVIGATE_BACK)
        LocalBroadcastManager.getInstance(reactContext).sendBroadcast(intent)
        
        // Also try to finish the current activity if it's an RNBridgeActivity
        reactContext.currentActivity?.let { activity ->
            if (activity is RNBridgeActivity) {
                activity.runOnUiThread {
                    activity.finish()
                }
            }
        }
    }
    
    /**
     * Called from React Native when data changes.
     * Sends a local broadcast with the updated data.
     * 
     * @param data The updated data from React Native
     */
    @ReactMethod
    fun onDataChange(data: ReadableMap?) {
        val intent = Intent(ACTION_DATA_CHANGE).apply {
            data?.let {
                putExtra(EXTRA_DATA, it.toHashMap().toString())
            }
        }
        LocalBroadcastManager.getInstance(reactContext).sendBroadcast(intent)
    }
    
    /**
     * Shows a native toast message.
     * This is a simple example of exposing native functionality to React Native.
     * 
     * @param message The message to display
     */
    @ReactMethod
    fun showToast(message: String) {
        reactContext.currentActivity?.runOnUiThread {
            android.widget.Toast.makeText(
                reactContext,
                message,
                android.widget.Toast.LENGTH_SHORT
            ).show()
        }
    }
}
