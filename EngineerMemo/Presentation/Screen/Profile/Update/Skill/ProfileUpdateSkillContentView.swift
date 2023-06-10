import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileUpdateSkillContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel().configure {
                $0.text = "Hello World!"
            }
        }
    }

    private let modelObject: SkillModelObject?

    init(modelObject: SkillModelObject?) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ProfileUpdateSkillContentView {}

// MARK: - private methods

private extension ProfileUpdateSkillContentView {}

// MARK: - protocol

extension ProfileUpdateSkillContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.edges.equalToSuperview()
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
