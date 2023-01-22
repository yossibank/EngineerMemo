import Combine
import SnapKit
import UIKit

// MARK: - stored properties & init

final class ProfilePickerInputView: UIView {
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [
        titleView,
        inputPickerView
    ]))

    private lazy var titleView: UIView = {
        $0.addSubview(titleLabel)
        return $0
    }(UIView(
        styles: [
            .backgroundLightGray,
            .borderPrimary,
            .cornerRadius4
        ]
    ))

    private lazy var inputPickerView: UIView = {
        $0.addSubview(inputDatePicker)
        $0.addSubview(pickerLabel)
        return $0
    }(UIView(style: .backgroundPrimary))

    private let titleLabel = UILabel(
        styles: [
            .bold16,
            .textSecondary
        ]
    )

    private let inputDatePicker: UIDatePicker = {
        $0.locale = .japan
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.contentHorizontalAlignment = .leading
        $0.expandPickerRange()
        return $0
    }(UIDatePicker(
        styles: [
            .borderPrimary,
            .cornerRadius4
        ]
    ))

    private let pickerLabel = UILabel(
        style: .LabelTitle.profileNoSetting
    )

    private var cancellables: Set<AnyCancellable> = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
        setupPicker()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: inputDatePicker)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, inputDatePicker].forEach {
                $0.apply(.borderPrimary)
            }
        }
    }
}

// MARK: - internal methods

extension ProfilePickerInputView {
    func configure(title: String) {
        titleLabel.text = title
    }
}

// MARK: - private methods

private extension ProfilePickerInputView {
    func setupViews() {
        apply(.backgroundPrimary)
        addSubview(stackView)
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        titleView.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        inputPickerView.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        inputDatePicker.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }

        pickerLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview()
        }
    }

    func setupPicker() {
        inputDatePicker.publisher
            .sink { [weak self] date in
                self?.pickerLabel.text = date.toString
            }
            .store(in: &cancellables)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfilePickerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProfilePickerInputView()) {
                $0.configure(title: "title")
            }
        }
    }
#endif
