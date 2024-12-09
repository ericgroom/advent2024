//
//  day9.swift
//  advent2024
//
//  Created by Eric Groom on 12/9/24.
//

import Foundation

struct Day9: Day {
    var input: [Block]
    
    typealias Input = [Block]

    enum Block: Equatable {
        case file(id: Int)
        case empty

        var isFile: Bool {
            switch self {
            case .empty: return false
            case .file: return true
            }
        }

        func hasId(_ testId: Int) -> Bool {
            switch self {
            case .empty: return false
            case .file(let id): return id == testId
            }
        }
    }

    static func parse(_ string: String) -> [Block] {
        var isFile: Bool = true
        var nextId: Int = 0
        var result = [Block]()
        for char in Array(string) {
            if char == "\n" { continue }
            let length = Int(String(char))!
            let block = if isFile {
                Block.file(id: nextId)
            } else {
                Block.empty
            }
            for _ in 0..<length {
                result.append(block)
            }
            if isFile {
                nextId += 1
            }
            isFile.toggle()
        }
        return result
    }

    func part1() -> String {
        var blocks = input
        var lhs = blocks.startIndex
        var rhs = blocks.endIndex-1
        while rhs >= blocks.startIndex && lhs < blocks.endIndex && rhs >= lhs {
            defer { rhs -= 1 }
            switch blocks[rhs] {
            case .empty: continue
            case .file(id: let id):
                toNextEmptyBlock(from: &lhs, in: blocks)
                if lhs >= blocks.endIndex || rhs < lhs { break }
                blocks[lhs] = .file(id: id)
                blocks[rhs] = .empty
            }
        }
        return String(checksum(blocks))
    }

    private func toNextEmptyBlock(from start: inout Int, in blocks: borrowing [Block]) {
        while start < blocks.endIndex && blocks[start].isFile  { start += 1 }
    }

    private func firstEmptyBlockIndex(of size: Int, in blocks: ArraySlice<Block>) -> Int? {
        var index = blocks.startIndex
        while index < blocks.endIndex {
            let length = lengthOfBlock(startingAt: index, in: blocks)
            let block = blocks[index]
            if !block.isFile && length >= size { return index }
            index = index + length
        }
        return nil
    }

    private func checksum(_ blocks: [Block]) -> Int {
        blocks.enumerated()
            .map {
                switch $0.element {
                case .empty: 0
                case .file(let id): id * $0.offset
                }
            }
            .reduce(0, +)
    }

    func part2() -> String {
        var blocks = input
        var lhs = blocks.startIndex
        var rhs = blocks.endIndex-1
        var minFileIdSeen = Int.max
        while rhs >= blocks.startIndex {
            defer { rhs -= 1 }
            switch blocks[rhs] {
            case .empty: continue
            case .file(id: let id):
                if id > minFileIdSeen { continue }
                minFileIdSeen = min(id, minFileIdSeen)
                toNextEmptyBlock(from: &lhs, in: blocks)
                if lhs >= blocks.endIndex { break }
                toStartOfBlock(at: &rhs, in: blocks)
                let fileLength = lengthOfBlock(startingAt: rhs, in: blocks[...])
                if let emptyBlockIndex = firstEmptyBlockIndex(of: fileLength, in: blocks[lhs...]), emptyBlockIndex < rhs {
                    var offset = 0
                    while offset < fileLength {
                        defer { offset += 1 }
                        blocks[emptyBlockIndex + offset] = .file(id: id)
                        blocks[rhs + offset] = .empty
                    }
                }
            }
        }
        return String(checksum(blocks))
    }

    private func toStartOfBlock(at index: inout Int, in blocks: [Block]) {
        let value = blocks[index]
        while index > blocks.startIndex && blocks[index-1] == value { index -= 1 }
    }

    private func lengthOfBlock(startingAt index: Int, in blocks: ArraySlice<Block>) -> Int {
        let value = blocks[index]
        return blocks[index...].prefix { $0 == value }.count
    }

    private func debugString(_ blocks: some Sequence<Block>) -> String {
        blocks.map { block in
            switch block {
            case .empty: "."
            case .file(let id): "\(id)"
            }
        }.reduce("", +)
    }

    static let example: String = "2333133121414131402"
    static let exampleSimple: String = "12345"
}
