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
@available(iOS 15.0, *)
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
    
    /// Module name constant for the main React Native app
    public static let defaultModuleName = "MyRNFramework"
    
    /// Convenience method to create a React Native view with default module name
    public func createDefaultView(initialProps: [AnyHashable: Any]? = nil) -> UIView? {
        return view(
            moduleName: Self.defaultModuleName,
            initialProps: initialProps,
            launchOptions: nil
        )
    }
}
