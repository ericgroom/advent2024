//
//  Secrets.swift
//  advent2024
//
//  Created by Eric Groom on 12/5/24.
//

import Foundation

struct Secrets: Codable {
    let sessionToken: String

    init(sessionToken: String) {
        self.sessionToken = sessionToken
    }

    enum SecretsFetchError: Swift.Error {
        case missingUrl
        case missingContents
        case emptyToken
    }

    init() throws {
        guard let url = Bundle.module.url(forResource: "secrets", withExtension: "json") else {
            throw SecretsFetchError.missingUrl
        }
        guard let data = try? Data(contentsOf: url) else {
            throw SecretsFetchError.missingContents
        }
        let decoder = JSONDecoder()
        self = try decoder.decode(Secrets.self, from: data)
        guard !self.sessionToken.isEmpty else { throw SecretsFetchError.emptyToken }
    }
}
