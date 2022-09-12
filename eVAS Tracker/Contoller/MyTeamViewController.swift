//
//  MyTeamViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/4/21.
//

import UIKit
import MBCircularProgressBar
import SVProgressHUD
class MyTeamViewController: UIViewController {
    
    @IBOutlet weak var lbl_feelingSymptoms: UILabel!
    
    @IBOutlet weak var lbl_last14DaysActiveCases: UILabel!
    @IBOutlet weak var totalActiveCases: UILabel!
    
    @IBOutlet weak var lbl_feelingGood: UILabel!
    @IBOutlet weak var lbl_closeContact: UILabel!
    
    @IBOutlet weak var lbl_totalMembers: EFCountingLabel!
    
    @IBOutlet weak var lbl_inOfficeMembers: EFCountingLabel!
    

    @IBOutlet weak var complted: MBCircularProgressBarView!
    @IBOutlet weak var accomadation: MBCircularProgressBarView!
    @IBOutlet weak var notKnown: MBCircularProgressBarView!
    @IBOutlet weak var notCompleted: MBCircularProgressBarView!
    
    var teamInfo = TeamStatisticsModel()
    private let MyTeamStatisticsViewModel = GetMyTeamStatisticsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
        
setupViewModel()
        
}
    
    func setupViewModel()
    {
        MyTeamStatisticsViewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show()
            }
        }
        MyTeamStatisticsViewModel.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        MyTeamStatisticsViewModel.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
                self?.teamInfo = Info
            
       
                self?.getFeildInfomation()
            }
        }
        MyTeamStatisticsViewModel.onErrorHandler = { errorMessage in
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
   
        MyTeamStatisticsViewModel.fetchData(EmployeeID: "\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
    }
    func getFeildInfomation()
    {
     
        totalActiveCases.text = "\(teamInfo.activeCases ?? 0)"
        lbl_last14DaysActiveCases.text = "\(teamInfo.activeCasesLast14Days ?? 0)"
        lbl_totalMembers.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
        lbl_totalMembers.countFrom(0, to: CGFloat(teamInfo.teamMembers ?? 0))
        lbl_totalMembers.setUpdateBlock { value, label in
            self.lbl_totalMembers.text = "\(Int(value))"
        }
            
            self.lbl_inOfficeMembers.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 3)
            self.lbl_inOfficeMembers.countFrom(0, to: CGFloat(teamInfo.teamMembersInOffice ?? 0))
            self.lbl_inOfficeMembers.setUpdateBlock { value, label in
                self.lbl_inOfficeMembers.text = "\(Int(value))"
        }
        DispatchQueue.main.async { //[.repeat, .curveEaseOut, .autoreverse]
         
          
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveLinear], animations: {
           
            self.complted.value = CGFloat((Double(self.teamInfo.vaccineDone ?? 0)/Double(self.teamInfo.teamMembers ?? 0))*100)
            self.notCompleted.value =  CGFloat((Double(self.teamInfo.notDone ?? 0)/Double(self.teamInfo.teamMembers ?? 0))*100)
            self.notKnown.value =  CGFloat((Double(self.teamInfo.notKnown ?? 0)/Double(self.teamInfo.teamMembers ?? 0))*100)
            self.accomadation.value =  CGFloat((Double(self.teamInfo.religiousmedicalCount ?? 0)/Double(self.teamInfo.teamMembers ?? 0))*100)
        }, completion: nil)
        }
  
    }
    }

