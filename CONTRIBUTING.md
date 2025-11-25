# Contributing to React Native Brownfield Integration

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and constructive in all interactions.

## How to Contribute

### Reporting Bugs

1. Check if the issue already exists in [GitHub Issues](https://github.com/phucprime/react-native-brownfield-integration/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, React Native version, etc.)

### Suggesting Features

1. Open an issue with the `enhancement` label
2. Describe the feature and its use case
3. Explain why it would benefit the project

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages: `git commit -m "feat: add new feature"`
6. Push to your fork: `git push origin feature/my-feature`
7. Open a Pull Request

## Development Setup

### Prerequisites

- Node.js >= 18
- Xcode (for iOS development)
- Android Studio (for Android development)
- CocoaPods

### Getting Started

```bash
# Clone the repository
git clone https://github.com/phucprime/react-native-brownfield-integration.git
cd react-native-brownfield-integration

# Install dependencies
cd MyRNFramework
npm install

# iOS setup
cd ios && pod install && cd ..

# Run iOS
npx react-native run-ios

# Run Android
npx react-native run-android
```

## Project Structure

```
├── MyRNFramework/     # React Native framework source
├── ios/               # iOS native host app demo
├── android/           # Android native host app demo
└── README.md
```

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

## Code Style

- TypeScript/JavaScript: Use ESLint configuration
- Swift: Follow Swift API Design Guidelines
- Kotlin: Follow Kotlin Coding Conventions

## Testing

Before submitting a PR:

1. Test on both iOS and Android
2. Verify the demo apps run correctly
3. Check for TypeScript errors: `npm run typecheck`
4. Run linting: `npm run lint`

## Questions?

Feel free to open an issue for any questions about contributing.
