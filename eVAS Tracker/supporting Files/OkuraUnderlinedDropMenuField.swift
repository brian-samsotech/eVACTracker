//
//  OkuraUnderlinedDropMenuField.swift
//  RegCard
//
//  Created by Brian on 3/28/20.
//  Copyright © 2020 Samsotech. All rights reserved.
//

import UIKit
protocol OkuraFormPageDelegate {
    var nextPage: UIViewController? { get set }
 
    var containerDelegate: OkuraFormContainerDelegate? { get set }
    var lastFieldView: UIView? { get }
    
    func pushNextPage(navigator: UINavigationController)
    func popCurrentPage(navigator: UINavigationController)
    func loadData()
    func cacheData()
    
    func validateForm() -> Bool
}



class OkuraUnderlinedDropMenuField: buttonOptions {

    // MARK: - Closures
    
    var onOpenDropMenu: (([String]) -> Void)?
    
    // MARK: - Inspectables
    @IBInspectable var setImage: Bool = false
    @IBInspectable var placeholderString: String = ""
    @IBInspectable var dbTableName: String = ""
    @IBInspectable var dbTableColName: String = ""
    @IBInspectable var canFilter: Bool = false
   
    // MARK: - Properties
    
    var dropMenuVC: STDropMenuViewController? = nil
    
    private var data: [String] = []
    private var currentText = ""
    
    override func initialize() {
       
        super.initialize()
     
        self.delegate = self
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        
        self.layer.borderColor = primarycolor.cgColor
          if(setImage == true)
          {
        
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
    }

    // MARK: - UI Textfield Delegate
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // if (!super.textfiel) {
        //     return false
        // }
        
        if (self.onOpenDropMenu != nil) {
            self.onOpenDropMenu!(self.data)
        }
        
        if (self.data.count > 0) {
            self.showDropMenu()
        }
        
        return self.canFilter
    }
    func loadDatafromApi(Data:[String])
    {
        self.data = Data
     
          self.placeholder = placeholderString
    }
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        
        let allowedCharacters = CharacterSet(charactersIn:"~`!@#|$%^&*()+=-/:\"\\'{}[]<>^?ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_. ")
        
        let characterSet = CharacterSet(charactersIn: string)
        if(allowedCharacters.isSuperset(of: characterSet) == true)
        {
        
            if (self == textField && (self.shouldChangeStringHandler != nil)) {
                if (!self.shouldChangeStringHandler!(textField, range, string)) {
                    return false
                }
            }
            
            if (self.data.count == 0) {
                //self.dropMenuVC?.view.isHidden = true
                self.dropMenuVC?.reload(withData: [])
                return true
            }
            
        let stringText: NSString = (textField.text ?? "") as NSString
        let newStringText = stringText.replacingCharacters(in: range, with: string)
        
        if (newStringText.count == 0) {
            //self.dropMenuVC?.view.isHidden = false
            self.dropMenuVC?.reload(withData: self.data)
            return true
        }
        
        let filteredData = self.data.filter() {
            let lowercase1 = $0.lowercased()
            let lowercase2 = newStringText.lowercased()
            return lowercase1.contains(lowercase2)
        }
        
        
        
        //let hasNoFilteredData = filteredData.count == 0
        //self.dropMenuVC?.view.isHidden = hasNoFilteredData
        self.dropMenuVC?.reload(withData: filteredData)
        }
        else{
            return false
        }
        return true
    }
    
    // MARK: - Public
    
    func setOptions(_ options: [String]) {
        data = options
        
    }
    
    func loadDefault() {
        if data.count == 0 {
            return
        }
        
        self.text = data.first ?? ""
    }
    
    func insertOption(_ option: String, atIndex index: Int) {
        data.insert(option, at: index)
    }
    
    func removeOption(_ option: String) {
        let removeIndex = data.firstIndex(of: option) ?? -1
        if(removeIndex < 0) {
            return
        }
        data.remove(at: removeIndex)
    }
    
    func loadOptionsFromDB(dataset:[String]) {
        if(setImage == true)
        {
      
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
      
        
        if (self.dbTableName.count == 0 ||
            self.dbTableColName.count == 0) {
            
      
            return
        }
        
        self.data = dataset
        
      
    }
    
    func hideDropMenu() {
        self.dropMenuVC?.view.isHidden = true
        // self.dropMenuVC?.dismiss(animated: false, completion: nil)
    }
    
    func showDropMenu() {
        self.dropMenuVC?.delegate = self
        self.dropMenuVC?.view.isHidden = false
        self.currentText = self.text ?? ""
        
        // TODO: if auto-complete
//        [_clearButton setHidden:NO];
//        [self.dropMenuVC attachToViewTop:self withData:mData];
        
        self.dropMenuVC?.attach(to: self, withData: self.data)
//        let currentResponder = UIResponder.curren
    }
}

extension OkuraUnderlinedDropMenuField: STDropDownDelegate {
    
    func onCloseSTDropMenu() {
        self.resignFirstResponder()
        self.endEditing(true)
        self.dropMenuVC?.view.isHidden = true
        
        let newText = self.text
        
        if (newText == self.currentText) {
            if(self.onEditCanceled != nil) {
                self.onEditCanceled!()
            }
        }
        else if(self.onEditDone != nil) {
            self.onEditDone!(newText)
        }
        
        // self.dropMenuVC?.dismiss(animated: false, completion: nil)
    }
    
    func onSTDropMenuSelect(with index: UInt, andValue value: String!) {
        self.text = value
        if(self.onEditDone != nil) {
            self.onEditDone!(value)
        }
    }
}
protocol OkuraFormContainerDelegate {
    func setDismissKeyboardTapRecognizer(enabled: Bool)
}

extension OkuraFormContainerDelegate {
    func setDismissKeyboardTapRecognizer(enabled: Bool) {}
}

