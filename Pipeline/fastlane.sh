#!/bin/bash

echo "🧪 Testing Fastlane with project profiles"
echo "========================================"

# Check if profiles exist
if [ ! -d "ProvisioningProfiles" ]; then
    echo "❌ ProvisioningProfiles directory not found!"
    exit 1
fi

PROFILE_COUNT=$(ls -1 ProvisioningProfiles/*.mobileprovision 2>/dev/null | wc -l)
echo "✅ Found $PROFILE_COUNT provisioning profiles in project"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
bundle install

# Check profiles
echo ""
echo "🔍 Checking profiles..."
bundle exec fastlane check_profiles

# Ask user which lane to run
echo ""
echo "Select lane to run:"
echo "1) Build only"
echo "2) Build and upload to TestFlight"
echo "3) Build and upload to App Store"
read -p "Choice (1-3): " choice

case $choice in
    1)
        bundle exec fastlane build_only
        ;;
    2)
        bundle exec fastlane beta
        ;;
    3)
        bundle exec fastlane release
        ;;
esac
