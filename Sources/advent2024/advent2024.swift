// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import InputFetcher

@main
struct Advent2024 {
    static func main() async throws {
        debugPrint(Day3.examples1, Day3.examples2)
        try await run(Day1.self, number: 1)
        try await run(Day2.self, number: 2)
        try await run(Day3.self, number: 3)
        try await run(Day4.self, number: 4)
        try await run(Day5.self, number: 5)
    }

    private static func run<DayType: Day>(_ dayType: DayType.Type, number dayNum: Int) async throws {
        print("Day \(dayNum)")
        print("Part 1:")
        let parser = dayType.parse
        let realInput = try await parser(fetchInput(for: dayNum))
        for rawExample in dayType.examples1 {
            let example = try parser(rawExample)
            print(dayType.init(input: example).part1())
        }
        print(dayType.init(input: realInput).part1())
        print("Part 2:")
        for rawExample in dayType.examples2 {
            let example = try parser(rawExample)
            print(dayType.init(input: example).part2())
        }
        print(dayType.init(input: realInput).part2())
    }
}
