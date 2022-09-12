//
//  ReportCloseContactViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import UIKit
import SVProgressHUD
class ReportCloseContactViewController: UIViewController,UITextViewDelegate {
    var notifyHRViewModel = NotifyHRViewModel()
    var onAcceptSignature: ((Bool) -> Void)?
    var datePickerVC: STDatePickerViewController? = nil
    var containerDelegate: OkuraFormContainerDelegate?
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    @IBOutlet weak var txt_textview: UITextView!
    @IBOutlet weak var txt_date: OkuraUnderlineDatePickerField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_textview.delegate = self
        txt_textview.layer.borderWidth = 1.0
        txt_textview.layer.borderColor = UIColor.gray.cgColor
        txt_textview.layer.cornerRadius = 8.0

        txt_date.text = toDate()
        
        embedPrompts()
        setupDatePickerFields()
      
    }
    private func embedPrompts() {
      
        
        self.datePickerVC = STDatePickerViewController.storyboardInstance() as? STDatePickerViewController
        self.embed(viewController: self.datePickerVC!)
        self.datePickerVC?.view.isHidden = true
     
    }
    private func setupDatePickerFields() {
        txt_date.datePickerVC = self.datePickerVC
        txt_date.isBirthDate = true
        txt_date.load()
        txt_date.onEditStart = { datePickerField in
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: false)
        }
       
        txt_date.onEditDone = { [self] textString in
            
            txt_date.text = textString
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: true)
        }
        
        
        
       
    }
    
    func CallNotifyHR(requestHR:NotifyHRModel)
    {
   
        notifyHRViewModel.onStartLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.show()
                }
            }
        notifyHRViewModel.onStopLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.dismiss()
                }
            }
        notifyHRViewModel.onSuccessHandler = {[weak self] (Info) in
                print("sucess")
            if (self?.onAcceptSignature != nil) {
                self?.onAcceptSignature!(true)
            }
            }
        notifyHRViewModel.onErrorHandler = { errorMessage in
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
        notifyHRViewModel.fetchData(request: requestHR)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func textViewDidChange(_ textView: UITextView) {
          
       }
    @IBAction func btn_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_reportCloseContact(_ sender: Any) {
        if(txt_date.text == "")
        {
            
        }
        else{
            
          
         
            var notify = NotifyHRModel()
            notify.CloseContactDate = txt_date.text
            notify.CloseContactDetails = txt_textview.text
            notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
            self.CallNotifyHR(requestHR: notify)
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
extension UITextField
{
    func setBottomBorder(withColor color: UIColor)
    {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0

        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}
extension UIViewController {
    func embed(viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = self.view.frame
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}
