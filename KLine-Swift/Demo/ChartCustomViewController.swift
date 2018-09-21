//
//  ChartCustomViewController.swift
//  Example
//
//  Created by Chance on 2018/2/27.
//  Copyright © 2018年 Chance. All rights reserved.
//

import UIKit
import SwiftWebSocket

class ChartCustomViewController: UIViewController {
    deinit {
        socket.close()
    }
    
    let darkGray = UIColor(red: 29.0/255.0, green: 30.0/255.0, blue: 34.0/255.0, alpha: 1)
    let lineViewBgColor = UIColor(red: 20.0/255.0, green: 22.0/255.0, blue: 24.0/255.0, alpha: 1)
    let backgroundColor = UIColor.black
    /// 不显示
    static let Hide: String = ""
    
    var selectedTime: Int = 0
    /// 主图线段
    let masterLine: [String] = [
        CHSeriesKey.candle, CHSeriesKey.timeline
    ]
    /// 主图指标
    let masterIndex: [String] = [CHSeriesKey.ma]
    /// 副图指标
    let assistIndex: [String] = [CHSeriesKey.volume, CHSeriesKey.macd, CHSeriesKey.kdj, CHSeriesKey.rsi, CHSeriesKey.boll]
    //选择交易对
    let exPairs: [String] = [
        "BTC-USD", "ETH-USD", "LTC-USD",
        "LTC-BTC", "ETH-BTC", "BCH-BTC",
        ]
    /// 已选周期
    var timeIndex: Int = 0
    /// 已选主图线段
    var selectedMasterLine: Int = 0 {
        didSet {
            if oldValue != selectedMasterLine {
                updateUserStyle()
            }
        }
    }
    /// 已选主图指标
    var selectedMasterIndex: Int = 0
    /// 已选副图指标1
    var selectedAssistIndex: Int = 0
    /// 已选副图指标2
    var selectedAssistIndex2: Int = 0
    /// 选择的风格
    var selectedTheme: Int = 0
    /// y轴显示方向
    var selectedYAxisSide: Int = 1
    /// 蜡烛柱颜色
    var selectedCandleColor: Int = 1
    var selectedSymbol: Int = 0
    /// 数据源
    var klineDatas = [KlineChartData]()
    /// 图表X轴的前一天，用于对比是否夸日
    var chartXAxisPrevDay: String = ""
    /// 图表
    lazy var chartView: CHKLineChartView = {
        let chartView = CHKLineChartView(frame: CGRect.zero)
        chartView.style = self.loadUserStyle()
        chartView.delegate = self
        chartView.backgroundColor = darkGray
        return chartView
    }()
    /// 顶部数据
    lazy var topView: TickerTopView = {
        let view = TickerTopView(frame: CGRect.zero)
        view.backgroundColor = darkGray
        return view
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return v
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close_btn"), for: .normal)
        btn.addTarget(self, action: #selector(forcePortrait), for: .touchUpInside)
        btn.isHidden = UIDevice.isPortrait
        return btn
    }()
    
    lazy var optionBar: KLineOptionBarPortrait = {
        let v = KLineOptionBarPortrait()
        v.optionDelegate = self
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.height.equalTo(v.viewHeight)
            make.left.right.centerY.equalToSuperview()
        }
        return v
    }()
    lazy var optionBarLandscape: KLineOptionBarLandscape = {
        let v = KLineOptionBarLandscape()
        v.optionDelegate = self
        view.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(v.viewHeight)
        })
        return v
    }()
    lazy var rightIndicator: KLineRightIndicatorView = {
        let v = KLineRightIndicatorView()
        v.isHidden = UIDevice.isPortrait
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(KLineTools.landscapeNavBarHeight + 10)
            make.bottom.equalToSuperview().offset(-2 * KLineTools.landscapeOptionBarHeight)
        }
        return v
    }()
    
    lazy var toolBar: UIView = {
        let v = UIView()
        v.backgroundColor = darkGray
        v.addSubview(favorBtn)
        favorBtn.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        })
        v.addSubview(buyBtn)
        buyBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(favorBtn)
            make.left.equalTo(favorBtn.snp.right)
            make.width.equalTo((UIScreen.main.bounds.width - 80) / 2)
        })
        v.addSubview(sellBtn)
        sellBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(buyBtn.snp.right)
            make.top.bottom.width.equalTo(buyBtn)
        })
        
        let line = UIView()
        line.backgroundColor = .black
        v.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(2)
        })
        return v
    }()
    
    lazy var favorBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("加自选", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.setImage(UIImage(named: "favor_nor"), for: .normal)
        btn.setImage(UIImage(named: "favor_sel"), for: .selected)
        btn.addTarget(self, action: #selector(favor(sender:)), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: -10, left: 30, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 20, left: -20, bottom: 0, right: 0)
        return btn
    }()
    
    lazy var buyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("买入", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.backgroundColor = UIColor(red: 230.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)
        btn.addTarget(self, action: #selector(buy), for: .touchUpInside)
        return btn
    }()
    
    lazy var sellBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("卖出", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.backgroundColor = UIColor(red: 40.0/255.0, green: 172.0/255.0, blue: 142.0/255.0, alpha: 1)
        btn.addTarget(self, action: #selector(sell), for: .touchUpInside)
        return btn
    }()
    
    let socket = WebSocket("wss://ars-wss.duelb.com/klineList")
    var pingTimer: Timer?
    var period = KLinePeriod(type: .min15).value
    var modelsDict = [AnyHashable: Any]()
    var marketType = "" {
        didSet {
            topView.market = marketType
        }
    }
    var marketId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.timeIndex = 0
        self.selectedMasterLine = 0
        self.selectedMasterIndex = 0
        self.selectedAssistIndex = 0
        self.selectedAssistIndex2 = 2
        self.selectedSymbol = 0
        self.handleChartIndexChanged()
        
        configSocket()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "full_screen")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(forceLandscape))
    }
    
    var superViewColor: UIColor?
    override func viewDidAppear(_ animated: Bool) {
        superViewColor = self.view.superview?.backgroundColor
        self.view.superview?.backgroundColor = backgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.superview?.backgroundColor = superViewColor
    }
    
    @objc func forceLandscape() {
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        KLineTools.isPortrait = false
        self.rotate(CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
    }
    
    @objc func forcePortrait() {
        self.view.transform = CGAffineTransform(rotationAngle: 0)
        KLineTools.isPortrait = true
        self.rotate(UIScreen.main.bounds.size)
    }
    
    func configSocket() {
        socket.allowSelfSignedSSL = true
        socket.delegate = self
        socket.open()
    }
    
    func sendData() {
        let requestModel = KLineMessageModel(JSON: [:])
        requestModel?.roomType = "klineList"
        requestModel?.msgType = "subscribe"
        requestModel?.symbols = self.marketType
        requestModel?.period = self.period
        requestModel?.marketId = self.marketId
        if let str = requestModel?.toJSONString() {
            self.socket.send(str)
            
            self.pingTimer?.invalidate()
            self.pingTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
            DispatchQueue.global().async {
                RunLoop.current.add(self.pingTimer!, forMode: .commonModes)
            }
        }
    }
    
    @objc func sendPing() {
        socket.ping()
    }
}

