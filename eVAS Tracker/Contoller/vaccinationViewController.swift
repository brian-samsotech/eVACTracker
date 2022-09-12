//
//  vaccinationViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import UIKit
import SVProgressHUD
class vaccinationViewController: UIViewController {
    var dropMenuVC: STDropMenuViewController? = nil
    var datePickerVC: STDatePickerViewController? = nil
    var containerDelegate: OkuraFormContainerDelegate?
    
    var onAcceptSignature: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    @IBOutlet weak var docImageView: UIImageView!
    @IBOutlet weak var lbl_fileName: UILabel!
    @IBOutlet weak var txt_doseNumber: OkuraUnderlinedDropMenuField!
    @IBOutlet weak var txt_date: OkuraUnderlineDatePickerField!
    @IBOutlet weak var txt_vaccinationName: OkuraUnderlinedDropMenuField!
    
    var VaccinationReportViewModel = uploadVaccinationReportViewModel()
    var doseModel = [DoseMasterModel]()
    var vaccinationModel = [VaccinationStatusModel]()
    private let doseMasterViewModel = DoseMasterViewModel()
    private let getVaccineMasterList = GetVaccineMasterList()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_date.layer.cornerRadius = 8.0
        txt_date.layer.borderWidth = 1.0
        txt_date.layer.borderColor = primarycolor.cgColor
        docImageView.isHidden = true
        embedPrompts()
        setupDatePickerFields()
        setupDropMenuFields()
        setupDoseMaster()
        setupVaccinationMaster()
       
      
    
    }
    func UploadVaccination(request:uploadVaccinationRequest)
    {
   
        VaccinationReportViewModel.onStartLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.show()
                }
            }
        VaccinationReportViewModel.onStopLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.dismiss()
                }
            }
        VaccinationReportViewModel.onSuccessHandler = {[weak self] (Info) in
                print("sucess")
            if (self?.onAcceptSignature != nil) {
                self?.onAcceptSignature!(true)
            }
 
            }
        VaccinationReportViewModel.onErrorHandler = { errorMessage in
                DispatchQueue.main.async { [self] in
                    if (self.onError != nil) {
                        self.onError!(errorMessage)
                    }
                    
            }
            }
        VaccinationReportViewModel.fetchData(request: request)
       
    }
    func setupVaccinationMaster()
    {
        getVaccineMasterList.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show()
            }
        }
        getVaccineMasterList.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        getVaccineMasterList.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
           var vaccinedata = [String]()
                self?.vaccinationModel = Info
                for object in Info{
                    

                    if(object.vaccineName != nil)
                    {
                    if (vaccinedata.contains(object.vaccineName!)){
                     
                }
                    else{
                        vaccinedata.append(object.vaccineName!)
                    }
                   
                     
                    }
                }
                 print(vaccinedata)
                self?.txt_vaccinationName.loadDatafromApi(Data:vaccinedata)
                
            }
        }
        getVaccineMasterList.onErrorHandler = { errorMessage in
            DispatchQueue.main.async { [self] in
          
                if (self.onError != nil) {
                    self.onError!(errorMessage)
                }
                
        }
        }
       
        getVaccineMasterList.fetchData()
    }
    func setupDoseMaster()
    {
        doseMasterViewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show()
            }
        }
        doseMasterViewModel.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        doseMasterViewModel.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
           
                self?.doseModel = Info
       
                var dosedata = [String]()
                  
                     for object in Info{
                         

                         if(object.doseName != nil)
                         {
                         if (dosedata.contains(object.doseName!)){
                          
                     }
                         else{
                            dosedata.append(object.doseName!)
                         }
                        
                          
                         }
                     }
                self?.txt_doseNumber.loadDatafromApi(Data: dosedata)
                   
            }
        }
        doseMasterViewModel.onErrorHandler = { errorMessage in
            DispatchQueue.main.async { [self] in
                if (self.onError != nil) {
                    self.onError!(errorMessage)
                }
                
        }
        }
       
        doseMasterViewModel.fetchData()
    }
    private func embedPrompts() {
        self.dropMenuVC = STDropMenuViewController.storyboardInstance() as? STDropMenuViewController
        self.embed(viewController: self.dropMenuVC!)
        self.dropMenuVC?.view.isHidden = true
        
        self.datePickerVC = STDatePickerViewController.storyboardInstance() as? STDatePickerViewController
        self.embed(viewController: self.datePickerVC!)
        self.datePickerVC?.view.isHidden = true
     
    }
    private func setupDropMenuFields() {
        
        txt_doseNumber.dropMenuVC = self.dropMenuVC
        
        
        txt_doseNumber.onOpenDropMenu = { options in
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: false)
        }
        
        txt_doseNumber.onEditDone = { textString in
      
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: true)
        }
        
        
        txt_vaccinationName.dropMenuVC = self.dropMenuVC
        
        
        txt_vaccinationName.onOpenDropMenu = { options in
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: false)
        }
        
        txt_vaccinationName.onEditDone = { textString in
      
            self.containerDelegate?.setDismissKeyboardTapRecognizer(enabled: true)
        }
        
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
    @IBAction func btn_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_upload(_ sender: UIButton) {
        
        if(txt_vaccinationName.text != "" && txt_doseNumber.text != "" && txt_date.text != "" && docImageView.image != nil)
        {
            
       
        var req = uploadVaccinationRequest()
        req.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
        req.FileBase64String = convertImageToBase64String(img:  self.docImageView.image ?? UIImage())
        req.VaccinationDateTime = formattedDateFromString(dateString: txt_date.text!, InputFormat: "yyyy-MM-dd", OutputFormat: "yyyy-MM-dd'T'HH:mm:ss")
        req.VaccinationName = txt_vaccinationName.text ?? ""
        req.DoseNumber = Int(txt_doseNumber.text ?? "0")
        let data:[VaccinationStatusModel] = self.vaccinationModel.filter { (CONFIGMODEL: VaccinationStatusModel) -> Bool in
             return CONFIGMODEL.vaccineName == txt_vaccinationName.text
         }
        if(data.count != 0)
        {
        req.VaccineID = data[0].vaccineID
        }
        let data2:[DoseMasterModel] = self.doseModel.filter { (CONFIGMODEL: DoseMasterModel) -> Bool in
            return CONFIGMODEL.doseName == txt_doseNumber.text
         }
        if(data2.count != 0)
        {
        req.DoseID = data2[0].doseID
        }
        UploadVaccination(request: req)
        }
        else{
            let dialog = ZAlertView(title: "Message",
                                   message:"Enter all required fields.",
                                   closeButtonText: "Okay",
                                   closeButtonHandler: { alertView in
                                       alertView.dismissAlertView()
                                  
                                   }
                               )
                               dialog.allowTouchOutsideToDismiss = false
                         
                               dialog.show()
        }
    }
    @IBAction func btn_chooseDocument(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.showAlert()
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
extension vaccinationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }

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
