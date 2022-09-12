//
//  TableViewCell.swift
//  eVAS Tracker
//
//  Created by Brian on 10/9/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_notification: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
