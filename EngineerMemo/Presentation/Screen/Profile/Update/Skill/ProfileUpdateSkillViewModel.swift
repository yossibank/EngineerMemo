import Combine
import Foundation

final class ProfileUpdateSkillViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var engineerCareer: SkillCareerType = .noSetting
        @Published var language: String?
        @Published var languageCareer: SkillCareerType = .noSetting
        @Published var toeic: Int?
    }

    final class Input: InputObject {
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let viewWillAppear = PassthroughSubject<Void, Never>()
        let didTapBarButton = PassthroughSubject<Void, Never>()
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var modelObject: SkillModelObject?
        @Published fileprivate(set) var isFinished = false
    }

    @BindableObject private(set) var binding: Binding

    let input: Input
    let output: Output

    private var cancellables = Set<AnyCancellable>()

    private let model: ProfileModelInput
    private let analytics: FirebaseAnalyzable

    init(
        model: ProfileModelInput,
        modelObject: ProfileModelObject,
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

        var updateObject = modelObject.skill ?? SkillModelObject(identifier: UUID().uuidString)

        // MARK: - viewDidLoad

        input.viewDidLoad.sink { _ in
            if let modelObject = modelObject.skill {
                output.modelObject = modelObject
            }
        }
        .store(in: &cancellables)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - エンジニア歴

        let engineerCareer = binding.$engineerCareer
            .dropFirst()
            .sink { engineerCareer in
                updateObject.engineerCareer = engineerCareer.value
            }

        // MARK: - 言語

        let language = binding.$language
            .dropFirst()
            .sink { language in
                updateObject.language = language
            }

        // MARK: - 言語歴

        let languageCareer = binding.$languageCareer
            .dropFirst()
            .sink { languageCareer in
                updateObject.languageCareer = languageCareer.value
            }

        // MARK: - TOEIC

        let toeic = binding.$toeic
            .dropFirst()
            .sink { toeic in
                updateObject.toeic = toeic
            }

        // MARK: - 更新・保存ボタンタップ

        input.didTapBarButton.sink { _ in
            var modelObject = modelObject
            modelObject.skill = updateObject
            model.skillUpdate(modelObject: modelObject)
            output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            engineerCareer,
            language,
            languageCareer,
            toeic
        ])
    }
}
