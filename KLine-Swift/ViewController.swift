//
//  ViewController.swift
//  KLine-Swift
//
//  Created by xieran on 2018/9/10.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.center = view.center
        btn.setTitle("push", for: .normal)
        btn.addTarget(self, action: #selector(push), for: .touchUpInside)
        btn.backgroundColor = .red
        view.addSubview(btn)
    }
    
    @objc func push() {
        let vc = ChartCustomViewController()
        vc.marketType = "BTC/USDT"
        vc.marketId = 4001
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
