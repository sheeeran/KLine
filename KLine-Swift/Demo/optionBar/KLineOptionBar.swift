//
//  TimeBar.swift
//  KLine-Swift
//
//  Created by xieran on 2018/9/10.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit
import SnapKit

class KLineOptionBar: UICollectionView {
    var viewHeight: CGFloat {
        if UIDevice.isPortrait {
            return 40.0
        } else {
            return KLineTools.landscapeOptionBarHeight
        }
    }
    var viewWidth: CGFloat = UIScreen.main.bounds.width
    
    let titleFont = UIFont.systemFont(ofSize: 12)
    let bgColor = UIColor(hexStr: "1c1e22")
    let maxBtnsPerRow = 6
    let periodBtns = [PeriodButton(.min1),
                      PeriodButton(.min15),
                      PeriodButton(.min30),
                      PeriodButton(.min60),
                      PeriodButton(.day1),
                      PeriodButton(.week1),
                      PeriodButton(.month1)]
    
    let indicatorBtns = [IndicatorButton(title: "MA", value: "MA"),
                         IndicatorButton(title: "BOLL", value: "BOLL")]
    let volumeBtns = [IndicatorButton(title: "成交量", value: "Volume"),
                      IndicatorButton(title: "MACD", value: "MACD"),
                      IndicatorButton(title: "KDJ", value: "BOLL"),
                      IndicatorButton(title: "RSI", value: "RSI")]
    
    var selectPeriodBlock: ((_ index: Int) -> Void)?
    var selectIndicator1Block: ((_ index: Int) -> Void)?
    var selectIndicator2Block: ((_ index: Int) -> Void)?
    
    var masterIndex: Int = 0
    var assitantIndex: Int = 0
    
    lazy var btnWidth: CGFloat = {
        return UIScreen.main.bounds.width / CGFloat(self.maxBtnsPerRow)
    }()

