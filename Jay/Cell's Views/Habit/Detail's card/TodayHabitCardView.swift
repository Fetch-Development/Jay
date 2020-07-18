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

class TodayHabitCardView: UIView, ChartViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    //VIEWS
    @IBOutlet var habitCardView: UIView!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var successAnimationView: AnimationView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    //BUTTONS
    @IBOutlet weak var statusButton: UIButton!
    @IBAction func statusButtonPressed(_ sender: Any) {
        progressAppend(data: &derivedData)
    }
    //LABELS
    @IBOutlet weak var calendarDateLabel: UILabel!
    @IBOutlet weak var quickLookProgressLabel: UILabel!
    
    //GLOBAL VARS
    let date = Date()
    private var derivedData = JayData.Habit(
        name: "1",
        createdAt: Date(),
        completed: 0,
        wanted: 0,
        state: .untouched,
        history: JayData.JayHabitHistory(habits: [])
    )
    let successGreenColor = UIColor.init(displayP3Red: 91/255, green: 199/255, blue: 122/255, alpha: 1)
    var delegate = CustomGriddedCelendarCollectionViewDelegate()
    var startingWeekday = 0
    var cellsPrinted = 0
    var daysInMonth = 0
    
    //Setting number of cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    //Setting cells in Calendar CV
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var imageView = UIImageView()
        let today = Calendar.current.component(.day, from: Date()) + 1
        
        //Changing UIImage according to habit history
        if indexPath.item >= startingWeekday - 1 && indexPath.item <= (daysInMonth - startingWeekday - 3) {
            if indexPath.item - (startingWeekday - 1) < derivedData.history.habits.endIndex && indexPath.item - (startingWeekday - 1) >= 0{
               
                switch derivedData.history.habits[indexPath.item - (startingWeekday - 1)].state {
                case .completed:
                    imageView = UIImageView(image: UIImage(systemName: "smallcircle.fill.circle"))
                case .incompleted:
                    imageView = UIImageView(image: UIImage(systemName: "smallcircle.circle"))
                case .untouched:
                    imageView = UIImageView(image: UIImage(systemName: "slash.circle"))
                default:
                    imageView = UIImageView(image: UIImage(systemName: "circle"))
                }
            //Detecting if its today
            } else if indexPath.item == today{
                imageView = UIImageView(image: UIImage(systemName: "largecircle.fill.circle"))
            } else {
                imageView = UIImageView(image: UIImage(systemName: "circle"))
            }
            
            //Setting cell's tint color
            if indexPath.item <= today {
                imageView.tintColor = .darkGray
            } else {
                imageView.tintColor = .systemGray
            }
            cell.contentView.addSubview(imageView)
            imageView.centerInSuperview()
            imageView.widthToSuperview()
            imageView.heightToSuperview()
        }
        return cell
    }
    
    //Initializing everything
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    init(data: JayData.Habit, frame: CGRect) {
        self.derivedData = data
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        startingWeekday = Calendar.current.component(.weekday, from: Calendar.current.date(from: DateComponents(year: year, month: month, day: 0))!)
        daysInMonth = Jay.getDaysInMonth(month: month)
        super.init(frame: frame)
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
    
    //Main XIB init function
    public func commonInit(){
        //Loading XIB
        Bundle.main.loadNibNamed("TodayHabitCard", owner: self, options: nil)
        addSubview(habitCardView)
        habitCardView.frame = self.bounds
        habitCardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //Loading chart
        graphView.insertSubview(lineChartView, at: 0)
        lineChartView.centerInSuperview()
        lineChartView.width(to: graphView)
        lineChartView.height(to: graphView)
        setData()
        
        //Loading calendar
        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 100,
                          width: self.bounds.width, height: 500),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.dataSource = self
        collectionView.delegate = self
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
        collectionView.widthToSuperview()
        collectionView.heightToSuperview()
        
        //Updating everything
        progressUpdate()
    }
    
    //Updating all labels, images, and misc
    private func progressUpdate(){
        quickLookProgressLabel.text = String(derivedData.completed) + "/" + String(derivedData.wanted)
        let calendarDateData = Jay.getCalendarDateData()
        calendarDateLabel.text = calendarDateData.0 + " " + calendarDateData.1
        if derivedData.state != .completed{
            statusButton.setBackgroundImage(UIImage(named: "HabitIcon"
                + String(derivedData.completed) + "."
                + String(derivedData.wanted)), for: .normal)
            successAnimationView.isHidden = true
        }
        else{
            statusButton.setBackgroundImage(UIImage(named: "HabitIconDone"), for: .normal)
            quickLookProgressLabel.textColor = successGreenColor
            //MARK: Move detailsScrollView to front here
        }
    }
    
    //Function, called when user presses habit-completing button
    private func progressAppend(data: inout JayData.Habit){
        // if derivedData.state != .completed{
        data.state = .incompleted
        if data.wanted - data.completed == 1{
            data.state = .completed
        }
        data.completed += 1
        playLottieAnimation(
            view: successAnimationView, named: "CheckedDone", after:
            {
                self.progressUpdate()
        }
        )
    }
    
    //Playing animation
    private func playLottieAnimation(view: AnimationView, named: String, after: @escaping () -> Void){
        view.isHidden = false
        view.animation = Animation.named(named)
        view.loopMode = .playOnce
        view.play { (finished) in
            after()
        }
    }
}
