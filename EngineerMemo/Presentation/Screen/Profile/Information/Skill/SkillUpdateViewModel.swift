import Combine
import Foundation

final class SkillUpdateViewModel: ViewModel {
    final class Binding: BindingObject {
        @Published var engineerCareer: SkillCareerType = .noSetting
        @Published var language: String?
        @Published var languageCareer: SkillCareerType = .noSetting
        @Published var toeic: Int?
        @Published var pr: String?
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

        var updatedObject = modelObject.skill ?? SkillModelObject(identifier: UUID().uuidString)

        // MARK: - viewWillAppear

        input.viewWillAppear.sink { _ in
            analytics.sendEvent(.screenView)
        }
        .store(in: &cancellables)

        // MARK: - エンジニア歴

        let engineerCareer = binding.$engineerCareer
            .dropFirst()
            .sink { updatedObject.engineerCareer = $0.value }

        // MARK: - 言語

        let language = binding.$language
            .dropFirst()
            .sink { updatedObject.language = $0 }

        // MARK: - 言語歴

        let languageCareer = binding.$languageCareer
            .dropFirst()
            .sink { updatedObject.languageCareer = $0.value }

        // MARK: - TOEIC

        let toeic = binding.$toeic
            .dropFirst()
            .sink { updatedObject.toeic = $0 }

        // MARK: - 自己PR

        let pr = binding.$pr
            .dropFirst()
            .sink { updatedObject.pr = $0 }

        // MARK: - 設定・更新ボタンタップ

        input.didTapBarButton.sink { [weak self] _ in
            var modelObject = modelObject
            modelObject.skill = updatedObject
            self?.insertSkill(modelObject)
            self?.output.isFinished = true
        }
        .store(in: &cancellables)

        cancellables.formUnion([
            engineerCareer,
            language,
            languageCareer,
            toeic,
            pr
        ])
    }
}

// MARK: - private methods

private extension SkillUpdateViewModel {
    func insertSkill(_ modelObject: ProfileModelObject) {
        model.insertSkill(modelObject)
            .sink { _ in }
            .store(in: &cancellables)
    }
}
