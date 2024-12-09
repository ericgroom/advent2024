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

    struct Block {
        let kind: BlockKind
        var size: Int
    }
    enum BlockKind {
        case file(id: Int)
        case empty

        var isFile: Bool {
            switch self {
            case .empty: return false
            case .file: return true
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
            if isFile {
                result.append(Block(kind: .file(id: nextId), size: length))
                nextId += 1
            } else {
                result.append(Block(kind: .empty, size: length))
            }
            isFile.toggle()
        }
        return result
    }

    func part1() -> String {
        var blocks = input
        while hasGaps(blocks) {
            blocks = defragStep(blocks)
        }
        return String(checksum(blocks))
    }

    private func checksum(_ blocks: [Block]) -> Int {
        var position = 0
        var blockIndex = 0
        var checksum = 0
        while blockIndex < blocks.endIndex {
            defer { blockIndex += 1 }
            let block = blocks[blockIndex]
            var remaining = block.size
            while remaining > 0 {
                let multiplier = switch block.kind {
                case .empty: 0
                case .file(let id): id
                }
                checksum += multiplier * position
                remaining -= 1
                position += 1
            }
        }
        return checksum
    }

    private func hasGaps(_ blocks: [Block]) -> Bool {
        let firstEmptyIndex = blocks.firstIndex { !$0.kind.isFile }!
        return blocks[firstEmptyIndex...].contains(where: { $0.kind.isFile })
    }

    private func defragStep(_ blocks: [Block]) -> [Block] {
        var blocks = blocks
        let rightmostFileIndex = blocks.lastIndex(where: { $0.kind.isFile })!
        let leftmostEmptyIndex = blocks.firstIndex(where: { !$0.kind.isFile })!
        let file = blocks[rightmostFileIndex]
        let empty = blocks[leftmostEmptyIndex]
        let newSize = min(file.size, empty.size)
        let newFileBlock = Block(kind: file.kind, size: newSize)
        let newEmptyBlock = Block(kind: .empty, size: newSize)
        if newSize == file.size {
            blocks.remove(at: rightmostFileIndex)
        } else {
            blocks[rightmostFileIndex].size -= newSize
        }
        if newSize == empty.size {
            blocks[leftmostEmptyIndex] = newFileBlock
        } else {
            blocks[leftmostEmptyIndex].size -= newSize
            blocks.insert(newFileBlock, at: leftmostEmptyIndex)
        }
        blocks.append(newEmptyBlock)
        return blocks
    }

    func part2() -> String {
        return ""
    }

    private func debugString(_ blocks: [Block]) -> String {
        var result: String = ""
        for block in blocks {
            var remaining = block.size
            while remaining > 0 {
                defer { remaining -= 1 }
                switch block.kind {
                case .file(let id):
                    result += "\(id)"
                case .empty:
                    result += "."
                }
            }
        }
        return result
    }

    static let example: String = "2333133121414131402"
    static let exampleSimple: String = "12345"
}
