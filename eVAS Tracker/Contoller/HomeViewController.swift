//
//  HomeViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/4/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SVProgressHUD

class HomeViewController: UIViewController,UIDocumentPickerDelegate{
    weak var shapeLayer: CAShapeLayer?
   
    @IBOutlet weak var lbl_pcrWarnning: UILabel!
    
    @IBOutlet weak var bg_vaccinationAnimation: BorderShimmerView!
    @IBOutlet weak var bg_pcrAnimation: BorderShimmerView!
    @IBOutlet weak var btn_PCRUpload: UIButton!
    @IBOutlet weak var btn_vaccinationUpload: UIButton!
    @IBOutlet weak var covidPositiveNo: UIButton!
    
    @IBOutlet weak var covidPositiveYES: UIButton!
    
    
    @IBOutlet weak var covidSymptomsNO: UIButton!
    
    @IBOutlet weak var covidSymptomsYES: UIButton!
    
    
    @IBOutlet weak var backInoffice: LabelSwitch!
    
    @IBOutlet weak var pcrView: UIView!
    @IBOutlet weak var vaccinationView: UIView!
    
    
    //Profile Info
    
    
    @IBOutlet weak var lbl_pendingTask: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    //Vacination Card
    
    @IBOutlet weak var lbl_vaccineDate: UILabel!
    @IBOutlet weak var lbl_vaccineSatus: UILabel!
    @IBOutlet weak var lbl_vaccineName: UILabel!
    
    
    //PCR CARD
    
    @IBOutlet weak var lbl_pcrStatus: UILabel!
    @IBOutlet weak var lbl_pcrDate: UILabel!
    
    
    //Risk
    
    @IBOutlet weak var lbl_riskStatus: UILabel!
    
    @IBOutlet weak var lbl_lastUpdated: UILabel!
    @IBOutlet weak var lbl_exposure: UILabel!
    
    var ProfilePictureViewModel = uploadProfilePictureViewModel()
    var notifyHRViewModel = NotifyHRViewModel()
    private let EmployeeStatisticsViewModel = GetEmployeeStatisticsViewModel()
    
    var userInformation = userModel()
    
    
    //CardView
    var transparentView = UIView()
    var tableView = UITableView()
    
    let height: CGFloat = 250
    
