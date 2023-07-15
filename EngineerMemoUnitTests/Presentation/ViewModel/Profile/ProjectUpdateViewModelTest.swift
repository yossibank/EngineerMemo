import Combine
@testable import EngineerMemo
import XCTest

final class ProjectUpdateViewModelTest: XCTestCase {
    private var model: ProfileModelInputMock!
    private var analytics: FirebaseAnalyzableMock!
    private var viewModel: ProjectUpdateViewModel!

    override func tearDown() {
        super.tearDown()

        model = nil
        analytics = nil
        viewModel = nil
    }

    func test_input_viewWillAppear_ログイベントが送信されていること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        analytics.sendEventFAEventHandler = {
            // assert
            XCTAssertEqual(
                $0,
                .screenView
            )
        }

        // act
        viewModel.input.viewWillAppear.send(())
    }

    func test_binding_title_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.title = "title"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.title,
                "title"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_startDate_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.startDate = Calendar.date(year: 2020, month: 1, day: 1)

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.startDate,
                Calendar.date(year: 2020, month: 1, day: 1)
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_endDate_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.endDate = Calendar.date(year: 2021, month: 1, day: 1)

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.endDate,
                Calendar.date(year: 2021, month: 1, day: 1)
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_role_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.role = "プログラマー"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.role,
                "プログラマー"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_processes_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.processes = [.implementation, .maintenance]

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.processes,
                [.implementation, .maintenance]
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_language_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.language = "Swift"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.language,
                "Swift"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_database_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.database = "CoreData"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.database,
                "CoreData"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_serverOS_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.serverOS = "Ubuntu"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.serverOS,
                "Ubuntu"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_tools_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.tools = ["Firebase", "MagicPod"]

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.tools,
                ["Firebase", "MagicPod"]
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_binding_content_設定ボタンタップ時にmodelObjectに反映されること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        viewModel.binding.content = "content"

        model.createProjectHandler = {
            // assert
            XCTAssertEqual(
                $0.projects.first?.content,
                "content"
            )

            return Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())
    }

    func test_input_didTapBarButton_output_isFinishedがtrueを取得できること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        model.createProjectHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertTrue(viewModel.output.isFinished)
    }

    func test_input_didTapBarButton_setting_案件作成処理が呼ばれること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder().build()
        )

        model.createProjectHandler = { _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(model.createProjectCallCount, 1)
    }

    func test_input_didTapBarButton_setting_案件更新処理が呼ばれること() {
        // arrange
        setupViewModel(
            identifier: "identifier",
            modelObject: ProfileModelObjectBuilder()
                .projects([
                    ProjectModelObjectBuilder()
                        .identifier("identifier")
                        .build()
                ])
                .build()
        )

        model.updateProjectHandler = { _, _ in
            Deferred {
                Future<Void, Never> { promise in
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }

        // act
        viewModel.input.didTapBarButton.send(())

        // assert
        XCTAssertEqual(model.updateProjectCallCount, 1)
    }
}

private extension ProjectUpdateViewModelTest {
    func setupViewModel(
        identifier: String,
        modelObject: ProfileModelObject
    ) {
        model = .init()

        analytics = modelObject.projects.contains(where: { $0.identifier == identifier })
            ? .init(screenId: .projectUpdate)
            : .init(screenId: .projectSetting)

        viewModel = .init(
            identifier: identifier,
            modelObject: modelObject,
            model: model,
            analytics: analytics
        )
    }
}
