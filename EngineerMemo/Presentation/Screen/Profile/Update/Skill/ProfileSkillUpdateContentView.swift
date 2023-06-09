import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class ProfileSkillUpdateContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel().configure {
                $0.text = "Hello World!"
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ProfileSkillUpdateContentView {}

// MARK: - private methods

private extension ProfileSkillUpdateContentView {}

// MARK: - protocol

extension ProfileSkillUpdateContentView: ContentView {
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
            WrapperView(view: ProfileSkillUpdateContentView())
        }
    }
#endif