    var settingArray = ["Notification","Change Password","Logout"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.bg_vaccinationAnimation.StopAnimation()
       // self.bg_pcrAnimation.StopAnimation()
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
       
        backInoffice.delegate = self
        backInoffice.curState = .L
        backInoffice.circleShadow = true
        backInoffice.fullSizeTapEnabled = true

        lbl_pcrWarnning.isHidden = true
        let signatureVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EveryDayViewController") as? EveryDayViewController
       
        signatureVC?.modalPresentationStyle = .overFullScreen
        
        signatureVC?.onAcceptSignature = { status in
          
            signatureVC?.dismiss(animated: false, completion: nil)
          
         
 var notify = NotifyHRModel()
            notify.AreyouFeelingGoodToday = status
            notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
            self.CallNotifyHR(requestHR: notify)
        }
            self.present(signatureVC!, animated: false, completion: nil)
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        print(timestamp)
        lbl_lastUpdated.text = timestamp
       
    }
    func setupViewModel()
    {
        EmployeeStatisticsViewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.show()
            }
        }
        EmployeeStatisticsViewModel.onStopLoading = { [weak self] in
            DispatchQueue.main.async {
                print("show async")
                SVProgressHUD.dismiss()
            }
        }
        EmployeeStatisticsViewModel.onSuccessHandler = {[weak self] (Info) in
            DispatchQueue.main.async { [self] in
                self?.userInformation = Info
            
       
                self?.getFeildInfomation()
            }
        }
        EmployeeStatisticsViewModel.onErrorHandler = { errorMessage in
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
       
        EmployeeStatisticsViewModel.fetchData(EmployeeID: "\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
    }
    func getFeildInfomation()
    {
        lbl_name.text = userInformation.fullName ?? ""
        if(userInformation.vaccinatedDate != nil)
        {
            
            
        lbl_vaccineDate.text = formattedDateFromString(dateString: userInformation.vaccinatedDate ?? "", InputFormat:"yyyy-MM-dd'T'HH:mm:ss", OutputFormat:"yyyy-MM-dd")
            lbl_vaccineDate.isHidden = false
        }
        else{
            lbl_vaccineDate.isHidden = true
        }
        if(userInformation.vaccineName != nil)
        {
            lbl_vaccineName.text = userInformation.vaccineName ?? ""
            lbl_vaccineName.isHidden = false
        }
        else{
            lbl_vaccineName.isHidden = true
        }
        if(userInformation.lastPCRDate != nil)
        {
            lbl_pcrDate.text =  formattedDateFromString(dateString: userInformation.lastPCRDate ?? "", InputFormat:"yyyy-MM-dd'T'HH:mm:ss", OutputFormat:"yyyy-MM-dd")
            lbl_pcrDate.isHidden = false
        }
        else{
            lbl_pcrDate.isHidden = true
        }
      
       
        lbl_pcrStatus.text = getPCRType(Days: userInformation.noofDaysLastPCR ?? 0).0
        pcrView.backgroundColor = getPCRType(Days: userInformation.noofDaysLastPCR ?? 0).1
       
        if(!getPCRType(Days: userInformation.noofDaysLastPCR ?? 0).2)
        {
            //bg_pcrAnimation.StartAnimation()
        }
        else{
           // bg_pcrAnimation.StopAnimation()
        }
        
        lbl_vaccineSatus.text = getVaccinationType(Type: userInformation.statusCategory ?? "").0
        vaccinationView.backgroundColor = getVaccinationType(Type: userInformation.statusCategory ?? "").1
        btn_vaccinationUpload.isHidden = !getVaccinationType(Type: userInformation.statusCategory ?? "").2
        
        if(!getVaccinationType(Type: userInformation.statusCategory ?? "").2)
        {
            bg_vaccinationAnimation.StartAnimation()
        }
        else{
            bg_vaccinationAnimation.StopAnimation()
        }
        lbl_riskStatus.text = userInformation.currentRiskCategory ?? ""
        
        if(userInformation.closeContactFlag != 0)
     {
            
            lbl_exposure.text = "Had exposure on \(formattedDateFromString(dateString: userInformation.contactDate ?? "", InputFormat:"yyyy-MM-dd'T'HH:mm:ss", OutputFormat:"yyyy-MM-dd") ?? "")"
     }
     else{
             lbl_exposure.text = "No exposure in last 14 days"
     }
        if(userInformation.backInOffice ?? false)
        {
            backInoffice.curState = .L
        }
        else{
            backInoffice.curState = .R
        }
     
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .short)
        print(timestamp)
        lbl_lastUpdated.text = timestamp
   profilePic.image = convertBase64StringToImage(imageBase64String: userInformation.empPhoto ?? "")
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
   
 
        profilePic.makeRounded()
      
        setupViewModel()
    }

    
    @IBAction func btn_reportCloseContact(_ sender: UIButton) {
        
        
        
        
        
        let signatureVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReportCloseContactViewController") as? ReportCloseContactViewController
       
        signatureVC?.modalPresentationStyle = .overFullScreen
        
        signatureVC?.onAcceptSignature = { status in
            self.dismiss(animated: true, completion: nil)
            Loaf("Close contact reported succesfully", state: .success, sender: self).show()
        
         
          
     
        }
            self.present(signatureVC!, animated: false, completion: nil)
    }
    
    //0 - No
    //1 - Yes
    
    @IBAction func btn_CovidPositive(_ sender: UIButton) {
       
        
        if(sender.tag == 0)
        {
            
            
            let dialog = ZAlertView(title: "Message",
                      message: "Are you sure you want to notify HR?",
                      isOkButtonLeft: false,
                      okButtonText: "Yes",
                      cancelButtonText: "No",
                      okButtonHandler: { (alertView) -> () in
                          alertView.dismissAlertView()
                        
                     
               var notify = NotifyHRModel()
                        notify.AreyouCoviPositive = false
                        notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
                        self.CallNotifyHR(requestHR: notify)
                      },
                      cancelButtonHandler: { (alertView) -> () in
                          alertView.dismissAlertView()
                       
                      }
                  )
                  dialog.show()
                  dialog.allowTouchOutsideToDismiss = true
        }
      else{

       
        let dialog = ZAlertView(title: "Message",
                  message: "Are you sure you want to notify HR?",
                  isOkButtonLeft: false,
                  okButtonText: "Yes",
                  cancelButtonText: "No",
                  okButtonHandler: { (alertView) -> () in
                    
                    
                    
               
                    
                
                    var notify = NotifyHRModel()
                    notify.AreyouCoviPositive = true
                    notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
                    self.CallNotifyHR(requestHR: notify)
                  },
                  cancelButtonHandler: { (alertView) -> () in
                      alertView.dismissAlertView()
                   
                  }
              )
              dialog.show()
              dialog.allowTouchOutsideToDismiss = true
        }
      
    }
    func UploadPicture(request:uploadProfilePictureRequest)
    {
   
        ProfilePictureViewModel.onStartLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.show()
                }
            }
        ProfilePictureViewModel.onStopLoading = { [weak self] in
                DispatchQueue.main.async {
                    print("show async")
                    SVProgressHUD.dismiss()
                }
            }
        ProfilePictureViewModel.onSuccessHandler = {[weak self] (Info) in
                print("sucess")
    
   Loaf("Profile picture updated succesfully", state: .success, sender: self!).show()
            }
        ProfilePictureViewModel.onErrorHandler = { errorMessage in
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
        ProfilePictureViewModel.fetchData(request: request)
       
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
            self?.getFeildInfomation()
            Loaf("Notified HR succesfully", state: .success, sender: self!).show()
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
    
    @IBAction func btn_CovidSymptoms(_ sender: UIButton) {
        if(sender.tag == 0)
        {
            
            
            
               let dialog = ZAlertView(title: "Message",
                         message: "Are you sure you want to notify HR?",
                         isOkButtonLeft: false,
                         okButtonText: "Yes",
                         cancelButtonText: "No",
                         okButtonHandler: { (alertView) -> () in
                             alertView.dismissAlertView()
                        
                            
                       var notify = NotifyHRModel()
                           notify.DoYouHaveAnySymptoms = false
                           notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
                           self.CallNotifyHR(requestHR: notify)
                         },
                         cancelButtonHandler: { (alertView) -> () in
                             alertView.dismissAlertView()
                          
                         }
                     )
                     dialog.show()
                     dialog.allowTouchOutsideToDismiss = true
        }
      else{

     
        let dialog = ZAlertView(title: "Message",
                  message: "Are you sure you want to notify HR?",
                  isOkButtonLeft: false,
                  okButtonText: "Yes",
                  cancelButtonText: "No",
                  okButtonHandler: { (alertView) -> () in
                      alertView.dismissAlertView()
                   
              var notify = NotifyHRModel()
                    notify.DoYouHaveAnySymptoms = true
                    notify.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
                    self.CallNotifyHR(requestHR: notify)
                  },
                  cancelButtonHandler: { (alertView) -> () in
                      alertView.dismissAlertView()
                   
                  }
              )
              dialog.show()
              dialog.allowTouchOutsideToDismiss = true
        }
      
        
    }
    
    @IBAction func btn_takePhoto(_ sender: Any) {
        
        DispatchQueue.main.async { [self] in
            self.showAlert()
        }
     
    }
    @IBAction func btn_vaccineUpload(_ sender: UIButton) {
        let signatureVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vaccinationViewController") as? vaccinationViewController
       
        signatureVC?.modalPresentationStyle = .overFullScreen
        
        signatureVC?.onAcceptSignature = { status in
            self.dismiss(animated: true, completion: nil)
            Loaf("Vaccination report uploaded succesfully", state: .success, sender: self).show()
       
     
        }
        signatureVC?.onError = { status in
          
            self.dismiss(animated: true, completion: nil)
            Loaf(status, state: .error, sender: self).show()
          
    }
            self.present(signatureVC!, animated: false, completion: nil)
    }
    
    @IBAction func btn_pcrUpload(_ sender: UIButton) {
  
        
        
        let signatureVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UploadPCRViewController") as? UploadPCRViewController
       
        signatureVC?.modalPresentationStyle = .overFullScreen
        
        signatureVC?.onAcceptSignature = { status in
          
            self.dismiss(animated: true, completion: nil)
            Loaf("PCR report uploaded succesfully", state: .success, sender: self).show()
          
    }
        signatureVC?.onError = { status in
          
            self.dismiss(animated: true, completion: nil)
            Loaf(status, state: .error, sender: self).show()
          
    }
        self.present(signatureVC!, animated: false, completion: nil)
    }
    @IBAction func btn_notification(_ sender: UIButton) {
        
      /*  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationListViewController") as? NotificationListViewController
        self.navigationController?.pushViewController(vc!, animated: true)*/
        
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
        
    }
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
    }

}


