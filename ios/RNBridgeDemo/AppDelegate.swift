//
//  AppDelegate.swift
//  RNBridgeDemo
//
//  Demo application showing how to integrate React Native using
//  @callstack/react-native-brownfield library.
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
        ReactNativeBrownfield.shared.startReactNative {
            print("[RNBridgeDemo] React Native bundle loaded")
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
