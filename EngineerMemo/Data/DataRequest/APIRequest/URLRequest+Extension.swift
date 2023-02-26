import Foundation

extension URLRequest {
    var curlString: String {
        guard let url else {
            return .empty
        }

        var baseCommand = "\ncurl \(url.absoluteString)"

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let httpMethod,
           httpMethod != "GET",
           httpMethod != "HEAD" {
            command.append("-X \(httpMethod)")
        }

        if let allHTTPHeaderFields {
            for (key, value) in allHTTPHeaderFields where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody,
           let body = String(data: data, encoding: .utf8) {
            command.append("-d \(body)")
        }

        return command.joined(separator: " \\\n\t")
    }
}
