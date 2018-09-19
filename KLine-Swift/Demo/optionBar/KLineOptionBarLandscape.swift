//
//  KLineOptionBarLandscape.swift
//  test
//
//  Created by xieran on 2018/9/19.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineOptionBarLandscape: KLineOptionBarPortrait {
    override var viewWidth: CGFloat {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    override var btnsPerRow: CGFloat {
        return 7.0
    }
    override var viewHeight: CGFloat {
        return KLineTools.landscapeOptionBarHeight
    }
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buttonArray(at indexPath: IndexPath) -> [KLineOptionButton] {
        switch state {
        case .normal:
            return normalButtons
        case.showMorePeriods:
            if indexPath.row == 0 {
                return otherPeriods
            } else {
                return normalButtons
            }
        case .showMoreIndicators:
            return []
        }
    }
    
    override func cellColor(at indexPath: IndexPath) -> UIColor {
        if self.state == .normal {
            return bgColor
        } else {
            return indexPath.row == 1 ? bgColor : .black
        }
    }
    
    override func getNormalButtons() -> [KLineOptionButton] {
        return [timeLineBtn,
                periodBtnMap[PeriodType.min1]!,
                periodBtnMap[PeriodType.min15]!,
                periodBtnMap[PeriodType.min60]!,
                periodBtnMap[PeriodType.day1]!,
                periodBtnMap[.week1]!,
                moreBtn]
    }
    
    override func getOtherPeriods() -> [KLineOptionButton] {
        return [periodBtnMap[.min30]!,  periodBtnMap[.month1]!]
    }
    
}
