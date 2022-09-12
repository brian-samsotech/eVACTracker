//
//  ChangePasswordViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/9/21.
//

import UIKit
import SVProgressHUD
class ChangePasswordViewController: UIViewController {
  var changePasswordViewModel = ChangePasswordViewModel()
    @IBOutlet weak var txt_confirmPassword: customtextfiled!
    @IBOutlet weak var txt_newPassword: customtextfiled!
    @IBOutlet weak var txt_oldPassword: customtextfiled!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_resertPassword(_ sender: UIButton) {
        
        if(txt_oldPassword.text != nil && txt_newPassword.text != nil && txt_confirmPassword.text != nil)
        {
            if(txt_newPassword.text != txt_confirmPassword.text)
            {
                let dialog = ZAlertView(title: "Error",
                                       message:"Password and Confirmation password do not match",
                                       closeButtonText: "Okay",
                                       closeButtonHandler: { alertView in
                                           alertView.dismissAlertView()
                                      
                                       }
                                   )
                                   dialog.allowTouchOutsideToDismiss = false
                             
                                   dialog.show()
            }
            else{
            callApi()
                
               
            }
        }
        else{
            let dialog = ZAlertView(title: "Error",
                                   message:"Enter required fields",
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
        }
    }
    func callApi()
    {
        changePasswordViewModel.onStartLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.show()
                }
            }
        changePasswordViewModel.onStopLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.dismiss()
                }
            }
        changePasswordViewModel.onSuccessHandler = {[weak self] (Info) in
            let dialog = ZAlertView(title: "Message",
                                   message:"Password reset successful",
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
            }
        changePasswordViewModel.onErrorHandler = { errorMessage in
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
        var requestData = ChangePasswordModel()
        requestData.OldPassword = txt_oldPassword.text ?? ""
        requestData.NewPassword = txt_newPassword.text ?? ""
        requestData.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
        changePasswordViewModel.fetchData(request: requestData)
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
