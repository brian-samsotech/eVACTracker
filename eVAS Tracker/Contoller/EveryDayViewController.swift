//
//  EveryDayViewController.swift
//  eVAS Tracker
//
//  Created by Brian on 10/4/21.
//

import UIKit

class EveryDayViewController: UIViewController {
    var onError: ((String) -> Void)?
    var onAcceptSignature: ((Bool) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_notGood(_ sender: Any) {
        if (self.onAcceptSignature != nil) {
            self.onAcceptSignature!(false)
        }
    }
    @IBAction func btn_good(_ sender: UIButton) {
        if (self.onAcceptSignature != nil) {
            self.onAcceptSignature!(true)
        }
    }
    @IBAction func btn_close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
