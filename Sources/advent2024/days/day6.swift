//
//  day6.swift
//  advent2024
//
//  Created by Eric Groom on 12/6/24.
//

struct Day6: Day {
    let input: Lab

    typealias Input = Lab

    struct Lab {
        let map: Grid<Tile>
        var `guard`: Guard
    }

    enum Tile {
        case empty
        case obstructed
    }

    struct Guard {
        var position: Vec2D
        var heading: Direction
    }

    static let example: String = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    static func parse(_ string: String) -> Lab {
        let charsGrid = string.split(separator: "\n").map(Array.init)
        var map = [Vec2D: Tile]()
        var `guard`: Guard!
        for (y, row) in charsGrid.enumerated() {
            for (x, char) in row.enumerated() {
                let coord = Vec2D(x: x, y: y)
                switch char {
                case "#": map[coord] = .obstructed
                case ".": map[coord] = .empty
                case "^":
                    map[coord] = .empty
                    `guard` = Guard(position: coord, heading: .up)
                default: fatalError("unknown input \(char)")
                }
            }
        }
        return Lab(map: Grid(data: map), guard: `guard`)
    }

    func part1() -> String {
        var lab = input
        var visited: Set<Vec2D> = []
        repeat {
            print(lab.guard.position)
            visited.insert(lab.guard.position)
            advanceGuard(&lab)
        } while lab.map[lab.guard.position] != nil
        return String(visited.count)
    }
    
    func part2() -> String {
        ""
    }

    private func advanceGuard(_ lab: inout Lab) {
        let nextCoord = lab.guard.position + lab.guard.heading.unitVector
        switch lab.map[nextCoord] {
        case .empty, nil:
            print("empty")
            lab.guard.position = nextCoord
        case .obstructed:
            print("obstructed")
            lab.guard.heading = lab.guard.heading.rotatedClockwise().rotatedClockwise()
        }
    }
}
