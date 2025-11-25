package com.myrnframework

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared
import com.facebook.react.ReactRootView

/**
 * MainActivity demonstrating React Native brownfield integration with Jetpack Compose.
 *
 * This implementation follows the brownfield integration guidelines from:
 * - https://www.rockjs.dev/docs/brownfield/intro
 * - https://github.com/callstack/react-native-brownfield
 *
 * This activity shows how to:
 * 1. Initialize React Native using ReactNativeBrownfieldShared
 * 2. Embed React Native views in Jetpack Compose using AndroidView
 * 3. Pass initial properties to React Native components
 * 4. Handle lifecycle events properly
 */
class MainActivity : ComponentActivity() {

    companion object {
        /** The default React Native module name for this framework */
        const val MODULE_NAME = "MyRNFramework"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ReactNativeScreen(
                        moduleName = MODULE_NAME,
                        initialProperties = mapOf("greeting" to "Hello from Compose!")
                    )
                }
            }
        }
    }
}

/**
 * A Composable that embeds a React Native view using AndroidView.
 * Handles loading states, errors, and proper lifecycle management.
 *
 * @param moduleName The registered React Native component name
 * @param initialProperties Optional properties to pass to the React Native component
 * @param modifier Modifier for the composable
 */
@Composable
fun ReactNativeScreen(
    moduleName: String = MainActivity.MODULE_NAME,
    initialProperties: Map<String, Any>? = null,
    modifier: Modifier = Modifier.fillMaxSize()
) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    var isLoading by remember { mutableStateOf(true) }
    var hasError by remember { mutableStateOf(false) }
    var reactRootView by remember { mutableStateOf<ReactRootView?>(null) }
    
    // Handle lifecycle events
    DisposableEffect(lifecycleOwner) {
        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_RESUME -> {
                    reactRootView?.let {
                        // React Native will resume automatically via ReactInstanceManager
                    }
                }
                Lifecycle.Event.ON_PAUSE -> {
                    reactRootView?.let {
                        // React Native will pause automatically via ReactInstanceManager
                    }
                }
                Lifecycle.Event.ON_DESTROY -> {
                    reactRootView?.unmountReactApplication()
                    reactRootView = null
                }
                else -> {}
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        
        onDispose {
            lifecycleOwner.lifecycle.removeObserver(observer)
            reactRootView?.unmountReactApplication()
        }
    }
    
    Box(modifier = modifier) {
        if (hasError) {
            // Error state
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Failed to load React Native view.\nEnsure ReactNativeBrownfieldShared is initialized.",
                    color = Color.Red,
                    modifier = Modifier.padding(16.dp)
                )
            }
        } else {
            // React Native view
            AndroidView(
                factory = { ctx ->
                    ReactRootView(ctx).also { view ->
                        reactRootView = view
                        
                        try {
                            val reactInstanceManager = ReactNativeBrownfieldShared.getReactInstanceManager()
                            
                            if (reactInstanceManager == null) {
                                hasError = true
                                return@also
                            }
                            
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
                                            is Long -> putLong(key, value)
                                        }
                                    }
                                }
                            }
                            
                            // Start the React Native application
                            view.startReactApplication(
                                reactInstanceManager,
                                moduleName,
                                bundle
                            )
                            
                            isLoading = false
                        } catch (e: Exception) {
                            hasError = true
                        }
                    }
                },
                modifier = Modifier.fillMaxSize(),
                update = { /* React Native handles updates internally */ }
            )
            
            // Loading indicator
            if (isLoading && !hasError) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator()
                }
            }
        }
    }
}
