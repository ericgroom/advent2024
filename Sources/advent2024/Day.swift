//
//  day.swift
//  advent2024
//
//  Created by Eric Groom on 12/5/24.
//

import Foundation

protocol Day {
    associatedtype Input

    static var example: String { get }
    static var example2: String { get }

    static var examples1: [String] { get }
    static var examples2: [String] { get }

    var input: Input { get }
    init(input: Input)

    func part1() -> String
    func part2() -> String
    static func parse(_ string: String) throws -> Input
}

extension Day {
    static var example2: String { example }
    static var examples1: [String] { [example] }
    static var examples2: [String] { [example2] }
}
