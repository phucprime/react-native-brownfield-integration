//
//  BrownfieldBridgeModule.swift
//  React Native Brownfield Bridge
//
//  Native module that provides communication between React Native and native iOS code.
//  This enables React Native components to trigger native actions like navigation.
//

import Foundation
import React

/// Native module for React Native to communicate with native iOS code
@objc(BrownfieldBridge)
class BrownfieldBridgeModule: NSObject {
    
    /// Posted when React Native requests to navigate back to native
    static let navigateBackNotification = Notification.Name("RNBrownfieldNavigateBack")
    
    /// Posted when React Native data changes
    static let dataChangeNotification = Notification.Name("RNBrownfieldDataChange")
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /// Called from React Native to navigate back to the native view
    @objc
    func navigateBack() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: BrownfieldBridgeModule.navigateBackNotification,
                object: nil
            )
        }
    }
    
    /// Called from React Native when data changes
    /// - Parameter data: The updated data from React Native
    @objc
    func onDataChange(_ data: Any) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: BrownfieldBridgeModule.dataChangeNotification,
                object: nil,
                userInfo: ["data": data]
            )
        }
    }
    
    /// Sends an event to React Native
    /// - Parameters:
    ///   - eventName: The name of the event
    ///   - body: The event payload
    @objc
    func sendEvent(_ eventName: String, body: Any?) {
        // Implementation for sending events to React Native
        // This would use RCTEventEmitter in a full implementation
    }
}