//websocket delegate
extension ChartCustomViewController: WebSocketDelegate {
    func webSocketClose(_ code: Int, reason: String, wasClean: Bool) {
        
    }
    
    func webSocketError(_ error: NSError) {
        
    }
    
    func webSocketMessageText(_ text: String) {
        if let msgModel = KLineMessageModel(JSONString: text) {
            if msgModel.msgType == "subscribe" || msgModel.msgType == "unsubscribe" {
                socket.close()
                return
            }
        }
        if let response = KLineResponse(JSONString: text), let line = response.data?.line {
            print(text)
            var nodes = self.modelsDict[self.period] as? [KlineChartData]
            if nodes == nil {
                nodes = [KlineChartData]()
            }
            for index in 0..<(line.ts?.count ?? 0) {
                let date = line.ts?[index] ?? Int(Date().timeIntervalSince1970)
                let open = line.openPrice?[index] ?? 0.0
                let high = line.highestPrice?[index] ?? 0.0
                let low = line.lowestPrice?[index] ?? 0.0
                let close = line.closePrice?[index] ?? 0.0
                let volume = line.tradeVolume?[index] ?? 0.0
                let model = KlineChartData()
                model.time = date
                model.openPrice = open
                model.highPrice = high
                model.lowPrice = low
                model.closePrice = close
                model.vol = volume
                nodes?.append(model)
            }
            self.modelsDict[self.period] = nodes
            self.chartView.reloadData()
            if let lastNode = nodes?.last {
                self.topView.update(data: lastNode)
            }
        }
    }
    
