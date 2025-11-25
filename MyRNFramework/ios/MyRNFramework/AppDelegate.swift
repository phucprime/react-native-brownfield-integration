//
//  AppDelegate.swift
//  MyRNFramework
//
//  React Native brownfield integration using @callstack/react-native-brownfield.
//  This follows the official API from the library.
//
//  Reference: https://github.com/callstack/react-native-brownfield
//

import UIKit
import ReactBrownfield

/// AppDelegate for React Native brownfield integration.
/// Uses @callstack/react-native-brownfield for initialization.
///
/// Usage:
/// 1. Start React Native in didFinishLaunchingWithOptions using ReactNativeBrownfield.shared.startReactNative()
/// 2. Use ReactNativeView (SwiftUI) or ReactNativeViewController (UIKit) to display React Native content
@objc public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    /// Module name constant for the main React Native app
    @objc public static let moduleName = "MyRNFramework"
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize React Native using @callstack/react-native-brownfield
        // This handles all the setup including the React Native factory
        ReactNativeBrownfield.shared.startReactNative {
            print("[MyRNFramework] React Native bundle loaded successfully")
        }
        
        return true
    }
    
    // MARK: - UIApplicationDelegate Lifecycle Methods
    
    public func applicationWillResignActive(_ application: UIApplication) {
        // Pause React Native animations/timers if needed
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Handle background transition
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Handle foreground transition
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Resume React Native if needed
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        // Clean up React Native resources
    }
}
