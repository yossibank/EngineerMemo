import SwiftUI

enum AppControllers {
    enum Profile {
        static func Detail() -> ProfileDetailViewController {
            let vc = ProfileDetailViewController()

            vc.title = L10n.Navigation.Title.profileDetail
            vc.inject(
                contentView: ContentViews.Profile.Detail(),
                viewModel: ViewModels.Profile.Detail()
            )

            return vc
        }
    }

    enum Sample {
        static func Add() -> SampleAddViewController {
            let vc = SampleAddViewController()

            vc.title = "サンプル作成"
            vc.inject(
                contentView: ContentViews.Sample.Add(),
                viewModel: ViewModels.Sample.Add()
            )

            return vc
        }

        static func Detail(_ modelObject: SampleModelObject) -> SampleDetailViewController {
            let vc = SampleDetailViewController()
            let routing = SampleDetailRouting(viewController: vc)

            vc.title = "サンプル詳細"
            vc.inject(
                contentView: ContentViews.Sample.Detail(modelObject: modelObject),
                viewModel: ViewModels.Sample.Detail(
                    modelObject: modelObject,
                    routing: routing
                )
            )

            return vc
        }

        static func Edit(_ modelObject: SampleModelObject) -> SampleEditViewController {
            let vc = SampleEditViewController()

            vc.title = "サンプル編集"
            vc.inject(
                contentView: ContentViews.Sample.Edit(modelObject: modelObject),
                viewModel: ViewModels.Sample.Edit(modelObject: modelObject)
            )

            return vc
        }

        static func List() -> SampleListViewController {
            let vc = SampleListViewController()
            let routing = SampleListRouting(viewController: vc)

            vc.title = "サンプル一覧"
            vc.inject(
                contentView: ContentViews.Sample.List(),
                viewModel: ViewModels.Sample.List(routing: routing)
            )

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
                static func List() -> DebugCoreDataListViewController {
                    let vc = DebugCoreDataListViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataList
                    vc.inject(contentView: ContentViews.Debug.CoreData.List())
                    return vc
                }

                static func Create() -> DebugCoreDataCreateViewController {
                    let vc = DebugCoreDataCreateViewController()
                    vc.title = L10n.Navigation.Title.debugCoreDataCreate
                    vc.inject(contentView: ContentViews.Debug.CoreData.Create())
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
