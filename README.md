# エンメモ

![Apple](https://img.shields.io/badge/Apple-%23777777.svg?style=for-the-badge&logo=apple&logoColor=white) ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) ![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-008000?style=for-the-badge&logo=ios&logoColor=white) ![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)  ![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)

## What's App

| | | | |
|:---:|:---:|:---:|:---:|
| <img src='Screenshot/Screenshot1.jpeg' /> | <img src='Screenshot/Screenshot2.jpeg' /> | <img src='Screenshot/Screenshot3.jpeg' /> | <img src='Screenshot/Screenshot4.jpeg' /> |

## App Store(2023/07/04~ unsubscribe)

[![App Store Link][app-store-url]][AppStore]

[app-store-url]: https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white
[AppStore]: https://apps.apple.com/us/app/%E3%82%A8%E3%83%B3%E3%83%A1%E3%83%A2/id6450376037

## App Screen(Snapshot)

* [ScreenList](https://github.com/yossibank/EngineerMemo/tree/main/EngineerMemoSnapshotTests/Reports)

※ Example

* カスタムシート画面

|全項目存在 長文|全項目存在 長文|
|:---:|:---:|
|Dark|Light|
|393x852.png|393x852.png|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/Sheet/testSheetViewController_全項目存在_長文_Dark_393x852.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/Sheet/testSheetViewController_全項目存在_長文_Light_393x852.png' width='250' style='border: 1px solid #999' />|

* プロフィールアイコン変更画面

|全項目|全項目|
|:---:|:---:|
|Dark|Light|
|393x852.png|393x852.png|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/ProfileIcon/testProfileIconViewController_全項目_Dark_393x852.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/ProfileIcon/testProfileIconViewController_全項目_Light_393x852.png' width='250' style='border: 1px solid #999' />|

* プロフィール設定・更新画面

|更新|更新|
|:---:|:---:|
|Dark|Light|
|393x852.png|393x852.png|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/ProfileBasicUpdate/testBasicUpdateViewController_更新_Dark_393x852.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/ProfileBasicUpdate/testBasicUpdateViewController_更新_Light_393x852.png' width='250' style='border: 1px solid #999' />|

* メモ一覧画面

|件数中|件数中|
|:---:|:---:|
|Dark|Light|
|393x852.png|393x852.png|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/MemoList/testMemoListViewController_件数中_Dark_393x852.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/MemoList/testMemoListViewController_件数中_Light_393x852.png' width='250' style='border: 1px solid #999' />|

* メモ詳細画面

|標準|標準|
|:---:|:---:|
|Dark|Light|
|393x852.png|393x852.png|
|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/MemoDetail/testMemoDetailViewController_標準_Dark_393x852.png' width='250' style='border: 1px solid #999' />|<img src='EngineerMemoSnapshotTests/ReferenceImages_64/MemoDetail/testMemoDetailViewController_標準_Light_393x852.png' width='250' style='border: 1px solid #999' />|

## Target OS

* **above iOS15**

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

**MVVM + Router with Combine + UIKit**

* **Model**(Target UnitTest)
  - **Converter**

* **ViewModel**(Target UnitTest)
  - **Router**

* **View**(Target SnapshotTest)
