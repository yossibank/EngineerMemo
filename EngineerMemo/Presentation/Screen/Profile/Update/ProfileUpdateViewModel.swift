import Combine
import Foundation

final class ProfileUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var name: String?
        @Published var birthday: Date?
        @Published var gender: ProfileMenuGenderType = .none
        @Published var email: String?
        @Published var phoneNumber: String?
        @Published var address: String?
        @Published var station: String?
    }

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapSaveButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinished: Bool?
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var modelObject = ProfileModelObject(identifier: UUID().uuidString)
    private var cancellables: Set<AnyCancellable> = .init()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        modelObject: ProfileModelObject?,
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

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { [weak self] _ in
            if let modelObject {
                self?.modelObject = modelObject
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
            .sink { [weak self] name in
                self?.modelObject.name = name
            }

        // MARK: - 生年月日

        let birthday = binding.$birthday
            .dropFirst()
            .sink { [weak self] birthday in
                self?.modelObject.birthday = birthday
            }

        // MARK: - 性別

        let gender = binding.$gender
            .dropFirst()
            .sink { [weak self] type in
                self?.modelObject.gender = type.gender
            }

        // MARK: - Eメール

        let email = binding.$email
            .dropFirst()
            .sink { [weak self] email in
                self?.modelObject.email = email
            }

        // MARK: - 電話番号

        let phoneNumber = binding.$phoneNumber
            .dropFirst()
            .sink { [weak self] phoneNumber in
                self?.modelObject.phoneNumber = phoneNumber
            }

        // MARK: - 住所

        let address = binding.$address
            .dropFirst()
            .sink { [weak self] address in
                self?.modelObject.address = address
            }

        // MARK: - 最寄駅

        let station = binding.$station
            .dropFirst()
            .sink { [weak self] station in
                self?.modelObject.station = station
            }

        // MARK: - 更新・保存ボタンタップ

        input.didTapSaveButton.sink { [weak self] _ in
            guard let self else {
                return
            }

            if modelObject == nil {
                self.model.create(modelObject: self.modelObject)
            } else {
                self.model.update(modelObject: self.modelObject)
            }

            self.output.isFinished = true
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
