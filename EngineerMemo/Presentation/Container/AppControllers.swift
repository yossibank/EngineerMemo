import SwiftUI

enum AppControllers {
    enum Memo {
        static func Detail(modelObject: MemoModelObject) -> MemoDetailViewController {
            let vc = MemoDetailViewController()

            vc.title = L10n.Navigation.Title.memoDetail
            vc.inject(
                contentView: MemoDetailContentView(modelObject: modelObject),
                viewModel: MemoDetailViewModel(
                    analytics: FirebaseAnalytics(screenId: .memoDetail)
                )
            )

            return vc
        }

        static func List() -> MemoListViewController {
            let vc = MemoListViewController()
            let routing = MemoListRouting(viewController: vc)

            vc.title = L10n.Navigation.Title.memoList
            vc.inject(
                contentView: MemoListContentView(),
                viewModel: MemoListViewModel(
                    model: Models.Memo(),
                    routing: routing,
                    analytics: FirebaseAnalytics(screenId: .memoList)
                )
            )

            return vc
        }
    }

    enum Profile {
        static func Detail() -> ProfileDetailViewController {
            let vc = ProfileDetailViewController()
            let routing = ProfileDetailRouting(viewController: vc)

            vc.title = L10n.Navigation.Title.profileDetail
            vc.inject(
                contentView: ProfileDetailContentView(),
                viewModel: ProfileDetailViewModel(
                    model: Models.Profile(),
                    routing: routing,
                    analytics: FirebaseAnalytics(screenId: .profileDetail)
                )
            )

            return vc
        }

        static func Icon() -> ProfileIconViewController {
            let vc = ProfileIconViewController()

            vc.title = L10n.Navigation.Title.profileIcon
            vc.inject(
                contentView: ProfileIconContentView(),
                viewModel: ProfileIconViewModel(
                    analytics: FirebaseAnalytics(screenId: .profileIcon)
                )
            )

            return vc
        }

        static func Update(type: ProfileUpdateType) -> ProfileUpdateViewController {
            let vc = ProfileUpdateViewController()

            switch type {
            case .setting:
                vc.title = L10n.Navigation.Title.profileSetting
                vc.inject(
                    contentView: ProfileUpdateContentView(modelObject: nil),
                    viewModel: ProfileUpdateViewModel(
                        model: Models.Profile(),
                        modelObject: nil,
                        analytics: FirebaseAnalytics(screenId: .profileSetting)
                    )
                )

            case let .update(modelObject):
                vc.title = L10n.Navigation.Title.profileUpdate
                vc.inject(
                    contentView: ProfileUpdateContentView(modelObject: modelObject),
                    viewModel: ProfileUpdateViewModel(
                        model: Models.Profile(),
                        modelObject: modelObject,
                        analytics: FirebaseAnalytics(screenId: .profileUpdate)
                    )
                )
            }

            return vc
        }
    }

    #if DEBUG
        enum Debug {
            static func Development() -> DebugDevelopmentViewController {
                let vc = DebugDevelopmentViewController()
                let routing = DebugDevelopmentRouting(viewController: vc)

                vc.title = L10n.Navigation.Title.debugDevelopment
                vc.inject(
                    contentView: DebugDevelopmentContentView(),
                    viewModel: DebugDevelopmentViewModel(routing: routing)
                )

                return vc
            }

            static func UserDefaults() -> DebugUserDefaultsViewController {
                let vc = DebugUserDefaultsViewController()

                vc.title = L10n.Navigation.Title.debugUserDefaults
                vc.inject(
                    contentView: DebugUserDefaultsContentView(),
                    viewModel: DebugUserDefaultsViewModel()
                )

                return vc
            }

            enum CoreData {
                static func List() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .list)
                    vc.title = L10n.Navigation.Title.debugCoreDataList
                    vc.inject(contentView: DebugCoreDataMenuContentView())
                    return vc
                }

                static func Create() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .create)
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: DebugCoreDataMenuContentView())
                    return vc
                }

                static func Update() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .update)
                    vc.title = L10n.Navigation.Title.debugCoreDataUpdate
                    vc.inject(contentView: DebugCoreDataMenuContentView())
                    return vc
                }
            }

            enum CoreDataObject {
                enum List {
                    static func Profile() -> DebugProfileListViewController {
                        let vc = DebugProfileListViewController()

                        vc.inject(
                            contentView: DebugProfileListContentView(),
                            viewModel: DebugProfileListViewModel(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Memo() -> DebugMemoListViewController {
                        let vc = DebugMemoListViewController()

                        vc.inject(
                            contentView: DebugMemoListContentView(),
                            viewModel: DebugMemoListViewModel(model: Models.Memo())
                        )

                        return vc
                    }
                }

                enum Create {
                    static func Profile() -> DebugProfileCreateViewController {
                        let vc = DebugProfileCreateViewController()

                        vc.inject(
                            contentView: DebugProfileCreateContentView(),
                            viewModel: DebugProfileCreateViewModel(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Memo() -> DebugMemoCreateViewController {
                        let vc = DebugMemoCreateViewController()

                        vc.inject(
                            contentView: DebugMemoCreateContentView(),
                            viewModel: DebugMemoCreateViewModel(model: Models.Memo())
                        )

                        return vc
                    }
                }

                enum Update {
                    static func Profile() -> DebugProfileUpdateViewController {
                        let vc = DebugProfileUpdateViewController()

                        vc.inject(
                            contentView: DebugProfileUpdateContentView(),
                            viewModel: DebugProfileUpdateViewModel(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Memo() -> DebugMemoUpdateViewController {
                        let vc = DebugMemoUpdateViewController()

                        vc.inject(
                            contentView: DebugMemoUpdateContentView(),
                            viewModel: DebugMemoUpdateViewModel(model: Models.Memo())
                        )

                        return vc
                    }
                }
            }
        }
    #endif
}

enum ProfileUpdateType: Equatable {
    case setting
    case update(ProfileModelObject)
}
