//
//  day10.swift
//  advent2024
//
//  Created by Eric Groom on 12/10/24.
//


import Foundation

struct Day10: Day {
    let input: Grid<Int>

    static let example: String = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    static func parse(_ string: String) -> Grid<Int> {
        let charGrid = string.split(separator: "\n")
            .map(Array.init)
        return Grid(grid: charGrid).map { Int(String($0))! }
    }

    // no diagonals
    // as long as possible
    // increases exactly 1 each step
    // starts 0 ends 9

    func part1() -> String {
        var score = 0
        for coord in input.coordinates {
            guard input[coord] == 0 else { continue }
            score += self.score(trailhead: coord, map: input)
        }
        return String(score)
    }

    func part2() -> String {
        var score = 0
        for coord in input.coordinates {
            guard input[coord] == 0 else { continue }
            score += self.rating(trailhead: coord, map: input)
        }
        return String(score)
    }

    private func score(trailhead: Vec2D, map: Grid<Int>) -> Int {
        var visited: Set<Vec2D> = []
        var queue: [Vec2D] = [trailhead]
        while !queue.isEmpty {
            let next = queue.removeFirst()
            if visited.contains(next) { continue }
            visited.insert(next)
            guard let thisHeight = map[next] else { fatalError() }
            let neighbors = map
                .neighbors(of: next, directions: Direction.cardinal)
                .filter { $0.1 - thisHeight == 1 }
            queue.append(contentsOf: neighbors.map(\.0))
        }
        return visited.count { coord in
            map[coord] == 9
        }
    }

    private func rating(trailhead: Vec2D, map: Grid<Int>) -> Int {
        func inner(path: [Vec2D]) -> Int {
            guard !path.isEmpty else { return 0 }
            let latest = path.last!
            if map[latest]! == 9 {
                return 1
            }

            let neighbors = map
                .neighbors(of: latest, directions: Direction.cardinal)
                .filter { $0.1 - map[latest]! == 1 }
                .map(\.0)

            return neighbors.reduce(0) { partialResult, neighbor in
                partialResult + rating(trailhead: neighbor, map: map)
            }
        }

        return inner(path: [trailhead])
    }
}
