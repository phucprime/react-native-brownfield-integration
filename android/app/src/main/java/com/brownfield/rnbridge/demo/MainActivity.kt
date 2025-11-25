package com.brownfield.rnbridge.demo

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import com.brownfield.rnbridge.RNBridgeActivity
import com.brownfield.rnbridge.RNBridgeManager
import com.brownfield.rnbridge.RNBridgeView
import com.brownfield.rnbridge.demo.ui.theme.RNBridgeDemoTheme

/**
 * Main Activity demonstrating how to integrate React Native views
 * within a native Android application using Jetpack Compose.
 */
class MainActivity : ComponentActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            RNBridgeDemoTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MainScreen(
                        onOpenFullScreen = { openReactNativeFullScreen() },
                        onOpenActivity = { openReactNativeActivity() }
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
                    moduleName = "BrownfieldScreen",
                    onBack = { recreate() }
                )
            }
        }
    }
    
    /**
     * Opens React Native in a separate Activity
     */
    private fun openReactNativeActivity() {
        val intent = Intent(this, RNBridgeActivity::class.java).apply {
            putExtra(RNBridgeActivity.EXTRA_MODULE_NAME, "BrownfieldScreen")
            putExtra(RNBridgeActivity.EXTRA_INITIAL_PROPS, Bundle().apply {
                putString("title", "React Native Activity")
                putString("source", "Android Activity")
            })
        }
        startActivity(intent)
    }
}

/**
 * Main screen with options to integrate React Native
 */
@Composable
fun MainScreen(
    onOpenFullScreen: () -> Unit,
    onOpenActivity: () -> Unit
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
            text = "This is a native Android app.\nChoose how to integrate React Native:",
            fontSize = 16.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Option 1: Open as Activity
        Button(
            onClick = onOpenActivity,
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            shape = RoundedCornerShape(12.dp)
        ) {
            Text("Open React Native Activity")
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Option 2: Open Full Screen Composable
        Button(
            onClick = onOpenFullScreen,
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            shape = RoundedCornerShape(12.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = MaterialTheme.colorScheme.secondary
            )
        ) {
            Text("Open Full Screen (Compose)")
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Option 3: Embed in Compose
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
                    MaterialTheme.colorScheme.tertiary
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
                    moduleName = "BrownfieldScreen",
                    modifier = Modifier.fillMaxSize()
                )
            }
        }
        
        Spacer(modifier = Modifier.weight(if (showEmbedded) 0f else 1f))
        
        // Status indicator
        val isReady = RNBridgeManager.isReady()
        Text(
            text = if (isReady) "Bridge Ready ✅" else "Bridge Loading...",
            fontSize = 14.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        Spacer(modifier = Modifier.height(16.dp))
    }
}

/**
 * Embedded React Native view using AndroidView
 */
@Composable
fun EmbeddedReactNativeView(
    moduleName: String,
    modifier: Modifier = Modifier,
    initialProps: Bundle? = null
) {
    AndroidView(
        factory = { context ->
            RNBridgeView(context).apply {
                setModuleName(moduleName)
                setInitialProps(initialProps ?: Bundle().apply {
                    putString("title", "Embedded RN View")
                    putString("source", "Android Compose")
                    putBoolean("compact", true)
                })
                startReactApplication()
            }
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
    var showBackButton by remember { mutableStateOf(true) }
    
    Box(modifier = Modifier.fillMaxSize()) {
        AndroidView(
            factory = { context ->
                RNBridgeView(context).apply {
                    setModuleName(moduleName)
                    setInitialProps(Bundle().apply {
                        putString("title", "Full Screen RN")
                        putString("source", "Android Full Screen")
                    })
                    startReactApplication()
                }
            },
            modifier = Modifier.fillMaxSize()
        )
        
        // Back button overlay
        if (showBackButton) {
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
}
