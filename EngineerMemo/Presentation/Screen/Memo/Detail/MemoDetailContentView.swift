import Combine
import UIKit
import UIKitHelper

// MARK: - properties & init

final class MemoDetailContentView: UIView {
    private var body: UIView {
        VStackView(alignment: .center) {
            UILabel().configure {
                $0.text = modelObject.title
            }

            UILabel().configure {
                $0.text = modelObject.content
            }
        }
    }

    private let modelObject: MemoModelObject

    init(modelObject: MemoModelObject) {
        self.modelObject = modelObject

        super.init(frame: .zero)

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - internal methods

extension MemoDetailContentView {}

// MARK: - private methods

private extension MemoDetailContentView {}

// MARK: - protocol

extension MemoDetailContentView: ContentView {
    func setupView() {
        configure {
            $0.backgroundColor = .primary
        }

        addSubview(body) {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct MemoDetailContentViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(
                view: MemoDetailContentView(
                    modelObject: MemoModelObjectBuilder().build()
                )
            )
        }
    }
#endif