    func webSocketOpen() {
        print("open")
        sendData()
    }
}

//横竖屏切换
extension ChartCustomViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        rotate(size)
    }
    
    func rotate(_ size: CGSize) {
        topView.setupLabels()
        makeConstraints()
        
        optionBar.rotate()
        optionBarLandscape.rotate()
        if size.width > size.height { //横屏
            closeBtn.isHidden = false
            rightIndicator.isHidden = false
            optionBar.isHidden = true
            optionBarLandscape.isHidden = false
            optionBarLandscape.updateConstraints()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else { //竖屏
            closeBtn.isHidden = true
            rightIndicator.isHidden = true
            optionBar.isHidden = false
            optionBarLandscape.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

extension ChartCustomViewController: KLineOptionDelegate {
    func selectTimeLine() {
        self.selectedMasterLine = 1
        self.handleChartIndexChanged()
    }
    
    func selectPeriod(_ period: String) {
        self.selectedMasterLine = 0
        self.period = period
        self.sendData()
        self.handleChartIndexChanged()
    }
    
    func selectAssitIndicator(_ indicator: String) {
        for (index, value) in self.assistIndex.enumerated() {
            if value == indicator {
                self.selectedAssistIndex = index
                self.handleChartIndexChanged()
                break
            }
        }
    }
}

// MARK: - 图表
extension ChartCustomViewController {
    /// 配置UI
    func setupUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = darkGray
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationItem.title = self.marketType
        self.view.backgroundColor = darkGray
        self.view.addSubview(self.topView)
        self.view.addSubview(self.optionBar)
        self.view.addSubview(self.rightIndicator)
        self.view.addSubview(self.chartView)
        self.view.addSubview(self.loadingView)
        self.view.addSubview(self.toolBar)
        self.topView.addSubview(self.closeBtn)
        makeConstraints()
    }
    
    func makeConstraints() {
        self.loadingView.snp.remakeConstraints { (make) in
            make.center.equalTo(self.chartView)
        }
        
        optionBar.snp.remakeConstraints { (make) in
            make.height.equalTo(optionBar.viewHeight)
            make.left.right.equalToSuperview()
            if UIDevice.isPortrait {
                make.top.equalTo(topView.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        rightIndicator.snp.remakeConstraints { (make) in
            if UIDevice.isPortrait {
                make.right.equalToSuperview().offset(-5)
                make.width.equalTo(0)
            } else {
                make.right.equalToSuperview()
                make.width.equalTo(60)
            }
            make.centerY.equalToSuperview()
            make.height.equalTo(rightIndicator.btnHeight * 6)
        }
        
        self.topView.snp.remakeConstraints { (make) in
            if UIDevice.isPortrait {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
            make.height.equalTo(80)
            make.left.right.equalToSuperview()
        }
          
        self.chartView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            if UIDevice.isPortrait {
                make.top.equalTo(self.optionBar.snp.bottom)
                make.bottom.equalTo(toolBar.snp.top).offset(-2)
                make.right.equalToSuperview()
            } else {
                make.top.equalTo(self.topView.snp.bottom).offset(3)
                make.bottom.equalTo(self.optionBar.snp.top).offset(-3)
                make.right.equalTo(self.rightIndicator.snp.left).offset(-2)
            }
        }
        
        toolBar.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            if UIDevice.isPortrait {
                make.height.equalTo(50)
            } else {
                make.height.equalTo(0)
            }
        }
        
        closeBtn.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }
    
    ///处理指标的变更
    func handleChartIndexChanged() {
        
        let lineKey = self.masterLine[self.selectedMasterLine]
        let masterKey = self.masterIndex[self.selectedMasterIndex]
        let assistKey = self.assistIndex[self.selectedAssistIndex]
//        let assist2Key = self.assistIndex[self.selectedAssistIndex2]
        
        self.chartView.setSection(hidden: assistKey == ChartCustomViewController.Hide, byIndex: 1)
//        self.chartView.setSection(hidden: assist2Key == ChartCustomViewController.Hide, byIndex: 2)
        
        //先隐藏所有线段
        self.chartView.setSerie(hidden: true, inSection: 0)
        self.chartView.setSerie(hidden: true, inSection: 1)
//        self.chartView.setSerie(hidden: true, inSection: 2)
        
        //显示当前选中的线段
        self.chartView.setSerie(hidden: false, by: masterKey, inSection: 0)
        self.chartView.setSerie(hidden: false, by: assistKey, inSection: 1)
//        self.chartView.setSerie(hidden: false, by: assist2Key, inSection: 2)
        self.chartView.setSerie(hidden: false, by: lineKey, inSection: 0)
        
        //重新渲染
        self.chartView.reloadData(resetData: false)
    }
    
    /// 更新指标算法和样式风格
    func updateUserStyle() {
        self.chartView.resetStyle(style: self.loadUserStyle())
        self.handleChartIndexChanged()
    }
}

// MARK: - 实现K线图表的委托方法
extension ChartCustomViewController: CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return (self.modelsDict[self.period] as? [KlineChartData])?.count ?? 0
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        guard let array = self.modelsDict[self.period] as? [KlineChartData] else {
            return CHChartItem()
        }
        let data = array[index]
        let item = CHChartItem()
        item.time = data.time
        item.openPrice = CGFloat(data.openPrice)
        item.highPrice = CGFloat(data.highPrice)
        item.lowPrice = CGFloat(data.lowPrice)
        item.closePrice = CGFloat(data.closePrice)
        item.vol = CGFloat(data.vol)
        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section: CHSection) -> String {
        var strValue = ""
        if section.key == "volume" {
            if value / 1000 > 1 {
                strValue = (value / 1000).ch_toString(maxF: section.decimal) + "K"
            } else {
                strValue = value.ch_toString(maxF: section.decimal)
            }
        } else {
            strValue = value.ch_toString(maxF: section.decimal)
        }
        
        return strValue
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        guard let array = self.modelsDict[self.period] as? [KlineChartData] else {
            return ""
        }
        let data = array[index]
        let timestamp = data.time
        let dayText = Date.ch_getTimeByStamp(timestamp, format: "MM-dd")
        let timeText = Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
        var text = ""
        //跨日，显示日期
        if dayText != self.chartXAxisPrevDay && index > 0 {
            text = dayText
        } else {
            text = timeText
        }
        self.chartXAxisPrevDay = dayText
        return text
    }
    
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 2
        }
        
    }
    
    
    /// 调整Y轴标签宽度
    ///
    /// - parameter chart:
    ///
    /// - returns:
    func widthForYAxisLabelInKLineChart(in chart: CHKLineChartView) -> CGFloat {
        return 60
    }
    
    /// 自定义分区图标题
    ///
    func kLineChart(chart: CHKLineChartView, titleForHeaderInSection section: CHSection, index: Int, item: CHChartItem) -> NSAttributedString? {
        var start = 0
        let titleString = NSMutableAttributedString()
        var key = ""
        switch section.index {
        case 0:
            key = self.masterIndex[self.selectedMasterIndex]
        default:
            key = section.series[section.selectedIndex].key
        }
        
        //获取该线段的标题值及颜色，可以继续自定义
        guard let attributes = section.getTitleAttributesByIndex(index, seriesKey: key) else {
            return nil
        }
        
        //合并为完整字符串
        for (title, color) in attributes {
            titleString.append(NSAttributedString(string: title))
            let range = NSMakeRange(start, title.ch_length)
            let colorAttribute = [NSAttributedStringKey.foregroundColor: color]
            titleString.addAttributes(colorAttribute, range: range)
            start += title.ch_length
        }
        
        return titleString
    }
    
    /// 点击图标返回点击的位置和数据对象
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    ///   - item:
    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        guard let array = self.modelsDict[self.period] as? [KlineChartData] else {
            return
        }
        let data = array[index]
        self.topView.update(data: data)
    }
    
    /// 切换可分页分区的线组
    ///
    func kLineChart(chart: CHKLineChartView, didFlipPageSeries section: CHSection, series: CHSeries, seriesIndex: Int) {
        switch section.index {
        case 1:
            self.selectedAssistIndex = self.assistIndex.index(of: series.key) ?? self.selectedAssistIndex
        case 2:
            self.selectedAssistIndex2 = self.assistIndex.index(of: series.key) ?? self.selectedAssistIndex2
        default:break
        }
    }
}

