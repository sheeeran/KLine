//
//  KLineOptionButton.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineOptionButton: UIButton {
    enum TypeEnum {
        case timeline       //分时
        case period         //时间
        case morePeriod           //更多
        case moreIndicator  //更多指标
        case prompt         //占位的(不可点击)
        case indicator      //指标
    }
    
    let selectedColor = UIColor(red: 253.0/255.0, green: 195.0/255.0, blue: 14.0/255.0, alpha: 1)
    lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = selectedColor
        v.isHidden = true
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(selectedColor, for: .selected)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        addTarget(self, action: #selector(optionClick(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            line.isHidden = !isSelected
        }
    }

    func addLine() {
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(3)
        }
    }
    
    @objc func optionClick(sender: KLineOptionButton) {
        NotificationCenter.default.post(name: Notification.Name.init("OptionButtonClick"), object: sender, userInfo: nil)
    }
}

class PeriodButton: KLineOptionButton {
    var period: KLinePeriod
    init(_ type: KLinePeriod.PeriodType) {
        self.period = KLinePeriod(type: type)
        super.init()
        self.setTitle(period.title, for: .normal)
        addLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IndicatorButton: KLineOptionButton {
    var value: String = ""
    
    init(title: String, value: String, hideLine: Bool = false) {
        super.init()
        self.setTitle(title, for: .normal)
        self.value = value
        if !hideLine {
            addLine()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FlexButton: KLineOptionButton {
    override init() {
        super.init()
        addLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = 5.0
        let labelFrame = titleLabel?.frame ?? .zero
        let context = UIGraphicsGetCurrentContext()
        let point1 = CGPoint(x: labelFrame.maxX + 2, y: labelFrame.maxY)
        let point2 = CGPoint(x: point1.x + width, y: point1.y)
        let point3 = CGPoint(x: point1.x + width, y: point1.y - width)
        context?.addLines(between: [point1, point2, point3, point1])
        if isSelected {
            context?.setFillColor(selectedColor.cgColor)
        } else {
            context?.setFillColor(UIColor.white.cgColor)
        }
        context?.fillPath()
    }
}

class MoreButton: FlexButton {
    override init() {
        super.init()
        self.setTitle("更多", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MoreIndicatorButton: FlexButton {
    override init() {
        super.init()
        self.setTitle("指标", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TimeLineButton: KLineOptionButton {
    override init() {
        super.init()
        self.setTitle("分时", for: .normal)
        addLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PromptButton: KLineOptionButton {
    init(title: String) {
        super.init()
        self.isUserInteractionEnabled = false
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
