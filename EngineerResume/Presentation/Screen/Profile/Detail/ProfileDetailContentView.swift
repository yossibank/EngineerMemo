import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class ProfileDetailContentView: UIView {
    var modelObject: ProfileModelObject? {
        didSet {
            configure(modelObject: modelObject)
        }
    }

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        return $0
    }(UIStackView(arrangedSubviews: [
        nameLabel,
        ageLabel
    ]))

    private let nameLabel = UILabel(styles: [.bold14])
    private let ageLabel = UILabel(styles: [.system10])

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension ProfileDetailContentView {
    func configure(modelObject: ProfileModelObject?) {
        nameLabel.text = modelObject?.name ?? "未設定"
        ageLabel.text = modelObject?.age.description ?? "未設定"
    }
}

// MARK: - protocol

extension ProfileDetailContentView: ContentView {
    func setupViews() {
        apply(.background)
        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfileDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfileDetailContentView()) { view in
                view.configure(
                    modelObject: ProfileModelObjectBuilder().build()
                )
            }
        }
    }
#endif
