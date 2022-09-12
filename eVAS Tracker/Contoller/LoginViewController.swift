//
//  LoginViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/6/21.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var txt_password: customtextfiled!
    
    @IBOutlet weak var txt_email: UITextField!
    
    private let userViewModel = userValidationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupViewModel()
        txt_password.enablePasswordToggle()
        // Do any additional setup after loading the view.
    }
    func setupViewModel()
    {
        userViewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show(withStatus: "Validating...")
            }
        }
        userViewModel.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        userViewModel.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
                UserDefaults.standard.set("\(Info.empID ?? 0)", forKey:userDefaultVal.EmployeeID)
             
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTabBarController") as? MyTabBarController
                self?.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    userViewModel.onErrorHandler = { errorMessage in
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
       
    }
    @IBAction func btn_forgotPassword(_ sender: Any) {
    }
    @IBAction func btn_login(_ sender: UIButton) {
        
        
        if(txt_email.text != "" && txt_password.text  != "")
            {
      var request = userReqModel()
            request.EmailID = txt_email.text ?? ""
            request.Password = txt_password.text ?? ""
            userViewModel.fetchData(request: request)
          
            }
            else{
                
                let dialog = ZAlertView(title: "Error",
                                       message: Error_code(error_code: "04"),
                                       closeButtonText: "Okay",
                                       closeButtonHandler: { alertView in
                                           alertView.dismissAlertView()
                                       }
                                   )
                                   dialog.allowTouchOutsideToDismiss = false
                             
                                   dialog.show()
            }
            
        
        
     
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
