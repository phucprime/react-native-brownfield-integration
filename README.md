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
│  │                      Metro Bundler / Rock CLI                            │   │
│  │                                                                          │   │
│  │   npm run bundle:ios      →  main.jsbundle (iOS)                         │   │
│  │   npm run bundle:android  →  index.android.bundle (Android)              │   │
│  │   npm run package:ios     →  MyRNFramework.xcframework                   │   │
│  │   npm run package:android →  myrnframework.aar                           │   │
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

# Build iOS XCFramework
npm run package:ios
# Output: MyRNFramework/build/MyRNFramework.xcframework

# Build Android AAR  
npm run package:android
# Output: MyRNFramework/build/myrnframework.aar
```

### Step 2: Copy Frameworks to Examples

```bash
# iOS
cp -r MyRNFramework/build/MyRNFramework.xcframework examples/ios-native-app/build/

# Android
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

## How AAR/XCFramework Works

When you package React Native as AAR (Android) or XCFramework (iOS), you're creating a **self-contained native library** that includes:

1. **React Native runtime** - The JS engine (Hermes) and bridge
2. **JavaScript bundle** - Your compiled React Native code (`main.jsbundle` / `index.android.bundle`)
3. **Native modules** - Any native code your RN app uses

### Build Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUILD PROCESS                                     │
└─────────────────────────────────────────────────────────────────────────────┘

  MyRNFramework/
  ├── src/App.tsx          ─┐
  ├── index.ts              │    Metro Bundler
  └── node_modules/        ─┴──────────────────┐
                                               │
                                               ▼
                           ┌───────────────────────────────────────┐
                           │  JavaScript Bundle                    │
                           │  • main.jsbundle (iOS)                │
                           │  • index.android.bundle (Android)     │
                           └───────────────────────────────────────┘
                                               │
                                               │  Rock CLI / Gradle
                                               ▼
              ┌────────────────────────────────┴────────────────────────────────┐
              │                                                                 │
              ▼                                                                 ▼
┌──────────────────────────────┐                         ┌──────────────────────────────┐
│   MyRNFramework.xcframework  │                         │   myrnframework.aar          │
│   (iOS Native Library)       │                         │   (Android Native Library)   │
├──────────────────────────────┤                         ├──────────────────────────────┤
│ • React Native runtime       │                         │ • React Native runtime       │
│ • Hermes JS engine           │                         │ • Hermes JS engine           │
│ • main.jsbundle (embedded)   │                         │ • index.android.bundle       │
│ • Native modules             │                         │ • Native modules             │
└──────────────────────────────┘                         └──────────────────────────────┘
              │                                                       │
              │                                                       │
              ▼                                                       ▼
┌──────────────────────────────┐                         ┌──────────────────────────────┐
│   examples/ios-native-app/   │                         │ examples/android-native-app/ │
│   build/                     │                         │   app/libs/                  │
│   └── MyRNFramework.xcfwk    │                         │   └── myrnframework.aar      │
│                              │                         │                              │
│   Podfile (ReactBrownfield)  │                         │   build.gradle (brownfield)  │
│                              │                         │                              │
│   ✅ No node_modules         │                         │   ✅ No node_modules         │
│   ✅ No Metro server         │                         │   ✅ No Metro server         │
│   ✅ Pure native app         │                         │   ✅ Pure native app         │
└──────────────────────────────┘                         └──────────────────────────────┘
```

---

## Native App Integration

### iOS Integration (Swift)

**AppDelegate.swift:**
```swift
import UIKit
import ReactBrownfield

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize React Native (loads JS bundle from XCFramework)
        ReactNativeBrownfield.shared.startReactNative {
            print("React Native framework loaded")
        }
        return true
    }
}
```

**Using ReactNativeViewController:**
```swift
import ReactBrownfield

// Push navigation
let rnVC = ReactNativeViewController(moduleName: "MyRNFramework")
navigationController?.pushViewController(rnVC, animated: true)

// Modal presentation
present(rnVC, animated: true)
```

**Using SwiftUI:**
```swift
import SwiftUI
import ReactBrownfield

struct ContentView: View {
    var body: some View {
        ReactNativeView(moduleName: "MyRNFramework")
    }
}
```

### Android Integration (Kotlin)

**MainApplication.kt:**
```kotlin
import android.app.Application
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Initialize React Native (loads JS bundle from AAR)
        ReactNativeBrownfield.initialize(this, emptyList()) { initialized ->
            println("React Native framework loaded: $initialized")
        }
    }
}
```

**Using Jetpack Compose:**
```kotlin
import androidx.compose.ui.viewinterop.AndroidView
import com.callstack.reactnativebrownfield.ReactNativeBrownfield

@Composable
fun ReactNativeScreen() {
    val activity = LocalContext.current as FragmentActivity
    AndroidView(
        factory = {
            ReactNativeBrownfield.shared.createView(activity, "MyRNFramework")
        }
    )
}
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
