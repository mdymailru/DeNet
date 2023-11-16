//
//  TreeViewModel.swift
//  TreeRange
//
//  Created by Dmitry Martynov on 15.11.2023.
//

import SwiftUI
import Combine

class TreeViewModel: ObservableObject {
    
  @Published var children: [Item]
  @Published var currentNode: TreeNode
    
  var treeMap = [Item]()
  
  private var model = Model()
    
  init() {
    self.currentNode = model.tree
    self.children = Self.reduceChildren(node: model.tree)
  }
    
    struct Item: Identifiable {
      let id: String
      let level: Int
    }
  
  func nodeTap(id: String) {
    
    guard let selectedNode = model.cache[id] else {return}
    withAnimation {
      self.currentNode = selectedNode
      self.children = Self.reduceChildren(node: selectedNode)
    }
  }
  
  func upLevel() {
    guard let upNode = self.currentNode.parent 
    else { return }
    withAnimation {
      self.currentNode = upNode
      self.children = Self.reduceChildren(node: upNode)
    }
  }
  
  func addChild() {
    
    let nodeName = model.addChild(currentNode)
  
    withAnimation {
      self.children.append(.init(id: nodeName,
                                 level: self.currentNode.level))
    }
  }
   
  func reduceMap() {
    
    self.treeMap = []
    model.tree.forEachDepth { node in
      self.treeMap.append(.init(id: node.value, level: node.level))
    }
  }
  
  private static func reduceChildren(node: TreeNode) -> [TreeViewModel.Item] {
    
    return node.children.map { TreeViewModel.Item(id: $0.value,
                                                  level: $0.level) }
  }
  

}
