//
//  TreeParentView.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 18/01/24.
//

import SwiftUI
import Combine
public enum TreeNodeViewType:String{
    case jsonDictionary = "Dictionary"
    case jsonArray = "Array"
    case other = "Other"
}
public protocol TreeNodeViewExpandable{
    func expand(should:Bool)
}
public struct TreeParentView: View {
    @Binding var doRefresh:PassthroughSubject<Bool, Never>
    @ObservedObject var vm:JsonTreeNodeViewModel
    
    var blueColor = Color(red: 16.0/255.0, green: 23.0/255.0, blue: 116.0/255.0)
    var shineColor = Color(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0)

    public var body: some View {
        HStack{
            ForEach((0..<vm.depth), id: \.self) {_ in
                treeParentBranch
                
            }
            //Spacer().frame(width: 15, height: 10)
            if vm.isLast && vm.isExpanded {
                treeLastChildExpanded
            }else if vm.isLast{
                treeLastChild
            }
            else{
                treeElbow
            }
            
            onOffButton
            image
            Text(vm.key).font(.custom("Helvetica", size: 12.0))
            Spacer()
        }
        .padding(.all, 0)
    }
    var onOffButton: some View{
        Button(action: {
            vm.isExpanded = !vm.isExpanded
            vm.expand(should: vm.isExpanded)
            doRefresh.send(true)

        }, label: {
            HStack{
                Text(vm.isExpanded ? "--" : "+")
                    .foregroundStyle(blueColor)
                    .font(.custom("Helvetica", size: 12.0))
            }
            .frame(width: 14, height: 14)
        })
        .background(shineColor.gradient)
        .controlSize(.mini)
        .overlay(RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 1))
    }
    var image: some View{
        
        return myImage(name:vm.type == .jsonArray ? "array" : "object").resizable().frame(width: 16, height: 16)
    }
    var treeElbow: some View{
        VStack(spacing:0){
            VStack(spacing:0){
                myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
            }
            Image("treeArrow", bundle: myResourceBundle).resizable().frame(width: 15, height: 1)
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
    var treeLastChildExpanded: some View{
        VStack(spacing:0){
            VStack(spacing:0){
                myImage(name:"treeParentBranchTile").resizable(resizingMode: .tile).frame(width: 15)
            }.layoutPriority(1)
            
            myImage(name:"treeArrow").resizable().frame(width: 15, height: 1).layoutPriority(1)
            
            VStack{
                Spacer()
                myImage(name:"lineCross1").resizable().frame(width: 15, height: 3)
                
            }.layoutPriority(1)
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
////    TreeParentView(vm: TreeParentViewModel(type: .array, id: 1, key: "ArrayType", jsonObject: [1,2,3,4,5,6], depth: 0))
////    TreeParentView(vm: TreeParentViewModel(type: .dictionary, id: 1, key: "DictionaryType", jsonObject: ["a1":"sdfsd", "a2": [1,2,3]], depth: 0))
//}
