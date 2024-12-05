//
//  day5.swift
//  advent2024
//
//  Created by Eric Groom on 12/5/24.
//

import Foundation

struct Day5 {
    let input: String

    static let example = #"""
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """#

    struct Input {
        let rules: [Int: Set<Int>]
        let updates: [[Int]]
    }

    func parse() -> Input {
        let parts = input.split(separator: "\n\n")
        assert(parts.count == 2)
        let rules = parts[0]
            .split(separator: "\n")
            .map { line in
                let lineParts = line.split(separator: "|")
                assert(lineParts.count == 2)
                return (Int(lineParts[0])!, Int(lineParts[1])!)
            }
            .reduce(into: [Int: Set<Int>]()) { partialResult, pagePair in
                let (before, after) = pagePair
                partialResult[before, default: Set()].insert(after)
            }

        let updates = parts[1]
            .split(separator: "\n")
            .map {
                $0.split(separator: ",")
                    .map { Int($0)! }
            }

        return Input(rules: rules, updates: updates)
    }

    // 4957
    func part1() {
        let input = parse()
        let updatesToPrint = input.updates.filter { update in
            var seenSoFar = Set<Int>()
            for page in update {
                let beforeRules = input.rules[page, default: Set()]
                guard beforeRules.intersection(seenSoFar).isEmpty else { return false }
                seenSoFar.insert(page)
                // 75,97,47,61,53
            }
            return true
        }
        let result = updatesToPrint.map { update in
            assert(update.count % 2 == 1)
            let index = update.count / 2
            return update[index]
        }.reduce(0, +)
        print(result)
    }
}
