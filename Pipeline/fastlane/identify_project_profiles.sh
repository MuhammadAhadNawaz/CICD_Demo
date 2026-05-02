#!/bin/bash
# fastlane/identify_project_profiles.sh

# Get the directory where this script is located (fastlane folder)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Profiles are in ProvisioningProfiles at the same level as fastlane
PROFILES_DIR="$SCRIPT_DIR/../ProvisioningProfiles"

MAIN_PROFILE=""
AUTOFILL_PROFILE=""
WIDGET_PROFILE=""
TEAM_ID=""

# Debug output to stderr
echo "DEBUG: Script directory: $SCRIPT_DIR" >&2
echo "DEBUG: Looking for profiles in: $PROFILES_DIR" >&2

if [ ! -d "$PROFILES_DIR" ]; then
    echo "ERROR: Profiles directory not found: $PROFILES_DIR" >&2
    echo "Main App Profile: NOT FOUND"
    echo "AutoFill Profile: NOT FOUND"
    echo "Widget Profile: NOT FOUND"
    echo "Team ID: NOT FOUND"
    exit 1
fi

PROFILE_COUNT=$(ls -1 "$PROFILES_DIR"/*.mobileprovision 2>/dev/null | wc -l)
echo "DEBUG: Found $PROFILE_COUNT profile(s)" >&2

for profile in "$PROFILES_DIR"/*.mobileprovision; do
    if [ -f "$profile" ]; then
        echo "DEBUG: Processing $(basename "$profile")" >&2
        
        PROFILE_NAME=$(security cms -D -i "$profile" 2>/dev/null | grep -A1 "<key>Name</key>" | tail -1 | sed 's/.*<string>//;s/<\/string>.*//')
        BUNDLE_ID=$(security cms -D -i "$profile" 2>/dev/null | grep -A1 "<key>application-identifier</key>" | tail -1 | sed 's/.*<string>//;s/<\/string>.*//' | cut -d. -f2-)
        
        echo "DEBUG: Profile Name: $PROFILE_NAME" >&2
        echo "DEBUG: Bundle ID: $BUNDLE_ID" >&2
        
        # Get Team ID from first profile
        if [ -z "$TEAM_ID" ]; then
            TEAM_ID=$(security cms -D -i "$profile" 2>/dev/null | grep -A1 "<key>com.apple.developer.team-identifier</key>" | tail -1 | sed 's/.*<string>//;s/<\/string>.*//')
            echo "DEBUG: Team ID: $TEAM_ID" >&2
        fi
        
        # Detect profile type based on Bundle ID
        BUNDLE_ID_LOWER=$(echo "$BUNDLE_ID" | tr '[:upper:]' '[:lower:]')
        
        if [[ "$BUNDLE_ID_LOWER" == *"autofill"* ]]; then
            AUTOFILL_PROFILE="$PROFILE_NAME"
            echo "DEBUG: Identified as AUTOFILL" >&2
        elif [[ "$BUNDLE_ID_LOWER" == *"widget"* ]] || [[ "$BUNDLE_ID_LOWER" == *"communitywidget"* ]]; then
            WIDGET_PROFILE="$PROFILE_NAME"
            echo "DEBUG: Identified as WIDGET" >&2
        elif [[ "$BUNDLE_ID_LOWER" == *"montanevalley"* ]] && [[ "$BUNDLE_ID_LOWER" != *"autofill"* ]] && [[ "$BUNDLE_ID_LOWER" != *"widget"* ]]; then
            MAIN_PROFILE="$PROFILE_NAME"
            echo "DEBUG: Identified as MAIN APP" >&2
        fi
        echo "" >&2
    fi
done

# Output results (this is what Fastlane parses)
echo "Main App Profile: ${MAIN_PROFILE:-NOT FOUND}"
echo "AutoFill Profile: ${AUTOFILL_PROFILE:-NOT FOUND}"
echo "Widget Profile: ${WIDGET_PROFILE:-NOT FOUND}"
echo "Team ID: ${TEAM_ID:-NOT FOUND}"
