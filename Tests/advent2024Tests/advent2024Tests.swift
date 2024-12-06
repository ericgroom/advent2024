import Testing
@testable import advent2024
import InputFetcher

@Test
func day1() async throws {
    let parser = Day1.parse
    let realInput = try await parser(fetchInput(for: 1))
    let example = parser(Day1.example)
    #expect(Day1(input: example).part1() == "11")
    #expect(Day1(input: realInput).part1() == "2192892")
    #expect(Day1(input: example).part2() == "31")
    #expect(Day1(input: realInput).part2() == "22962826")
}

@Test
func day2() async throws {
    let parser = Day2.parse
    let realInput = try await parser(fetchInput(for: 2))
    let example = parser(Day2.example)
    #expect(Day2(input: example).part1() == "2")
    #expect(Day2(input: realInput).part1() == "332")
    #expect(Day2(input: example).part2() == "4")
    #expect(Day2(input: realInput).part2() == "398")
}

@Test
func day3() async throws {
    let parser = Day3.parse
    let realInput = try await parser(fetchInput(for: 3))
    let example = parser(Day3.example)
    #expect(Day3(input: example).part1() == "161")
    #expect(Day3(input: realInput).part1() == "189600467")
    #expect(Day3(input: parser(Day3.example2)).part2() == "48")
    #expect(Day3(input: realInput).part2() == "107069718")
}

@Test
func day4() async throws {
    let parser = Day4.parse
    let realInput = try await parser(fetchInput(for: 4))
    let example = parser(Day4.example)
    #expect(Day4(input: example).part1() == "18")
    #expect(Day4(input: realInput).part1() == "2521")
    #expect(Day4(input: example).part2() == "9")
    #expect(Day4(input: realInput).part2() == "1912")
}

@Test
func day5() async throws {
    let parser = Day5.parse
    let realInput = try await parser(fetchInput(for: 5))
    let example = parser(Day5.example)
    #expect(Day5(input: example).part1() == "143")
    #expect(Day5(input: realInput).part1() == "4957")
    #expect(Day5(input: example).part2() == "123")
    #expect(Day5(input: realInput).part2() == "6938")
}

@Test
func day6() async throws {
    let parser = Day6.parse
    let realInput = try await parser(fetchInput(for: 6))
    let example = parser(Day6.example)
    #expect(Day6(input: example).part1() == "41")
    #expect(Day6(input: realInput).part1() == "5101")
}
