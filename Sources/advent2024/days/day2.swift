//
//  day2.swift
//  advent2024
//
//  Created by Eric Groom on 12/2/24.
//

import Foundation

struct Day2 {
    let input: String

    static let example = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    func parse(_ input: String) -> [[Int]] {
        input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { line in
                line
                    .components(separatedBy: .whitespaces)
                    .compactMap { Int($0, radix: 10) }
            }
    }

    // 332
    func part1() {
        let reports = parse(input)
        let result = reports
            .filter { safe(levels: $0) }
            .count
        print(result)
    }

    // 398
    func part2() {
        let reports = parse(input)
        let safeReports = reports.filter { safe(levels: $0)}
        let unsafeReports = reports.filter { !safe(levels: $0)}
        let newSafeReports = unsafeReports.filter { report in
            report.indices.contains { index in
                var without = report
                without.remove(at: index)
                return safe(levels: without)
            }
        }
        print(safeReports.count + newSafeReports.count)
    }

    private func safe(levels: [Int]) -> Bool {
        assert(levels.count >= 2)
        var previousLevel = levels[0]
        var increasing = false
        var decreasing = false
        for level in levels[1...] {
            let prevIncreasing = increasing
            let prevDecreasing = decreasing
            defer { previousLevel = level }
            let absDiff = abs(level - previousLevel)
            guard 0 < absDiff && absDiff <= 3 else { return false }
            increasing = level > previousLevel
            decreasing = level < previousLevel
            if prevIncreasing == true && increasing == false { return false }
            if prevDecreasing == true && decreasing == false { return false }
        }
        return true
    }
}
