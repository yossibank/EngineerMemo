import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - stored properties & init

final class SampleDetailContentView: UIView {
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 28
        return $0
    }(UIStackView(arrangedSubviews: [
        idLabel,
        userIdLabel,
        titleLabel,
        bodyLabel
    ]))

    private let userIdLabel = UILabel(
        styles: [
            .boldSystemFont(size: 14),
            .textColor(.red)
        ]
    )

    private let idLabel = UILabel(
        styles: [
            .systemFont(size: 12),
            .textColor(.thinGray)
        ]
    )

    private let titleLabel = UILabel(
        styles: [
            .numberOfLines(0),
            .systemFont(size: 18, weight: .heavy)
        ]
    )

    private let bodyLabel = UILabel(
        styles: [
            .italicSystemFont(size: 16),
            .numberOfLines(0),
            .textColor(.thinGray)
        ]
    )

    private let modelObject: SampleModelObject

    init(modelObject: SampleModelObject) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        setupConfigure(modelObject: modelObject)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private methods

private extension SampleDetailContentView {
    func setupConfigure(modelObject: SampleModelObject) {
        userIdLabel.text = "UserID: \(modelObject.userId)"
        idLabel.text = "ID: \(modelObject.id)"
        titleLabel.text = modelObject.title
        bodyLabel.text = modelObject.body
    }
}

// MARK: - protocol

extension SampleDetailContentView: ContentView {
    func setupViews() {
        apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SampleDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: SampleDetailContentView(
                    modelObject: SampleModelObjectBuilder().build()
                )
            )
        }
    }
#endif
