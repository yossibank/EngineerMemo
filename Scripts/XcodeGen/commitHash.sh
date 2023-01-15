plistBuddy="/usr/libexec/PlistBuddy"
infoPlistFile="${TEMP_DIR}/Preprocessed-Info.plist"

commitHash=$(git rev-parse --short HEAD)
$plistBuddy -c "Set :CommitHash $commitHash" $infoPlistFile