# EngineerMemo

## アプリ画面(Snapshot)

* [画面一覧](https://github.com/yossibank/EngineerMemo/tree/main/EngineerMemoTests/Reports)

※ 画面例

* カスタムシート画面

|全項目存在ダークモード|全項目存在ライトモード|
|:---:|:---:|
|16.0|16.0|
|iPhone14|iPhone14|
|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/カスタムシート/testSheetViewController_全項目存在_ダークモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/カスタムシート/testSheetViewController_全項目存在_ライトモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|

* プロフィールアイコン変更画面

|全項目ダークモード|全項目ライトモード|
|:---:|:---:|
|16.0|16.0|
|iPhone14|iPhone14|
|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/プロフィールアイコン変更画面/testProfileIconViewController_全項目_ダークモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/プロフィールアイコン変更画面/testProfileIconViewController_全項目_ライトモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|

* プロフィール設定・更新画面

|更新ダークモード|更新ライトモード|
|:---:|:---:|
|16.0|16.0|
|iPhone14|iPhone14|
|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/プロフィール設定・更新画面/testProfileUpdateViewController_更新_ダークモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/プロフィール設定・更新画面/testProfileUpdateViewController_更新_ライトモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|

* メモ一覧画面

|件数中ダークモード|件数中ライトモード|
|:---:|:---:|
|16.0|16.0|
|iPhone14|iPhone14|
|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/メモ一覧画面/testMemoListViewController_件数中_ダークモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/メモ一覧画面/testMemoListViewController_件数中_ライトモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|

* メモ詳細画面

|標準ダークモード|標準ライトモード|
|:---:|:---:|
|16.0|16.0|
|iPhone14|iPhone14|
|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/メモ詳細画面/testMemoDetailViewController_標準_ダークモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|<img src='EngineerMemoTests/TestSnapshot/ReferenceImages_64/メモ詳細画面/testMemoDetailViewController_標準_ライトモード_iPhone_16_0_390x844@3x.png' width='200' style='border: 1px solid #999' />|

## 開発用機能

* APIレスポンス確認

https://user-images.githubusercontent.com/55877379/233827264-f389c7db-126f-4b01-8d08-36446e9c61bb.mov

https://user-images.githubusercontent.com/55877379/233827281-3eb41f69-af39-457d-baff-d5f06e9380dd.mov

## 対象OS

* iOS14以降

## 導入ライブラリ

* **Firebase**
* **SnapKit**
* **IQKeyboardManager**
* **OHHTTPStubs**
* **iOSSnapshotTestCase**
* **Mockolo**
* **LicensePlist**
* **UIKitHelper(自作ライブラリ)**

## 導入ツール

* **SwiftFormat**
* **SwiftLint**
* **SwiftGen**
* **XcodeGen**

## プロジェクト設定

* `project.yml`内で管理、以下コマンド実行

```
make setup
```

## アーキテクチャ

**MVVM**

* **Model**(単体テスト対象)

* **ViewModel**(単体テスト対象)
  - **Router**(画面遷移管理)保持

* **View**
