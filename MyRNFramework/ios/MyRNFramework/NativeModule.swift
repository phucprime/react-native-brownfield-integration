//
//  NativeModule.swift
//  MyRNFramework
//
//  Native module bridge example for React Native brownfield integration.
//  Demonstrates how to expose native iOS functionality to React Native.
//

import Foundation
import UIKit
import React

/// Native module that exposes iOS functionality to React Native.
/// This module provides examples of common native bridge patterns.
@objc(NativeModule)
class NativeModule: NSObject {
    
    /// Indicates that this module's methods should be called on the main queue.
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /// Shows a native iOS alert dialog.
    /// - Parameter message: The message to display in the alert
    @objc func showNativeAlert(_ message: String) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            
            let alert = UIAlertController(
                title: "Native Alert",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // Find the topmost presented view controller
            var topController = rootViewController
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            topController.present(alert, animated: true)
        }
    }
    
    /// Gets device information and returns it to React Native.
    /// - Parameters:
    ///   - resolve: Promise resolve callback
    ///   - reject: Promise reject callback
    @objc func getDeviceInfo(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        let device = UIDevice.current
        let deviceInfo: [String: Any] = [
            "name": device.name,
            "model": device.model,
            "systemName": device.systemName,
            "systemVersion": device.systemVersion,
            "identifierForVendor": device.identifierForVendor?.uuidString ?? "unknown"
        ]
        resolve(deviceInfo)
    }
    
    /// Triggers haptic feedback on supported devices.
    /// - Parameter style: The style of haptic feedback ("light", "medium", "heavy")
    @objc func triggerHapticFeedback(_ style: String) {
        DispatchQueue.main.async {
            let generator: UIImpactFeedbackGenerator
            
            switch style {
            case "light":
                generator = UIImpactFeedbackGenerator(style: .light)
            case "heavy":
                generator = UIImpactFeedbackGenerator(style: .heavy)
            default:
                generator = UIImpactFeedbackGenerator(style: .medium)
            }
            
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    /// Opens a URL in the default browser or appropriate app.
    /// - Parameters:
    ///   - urlString: The URL string to open
    ///   - resolve: Promise resolve callback
    ///   - reject: Promise reject callback
    @objc func openURL(
        _ urlString: String,
        resolver resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        guard let url = URL(string: urlString) else {
            reject("INVALID_URL", "The provided URL is invalid", nil)
            return
        }
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        resolve(true)
                    } else {
                        reject("OPEN_FAILED", "Failed to open URL", nil)
                    }
                }
            } else {
                reject("CANNOT_OPEN", "Cannot open this URL", nil)
            }
        }
    }
}
