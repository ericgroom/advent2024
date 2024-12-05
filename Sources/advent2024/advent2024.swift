// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import InputFetcher

@main
struct Advent2024 {
    static func main() async throws {
        Day1(input: Day1.example).part1()
        try await Day1(input: fetchInput(for: 1)).part1()
        Day1(input: Day1.example).part2()
        try await Day1(input: fetchInput(for: 1)).part2()
        Day2(input: Day2.example).part1()
        try await Day2(input: fetchInput(for: 2)).part1()
        Day2(input: Day2.example).part2()
        try await Day2(input: fetchInput(for: 2)).part2()
        Day3(input: Day3.example).part1()
        try await Day3(input: fetchInput(for: 3)).part1()
        Day3(input: Day3.example2).part2()
        try await Day3(input: fetchInput(for: 3)).part2()
        Day4(input: Day4.example).part1()
        try await Day4(input: fetchInput(for: 4)).part1()
        Day4(input: Day4.example).part2()
        try await Day4(input: fetchInput(for: 4)).part2()
        Day5(input: Day5.example).part1()
        try await Day5(input: fetchInput(for: 5)).part1()
        Day5(input: Day5.example).part2()
        try await Day5(input: fetchInput(for: 5)).part2()
    }
}
