//
//  TreeChildViewModel.swift
//  ExampleJSONViewFirst
//
//  Created by Administrator on 18/01/24.
//

import Foundation
import SwiftUI

public class TreeChildViewModel: JsonTreeNodeViewModel{

    private var object:(any JsonData)?
    
    public init(type: TreeNodeViewType,id: Int, key: String, depth: Int, object: (any JsonData)?, isLast:Bool) {
        super.init(id: id, key: key, jsonObject: NSNull(), depth: depth, type: type, isLast: isLast)

        self.object = object
    }
    public override var jsonObject:JsonData?{
        get{
            return object?.toString()
        }
        set{
            
        }
    }

}
