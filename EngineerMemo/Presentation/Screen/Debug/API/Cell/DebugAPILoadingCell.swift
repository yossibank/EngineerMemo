import Combine
import UIKit

// MARK: - properties & init

final class DebugAPILoadingCell: UITableViewCell {
    private var body: UIView {
        VStackView(alignment: .center, spacing: 16) {
            loading.configure {
                $0.startAnimating()
            }

            UILabel().configure {
                $0.text = L10n.Debug.Api.loading
                $0.textColor = .primary
                $0.font = .boldSystemFont(ofSize: 12)
            }
        }
    }

    private let loading = UIActivityIndicatorView()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension DebugAPILoadingCell {
    func configure(with isLoading: Bool) {
        if isLoading {
            loading.startAnimating()
        } else {
            loading.stopAnimating()
        }
    }
}

// MARK: - private methods

private extension DebugAPILoadingCell {
    func setupView() {
        contentView.configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(16)
                $0.horizontalEdges.equalToSuperview().inset(8)
            }

            $0.backgroundColor = .background
            $0.isUserInteractionEnabled = false
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct DebugAPILoadingCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugAPILoadingCell())
        }
    }
#endif
