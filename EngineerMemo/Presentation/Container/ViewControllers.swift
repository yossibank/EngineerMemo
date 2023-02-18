import SwiftUI

enum AppControllers {
    enum Memo {
        static func List() -> MemoListViewController {
            let vc = MemoListViewController()

            vc.title = L10n.Navigation.Title.memoList
            vc.inject(
                contentView: ContentViews.Memo.List(),
                viewModel: ViewModels.Memo.List()
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
                contentView: ContentViews.Profile.Detail(),
                viewModel: ViewModels.Profile.Detail(routing: routing)
            )

            return vc
        }

        static func Update(type: ProfileUpdateType) -> ProfileUpdateViewController {
            let vc = ProfileUpdateViewController()

            switch type {
            case .setting:
                vc.title = L10n.Navigation.Title.profileSetting
                vc.inject(
                    contentView: ContentViews.Profile.Update(),
                    viewModel: ViewModels.Profile.Update(screenId: .profileSetting)
                )

            case let .update(modelObject):
                vc.title = L10n.Navigation.Title.profileUpdate
                vc.inject(
                    contentView: ContentViews.Profile.Update(modelObject: modelObject),
                    viewModel: ViewModels.Profile.Update(
                        modelObject: modelObject,
                        screenId: .profileUpdate
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
                    contentView: ContentViews.Debug.Development(),
                    viewModel: ViewModels.Debug.Development(routing: routing)
                )

                return vc
            }

            enum CoreData {
                static func Create() -> DebugCoreDataCreateViewController {
                    let vc = DebugCoreDataCreateViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: ContentViews.Debug.CoreData.Create())
                    return vc
                }

                static func List() -> DebugCoreDataListViewController {
                    let vc = DebugCoreDataListViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataList
                    vc.inject(contentView: ContentViews.Debug.CoreData.List())
                    return vc
                }

                static func Update() -> DebugCoreDataUpdateViewController {
                    let vc = DebugCoreDataUpdateViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataUpdate
                    vc.inject(contentView: ContentViews.Debug.CoreData.Update())
                    return vc
                }
            }

            enum CoreDataObject {
                enum List {
                    static func Profile() -> DebugProfileListViewController {
                        let vc = DebugProfileListViewController()

                        vc.inject(
                            contentView: ContentViews.Debug.CoreDataObject.List.Profile(),
                            viewModel: ViewModels.Debug.CoreDataObject.List.Profile()
                        )

                        return vc
                    }
                }

                enum Create {
                    static func Profile() -> DebugProfileCreateViewController {
                        let vc = DebugProfileCreateViewController()

                        vc.inject(
                            contentView: ContentViews.Debug.CoreDataObject.Create.Profile(),
                            viewModel: ViewModels.Debug.CoreDataObject.Create.Profile()
                        )

                        return vc
                    }
                }

                enum Update {
                    static func Profile() -> DebugProfileUpdateViewController {
                        let vc = DebugProfileUpdateViewController()

                        vc.inject(
                            contentView: ContentViews.Debug.CoreDataObject.Update.Profile(),
                            viewModel: ViewModels.Debug.CoreDataObject.Update.Profile()
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
