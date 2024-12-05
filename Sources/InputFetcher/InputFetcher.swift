//
//  InputFetcher.swift
//  advent2024
//
//  Created by Eric Groom on 12/5/24.
//

import Foundation

public func fetchInput(for day: Int) async throws -> String {
    let localURL = localInputFileURL(for: day)
    if FileManager.default.fileExists(atPath: localURL.path) {
        return try String(contentsOf: localURL, encoding: .utf8)
    } else {
        // create the file so we don't try over and over if the network fails
        try remoteFetchFailsafe(day: day)
        FileManager.default.createFile(atPath: localURL.path(), contents: nil)
        let fromRemote = try await fetchFromRemote(for: day)
        FileManager.default.createFile(atPath: localURL.path(), contents: fromRemote.data(using: .utf8))
        return fromRemote
    }
}

fileprivate func remoteFetchFailsafe(day: Int) throws {
    // I don't trust someone inexperienced to run this code and not spam the server
    // so here is a failsafe
    struct FetchError: Error {
        let localizedDescription: String
    }
    let checkURL = URL(filePath: #filePath)
        .deletingLastPathComponent()
        .appending(component: "enableFetching", directoryHint: .notDirectory)
    guard FileManager.default.fileExists(atPath: checkURL.path()) else {
        let errorMessage = "Input file missing for day \(day). Expected at \(localInputFileURL(for: day))"
        throw FetchError(localizedDescription: errorMessage)
    }
}

fileprivate func fetchFromRemote(for day: Int) async throws -> String {
    enum FetchError: Error {
        case invalidURL
        case badResponse(URLResponse)
        case dataNotConvertibleToString
        case invalidCookie
    }
    let secrets = try Secrets()
    guard let cookie = HTTPCookie(properties: [
        .path: "/",
        .domain: "adventofcode.com",
        .name: "session",
        .value: secrets.sessionToken,
        .secure: true
    ]) else {
        throw FetchError.invalidCookie
    }
    let config = URLSessionConfiguration.default
    config.httpCookieStorage?.setCookie(cookie)
    let session = URLSession(configuration: config)
    guard let url = URL(string: "https://adventofcode.com/2024/day/\(day)/input") else {
        throw FetchError.invalidURL
    }
    var request = URLRequest(url: url)
    request.addValue("github.com/ericgroom/advent2024 by bcgroom@gmail.com", forHTTPHeaderField: "User-Agent")
    let (data, response) = try await session.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw FetchError.badResponse(response)
    }
    guard let input = String(data: data, encoding: .utf8) else { throw FetchError.dataNotConvertibleToString }
    return input
}

fileprivate func localInputFileURL(for day: Int) -> URL {
    let fileName = "day\(day).txt"
    let inputsFolderURL = projectFolderURL()
        .appending(component: "Sources", directoryHint: .isDirectory)
        .appending(component: "advent2024", directoryHint: .isDirectory)
        .appending(component: "inputs", directoryHint: .isDirectory)
    guard FileManager.default.fileExists(atPath: inputsFolderURL.path) else {
        preconditionFailure("Expected inputs directory at \(inputsFolderURL.path) but it doesn't exist")
    }
    return inputsFolderURL.appending(component: fileName, directoryHint: .notDirectory)
}

fileprivate func projectFolderURL(_ startingFromPath: String = #filePath) -> URL {
    let url = URL(fileURLWithPath: startingFromPath)
    guard FileManager.default.fileExists(atPath: startingFromPath) else {
        fatalError("Cannot find project root at \(startingFromPath)")
    }
    let isDirectory = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    guard isDirectory else {
        let parentURL = url.deletingLastPathComponent()
        return projectFolderURL(parentURL.path())
    }
    let contents = try! FileManager.default.contentsOfDirectory(atPath: startingFromPath)
    if contents.contains("Package.swift") {
        return url
    } else {
        let parentURL = url.deletingLastPathComponent()
        return projectFolderURL(parentURL.path())
    }
}
