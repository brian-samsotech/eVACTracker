//
//  Functions.swift
//  eVAS Tracker
//
//  Created by Brian on 10/3/21.
//
import UIKit
import Foundation

let primarycolor = UIColor(red: 102.0/255.0, green: 50.0/255.0, blue: 89.0/255.0, alpha: 1.0)
let greenColor = UIColor(red: 36.0/255.0, green: 99.0/255.0, blue: 42.0/255.0, alpha: 1.0)
let aember = UIColor(red: 207.0/255.0, green: 94.0/255.0, blue: 2.0/255.0, alpha: 1.0)
@IBDesignable
class RoundedCornerView: UIView {

    var cornerRadiusValue : CGFloat = 0
    var corners : UIRectCorner = []

    @IBInspectable public var cornerRadius : CGFloat {
        get {
            return cornerRadiusValue
        }
        set {
            cornerRadiusValue = newValue
        }
    }
    @IBInspectable
    public var borderWidth: CGFloat = 0 {

        didSet {
            layer.borderWidth = borderWidth
            
        }
    }
    @IBInspectable
    public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var topLeft : Bool {
        get {
            return corners.contains(.topLeft)
        }
        set {
            setCorner(newValue: newValue, for: .topLeft)
        }
    }

    @IBInspectable public var topRight : Bool {
        get {
            return corners.contains(.topRight)
        }
        set {
            setCorner(newValue: newValue, for: .topRight)
        }
    }

    @IBInspectable public var bottomLeft : Bool {
        get {
            return corners.contains(.bottomLeft)
        }
        set {
            setCorner(newValue: newValue, for: .bottomLeft)
        }
    }

    @IBInspectable public var bottomRight : Bool {
        get {
            return corners.contains(.bottomRight)
        }
        set {
            setCorner(newValue: newValue, for: .bottomRight)
        }
    }

    func setCorner(newValue: Bool, for corner: UIRectCorner) {
        if newValue {
            addRectCorner(corner: corner)
        } else {
            removeRectCorner(corner: corner)
        }
    }

    func addRectCorner(corner: UIRectCorner) {
        corners.insert(corner)
        updateCorners()
    }

    func removeRectCorner(corner: UIRectCorner) {
        if corners.contains(corner) {
            corners.remove(corner)
            updateCorners()
        }
    }

    func updateCorners() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadiusValue, height: cornerRadiusValue))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }

}
@IBDesignable class CardView: UIView {
    var cornnerRadius : CGFloat = 12
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 2
    
    var shadowColour : UIColor = UIColor.lightGray
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
 //   layer.backgroundColor = UIColor.white.cgColor
       layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = cornnerRadius
     
    }
}
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
@IBDesignable extension UIImageView {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
extension UIView {
  func animateBorderWidth(toValue: CGFloat, duration: Double) {
    let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = layer.borderWidth
    animation.toValue = toValue
    animation.duration = duration
    layer.add(animation, forKey: "drawLineAnimation")
    layer.borderWidth = toValue
   
     
  }
}
public class customtextfiled: UITextField {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutGradientButtonLayer()
    }
    // MARK: Private
    private func layoutGradientButtonLayer() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = primarycolor.cgColor
    }
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
  
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "ic_password_invisible"), for: .normal)
        }else{
            button.setImage(UIImage(named: "ic_password_visible"), for: .normal)

        }
    }

    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
 
}
@IBDesignable class roundCorner: UIView {
    var cornnerRadius : CGFloat = 12
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 2
    
    var shadowColour : UIColor = UIColor.lightGray
    var shadowOpacity : CGFloat = 0.5
    
    override func layoutSubviews() {
 //   layer.backgroundColor = UIColor.white.cgColor
       layer.borderWidth = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = cornnerRadius
     
    }
}
extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

func toDate() -> String
{
    
    let date = Date()
    let formate = DateFormatter()
    formate.dateFormat = "yyyy-MM-dd"
    let formattedDate = formate.string(from: date)
    return "\(formattedDate)"
}
