//
//  AppDelegate.swift
//  NativeiOSApp
//
//  Native iOS Application demonstrating React Native Brownfield Integration.
//  This is a PURE native iOS app that consumes the pre-built MyRNFramework.xcframework.
//
//  Prerequisites:
//  1. Build the framework: cd MyRNFramework && npm run package:ios
//  2. Copy MyRNFramework.xcframework to examples/ios-native-app/build/
//  3. Copy main.jsbundle to RNBridgeDemo/Resources/
//  4. Run: pod install
//
//  Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/SWIFT.md
//

import UIKit
import ReactBrownfield

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize React Native using @callstack/react-native-brownfield
        // The XCFramework contains the bundled JS, so no metro server needed
        ReactNativeBrownfield.shared.startReactNative {
            print("[NativeiOSApp] React Native framework loaded successfully from XCFramework")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
}
