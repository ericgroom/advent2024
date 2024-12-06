//
//  day1.swift
//  advent2024
//
//  Created by Eric Groom on 12/2/24.
//

import Foundation


struct Day1: Day {

    let input: [(Int, Int)]

    static let example = """
                  3   4
                  4   3
                  2   5
                  1   3
                  3   9
                  3   3
                  """

    static func parse(_ string: String) -> [(Int, Int)] {
        string
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { (line: String) in
                let rawNums = line
                    .components(separatedBy: .whitespaces)
                    .filter { !$0.isEmpty }
                assert(rawNums.count == 2)
                let num0 = Int(rawNums[0], radix: 10)!
                let num1 = Int(rawNums[1], radix: 10)!
                return (num0, num1)
            }
    }

    // 2192892
    func part1() -> String {
        let lhs = input.map(\.0).sorted()
        let rhs = input.map(\.1).sorted()
        let distances = zip(lhs, rhs)
            .map { abs($0 - $1) }
        let result = distances.reduce(0, +)
        return String(result)
    }

    // 22962826
    func part2() -> String {
        let lhs = input.map(\.0)
        let rhs = input.map(\.1)
        var rhsFrequency = [Int: Int]()
        for num in rhs {
            rhsFrequency[num, default: 0] += 1
        }
        let result = lhs
            .map { $0 * rhsFrequency[$0, default: 0] }
            .reduce(0, +)
        return String(result)
    }
}
