#!/bin/bash

# Shop Management System - Setup Script
# This script helps set up the Flutter project with all dependencies

echo "🚀 Setting up Shop Management System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
        exit 1
    fi

    FLUTTER_VERSION=$(flutter --version | head -n 1)
    print_success "Flutter found: $FLUTTER_VERSION"
}

# Check Firebase CLI
check_firebase() {
    print_status "Checking Firebase CLI..."
    if ! command -v firebase &> /dev/null; then
        print_warning "Firebase CLI not found. Installing..."
        npm install -g firebase-tools
        if [ $? -eq 0 ]; then
            print_success "Firebase CLI installed successfully"
        else
            print_error "Failed to install Firebase CLI. Please install manually."
            exit 1
        fi
    else
        FIREBASE_VERSION=$(firebase --version)
        print_success "Firebase CLI found: $FIREBASE_VERSION"
    fi
}

# Install Flutter dependencies
install_dependencies() {
    print_status "Installing Flutter dependencies..."
    flutter pub get
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

# Generate code
generate_code() {
    print_status "Generating code (if needed)..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    if [ $? -eq 0 ]; then
        print_success "Code generation completed"
    else
        print_warning "Code generation had issues (might be normal if no generators needed)"
    fi
}

# Generate localizations
generate_localizations() {
    print_status "Generating localizations..."
    flutter gen-l10n
    if [ $? -eq 0 ]; then
        print_success "Localizations generated successfully"
    else
        print_error "Failed to generate localizations"
        exit 1
    fi
}

# Create required directories
create_directories() {
    print_status "Creating required directories..."

    # Create assets directories
    mkdir -p assets/images
    mkdir -p assets/animations
    mkdir -p assets/icons

    # Create placeholder files
    touch assets/images/.gitkeep
    touch assets/animations/.gitkeep
    touch assets/icons/.gitkeep

    print_success "Directories created successfully"
}

# Create placeholder images
create_placeholder_images() {
    print_status "Creating placeholder assets..."

    # Create a simple SVG placeholder
    cat > assets/images/app_logo.svg << 'EOF'
<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <rect width="100" height="100" fill="#0277BD"/>
  <text x="50" y="55" font-family="Arial" font-size="12" fill="white" text-anchor="middle">SHOP</text>
</svg>
EOF

    print_success "Placeholder assets created"
}

# Check Flutter doctor
check_flutter_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor -v

    print_warning "Please review Flutter doctor output above."
    print_warning "Make sure there are no errors before proceeding."
}

# Firebase setup guide
firebase_setup_guide() {
    print_status "Firebase Setup Guide:"
    echo "1. Go to https://console.firebase.google.com/"
    echo "2. Create a new project or use existing one"
    echo "3. Add Android app with package name: com.example.mobile_app_for_shops"
    echo "4. Add iOS app with bundle ID: com.example.mobile_app_for_shops"
    echo "5. Download configuration files:"
    echo "   - google-services.json → android/app/"
    echo "   - GoogleService-Info.plist → ios/Runner/"
    echo "6. Enable Authentication → Email/Password"
    echo "7. Enable Firestore Database"
    echo "8. Enable Storage"
    echo "9. Update firebase_options.dart with your project details"
    echo "10. Deploy security rules: firebase deploy --only firestore:rules,storage:rules"
}

# Main setup function
main() {
    echo "=========================================="
    echo "  Shop Management System Setup"
    echo "=========================================="
    echo ""

    # Run checks and setup
    check_flutter
    check_firebase
    create_directories
    create_placeholder_images
    install_dependencies
    generate_code
    generate_localizations
    check_flutter_doctor

    echo ""
    echo "=========================================="
    print_success "Setup completed successfully! 🎉"
    echo "=========================================="
    echo ""

    firebase_setup_guide

    echo ""
    print_status "Next steps:"
    echo "1. Configure Firebase as shown above"
    echo "2. Run 'flutter run' to start the app"
    echo "3. For development, see DEVELOPMENT.md"
    echo "4. For deployment, see IMPLEMENTATION_GUIDE.md"
    echo ""
    print_success "Happy coding! 🚀"
}

# Handle script arguments
case "${1:-}" in
    "help"|"-h"|"--help")
        echo "Shop Management System Setup Script"
        echo ""
        echo "Usage: $0 [help]"
        echo ""
        echo "This script sets up the Flutter project with all necessary dependencies"
        echo "and provides guidance for Firebase configuration."
        ;;
    *)
        main
        ;;
esac