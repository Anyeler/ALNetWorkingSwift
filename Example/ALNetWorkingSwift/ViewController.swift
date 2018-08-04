//
//  ViewController.swift
//  ALNetWorkingSwift
//
//  Created by Anyeler on 08/04/2018.
//  Copyright (c) 2018 Anyeler. All rights reserved.
//

import UIKit
import ALNetWorking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getAction(_ sender: UIButton) {
        ALNetHTTPRequestOperationManager.request(url: "https://www.baidu.com") { (response: ALResult<ALNetHTTPResponseAny>) in
            switch response {
            case .success(let res):
                print(res)
            case .failure(let err):
                print(err)
                
            }
        }
    }
}

