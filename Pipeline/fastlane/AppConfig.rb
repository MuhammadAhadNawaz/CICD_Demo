# fastlane/AppConfig.rb
module AppConfig
  # Bundle Identifiers
  BUNDLE_IDS = {
    main: "com.insite.montanevalley",
    autofill: "com.insite.montanevalley.autofill",
    widget: "com.insite.montanevalley.communitywidget"
  }
  
  # App Store Connect credentials
  APPLE_ID = ENV["FASTLANE_USER"] || "adeelkmalik@gmail.com"
  
  # Development Team ID (will be auto-detected from profiles if nil)
  TEAM_ID = ENV["TEAM_ID"] || nil
  
  # Export options defaults
  EXPORT_METHOD = "app-store"
  SIGNING_CERTIFICATE = "Apple Distribution"
  
  # Build settings
  SCHEME = "MontaneValley"
  
  # Workspace is at the project root (one level above Pipeline)
  # Pipeline/fastlane/ -> Pipeline/ -> MoonlightBasin-iOS/
  PROJECT_ROOT = File.expand_path("../..", __dir__)  # Goes up two levels from fastlane
  WORKSPACE = File.join(PROJECT_ROOT, "MontaneValley.xcworkspace")
  CONFIGURATION = "Release"
  
  # Paths - build directory at project root
  BUILD_DIRECTORY = File.join(PROJECT_ROOT, "build")
  IPA_NAME = "MontaneValley.ipa"
  
  # Profiles are in Pipeline/ProvisioningProfiles (one level up from fastlane)
  PROFILES_DIR = File.expand_path("../ProvisioningProfiles", __dir__)
  
  # Helper methods
  def self.bundle_id(type)
    BUNDLE_IDS[type.to_sym]
  end
  
  def self.all_bundle_ids
    BUNDLE_IDS.values
  end
  
  def self.ipa_path
    File.join(BUILD_DIRECTORY, IPA_NAME)
  end
end
