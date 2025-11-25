# React Native Brownfield Integration

Package React Native as a framework (XCFramework/AAR) and embed it into existing native iOS and Android applications.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        REACT NATIVE BROWNFIELD INTEGRATION                      │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              MyRNFramework/                                     │
│                       (React Native Framework Source)                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                                                                         │    │
│  │   src/App.tsx  ←──  React Native Components (JavaScript/TypeScript)     │    │
│  │   index.ts     ←──  Entry Point (AppRegistry.registerComponent)         │    │
│  │                                                                         │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                    │                                            │
│                                    ▼                                            │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │                         Build Commands                                   │   │
│  │                                                                          │   │
│  │   npm run package:ios     →  MyRNFramework.xcframework                   │   │
│  │   npm run package:android →  myrnframework.aar                           │   │
│  │                                                                          │   │
│  │   ─────────────────────────────────────────────────────────────────────  │   │
│  │   Rock CLI packages everything: RN runtime + JS bundle + native modules  │   │
│  │                                                                          │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │  Copy packaged frameworks
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              examples/                                          │
│                    (Pure Native Apps - No node_modules!)                        │
│                                                                                 │
│   ┌─────────────────────────────────┐   ┌─────────────────────────────────┐    │
│   │       ios-native-app/           │   │     android-native-app/         │    │
│   │     (Pure Native Swift)         │   │    (Pure Native Kotlin)         │    │
│   ├─────────────────────────────────┤   ├─────────────────────────────────┤    │
│   │                                 │   │                                 │    │
│   │  build/                         │   │  app/libs/                      │    │
│   │  └── MyRNFramework.xcframework  │   │  └── myrnframework.aar          │    │
│   │                                 │   │                                 │    │
│   │  Podfile                        │   │  build.gradle                   │    │
│   │  └── pod 'ReactBrownfield'      │   │  └── react-native-brownfield    │    │
│   │                                 │   │                                 │    │
│   │  RNBridgeDemo/                  │   │  app/src/.../nativeapp/         │    │
│   │  ├── AppDelegate.swift          │   │  ├── MainApplication.kt         │    │
│   │  └── ViewController.swift       │   │  └── MainActivity.kt            │    │
│   │                                 │   │                                 │    │
│   └─────────────────────────────────┘   └─────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
react-native-brownfield-integration/
│
├── MyRNFramework/                          # React Native framework source
│   ├── src/App.tsx                         # React Native UI components
│   ├── index.ts                            # Entry point (AppRegistry.registerComponent)
│   ├── package.json                        # Dependencies & scripts (bundle, package)
│   ├── ios/                                # iOS development app (uses node_modules)
│   │   ├── Podfile
│   │   └── MyRNFramework/
│   │       ├── AppDelegate.swift
│   │       └── NativeModule.swift
│   └── android/                            # Android development app (uses node_modules)
│       └── app/src/main/java/com/myrnframework/
│           ├── MainApplication.kt
│           └── MainActivity.kt
│
├── examples/                               # ⭐ TRUE BROWNFIELD EXAMPLES
│   │
│   ├── ios-native-app/                     # Pure native iOS app
│   │   ├── build/                          # Place XCFramework here after build
│   │   │   └── MyRNFramework.xcframework
│   │   ├── Podfile                         # Only ReactBrownfield pod
│   │   └── RNBridgeDemo/
│   │       ├── AppDelegate.swift           # ReactNativeBrownfield.shared.startReactNative()
│   │       └── ViewController.swift        # ReactNativeViewController usage
│   │
│   └── android-native-app/                 # Pure native Android app
│       ├── app/libs/                       # Place AAR here after build
│       │   └── myrnframework.aar
│       ├── build.gradle                    # Pure native, no RN gradle plugins
│       └── app/src/main/java/com/example/nativeapp/
│           ├── MainApplication.kt          # ReactNativeBrownfield.initialize()
│           └── MainActivity.kt             # Jetpack Compose + createView()
│
├── .github/                                # GitHub templates
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
│
├── LICENSE                                 # MIT License
├── CONTRIBUTING.md                         # Contribution guidelines
├── CHANGELOG.md                            # Version history
└── README.md                               # This file
```

## Key Concept: Development vs Production

This project demonstrates **two different integration modes**:

| Mode | Location | Use Case | How it Works |
|------|----------|----------|--------------|
| **Development** | `MyRNFramework/ios/` and `MyRNFramework/android/` | Developing the RN framework | Uses `node_modules` directly, Metro dev server |
| **Production (Brownfield)** | `examples/ios-native-app/` and `examples/android-native-app/` | Integrating into existing apps | Uses packaged XCFramework/AAR, **no node_modules** |

The `examples/` folder shows the **true brownfield pattern**: native apps that have **zero knowledge of React Native's build system** - they just consume pre-built binary frameworks.

## Quick Start

### Step 1: Build the React Native Framework

```bash
# Install dependencies
cd MyRNFramework
npm install

