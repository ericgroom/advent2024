//
//  day4.swift
//  advent2024
//
//  Created by Eric Groom on 12/4/24.
//

import Foundation

struct Day4 {
    let input: String

    static let example: String = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    func parse() -> Grid<Character> {
        let characterGrid = input.split(separator: .newlineSequence)
            .map { Array($0) }
        return Grid(grid: characterGrid)
    }

    // 2521
    func part1() {
        let grid = parse()
        let searchSequence: [Character] = ["X", "M", "A", "S"]
        var matchCount = 0
        for location in grid.coordinates {
            let value = grid[location]!
            // only visit X's
            guard value == searchSequence.first! else { continue }
            for direction in Direction.allCases {
                if sequenceExists(sequence: searchSequence[...], from: location, in: grid, towards: direction) {
                    matchCount += 1
                }
            }
        }
        print(matchCount)
    }

    // 1912
    func part2() {
        let grid = parse()
        var matchCount = 0
        for location in grid.coordinates {
            for window in windows() {
                if windowMatches(window: window, at: location, in: grid) {
                    matchCount += 1
                }
            }
        }

        print(matchCount)
    }

    func windowMatches(window: [[Character?]], at location: Vec2D, in grid: Grid<Character>) -> Bool {
        for (y, row) in window.enumerated() {
            for (x, value) in row.enumerated() {
                guard let value else { continue }
                let gridCoordinate = Vec2D(x: x, y: y) + location
                guard let gridValue = grid[gridCoordinate] else { return false }
                guard gridValue == value else { return false }
            }
        }
        return true
    }

    func windows() -> Set<[[Character?]]> {
        [
            [
                ["M", nil, "M"],
                [nil, "A", nil],
                ["S", nil, "S"],
            ],
            [
                ["S", nil, "M"],
                [nil, "A", nil],
                ["S", nil, "M"],
            ],
            [
                ["S", nil, "S"],
                [nil, "A", nil],
                ["M", nil, "M"],
            ],
            [
                ["M", nil, "S"],
                [nil, "A", nil],
                ["M", nil, "S"],
            ],
        ]
    }

    func sequenceExists(sequence: ArraySlice<Character>, from start: Vec2D, in grid: Grid<Character>, towards direction: Direction) -> Bool {
        guard !sequence.isEmpty else { return true }
        let expectedValue = sequence.first!
        guard let actualValue = grid[start] else { return false }
        guard expectedValue == actualValue else { return false }
        return sequenceExists(sequence: sequence[sequence.startIndex+1..<sequence.endIndex], from: start + direction.unitVector, in: grid, towards: direction)
    }
}

struct Vec2D: Equatable, Hashable {
    let x: Int
    let y: Int

    var neighbors: [Vec2D] {
        Vec2D.unitVectors.map { $0 + self }
    }

    static var unitVectors: [Vec2D] {
        [.init(x: 0, y: 1), .init(x: -1, y: 1), .init(x: -1, y: 0), .init(x: -1, y: -1), .init(x: 0, y: -1), .init(x: 1, y: -1), .init(x: 1, y: 0), .init(x: 1, y: 1)]
    }

    static func +(lhs: Vec2D, rhs: Vec2D) -> Vec2D {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

enum Direction: CaseIterable, Equatable, Hashable {
    case upLeft, up, upRight, left, right, downLeft, down, downRight

    var unitVector: Vec2D {
        switch self {
        case .upLeft: return .init(x: -1, y: -1)
        case .up: return .init(x: 0, y: -1)
        case .upRight: return .init(x: 1, y: -1)
        case .left: return .init(x: -1, y: 0)
        case .right: return .init(x: 1, y: 0)
        case .downLeft: return .init(x: -1, y: 1)
        case .down: return .init(x: 0, y: 1)
        case .downRight: return .init(x: 1, y: 1)
        }
    }
}

struct Grid<Value> {
    private(set) var data: [Vec2D: Value]

    init(data: [Vec2D : Value]) {
        self.data = data
    }

    init(grid: [[Value]]) {
        guard let width = grid.first?.count else {
            preconditionFailure("empty")
        }

        var result = [Vec2D: Value]()
        for (y, row) in grid.enumerated() {
            precondition(row.count == width)
            for (x, value) in row.enumerated() {
                let coord = Vec2D(x: x, y: y)
                result[coord] = value
            }
        }
        self.init(data: result)
    }

    subscript(_ v: Vec2D) -> Value? {
        get {
            data[v]
        }
        set {
            data[v] = newValue
        }
    }

    func neighbors(of v: Vec2D) -> [(Vec2D, Value)] {
        var result: [(Vec2D, Value)] = []
        for neighbor in v.neighbors {
            if let value = self[neighbor] {
                result.append((neighbor, value))
            }
        }
        return result
    }

    var coordinates: some Sequence<Vec2D> {
        data.keys
    }
}
