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
        modelObject: ProfileModelObject,
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

        var updateObject = modelObject.skillModelObject ?? SkillModelObject(identifier: UUID().uuidString)

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

        // MARK: - 設定・更新ボタンタップ

        input.didTapBarButton.sink { [weak self] _ in
            if modelObject.skillModelObject.isNil {
                var modelObject = modelObject
                modelObject.skillModelObject = updateObject
                self?.createSkill(modelObject: modelObject)
            } else {
                var modelObject = modelObject
                modelObject.skillModelObject = updateObject
                self?.updateSkill(modelObject: modelObject)
            }

            self?.output.isFinished = true
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

// MARK: - private methods

private extension ProfileUpdateSkillViewModel {
    func createSkill(modelObject: ProfileModelObject) {
        model.createSkill(modelObject: modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }

    func updateSkill(modelObject: ProfileModelObject) {
        model.updateSkill(modelObject: modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