# Build iOS XCFramework (this is all you need!)
npm run package:ios
# Output: MyRNFramework/build/MyRNFramework.xcframework

# Build Android AAR (this is all you need!)
npm run package:android
# Output: MyRNFramework/build/myrnframework.aar
```

> **💡 What does `package:ios` / `package:android` do?**
> 
> These commands use [Rock CLI](https://www.rockjs.dev) to create a **complete, self-contained native framework** that includes:
> - React Native runtime (Hermes JS engine)
> - Your compiled JavaScript bundle
> - All native modules and dependencies
> 
> The output XCFramework/AAR can be used in any native app without needing node_modules or Metro bundler.

### Step 2: Copy Frameworks to Examples

```bash
# iOS - copy XCFramework
cp -r MyRNFramework/build/MyRNFramework.xcframework examples/ios-native-app/build/

# Android - copy AAR
cp MyRNFramework/build/myrnframework.aar examples/android-native-app/app/libs/
```

### Step 3: Run the Native Example Apps

**iOS:**
```bash
cd examples/ios-native-app
pod install
open RNBridge.xcodeproj
# Build and run in Xcode
```

**Android:**
```bash
cd examples/android-native-app
./gradlew assembleDebug
# Or open in Android Studio and run
```

---

## 📱 iOS: Embed XCFramework in Your Native App

### Method 1: Drag & Drop (Recommended for beginners)

**Step 1:** Build the XCFramework
```bash
cd MyRNFramework
npm install
npm run package:ios
# Creates: build/MyRNFramework.xcframework
```

**Step 2:** Add XCFramework to Xcode
1. Open your Xcode project
2. Select your app target → **General** tab
3. Scroll to **"Frameworks, Libraries, and Embedded Content"**
4. Click **"+"** → **"Add Other..."** → **"Add Files..."**
5. Navigate to and select `MyRNFramework.xcframework`
6. Set embed option to **"Embed & Sign"**

```
Your Xcode Project
├── YourApp.xcodeproj
├── YourApp/
│   ├── AppDelegate.swift
│   └── ...
└── Frameworks/                      ← XCFramework goes here
    └── MyRNFramework.xcframework
```

**Step 3:** Add ReactBrownfield via CocoaPods

Create or update your `Podfile`:
```ruby
platform :ios, '14.0'

target 'YourApp' do
  use_frameworks! :linkage => :static
  
  # React Native Brownfield integration library
  pod 'ReactBrownfield', :git => 'https://github.com/callstack/react-native-brownfield.git', :tag => '1.2.0'
end
```

Then run:
```bash
pod install
```

**Step 4:** Initialize in your AppDelegate
```swift
import UIKit
import ReactBrownfield

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize React Native - MUST be called before showing any RN views
        ReactNativeBrownfield.shared.startReactNative {
            print("✅ React Native loaded from XCFramework")
        }
        return true
    }
}
```

**Step 5:** Display React Native in your app

**Option A - UIKit (ViewController):**
```swift
import UIKit
import ReactBrownfield

class MyViewController: UIViewController {
    
    @IBAction func showReactNative(_ sender: Any) {
        // "MyRNFramework" must match AppRegistry.registerComponent name
        let rnViewController = ReactNativeViewController(moduleName: "MyRNFramework")
        navigationController?.pushViewController(rnViewController, animated: true)
    }
}
```

**Option B - SwiftUI:**
```swift
import SwiftUI
import ReactBrownfield

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Native SwiftUI Content")
            
            // Embed React Native view
            ReactNativeView(moduleName: "MyRNFramework")
                .frame(height: 400)
        }
    }
}
```

**Option C - Embed as child view:**
```swift
func embedReactNativeView() {
    guard let rnView = ReactNativeBrownfield.shared.view(
        moduleName: "MyRNFramework",
        initialProps: ["userId": "123"],
        launchOptions: nil
    ) else { return }
    
    view.addSubview(rnView)
    rnView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
}
```

---

## 🤖 Android: Embed AAR in Your Native App

### Method 1: Local AAR File (Recommended)

**Step 1:** Build the AAR
```bash
cd MyRNFramework
npm install
npm run package:android
# Creates: build/myrnframework.aar
```

**Step 2:** Copy AAR to your project
```bash
# Create libs folder if it doesn't exist
mkdir -p YourAndroidApp/app/libs

