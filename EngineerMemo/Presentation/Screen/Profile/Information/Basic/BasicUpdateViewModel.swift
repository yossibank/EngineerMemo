import Combine
import Foundation

final class BasicUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var name: String?
        @Published var birthday: Date?
        @Published var gender: ProfileGenderType = .noSetting
        @Published var email: String?
        @Published var phoneNumber: String?
        @Published var address: String?
        @Published var station: String?
    }

    final class Input: InputObject {
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinished = false
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var cancellables = Set<AnyCancellable>()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        modelObject: ProfileModelObject?,
        model: ProfileModelInput,
        analytics: FirebaseAnalyzable
    ) {
        let binding = Binding()
        let input = Input()
        let output = Output()

        self.binding = binding
        self.input = input
        self.output = output
        self.model = model
        self.analytics = analytics

        var updatedObject = modelObject ?? ProfileModelObject(identifier: UUID().uuidString)

        cancellables.formUnion([
            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - 名前

            binding.$name
                .dropFirst()
                .sink { updatedObject.name = $0 },

            // MARK: - 生年月日

            binding.$birthday
                .dropFirst()
                .sink { updatedObject.birthday = $0 },

            // MARK: - 性別

            binding.$gender
                .dropFirst()
                .sink { updatedObject.gender = $0.gender },

            // MARK: - Eメール

            binding.$email
                .dropFirst()
                .sink { updatedObject.email = $0 },

            // MARK: - 電話番号

            binding.$phoneNumber
                .dropFirst()
                .sink { updatedObject.phoneNumber = $0 },

            // MARK: - 住所

            binding.$address
                .dropFirst()
                .sink { updatedObject.address = $0 },

            // MARK: - 最寄駅

            binding.$station
                .dropFirst()
                .sink { updatedObject.station = $0 },

            // MARK: - 設定・更新ボタンタップ

            input.didTapBarButton.weakSink(with: self) {
                if modelObject.isNil {
                    $0.createBasic(updatedObject)
                } else {
                    $0.updateBasic(updatedObject)
                }

                output.isFinished = true
            }
        ])
    }
}

// MARK: - private methods

private extension BasicUpdateViewModel {
    func createBasic(_ modelObject: ProfileModelObject) {
        model.createBasic(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }

    func updateBasic(_ modelObject: ProfileModelObject) {
        model.updateBasic(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
