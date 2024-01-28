//
//  Extension.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 24/01/24.
//

import Foundation

public enum JsonDataType{
    case object
    case array
    case other
}
public protocol JsonData {
    func toString() -> JsonData
    var type:JsonDataType{get}
    func object() -> Self
    func mutableContainer()->JsonData
    func toDictionary() -> (JsonData & KeyValueComplaint)?
}
public extension JsonData {
    func toString() -> JsonData {
        return "\(self)"
    }
    var type:JsonDataType{
        get{
            return .other
        }
    }
    func object() -> Self {
        return self
    }
    func mutableContainer()->JsonData {
        if Self.self == NSDictionary.self {
            return (self as! NSDictionary).mutableCopy() as! NSDictionary
        }else if Self.self == NSArray.self {
            return (self as! NSArray).mutableCopy() as! NSArray
        }else{
            return self
        }
    }
    func toDictionary()-> (JsonData & KeyValueComplaint)?{
        if self.type == .object
        {
            return (self as? NSDictionary)
        }
        else if self.type == .array{
            let dic = NSMutableDictionary()
            dic.setValue("false" as JsonData, forKey: "__isExpanded__")
           
            if let arr = self as? NSArray {
                dic.setValue("Array", forKey: "__ELEMENT_TYPE__")
                let c = arr.count
                let digitCount = "\(c)".count
                for (offset, element) in arr.enumerated(){
                    let kyStr = String(format: "%0\(digitCount)d", offset)
                    dic.setValue(element, forKey: kyStr)
                }
            }
            return dic
        }else{
            return nil
        }
    }
    func sort(by:(_ obj1:JsonData, _ obj2:JsonData)->Bool) -> JsonData?{
        if self.type == .array{
            let arr = NSMutableArray(array: (self as? NSArray) ?? NSMutableArray())
            var i = 0
            
            while(i < arr.count-1){
                var  j = i+1
                while(j < arr.count){
                    if by(arr.object(at: i) as! JsonData, arr.object(at: j) as! JsonData) == false {
                        let temp = arr.object(at: i)
                        arr[i] = arr.object(at: j)
                        arr[j] = temp
                    }
                    j += 1
                }
                i += 1
            }
            return arr
        }
        return nil
    }
}

extension NSNull:JsonData{
    
}
extension NSString:JsonData{}
extension NSNumber:JsonData{}
extension NSDictionary:JsonData{
    public var type:JsonDataType{
        get{
            return .object
        }
    }
}
extension NSArray:JsonData{
    public var type:JsonDataType{
        get{
            return .array
        }
    }
}
extension Bool:JsonData{}
extension String:JsonData{}
extension Int:JsonData{}
//-----------------------------------------
public protocol KeyValueComplaint{
    func set(value:JsonData, forKey key:JsonData)
    func getValue(forKey key:JsonData) -> JsonData?
    func allKeys() -> JsonData?
}
extension NSDictionary:KeyValueComplaint{
    public func set(value: JsonData, forKey key: JsonData) {
        self.setValue(value, forKey: key.toString() as! String)
    }
    
    public func getValue(forKey key: JsonData) -> JsonData? {
        self.value(forKey: key.toString() as! String) as? any JsonData
    }
    public func allKeys() -> JsonData?{
        return (self.allKeys as NSArray)
    }
}
