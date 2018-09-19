//
//  KLinePeriod.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLinePeriod {
    enum PeriodType {
        case min1
        case min15
        case min30
        case min60
        case day1
        case week1
        case month1
    }
    
    var title = ""
    var value = ""

    init(type: PeriodType) {
        switch type {
        case .min1:
            title = "1分"
            value = "1"
        case .min15:
            title = "15分"
            value = "15"
        case .min30:
            title = "30分"
            value = "30"
        case .min60:
            title = "1小时"
            value = "60"
        case .day1:
            title = "1天"
            value = "1D"
        case .week1:
            title = "周线"
            value = "1W"
        case .month1:
            title = "1月"
            value = "1M"
        }
    }
}
