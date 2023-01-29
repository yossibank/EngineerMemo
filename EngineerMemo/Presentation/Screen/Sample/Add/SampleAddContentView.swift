import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - stored properties & init

final class SampleAddContentView: UIView {
    private(set) lazy var didChangeTitleTextPublisher = titleTextField.textDidChangePublisher
    private(set) lazy var didChangeBodyTextPublisher = bodyTextField.textDidChangePublisher
    private(set) lazy var didTapCreateButtonPublisher = createButton.publisher(for: .touchUpInside)

    private var cancellables: Set<AnyCancellable> = .init()

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.setCustomSpacing(16, after: userIdLabel)
        $0.setCustomSpacing(16, after: titleStackView)
        $0.setCustomSpacing(32, after: bodyStackView)
        return $0
    }(UIStackView(arrangedSubviews: [
        userIdLabel,
        titleStackView,
        bodyStackView,
        buttonStackView
    ]))

    private lazy var titleStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView(arrangedSubviews: [
        titleCountStackView,
        titleTextField,
        titleValidationLabel
    ]))

    private lazy var titleCountStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        return $0
    }(UIStackView(arrangedSubviews: [titleCountLabel]))

    private lazy var bodyStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView(arrangedSubviews: [
        bodyCountStackView,
        bodyTextField,
        bodyValidationLabel
    ]))

    private lazy var bodyCountStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .trailing
        return $0
    }(UIStackView(arrangedSubviews: [bodyCountLabel]))

    private lazy var buttonStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [createButton]))

    private let userIdLabel = UILabel(
        style: .italicSystemFont(size: 16)
    )

    private let titleCountLabel = UILabel(
        style: .systemFont(size: 10)
    )

    private let titleTextField = UITextField(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .borderStyle(.roundedRect),
            .clipsToBounds(true),
            .cornerRadius(8),
            .placeholder("タイトル")
        ]
    )

    private let titleValidationLabel = UILabel(
        styles: [
            .systemFont(size: 10),
            .textColor(.red)
        ]
    )

    private let bodyCountLabel = UILabel(
        style: .systemFont(size: 10)
    )

    private let bodyTextField = UITextField(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .borderStyle(.roundedRect),
            .clipsToBounds(true),
            .cornerRadius(8),
            .placeholder("内容")
        ]
    )

    private let bodyValidationLabel = UILabel(
        styles: [
            .systemFont(size: 10),
            .textColor(.red)
        ]
    )

    private let createButton = UIButton(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(8),
            .setTitle("作成する"),
            .setTitleColor(.theme),
            .systemFont(size: 15)
        ]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupInitialize()
        setupConfigure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleTextField, bodyTextField].forEach {
                $0.apply(.borderColor(.theme))
            }

            createButton.layer.borderColor = enableColor(isEnabled: createButton.isEnabled).cgColor
        }
    }
}

// MARK: - internal methods

extension SampleAddContentView {
    func validation(type: ValidationType) {
        switch type {
        case let .title(error):
            titleValidationLabel.text = error.description

        case let .body(error):
            bodyValidationLabel.text = error.description
        }
    }

    func buttonEnabled(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.layer.borderColor = enableColor(isEnabled: isEnabled).cgColor
        createButton.setTitleColor(enableColor(isEnabled: isEnabled), for: .normal)
    }
}

// MARK: - private methods

private extension SampleAddContentView {
    func setupInitialize() {
        userIdLabel.text = "UserID: MyユーザーID"

        [titleCountLabel, bodyCountLabel].forEach {
            $0.text = "入力文字数: 0"
        }
    }

    func setupConfigure() {
        didChangeTitleTextPublisher
            .receive(on: DispatchQueue.main)
            .map(\.count)
            .sink { [weak self] count in
                self?.titleCountLabel.text = "入力文字数: \(count)"
            }
            .store(in: &cancellables)

        didChangeBodyTextPublisher
            .receive(on: DispatchQueue.main)
            .map(\.count)
            .sink { [weak self] count in
                self?.bodyCountLabel.text = "入力文字数: \(count)"
            }
            .store(in: &cancellables)
    }

    func enableColor(isEnabled: Bool) -> UIColor {
        isEnabled ? .theme : .theme.withAlphaComponent(0.3)
    }
}

// MARK: - protocol

extension SampleAddContentView: ContentView {
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

        [titleStackView, bodyStackView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(96)
            }
        }

        [titleTextField, bodyTextField].forEach {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(48)
            }
        }

        createButton.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(56)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SampleAddContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: SampleAddContentView()
            )
        }
    }
#endif
