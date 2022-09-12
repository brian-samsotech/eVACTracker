//
//  OkuraRadioButton.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import Foundation
import UIKit
@IBDesignable
class Button2: UIButton {
    // MARK: - Properties
  
    
    @IBInspectable var iconSpacing: CGFloat = 0.0 {
        didSet {
            self.initialize()
        }
    }
    
    @IBInspectable var iconPadding: CGFloat = 0.0 {
        didSet {
            self.initialize()
        }
    }
    
  @IBInspectable var iconAlignment: String = "default" {
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
    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        self.initialize()
    }
    */
    // MARK: -
    func initialize() {
      
        self.loadIconLayout()
        self.loadBorderLayout()
        self.setShadow()
        
        if let imgView = self.imageView {
            imgView.contentMode = .scaleAspectFit
        }
        
        
   
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
    }
    
    func loadIconLayout() {
        switch self.iconAlignment {
        case "top":
            self.alignIconTop()
            break
        case "trailing":
            self.alignIconTrailing()
            break
            case "leading":
                self.alignIconLeading()
                break
        default:
            //print("default button content alignment.")
            break
        }
    }
  func alignIconTop() {
        guard let imgView = self.imageView else {
            return
        }
        
        guard let buttonName = self.titleLabel else {
            return
        }
        
        let halfSpacing = self.iconSpacing * 0.5
        let imgSize = imgView.bounds.size
        let labelSize = buttonName.frame.size
        let labelHalfHeight = labelSize.height * 0.5
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(labelHalfHeight + halfSpacing),
                                            left: 0,
                                            bottom: 0,
                                            right: -labelSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets(top: imgSize.height + self.iconSpacing,
                                            left: -imgSize.width,
                                            bottom: 0,
                                            right: 0)
        
        self.contentEdgeInsets = UIEdgeInsets(top: self.iconPadding, left: self.iconPadding,
                                              bottom: self.iconPadding, right: self.iconPadding)
    }
    
    func alignIconTrailing() {
        guard let imgView = self.imageView else {
            return
        }
        
        guard let buttonName = self.titleLabel else {
            return
        }
        
        let imgSize = imgView.bounds.size
        let imgWidth = imgSize.width
        let lblSize = buttonName.frame.size
        let lblWidth = lblSize.width
        
        // let lblOffsetX = imgWidth + self.iconSpacing
        
        //self.contentHorizontalAlignment = .right
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: lblWidth + imgWidth + self.iconSpacing,
                                            bottom: 0,
                                            right: -(lblWidth + imgWidth + self.iconSpacing))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgWidth,
                                            bottom: 0, right: 0)
        self.contentEdgeInsets = UIEdgeInsets(top: self.iconPadding, left: self.iconPadding, bottom: self.iconPadding, right: self.iconPadding)
    }

func alignIconLeading() {
        guard let imgView = self.imageView else {
            return
        }
        
        guard let buttonName = self.titleLabel else {
            return
        }
        
        let imgSize = imgView.bounds.size
        let imgWidth = imgSize.width
        let lblSize = buttonName.frame.size
        let lblWidth = lblSize.width
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: lblWidth + imgWidth + self.iconSpacing,
                                            bottom: 0,
                                            right: -(lblWidth + imgWidth + self.iconSpacing))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgWidth,
                                            bottom: 0, right: 0)
        self.contentEdgeInsets = UIEdgeInsets(top: self.iconPadding, left: self.iconPadding, bottom: self.iconPadding, right: self.iconPadding)
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
    self.borderWidth = 1.0
    self.backgroundColor = UIColor.clear
            self.tintColor = UIColor.white
            self.setTitleColor(UIColor.white, for: .normal)
        layer.masksToBounds = true
    }
}
class OkuraRadioButton: Button2 {

    var buttonIcon: UIImageView? = nil
    
    var isChecked: Bool = false {
        didSet {
            refreshIcon()
        }
    }

    override func initialize() {
        super.initialize()
        
        self.backgroundColor = .clear//DefaultTheme.Colors.onPrimary
        self.tintColor = UIColor.black
        self.setTitleColor(UIColor.black, for: .normal)
        
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
        
        if(self.buttonIcon != nil) {
            self.buttonIcon?.tintColor = UIColor.red
            return
        }
     
        self.buttonIcon = UIImageView(image: UIImage(named: "icon_circle_outline"))
        self.buttonIcon?.tintColor = UIColor.black
        self.buttonIcon?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.buttonIcon!)
        
        self.buttonIcon?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.buttonIcon?.topAnchor.constraint(equalTo: self.topAnchor,
                                              constant: 8).isActive = true
        self.buttonIcon?.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                 constant: -8).isActive = true
        self.buttonIcon?.widthAnchor.constraint(equalTo: (self.buttonIcon?.heightAnchor)!,
                                                multiplier: 1).isActive = true
        
        self.setupAlignment()
    }
    
    private func setupAlignment() {
        self.contentHorizontalAlignment = .left
        
        if(self.buttonIcon == nil) {
            return
        }
        
        //let iconHeight = self.buttonIcon?.bounds.size.height ?? 0
        let iconHeight = self.frame.size.height
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: iconHeight * 1.3,
                                            bottom: 0, right: 0)
    }
    
    // MARK: - public
    
    func refreshIcon() {
        if(self.isChecked) {
            self.buttonIcon?.image = UIImage(named: "icon_circle")
        }
        
        else {
            self.buttonIcon?.image = UIImage(named: "icon_circle_outline")
        }
    }
    
    func toggleCheckMark() {
        isChecked = !isChecked
    }
    
}
