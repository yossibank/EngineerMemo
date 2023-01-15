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

            static func CoreData() -> DebugCoreDataViewController {
                let vc = DebugCoreDataViewController()

                vc.title = L10n.Navigation.Title.debugCoreData
                vc.inject(
                    contentView: ContentViews.Debug.CoreData(),
                    viewModel: ViewModels.Debug.CoreData()
                )

                return vc
            }
        }
    #endif
}