class BorderShimmerView : UIView {
    
    /// allow gradient layer to resize automatically
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    /// boilerplate UIView initializers
   /* init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }*/
    
    /// set up everything
    func StartAnimation() {

        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.locations = [0, 0.5, 1, 1] /// adjust this to change the colors' spacing
        gradientLayer.colors = [
            UIColor.white.cgColor,
           /// yellow + orange for gold effect
            greenColor.cgColor,
          UIColor.white.cgColor
        ]
        
        let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnimation.fromValue = CGPoint(x: 2, y: -1) /// extreme top right
        startPointAnimation.toValue = CGPoint(x: 0, y: 1) /// bottom left
        
        let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnimation.fromValue = CGPoint(x: 1, y: 0) /// top right
        endPointAnimation.toValue = CGPoint(x: -1, y: 2) /// extreme bottom left
        
        let animationGroup = CAAnimationGroup() /// group animations together
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = 4
        animationGroup.repeatCount = .infinity /// repeat animation infinitely
        gradientLayer.add(animationGroup, forKey: nil)
        
    }
    func StopAnimation()
    {
        self.layer.mask = nil
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("Unable to deque cell")}
        cell.lbl.text = settingArray[indexPath.row]
       cell.settingImage.image = UIImage(named: settingArray[indexPath.row])!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
        if(indexPath.row == 0)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationListViewController") as? NotificationListViewController
             self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if(indexPath.row == 1)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController
             self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            let dialog = ZAlertView(title: "Logout",
                      message: "Are you sure you want to logout HR?",
                      isOkButtonLeft: false,
                      okButtonText: "Yes",
                      cancelButtonText: "No",
                      okButtonHandler: { (alertView) -> () in
                          alertView.dismissAlertView()
                      
                        UserDefaults.standard.removeObject(forKey: userDefaultVal.EmployeeID)
                      
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                  
                        self.navigationController?.pushViewController(vc!, animated: false)
                      
                      },
                      cancelButtonHandler: { (alertView) -> () in
                          alertView.dismissAlertView()
                       
                      }
                  )
                  dialog.show()
                  dialog.allowTouchOutsideToDismiss = true
        }
    }
    
}
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        alert.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: {(action: UIAlertAction) in
            self.profilePic.image = UIImage(named: "profilePic")
            var req = uploadProfilePictureRequest()
            req.ProfileBase64Img = convertImageToBase64String(img: UIImage(named: "profilePic") ?? UIImage())
              req.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
         
              self.UploadPicture(request: req)
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
          
            self?.profilePic.image = image
          var req = uploadProfilePictureRequest()
            req.ProfileBase64Img = convertImageToBase64String(img: image)
            req.EmployeeID = Int("\(UserDefaults.standard.value(forKey: userDefaultVal.EmployeeID) ?? "0")")
         
            self?.UploadPicture(request: req)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
extension HomeViewController: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        
        Loaf("Notified HR succesfully", state: .success, sender: self).show()
        switch sender.curState {
            case .L: print("left state")
            case .R: print("right state")
        }
    }
}
