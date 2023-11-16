//
//
//  TreeDomain.swift
//
//  Created by Dmitry Martynov on 15.11.2023.
//

import Foundation

final class TreeNode: Codable {
    var value: String

    weak var parent: TreeNode?
    var children = [TreeNode]()
    var level: Int = 0

    init(value: String) {
        self.value = value
    }

    func forEachDepth(work: (TreeNode) -> Void) {
        
        work(self)
        children.forEach { $0.forEachDepth(work: work) }
    }
        
    func forEachLevel(work: (TreeNode) -> Void) {
        
        work(self)
        var queue = children
        
        while let node = queue.first {
            work(node)
            queue.append(contentsOf: node.children)
            queue = Array(queue.dropFirst())
        }
    }
    
    func search(_ value: String, withChildren: Bool) -> TreeNode? {
        var result: TreeNode?
        forEachLevel { node in
            if node.value == value,
               node.children.isEmpty != withChildren { result = node }
        }
        return result
    }
    
  func addChild(_ node: TreeNode) {
      children.append(node)
      node.parent = self
      node.forEachLevel {
          $0.level = ($0.parent?.level ?? 0) + 1
      }
  }
  
  private enum CodingKeys : String, CodingKey {
    case value
    case children
    case level
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(value, forKey: .value)
    try container.encode(children, forKey: .children)
    try container.encode(level, forKey: .level)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.value = try container.decode(String.self, forKey: .value)
    self.level = try container.decode(Int.self, forKey: .level)
    self.children = try container.decode([TreeNode].self, forKey: .children)

    for child in children {
        child.parent = self
    }
  }
    
}

extension TreeNode: CustomStringConvertible {
  var description: String {
    var s = "\(value)"
    if !children.isEmpty {
        s += " {" + children.map { $0.description + "-\($0.level)" }.joined(separator: ", ") + "}"
    }
    return s
  }
}

extension TreeNode: Equatable {
    static func ==(lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.value == rhs.value
    }
}

