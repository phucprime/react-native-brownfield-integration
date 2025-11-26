//
//  SceneDelegate.swift
//  MyRNFramework
//
//  Scene delegate for managing the app's UI lifecycle.
//

import ReactBrownfield
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // Create the SwiftUI content view with React Native embedded
        let contentView = ContentView()

        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

/// Main SwiftUI ContentView that embeds the React Native view
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // React Native view embedded in SwiftUI
                ReactNativeView(
                    moduleName: "MyRNFramework",
                    initialProperties: ["greeting": "Hello from SwiftUI!"]
                )
            }
            .navigationTitle("MyRNFramework")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
