import UIKit

final class VStackView: BaseStackView {
    init(
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = .zero,
        @StackViewBuilder builder: () -> [UIView]
    ) {
        super.init(
            axis: .vertical,
            alignment: alignment,
            distribution: distribution,
            spacing: spacing,
            layoutMargins: layoutMargins,
            arrangedSubviews: builder()
        )
    }

    init(
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        layoutMargins: UIEdgeInsets = .zero,
        @StackViewBuilder builder: () -> UIView
    ) {
        super.init(
            axis: .vertical,
            alignment: alignment,
            distribution: distribution,
            spacing: spacing,
            layoutMargins: layoutMargins,
            arrangedSubviews: [builder()]
        )
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
