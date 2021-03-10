//
//  ViewController.swift
//  Metal_Triangle
//
//  Created by hyq on 2021/3/10.
//

import UIKit

class ViewController: UIViewController {
    
    var metalView: MetalView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        metalView = MetalView(frame: view.bounds)
        view.addSubview(metalView)
    }


}

