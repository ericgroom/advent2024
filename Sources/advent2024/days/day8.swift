//
//  day8.swift
//  advent2024
//
//  Created by Eric Groom on 12/8/24.
//

import Foundation

struct Day8: Day {
    static let example: String = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """
    
    let input: Grid<Character>
    
    static func parse(_ string: String) -> Grid<Character> {
        let charGrid = string.split(separator: "\n")
            .map(Array.init)
        return Grid(grid: charGrid)
    }
    
    func part1() -> String {
        let antennasByFrequency = groupedAntennas()
        var antinodes = [Vec2D]()
        for location in input.coordinates {
            for (_, antennas) in antennasByFrequency {
                for pair in allPermutations(antennas) {
                    guard isOnLine(point: location, line: pair) else { continue }
                    let distA = Vec2D.euclideanDistance(pair.0, location)
                    let distB = Vec2D.euclideanDistance(pair.1, location)
                    let lower = min(distA, distB)
                    let higher = max(distA, distB)
                    guard abs(lower * 2 - higher) < 0.01 else { continue }
                    antinodes.append(location)
                }
            }
        }
        let result = Set(antinodes)
        return String(result.count)
    }
    
    func allPermutations<T: Equatable>(_ seq: [T]) -> [(T, T)] {
        var result = [(T, T)]()
        for a in seq {
            for b in seq where b != a {
                result.append((a, b))
            }
        }
        return result
    }
    
    func part2() -> String {
        let antennasByFrequency = groupedAntennas()
        var antinodes = [Vec2D]()
        for location in input.coordinates {
            for (_, antennas) in antennasByFrequency {
                for pair in allPermutations(antennas) {
                    guard isOnLine(point: location, line: pair) else { continue }
                    antinodes.append(location)
                }
            }
        }
        let result = Set(antinodes)
        return String(result.count)
    }
    
    private func groupedAntennas() -> [Character: Array<Vec2D>] {
        input.coordinates.reduce(into: [Character: Array<Vec2D>]()) { partialResult, location in
            let value = input[location]!
            guard value != "." else { return }
            partialResult[value, default: []].append(location)
        }
    }
    
    private func isOnLine(point: Vec2D, line: (Vec2D, Vec2D)) -> Bool {
        // [ Ax * (By - Cy) + Bx * (Cy - Ay) + Cx * (Ay - By) ] / 2
        // https://stackoverflow.com/a/3813755/6335864
        let (llhs, rrhs) = line
        let lhs = llhs.double
        let rhs = rrhs.double
        let point = point.double
        // (0, 0), (2, 2), (-3, -3)
        let expr = lhs.x * (rhs.y - point.y) + rhs.x * (point.y - lhs.y) + point.x * (lhs.y - rhs.y)
        return abs(expr) < 0.01
    }
}

extension Vec2D {
    static func euclideanDistance(_ lhs: Vec2D, _ rhs: Vec2D) -> Double {
        let ys: Double = Double(rhs.y - lhs.y)
        let xs: Double = Double(rhs.x - lhs.x)
        return sqrt((ys * ys) + (xs * xs))
    }
    
    var double: (x: Double, y: Double) {
        (x: Double(x), y: Double(y))
    }
}
