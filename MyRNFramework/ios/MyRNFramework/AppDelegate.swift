//
//  AppDelegate.swift
//  MyRNFramework
//
//  Modern React Native brownfield integration using RCTReactNativeFactory
//  and ReactNativeDelegate patterns.
//

import UIKit
import React
import React_RCTAppDelegate

/// AppDelegate for React Native brownfield integration.
/// Uses the modern RCTReactNativeFactory pattern for initialization.
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /// The React Native factory instance
    var reactNativeFactory: RCTReactNativeFactory?
    
    /// The React Native delegate with dependency provider
    private var reactDelegate: ReactNativeDelegate?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize the React Native delegate with dependency provider
        let delegate = ReactNativeDelegate()
        delegate.dependencyProvider = RCTAppDependencyProvider()
        reactDelegate = delegate
        
        // Create the React Native factory
        reactNativeFactory = RCTReactNativeFactory(delegate: delegate)
        
        return true
    }
    
    /// Creates a React Native root view for the specified module.
    /// - Parameters:
    ///   - moduleName: The registered React Native component name
    ///   - initialProperties: Optional properties to pass to the component
    /// - Returns: A UIView containing the React Native content
    func createReactNativeView(
        moduleName: String,
        initialProperties: [AnyHashable: Any]? = nil
    ) -> UIView? {
        guard let factory = reactNativeFactory else {
            print("[MyRNFramework] React Native factory not initialized")
            return nil
        }
        
        return factory.rootViewFactory.view(
            withModuleName: moduleName,
            initialProperties: initialProperties
        )
    }
}

/// ReactNativeDelegate implementation for brownfield integration.
/// Configures the React Native runtime with the appropriate dependency provider.
class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    
    /// The dependency provider for React Native
    var dependencyProvider: RCTAppDependencyProvider?
    
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        #if DEBUG
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
    
    override func bundleURL() -> URL? {
        return sourceURL(for: RCTBridge())
    }
}
