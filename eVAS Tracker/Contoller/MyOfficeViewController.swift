//
//  MyOfficeViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/5/21.
//

import UIKit
import SVProgressHUD
import Charts
class MyOfficeViewController: UIViewController {
 
    
    @IBOutlet weak var barchart: BarChartView!
    
    var officeInfo = OfficeStatisticsModel()
    private let MyOfficeStatisticsViewModel = GetMyOfficeStatisticsViewModel()
    @IBOutlet weak var lbl_totalCases: UILabel!
    
    @IBOutlet weak var lbl_last14DaysActive: UILabel!
    @IBOutlet weak var lbl_activeCases: UILabel!
    @IBOutlet weak var lbl_last14DaysCases: UILabel!
    
    @IBOutlet weak var lbl_accomodation: UILabel!
    @IBOutlet weak var lbl_notKnown: UILabel!
    @IBOutlet weak var lbl_notCompleted: UILabel!
    @IBOutlet weak var lbl_completed: UILabel!
    @IBOutlet weak var lbl_availbleInOffice: EFCountingLabel!
    @IBOutlet weak var lbl_totalMember: EFCountingLabel!
    let months = ["Office 1", "Office 2", "Office 3", "Office 4", "Office 5"]
        let unitsSold = [164.0, 60.0, 80.0, 30.0, 50.0]
        let unitsBought = [150.0, 30.0, 20.0, 30.0, 40.0]
    override func viewDidLoad() {
        super.viewDidLoad()
    
       

       
   
    }
    func setChart() {
        
        
          barchart.noDataText = "You need to provide data for the chart."
      


                     //legend
                     let legend = barchart.legend
                     legend.enabled = true
                     legend.horizontalAlignment = .right
                     legend.verticalAlignment = .top
                     legend.orientation = .vertical
                     legend.drawInside = true
                     legend.yOffset = 10.0;
                     legend.xOffset = 10.0;
                     legend.yEntrySpace = 0.0;


                     let xaxis = barchart.xAxis
              
                     xaxis.drawGridLinesEnabled = true
                     xaxis.labelPosition = .bottom
                     xaxis.centerAxisLabelsEnabled = true
                     xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
                     xaxis.granularity = 1
          
          
          let leftAxisFormatter = NumberFormatter()
          leftAxisFormatter.maximumFractionDigits = 1

          let yaxis = barchart.leftAxis
          yaxis.spaceTop = 0.35
          yaxis.axisMinimum = 0
          yaxis.drawGridLinesEnabled = false

          barchart.rightAxis.enabled = false
        
        
        
        
        barchart.backgroundColor = UIColor.clear
        barchart.noDataText = "You need to provide data for the chart."
           var dataEntries: [BarChartDataEntry] = []
           var dataEntries1: [BarChartDataEntry] = []

           for i in 0..<months.count {

               let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i])
               dataEntries.append(dataEntry)

               let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.unitsBought[i])
               dataEntries1.append(dataEntry1)

               //stack barchart
               //let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")



           }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Total Member")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Vaccinated Member")
        
           let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
           chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
           //chartDataSet.colors = ChartColorTemplates.colorful()
           //let chartData = BarChartData(dataSet: chartDataSet)

           let chartData = BarChartData(dataSets: dataSets)


           let groupSpace = 0.3
           let barSpace = 0.05
           let barWidth = 0.3
           // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"

           let groupCount = self.months.count
           let startYear = 0


           chartData.barWidth = barWidth;
        barchart.xAxis.axisMinimum = Double(startYear)
           let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
           print("Groupspace: \(gg)")
        barchart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

           chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
           //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barchart.notifyDataSetChanged()

        barchart.data = chartData

           //background color
      //  barchart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

           //chart animation
        barchart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)


       }
    func setChart(dataPoints: [String], values: [Double]) {
        barchart.noDataText = "You need to provide data for the chart."
      
      var dataEntries: [BarChartDataEntry] = []
      
      for i in 0..<dataPoints.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
        dataEntries.append(dataEntry)
      }
      
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
      let chartData = BarChartData(dataSet: chartDataSet)
        barchart.data = chartData
    }
    override func viewWillAppear(_ animated: Bool) {
      
      
        setChart()
      setupViewModel()
    }
    func setupViewModel()
    {
        MyOfficeStatisticsViewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show()
            }
        }
        MyOfficeStatisticsViewModel.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        MyOfficeStatisticsViewModel.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
                self?.officeInfo = Info
            
       
                self?.getFeildInfomation()
            }
        }
        MyOfficeStatisticsViewModel.onErrorHandler = { errorMessage in
            DispatchQueue.main.async { [self] in
          
            let dialog = ZAlertView(title: "Error",
                                   message:errorMessage,
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
        }
        }
   
        MyOfficeStatisticsViewModel.fetchData(EmployeeID: "\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
    }
    func getFeildInfomation()
    {
        lbl_totalCases.text = "\(officeInfo.reportedCases ?? 0)"
        lbl_activeCases.text = "\(officeInfo.activeCases ?? 0)"
        lbl_last14DaysActive.text = "\(officeInfo.activeCasesLast14Days ?? 0)"
        lbl_totalMember.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
        lbl_totalMember.countFrom(0, to: CGFloat(officeInfo.teamMembers ?? 0))
        lbl_totalMember.setUpdateBlock { value, label in
            self.lbl_totalMember.text = "\(Int(value))"
        }
            
            self.lbl_availbleInOffice.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            self.lbl_availbleInOffice.countFrom(0, to: CGFloat(officeInfo.teamMembersInOffice ?? 0))
            self.lbl_availbleInOffice.setUpdateBlock { value, label in
                self.lbl_availbleInOffice.text = "\(Int(value))"
        }
       // lbl_completed.text = "63%"
       lbl_completed.text = "\(Int((Double(self.officeInfo.vaccineDone ?? 0)/Double(self.officeInfo.teamMembers ?? 0))*100))%"
        lbl_notCompleted.text = "\(Int((Double(self.officeInfo.notDone ?? 0)/Double(self.officeInfo.teamMembers ?? 0))*100))%"
        lbl_notKnown.text = "\(Int((Double(self.officeInfo.notKnown ?? 0)/Double(self.officeInfo.teamMembers ?? 0))*100))%"
        lbl_accomodation.text = "\(Int((Double(self.officeInfo.religiousmedicalCount ?? 0)/Double(self.officeInfo.teamMembers ?? 0))*100))%"
      
  
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
