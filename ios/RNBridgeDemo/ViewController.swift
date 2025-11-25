//
//  ViewController.swift
//  RNBridgeDemo
//
//  Main view controller demonstrating how to embed React Native views
//  within a native iOS application.
//

import UIKit
import React

class ViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "React Native Brownfield Demo"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This is a native iOS app.\nTap the button below to open a React Native view."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var openRNButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open React Native Screen", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openReactNativeScreen), for: .touchUpInside)
        return button
    }()
    
    private lazy var embedRNButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Embed React Native View", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(embedReactNativeView), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var embeddedRNView: UIView?
    private var rnContainerView: UIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupNotifications()
        updateStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatus()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(openRNButton)
        view.addSubview(embedRNButton)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            openRNButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            openRNButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            openRNButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            openRNButton.heightAnchor.constraint(equalToConstant: 50),
            
            embedRNButton.topAnchor.constraint(equalTo: openRNButton.bottomAnchor, constant: 16),
            embedRNButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            embedRNButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            embedRNButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupNotifications() {
        // Listen for React Native navigation events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNavigateBack),
            name: BrownfieldBridgeModule.navigateBackNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChange(_:)),
            name: BrownfieldBridgeModule.dataChangeNotification,
            object: nil
        )
    }
    
    private func updateStatus() {
        let status = RNBridgeManager.shared.isBridgeReady ? "Bridge Ready ✅" : "Bridge Loading..."
        statusLabel.text = status
    }
    
    // MARK: - Actions
    
    @objc private func openReactNativeScreen() {
        let rnViewController = RNBridgeViewController(
            moduleName: "BrownfieldScreen",
            initialProperties: [
                "title": "React Native Screen",
                "source": "Native iOS"
            ]
        )
        rnViewController.modalPresentationStyle = .fullScreen
        present(rnViewController, animated: true)
    }
    
    @objc private func embedReactNativeView() {
        if embeddedRNView != nil {
            // Remove existing embedded view
            removeEmbeddedRNView()
            embedRNButton.setTitle("Embed React Native View", for: .normal)
            embedRNButton.backgroundColor = .systemGreen
        } else {
            // Add embedded React Native view
            addEmbeddedRNView()
            embedRNButton.setTitle("Remove Embedded View", for: .normal)
            embedRNButton.backgroundColor = .systemRed
        }
    }
    
    private func addEmbeddedRNView() {
        guard let rootView = RNBridgeManager.shared.createRootView(
            moduleName: "BrownfieldScreen",
            initialProperties: [
                "title": "Embedded RN View",
                "source": "Embedded in Native",
                "compact": true
            ]
        ) else {
            showAlert(title: "Error", message: "Failed to create React Native view")
            return
        }
        
        // Create container view
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemBlue.cgColor
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        rootView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rootView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: embedRNButton.bottomAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -20),
            
            rootView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        embeddedRNView = rootView
        rnContainerView = containerView
    }
    
    private func removeEmbeddedRNView() {
        rnContainerView?.removeFromSuperview()
        embeddedRNView = nil
        rnContainerView = nil
    }
    
    // MARK: - Notification Handlers
    
    @objc private func handleNavigateBack() {
        // Dismiss any presented React Native view controller
        if presentedViewController is RNBridgeViewController {
            dismiss(animated: true)
        }
    }
    
    @objc private func handleDataChange(_ notification: Notification) {
        if let data = notification.userInfo?["data"] {
            print("Received data from React Native: \(data)")
        }
    }
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
