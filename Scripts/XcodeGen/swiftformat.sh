# Apple Silicon MacでHomebrewのPATHを通す
if [ -d /opt/homebrew/bin ] && ! type brew > /dev/null 2>&1 ; then
    export PATH="$PATH:/opt/homebrew/bin"
fi

if which mint >/dev/null; then
    git diff --name-only | grep .swift | while read filename; do
        xcrun --sdk macosx mint run swiftformat "$filename"
    done
fi