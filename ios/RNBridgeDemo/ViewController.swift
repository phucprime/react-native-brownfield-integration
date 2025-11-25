//
//  ViewController.swift
//  RNBridgeDemo
//
//  Main view controller demonstrating how to embed React Native views
//  within a native iOS application using @callstack/react-native-brownfield.
//
//  Reference: https://github.com/callstack/react-native-brownfield/blob/main/docs/SWIFT.md
//

import UIKit
import ReactBrownfield

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    private let moduleName = "BrownfieldScreen"
    
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
        button.setTitle("Push React Native Screen", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openReactNativeScreen), for: .touchUpInside)
        return button
    }()
    
    private lazy var presentRNButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Present React Native Modal", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentReactNativeModal), for: .touchUpInside)
        return button
    }()
    
    private lazy var embedRNButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Embed React Native View", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(embedReactNativeView), for: .touchUpInside)
        return button
    }()
    
    private var embeddedRNView: UIView?
    private var rnContainerView: UIView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Native App"
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(openRNButton)
        view.addSubview(presentRNButton)
        view.addSubview(embedRNButton)
        
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
            
            presentRNButton.topAnchor.constraint(equalTo: openRNButton.bottomAnchor, constant: 16),
            presentRNButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            presentRNButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            presentRNButton.heightAnchor.constraint(equalToConstant: 50),
            
            embedRNButton.topAnchor.constraint(equalTo: presentRNButton.bottomAnchor, constant: 16),
            embedRNButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            embedRNButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            embedRNButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    
    /// Opens React Native using ReactNativeViewController (push navigation)
    @objc private func openReactNativeScreen() {
        // Use the library's ReactNativeViewController
        let rnViewController = ReactNativeViewController(
            moduleName: moduleName,
            initialProperties: [
                "title": "Pushed RN Screen",
                "source": "Native iOS (Push)"
            ]
        )
        navigationController?.pushViewController(rnViewController, animated: true)
    }
    
    /// Opens React Native using ReactNativeViewController (modal presentation)
    @objc private func presentReactNativeModal() {
        let rnViewController = ReactNativeViewController(
            moduleName: moduleName,
            initialProperties: [
                "title": "Modal RN Screen",
                "source": "Native iOS (Modal)"
            ]
        )
        rnViewController.modalPresentationStyle = .fullScreen
        present(rnViewController, animated: true)
    }
    
    /// Embeds React Native view directly using ReactNativeBrownfield.shared.view()
    @objc private func embedReactNativeView() {
        if embeddedRNView != nil {
            // Remove existing embedded view
            removeEmbeddedRNView()
            embedRNButton.setTitle("Embed React Native View", for: .normal)
            embedRNButton.backgroundColor = .systemOrange
        } else {
            // Add embedded React Native view
            addEmbeddedRNView()
            embedRNButton.setTitle("Remove Embedded View", for: .normal)
            embedRNButton.backgroundColor = .systemRed
        }
    }
    
    private func addEmbeddedRNView() {
        // Use ReactNativeBrownfield.shared.view() to create the view
        guard let rootView = ReactNativeBrownfield.shared.view(
            moduleName: moduleName,
            initialProps: [
                "title": "Embedded RN View",
                "source": "Native iOS (Embedded)",
                "compact": true
            ],
            launchOptions: nil
        ) else {
            showAlert(title: "Error", message: "Failed to create React Native view.\nEnsure ReactNativeBrownfield.shared.startReactNative() was called.")
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
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
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
    
    // MARK: - Helpers
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
