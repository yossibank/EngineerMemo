import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateSkillContentView: UIView {
    private lazy var scrollView = UIScrollView().addSubview(body) {
        $0.width.edges.equalToSuperview()
    }

    private lazy var body = VStackView(distribution: .equalSpacing, spacing: 16) {
        careerInputView
    }

    private var cancellables = Set<AnyCancellable>()

    private let careerInputView = ProfileUpdateCareerInputView()

    private let modelObject: SkillModelObject?

    init(modelObject: SkillModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
        setupEvent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ProfileUpdateSkillContentView {}

// MARK: - private methods

private extension ProfileUpdateSkillContentView {
    func setupEvent() {
        gesturePublisher().sink { [weak self] _ in
            self?.endEditing(true)
        }
        .store(in: &cancellables)
    }
}

// MARK: - protocol

extension ProfileUpdateSkillContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(scrollView) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.bottom.equalToSuperview().priority(.low)
                $0.leading.trailing.equalToSuperview()
            }

            $0.keyboardLayoutGuide.snp.makeConstraints {
                $0.top.equalTo(scrollView.snp.bottom).inset(-16)
            }

            $0.backgroundColor = .background
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileSkillUpdateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileUpdateSkillContentView(modelObject: nil))
        }
    }
#endif
