# EngineerMemo

## What's App

| | | | |
|:---:|:---:|:---:|:---:|
| <img src='Screenshot/%E2%80%8EScreenshot1.jpeg' /> | <img src='Screenshot/%E2%80%8EScreenshot2.jpeg' /> | <img src='Screenshot/%E2%80%8EScreenshot3.jpeg' /> | <img src='Screenshot/%E2%80%8EScreenshot4.jpeg' /> |

## App Store Link

https://apps.apple.com/us/app/%E3%82%A8%E3%83%B3%E3%83%A1%E3%83%A2/id6450376037

## App Screen(Snapshot)

* [ScreenList](https://github.com/yossibank/EngineerMemo/tree/main/EngineerMemoSnapshotTests/Reports)

※ Example

* カスタムシート画面

|全項目存在長文ダークモード|全項目存在長文ライトモード|
|:---:|:---:|
|16.4|16.4|
|iPhone14|iPhone14|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/カスタムシート/testSheetViewController_全項目存在_長文_ダークモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/カスタムシート/testSheetViewController_全項目存在_長文_ライトモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|

* プロフィールアイコン変更画面

|全項目ダークモード|全項目ライトモード|
|:---:|:---:|
|16.4|16.4|
|iPhone14|iPhone14|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/プロフィールアイコン変更画面/testProfileIconViewController_全項目_ダークモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/プロフィールアイコン変更画面/testProfileIconViewController_全項目_ライトモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|

* プロフィール設定・更新画面

|更新ダークモード|更新ライトモード|
|:---:|:---:|
|16.4|16.4|
|iPhone14|iPhone14|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/プロフィール基本情報設定・更新画面/testBasicUpdateViewController_更新_ダークモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/プロフィール基本情報設定・更新画面/testBasicUpdateViewController_更新_ライトモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|

* メモ一覧画面

|件数中ダークモード|件数中ライトモード|
|:---:|:---:|
|16.4|16.4|
|iPhone14|iPhone14|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/メモ一覧画面/testMemoListViewController_件数中_ダークモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/メモ一覧画面/testMemoListViewController_件数中_ライトモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|

* メモ詳細画面

|標準ダークモード|標準ライトモード|
|:---:|:---:|
|16.4|16.4|
|iPhone14|iPhone14|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/メモ詳細画面/testMemoDetailViewController_標準_ダークモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/メモ詳細画面/testMemoDetailViewController_標準_ライトモード_iPhone_16_4_390x844@3x.png' width='250' style='border: 1px solid #999' />|

## Target OS

* above iOS15

## Library

* **Firebase**
* **SnapKit**
* **OHHTTPStubs**
* **iOSSnapshotTestCase**
* **Mockolo**
* **LicensePlist**
* **UIKitHelper(self-made Library)**

## Tool

* **SwiftFormat**
* **SwiftLint**
* **SwiftGen**
* **XcodeGen**

## Architecture

**MVVM with Combine**

* **Model**(Target UnitTest)
  - **Converter**

* **ViewModel**(Target UnitTest)
  - **Router**

* **View**(Target SnapshotTest)
