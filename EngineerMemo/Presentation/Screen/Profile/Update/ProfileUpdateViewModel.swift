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
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let saveButtonTapped = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var isFinish: Bool?
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

        // MARK: - 名前

        let name = binding.$name.sink { [weak self] name in
            self?.modelObject.name = name
        }

        // MARK: - 生年月日

        let birthday = binding.$birthday.sink { [weak self] birthday in
            self?.modelObject.birthday = birthday
        }

        // MARK: - 性別

        let gender = binding.$gender.sink { [weak self] type in
            self?.modelObject.gender = type.gender
        }

        // MARK: - Eメール

        let email = binding.$email.sink { [weak self] email in
            self?.modelObject.email = email
        }

        // MARK: - 電話番号

        let phoneNumber = binding.$phoneNumber.sink { [weak self] phoneNumber in
            self?.modelObject.phoneNumber = phoneNumber
        }

        // MARK: - 住所

        let address = binding.$address.sink { [weak self] address in
            self?.modelObject.address = address
        }

        // MARK: - 最寄駅

        let station = binding.$station.sink { [weak self] station in
            self?.modelObject.station = station
        }

        // MARK: - viewWillAppear

        input.viewWillAppear
            .sink { _ in
                analytics.sendEvent(.screenView)
            }
            .store(in: &cancellables)

        // MARK: - 作成ボタンタップ

        input.saveButtonTapped
            .sink { [weak self] _ in
                guard let self else {
                    return
                }

                self.model.create(modelObject: self.modelObject)
                self.output.isFinish = true
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
