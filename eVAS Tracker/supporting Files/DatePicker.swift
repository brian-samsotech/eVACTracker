//
//  DatePicker.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import Foundation
import UIKit
@IBDesignable
class buttonOptions: UITextField {
    // MARK: - Properties
    
    var shouldEditHandler: ((String) -> Bool)?
    var shouldChangeStringHandler: ((UITextField, NSRange, String) -> Bool)?
    var shouldReturn: ((UITextField) -> Bool)?
    var onEditDone: ((String?) -> Void)?
    var onEditCanceled: (() -> Void)?
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.initialize()
        }
    }
    
    
    
    @IBInspectable var enableShadow: Bool = true {
        didSet {
            self.initialize()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.initialize()
    }
    
   
    func initialize() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: UIColor.lightGray])
     
        
        
        self.loadBorderLayout()
        self.setShadow()
        
        
        
        
    }
    
    func setShadow() {
        if !self.enableShadow {
            self.layer.masksToBounds = true
            return
        }
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        
        /*
         self.layer.shadowOffset = CGSize(width: 0, height: 2)
         let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
         self.layer.shadowPath = shadowPath.cgPath
         self.layer.shadowOpacity = Float(0.5)
         
         */
    }
    
    
    
    // MARK: - Private
    private func loadBorderLayout() {
        if(self.cornerRadius >= 1) {
            self.layer.cornerRadius = self.cornerRadius
        }
        else if(self.cornerRadius > 0) {
            let height = self.layer.bounds.size.height
            self.layer.cornerRadius = height * self.cornerRadius
        }
        else {
            self.layer.cornerRadius = 0
        }
        self.backgroundColor = UIColor.white
        
        
        
        
        layer.masksToBounds = true
        
        
        
    }
}
extension buttonOptions: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (self == textField && (self.shouldChangeStringHandler != nil)) {
            if (!self.shouldChangeStringHandler!(textField, range, string)) {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.onEditDone?(self.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.shouldReturn?(textField) ?? true
    }
}
class OkuraUnderlineDatePickerField: buttonOptions {

    // MARK: - Closure
    
    var onEditStart: ((OkuraUnderlineDatePickerField) -> Void)?
    var onSetDate: ((Date) -> Void)?
    
    // MARK: - Inspectable
    @IBInspectable var setImage: Bool = false
    @IBInspectable var placeholderString: String = ""
    @IBInspectable var isDatePickerMode: Bool = true
    @IBInspectable var dateFormat: String = ""
    @IBInspectable var minToday: Bool = false
    @IBInspectable var maxToday: Bool = false
    
    var isBirthDate: Bool = false
    var minDate: Date? = nil
    var maxDate: Date? = nil
    
    // var clearButton: UIButton? = nil
    
    // MARK: - Properties
    
    var datePickerVC: STDatePickerViewController? = nil
    
    // MARK: - Init
    
    override func initialize() {
        super.initialize()
        self.delegate = self
       
      //  self.addClearButton()
    }
    
