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
        return UIScreen.main.bounds.height - landscapeNavBarHeight - 2 * landscapeOptionBarHeight - 10
    }
    
    enum BarState {
        case normal
        case showMorePeriods
        case showMoreIndicators
    }
}
