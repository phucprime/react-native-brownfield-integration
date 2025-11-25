# React Native Brownfield Integration

Embed React Native into existing native iOS and Android applications. This repository provides a complete solution for brownfield integration, allowing you to incrementally add React Native features to your existing native apps.

## Overview

Brownfield integration is ideal when:
- You have an existing native app and want to add React Native features incrementally
- You want to reuse React Native code across multiple native apps
- You need specific screens or features built with React Native within a native shell
- You want to maintain native navigation while using React Native for content

## Project Structure

```
├── react-native-bundle/     # Shared React Native JavaScript code
│   ├── src/
│   │   ├── BrownfieldScreen.js    # Sample screen component
│   │   └── SharedFeature.js       # Reusable feature component
│   ├── index.js                   # Entry point & component registration
│   └── package.json
├── ios/                     # iOS native integration
│   └── RNBridge/
│       ├── RNBridgeManager.swift         # Bridge singleton manager
│       ├── RNBridgeViewController.swift  # View controller for RN views
│       ├── BrownfieldBridgeModule.swift  # Native module for RN→Native
│       └── BrownfieldBridgeModule.m      # Objective-C bridge
└── android/                 # Android native integration
    └── app/src/main/java/com/brownfield/rnbridge/
        ├── RNBridgeManager.kt        # Bridge singleton manager
        ├── RNBridgeActivity.kt       # Activity for hosting RN views
        ├── RNBridgeView.kt           # Custom view for embedding RN
        ├── BrownfieldBridgeModule.kt # Native module for RN→Native
        └── BrownfieldBridgePackage.kt
```

## Getting Started

### 1. React Native Bundle Setup

```bash
cd react-native-bundle
npm install
```

### 2. Building the JavaScript Bundle

For iOS:
```bash
npm run bundle:ios
```

For Android:
```bash
npm run bundle:android
```

## iOS Integration

### Setup

1. Add React Native dependencies to your Podfile:

```ruby
require_relative '../react-native-bundle/node_modules/react-native/scripts/react_native_pods'

target 'YourApp' do
  use_react_native!
end
```

2. Copy the `ios/RNBridge` folder to your Xcode project.

3. Add the generated `main.jsbundle` to your app bundle.

### Usage

Initialize the bridge in your AppDelegate:

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // For development (Metro bundler)
        RNBridgeManager.shared.initialize(
            source: .metro(host: "localhost", port: 8081),
            launchOptions: launchOptions
        )
        
        // For production (bundled JS)
        // RNBridgeManager.shared.initialize(
        //     source: .localBundle(filename: "main"),
        //     launchOptions: launchOptions
        // )
        
        return true
    }
}
```

Present a React Native screen:

```swift
// Push onto navigation stack
let rnViewController = RNBridgeViewController(
    moduleName: "BrownfieldScreen",
    initialProperties: ["title": "My RN Screen", "message": "Hello from native!"]
)
navigationController?.pushViewController(rnViewController, animated: true)

// Or present modally
present(rnViewController, animated: true)
```

Handle navigation callbacks from React Native:

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNavigateBack),
            name: BrownfieldBridgeModule.navigateBackNotification,
            object: nil
        )
    }
    
    @objc func handleNavigateBack() {
        navigationController?.popViewController(animated: true)
    }
}
```

## Android Integration

### Setup

1. Add React Native dependencies to your `build.gradle`:

```groovy
dependencies {
    implementation "com.facebook.react:react-android"
    implementation "com.facebook.react:hermes-android"
}
```

2. Copy the `android/app/src/main/java/com/brownfield/rnbridge` folder to your project.

3. Copy the bundled JS to `app/src/main/assets/index.android.bundle`.

### Usage

Initialize the bridge in your Application class:

```kotlin
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        RNBridgeManager.initialize(this, RNBridgeManager.BridgeConfig(
            useDeveloperSupport = BuildConfig.DEBUG,
            jsBundleAsset = "index.android.bundle"
        ))
    }
}
```

Launch a React Native Activity:

```kotlin
val intent = Intent(this, RNBridgeActivity::class.java).apply {
    putExtra(RNBridgeActivity.EXTRA_MODULE_NAME, "BrownfieldScreen")
    putExtra(RNBridgeActivity.EXTRA_INITIAL_PROPS, bundleOf(
        "title" to "My RN Screen",
        "message" to "Hello from native!"
    ))
}
startActivity(intent)
```

Embed React Native in an existing layout:

```kotlin
val rnView = RNBridgeView(this).apply {
    setModuleName("SharedFeature")
    setInitialProps(bundleOf("featureName" to "Todo List"))
    startReactApplication()
}
container.addView(rnView)
```

Handle navigation callbacks:

```kotlin
class MyActivity : AppCompatActivity() {
    private val navigateBackReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            finish()
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        LocalBroadcastManager.getInstance(this).registerReceiver(
            navigateBackReceiver,
            IntentFilter(BrownfieldBridgeModule.ACTION_NAVIGATE_BACK)
        )
    }
    
    override fun onDestroy() {
        super.onDestroy()
        LocalBroadcastManager.getInstance(this).unregisterReceiver(navigateBackReceiver)
    }
}
```

## React Native Components

### BrownfieldScreen

A sample screen component demonstrating brownfield integration features:
- Receives initial properties from native code
- Interactive counter UI
- Platform detection
- Native navigation callback

### SharedFeature

A reusable todo list component showcasing:
- Code sharing across multiple native apps
- Bidirectional data communication
- Complex UI interactions

## Communication Bridge

The `BrownfieldBridge` native module provides:

- `navigateBack()` - Request native navigation back
- `onDataChange(data)` - Notify native of data changes

Usage in React Native:

```javascript
import { NativeModules } from 'react-native';

// Navigate back to native
NativeModules.BrownfieldBridge.navigateBack();

// Send data to native
NativeModules.BrownfieldBridge.onDataChange({ items: [...] });
```

## Development

### Running the Metro Bundler

```bash
cd react-native-bundle
npm start
```

### Testing

```bash
cd react-native-bundle
npm test
```

## Best Practices

1. **Initialize Early**: Call `RNBridgeManager.initialize()` in your app's startup sequence.

2. **Reuse the Bridge**: Use the singleton pattern to avoid creating multiple React Native instances.

3. **Handle Lifecycle**: Properly manage React Native lifecycle in activities/view controllers.

4. **Bundle for Production**: Always use pre-bundled JavaScript for production releases.

5. **Communicate Efficiently**: Use the native bridge for essential communication only.

## License

MIT