    // MARK: - Public
    func load()
    {
        if(setImage == true)
        {
    /*   self.rightViewMode = .always
          let emailImgContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
          let emailImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
          emailImg.image = UIImage(named: "ic_dropdown")
          emailImgContainer.addSubview(emailImg)
          self.rightView = emailImgContainer
            
        */
            let dropMenuImageView = UIImageView()
          
            dropMenuImageView.image = UIImage(named: "ic_dropdown")
           
          //  dropMenuImageView.tintColor = DefaultTheme.primaryColor()
            dropMenuImageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(dropMenuImageView)

            dropMenuImageView.addConstraints(
                [
                    NSLayoutConstraint(
                        item: dropMenuImageView,
                        attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        multiplier: 1,
                        constant: 14),
                    NSLayoutConstraint(
                        item: dropMenuImageView,
                        attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        multiplier: 1,
                        constant: 14)
                ])

            NSLayoutConstraint.activate(
                [
                    dropMenuImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    dropMenuImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
                ])
        }
          self.placeholder = placeholderString
    }
    func showDatePicker() {
        if (self.isDatePickerMode) {
            datePickerVC?.mode = .date
        } else {
            datePickerVC?.mode = .time
        }
        
        let dateHelper = STDateHelper()
        dateHelper.isBirthDate = isBirthDate
        var date = Date()
        
        if let dateInput = self.text {
            if (dateInput.count > 0) {
                date = dateHelper.date(from: dateInput)
            }
        }
        
        if (self.onEditStart != nil) {
            self.onEditStart!(self)
        }
        
        datePickerVC?.delegate = self
        datePickerVC?.attachCustomDatePicker(to: self)
        
        if (self.minToday) {
            datePickerVC?.minDate = Date()
        } else {
            datePickerVC?.minDate = self.minDate
        }
        
        if (self.maxToday) {
            datePickerVC?.maxDate = Date()
        } else {
            datePickerVC?.maxDate = self.maxDate
        }
        
        let currentResponder = UIResponder.self as? UIView
        if (currentResponder != nil) {
            currentResponder?.resignFirstResponder()
            currentResponder?.endEditing(true)
        }
        
        datePickerVC?.view.isHidden = false
        //clearButton?.isHidden = false
        
        if (self.isDatePickerMode) {
            datePickerVC?.show(date)
        } else {
            datePickerVC?.showTime(date)
        }
    }
    
    // MARK: - Private
    
  /*  func addClearButton() {
        
        if (datePickerVC?.viewIfLoaded == nil) {
            return
        }
        
        if (self.clearButton != nil){
            return
        }
        
        self.clearButton = UIButton(type: .custom)
        self.clearButton?.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton?.backgroundColor = UIColor.clear
        self.clearButton?.tintColor = UIColor.blue
        self.clearButton?.setTitle("", for: .normal)
       // self.clearButton?.setImage(DefaultTheme.Icons.clear, for: .normal)
        self.clearButton?.addTarget(self, action: #selector(onClickClearButton), for: .touchUpInside)
        self.datePickerVC?.viewIfLoaded?.addSubview(self.clearButton!)
        
        self.clearButton?.addConstraints([
            NSLayoutConstraint(item: self.clearButton!, attribute: .width, relatedBy: .equal, toItem: self.clearButton, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.clearButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.clearButton, attribute: .trailing, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: self.clearButton!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        self.clearButton?.isHidden = true
        
    }
    */
    // MARK: - Override UITextField Delegate Functions
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        /*
         if(![super textFieldShouldBeginEditing:textField])
         {
             return NO;
         }
         */
        
        self.showDatePicker()
        return false
        
    }
}

extension OkuraUnderlineDatePickerField: STDatePickerDelegate {
    
    func onDatePickerClose() {
        self.datePickerVC?.view.isHidden = true
       // self.clearButton?.isHidden = true
    }
    
    func onUpdateValue(with date: Date!) {
        let dateHelper = STDateHelper()
        var dateString = ""
        
        if (self.dateFormat.count > 0) {
            dateString = dateHelper.convert(date, toFormat: self.dateFormat, timeZone: TimeZone(abbreviation: "UTC")!)
        } else {
            let userDefaults = UserDefaults.standard
            var settingsDateFormat = userDefaults.string(forKey: str_Defaults_DateFormat) ?? ""
            if (settingsDateFormat.count == 0) {
                settingsDateFormat = STDateFormatDisplay
            }
            dateString = dateHelper.convert(date, toFormat: settingsDateFormat)
        }
        
        self.text = dateString
        
        if (self.onEditDone != nil) {
            self.onEditDone!(dateString)
        }
        
        if (self.onSetDate != nil) {
            self.onSetDate!(date)
        }
    }
    
    @objc
    func onClickClearButton() {
        if (self.onEditDone != nil) {
            self.onEditDone!("")
        }
        
        self.text = ""
    }
}

