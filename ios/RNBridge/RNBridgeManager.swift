//
//  RNBridgeManager.swift
//  React Native Brownfield Bridge
//
//  This class manages the React Native bridge for embedding React Native views
//  into existing native iOS applications.
//

import Foundation
import React

/// RNBridgeManager is a singleton class that manages the React Native bridge
/// for brownfield integration in iOS applications.
public class RNBridgeManager: NSObject {
    
    /// Shared singleton instance
    public static let shared = RNBridgeManager()
    
    /// The React Native bridge instance
    private var bridge: RCTBridge?
    
    /// Indicates whether the bridge is ready
    public private(set) var isBridgeReady = false
    
    /// Delegate for receiving bridge events
    public weak var delegate: RNBridgeDelegate?
    
    /// Bundle URL configuration
    public enum BundleSource {
        case metro(host: String, port: UInt16)  // Development server
        case localBundle(filename: String)       // Pre-bundled JS
    }
    
    private override init() {
        super.init()
    }
    
    /// Initializes the React Native bridge with the specified configuration.
    /// - Parameters:
    ///   - source: The source of the JavaScript bundle
    ///   - launchOptions: Optional launch options from the app delegate
    public func initialize(source: BundleSource, launchOptions: [AnyHashable: Any]? = nil) {
        guard bridge == nil else {
            print("[RNBridge] Bridge already initialized")
            return
        }
        
        let bundleURL: URL?
        
        switch source {
        case .metro(let host, let port):
            bundleURL = URL(string: "http://\(host):\(port)/index.bundle?platform=ios")
        case .localBundle(let filename):
            bundleURL = Bundle.main.url(forResource: filename, withExtension: "jsbundle")
        }
        
        guard let url = bundleURL else {
            print("[RNBridge] Failed to create bundle URL")
            return
        }
        
        bridge = RCTBridge(
            bundleURL: url,
            moduleProvider: nil,
            launchOptions: launchOptions
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bridgeDidLoad),
            name: NSNotification.Name.RCTJavaScriptDidLoad,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bridgeDidFailToLoad),
            name: NSNotification.Name.RCTJavaScriptDidFailToLoad,
            object: nil
        )
    }
    
    /// Creates a React Native root view for the specified component.
    /// - Parameters:
    ///   - moduleName: The name of the registered React Native component
    ///   - initialProperties: Optional initial properties to pass to the component
    /// - Returns: A configured RCTRootView ready to be added to the view hierarchy
    public func createRootView(
        moduleName: String,
        initialProperties: [AnyHashable: Any]? = nil
    ) -> RCTRootView? {
        guard let bridge = bridge else {
            print("[RNBridge] Bridge not initialized. Call initialize() first.")
            return nil
        }
        
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: initialProperties
        )
        
        rootView.backgroundColor = .systemBackground
        
        return rootView
    }
    
    /// Invalidates and cleans up the React Native bridge.
    /// Call this when the app is terminating or when React Native is no longer needed.
    public func invalidate() {
        bridge?.invalidate()
        bridge = nil
        isBridgeReady = false
    }
    
    // MARK: - Private Methods
    
    @objc private func bridgeDidLoad(_ notification: Notification) {
        isBridgeReady = true
        delegate?.bridgeDidLoad()
        print("[RNBridge] Bridge loaded successfully")
    }
    
    @objc private func bridgeDidFailToLoad(_ notification: Notification) {
        isBridgeReady = false
        if let error = notification.userInfo?["error"] as? NSError {
            delegate?.bridgeDidFailToLoad(error: error)
            print("[RNBridge] Bridge failed to load: \(error.localizedDescription)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - RNBridgeDelegate Protocol

/// Protocol for receiving React Native bridge events
public protocol RNBridgeDelegate: AnyObject {
    func bridgeDidLoad()
    func bridgeDidFailToLoad(error: NSError)
}

// MARK: - Default Protocol Implementation

public extension RNBridgeDelegate {
    func bridgeDidLoad() {}
    func bridgeDidFailToLoad(error: NSError) {}
}
