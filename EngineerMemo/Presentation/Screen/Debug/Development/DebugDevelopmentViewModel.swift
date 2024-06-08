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

            cancellables.formUnion([
                // MARK: - カラーテーマセグメント変更

                input.didChangeColorThemeIndex.weakSink(with: self) {
                    model.updateColorTheme($1)
                },

                // MARK: - APIセルタップ

                input.didTapAPICell.sink {
                    routing.showDebugAPIScreen()
                },

                // MARK: - CoreDataセルタップ

                input.didTapCoreDataCell.weakSink(with: self) {
                    routing.showDebugCoreDataScreen(action: $1)
                }
            ])
        }
    }
#endif
