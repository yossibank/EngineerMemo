#if DEBUG
    import Combine
    import SwiftUI
    import UIKit
    import UIKitHelper

    // MARK: - properties & init

    final class DebugAPIContentView: UIView {
        private var cancellables: Set<AnyCancellable> = .init()

        private var body: UIView {
            VStackView(alignment: .center) {
                button.configure {
                    $0.setTitle("送信", for: .normal)
                }

                textView
                    .addConstraint {
                        $0.width.equalTo(UIScreen.main.bounds.width)
                        $0.height.equalTo(600)
                    }
                    .configure {
                        $0.font = .boldSystemFont(ofSize: 14)
                    }
            }
        }

        private let button = UIButton(type: .system)
        private let textView = UITextView()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setupView()
            setupEvent()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // MARK: - private methods

    private extension DebugAPIContentView {
        func setupEvent() {
            button.publisher(for: .touchUpInside).sink { _ in
                APIClient().request(
                    item: DebugGetRequest(
                        parameters: .init(userId: nil)
                    )
                ) { [weak self] result in
                    switch result {
                    case let .success(response):
                        let encoder: JSONEncoder = {
                            $0.outputFormatting = .prettyPrinted
                            return $0
                        }(JSONEncoder())

                        if let data = try? encoder.encode(response),
                           let json = String(data: data, encoding: .utf8) {
                            DispatchQueue.main.async {
                                self?.textView.text = json
                            }
                        }

                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
            .store(in: &cancellables)
        }
    }

    // MARK: - protocol

    extension DebugAPIContentView: ContentView {
        func setupView() {
            configure {
                $0.addSubview(body) {
                    $0.edges.equalToSuperview()
                }

                $0.backgroundColor = .primary
            }
        }
    }

    // MARK: - preview

    struct DebugAPIContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: DebugAPIContentView())
        }
    }
#endif
