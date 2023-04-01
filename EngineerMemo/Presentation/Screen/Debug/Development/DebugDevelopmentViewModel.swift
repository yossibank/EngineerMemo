#if DEBUG
    import Combine
    import UIKit

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeColorThemeIndex = PassthroughSubject<Int, Never>()
            let didTapCoreDataCell = PassthroughSubject<DebugCoreDataAction, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables: Set<AnyCancellable> = .init()

        private let model: DebugModelInput
        private let routing: DebugDevelopmentRoutingInput

        init(
            model: DebugModelInput,
            routing: DebugDevelopmentRoutingInput
        ) {
            self.input = Input()
            self.model = model
            self.routing = routing

            // MARK: - カラーテーマセグメント変更

            input.didChangeColorThemeIndex.sink { index in
                model.updateColorTheme(index)
            }
            .store(in: &cancellables)

            // MARK: - CoreDataセルタップ

            input.didTapCoreDataCell.sink { action in
                routing.showDebugCoreDataScreen(action: action)
            }
            .store(in: &cancellables)
        }
    }
#endif
