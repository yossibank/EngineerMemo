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

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 名前

        let name = binding.$name
            .dropFirst()
            .sink { updatedObject.name = $0 }

        // MARK: - 生年月日

        let birthday = binding.$birthday
            .dropFirst()
            .sink { updatedObject.birthday = $0 }

        // MARK: - 性別

        let gender = binding.$gender
            .dropFirst()
            .sink { updatedObject.gender = $0.gender }

        // MARK: - Eメール

        let email = binding.$email
            .dropFirst()
            .sink { updatedObject.email = $0 }

        // MARK: - 電話番号

        let phoneNumber = binding.$phoneNumber
            .dropFirst()
            .sink { updatedObject.phoneNumber = $0 }

        // MARK: - 住所

        let address = binding.$address
            .dropFirst()
            .sink { updatedObject.address = $0 }

        // MARK: - 最寄駅

        let station = binding.$station
            .dropFirst()
            .sink { updatedObject.station = $0 }

        // MARK: - 設定・更新ボタンタップ

        input.didTapBarButton.sink { [weak self] _ in
            if modelObject.isNil {
                self?.createBasic(updatedObject)
            } else {
                self?.updateBasic(updatedObject)
            }

            output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            name,
            birthday,
            gender,
            email,
            phoneNumber,
            address,
            station
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
