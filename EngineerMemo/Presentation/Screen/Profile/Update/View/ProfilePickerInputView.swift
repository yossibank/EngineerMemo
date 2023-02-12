import Combine
import SnapKit
import UIKit
import UIStyle

// MARK: - properties & init

final class ProfilePickerInputView: UIView {
    private(set) lazy var inputPublisher = inputDatePicker.publisher

    private lazy var stackView = UIStackView(
        styles: [
            .addArrangedSubviews(arrangedSubviews),
            .axis(.vertical)
        ]
    )

    private lazy var arrangedSubviews = [
        titleView,
        pickerInputView
    ]

    private lazy var titleView = UIView(
        styles: [
            .addSubview(titleLabel),
            .backgroundColor(.thinGray),
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .cornerRadius(4)
        ]
    )

    private lazy var pickerInputView = UIView(
        styles: [
            .addSubviews([inputDatePicker, pickerLabel]),
            .backgroundColor(.primary)
        ]
    )

    private let titleLabel = UILabel(
        styles: [
            .boldSystemFont(size: 16),
            .textColor(.secondary)
        ]
    )

    private let inputDatePicker = UIDatePicker(
        styles: [
            .borderColor(.theme),
            .borderWidth(1.0),
            .clipsToBounds(true),
            .contentHorizontalAlignment(.leading),
            .cornerRadius(4),
            .datePickerMode(.date),
            .locale(.japan),
            .preferredDatePickerStyle(.compact)
        ]
    )

    private let pickerLabel = UILabel(
        style: .text(.noSetting)
    )

    private var cancellables: Set<AnyCancellable> = .init()

    init(title: String) {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
        setupPicker()

        titleLabel.apply(.text(title))
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
                $0.apply(.borderColor(.theme))
            }
        }
    }
}

// MARK: - internal methods

extension ProfilePickerInputView {
    func updateValue(modelObject: ProfileModelObject?) {
        guard
            let modelObject,
            let birthday = modelObject.birthday
        else {
            return
        }

        pickerLabel.apply(.text(birthday.toString))
    }
}

// MARK: - private methods

private extension ProfilePickerInputView {
    func setupViews() {
        apply([
            .addSubview(stackView),
            .backgroundColor(.primary)
        ])
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        titleView.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        pickerInputView.snp.makeConstraints {
            $0.height.equalTo(80)
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
        inputDatePicker.expandPickerRange()
        inputDatePicker.publisher
            .sink { [weak self] birthday in
                self?.pickerLabel.text = birthday.toString
            }
            .store(in: &cancellables)
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProfilePickerInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: ProfilePickerInputView(
                    title: "title"
                )
            )
        }
    }
#endif
