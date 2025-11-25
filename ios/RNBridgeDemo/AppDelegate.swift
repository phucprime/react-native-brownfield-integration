//
//  AppDelegate.swift
//  RNBridgeDemo
//
//  Demo application showing how to integrate React Native using the RNBridge library.
//

import UIKit
import React

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize the React Native bridge
        #if DEBUG
        RNBridgeManager.shared.initialize(
            source: .metro(host: "localhost", port: 8081),
            launchOptions: launchOptions
        )
        #else
        RNBridgeManager.shared.initialize(
            source: .localBundle(filename: "main"),
            launchOptions: launchOptions
        )
        #endif
        
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
    
    // MARK: - React Native URL Handling
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return RCTLinkingManager.application(app, open: url, options: options)
    }
}
