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
    
    var type: PeriodType = .min1
    var title: String {
        switch self.type {
        case .min1:
            return "1分"
        case .min15:
            return "15分"
        case .min30:
            return "30分"
        case .min60:
            return "1小时"
        case .day1:
            return "1天"
        case .week1:
            return "周线"
        case .month1:
            return "1月"
        }
    }
    var period: String {
        switch self.type {
        case .min1:
            return "1"
        case .min15:
            return "15"
        case .min30:
            return "30"
        case .min60:
            return "60"
        case .day1:
            return "1D"
        case .week1:
            return "1W"
        case .month1:
            return "1M"
        }
    }
    
    init(type: PeriodType) {
        self.type = type
    }
}
