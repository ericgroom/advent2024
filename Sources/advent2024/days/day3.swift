//
//  day3.swift
//  advent2024
//
//  Created by Eric Groom on 12/3/24.
//

import Foundation
import RegexBuilder

struct Day3: Day {
    let input: [Instruction]

    static let example = #"""
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """#
    static let example2 = #"""
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """#

    enum Instruction {
        case `do`
        case dont
        case mul(Int, Int)
    }

    static func parse(_ string: String) -> [Instruction] {
        let mulPattern = /mul\(([0-9]+),([0-9]+)\)/
        let doPattern = /do\(\)/
        let dontPattern = /don't\(\)/
        let pattern = ChoiceOf {
            mulPattern
            doPattern
            dontPattern
        }
        var result = [Instruction]()
        for match in string.matches(of: pattern) {
            switch match.0 {
            case "do()":
                result.append(.do)
            case "don't()":
                result.append(.dont)
            default:
                result.append(.mul(Int(match.1!)!, Int(match.2!)!))
            }
        }
        return result
    }

    // 189600467
    func part1() -> String {
        let result = input
            .compactMap { instruction in
                switch instruction {
                case .mul(let lhs, let rhs):
                    (lhs, rhs)
                default:
                    nil
                }
            }
            .map { $0 * $1 }
            .reduce(0, +)

        return String(result)
    }

    // 107069718
    func part2() -> String {
        let instructions = input
        var `do` = true
        var result = 0
        for instruction in instructions {
            switch instruction {
            case .do:
                `do` = true
            case .dont:
                `do` = false
            case .mul(let lhs, let rhs):
                if `do` {
                    result += (lhs * rhs)
                } else {
                    continue
                }
            }
        }

        return String(result)
    }

}
