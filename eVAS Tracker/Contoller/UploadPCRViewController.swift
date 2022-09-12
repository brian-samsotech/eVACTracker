//
//  UploadPCRViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import UIKit
import SVProgressHUD
class UploadPCRViewController: UIViewController {
    var datePickerVC: STDatePickerViewController? = nil
    var containerDelegate: OkuraFormContainerDelegate?
    @IBOutlet weak var lbl_fileName: UILabel!
    @IBOutlet weak var txt_date: OkuraUnderlineDatePickerField!
    var PCRReportViewModel = uploadPCRReportViewModel()
    var req = uploadPCRRequest()
    @IBOutlet weak var btnPositive: UIButton!
    var onAcceptSignature: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    @IBOutlet weak var docImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        btnPositive.setImage(UIImage(systemName: "squareshape", withConfiguration: boldConfig) ?? UIImage(), for: .normal)
        req.IsPCRPositive = false
        embedPrompts()
        setupDatePickerFields()
        docImageView.isHidden = true
        txt_date.layer.cornerRadius = 8.0
        txt_date.layer.borderWidth = 1.0
        
        txt_date.layer.borderColor = primarycolor.cgColor
        // Do any additional setup after loading the view.
    }
    func UploadPCR(request:uploadPCRRequest)
    {
   
        PCRReportViewModel.onStartLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.show()
                }
            }
        PCRReportViewModel.onStopLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.dismiss()
                }
            }
        PCRReportViewModel.onSuccessHandler = {[weak self] (Info) in
                print("sucess")
            if (self?.onAcceptSignature != nil) {
                self?.onAcceptSignature!(true)
            }
  
            }
        PCRReportViewModel.onErrorHandler = { errorMessage in
                DispatchQueue.main.async { [self] in
              
                    if (self.onError != nil) {
                        self.onError!(errorMessage)
                    }
                    
            }
        }
        PCRReportViewModel.fetchData(request: request)
       
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
    @IBAction func btn_uploadDocument(_ sender: Any) {
  
        if(txt_date.text == "")
        {
            let dialog = ZAlertView(title: "Message",
                                   message:"Date field should not be empty",
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
        }
        else if(self.docImageView.image == nil)
        {
            let dialog = ZAlertView(title: "Message",
                                   message:"Choose Document to continue with upload",
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
        }
        else
        {
        req.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
        req.FileBase64String = convertImageToBase64String(img:  self.docImageView.image ?? UIImage())
        req.PCRDateTime = formattedDateFromString(dateString: txt_date.text!, InputFormat: "yyyy-MM-dd", OutputFormat: "yyyy-MM-dd'T'HH:mm:ss")
       
        UploadPCR(request: req)
        }
    }
    @IBAction func btn_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_chooseFile(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.showAlert()
        }
    }
    @IBAction func btn_ispostive(_ sender: UIButton) {
        
        //squareshape
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let boldSearch = UIImage(systemName: "checkmark.square.fill", withConfiguration: boldConfig) ?? UIImage()
        
        
        if (sender.currentImage == boldSearch){
            //do something here
            req.IsPCRPositive = false
            sender.setImage(UIImage(systemName: "squareshape", withConfiguration: boldConfig) ?? UIImage(), for: .normal)
        }
        else{
            req.IsPCRPositive = true
            sender.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: boldConfig) ?? UIImage(), for: .normal)
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
extension UploadPCRViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    

    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Message", message: "Choose any option to contine upload", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
          //  self?.profileImgView.image = image
            self?.docImageView.isHidden = false
            self?.docImageView.image = image
            self?.lbl_fileName.text = "1 file selected"
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