# Copy the AAR
cp MyRNFramework/build/myrnframework.aar YourAndroidApp/app/libs/
```

Your project structure:
```
YourAndroidApp/
├── app/
│   ├── build.gradle
│   ├── libs/                        ← AAR goes here
│   │   └── myrnframework.aar
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── java/com/yourapp/
│           ├── MainApplication.kt
│           └── MainActivity.kt
├── build.gradle
└── settings.gradle
```

**Step 3:** Configure `app/build.gradle`
```gradle
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
}

android {
    namespace = "com.yourapp"
    compileSdk = 34

    defaultConfig {
        minSdk = 24
        targetSdk = 34
    }
    
    // Required for Compose
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.8"
    }
}

dependencies {
    // ✅ Include AAR from libs folder
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.aar"))))
    
    // AndroidX & Compose dependencies
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.fragment:fragment-ktx:1.6.2")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation(platform("androidx.compose:compose-bom:2024.01.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
}
```

**Step 4:** Initialize in MainApplication.kt
```kotlin
package com.yourapp

import android.app.Application
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize React Native - MUST be called before showing any RN views
        ReactNativeBrownfield.initialize(
            application = this,
            packages = emptyList()  // Packages are bundled in the AAR
        ) { initialized ->
            println("✅ React Native loaded from AAR: $initialized")
        }
    }
}
```

**Step 5:** Display React Native in your app

**Option A - Jetpack Compose:**
```kotlin
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.FragmentActivity
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

@Composable
fun ReactNativeScreen() {
    val activity = LocalContext.current as FragmentActivity
    
    AndroidView(
        factory = { context ->
            // "MyRNFramework" must match AppRegistry.registerComponent name
            ReactNativeBrownfield.shared.createView(activity, "MyRNFramework")
        }
    )
}

// Usage in your navigation
@Composable
fun MainScreen() {
    var showRN by remember { mutableStateOf(false) }
    
    Column {
        Button(onClick = { showRN = true }) {
            Text("Open React Native")
        }
        
        if (showRN) {
            ReactNativeScreen()
        }
    }
}
```

**Option B - Traditional View/Activity:**
```kotlin
import android.os.Bundle
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
    
    fun showReactNative() {
        val container = findViewById<FrameLayout>(R.id.react_native_container)
        val rnView = ReactNativeBrownfield.shared.createView(this, "MyRNFramework")
        container.addView(rnView)
    }
}
```

**Option C - Start as new Activity:**
```kotlin
// Create a dedicated Activity for React Native
class ReactNativeActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        val rnView = ReactNativeBrownfield.shared.createView(this, "MyRNFramework")
        setContentView(rnView)
    }
}

