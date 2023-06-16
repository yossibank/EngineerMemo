fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios unit_test

```sh
[bundle exec] fastlane ios unit_test
```

環境変数

ユニットテストを実行する

### ios update_develop_certificates

```sh
[bundle exec] fastlane ios update_develop_certificates
```

開発者用証明書更新

### ios update_appstore_certificates

```sh
[bundle exec] fastlane ios update_appstore_certificates
```

本番用開発者用証明書更新

### ios read_develop_certificates

```sh
[bundle exec] fastlane ios read_develop_certificates
```

開発者用証明書取得

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
