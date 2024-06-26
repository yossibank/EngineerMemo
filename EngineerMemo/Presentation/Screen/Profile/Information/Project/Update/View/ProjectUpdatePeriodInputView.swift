import Combine
import UIKit

// MARK: - properties & init

final class ProjectUpdatePeriodInputView: UIView {
    private(set) lazy var didChangeStartDatePublisher = startDatePicker.publisher
    private(set) lazy var didChangeEndDatePublisher = endDatePicker.publisher

    private var body: UIView {
        VStackView(spacing: 8) {
            UpdateTitleView().configure {
                $0.setTitle(
                    title: L10n.Project.period,
                    icon: Asset.projectPeriod.image
                )
            }

            HStackView(distribution: .equalCentering) {
                VStackView(spacing: 4) {
                    UIView()
                        .addSubview(startDatePicker) {
                            $0.edges.equalToSuperview()
                        }
                        .addSubview(startPickerLabel) {
                            $0.edges.equalToSuperview()
                        }
                        .addConstraint {
                            $0.height.equalTo(40)
                        }

                    startBorderView
                }
                .addConstraint {
                    $0.width.greaterThanOrEqualTo(140)
                }

                UILabel().configure {
                    $0.text = "〜"
                    $0.textAlignment = .center
                }

                VStackView(spacing: 4) {
                    UIView()
                        .addSubview(endDatePicker) {
                            $0.edges.equalToSuperview()
                        }
                        .addSubview(endPickerLabel) {
                            $0.edges.equalToSuperview()
                        }
                        .addConstraint {
                            $0.height.equalTo(40)
                        }

                    endBorderView
                }
                .addConstraint {
                    $0.width.greaterThanOrEqualTo(140)
                }
            }
        }
    }

    private let startDatePicker = UIDatePicker().configure {
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.locale = .japan
        $0.preferredDatePickerStyle = .compact
    }

    private let endDatePicker = UIDatePicker().configure {
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.locale = .japan
        $0.preferredDatePickerStyle = .compact
    }

    private let startPickerLabel = UILabel().configure {
        $0.text = .noSetting
        $0.textAlignment = .center
    }

    private let endPickerLabel = UILabel().configure {
        $0.text = .noSetting
        $0.textAlignment = .center
    }

    private let startBorderView = BorderView()
    private let endBorderView = BorderView()

    private var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupPicker()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - override methods

extension ProjectUpdatePeriodInputView {
    override func layoutSubviews() {
        super.layoutSubviews()

        UIDatePicker.makeTransparent(view: startDatePicker)
        UIDatePicker.makeTransparent(view: endDatePicker)
    }
}

// MARK: - internal methods

extension ProjectUpdatePeriodInputView {
    func setProjectValue(_ modelObject: ProjectModelObject?) {
        guard let modelObject else {
            return
        }

        if let startDate = modelObject.startDate {
            startPickerLabel.text = startDate.toString
        }

        if let endDate = modelObject.endDate {
            endPickerLabel.text = endDate.toString
        }
    }
}

// MARK: - private methods

private extension ProjectUpdatePeriodInputView {
    func setupView() {
        configure {
            $0.addSubview(body) {
                $0.verticalEdges.equalToSuperview().inset(8)
                $0.horizontalEdges.equalToSuperview().inset(16)
            }

            $0.backgroundColor = .background
        }
    }

    func setupPicker() {
        startDatePicker.expandPickerRange()
        endDatePicker.expandPickerRange()

        cancellables.formUnion([
            startDatePicker.publisher(for: .editingDidBegin).weakSink(with: self) {
                $0.startBorderView.changeColor(.inputBorder)
            },
            endDatePicker.publisher(for: .editingDidBegin).weakSink(with: self) {
                $0.endBorderView.changeColor(.inputBorder)
            },
            startDatePicker.publisher(for: .editingDidEnd).weakSink(with: self) {
                $0.startBorderView.changeColor(.primary)
            },
            endDatePicker.publisher(for: .editingDidEnd).weakSink(with: self) {
                $0.endBorderView.changeColor(.primary)
            },
            startDatePicker.publisher.weakSink(with: self) {
                $0.startPickerLabel.text = $1.toString
            },
            endDatePicker.publisher.weakSink(with: self) {
                $0.endPickerLabel.text = $1.toString
            }
        ])
    }
}

// MARK: - preview

#if DEBUG
    import SwiftUI

    struct ProjectUpdatePeriodInputViewPreview: PreviewProvider {
        static var previews: some View {
            WrapperView(view: ProjectUpdatePeriodInputView())
                .frame(height: 100)
        }
    }
#endif
