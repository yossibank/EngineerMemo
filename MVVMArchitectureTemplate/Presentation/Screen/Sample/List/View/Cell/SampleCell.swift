import SnapKit
import UIKit

// MARK: - properties & init

final class SampleCell: UITableViewCell {
    private lazy var mainStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
        return $0
    }(UIStackView(arrangedSubviews: [
        idLabel,
        infoStackView
    ]))

    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalCentering
        $0.spacing = 4
        return $0
    }(UIStackView(arrangedSubviews: [
        userIdLabel,
        titleLabel,
        bodyLabel
    ]))

    private let idLabel = UILabel(style: .system10)
    private let userIdLabel = UILabel(style: .system10)
    private let titleLabel = UILabel(styles: [.bold14, .line2])
    private let bodyLabel = UILabel(style: .system12)

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - internal methods

extension SampleCell {
    func configure(_ modelObject: SampleModelObject) {
        idLabel.text = "ID: \(modelObject.id.description)"
        userIdLabel.text = "UserID: \(modelObject.userId.description)"
        titleLabel.text = modelObject.title
        bodyLabel.text = modelObject.body
    }
}

// MARK: - private methods

private extension SampleCell {
    func setupViews() {
        apply(.background)
        contentView.addSubview(mainStackView)
    }

    func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        idLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct SampleCellPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: SampleCell()) {
                $0.configure(SampleModelObjectBuilder().build())
            }
        }
    }
#endif
