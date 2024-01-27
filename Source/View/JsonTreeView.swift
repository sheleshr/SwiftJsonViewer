//
//  ContentView.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 18/01/24.
//

import SwiftUI

public struct JsonTreeView: View {
    @ObservedObject var vm: JsonTreeViewModel
    
    public init(vm: JsonTreeViewModel) {
        self.vm = vm
    }
    
    public var body: some View {
       
                List(vm.list) { treeNodeVM in
                    if treeNodeVM.jsonObject?.type != .other {
                        TreeParentView(doRefresh:$vm.refreshEvent, vm: treeNodeVM)
                            .listRowSeparator(.hidden, edges: .top)
                            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 2))
                            .lineSpacing(0)
                    }else{
                        TreeChildView(doRefresh:$vm.refreshEvent, vm: treeNodeVM)
                            .listRowSeparator(.hidden, edges: .top)
                            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 2))
                            .lineSpacing(0)
                    }
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 20)                
                .onAppear(perform: {
                    
                    vm.prepareData()
                    vm.loadData()
                })
            
    }
}

//#Preview {
//    JsonTreeView(vm: JsonTreeViewModel(object: loadDefaultData()))
//}


