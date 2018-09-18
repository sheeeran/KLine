//
//  KLineTools.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineTools: NSObject {
    static let landscapeNavBarHeight: CGFloat = 50.0
    static let landscapeOptionBarHeight: CGFloat = 40.0
    static var rightIndicatorViewHeight: CGFloat {
        return min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) - landscapeNavBarHeight - 2 * landscapeOptionBarHeight - 10
    }
    
    //选择时间
    static let times: [String] = ["1", "5", "15", "30","60", "240", "1D", "1W", "1M"]
}
