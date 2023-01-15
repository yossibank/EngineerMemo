enum ContentViews {
    enum Profile {
        static func Detail() -> ProfileDetailContentView {
            .init()
        }
    }

    enum Sample {
        static func Add() -> SampleAddContentView {
            .init()
        }

        static func Detail(modelObject: SampleModelObject) -> SampleDetailContentView {
            .init(modelObject: modelObject)
        }

        static func Edit(modelObject: SampleModelObject) -> SampleEditContentView {
            .init(modelObject: modelObject)
        }

        static func List() -> SampleListContentView {
            .init()
        }
    }

    #if DEBUG
        enum Debug {
            static func Development() -> DebugDevelopmentContentView {
                .init()
            }

            static func CoreData() -> DebugCoreDataContentView {
                .init()
            }
        }
    #endif
}
