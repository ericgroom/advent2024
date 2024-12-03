// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Advent2024 {
    static func main() {
        Day1(input: Day1.example).part1()
        Day1(input: getInput(filename: "day1")).part1()
        Day1(input: Day1.example).part2()
        Day1(input: getInput(filename: "day1")).part2()
        Day2(input: Day2.example).part1()
        Day2(input: getInput(filename: "day2")).part1()
    }

    static func getInput(filename: String) -> String {
        let url = Bundle.module.url(forResource: filename, withExtension: "txt")!
        return try! String(contentsOf: url, encoding: .utf8)
    }
}