// MARK: - 竖屏切换重载方法实现
extension ChartCustomViewController {
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation.isPortrait {
            //竖屏时，交易量的y轴只以4间断显示
            self.chartView.sections[1].yAxis.tickInterval = 3
            self.chartView.sections[2].yAxis.tickInterval = 3
        } else {
            //竖屏时，交易量的y轴只以2间断显示
            self.chartView.sections[1].yAxis.tickInterval = 1
            self.chartView.sections[2].yAxis.tickInterval = 1
        }
        self.chartView.reloadData()
    }
    
}

// MARK: - 自定义样式
extension ChartCustomViewController {
    
    /// 读取用户自定义样式
    ///
    /// - Returns:
    func loadUserStyle() -> CHKLineChartStyle {
        
        let seriesParams = SeriesParamList.shared.loadUserData()
        let styleParam = StyleParam.shared
        
        let style = CHKLineChartStyle()
        style.labelFont = UIFont.systemFont(ofSize: 10)
        style.lineColor = UIColor(hex: styleParam.lineColor)
        style.textColor = UIColor(hex: styleParam.textColor)
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        style.selectedTextColor = UIColor(hex: styleParam.selectedTextColor)
        style.backgroundColor = lineViewBgColor
        style.isInnerYAxis = true
        
        if styleParam.showYAxisLabel == "Left" {
            style.showYAxisLabel = .left
            style.padding = UIEdgeInsets(top: 16, left: 0, bottom: 4, right: 8)
            
        } else {
            style.showYAxisLabel = .right
            style.padding = UIEdgeInsets(top: 16, left: 8, bottom: 4, right: 0)
            
        }
    
        style.algorithms.append(CHChartAlgorithm.timeline)
        
        /************** 配置分区样式 **************/
        
        /// 主图
        let upcolor = (UIColor.ch_hex(styleParam.upColor), true)
        let downcolor = (UIColor.ch_hex(styleParam.downColor), true)
        let priceSection = CHSection()
        priceSection.backgroundColor = style.backgroundColor
        priceSection.titleShowOutSide = true
        priceSection.valueType = .master
        priceSection.key = "master"
        priceSection.hidden = false
        priceSection.ratios = 3
        priceSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        priceSection.showTitle = false
        
        /// 副图1
        let assistSection1 = CHSection()
        assistSection1.backgroundColor = style.backgroundColor
        assistSection1.valueType = .assistant
        assistSection1.key = "assist1"
        assistSection1.hidden = false
        assistSection1.ratios = 1
        assistSection1.paging = true
        assistSection1.yAxis.tickInterval = 4
        assistSection1.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        
//        /// 副图2
//        let assistSection2 = CHSection()
//        assistSection2.backgroundColor = style.backgroundColor
//        assistSection2.valueType = .assistant
//        assistSection2.key = "assist2"
//        assistSection2.hidden = false
//        assistSection2.ratios = 1
//        assistSection2.paging = true
//        assistSection2.yAxis.tickInterval = 4
//        assistSection2.padding = UIEdgeInsets(top: 16, left: 0, bottom: 8, right: 0)
        
        /************** 添加主图固定的线段 **************/
        
        /// 时分线
        let timelineSeries = CHSeries.getTimelinePrice(
            color: UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1),
            section: priceSection,
            showGuide: false,
            lineWidth: 1)
        
