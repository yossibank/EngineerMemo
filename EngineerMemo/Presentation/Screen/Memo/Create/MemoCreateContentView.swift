import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoCreateContentView: UIView {
    private(set) lazy var didChangeTitleTextPublisher = titleTextView.textDidChangePublisher
    private(set) lazy var didChangeContentTextPublisher = contentTextView.textDidChangePublisher
    private(set) lazy var didTapBarButtonPublisher = barButton.publisher(for: .touchUpInside)

    private(set) lazy var barButton = UIButton(type: .system).addConstraint {
        $0.width.equalTo(72)
        $0.height.equalTo(32)
    }

    private var cancellables: Set<AnyCancellable> = .init()

    private var body: UIView {
        VStackView(spacing: 16) {
            VStackView(spacing: 8) {
                titleView
                    .addSubview(titleLabel) {
                        $0.edges.equalToSuperview().inset(8)
                    }
                    .addConstraint {
                        $0.height.equalTo(40)
                    }
                    .apply(.inputView)

                VStackView(spacing: 4) {
                    titleTextView
                        .addConstraint {
                            $0.height.equalTo(48)
                        }
                        .configure {
                            $0.font = .boldSystemFont(ofSize: 16)
                            $0.layer.borderColor = UIColor.theme.cgColor
                            $0.layer.borderWidth = 1.0
                            $0.layer.cornerRadius = 4
                        }
                }
            }

            VStackView(spacing: 8) {
                contentView
                    .addSubview(contentLabel) {
                        $0.edges.equalToSuperview().inset(8)
                    }
                    .addConstraint {
                        $0.height.equalTo(40)
                    }
                    .apply(.inputView)

                VStackView(spacing: 4) {
                    contentTextView
                        .addConstraint {
                            $0.height.equalTo(120)
                        }
                        .configure {
                            $0.font = .boldSystemFont(ofSize: 14)
                            $0.layer.borderColor = UIColor.theme.cgColor
                            $0.layer.borderWidth = 1.0
                            $0.layer.cornerRadius = 4
                        }
                }
            }
        }
    }

    private let titleView = UIView()
    private let titleTextView = UITextView()
    private let titleLabel = UILabel().configure {
        $0.text = L10n.Memo.title
        $0.textColor = .secondary
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let contentView = UIView()
    private let contentTextView = UITextView()
    private let contentLabel = UILabel().configure {
        $0.text = L10n.Memo.content
        $0.textColor = .secondary
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let createButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupBarButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            super.traitCollectionDidChange(previousTraitCollection)

            [titleView, titleTextView, contentView, contentTextView, barButton].forEach {
                $0.layer.borderColor = UIColor.theme.cgColor
            }
        }
    }
}

// MARK: - private methods

private extension MemoCreateContentView {
    func setupBarButton() {
        barButton.apply(.createNavigationButton)

        barButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.barButton.apply(.createDoneNavigationButton)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self?.barButton.apply(.createNavigationButton)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - protocol

extension MemoCreateContentView: ContentView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                $0.leading.trailing.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .primary
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoCreateContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: MemoCreateContentView())
        }
    }
#endif
