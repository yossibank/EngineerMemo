enum ViewModels {
    enum Memo {
        static func List() -> MemoListViewModel {
            .init(analytics: FirebaseAnalytics(screenId: .memoList))
        }
    }

    enum Profile {
        static func Detail(routing: ProfileDetailRoutingInput) -> ProfileDetailViewModel {
            .init(
                model: Models.Profile(),
                routing: routing,
                analytics: FirebaseAnalytics(screenId: .profileDetail)
            )
        }

        static func Update(
            modelObject: ProfileModelObject? = nil,
            screenId: FAScreenId
        ) -> ProfileUpdateViewModel {
            .init(
                model: Models.Profile(),
                modelObject: modelObject,
                analytics: FirebaseAnalytics(screenId: screenId)
            )
        }
    }

    #if DEBUG
        enum Debug {
            static func Development(routing: DebugDevelopmentRoutingInput) -> DebugDevelopmentViewModel {
                .init(routing: routing)
            }

            enum CoreDataObject {
                enum Create {
                    static func Profile() -> DebugProfileCreateViewModel {
                        .init(model: Models.Profile())
                    }
                }

                enum List {
                    static func Profile() -> DebugProfileListViewModel {
                        .init(model: Models.Profile())
                    }
                }

                enum Update {
                    static func Profile() -> DebugProfileUpdateViewModel {
                        .init(model: Models.Profile())
                    }
                }
            }
        }
    #endif
}
