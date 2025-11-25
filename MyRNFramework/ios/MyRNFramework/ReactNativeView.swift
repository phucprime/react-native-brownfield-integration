//
//  ReactNativeView.swift
//  MyRNFramework
//
//  SwiftUI and UIKit integration using @callstack/react-native-brownfield.
//  
//  The library provides:
//  - ReactNativeView: SwiftUI component for embedding React Native
//  - ReactNativeViewController: UIKit controller for embedding React Native
//
//  Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/SWIFT.md
//

import SwiftUI
import UIKit
import ReactBrownfield

// MARK: - Re-export library components for convenience

/// Re-export ReactNativeView from the brownfield library for SwiftUI usage.
/// 
/// Example:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationView {
///             VStack {
///                 Text("Welcome to Native App")
///                 NavigationLink("Open React Native") {
///                     ReactNativeView(moduleName: "MyRNFramework")
///                         .navigationBarHidden(true)
///                 }
///             }
///         }
///     }
/// }
/// ```
public typealias RNView = ReactBrownfield.ReactNativeView

/// Re-export ReactNativeViewController from the brownfield library for UIKit usage.
///
/// Example:
/// ```swift
/// let rnViewController = ReactNativeViewController(moduleName: "MyRNFramework")
/// navigationController?.pushViewController(rnViewController, animated: true)
/// ```
public typealias RNViewController = ReactBrownfield.ReactNativeViewController

// MARK: - Convenience extensions

extension ReactNativeBrownfield {
    
    /// Convenience method to create a React Native view with default module name
    public func createView(initialProps: [AnyHashable: Any]? = nil) -> UIView? {
        return view(
            moduleName: AppDelegate.moduleName,
            initialProps: initialProps,
            launchOptions: nil
        )
    }
}

// MARK: - Custom SwiftUI wrapper (alternative if library import fails)

/// Custom SwiftUI wrapper for React Native - use only if ReactBrownfield.ReactNativeView
/// is not available (e.g., when library is not properly linked).
@available(iOS 15.0, *)
public struct MyReactNativeView: View {
    @Environment(\.dismiss) var dismiss
    
    let moduleName: String
    let initialProperties: [String: Any]
    
    public init(moduleName: String = AppDelegate.moduleName, initialProperties: [String: Any] = [:]) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
    }
    
    public var body: some View {
        MyReactNativeViewRepresentable(
            moduleName: moduleName,
            initialProperties: initialProperties
        )
        .ignoresSafeArea(.all)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("PopToNativeNotification"))) { _ in
            dismiss()
        }
    }
}

/// UIViewControllerRepresentable bridge for SwiftUI
struct MyReactNativeViewRepresentable: UIViewControllerRepresentable {
    var moduleName: String
    var initialProperties: [String: Any]
    
    func makeUIViewController(context: Context) -> UIViewController {
        return MyReactNativeViewController(
            moduleName: moduleName,
            initialProperties: initialProperties
        )
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

/// Custom UIViewController for React Native - fallback implementation
public class MyReactNativeViewController: UIViewController {
    
    private let moduleName: String
    private let initialProperties: [String: Any]?
    
    public init(moduleName: String = AppDelegate.moduleName, initialProperties: [String: Any]? = nil) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create view using ReactNativeBrownfield.shared.view()
        if let reactView = ReactNativeBrownfield.shared.view(
            moduleName: moduleName,
            initialProps: initialProperties,
            launchOptions: nil
        ) {
            view = reactView
        } else {
            showErrorState()
        }
        
        // Listen for pop to native notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePopToNative),
            name: NSNotification.Name("PopToNativeNotification"),
            object: nil
        )
    }
    
    @objc private func handlePopToNative(_ notification: Notification) {
        let animated = (notification.userInfo?["animated"] as? Bool) ?? true
        
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated)
        }
    }
    
    private func showErrorState() {
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Failed to load React Native view\nEnsure ReactNativeBrownfield.shared.startReactNative() was called"
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
