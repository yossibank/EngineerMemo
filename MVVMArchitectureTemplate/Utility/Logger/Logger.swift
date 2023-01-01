import os

enum Logger {
    private enum LogType {
        case debug
        case info
        case warning
        case error
        case fault
    }

    private static let logger = os.Logger(
        subsystem: "sample.com",
        category: "App"
    )

    static func debug(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            .debug,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }

    static func info(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            .info,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }

    static func warning(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            .warning,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }

    static func error(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            .error,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }

    static func fault(
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            .fault,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }

    private static func doLog(
        _ type: LogType,
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
            switch type {
            case .debug:
                logger.debug("🔎【DEBUG】\(message) \(file.split(separator: "/").last!) \(function) L:\(line)")

            case .info:
                logger.info("💻【INFO】\(message) \(file.split(separator: "/").last!) \(function) L:\(line)")

            case .warning:
                logger.warning("⚠️【WARNING】\(message) \(file.split(separator: "/").last!) \(function) L:\(line)")

            case .error:
                logger.error("🚨【ERROR】\(message) \(file.split(separator: "/").last!) \(function) L:\(line)")

            case .fault:
                logger.error("💣【FAULT】\(message) \(file.split(separator: "/").last!) \(function) L:\(line)")
            }
        #endif
    }
}
