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
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    
    //BUTTONS
    @IBOutlet weak var statusButton: UIButton!
    @IBAction func statusButtonPressed(_ sender: Any) {
        if TodayHabitCardView.derivedData?.state != .completed {
            progressAppend(data: &(TodayHabitCardView.derivedData)!)
            DispatchQueue(label: "background").async {
                autoreleasepool {
                    DataProvider.update(id: self.cellId!, obj: TodayHabitCardView.derivedData as Any)
                }
            }
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
    @IBOutlet weak var quickLookProgressLabel: UILabel!
    
    //GLOBAL VARS
    let date = Date()
    public static var derivedData: JayData.HabitLocal?
    public var cellId: String?
    let successGreenColor = UIColor.init(displayP3Red: 91 / 255, green: 199 / 255, blue: 122 / 255, alpha: 1)
    private var delegate = CustomGriddedCalendarCollectionViewDelegate()
    public static var startingWeekday = 0
    var cellsPrinted = 0
    var daysInMonth = 0
    public static var today = Calendar.current.component(.day, from: Date()) + 1
    
    //MISC
    override func viewWillDisappear(_ animated: Bool) {
        DataProvider.update(id: cellId!, obj: TodayHabitCardView.derivedData as Any)
    }
    
    //Explicitly detecting whether the system appearance has changed in order to redraw the chart
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                setData()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    //Setting number of cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    //Setting cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func update(idCell: String, data: JayData.HabitLocal) {
        cellId = idCell
        TodayHabitCardView.derivedData = data
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        TodayHabitCardView.startingWeekday = Calendar.current.component(.weekday, from: Calendar.current.date(from: DateComponents(year: year, month: month, day: 0))!)
        daysInMonth = Jay.getDaysInMonth(month: month)
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
    
    //MARK: DEBUG – REMOVE IN PRODUCTION
    let values: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 50.0),
        ChartDataEntry(x: 1.0, y: 35.0),
        ChartDataEntry(x: 2.0, y: 40.0),
        ChartDataEntry(x: 3.0, y: 25.0),
        ChartDataEntry(x: 4.0, y: 20.0),
        ChartDataEntry(x: 5.0, y: 46.0),
        ChartDataEntry(x: 6.0, y: 30.0),
        ChartDataEntry(x: 6.1, y: 0.0),
    ]
    //MARK: DEBUG END
    
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
    
    //Setting data for the chart
    private func setData() {
        let set = LineChartDataSet(entries: values)
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
        //Loading calendar
        let collectionView = UICollectionView (
            frame: CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize.zero
        }
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
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
        
        //Updating everything
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
            if !initial{
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.successAnimationView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                },
                               completion: { _ in
                                self.successAnimationView.isHidden = true
                })
            }
        }
        else {
            statusButton.setBackgroundImage(UIImage(named: "HabitIconDone"), for: .normal)
            quickLookProgressLabel.textColor = successGreenColor
            //MARK: Move detailsScrollView to front here
        }
    }
    
    //Function, called when user presses habit-completing button
    private func progressAppend(data: inout JayData.HabitLocal) {
        (data.wanted - data.completed == 1) ? (data.state = .completed) : (data.state = .incompleted)
        data.completed += 1
        playLottieAnimation (
            view: successAnimationView,
            named: "CheckedDone",
            after: { self.progressUpdate() }
        )
    }
    
    //Playing animation
    private func playLottieAnimation(view: AnimationView, named: String, after: @escaping () -> Void) {
        self.successAnimationView.transform = CGAffineTransform(scaleX: 1, y: 1)
        view.isHidden = false
        view.animation = Animation.named(named)
        view.loopMode = .playOnce
        view.play { _ in
            after()
        }
    }
}
