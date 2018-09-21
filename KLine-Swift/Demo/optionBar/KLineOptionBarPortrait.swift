//
//  TimeBar.swift
//  KLine-Swift
//
//  Created by xieran on 2018/9/10.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import SnapKit

protocol KLineOptionDelegate: class {
    func selectTimeLine()
    func selectPeriod(_ period: String)
    func selectAssitIndicator(_ indicator: String)
}

class KLineOptionBarPortrait: UICollectionView {
    weak var optionDelegate: KLineOptionDelegate?
    var state: KLineTools.BarState = .normal {
        didSet {
            guard oldValue != state else {
                return
            }
            //update Height
            var newHeight: CGFloat = 0
            switch self.state {
            case .normal:
                moreBtn.isSelected = false
                moreIndicatorBtn.isSelected = false
                newHeight = viewHeight
            case .showMorePeriods:
                moreBtn.isSelected = true
                newHeight = viewHeight * 2
            case .showMoreIndicators:
                moreIndicatorBtn.isSelected = true
                newHeight = viewHeight * 3
            }
            self.snp.updateConstraints { (make) in
                make.height.equalTo(newHeight)
            }
            
            reloadData()
        }
    }
    
    typealias PeriodType = KLinePeriod.PeriodType
    lazy var timeLineBtn: TimeLineButton = {
        return TimeLineButton()
    }()
    
    lazy var moreBtn: MoreButton = {
        return MoreButton()
    }()
    
    lazy var moreIndicatorBtn: MoreIndicatorButton = {
        return MoreIndicatorButton()
    }()
    
    lazy var normalButtons: [KLineOptionButton] = { 
        return getNormalButtons()
    }()
    lazy var otherPeriods: [KLineOptionButton] = {
        return getOtherPeriods()
    }()
    
    lazy var masterIndicators: [KLineOptionButton] = {
        return [PromptButton(title: "主图"), PromptButton(title: "MA")]
    }()
    
    lazy var assistantIndicators: [KLineOptionButton] = {
        return [PromptButton(title: "副图")] + [IndicatorButton(title: "成交量", value: "Volume"),
                                                  IndicatorButton(title: "MACD", value: "MACD"),
                                                  IndicatorButton(title: "KDJ", value: "KDJ"),
                                                  IndicatorButton(title: "RSI", value: "RSI"),
                                                  IndicatorButton(title: "BOLL", value: "BOLL")]
    }()
    
    lazy var periodBtnMap: [KLinePeriod.PeriodType: PeriodButton] = {
        var dic = [KLinePeriod.PeriodType: PeriodButton]()
        for type in periodTypes {
            let btn = PeriodButton(type)
            dic[type] = btn
        }
        return dic
    }()
    let periodTypes: [KLinePeriod.PeriodType] = [.min1, .min15, .min30, .min60, .day1, .week1, .month1]
    
    var viewHeight: CGFloat {
        return 40.0
    }
    var viewWidth: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    var btnsPerRow: CGFloat {
        return 7.0
    }

    let titleFont = UIFont.systemFont(ofSize: 12)
    let bgColor = UIColor(hexStr: "1c1e22")
    let maxBtnsPerRow = 6
    
    var masterIndex: Int = 0
    var assitantIndex: Int = 0
    
    lazy var btnWidth: CGFloat = {
        return viewWidth / CGFloat(self.maxBtnsPerRow)
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "OptionBar")
        
        NotificationCenter.default.addObserver(self, selector: #selector(optionButtonClick(notice:)), name: Notification.Name.init("OptionButtonClick"), object: nil)
        
        periodBtnMap[.min15]?.isSelected = true
        assistantIndicators[0].isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func optionButtonClick(notice: Notification) {
        if let btn = notice.object as? KLineOptionButton {
            if btn is MoreButton {
                showMore()
            } else if btn is MoreIndicatorButton {
                showIndicators()
            } else if btn is TimeLineButton {
                clickTimeLine()
            } else if btn is PeriodButton {
                clickPeriod(sender: btn as! PeriodButton)
            } else if btn is IndicatorButton {
                clickAssistIndicator(sender: btn as! IndicatorButton)
            }
        }
    }
    
    func buttonArray(at indexPath: IndexPath) -> [KLineOptionButton] {
        switch state {
        case .normal:
            return normalButtons
        case.showMorePeriods:
            if indexPath.row == 0 {
                return normalButtons
            } else {
                return otherPeriods
            }
        case .showMoreIndicators:
            if indexPath.row == 0 {
                return normalButtons
            } else if indexPath.row == 1 {
                return masterIndicators
            } else {
                return assistantIndicators
            }
        }
    }
    
    func cellColor(at indexPath: IndexPath) -> UIColor {
        return indexPath.row == 0 ? bgColor : .black
    }
    
    func getNormalButtons() -> [KLineOptionButton] {
        return [timeLineBtn,
                periodBtnMap[PeriodType.min1]!,
                periodBtnMap[PeriodType.min15]!,
                periodBtnMap[PeriodType.min60]!,
                periodBtnMap[PeriodType.day1]!,
                moreBtn,
                moreIndicatorBtn]
    }
    
    func getOtherPeriods() -> [KLineOptionButton] {
        return [periodBtnMap[.min30]!, periodBtnMap[.week1]!, periodBtnMap[.month1]!]
    }
    
}

extension KLineOptionBarPortrait {
    @objc func showMore() {
        self.state = self.state == .showMorePeriods ? .normal : .showMorePeriods
    }
    
    @objc func showIndicators() {
        self.state = self.state == .showMoreIndicators ? .normal : .showMoreIndicators
    }
    
    @objc func clickTimeLine() {
        guard !timeLineBtn.isSelected else {
            return
        }
        timeLineBtn.isSelected = true
        periodBtnMap.forEach { (_, button) in
            button.isSelected = false
        }
        optionDelegate?.selectTimeLine()
    }
    
    @objc func clickPeriod(sender: PeriodButton) {
        if !self.isHidden, !sender.isSelected {
            optionDelegate?.selectPeriod(sender.period.value)
        }
        
        timeLineBtn.isSelected = false
        periodBtnMap.forEach { (_, button) in
            if sender.period.value == button.period.value {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }

    @objc func clickAssistIndicator(sender: IndicatorButton) {
        assistantIndicators.forEach { (button) in
            if button is IndicatorButton, sender.value == (button as! IndicatorButton).value {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
        
        optionDelegate?.selectAssitIndicator(sender.value)
    }
    
    func rotate() {
        self.state = .normal
    }
}

extension KLineOptionBarPortrait: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.state {
        case .normal:
            return 1
        case .showMorePeriods:
            return 2
        case .showMoreIndicators:
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionBar", for: indexPath)
        cell.backgroundColor = cellColor(at: indexPath)
        
        for v in cell.contentView.subviews {
            v.removeFromSuperview()
        }
        
        let btns = buttonArray(at: indexPath)
        let btnWidth = viewWidth / btnsPerRow
        for (index, button) in btns.enumerated() {
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(btnWidth)
                make.left.equalToSuperview().offset(CGFloat(index) * btnWidth)
            }
        }
        
        if self.state == .showMoreIndicators {
            if indexPath.row == 1 || indexPath.row == 2 {
                let line = UIView()
                line.backgroundColor = .white
                cell.contentView.addSubview(line)
                line.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(btnWidth)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(1)
                    make.height.equalTo(15)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewWidth, height: self.viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

