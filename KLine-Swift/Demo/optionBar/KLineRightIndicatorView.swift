//
//  KLineRightIndicatorView.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineRightIndicatorView: UIView {
    
    let masterIndicators = [PromptButton(title: "MA"),
                         ]
    let assistantIndicators = [IndicatorButton(title: "成交量", value: "Volume", hideLine: true),
                      IndicatorButton(title: "MACD", value: "MACD", hideLine: true),
                      IndicatorButton(title: "KDJ", value: "KDJ", hideLine: true),
                      IndicatorButton(title: "RSI", value: "RSI", hideLine: true),
                      IndicatorButton(title: "BOLL", value: "BOLL", hideLine: true)]
    
    var selectedIndex: Int = 0 {
        didSet {
            for (index, btn) in assistantIndicators.enumerated() {
                btn.isSelected = selectedIndex == index
            }
        }
    }
        
    let btnHeight: CGFloat = 40.0
    
    init() {
        super.init(frame: .zero)
        let btns = (masterIndicators as [KLineOptionButton]) + (assistantIndicators as [KLineOptionButton])
        for (index, btn) in btns.enumerated() {
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
            make.top.equalTo((masterIndicators.last?.snp.bottom)!)
            make.height.equalTo(1)
        }
        
        backgroundColor = .clear
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(optionButtonClick(notice:)), name: Notification.Name.init("OptionButtonClick"), object: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func optionButtonClick(notice: Notification) {
        if let btn = notice.object as? IndicatorButton {
            assistantIndicators.forEach { (button) in
                button.isSelected = btn.value == button.value
            }
        }
    }
}
