enum ContentViews {
    enum Profile {
        static func Detail() -> ProfileDetailContentView {
            .init()
        }

        static func Update() -> ProfileUpdateContentView {
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

            enum CoreData {
                static func List() -> DebugCoreDataListContentView {
                    .init()
                }

                static func Create() -> DebugCoreDataCreateContentView {
                    .init()
                }

                static func Update() -> DebugCoreDataUpdateContentView {
                    .init()
                }
            }

            enum CoreDataObject {
                enum List {
                    static func Profile() -> DebugProfileListContentView {
                        .init()
                    }
                }

                enum Create {
                    static func Profile() -> DebugProfileCreateContentView {
                        .init()
                    }
                }

                enum Update {
                    static func Profile() -> DebugProfileUpdateContentView {
                        .init()
                    }
                }
            }
        }
    #endif
}
