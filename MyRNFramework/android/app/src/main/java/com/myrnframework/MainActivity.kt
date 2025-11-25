package com.myrnframework

import android.os.Bundle
import android.os.Bundle as AndroidBundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.FragmentActivity
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

/**
 * MainActivity demonstrating React Native brownfield integration with Jetpack Compose.
 *
 * Uses @callstack/react-native-brownfield library for proper integration.
 * Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/KOTLIN.md
 *
 * This activity shows how to:
 * 1. Use ReactNativeBrownfield.shared.createView() to embed React Native in Compose
 * 2. Pass initial properties to React Native components
 */
class MainActivity : FragmentActivity() {

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
                        launchOptions = AndroidBundle().apply {
                            putString("greeting", "Hello from Compose!")
                        }
                    )
                }
            }
        }
    }
}

/**
 * A Composable that embeds a React Native view using ReactNativeBrownfield.shared.createView().
 * This is the recommended approach from @callstack/react-native-brownfield.
 *
 * @param moduleName The registered React Native component name
 * @param launchOptions Optional Bundle to pass to the React Native component
 * @param modifier Modifier for the composable
 */
@Composable
fun ReactNativeScreen(
    moduleName: String = MainActivity.MODULE_NAME,
    launchOptions: AndroidBundle? = null,
    modifier: Modifier = Modifier.fillMaxSize()
) {
    val context = LocalContext.current
    val fragmentActivity = context as? FragmentActivity
    
    Box(modifier = modifier) {
        AndroidView(
            factory = { _ ->
                // Use ReactNativeBrownfield.shared.createView() as per the official docs
                ReactNativeBrownfield.shared.createView(
                    fragmentActivity,
                    moduleName,
                    null,  // reactDelegate - let the library handle it
                    launchOptions
                )
            },
            modifier = Modifier.fillMaxSize()
        )
    }
}
