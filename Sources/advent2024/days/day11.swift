//
//  day11.swift
//  advent2024
//
//  Created by Eric Groom on 12/11/24.
//

import Foundation

struct Day11: Day {
    static let example = """
    125 17
    """

    let input: [Int]

    static func parse(_ string: String) -> [Int] {
        string.trimmingCharacters(in: .newlines).split(separator: " ").map { Int($0)! }
    }

    func part1() -> String {
        var stones = input
        for _ in 0..<25 {
            stones = stones.flatMap(evolveStone)
        }
        return String(stones.count)
    }

    func part2() -> String {
        return ""
    }

    private func evolveStone(_ stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        }
        let digits = split(stone)
        if digits.count % 2 == 0 {
            let halfLen = digits.count / 2
            return [join(digits[..<halfLen]), join(digits[halfLen...])]
        } else {
            return [stone * 2024]
        }
    }

    private func split(_ num: Int) -> [Int] {
        var digits = [Int]()
        var num = num
        while num > 0 {
            let digit = num % 10
            digits.append(digit)
            num /= 10
        }
        digits.reverse()
        return digits
    }

    private func join(_ digits: some Sequence<Int>) -> Int {
        digits.reduce(0) { $0 * 10 + $1 }
    }
}
