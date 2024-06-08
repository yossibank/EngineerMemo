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

        cancellables.formUnion([
            // MARK: - viewWillAppear

            input.viewWillAppear.sink {
                analytics.sendEvent(.screenView)
            },

            // MARK: - エンジニア歴

            binding.$engineerCareer
                .dropFirst()
                .sink { updatedObject.engineerCareer = $0.value },

            // MARK: - 言語

            binding.$language
                .dropFirst()
                .sink { updatedObject.language = $0 },

            // MARK: - 言語歴

            binding.$languageCareer
                .dropFirst()
                .sink { updatedObject.languageCareer = $0.value },

            // MARK: - TOEIC

            binding.$toeic
                .dropFirst()
                .sink { updatedObject.toeic = $0 },

            // MARK: - 自己PR

            binding.$pr
                .dropFirst()
                .sink { updatedObject.pr = $0 },

            // MARK: - 設定・更新ボタンタップ

            input.didTapBarButton.weakSink(with: self) {
                var modelObject = modelObject
                modelObject.skill = updatedObject
                $0.insertSkill(modelObject)
                $0.output.isFinished = true
            }
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
