/// @mockable
protocol SampleConverterInput {
    func convert(_ objects: [SampleDataObject]) -> [SampleModelObject]
    func convert(_ object: SampleDataObject) -> SampleModelObject
}

struct SampleConverter: SampleConverterInput {
    func convert(_ objects: [SampleDataObject]) -> [SampleModelObject] {
        objects.map {
            .init(
                userId: $0.userId,
                id: $0.id,
                title: $0.title,
                body: $0.body
            )
        }
    }

    func convert(_ object: SampleDataObject) -> SampleModelObject {
        .init(
            userId: object.userId,
            id: object.id,
            title: object.title,
            body: object.body
        )
    }
}
