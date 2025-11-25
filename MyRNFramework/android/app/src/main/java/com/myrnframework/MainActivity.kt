package com.myrnframework

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared
import com.facebook.react.ReactRootView

/**
 * MainActivity demonstrating React Native brownfield integration with Jetpack Compose.
 *
 * This activity shows how to:
 * 1. Initialize React Native using ReactNativeBrownfieldShared
 * 2. Embed React Native views in Jetpack Compose using AndroidView
 * 3. Pass initial properties to React Native components
 */
class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Start React Native with the brownfield shared library
        ReactNativeBrownfieldShared.startReactNative(
            application = application,
            bundleName = "index.android.bundle"
        )
        
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ReactNativeScreen(
                        moduleName = "MyRNFramework",
                        initialProperties = mapOf("greeting" to "Hello from Compose!")
                    )
                }
            }
        }
    }
}

/**
 * A Composable that embeds a React Native view using AndroidView.
 *
 * @param moduleName The registered React Native component name
 * @param initialProperties Optional properties to pass to the React Native component
 */
@Composable
fun ReactNativeScreen(
    moduleName: String,
    initialProperties: Map<String, Any>? = null
) {
    AndroidView(
        factory = { context ->
            ReactRootView(context).apply {
                // Convert Map to Bundle for initial properties
                val bundle = initialProperties?.let { props ->
                    Bundle().apply {
                        props.forEach { (key, value) ->
                            when (value) {
                                is String -> putString(key, value)
                                is Int -> putInt(key, value)
                                is Boolean -> putBoolean(key, value)
                                is Double -> putDouble(key, value)
                                is Float -> putFloat(key, value)
                            }
                        }
                    }
                }
                
                // Start the React Native application
                startReactApplication(
                    ReactNativeBrownfieldShared.getReactInstanceManager(),
                    moduleName,
                    bundle
                )
            }
        },
        modifier = Modifier.fillMaxSize(),
        update = { /* React Native handles updates internally */ }
    )
}
