//
//  ViewController.swift
//  SwiftJsonViewer
//
//  Created by sheleshr on 01/27/2024.
//  Copyright (c) 2024 sheleshr. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftJsonViewer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showJsonViewer(_ sender: Any) {
        let view = JsonTreeView(vm: JsonTreeViewModel(object: loadDefaultData()))
        let hostingView = UIHostingController(rootView: view)
        hostingView.modalPresentationStyle = .fullScreen
        self.present(hostingView, animated: true)
    }
    
    private func loadDefaultData() -> JsonData? {
        if let filePath = Bundle.main.path(forResource: "data", ofType: "json"){
            guard let data = FileManager.default.contents(atPath: filePath)
            else {
                fatalError("Can not load file at: \(filePath)")
            }
            
            if let obj = try? JSONSerialization.jsonObject(with: data,options: .mutableContainers),
               var object = (obj as? any JsonData)?.mutableContainer()
            {

                return object
            }
        }
        return nil
    }

}