// Launch from anywhere
startActivity(Intent(this, ReactNativeActivity::class.java))
```

---

## 🔧 Troubleshooting

### iOS Issues

| Problem | Solution |
|---------|----------|
| "No such module 'ReactBrownfield'" | Run `pod install` and open `.xcworkspace` (not `.xcodeproj`) |
| XCFramework not found | Ensure it's added in "Frameworks, Libraries, and Embedded Content" with "Embed & Sign" |
| App crashes on launch | Make sure `startReactNative()` is called in `AppDelegate` before any RN views |
| Module "MyRNFramework" not found | Verify the module name matches `AppRegistry.registerComponent('MyRNFramework', ...)` |

### Android Issues

| Problem | Solution |
|---------|----------|
| AAR not found | Verify AAR is in `app/libs/` and `fileTree` is in `build.gradle` dependencies |
| Crash on createView() | Ensure `ReactNativeBrownfield.initialize()` is called in `Application.onCreate()` |
| "Module MyRNFramework not registered" | Module name must match `AppRegistry.registerComponent` in your RN code |
| Gradle sync fails | Make sure compileSdk ≥ 34 and minSdk ≥ 24 |

---

## 📋 Checklist: Embed in Your Existing App

### iOS Checklist
- [ ] Build XCFramework: `npm run package:ios` in MyRNFramework/
- [ ] Add XCFramework to Xcode project (Embed & Sign)
- [ ] Add `ReactBrownfield` pod to Podfile
- [ ] Run `pod install`
- [ ] Open `.xcworkspace` (not `.xcodeproj`)
- [ ] Call `ReactNativeBrownfield.shared.startReactNative()` in AppDelegate
- [ ] Use `ReactNativeViewController` or `ReactNativeView` to display

### Android Checklist
- [ ] Build AAR: `npm run package:android` in MyRNFramework/
- [ ] Copy AAR to `app/libs/` folder
- [ ] Add `fileTree` to `build.gradle` dependencies
- [ ] Call `ReactNativeBrownfield.initialize()` in Application class
- [ ] Register Application class in AndroidManifest.xml
- [ ] Use `ReactNativeBrownfield.shared.createView()` to display

---

## How AAR/XCFramework Works

When you package React Native as AAR (Android) or XCFramework (iOS), you're creating a **self-contained native library** that includes:

| Component | Description |
|-----------|-------------|
| **React Native Runtime** | The JS engine (Hermes) and native bridge |
| **JavaScript Bundle** | Your compiled RN code (`main.jsbundle` / `index.android.bundle`) |
| **Native Modules** | Any native code your RN app uses |
| **Assets** | Images, fonts, and other resources |

### What This Means for Your Native App

✅ **No node_modules needed** - The AAR/XCFramework is completely self-contained  
✅ **No Metro server** - JS bundle is embedded inside the framework  
✅ **No React Native CLI** - Just import and use like any native library  
✅ **No build system changes** - Standard Xcode/Gradle builds work  

### Updating Your React Native Code

To update the React Native portion:
1. Make changes in `MyRNFramework/src/`
2. Rebuild: `npm run package:ios` or `npm run package:android`
3. Replace the old XCFramework/AAR with the new one
4. Rebuild your native app

---

## 📦 Available Build Commands

The `MyRNFramework/package.json` includes several build scripts. Here's what each one does:

### For Brownfield Integration (USE THESE)

| Command | Output | Description |
|---------|--------|-------------|
| `npm run package:ios` | `build/MyRNFramework.xcframework` | **Complete iOS framework** with RN runtime + JS bundle. Drop into any Xcode project. |
| `npm run package:android` | `build/myrnframework.aar` | **Complete Android library** with RN runtime + JS bundle. Drop into any Android project. |

### For Development Only (DON'T USE FOR BROWNFIELD)

| Command | Output | Description |
|---------|--------|-------------|
| `npm run bundle:ios` | `ios/main.jsbundle` | Creates JS bundle only. Used internally during development. |
| `npm run bundle:android` | `android/.../index.android.bundle` | Creates JS bundle only. Used internally during development. |
| `npm run ios` | — | Runs the dev app in iOS Simulator with Metro server. |
| `npm run android` | — | Runs the dev app in Android Emulator with Metro server. |

### When to Use What

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   "I want to embed React Native in my existing native app"                  │
│                                                                             │
│   → Use: npm run package:ios  or  npm run package:android                   │
│   → Get: XCFramework/AAR that works standalone                              │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   "I want to develop/debug the React Native code"                           │
│                                                                             │
│   → Use: npm run ios  or  npm run android                                   │
│   → Get: Live development with Metro hot reload                             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Important Notes

| Aspect | Description |
|--------|-------------|
| **Module Name** | Must match `AppRegistry.registerComponent('MyRNFramework', ...)` in `index.ts` |
| **JS Bundle** | Embedded inside AAR/XCFramework - no separate file needed at runtime |
| **Updates** | To update RN code, rebuild AAR/XCFramework and replace in native project |
| **Debug vs Release** | Development apps use Metro; Production apps use embedded bundle |

## Key Technologies

| Component | iOS | Android |
|-----------|-----|---------|
| **Framework** | XCFramework | AAR |
| **Bridge Library** | ReactBrownfield | react-native-brownfield |
| **UI Integration** | ReactNativeView / ReactNativeViewController | createView() |
| **JS Engine** | Hermes | Hermes |
| **Bundler** | Metro | Metro |
| **Packaging** | Rock CLI | Rock CLI |

## Tools & Dependencies

- **[Rock CLI](https://www.rockjs.dev)** - Package React Native as native frameworks
- **[@callstack/react-native-brownfield](https://github.com/callstack/react-native-brownfield)** - Official brownfield integration library

## License

MIT
