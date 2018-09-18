//
//  KLineRightIndicatorView.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineRightIndicatorView: UIView {

    let indicatorBtns = [KLineRightIndicatorButton(title: "MA", value: "MA"),
                         KLineRightIndicatorButton(title: "BOLL", value: "BOLL")]
    let volumeBtns = [KLineRightIndicatorButton(title: "成交量", value: "Volume"),
                      KLineRightIndicatorButton(title: "MACD", value: "MACD"),
                      KLineRightIndicatorButton(title: "KDJ", value: "BOLL"),
                      KLineRightIndicatorButton(title: "RSI", value: "RSI")]
    
    var masterIndex: Int = 0 {
        didSet {
            for (index, btn) in indicatorBtns.enumerated() {
                btn.isSelected = masterIndex == index
            }
        }
    }
    
    var assitantIndex: Int = 0 {
        didSet {
            for (index, btn) in volumeBtns.enumerated() {
                btn.isSelected = assitantIndex == index
            }
        }
    }
    
    var selectIndicator1Block: ((_ index: Int) -> Void)?
    var selectIndicator2Block: ((_ index: Int) -> Void)?
    
    let btnHeight: CGFloat = 40.0

    init() {
        super.init(frame: .zero)        
        for (index, btn) in (indicatorBtns + volumeBtns).enumerated() {
            btn.tag = index
            btn.addTarget(self, action: #selector(selectIndex(sender:)), for: .touchUpInside)
            addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.width.equalToSuperview()
                make.top.equalToSuperview().offset(CGFloat(index) * self.btnHeight)
                make.height.equalTo(self.btnHeight)
            })
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(white: 1, alpha: 0.3)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-6)
            make.top.equalTo((indicatorBtns.last?.snp.bottom)!)
            make.height.equalTo(1)
        }
        
        
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor

        DispatchQueue.main.async {
            self.masterIndex = 0
            self.assitantIndex = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectIndex(sender: KLineRightIndicatorButton) {
        if indicatorBtns.contains(sender) {
            for btn in indicatorBtns {
                btn.isSelected = btn == sender
            }
            selectIndicator1Block?(sender.tag)
        }
        
        if volumeBtns.contains(sender) {
            for btn in volumeBtns {
                btn.isSelected = btn == sender
            }
            selectIndicator2Block?(sender.tag - indicatorBtns.count)
        }
    }
}
