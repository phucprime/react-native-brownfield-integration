//
//  AppDelegate.swift
//  MyRNFramework
//
//  Modern React Native brownfield integration using RCTReactNativeFactory
//  and ReactNativeDelegate patterns for embedding React Native as a framework.
//
//  This implementation follows the brownfield integration guidelines from:
//  - https://www.rockjs.dev/docs/brownfield/intro
//  - https://github.com/callstack/react-native-brownfield
//

import UIKit
import React
import React_RCTAppDelegate

/// AppDelegate for React Native brownfield integration.
/// Uses the modern RCTReactNativeFactory pattern for initialization.
///
/// Usage in host application:
/// 1. Initialize React Native in didFinishLaunchingWithOptions
/// 2. Use createReactNativeView() to embed React Native content
/// 3. Access reactNativeFactory for advanced customization
@objc public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    /// The React Native factory instance - use this to create React Native views
    @objc public var reactNativeFactory: RCTReactNativeFactory?
    
    /// The React Native delegate with dependency provider
    private var reactDelegate: ReactNativeDelegate?
    
    /// Module name constant for the main React Native app
    @objc public static let moduleName = "MyRNFramework"
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Initialize the React Native delegate with dependency provider
        let delegate = ReactNativeDelegate()
        delegate.dependencyProvider = RCTAppDependencyProvider()
        reactDelegate = delegate
        
        // Create the React Native factory
        reactNativeFactory = RCTReactNativeFactory(delegate: delegate)
        
        // Register any additional native modules here if needed
        // This is handled automatically by the bridging headers
        
        return true
    }
    
    /// Creates a React Native root view for the specified module.
    /// This is the primary method for embedding React Native content in native views.
    ///
    /// - Parameters:
    ///   - moduleName: The registered React Native component name (defaults to "MyRNFramework")
    ///   - initialProperties: Optional properties to pass to the component
    /// - Returns: A UIView containing the React Native content, or nil if factory not initialized
    ///
    /// Example usage:
    /// ```swift
    /// if let rnView = appDelegate.createReactNativeView(
    ///     moduleName: "MyRNFramework",
    ///     initialProperties: ["greeting": "Hello from Native!"]
    /// ) {
    ///     containerView.addSubview(rnView)
    /// }
    /// ```
    @objc public func createReactNativeView(
        moduleName: String = "MyRNFramework",
        initialProperties: [AnyHashable: Any]? = nil
    ) -> UIView? {
        guard let factory = reactNativeFactory else {
            print("[MyRNFramework] Error: React Native factory not initialized. Call application:didFinishLaunchingWithOptions: first.")
            return nil
        }
        
        return factory.rootViewFactory.view(
            withModuleName: moduleName,
            initialProperties: initialProperties
        )
    }
    
    /// Returns the bundle URL for the JavaScript bundle.
    /// Use this when you need direct access to the bundle location.
    @objc public func bundleURL() -> URL? {
        return reactDelegate?.bundleURL()
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

/// ReactNativeDelegate implementation for brownfield integration.
/// Configures the React Native runtime with the appropriate bundle URL and dependency provider.
///
/// The delegate provides:
/// - Development server URL for debug builds (Metro bundler)
/// - Pre-bundled JavaScript for release/production builds
class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    
    /// The dependency provider for React Native
    var dependencyProvider: RCTAppDependencyProvider?
    
    /// Returns the URL for the JavaScript bundle.
    /// - Debug: Loads from Metro development server
    /// - Release: Loads pre-bundled main.jsbundle from app bundle
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        return bundleURL()
    }
    
    /// Returns the bundle URL based on build configuration.
    /// For framework distribution, override this to customize bundle loading.
    override func bundleURL() -> URL? {
        #if DEBUG
        // Development: Load from Metro bundler
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        // Production: Load pre-bundled JavaScript
        // The bundle should be created using: npm run bundle:ios
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
    
    /// Override to provide custom native module packages
    /// Add any additional native modules that should be available to React Native
    func extraModulesForBridge(_ bridge: RCTBridge!) -> [RCTBridgeModule]? {
        return nil
    }
}
