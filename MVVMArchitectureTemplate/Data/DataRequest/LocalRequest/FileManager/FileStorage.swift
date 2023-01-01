import Foundation

@propertyWrapper
final class FileStorage<T: Codable> {
    private let file: String
    private var value: T?

    init(fileName: String) {
        self.file = fileName
        self.value = LocalStorageManager.getObjectFromFile(fileName: file)
    }

    var wrappedValue: T? {
        get {
            value
        }
        set {
            value = newValue

            let fileName = file

            if let data = newValue {
                LocalStorageManager.writeObjectToFile(
                    fileName: fileName,
                    jsonEncodable: data
                )
            } else {
                LocalStorageManager.deleteFile(fileName: fileName)
            }
        }
    }
}

private enum LocalStorageManager {
    private enum PathSearchError: Error {
        case pathNotFound
    }

    private enum DispatchQueueLabel: String {
        case localStorageManager
    }

    private enum Constants {
        static let fileWritingDebounce = DispatchTimeInterval.milliseconds(200)
    }

    static func removeAll() {
        let manager = FileManager.default

        guard
            let docURL = manager.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first
        else {
            return
        }

        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let dirURL = docURL.appendingPathComponent(bundleId)

        manager.enumerator(at: dirURL, includingPropertiesForKeys: nil)?.forEach { url in
            if let url = url as? URL {
                try? manager.removeItem(at: url)
            }
        }
    }

    static func getObjectFromFile<T: Decodable>(fileName: String) -> T? {
        do {
            let fileURL = try retrieveConfiguredFileURL(fileName: fileName)
            let localData = try Data(contentsOf: fileURL, options: .alwaysMapped)
            let localItems = try JSONDecoder().decode(T.self, from: localData)
            return localItems
        } catch {
            logError(
                errorDescription: error.localizedDescription,
                functionName: #function
            )
            return nil
        }
    }

    static func writeObjectToFile(
        fileName: String,
        jsonEncodable: some Encodable,
        dispatchQueue: DispatchQueue = DispatchQueue(
            label: DispatchQueueLabel.localStorageManager.rawValue
        )
    ) {
        dispatchQueue.async {
            let jsonEncoder = JSONEncoder()

            guard let jsonData = try? jsonEncoder.encode(jsonEncodable) else {
                return
            }

            do {
                let fileURL = try self.retrieveConfiguredFileURL(fileName: fileName)
                try jsonData.write(to: fileURL, options: .atomic)
            } catch {
                self.logError(
                    errorDescription: error.localizedDescription,
                    functionName: #function
                )
            }
        }
    }

    static func deleteFile(
        fileName: String,
        dispatchQueue: DispatchQueue = DispatchQueue(
            label: DispatchQueueLabel.localStorageManager.rawValue
        )
    ) {
        dispatchQueue.async {
            do {
                let fileURL = try self.retrieveConfiguredFileURL(fileName: fileName)
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                DispatchQueue.main.async {
                    self.logError(
                        errorDescription: error.localizedDescription,
                        functionName: #function
                    )
                }
            }
        }
    }
}

private extension LocalStorageManager {
    static func retrieveConfiguredFileURL(
        fileName: String,
        excludeFromBackup: Bool = true
    ) throws -> URL {
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let appSupportDir = FileManager.SearchPathDirectory.applicationSupportDirectory
        let userMask = FileManager.SearchPathDomainMask.userDomainMask

        guard
            let appSupportDirURL: URL = FileManager.default.urls(
                for: appSupportDir,
                in: userMask
            ).first
        else {
            throw PathSearchError.pathNotFound
        }

        let dirURL = appSupportDirURL.appendingPathComponent(bundleId, isDirectory: true)
        var isDir: ObjCBool = true

        if !FileManager.default.fileExists(atPath: dirURL.path, isDirectory: &isDir) {
            try? FileManager.default.createDirectory(
                at: dirURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }

        var fullURL = dirURL.appendingPathComponent(fileName, isDirectory: false)

        if excludeFromBackup {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? fullURL.setResourceValues(resourceValues)
        }

        return fullURL
    }

    static func logError(
        errorDescription: String,
        functionName: String
    ) {
        let log = String(describing: self) + " " + functionName + " error:" + errorDescription
        Logger.debug(message: log)
    }
}
