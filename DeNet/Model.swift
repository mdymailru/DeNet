//
//  Model.swift
//  TreeRange
//
//  Created by Dmitry Martynov on 16.07.2023.
//
import Foundation

final class Model {
    
  let tree: TreeNode
  var cache = [String: TreeNode]()
  
  static let root = "root"
  
  init() {
    self.tree = Self.loadTree()
    initCache()
  }
  
  func addChild(_ node: TreeNode) -> String {
    
    let nodeName = getNodeName()
    let childNode = TreeNode(value: nodeName)
    node.addChild(childNode)
    self.cache[nodeName] = childNode
    
    saveDataTree()
    return nodeName
  }
  
  private func saveDataTree() {
    
    let encoder = JSONEncoder()
    
    guard let json = try? encoder.encode(self.tree),
          let jsonStr = String(data: json, encoding: String.Encoding.utf8)
    else { return }
   
    UserDefaults.standard.set(json, forKey: Self.root)
    print(jsonStr)
    
  }
  
  private static func loadTree() -> TreeNode {
    let decoder = JSONDecoder()
    
    guard let data = UserDefaults.standard.object(forKey: Self.root) as? Data,
          let savedTree = try? decoder.decode(TreeNode.self, from: data)
    else { return .init(value: Self.root) }
    
    print(savedTree.description)
    return savedTree
  }
  
  private func initCache() {
    self.cache[Self.root] = self.tree
    self.tree.forEachDepth { node in
      self.cache[node.value] = node
    }
  }
  
  private func getNodeName() -> String {
    
    let hexDigits = Array("0123456789ABCDEF")
    var str = [Character]()
    (0...40).forEach { _ in
      
      str.append(hexDigits.randomElement()!)
    }
    return String(str)
  }
}
