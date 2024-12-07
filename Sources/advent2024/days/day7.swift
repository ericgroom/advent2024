//
//  day7.swift
//  advent2024
//
//  Created by Eric Groom on 12/7/24.
//

struct Day7: Day {
    let input: [Int: [Int]]

    static let example = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

    static func parse(_ string: String) -> [Int : [Int]] {
        let data = string.split(separator: "\n")
            .map { line in
                let parts = line.split(separator: ": ")
                assert(parts.count == 2)
                let testNum = Int(parts[0])!
                let operands = parts[1].split(separator: " ").map { Int($0)! }
                return (testNum, operands)
            }

        return Dictionary(uniqueKeysWithValues: data)
    }

    func part1() -> String {
        let result = input.filter { (testNum, operands) in
            let operatorPermutations = slotPermutations(Operator.allCases, desiredCount: operands.count - 1)
            for permutation in operatorPermutations {
                let result = evaluate(operands, operators: permutation)
                if result == testNum {
                    return true
                }
            }
            return false
        }.keys.reduce(0, +)
        return "\(result)"
    }

    func part2() -> String {
        return ""
    }

    enum Operator: CaseIterable {
        case add
        case multiply
    }

    private func evaluate(_ operands: [Int], operators: [Operator]) -> Int {
        guard let first = operands.first else { return 0 }
        var result = first
        for (operand, op) in zip(operands[1...], operators) {
            switch op {
            case .add:
                result += operand
            case .multiply:
                result *= operand
            }
        }
        return result
    }

    private func slotPermutations<T>(_ possibilities: [T], desiredCount: Int) -> [[T]] {
        // 0: []
        // 1: [[*], [+]]
        // 2: [[*, *], [*, +], [+, *], [+, +]]
        guard desiredCount > 0 else { return [[]] }
        let lowerOrderPermutations = slotPermutations(possibilities, desiredCount: desiredCount - 1)
        var result = [[T]]()
        for possibility in possibilities {
            for lowerOrderPermutation in lowerOrderPermutations {
                let perm = [possibility] + lowerOrderPermutation
                result.append(perm)
            }
        }
        return result
    }
}
