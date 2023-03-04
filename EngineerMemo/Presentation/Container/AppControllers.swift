import SwiftUI

enum AppControllers {
    enum Memo {
        static func List() -> MemoListViewController {
            let vc = MemoListViewController()

            vc.title = L10n.Navigation.Title.memoList
            vc.inject(
                contentView: MemoListContentView(),
                viewModel: MemoListViewModel(analytics: FirebaseAnalytics(screenId: .memoList))
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

            enum CoreData {
                static func Create() -> DebugCoreDataCreateViewController {
                    let vc = DebugCoreDataCreateViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: DebugCoreDataCreateContentView())
                    return vc
                }

                static func List() -> DebugCoreDataListViewController {
                    let vc = DebugCoreDataListViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataList
                    vc.inject(contentView: DebugCoreDataListContentView())
                    return vc
                }

                static func Update() -> DebugCoreDataUpdateViewController {
                    let vc = DebugCoreDataUpdateViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataUpdate
                    vc.inject(contentView: DebugCoreDataUpdateContentView())
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
                }

                enum Create {
                    static func Memo() -> DebugMemoCreateViewController {
                        let vc = DebugMemoCreateViewController()
                        
                        vc.inject(
                            contentView: DebugMemoCreateContentView(),
                            viewModel: DebugMemoCreateViewModel(model: Models.Memo())
                        )

                        return vc
                    }
                    
                    static func Profile() -> DebugProfileCreateViewController {
                        let vc = DebugProfileCreateViewController()

                        vc.inject(
                            contentView: DebugProfileCreateContentView(),
                            viewModel: DebugProfileCreateViewModel(model: Models.Profile())
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
                }
            }
        }
    #endif
}

enum ProfileUpdateType: Equatable {
    case setting
    case update(ProfileModelObject)
}
