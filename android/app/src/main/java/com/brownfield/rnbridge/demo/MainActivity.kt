package com.brownfield.rnbridge.demo

import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.FragmentActivity
import com.callstack.reactnativebrownfield.ReactNativeBrownfield
import com.brownfield.rnbridge.demo.ui.theme.RNBridgeDemoTheme

/**
 * Main Activity demonstrating how to integrate React Native views
 * within a native Android application using Jetpack Compose.
 * 
 * Uses @callstack/react-native-brownfield for proper brownfield integration.
 * Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/KOTLIN.md
 */
class MainActivity : FragmentActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            RNBridgeDemoTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MainScreen(
                        onOpenFullScreen = { openReactNativeFullScreen() }
                    )
                }
            }
        }
    }
    
    /**
     * Opens React Native as a full-screen Composable
     */
    private fun openReactNativeFullScreen() {
        setContent {
            RNBridgeDemoTheme {
                ReactNativeFullScreen(
                    moduleName = "MyRNFramework",
                    onBack = { recreate() }
                )
            }
        }
    }
}

/**
 * Main screen with options to integrate React Native
 */
@Composable
fun MainScreen(
    onOpenFullScreen: () -> Unit
) {
    var showEmbedded by remember { mutableStateOf(false) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(40.dp))
        
        Text(
            text = "React Native Brownfield Demo",
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Text(
            text = "This is a native Android app using\n@callstack/react-native-brownfield.\nChoose how to integrate React Native:",
            fontSize = 16.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Option 1: Open Full Screen Composable
        Button(
            onClick = onOpenFullScreen,
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text("Open Full Screen React Native")
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Option 2: Embed in Compose
        Button(
            onClick = { showEmbedded = !showEmbedded },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            shape = RoundedCornerShape(12.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = if (showEmbedded) 
                    MaterialTheme.colorScheme.error 
                else 
                    MaterialTheme.colorScheme.secondary
            )
        ) {
            Text(if (showEmbedded) "Remove Embedded View" else "Embed React Native View")
        }
        
        // Embedded React Native View
        if (showEmbedded) {
            Spacer(modifier = Modifier.height(24.dp))
            
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                )
            ) {
                EmbeddedReactNativeView(
                    moduleName = "MyRNFramework",
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
        
        Spacer(modifier = Modifier.weight(if (showEmbedded) 0f else 1f))
        
        // Status indicator
        Text(
            text = "Using @callstack/react-native-brownfield ✅",
            fontSize = 14.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        Spacer(modifier = Modifier.height(16.dp))
    }
}

/**
 * Embedded React Native view using @callstack/react-native-brownfield
 */
@Composable
fun EmbeddedReactNativeView(
    moduleName: String,
    modifier: Modifier = Modifier
) {
    val activity = LocalContext.current as FragmentActivity
    
    AndroidView(
        factory = { _ ->
            // Use official ReactNativeBrownfield.shared.createView() API
            ReactNativeBrownfield.shared.createView(activity, moduleName)
        },
        modifier = modifier
    )
}

/**
 * Full-screen React Native view
 */
@Composable
fun ReactNativeFullScreen(
    moduleName: String,
    onBack: () -> Unit
) {
    val activity = LocalContext.current as FragmentActivity
    
    Box(modifier = Modifier.fillMaxSize()) {
        AndroidView(
            factory = { _ ->
                // Use official ReactNativeBrownfield.shared.createView() API
                ReactNativeBrownfield.shared.createView(activity, moduleName)
            },
            modifier = Modifier.fillMaxSize()
        )
        
        // Back button overlay
        Button(
            onClick = onBack,
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.9f),
                contentColor = MaterialTheme.colorScheme.onSurface
            )
        ) {
            Text("← Back to Native")
        }
    }
}
