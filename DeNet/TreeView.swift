//
//  ContentView.swift
//  DeNet
//
//  Created by Dmitry Martynov on 15.11.2023.
//

import SwiftUI

struct TreeView: View {
  
  @ObservedObject var viewModel: TreeViewModel
  @State var isSheet: Bool = false
  
  var body: some View {
    
    VStack(spacing: 6) {
      
      HStack {
        Button(action: viewModel.upLevel) {
          Image(systemName: "arrow.up.circle")
            .resizable()
            .frame(width: 32, height: 32)
            //.fontWeight(.thin)
        }.disabled(viewModel.currentNode.level == 0)
        
        Spacer()
        
        Text("Level: \(viewModel.currentNode.level)")
        Text("Child: \(viewModel.currentNode.children.count)")
        Spacer()
        
        Button(action: {
          viewModel.reduceMap()
          self.isSheet = true
        }) {
          Image(systemName: "map.circle")
            .resizable()
            .frame(width: 32, height: 32)
            //.fontWeight(.thin)
        }
      }
      Text(viewModel.currentNode.value)
      
      ScrollView(showsIndicators: true) {
        LazyVStack(alignment: .leading, spacing: 15) {
          ForEach(viewModel.children) { node in
            
            Button(node.id) {
              
              viewModel.nodeTap(id: node.id)
            }
          }
        }
      }
      .padding(.vertical)
    }
    .lineLimit(1)
    .overlay(alignment: .bottom) {
      
      Button(action: viewModel.addChild) {
        Image(systemName: "plus.circle")
          .resizable()
          .frame(width: 42, height: 42)
          //.fontWeight(.thin)
      }
    }
    
    .sheet(isPresented: $isSheet) {
      
      ScrollViewReader { proxy in
        ScrollView([.vertical, .horizontal], showsIndicators: true) {
          
          VStack(alignment: .leading) {
        
            ForEach(viewModel.treeMap) { node in
              
              Button(action: {
                self.isSheet = false
                viewModel.nodeTap(id: node.id)
              }) {
                Text(node.id)
                  .padding(.leading, CGFloat(node.level * 22))
                  .lineLimit(1)
                
              }
              .padding(.vertical,3)
              .background(viewModel.currentNode.value == node.id ? Color.orange : Color.clear)
              .id(node.id)
            }
          }
          
        }.onAppear { proxy.scrollTo(viewModel.currentNode.value)}
      }
      .overlay(alignment: .topTrailing) {
        Button(action: { self.isSheet = false }) {
          Image(systemName: "xmark.circle")
            .resizable()
            .frame(width: 32, height: 32)
            //.fontWeight(.thin)
        }.padding(.horizontal)
      }.padding()
    }
    .font(.body)
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      TreeView(viewModel: .init())
    }
}
