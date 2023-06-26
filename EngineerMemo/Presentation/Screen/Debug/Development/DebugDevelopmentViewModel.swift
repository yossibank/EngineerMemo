#if DEBUG
    import Combine
    import UIKit

    final class DebugDevelopmentViewModel: ViewModel {
        final class Input: InputObject {
            let didChangeColorThemeIndex = PassthroughSubject<Int, Never>()
            let didTapAPICell = PassthroughSubject<Void, Never>()
            let didTapCoreDataCell = PassthroughSubject<DebugCoreDataAction, Never>()
        }

        let input: Input
        let output = NoOutput()
        let binding = NoBinding()

        private var cancellables = Set<AnyCancellable>()

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

            input.didChangeColorThemeIndex.sink {
                model.updateColorTheme($0)
            }
            .store(in: &cancellables)

            // MARK: - APIセルタップ

            input.didTapAPICell.sink { _ in
                routing.showDebugAPIScreen()
            }
            .store(in: &cancellables)

            // MARK: - CoreDataセルタップ

            input.didTapCoreDataCell.sink {
                routing.showDebugCoreDataScreen(action: $0)
            }
            .store(in: &cancellables)
        }
    }
#endif