        timelineSeries.hidden = true
        
        /// 蜡烛线
        let priceSeries = CHSeries.getCandlePrice(
            upStyle: upcolor,
            downStyle: downcolor,
            titleColor: UIColor(white: 0.8, alpha: 1),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .arrow(UIColor(white: 0.8, alpha: 1)))
        
        priceSeries.showTitle = true
        priceSeries.chartModels.first?.ultimateValueStyle = .arrow(UIColor(white: 0.8, alpha: 1))
        
        priceSection.series.append(timelineSeries)
        priceSection.series.append(priceSeries)
        
        /************** 读取用户配置中线段 **************/
        
        for series in seriesParams {
            
            if series.hidden {
                continue
            }
            
            if self.selectedMasterLine == 1, series.seriesKey == CHSeriesKey.ma {
                series.params.removeAll()
            }
            
            //添加指标算法
            style.algorithms.append(contentsOf: series.getAlgorithms())
            
            //添加指标线段
            series.appendIn(masterSection: priceSection, assistSections: assistSection1)
        }
        
        style.sections.append(priceSection)
        if assistSection1.series.count > 0 {
            style.sections.append(assistSection1)
        }
        
//        if assistSection2.series.count > 0 {
//            style.sections.append(assistSection2)
//        }
        
        return style
    }
}

//toolbar
extension ChartCustomViewController {
    @objc func favor(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func buy() {
        
    }
    
    @objc func sell() {
        
    }
}
