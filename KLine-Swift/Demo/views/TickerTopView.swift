//
//  TickerTopView.swift
//  Example
//
//  Created by Chance on 2018/2/27.
//  Copyright © 2018年 Chance. All rights reserved.
//

import UIKit

class TickerTopView: UIView {

    /// 价格
    lazy var labelPrice: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(red: 229.0/255.0, green: 73.0/255.0, blue: 74.0/255.0, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 26)
        return view
    }()

    /// 涨跌
    lazy var labelRise: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hex: 0xfe9d25)
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    /// 开盘
    lazy var labelOpen: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hex: 0xfe9d25)
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    /// 最高
    lazy var labelHigh: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .right
        view.text = " "
        return view
    }()
    
    /// 收盘
    lazy var labelClose: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hex: 0xfe9d25)
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    /// 最低
    lazy var labelLow: UILabel = {
        let view = UILabel()
        view.textColor =  UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .right
        view.text = " "
        return view
    }()
    
    /// 交易量
    lazy var labelVol: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .right
        view.text = " "
        return view
    }()
    
    /// 交易额
    lazy var labelTurnover: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    /// 价格±
    lazy var labelMargin: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(hex: 0xfe9d25)
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    lazy var highPrompt: UILabel = {
        let label = UILabel()
        label.text = "高"
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    lazy var lowPrompt: UILabel = {
        let label = UILabel()
        label.text = "低"
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    lazy var volPrompt: UILabel = {
        let label = UILabel()
        label.text = "24小时量"
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    lazy var marketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    
    var market: String = "" {
        didSet {
            marketLabel.text = market
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    /// 配置UI
    func setupUI() {
        let line = UIView()
        line.backgroundColor = .black
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
        addSubview(marketLabel)
        
        addSubview(highPrompt)
        addSubview(lowPrompt)
        addSubview(volPrompt)
        
        addSubview(labelHigh)
        addSubview(labelLow)
        addSubview(labelVol)
        
        addSubview(labelPrice)
        addSubview(labelTurnover)
        addSubview(labelRise)

        setupLabels()
    }
    
    /// 配置布局
    func setupLabels() {
        if UIDevice.isPortrait {
            labelPrice.font = UIFont.systemFont(ofSize: 26)
            labelRise.font = UIFont.systemFont(ofSize: 12)

            marketLabel.snp.remakeConstraints { (make) in
                make.width.height.equalTo(0)
            }
            
            labelHigh.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalTo(labelLow.snp.top).offset(-5)
                make.width.equalTo(100)
            }
            highPrompt.snp.remakeConstraints { (make) in
                make.centerY.equalTo(labelHigh)
                make.right.equalTo(labelHigh.snp.left)
            }
            
            labelLow.snp.remakeConstraints { (make) in
                make.right.width.equalTo(labelHigh)
                make.centerY.equalToSuperview()
            }
            lowPrompt.snp.remakeConstraints { (make) in
                make.right.equalTo(labelLow.snp.left)
                make.centerY.equalTo(labelLow)
            }
            
            labelVol.snp.remakeConstraints { (make) in
                make.right.width.equalTo(labelHigh)
                make.top.equalTo(labelLow.snp.bottom).offset(5)
            }
            volPrompt.snp.remakeConstraints { (make) in
                make.right.equalTo(labelVol.snp.left)
                make.centerY.equalTo(labelVol)
            }
            
            labelPrice.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(5)
            }
            labelTurnover.snp.remakeConstraints { (make) in
                make.top.equalTo(labelPrice.snp.bottom).offset(10)
                make.left.equalTo(labelPrice)
            }
            labelRise.snp.remakeConstraints { (make) in
                make.left.equalTo(labelTurnover.snp.right).offset(5)
                make.centerY.equalTo(labelTurnover)
            }
        } else {
            labelPrice.font = UIFont.systemFont(ofSize: 20)
            labelRise.font = UIFont.systemFont(ofSize: 20)
            
            marketLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            }
            labelPrice.snp.remakeConstraints { (make) in
                make.left.equalTo(marketLabel.snp.right).offset(15)
                make.centerY.equalToSuperview()
            }
            labelRise.snp.remakeConstraints { (make) in
                make.left.equalTo(labelPrice.snp.right).offset(15)
                make.centerY.equalToSuperview()
            }
            labelTurnover.snp.remakeConstraints { (make) in
                make.left.equalTo(labelRise.snp.right).offset(15)
                make.centerY.equalToSuperview()
            }
            
            
            labelVol.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-60)
            }
            volPrompt.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(labelVol.snp.left).offset(-2)
            }
            
            labelLow.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(volPrompt.snp.left).offset(-2)
            }
            lowPrompt.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(labelLow.snp.left).offset(-2)
            }
            
            labelHigh.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(lowPrompt.snp.left).offset(-2)
            }
            highPrompt.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(labelHigh.snp.left).offset(-2)
            }
        }
    }
    
    /// 更新数据
    ///
    /// - Parameter data:
    func update(data: KlineChartData) {
        for v in subviews where v is UILabel {
            v.isHidden = false
        }
        
        self.labelPrice.text = "\(data.closePrice)"
        self.labelRise.text = "\(data.amplitudeRatio.toString(maxF: 2))%"
//        self.labelMargin.text = "\(data.amplitude.toString(maxF: 4))"
        
//        self.labelOpen.text = "O" + " " + "\(data.openPrice.toString(maxF: 4))"
        self.labelHigh.text = "\(data.highPrice.toString(maxF: 4))"
        self.labelLow.text = "\(data.lowPrice.toString(maxF: 4))"
//        self.labelClose.text = "C" + " " + "\(data.closePrice.toString(maxF: 4))"
        self.labelVol.text = "\(data.vol.toString(maxF: 2))"
        let turnover = data.vol * data.closePrice
        self.labelTurnover.text = "≈" + "\(turnover.toString(maxF: 2))" + "CNY"
    }
}
