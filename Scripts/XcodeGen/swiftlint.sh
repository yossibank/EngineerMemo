if which mint >/dev/null; then
    git diff --name-only | grep .swift | while read filename; do
        xcrun --sdk macosx mint run swiftlint "$filename"
    done
fi