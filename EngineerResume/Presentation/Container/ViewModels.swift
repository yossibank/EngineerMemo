enum ViewModels {
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
}
