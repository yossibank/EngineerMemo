enum ViewModels {
    enum Profile {
        static func Detail() -> ProfileDetailViewModel {
            .init(
                model: Models.Profile(),
                analytics: FirebaseAnalytics(screenId: .profileDetail)
            )
        }
    }

    enum Sample {
        static func Add() -> SampleAddViewModel {
            .init(
                model: Models.Sample(),
                analytics: FirebaseAnalytics(screenId: .sampleAdd)
            )
        }

        static func Detail(
            modelObject: SampleModelObject,
            routing: SampleDetailRoutingInput
        ) -> SampleDetailViewModel {
            .init(
                modelObject: modelObject,
                routing: routing,
                analytics: FirebaseAnalytics(screenId: .sampleDetail)
            )
        }

        static func Edit(modelObject: SampleModelObject) -> SampleEditViewModel {
            .init(
                model: Models.Sample(),
                modelObject: modelObject,
                analytics: FirebaseAnalytics(screenId: .sampleEdit)
            )
        }

        static func List(routing: SampleListRoutingInput) -> SampleListViewModel {
            .init(
                model: Models.Sample(),
                routing: routing,
                analytics: FirebaseAnalytics(screenId: .sampleList)
            )
        }
    }

    #if DEBUG
        enum Debug {
            static func Development(routing: DebugDevelopmentRoutingInput) -> DebugDevelopmentViewModel {
                .init(routing: routing)
            }

            enum CoreData {
                static func Create() -> DebugCoreDataCreateViewModel {
                    .init()
                }
            }
        }
    #endif
}
