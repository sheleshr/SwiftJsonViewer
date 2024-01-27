//
//  TreeChildView.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 18/01/24.
//

import SwiftUI
import Combine
struct TreeChildView: View {
    @Binding var doRefresh:PassthroughSubject<Bool, Never>
     var vm:JsonTreeNodeViewModel
    
    var body: some View {
        HStack{
            ForEach((0..<vm.depth), id: \.self) {_ in
                treeParentBranch
                
            }
            if vm.isLast {
                treeLastChild
            }else{
                treeElbow
            }
            
            image
            
            keyValue
            
            Spacer()
        }
        .padding(.all, 0)
    }
    var image: some View{
        myImage(name:"green").resizable().frame(width: 16, height: 16)
    }
    var treeElbow: some View{
        VStack(spacing:0){
            VStack(spacing:0){
                myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
            }
            Image("treeArrow").resizable().frame(width: 15, height: 1)
            VStack(spacing:0){
                myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
            }
        }
    }
    var treeParentBranch: some View{
        VStack(spacing:0){
            myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
        }
    }
    var treeLastChild: some View{
        VStack(spacing:0){
            VStack(spacing:0){
                myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
            }.layoutPriority(1)
            myImage(name:"treeArrow").resizable().frame(width: 15, height: 1)
            Spacer().layoutPriority(1)
           
        }
    }
    var keyValue:some View{
        HStack{
            if let keyStr = vm.key.toString() as? String{
                Text(keyStr).font(.custom("Helvetica", size: 12.0))
            }
            
            Text(":").font(.custom("Helvetica", size:12.0))
            
            if let valueStr = vm.jsonObject?.toString() as? String{
                    Text(valueStr)
                        .font(.custom("Helvetica", size: 12.0))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    var myResourceBundle: Bundle{
        return Bundle(for: JsonTreeViewModel.self)
    }
    func myImage(name:String)->Image{
        Image(name, bundle: myResourceBundle)
    }
}

//#Preview {
////    TreeChildView(vm: TreeChildViewModel(type:.other,id: 1, key: "0", depth: 0))
//}
