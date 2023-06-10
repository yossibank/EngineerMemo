# Apple Silicon MacでHomebrewのPATHを通す
if [ -d /opt/homebrew/bin ] && ! type brew > /dev/null 2>&1 ; then
    export PATH="$PATH:/opt/homebrew/bin"
fi

if which mint >/dev/null; then
    make generate-test-mock
fi