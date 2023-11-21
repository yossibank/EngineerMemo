if [ -d ${BUILD_DIR%/Build/*}/SourcePackages ]; then
    ${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run
fi