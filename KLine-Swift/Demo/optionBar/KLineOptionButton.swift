//
//  KLineOptionButton.swift
//  test
//
//  Created by xieran on 2018/9/17.
//  Copyright © 2018年 xieran. All rights reserved.
//

import UIKit

class KLineOptionButton: UIButton {
    let selectedColor = UIColor(red: 253.0/255.0, green: 195.0/255.0, blue: 14.0/255.0, alpha: 1)
    lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = selectedColor
        v.isHidden = true
        return v
    }()
    var hideLine: Bool {
        return false
    }
    
    override var isSelected: Bool {
        didSet {
            if !hideLine {
                line.isHidden = !isSelected
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(selectedColor, for: .selected)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PeriodButton: KLineOptionButton {
    var model: KLinePeriod?
    
    init(_ type: KLinePeriod.PeriodType) {
        super.init(frame: .zero)
        self.model = KLinePeriod(type: type)
        self.setTitle(model?.title ?? "", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IndicatorButton: KLineOptionButton {
    var value: String?
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KLineRightIndicatorButton: IndicatorButton {
    override var hideLine: Bool {
        return true
    }
}

class FlexButton: UIButton {
    let selectedColor = UIColor(red: 253.0/255.0, green: 195.0/255.0, blue: 14.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.setTitleColor(selectedColor, for: .selected)
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
    
    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
}
