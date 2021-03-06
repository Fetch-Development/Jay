//
//  TodayHabitCardView.swift
//  Jay
//
//  Created by Aydar Nasibullin on 14.07.2020.
//  Copyright © 2020 Fetch Development. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints
import Lottie

class TodayHabitCardView: UIViewController, ChartViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    //VIEWS
    @IBOutlet var habitCardView: UIView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var cardIconImageView: UIImageView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    
    //BUTTONS
    @IBOutlet weak var statusButton: UIButton!
    @IBAction func statusButtonPressed(_ sender: Any) {
        if TodayHabitCardView.derivedData?.state != .completed {
            Jay.progressAppend(
                data: &(TodayHabitCardView.derivedData)!,
                animationView: successAnimationView,
                afterAction: {
                    self.progressUpdate()
            }
            )
            DataProvider.update(
                id: self.cellId!,
                obj: TodayHabitCardView.derivedData as Any
            )
            self.setData()
            
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //LABELS
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var calendarDateLabel: UILabel!
    @IBOutlet weak var cardHeader: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var quickLookProgressLabel: UILabel!
    
    //DETAILS
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var bestCntLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var missesLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    
    //GLOBAL VARS
    public static var derivedData: JayData.HabitLocal?
    public var cellId: String?
    private lazy var delegate = CustomGriddedCalendarCollectionViewDelegate()
    public static var startingWeekday = 0
    var daysInMonth = 0
    var today = 0
    public static var today = Calendar.current.component(.day, from: Date()) + 1
    var collectionView: UICollectionView!
    
    //MISC
    override func viewWillDisappear(_ animated: Bool) {
        DataProvider.update(id: cellId!, obj: TodayHabitCardView.derivedData as Any)
        vc!.collectionView.reloadData()
    }
    
    //Explicitly detecting whether the system appearance has changed in order to redraw the chart
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                setData()
            }
        }
    }
    
    //Setting number of cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31 + TodayHabitCardView.startingWeekday - 1
    }
    
    //Setting cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let offset = today - 2 + TodayHabitCardView.startingWeekday
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        var imageView = UIImageView()
        var status = JayData.JayHabitState.blank
        
        if indexPath.item - TodayHabitCardView.startingWeekday + 2 > 0 {
            status = DataProvider.getCalendarStatus(id: cellId!, date: Jay.getDayOfMonth(date: Date(), index:
                indexPath.item - TodayHabitCardView.startingWeekday + 1))
        }

        switch status {
        case .completed:
            imageView = UIImageView(image: UIImage(systemName: indexPath.item == offset ? "smallcircle.fill.circle.fill" : "smallcircle.fill.circle"))
        case .untouched:
            imageView = UIImageView(image: UIImage(systemName: indexPath.item == offset ? "slash.circle.fill" : "slash.circle"))
        case .incompleted:
            imageView = UIImageView(image: UIImage(systemName: indexPath.item == offset ? "smallcircle.circle.fill" : "smallcircle.circle"))
        case .unknown:
            imageView = UIImageView(image: UIImage(systemName: "circle"))
        case .blank:
            imageView = UIImageView(image: nil)
        }
        
        imageView.tintColor = indexPath.item > offset ? .systemGray4 : .darkGray
        cell.contentView.addSubview(imageView)
        imageView.centerInSuperview()
        imageView.widthToSuperview()
        imageView.heightToSuperview()
        return cell
    }
    
    func update(idCell: String, data: JayData.HabitLocal) {
        cellId = idCell
        TodayHabitCardView.derivedData = data
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        TodayHabitCardView.startingWeekday = Calendar.current.component(.weekday, from: Calendar.current.date(from: DateComponents(year: year, month: month, day: 0))!)
        daysInMonth = Jay.getDaysInMonth(month: month)
        today = Calendar.current.component(.day, from: Date())
    }
    
    //Creating & configuring chart
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemBackground
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.drawBordersEnabled = false
        chartView.drawMarkers = false
        chartView.noDataText = ""
        chartView.legend.enabled = false
        return chartView
    }()
    
    //Function returning gradient
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let topColor = UIColor.systemTeal.cgColor
        let bottomColor = UIColor.systemBackground.cgColor
        let gradientColors = [topColor, bottomColor] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    //Setting data for the chart and details
    private func setData() {
        let set = LineChartDataSet(entries: {
            let values = DataProvider.getChartInfo(id: cellId!)
            var target: [ChartDataEntry] = []
            for i in 0..<values.count {
                target.append(ChartDataEntry(x: Double(i), y: Double(values[i])))
            }
            return target
        }())
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 3
        set.setColor(.systemTeal)
        set.fill = Fill.init(linearGradient: getGradientFilling(), angle: 90.0)
        set.drawFilledEnabled = true
        set.setDrawHighlightIndicators(false)
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
        
        //Details
        let details = DataProvider.getStatistics(id: cellId!)
        bestCntLabel.text = "\(details.best)"
        streakLabel.text = "\(details.streak)"
        percentageLabel.text = "\(details.donePercentage)%"
        missesLabel.text = "\(details.len - details.completedSum)"
        successLabel.text = "\(details.completedSum)"
        let len = details.len
        dayCountLabel.text = "Over \(len) " + (len > 1 ? "days" : "day")
        
        //Card
        let card = Jay.getCard(from: TodayHabitCardView.derivedData!)
        cardHeader.text = card.header
        cardDescriptionLabel.text = card.description
        cardIconImageView.image = UIImage(systemName: card.imageName)
    }
    
    func loadCV() {
        //Loading calendar
        if calendarView.subviews.count > 0 {
            let dcollectionView = calendarView.subviews[0] as! UICollectionView
            //let day = Calendar.current.component(.day, from: Date())
            //collectionView.reloadData()
            dcollectionView.removeFromSuperview()
            dcollectionView.delegate = delegate
        }
        calendarView.layoutSubviews()
        collectionView = UICollectionView (
            frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize.zero
        }
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset = .zero
        collectionView.delegate = delegate
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
        
        calendarView.addSubview(collectionView)
        collectionView.centerInSuperview()
        collectionView.width(to: calendarView)
        collectionView.bounds = calendarView.bounds
        collectionView.heightToSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Title
        mainLabel.text = TodayHabitCardView.derivedData?.name
        //Loading chart
        graphView.insertSubview(lineChartView, at: 0)
        lineChartView.centerInSuperview()
        lineChartView.width(to: graphView)
        lineChartView.height(to: graphView)
        setData()
        //Configuring overview container
        let ovrvLayer = overviewView.layer
        ovrvLayer.masksToBounds = false
        ovrvLayer.cornerRadius = 15
        ovrvLayer.shadowColor = UIColor.black.cgColor
        ovrvLayer.shadowOpacity = 0.2
        ovrvLayer.shadowRadius = 8
        ovrvLayer.shadowPath = UIBezierPath(roundedRect: CGRect(x: overviewView.bounds.minX, y: overviewView.bounds.minY, width: view.frame.width - 40, height: overviewView.bounds.height + 5), cornerRadius: 10).cgPath
        ovrvLayer.shouldRasterize = true
        ovrvLayer.rasterizationScale = UIScreen.main.scale
        
        //Updating everything
        loadCV()
        progressUpdate(initial: true)
    }
    
    //Updating all labels, images, and misc
    private func progressUpdate(initial: Bool = false) {
        quickLookProgressLabel.text = String(TodayHabitCardView.derivedData!.completed)
            + "/" + String(TodayHabitCardView.derivedData!.wanted)
        let calendarDateData = Jay.getCalendarDateData()
        calendarDateLabel.text = calendarDateData.0 + " " + calendarDateData.1
        if TodayHabitCardView.derivedData!.state != .completed {
            statusButton.setBackgroundImage(UIImage(named: "HabitIcon"
                + String(TodayHabitCardView.derivedData!.completed) + "."
                + String(TodayHabitCardView.derivedData!.wanted)), for: .normal)
            if !initial {
                Jay.animateScale(view: successAnimationView)
            }
        }
        else {
            statusButton.setBackgroundImage(UIImage(named: "HabitIconDone"), for: .normal)
            quickLookProgressLabel.textColor = Jay.successGreenColor
            successAnimationView.isHidden = true
            //MARK: Move detailsScrollView to front here
        }
        loadCV()
    }
    
    
}
