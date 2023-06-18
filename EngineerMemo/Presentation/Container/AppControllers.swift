import SwiftUI

enum AppControllers {
    static func Sheet(_ sheetContent: SheetContent) -> SheetViewController {
        let vc = SheetViewController()
        vc.inject(contentView: SheetContentView(sheetContent: sheetContent))
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }

    enum Memo {
        static func Detail(identifier: String) -> MemoDetailViewController {
            let vc = MemoDetailViewController()
            let routing = MemoDetailRouting(viewController: vc)

            vc.title = L10n.Navigation.Title.memoDetail
            vc.inject(
                contentView: MemoDetailContentView(),
                viewModel: MemoDetailViewModel(
                    identifier: identifier,
                    model: Models.Memo(),
                    routing: routing,
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

        static func Update(modelObject: MemoModelObject?) -> MemoUpdateViewController {
            let vc = MemoUpdateViewController()

            vc.title = modelObject.isNil
                ? L10n.Navigation.Title.memoCreate
                : L10n.Navigation.Title.memoUpdate

            vc.inject(
                contentView: MemoUpdateContentView(modelObject: modelObject),
                viewModel: MemoUpdateViewModel(
                    model: Models.Memo(),
                    modelObject: modelObject,
                    analytics: modelObject.isNil
                        ? FirebaseAnalytics(screenId: .memoCreate)
                        : FirebaseAnalytics(screenId: .memoUpdate)
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

        static func Icon(modelObject: ProfileModelObject) -> ProfileIconViewController {
            let vc = ProfileIconViewController()

            vc.title = L10n.Navigation.Title.profileIcon
            vc.inject(
                contentView: ProfileIconContentView(),
                viewModel: ProfileIconViewModel(
                    model: Models.Profile(),
                    modelObject: modelObject,
                    analytics: FirebaseAnalytics(screenId: .profileIcon)
                )
            )

            return vc
        }

        enum Update {
            static func Basic(modelObject: ProfileModelObject?) -> ProfileUpdateBasicViewController {
                let vc = ProfileUpdateBasicViewController()

                vc.title = L10n.Navigation.Title.profileBasicSetting
                vc.inject(
                    contentView: ProfileUpdateBasicContentView(modelObject: modelObject),
                    viewModel: ProfileUpdateBasicViewModel(
                        modelObject: modelObject,
                        model: Models.Profile(),
                        analytics: modelObject.isNil
                            ? FirebaseAnalytics(screenId: .profileBasicSetting)
                            : FirebaseAnalytics(screenId: .profileBasicUpdate)
                    )
                )

                return vc
            }

            static func Skill(modelObject: ProfileModelObject) -> ProfileUpdateSkillViewController {
                let vc = ProfileUpdateSkillViewController()

                vc.title = L10n.Navigation.Title.profileSKillSetting
                vc.inject(
                    contentView: ProfileUpdateSkillContentView(modelObject: modelObject),
                    viewModel: ProfileUpdateSkillViewModel(
                        modelObject: modelObject,
                        model: Models.Profile(),
                        analytics: modelObject.skill.isNil
                            ? FirebaseAnalytics(screenId: .profileSkillSetting)
                            : FirebaseAnalytics(screenId: .profileSkillUpdate)
                    )
                )

                return vc
            }
        }
    }
}

#if DEBUG
    extension AppControllers {
        enum Debug {
            static func Development() -> DebugDevelopmentViewController {
                let vc = DebugDevelopmentViewController()
                let routing = DebugDevelopmentRouting(viewController: vc)

                vc.title = L10n.Navigation.Title.debugDevelopment
                vc.inject(
                    contentView: DebugDevelopmentContentView(),
                    viewModel: DebugDevelopmentViewModel(
                        model: DebugModel(),
                        routing: routing
                    )
                )

                return vc
            }

            static func API() -> DebugAPIViewController {
                let vc = DebugAPIViewController()

                vc.title = L10n.Navigation.Title.debugAPIResponse
                vc.inject(
                    contentView: DebugAPIContentView(),
                    viewModel: DebugAPIViewModel()
                )

                return vc
            }

            enum CoreData {
                static func Create() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .create)
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: DebugCoreDataMenuContentView())
                    return vc
                }

                static func List() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .list)
                    vc.title = L10n.Navigation.Title.debugCoreDataList
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
                    static func Memo() -> DebugMemoListViewController {
                        let vc = DebugMemoListViewController()

                        vc.inject(
                            contentView: DebugMemoListContentView(),
                            viewModel: DebugMemoListViewModel(model: Models.Memo())
                        )

                        return vc
                    }

                    static func Profile() -> DebugProfileListViewController {
                        let vc = DebugProfileListViewController()

                        vc.inject(
                            contentView: DebugProfileListContentView(),
                            viewModel: DebugProfileListViewModel(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Project() -> DebugProjectListViewController {
                        let vc = DebugProjectListViewController()

                        vc.inject(
                            contentView: DebugProjectListContentView(),
                            viewModel: DebugProjectListViewModel(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Skill() -> DebugSkillListViewController {
                        let vc = DebugSkillListViewController()

                        vc.inject(
                            contentView: DebugSkillListContentView(),
                            viewModel: DebugSkillListViewModel(model: Models.Profile())
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
                    static func Memo() -> DebugMemoUpdateViewController {
                        let vc = DebugMemoUpdateViewController()

                        vc.inject(
                            contentView: DebugMemoUpdateContentView(),
                            viewModel: DebugMemoUpdateViewModel(model: Models.Memo())
                        )

                        return vc
                    }

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
    }
#endif

enum MemoUpdateType: Equatable {
    case create
    case update(MemoModelObject)
}
