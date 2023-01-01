import SwiftUI

enum AppControllers {
    enum Sample {
        static func Add() -> SampleAddViewController {
            let viewController = SampleAddViewController()

            viewController.title = "サンプル作成"
            viewController.inject(
                contentView: ContentViews.Sample.Add(),
                viewModel: ViewModels.Sample.Add()
            )

            return viewController
        }

        static func Detail(_ modelObject: SampleModelObject) -> SampleDetailViewController {
            let viewController = SampleDetailViewController()
            let routing = SampleDetailRouting(viewController: viewController)

            viewController.title = "サンプル詳細"
            viewController.inject(
                contentView: ContentViews.Sample.Detail(modelObject: modelObject),
                viewModel: ViewModels.Sample.Detail(
                    modelObject: modelObject,
                    routing: routing
                )
            )

            return viewController
        }

        static func Edit(_ modelObject: SampleModelObject) -> SampleEditViewController {
            let viewController = SampleEditViewController()

            viewController.title = "サンプル編集"
            viewController.inject(
                contentView: ContentViews.Sample.Edit(modelObject: modelObject),
                viewModel: ViewModels.Sample.Edit(modelObject: modelObject)
            )

            return viewController
        }

        static func List() -> SampleListViewController {
            let viewController = SampleListViewController()
            let routing = SampleListRouting(viewController: viewController)

            viewController.title = "サンプル一覧"
            viewController.inject(
                contentView: ContentViews.Sample.List(),
                viewModel: ViewModels.Sample.List(routing: routing)
            )

            return viewController
        }
    }
}
