# Apple Silicon MacでHomebrewのPATHを通す
if [ -d /opt/homebrew/bin ] && ! type brew > /dev/null 2>&1 ; then
    export PATH="$PATH:/opt/homebrew/bin"
fi

if which mint >/dev/null; then
    xcrun --sdk macosx mint run mono0926/LicensePlist --output-path EngineerMemo/App/Plist/Settings.bundle
fi