    //更多
    fileprivate lazy var moreBtn: FlexButton = {
        let btn = FlexButton(type: .custom)
        btn.titleLabel?.font = titleFont
        btn.setTitle("更多", for: .normal)
        btn.addTarget(self, action: #selector(showMore(sender:)), for: .touchUpInside)
        return btn
    }()
    
    //指标
    fileprivate lazy var indicatorBtn: FlexButton = {
        let btn = FlexButton(type: .custom)
        btn.titleLabel?.font = titleFont
        btn.setTitle("指标", for: .normal)
        btn.addTarget(self, action: #selector(showIndicators(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var isOpen = false {
        didSet {
            guard oldValue != isOpen else {
                return
            }
            
            if isOpen {
                self.snp.updateConstraints { (make) in
                    make.height.equalTo(viewHeight * 2)
                }
            } else {
                self.snp.updateConstraints { (make) in
                    make.height.equalTo(viewHeight)
                }
            }
        }
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(OptionBarCollectionViewCell.self, forCellWithReuseIdentifier: "OptionBar")
        
        for btn in periodBtns {
            btn.addTarget(self, action: #selector(selectPeriod(sender:)), for: .touchUpInside)
        }
        
        for btn in indicatorBtns {
            btn.addTarget(self, action: #selector(selectIndicator1(sender:)), for: .touchUpInside)
        }
        
        for btn in volumeBtns {
            btn.addTarget(self, action: #selector(selectIndicator2(sender:)), for: .touchUpInside)
        }
        
        periodBtns[0].isSelected = true
        indicatorBtns[0].isSelected = true
        volumeBtns[0].isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotate(screenWidth: CGFloat) {
        self.viewWidth = screenWidth
        self.isHidden = true
        self.moreBtn.setNeedsDisplay()
        self.indicatorBtn.setNeedsDisplay()
        self.snp.updateConstraints { (make) in
            make.height.equalTo(isOpen ? self.viewHeight * 2 : self.viewHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isHidden = false
        }
        
        reloadData()
    }
}

extension KLineOptionBar {
    @objc func showMore(sender: UIButton) {
        indicatorBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            reloadData()
        }
        isOpen = sender.isSelected
    }
    
    @objc func showIndicators(sender: UIButton) {
        moreBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            reloadData()
        }
        isOpen = sender.isSelected
    }
    
    @objc func selectPeriod(sender: PeriodButton) {
        guard sender.isSelected == false else {
            return
        }
        
        indicatorBtn.isSelected = false
        moreBtn.isSelected = false
        
        var periodIndex = 0
        for (index, btn) in periodBtns.enumerated() {
            if btn == sender {
                btn.isSelected = true
                periodIndex = index
            } else {
                btn.isSelected = false
            }
        }
        sender.isSelected = true
        if isOpen {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.isOpen = false
            }
        }
        
        selectPeriodBlock?(periodIndex)
    }
    
    @objc func selectIndicator1(sender: IndicatorButton) {
        guard sender.isSelected == false else {
            return
        }
        indicatorBtn.isSelected = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isOpen = false
        }
        for (index, btn) in indicatorBtns.enumerated() {
            if btn == sender {
                btn.isSelected = true
                masterIndex = index
            } else {
                btn.isSelected = false
            }
        }
        selectIndicator1Block?(masterIndex)
    }
    
    @objc func selectIndicator2(sender: IndicatorButton) {
        guard sender.isSelected == false else {
            return
        }
        indicatorBtn.isSelected = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isOpen = false
        }
        for (index, btn) in volumeBtns.enumerated() {
            if btn == sender {
                btn.isSelected = true
                assitantIndex = index
            } else {
                btn.isSelected = false
            }
        }
        selectIndicator2Block?(assitantIndex)
    }
}

extension KLineOptionBar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsPerRow = 6
        return itemsPerRow
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.isOpen {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionBar", for: indexPath) as! OptionBarCollectionViewCell
        cell.backgroundColor = indexPath.section == 0 ? bgColor : .black

        let tuple = (indexPath.section, indexPath.row)
        if UIDevice.isPortrait {
            if indexPath.section == 0{
                switch tuple {
                case (0, 0):
                    cell.btn = periodBtns[0]
                case (0, 1):
                    cell.btn = periodBtns[1]
                case (0, 2):
                    cell.btn = periodBtns[3]
                case (0, 3):
                    cell.btn = periodBtns[4]
                case (0, 4):
                    cell.btn = moreBtn
                case (0, 5):
                    cell.btn = indicatorBtn
                default:
                    cell.btn = nil
                }
            } else {
                if moreBtn.isSelected { //更多
                    switch tuple {
                    case (1, 0):
                        cell.btn = periodBtns[2]
                    case (1, 1):
                        cell.btn = periodBtns[5]
                    case (1, 2):
                        cell.btn = periodBtns[6]
                    default:
                        cell.btn = nil
                    }
                } else if indicatorBtn.isSelected { //指标
                    switch tuple {
                    case (1, 0):
                        cell.btn = indicatorBtns[0]
                    case (1, 1):
                        cell.btn = indicatorBtns[1]
                    default:
                        cell.btn = volumeBtns[tuple.1 - 2]
                    }
                } else {
                    cell.btn = nil
                }
            }
        } else {
            switch tuple {
            case (0, 0):
                cell.btn = periodBtns[0]
            case (0, 1):
                cell.btn = periodBtns[1]
            case (0, 2):
                cell.btn = periodBtns[3]
            case (0, 3):
                cell.btn = periodBtns[4]
            case (0, 4):
                cell.btn = periodBtns[5]
            case (0, 5):
                cell.btn = moreBtn
            case (1, 0):
                cell.btn = periodBtns[2]
            case (1, 1):
                cell.btn = periodBtns[6]
            default:
                cell.btn = nil
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6.0
        return CGSize(width: self.viewWidth / itemsPerRow, height: self.viewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
