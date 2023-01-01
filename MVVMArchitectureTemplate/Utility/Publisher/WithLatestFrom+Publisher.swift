import Combine
import Dispatch

extension Publishers {
    struct WithLatestFrom<
        Upstream: Publisher,
        Side: Publisher,
        Output
    >: Publisher where Upstream.Failure == Side.Failure {
        typealias Failure = Side.Failure
        typealias ResultSelector = (Upstream.Output, Side.Output) -> Output

        let upstream: Upstream
        let side: Side
        let resultSelector: ResultSelector

        func receive<S>(
            subscriber: S
        ) where S: Subscriber, Side.Failure == S.Failure, Output == S.Input {
            let timestampedUpstream = upstream.map(TimestampedValue.init)
            let timestampedSide = side.map(TimestampedValue.init)
            let state = timestampedUpstream.combineLatest(timestampedSide, State.init)
            let mappedValue = state
                .filter { $0.upstream.time >= $0.side.time }
                .map { resultSelector($0.upstream.value, $0.side.value) }

            mappedValue.receive(subscriber: subscriber)
        }

        private struct TimestampedValue<T> {
            let value: T
            let time: DispatchTime

            init(value: T) {
                self.value = value
                self.time = DispatchTime.now()
            }
        }

        private struct State {
            let upstream: TimestampedValue<Upstream.Output>
            let side: TimestampedValue<Side.Output>
        }
    }
}

extension Publisher {
    func withLatestFrom<P: Publisher, R>(
        _ publisher: P,
        resultSelector: @escaping (Output, P.Output) -> R
    ) -> Publishers.WithLatestFrom<Self, P, R> {
        .init(
            upstream: self,
            side: publisher,
            resultSelector: resultSelector
        )
    }

    func withLatestFrom<P: Publisher>(
        _ publisher: P
    ) -> Publishers.WithLatestFrom<Self, P, P.Output> {
        withLatestFrom(
            publisher,
            resultSelector: { $1 }
        )
    }
}
