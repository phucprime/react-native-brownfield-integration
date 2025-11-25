//
//  RNBridgeViewController.swift
//  React Native Brownfield Bridge
//
//  A UIViewController subclass that hosts a React Native view.
//  Use this as a base class or embed it in your navigation flow.
//

import UIKit
import React

/// A view controller that hosts a React Native view.
/// This can be pushed onto a UINavigationController or presented modally.
open class RNBridgeViewController: UIViewController {
    
    /// The name of the React Native component to display
    public let moduleName: String
    
    /// Initial properties passed to the React Native component
    public var initialProperties: [AnyHashable: Any]?
    
    /// The React Native root view
    private var rootView: RCTRootView?
    
    /// Loading indicator shown while the bridge loads
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    /// Initializes the view controller with the specified React Native module.
    /// - Parameters:
    ///   - moduleName: The registered name of the React Native component
    ///   - initialProperties: Optional properties to pass to the component
    public init(moduleName: String, initialProperties: [AnyHashable: Any]? = nil) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLoadingView()
        loadReactNativeView()
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingView.startAnimating()
    }
    
    private func loadReactNativeView() {
        rootView = RNBridgeManager.shared.createRootView(
            moduleName: moduleName,
            initialProperties: initialProperties
        )
        
        guard let rootView = rootView else {
            showErrorState()
            return
        }
        
        rootView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootView)
        
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        loadingView.stopAnimating()
    }
    
    private func showErrorState() {
        loadingView.stopAnimating()
        
        let errorLabel = UILabel()
        errorLabel.text = "Failed to load React Native view"
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent || isBeingDismissed {
            // Clean up when the view controller is being removed
            cleanupView()
        }
    }
    
    private func cleanupView() {
        rootView?.removeFromSuperview()
        rootView = nil
    }
}
