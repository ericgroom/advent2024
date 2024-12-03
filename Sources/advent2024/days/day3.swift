//
//  day3.swift
//  advent2024
//
//  Created by Eric Groom on 12/3/24.
//

import Foundation

struct Day3 {
    let input: String

    static let example = #"""
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """#

    func parse() -> [(Int, Int)] {
        let pattern = /mul\(([0-9]+),([0-9]+)\)/
        var result = [(Int, Int)]()
        for match in input.matches(of: pattern) {
            let lhs = match.1
            let rhs = match.2
            result.append((Int(lhs)!, Int(rhs)!))
        }
        return result
    }

    // 189600467
    func part1() {
        let result = parse()
            .map { $0 * $1 }
            .reduce(0, +)

        print(result)
    }

}
