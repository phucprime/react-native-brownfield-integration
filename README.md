# React Native Brownfield Integration

Embed React Native into existing native iOS and Android applications. This repository provides a complete solution for brownfield integration, allowing you to incrementally add React Native features to your existing native apps.

## Overview

Brownfield integration allows you to embed React Native into existing native applications. This is ideal when:

- You have an existing native app and want to add React Native features incrementally
- You want to reuse React Native code across multiple native apps
- You need specific screens or features built with React Native within a native shell
- You want to maintain native navigation while using React Native for content
- You need to package React Native as a framework (XCFramework/AAR) for distribution

## Key Features

| Feature | Description |
|---------|-------------|
| **Framework Packaging** | Package React Native as XCFramework (iOS) or AAR (Android) for easy distribution |
| **Reusable Components** | Share React Native components across multiple native applications |
| **Native Navigation** | Integrate with native navigation systems (UIKit, SwiftUI, Jetpack Compose) |
| **Hot Reloading** | Fast development with Metro bundler hot reloading support |
| **New Architecture** | Support for React Native's New Architecture with TurboModules |
| **Native Modules** | Bridge native functionality to React Native components |

## Recommended Tools

- **[Rock](https://github.com/nicklockwood/SwiftFormat)** - CLI tool for packaging React Native as native frameworks
- **[@callstack/react-native-brownfield](https://github.com/nicklockwood/SwiftFormat)** - Simplifies brownfield integration
- **[CocoaPods](https://cocoapods.org/)** - iOS dependency management
- **[Gradle](https://gradle.org/)** - Android build automation

## Project Structure

```
MyRNFramework/
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/java/com/myrnframework/
│   │       ├── MainActivity.kt
│   │       ├── MainApplication.kt
│   │       ├── NativeModule.kt
│   │       └── NativeModulePackage.kt
│   ├── build.gradle
│   └── settings.gradle
├── ios/
│   ├── MyRNFramework/
│   │   ├── AppDelegate.swift
│   │   ├── ReactNativeView.swift
│   │   ├── NativeModule.swift
│   │   └── NativeModule.m
│   └── Podfile
├── src/
│   ├── App.tsx
│   └── index.ts
├── package.json
├── metro.config.js
├── app.json
├── tsconfig.json
└── index.ts
```

## Initial Setup

### 1. Install Dependencies

```bash
cd MyRNFramework
npm install
```

### 2. iOS Setup

```bash
cd ios
pod install
```

### 3. Android Setup

```bash
cd android
./gradlew build
```

## Configuration Files

### app.json

```json
{
  "name": "MyRNFramework",
  "displayName": "MyRNFramework"
}
```

### metro.config.js

```javascript
const {getDefaultConfig} = require('@react-native/metro-config');

module.exports = (async () => {
  const defaultConfig = await getDefaultConfig(__dirname);
  return {
    ...defaultConfig,
    resolver: {
      ...defaultConfig.resolver,
      sourceExts: [...defaultConfig.resolver.sourceExts, 'tsx', 'ts'],
    },
  };
})();
```

### package.json Scripts

```json
{
  "scripts": {
    "start": "react-native start",
    "package:ios": "rock package:ios",
    "package:android": "rock package:aar"
  }
}
```

## iOS Integration

### 1. Package as XCFramework

```bash
npm run package:ios
```

This creates an XCFramework that can be distributed and integrated into any iOS project.

### 2. Add to Xcode Project

1. Drag the XCFramework into your Xcode project
2. Ensure it's added to "Embed & Sign" in your target's frameworks

### 3. Initialize React Native

Update your AppDelegate using the modern `RCTReactNativeFactory` pattern:

```swift
import UIKit
import React
import React_RCTAppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {
    var reactNativeFactory: RCTReactNativeFactory?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let delegate = ReactNativeDelegate()
        delegate.dependencyProvider = RCTAppDependencyProvider()
        reactNativeFactory = RCTReactNativeFactory(delegate: delegate)
        
        return true
    }
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    var dependencyProvider: RCTAppDependencyProvider?
    
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        #if DEBUG
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
```

### 4. SwiftUI Integration

Use `UIViewRepresentable` to embed React Native views in SwiftUI:

```swift
import SwiftUI
import React

struct ReactNativeView: UIViewRepresentable {
    let moduleName: String
    var initialProperties: [AnyHashable: Any]?
    
    func makeUIView(context: Context) -> UIView {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let factory = appDelegate.reactNativeFactory else {
            return UIView()
        }
        
        return factory.rootViewFactory.view(
            withModuleName: moduleName,
            initialProperties: initialProperties
        ) ?? UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// Usage in SwiftUI
struct ContentView: View {
    var body: some View {
        ReactNativeView(
            moduleName: "MyRNFramework",
            initialProperties: ["greeting": "Hello from SwiftUI!"]
        )
    }
}
```

### 5. UIKit Integration

Present React Native views in UIKit:

```swift
let rootView = appDelegate.reactNativeFactory?.rootViewFactory.view(
    withModuleName: "MyRNFramework",
    initialProperties: nil
)

let viewController = UIViewController()
viewController.view = rootView
navigationController?.pushViewController(viewController, animated: true)
```

## Android Integration

### 1. Package as AAR

```bash
npm run package:android
```

This creates an AAR file that can be distributed and integrated into any Android project.

### 2. Add to Gradle Project

Add the AAR to your project's dependencies:

```groovy
dependencies {
    implementation files('libs/myrnframework.aar')
    implementation "com.facebook.react:react-android"
    implementation "com.facebook.react:hermes-android"
    implementation "com.callstack.reactnativeshared:react-native-brownfield-shared:latest.release"
}
```

### 3. Initialize React Native

Use `ReactNativeBrownfieldShared` for initialization:

```kotlin
import android.app.Application
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        
        ReactNativeBrownfieldShared.startReactNative(
            application = this,
            bundleName = "index.android.bundle"
        )
    }
}
```

### 4. Jetpack Compose Integration

Use `AndroidView` to embed React Native in Compose:

```kotlin
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import com.callstack.reactnativeshared.ReactNativeBrownfieldShared
import com.facebook.react.ReactRootView

@Composable
fun ReactNativeScreen(
    moduleName: String,
    initialProperties: Map<String, Any>? = null
) {
    AndroidView(
        factory = { context ->
            ReactRootView(context).apply {
                val bundle = initialProperties?.let { props ->
                    android.os.Bundle().apply {
                        props.forEach { (key, value) ->
                            when (value) {
                                is String -> putString(key, value)
                                is Int -> putInt(key, value)
                                is Boolean -> putBoolean(key, value)
                            }
                        }
                    }
                }
                
                startReactApplication(
                    ReactNativeBrownfieldShared.getReactInstanceManager(),
                    moduleName,
                    bundle
                )
            }
        },
        modifier = Modifier.fillMaxSize()
    )
}

// Usage
@Composable
fun MainScreen() {
    ReactNativeScreen(
        moduleName = "MyRNFramework",
        initialProperties = mapOf("greeting" to "Hello from Compose!")
    )
}
```

### 5. Activity-based Integration

For traditional Activity-based integration:

```kotlin
class ReactNativeActivity : AppCompatActivity() {
    private var reactRootView: ReactRootView? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        reactRootView = ReactRootView(this).apply {
            startReactApplication(
                ReactNativeBrownfieldShared.getReactInstanceManager(),
                "MyRNFramework",
                null
            )
        }
        
        setContentView(reactRootView)
    }
    
    override fun onDestroy() {
        super.onDestroy()
        reactRootView?.unmountReactApplication()
    }
}
```

## Sample React Native Code

### src/App.tsx

```typescript
import React, {useState, useCallback} from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  SafeAreaView,
  TextInput,
  ScrollView,
} from 'react-native';

const App: React.FC = () => {
  const [count, setCount] = useState<number>(0);
  const [name, setName] = useState<string>('');
  const [greeting, setGreeting] = useState<string>('');

  const handleIncrement = useCallback(() => setCount(prev => prev + 1), []);
  const handleDecrement = useCallback(() => setCount(prev => prev - 1), []);
  const handleReset = useCallback(() => setCount(0), []);
  
  const handleGreet = useCallback(() => {
    if (name.trim()) {
      setGreeting(`Hello, ${name.trim()}!`);
    }
  }, [name]);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.content}>
        {/* Counter Demo */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Counter Demo</Text>
          <Text style={styles.counterValue}>{count}</Text>
          <View style={styles.buttonRow}>
            <TouchableOpacity style={styles.button} onPress={handleDecrement}>
              <Text style={styles.buttonText}>−</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.button} onPress={handleReset}>
              <Text style={styles.buttonText}>Reset</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.button} onPress={handleIncrement}>
              <Text style={styles.buttonText}>+</Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* Input Demo */}
        <View style={styles.card}>
          <Text style={styles.cardTitle}>Input Demo</Text>
          <TextInput
            style={styles.input}
            placeholder="Enter your name..."
            value={name}
            onChangeText={setName}
          />
          <TouchableOpacity style={styles.button} onPress={handleGreet}>
            <Text style={styles.buttonText}>Say Hello</Text>
          </TouchableOpacity>
          {greeting && <Text style={styles.greeting}>{greeting}</Text>}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#F5F5F5' },
  content: { padding: 16 },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    padding: 20,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  cardTitle: { fontSize: 20, fontWeight: '600', marginBottom: 16 },
  counterValue: { fontSize: 48, fontWeight: 'bold', textAlign: 'center' },
  buttonRow: { flexDirection: 'row', justifyContent: 'center', gap: 12 },
  button: {
    backgroundColor: '#007AFF',
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
  },
  buttonText: { color: '#FFFFFF', fontSize: 18, fontWeight: '600' },
  input: {
    borderWidth: 1,
    borderColor: '#DDD',
    borderRadius: 8,
    padding: 12,
    marginBottom: 12,
  },
  greeting: { marginTop: 16, fontSize: 16, color: '#34C759' },
});

export default App;
```

## Native Module Bridge Examples

### iOS Native Module (Swift)

```swift
// NativeModule.swift
@objc(NativeModule)
class NativeModule: NSObject {
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func showNativeAlert(_ message: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            
            let alert = UIAlertController(
                title: "Native Alert",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            rootViewController.present(alert, animated: true)
        }
    }
    
    @objc func getDeviceInfo(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        let device = UIDevice.current
        resolve([
            "name": device.name,
            "model": device.model,
            "systemVersion": device.systemVersion
        ])
    }
}
```

```objc
// NativeModule.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeModule, NSObject)
RCT_EXTERN_METHOD(showNativeAlert:(NSString *)message)
RCT_EXTERN_METHOD(getDeviceInfo:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
```

### Android Native Module (Kotlin)

```kotlin
// NativeModule.kt
class NativeModule(
    private val reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "NativeModule"

    @ReactMethod
    fun showNativeAlert(message: String) {
        reactContext.currentActivity?.runOnUiThread {
            Toast.makeText(reactContext, message, Toast.LENGTH_LONG).show()
        }
    }

    @ReactMethod
    fun getDeviceInfo(promise: Promise) {
        val deviceInfo = Arguments.createMap().apply {
            putString("manufacturer", Build.MANUFACTURER)
            putString("model", Build.MODEL)
            putInt("sdkVersion", Build.VERSION.SDK_INT)
        }
        promise.resolve(deviceInfo)
    }
}

// NativeModulePackage.kt
class NativeModulePackage : ReactPackage {
    override fun createNativeModules(
        reactContext: ReactApplicationContext
    ): List<NativeModule> = listOf(NativeModule(reactContext))
    
    override fun createViewManagers(
        reactContext: ReactApplicationContext
    ): List<ViewManager<*, *>> = emptyList()
}
```

### Using Native Modules in React Native

```typescript
import { NativeModules } from 'react-native';

const { NativeModule } = NativeModules;

// Show native alert
NativeModule.showNativeAlert('Hello from React Native!');

// Get device info (async)
const deviceInfo = await NativeModule.getDeviceInfo();
console.log(deviceInfo);
```

## Development & Testing

### Start Metro Bundler

```bash
cd MyRNFramework
npm start
```

### Run Tests

```bash
npm test
```

### Build for Production

iOS:
```bash
npm run bundle:ios
```

Android:
```bash
npm run bundle:android
```

## Legacy Integration

For projects using the legacy integration pattern, see the following directories:

- `react-native-bundle/` - Legacy JavaScript bundle
- `ios/RNBridge/` - Legacy iOS bridge components
- `android/app/` - Legacy Android bridge components

## Best Practices

1. **Initialize Early**: Initialize React Native in your app's startup sequence
2. **Reuse Instances**: Use singleton patterns to avoid creating multiple React Native instances
3. **Handle Lifecycle**: Properly manage React Native lifecycle in activities/view controllers
4. **Bundle for Production**: Always use pre-bundled JavaScript for production releases
5. **Use TypeScript**: Leverage TypeScript for type safety in your React Native code
6. **Test Native Modules**: Write unit tests for native module functionality

## License

MIT
