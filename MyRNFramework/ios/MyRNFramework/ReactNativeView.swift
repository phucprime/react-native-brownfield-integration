//
//  ReactNativeView.swift
//  MyRNFramework
//
//  SwiftUI integration using UIViewRepresentable.
//  Allows embedding React Native views in SwiftUI applications.
//

import SwiftUI
import UIKit
import React

/// A SwiftUI view that wraps a React Native component.
/// Use this to embed React Native content in SwiftUI applications.
///
/// Example usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ReactNativeView(moduleName: "MyRNFramework")
///             .frame(maxWidth: .infinity, maxHeight: .infinity)
///     }
/// }
/// ```
struct ReactNativeView: UIViewRepresentable {
    
    /// The name of the React Native module to display
    let moduleName: String
    
    /// Optional initial properties to pass to the React Native component
    var initialProperties: [AnyHashable: Any]?
    
    /// The React Native factory from the app delegate
    private var reactNativeFactory: RCTReactNativeFactory? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.reactNativeFactory
    }
    
    init(moduleName: String, initialProperties: [AnyHashable: Any]? = nil) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
    }
    
    func makeUIView(context: Context) -> UIView {
        guard let factory = reactNativeFactory else {
            // Return a placeholder view if factory is not available
            let placeholder = UIView()
            placeholder.backgroundColor = .systemBackground
            
            let label = UILabel()
            label.text = "React Native not initialized"
            label.textColor = .systemRed
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            placeholder.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: placeholder.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: placeholder.centerYAnchor)
            ])
            
            return placeholder
        }
        
        // Create the React Native root view using the modern factory pattern
        let rootView = factory.rootViewFactory.view(
            withModuleName: moduleName,
            initialProperties: initialProperties
        )
        
        return rootView ?? UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
        // React Native handles most updates internally
    }
}

/// A UIKit view controller that hosts a React Native view for use in UIKit apps.
/// This provides an alternative to SwiftUI integration.
///
/// Example usage:
/// ```swift
/// let rnViewController = ReactNativeViewController(moduleName: "MyRNFramework")
/// navigationController?.pushViewController(rnViewController, animated: true)
/// ```
class ReactNativeViewController: UIViewController {
    
    /// The name of the React Native module to display
    let moduleName: String
    
    /// Optional initial properties to pass to the React Native component
    var initialProperties: [AnyHashable: Any]?
    
    /// The React Native root view
    private var reactView: UIView?
    
    init(moduleName: String, initialProperties: [AnyHashable: Any]? = nil) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupReactNativeView()
    }
    
    private func setupReactNativeView() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let factory = appDelegate.reactNativeFactory else {
            showErrorState()
            return
        }
        
        let rootView = factory.rootViewFactory.view(
            withModuleName: moduleName,
            initialProperties: initialProperties
        )
        
        guard let view = rootView else {
            showErrorState()
            return
        }
        
        reactView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func showErrorState() {
        let label = UILabel()
        label.text = "Failed to load React Native view"
        label.textColor = .systemRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
