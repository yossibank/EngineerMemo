import Combine
import CoreData

final class CoreDataPublisher<Entity>: NSObject, NSFetchedResultsControllerDelegate, Publisher
    where Entity: NSManagedObject {
    typealias Output = [Entity]
    typealias Failure = CoreDataError

    private var resultController: NSFetchedResultsController<NSManagedObject>?
    private var subscriptions = 0

    private let request: NSFetchRequest<Entity>
    private let context: NSManagedObjectContext
    private let subject: CurrentValueSubject<[Entity], Failure>

    init(
        request: NSFetchRequest<Entity>,
        context: NSManagedObjectContext
    ) {
        if request.sortDescriptors == nil {
            request.sortDescriptors = []
        }

        self.request = request
        self.context = context
        self.subject = CurrentValueSubject([])

        super.init()
    }

    func receive<S>(
        subscriber: S
    ) where S: Subscriber, CoreDataPublisher.Failure == S.Failure, CoreDataPublisher.Output == S.Input {
        var start = false

        objc_sync_enter(self)
        subscriptions += 1
        start = subscriptions == 1
        objc_sync_exit(self)

        if start {
            let controller = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            controller.delegate = self

            context.perform {
                do {
                    try controller.performFetch()
                    let result = controller.fetchedObjects ?? []
                    self.subject.send(result)
                } catch {
                    self.subject.send(completion: .failure(.something(error.localizedDescription)))
                }
            }

            resultController = controller as? NSFetchedResultsController<NSManagedObject>
        }

        CoreDataSubscription(
            fetchPublisher: self,
            subscriber: AnySubscriber(subscriber)
        )
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [Entity] ?? []
        subject.send(result)
    }

    private func dropSubscription() {
        objc_sync_enter(self)
        subscriptions -= 1
        let stop = subscriptions == 0
        objc_sync_exit(self)

        if stop {
            resultController?.delegate = nil
            resultController = nil
        }
    }

    private final class CoreDataSubscription: Subscription {
        private var fetchPublisher: CoreDataPublisher?
        private var cancellable: AnyCancellable?

        @discardableResult
        init(
            fetchPublisher: CoreDataPublisher,
            subscriber: AnySubscriber<Output, Failure>
        ) {
            subscriber.receive(subscription: self)

            self.fetchPublisher = fetchPublisher
            self.cancellable = fetchPublisher.subject
                .dropFirst()
                .sink(
                    receiveCompletion: { completion in
                        subscriber.receive(completion: completion)
                    },
                    receiveValue: { value in
                        _ = subscriber.receive(value)
                    }
                )
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            cancellable?.cancel()
            cancellable = nil
            fetchPublisher?.dropSubscription()
            fetchPublisher = nil
        }
    }
}
