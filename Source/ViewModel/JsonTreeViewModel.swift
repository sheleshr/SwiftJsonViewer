//
//  JsonTreeViewModel.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 18/01/24.
//

import Foundation
import SwiftUI
import Combine


public class JsonTreeNodeViewModel:Identifiable, ObservableObject{
    public var id:Int
    public var key: String
    public var jsonObject:JsonData?
    public var depth:Int
    public var type:TreeNodeViewType
    public var isLast:Bool
    
    @Published public var isExpanded = false
    
    public init(id: Int, key: String, jsonObject: JsonData?, depth: Int, type: TreeNodeViewType, isLast:Bool) {
        self.id = id
        self.key = key
        self.jsonObject = jsonObject
        self.depth = depth
        self.type = type
        self.isLast = isLast
        
        if let dic = jsonObject as? NSDictionary{
            isExpanded = dic.value(forKey: "__isExpanded__") as? String == "true" ? true : false
        }
        
    }
    
    func expand(should: Bool) {
        if should { // Expand
            doExpand()
        }else{  // Collapse
            doCollapse()
        }
    }
    private func doExpand(){
        if let dic = jsonObject as? NSDictionary{
            dic.setValue("true", forKey: "__isExpanded__")
            
        }
    }
    private func doCollapse(){
        if let dic = jsonObject as? NSDictionary{
            dic.setValue("false", forKey: "__isExpanded__")
        }
    }
}


public class JsonTreeViewModel:ObservableObject{
    var object:JsonData?
    @Published var list: [JsonTreeNodeViewModel]
    var refreshEvent = PassthroughSubject<Bool, Never>()
    
    var cancellable = [AnyCancellable]()
    
    private var uniqueIdentifier = 0
    private var tempList = [JsonTreeNodeViewModel]()
    
    public init(object: JsonData?, list: [JsonTreeNodeViewModel] = [JsonTreeNodeViewModel]()) {
        self.object = object
        self.list = list
        
        refreshEvent.sink { shouldOn in
            self.loadData()
         }.store(in: &cancellable)
    }
    func prepareData(){
          object =  traverseAndConvertJsonData(element: object)
       
    }
    func traverseAndConvertJsonData(element:JsonData?) -> JsonData?{
        
        if element?.type == .array {
            let dic  = element?.toDictionary()
            dic?.set(value: "Array", forKey: "__ELEMENT_TYPE__")
            _ = traverseAndConvertJsonData(element: dic)
            return dic
        }
        else if element?.type == .object,
                    let keyValue = (element as? (JsonData & KeyValueComplaint)),
                let arrKey = (keyValue.allKeys() as? NSArray){
            for key in arrKey{
                if let k = key as? JsonData,  let obj = keyValue.getValue(forKey: k){
                    if obj.type == .array{
                        let d = obj.toDictionary()
                        (element as? KeyValueComplaint)?.set(value: d ?? NSNull(), forKey: k)
                        
                        _ = traverseAndConvertJsonData(element: d)
                    }
                    else if obj.type == .object{

                        _ = traverseAndConvertJsonData(element: obj)
                    }
                }
            }
            return element
        }
        return element

    }
    
    func loadData(){
        
        if let dic = object as? (JsonData & KeyValueComplaint){
            var treeNodeViewType = TreeNodeViewType.other
            var isExpanded = false
            
            
            let myType = dic.getValue(forKey: "__ELEMENT_TYPE__") as? String
            if myType == nil{
                dic.set(value: "Dictionary", forKey: "__ELEMENT_TYPE__")
            }

            treeNodeViewType = TreeNodeViewType(rawValue: myType ?? "Dictionary") ?? .other
            isExpanded = dic.getValue(forKey: "__isExpanded__") as? String == "true" ? true : false
            
            let vm1 = TreeParentViewModel(id: uniqueIdentifier, key: "JSON", jsonObject: dic , depth: 0, type: treeNodeViewType, isLast: true)
            uniqueIdentifier += 1
            tempList.append(vm1)
            
            if isExpanded{
                updateListOfTreeNodeViewModel(rootDic: dic, nodeLevel: 1)
            }else{
                
            }
                  
            list = tempList
            tempList = [JsonTreeNodeViewModel]()
        }
    }
    
    func updateListOfTreeNodeViewModel(rootDic:(any JsonData)?, nodeLevel:Int ){
        
        if let dic = rootDic?.toDictionary() {
            
            guard let allKeys = dic.allKeys()?.sort(by: { obj1, obj2 in
                return (obj1.toString() as! String) < (obj2.toString() as! String)
            }) as? NSArray
            else {return}
            
            let totalKeyCount = allKeys.count
            let totalExtraKeyCount = 2      // 1. __ELEMENT_TYPE__, 2. __isExpanded__
//            let actualDataKeyCount = totalKeyCount - totalExtraKeyCount
            var extraKeyRemainingToFound = totalExtraKeyCount
            
//            for (i, key) in allKeys.enumerated(){
            var i = 0
            while(i < allKeys.count){
             
            let key = allKeys.object(at: i)
               
            if let keyStr = key as? String
            {
                
                if let obj = dic.getValue(forKey: keyStr), 
                    obj.type == .object,
                   let objDic = obj as? (JsonData & KeyValueComplaint)
                {
                    
                    var treeNodeViewType = TreeNodeViewType.other
                    var isExpanded = false
        
                    let myType = objDic.getValue(forKey: "__ELEMENT_TYPE__") as? String
                    
                    if myType == nil{
                        objDic.set(value: "Dictionary", forKey: "__ELEMENT_TYPE__")
                    }
                    treeNodeViewType = TreeNodeViewType(rawValue: (myType) ?? "Dictionary") ?? .other
                    isExpanded = objDic.getValue(forKey: "__isExpanded__") as? String == "true" ? true : false
                    
                    let lastNode = i==((totalKeyCount-1)-extraKeyRemainingToFound)//allKeys.count-2
                    
                    let vm1 = TreeParentViewModel(id: uniqueIdentifier, key: keyStr, jsonObject: objDic , depth: nodeLevel, type: treeNodeViewType,isLast: lastNode)
                    uniqueIdentifier += 1
                    tempList.append(vm1)
                    
                    if isExpanded {
                        updateListOfTreeNodeViewModel(rootDic:obj, nodeLevel: nodeLevel+1)
                    }else{
                        
                    }
                }
                else if let obj = dic.getValue(forKey: keyStr)
                {
                    if keyStr == "__ELEMENT_TYPE__" || keyStr == "__isExpanded__" {
                        extraKeyRemainingToFound -= 1
                        i += 1
                        continue
                    }
                    
                    let lastNode = i==((totalKeyCount-1)-extraKeyRemainingToFound)//allKeys.count-2
                    let vm1 = TreeChildViewModel(type: .other, id: uniqueIdentifier, key: keyStr, depth: nodeLevel, object: obj,isLast: lastNode)
                    uniqueIdentifier += 1
                    tempList.append(vm1)
                }else{
                    if keyStr == "__ELEMENT_TYPE__" || keyStr == "__isExpanded__" {
                        extraKeyRemainingToFound -= 1
                        i += 1
                        continue
                    }
                    
                    let lastNode = i==((totalKeyCount-1)-extraKeyRemainingToFound)//allKeys.count-2
                    let vm1 = TreeChildViewModel(type: .other, id: uniqueIdentifier, key: keyStr, depth: nodeLevel, object: NSNull(), isLast: lastNode)
                    uniqueIdentifier += 1
                    tempList.append(vm1)
                }
                
                
            }
                i += 1
        }
    }
    
    }
    }
