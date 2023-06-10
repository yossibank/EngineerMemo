import Combine
import Foundation

final class ProfileUpdateBasicViewModel: ViewModel {
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
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: ProfileModelObject?
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

        var updateObject = ProfileModelObject(identifier: UUID().uuidString)

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { _ in
            if let modelObject {
                updateObject = modelObject
                output.modelObject = modelObject
            }
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - 名前

        let name = binding.$name
            .dropFirst()
            .sink { name in
                updateObject.name = name
            }

        // MARK: - 生年月日

        let birthday = binding.$birthday
            .dropFirst()
            .sink { birthday in
                updateObject.birthday = birthday
            }

        // MARK: - 性別

        let gender = binding.$gender
            .dropFirst()
            .sink { type in
                updateObject.gender = type.gender
            }

        // MARK: - Eメール

        let email = binding.$email
            .dropFirst()
            .sink { email in
                updateObject.email = email
            }

        // MARK: - 電話番号

        let phoneNumber = binding.$phoneNumber
            .dropFirst()
            .sink { phoneNumber in
                updateObject.phoneNumber = phoneNumber
            }

        // MARK: - 住所

        let address = binding.$address
            .dropFirst()
            .sink { address in
                updateObject.address = address
            }

        // MARK: - 最寄駅

        let station = binding.$station
            .dropFirst()
            .sink { station in
                updateObject.station = station
            }

        // MARK: - 設定・更新ボタンタップ

        input.didTapBarButton.sink { _ in
            if modelObject == nil {
                model.create(modelObject: updateObject)
            } else {
                model.basicUpdate(modelObject: updateObject)
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
