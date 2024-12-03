//
//  day1.swift
//  advent2024
//
//  Created by Eric Groom on 12/2/24.
//

import Foundation


struct Day1 {
    let input: String
    static let example = """
                  3   4
                  4   3
                  2   5
                  1   3
                  3   9
                  3   3
                  """

    func parse() -> [(Int, Int)] {
        input
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
    func part1() {
        let parsed = parse()
        let lhs = parsed.map(\.0).sorted()
        let rhs = parsed.map(\.1).sorted()
        let distances = zip(lhs, rhs)
            .map { abs($0 - $1) }
        let result = distances.reduce(0, +)
        print(result)
    }
}
