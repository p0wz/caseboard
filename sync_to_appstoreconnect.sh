#!/usr/bin/env bash
set -e

echo "=========================================="
echo "  Caseboard: App Store Connect Publisher  "
echo "=========================================="

APP_ID="$1"

if [ -z "$APP_ID" ]; then
    echo "Checking existing apps in App Store Connect..."
    asc apps list
    echo ""
    echo "Usage: ./sync_to_appstoreconnect.sh <APP_ID>"
    echo ""
    echo "If you haven't created the App Record in App Store Connect yet:"
    echo "1. Go to https://appstoreconnect.apple.com/apps"
    echo "2. Click [+] -> New App"
    echo "   - Platforms: iOS"
    echo "   - Name: Caseboard: Detective Mystery"
    echo "   - Primary Language: English (U.S.)"
    echo "   - Bundle ID: Caseboard - com.p0wze.caseboard"
    echo "   - SKU: caseboardapp"
    echo "   - User Access: Full Access"
    echo "3. Copy the App ID from App Store Connect (or run 'asc apps list')"
    echo "4. Run: ./sync_to_appstoreconnect.sh <APP_ID>"
    echo ""
    echo "Alternatively, you can create it via CLI by running:"
    echo "asc web apps create --name \"Caseboard: Detective Mystery\" --bundle-id \"com.p0wze.caseboard\" --sku \"caseboardapp\""
    exit 1
fi

echo ">> 1. Validating Canonical Metadata..."
asc metadata validate --dir "./metadata"

echo ">> 2. Validating 6.7\" Screenshots..."
asc screenshots validate --path "appstore_screenshots/iphone_67" --device-type "IPHONE_67"

echo ">> 3. Pushing ASO Metadata to App Store Connect (App ID: $APP_ID)..."
asc metadata push --app "$APP_ID" --version "1.0" --dir "./metadata"

echo ">> 4. Uploading AppLaunchpad Screenshots (1290x2796) to App Store Connect..."
asc screenshots upload --app "$APP_ID" --version "1.0" --path "appstore_screenshots/iphone_67" --device-type "IPHONE_67"

echo "=========================================="
echo "  SUCCESS: All ASO Metadata & Screenshots "
echo "  have been synced to App Store Connect!  "
echo "=========================================="
