import SwiftUI

enum AppControllers {
    static func Sheet(_ sheetContent: SheetContent) -> SheetViewController {
        let vc = SheetViewController()
        vc.inject(contentView: .init(sheetContent: sheetContent))
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }

    enum Memo {
        static func Detail(identifier: String) -> MemoDetailViewController {
            let vc = MemoDetailViewController()
            let routing = MemoDetailRouting(viewController: vc)

            vc.title = L10n.Navigation.Title.memoDetail
            vc.inject(
                contentView: .init(),
                viewModel: .init(
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
                contentView: .init(),
                viewModel: .init(
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
                contentView: .init(modelObject: modelObject),
                viewModel: .init(
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
        enum Information {
            enum Basic {
                static func Update(modelObject: ProfileModelObject?) -> BasicUpdateViewController {
                    let vc = BasicUpdateViewController()

                    vc.title = modelObject.isNil
                        ? L10n.Navigation.Title.basicSetting
                        : L10n.Navigation.Title.basicUpdate

                    vc.inject(
                        contentView: .init(modelObject: modelObject),
                        viewModel: .init(
                            modelObject: modelObject,
                            model: Models.Profile(),
                            analytics: modelObject.isNil
                                ? FirebaseAnalytics(screenId: .basicSetting)
                                : FirebaseAnalytics(screenId: .basicUpdate)
                        )
                    )

                    return vc
                }
            }

            enum Project {
                static func Detail(
                    identifier: String,
                    modelObject: ProfileModelObject
                ) -> ProjectDetailViewController {
                    let vc = ProjectDetailViewController()
                    let routing = ProjectDetailRouting(viewController: vc)

                    vc.title = L10n.Navigation.Title.projectDetail
                    vc.inject(
                        contentView: .init(),
                        viewModel: .init(
                            identifier: identifier,
                            modelObject: modelObject,
                            model: Models.Profile(),
                            routing: routing,
                            analytics: FirebaseAnalytics(screenId: .projectDetail)
                        )
                    )

                    return vc
                }

                static func Update(
                    identifier: String,
                    modelObject: ProfileModelObject
                ) -> ProjectUpdateViewController {
                    let vc = ProjectUpdateViewController()

                    vc.title = modelObject.projects.contains(where: { $0.identifier == identifier })
                        ? L10n.Navigation.Title.projectUpdate
                        : L10n.Navigation.Title.projectSetting

                    vc.inject(
                        contentView: .init(
                            identifier: identifier,
                            modelObject: modelObject
                        ),
                        viewModel: .init(
                            identifier: identifier,
                            modelObject: modelObject,
                            model: Models.Profile(),
                            analytics: modelObject.projects.contains(where: { $0.identifier == identifier })
                                ? FirebaseAnalytics(screenId: .projectUpdate)
                                : FirebaseAnalytics(screenId: .projectSetting)
                        )
                    )

                    return vc
                }
            }

            enum Skill {
                static func Update(modelObject: ProfileModelObject) -> SkillUpdateViewController {
                    let vc = SkillUpdateViewController()

                    vc.title = modelObject.skill.isNil
                        ? L10n.Navigation.Title.sKillSetting
                        : L10n.Navigation.Title.skillUpdate

                    vc.inject(
                        contentView: .init(modelObject: modelObject),
                        viewModel: .init(
                            modelObject: modelObject,
                            model: Models.Profile(),
                            analytics: modelObject.skill.isNil
                                ? FirebaseAnalytics(screenId: .skillSetting)
                                : FirebaseAnalytics(screenId: .skillUpdate)
                        )
                    )

                    return vc
                }
            }
        }

        static func Icon(modelObject: ProfileModelObject) -> ProfileIconViewController {
            let vc = ProfileIconViewController()

            vc.title = L10n.Navigation.Title.profileIcon
            vc.inject(
                contentView: .init(),
                viewModel: .init(
                    model: Models.Profile(),
                    modelObject: modelObject,
                    analytics: FirebaseAnalytics(screenId: .profileIcon)
                )
            )

            return vc
        }

        static func List() -> ProfileListViewController {
            let vc = ProfileListViewController()
            let routing = ProfileListRouting(viewController: vc)

            vc.title = L10n.Navigation.Title.profileList
            vc.inject(
                contentView: .init(),
                viewModel: .init(
                    model: Models.Profile(),
                    routing: routing,
                    analytics: FirebaseAnalytics(screenId: .profileList)
                )
            )

            return vc
        }
    }

    static func Setting() -> SettingViewController {
        let vc = SettingViewController()

        vc.title = L10n.Navigation.Title.setting
        vc.inject(
            contentView: .init(),
            viewModel: .init(
                analytics: FirebaseAnalytics(screenId: .setting)
            )
        )

        return vc
    }
}

#if DEBUG
    extension AppControllers {
        enum Debug {
            static func API() -> DebugAPIViewController {
                let vc = DebugAPIViewController()

                vc.title = L10n.Navigation.Title.debugAPIResponse
                vc.inject(
                    contentView: .init(),
                    viewModel: .init()
                )

                return vc
            }

            static func Development() -> DebugDevelopmentViewController {
                let vc = DebugDevelopmentViewController()
                let routing = DebugDevelopmentRouting(viewController: vc)

                vc.title = L10n.Navigation.Title.debugDevelopment
                vc.inject(
                    contentView: .init(),
                    viewModel: .init(
                        model: DebugModel(),
                        routing: routing
                    )
                )

                return vc
            }

            enum CoreData {
                static func Create() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .create)
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: .init())
                    return vc
                }

                static func List() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .list)
                    vc.title = L10n.Navigation.Title.debugCoreDataList
                    vc.inject(contentView: .init())
                    return vc
                }

                static func Update() -> DebugCoreDataMenuViewController {
                    let vc = DebugCoreDataMenuViewController(displayType: .update)
                    vc.title = L10n.Navigation.Title.debugCoreDataUpdate
                    vc.inject(contentView: .init())
                    return vc
                }
            }

            enum CoreDataObject {
                enum List {
                    static func Memo() -> DebugMemoListViewController {
                        let vc = DebugMemoListViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Memo())
                        )

                        return vc
                    }

                    static func Profile() -> DebugProfileListViewController {
                        let vc = DebugProfileListViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Project() -> DebugProjectListViewController {
                        let vc = DebugProjectListViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Profile())
                        )

                        return vc
                    }

                    static func Skill() -> DebugSkillListViewController {
                        let vc = DebugSkillListViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Profile())
                        )

                        return vc
                    }
                }

                enum Create {
                    static func Memo() -> DebugMemoCreateViewController {
                        let vc = DebugMemoCreateViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Memo())
                        )

                        return vc
                    }

                    static func Profile() -> DebugProfileCreateViewController {
                        let vc = DebugProfileCreateViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Profile())
                        )

                        return vc
                    }
                }

                enum Update {
                    static func Memo() -> DebugMemoUpdateViewController {
                        let vc = DebugMemoUpdateViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Memo())
                        )

                        return vc
                    }

                    static func Profile() -> DebugProfileUpdateViewController {
                        let vc = DebugProfileUpdateViewController()

                        vc.inject(
                            contentView: .init(),
                            viewModel: .init(model: Models.Profile())
                        )

                        return vc
                    }
                }
            }
        }
    }
#endif
